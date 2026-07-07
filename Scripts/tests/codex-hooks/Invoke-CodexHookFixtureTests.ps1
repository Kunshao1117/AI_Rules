param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path,
    [string]$FixturesRoot = (Join-Path $PSScriptRoot 'fixtures'),
    [string]$HookScript = (Join-Path $RepoRoot 'Codex\.codex\hooks\team-native-gate.ps1'),
    [string[]]$Shell,
    [switch]$RequireAllShells,
    [switch]$VerifyRuntimeSync,
    [switch]$SkipHostWrapper
)

$ErrorActionPreference = 'Stop'

function Resolve-FixtureShellApplication {
    param([string]$Name)
    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        return [PSCustomObject]@{ Name = $Name; Path = $null; Available = $false; Reason = 'not found' }
    }
    if ($command.CommandType -ne [System.Management.Automation.CommandTypes]::Application) {
        return [PSCustomObject]@{ Name = $Name; Path = $null; Available = $false; Reason = 'not an application path' }
    }
    return [PSCustomObject]@{ Name = $Name; Path = $command.Source; Available = $true; Reason = 'CommandType Application' }
}

function Get-FixtureShells {
    param([string[]]$Requested)
    $names = if ($Requested -and $Requested.Count -gt 0) { $Requested } else { @('pwsh','powershell') }
    $resolved = @()
    foreach ($name in $names) {
        $shell = Resolve-FixtureShellApplication -Name $name
        if (-not $shell.Available) {
            $message = "Skipping shell {0}: {1}" -f $name, $shell.Reason
            if ($RequireAllShells) { throw $message }
            Write-Host $message
            continue
        }
        $resolved += $shell
    }
    if ($resolved.Count -eq 0) { throw 'No fixture shell application is available.' }
    return $resolved
}

function Test-FixtureFileHashEqual {
    param([string]$SourcePath, [string]$TargetPath)
    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { return $false }
    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) { return $false }
    $left = (Get-FileHash -LiteralPath $SourcePath -Algorithm SHA256).Hash
    $right = (Get-FileHash -LiteralPath $TargetPath -Algorithm SHA256).Hash
    return ($left -eq $right)
}

function Test-FixtureHookConfigDisabled {
    param([object]$HookConfig)
    if ($null -eq $HookConfig) { return $false }
    $lifecycle = $HookConfig.PSObject.Properties['x_ai_rules_hooks_lifecycle']
    if ($null -eq $lifecycle -or $null -eq $lifecycle.Value) { return $false }
    $state = $lifecycle.Value.PSObject.Properties['state']
    return ($null -ne $state -and [string]$state.Value -eq 'disabled')
}

function Get-FixtureFiles {
    param([string]$FixturesRoot)
    Get-ChildItem -LiteralPath $FixturesRoot -Filter '*.json' -File |
        Where-Object { $_.Name -ne 'manifest.json' } |
        Sort-Object Name
}

function Read-FixtureManifest {
    param([string]$FixturesRoot)
    $manifestPath = Join-Path $FixturesRoot 'manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { return $null }
    return (Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop)
}

function Test-FixtureManifestContract {
    param([string]$FixturesRoot, [object]$Manifest, [System.Collections.Generic.List[string]]$Failures)
    if ($null -eq $Manifest) { return }
    $requiredProperty = $Manifest.PSObject.Properties['requiredFixtures']
    if ($null -eq $requiredProperty) {
        $Failures.Add('manifest.json must define requiredFixtures.')
        return
    }
    foreach ($entry in @($requiredProperty.Value)) {
        $file = [string]$entry.file
        if ([string]::IsNullOrWhiteSpace($file)) {
            $Failures.Add('manifest.json has a required fixture entry without file.')
            continue
        }
        $fixturePath = Join-Path $FixturesRoot $file
        if (-not (Test-Path -LiteralPath $fixturePath -PathType Leaf)) {
            $Failures.Add(('manifest.json required fixture is missing: {0}' -f $file))
            continue
        }
        $fixture = Get-Content -LiteralPath $fixturePath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        if ($entry.PSObject.Properties['canonicalDecision'] -and $fixture.PSObject.Properties['canonicalDecision']) {
            if ([string]$entry.canonicalDecision -ne [string]$fixture.canonicalDecision) {
                $Failures.Add(('{0} manifest canonicalDecision {1} conflicts with fixture canonicalDecision {2}.' -f $file, $entry.canonicalDecision, $fixture.canonicalDecision))
            }
        }
    }
}

function ConvertTo-FixtureInputJson {
    param([object]$Fixture, [System.Collections.Generic.List[string]]$CleanupPaths)
    if ($Fixture.PSObject.Properties['rawInput']) { return [string]$Fixture.rawInput }
    $inputObject = if ($Fixture.PSObject.Properties['input']) {
        $Fixture.input | ConvertTo-Json -Depth 64 | ConvertFrom-Json
    } else {
        [PSCustomObject]@{}
    }
    if ($Fixture.PSObject.Properties['transcriptText']) {
        $tempTranscript = Join-Path ([IO.Path]::GetTempPath()) ('codex-hook-transcript-{0}.txt' -f ([guid]::NewGuid().ToString('N')))
        Set-Content -LiteralPath $tempTranscript -Value ([string]$Fixture.transcriptText) -Encoding UTF8
        $CleanupPaths.Add($tempTranscript)
        $inputObject | Add-Member -NotePropertyName 'transcript_path' -NotePropertyValue $tempTranscript -Force
    }
    if ($Fixture.PSObject.Properties['hostVerifiedToolLayerEvidence'] -and -not $Fixture.PSObject.Properties['hostEvidenceTransport']) {
        $inputObject | Add-Member -NotePropertyName 'hostVerifiedToolLayerEvidence' -NotePropertyValue $Fixture.hostVerifiedToolLayerEvidence -Force
    }
    return ($inputObject | ConvertTo-Json -Depth 64 -Compress)
}

function Invoke-FixtureHook {
    param([object]$ShellInfo, [string]$InputJson, [object]$Fixture, [System.Collections.Generic.List[string]]$CleanupPaths)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $ShellInfo.Path
    $psi.ArgumentList.Add('-NoProfile')
    $psi.ArgumentList.Add('-ExecutionPolicy')
    $psi.ArgumentList.Add('Bypass')
    $psi.ArgumentList.Add('-File')
    $psi.ArgumentList.Add($HookScript)
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    if ($Fixture.PSObject.Properties['hostVerifiedToolLayerEvidence'] -and $Fixture.PSObject.Properties['hostEvidenceTransport']) {
        $evidenceJson = $Fixture.hostVerifiedToolLayerEvidence | ConvertTo-Json -Depth 64 -Compress
        if ($Fixture.hostEvidenceTransport -eq 'envPath') {
            $tempEvidence = Join-Path ([IO.Path]::GetTempPath()) ('codex-hook-host-evidence-{0}.json' -f ([guid]::NewGuid().ToString('N')))
            Set-Content -LiteralPath $tempEvidence -Value $evidenceJson -Encoding UTF8
            $CleanupPaths.Add($tempEvidence)
            $psi.Environment['CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_PATH'] = $tempEvidence
        } else {
            $psi.Environment['CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_JSON'] = $evidenceJson
        }
    }
    $process = [System.Diagnostics.Process]::Start($psi)
    $process.StandardInput.Write($InputJson)
    $process.StandardInput.Close()
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    return [PSCustomObject]@{ Stdout = $stdout; Stderr = $stderr; ExitCode = $process.ExitCode }
}

function Get-FixtureEffectiveDecision {
    param([object]$ParsedOutput)
    $hookSpecific = $ParsedOutput.PSObject.Properties['hookSpecificOutput']
    if ($null -ne $hookSpecific) {
        $permissionDecision = $hookSpecific.Value.PSObject.Properties['permissionDecision']
        if ($null -ne $permissionDecision -and [string]$permissionDecision.Value -ne '') {
            return [string]$permissionDecision.Value
        }
    }
    $decision = $ParsedOutput.PSObject.Properties['decision']
    if ($null -ne $decision -and [string]$decision.Value -ne '') {
        if ([string]$decision.Value -eq 'approve') { return 'allow' }
        return [string]$decision.Value
    }
    $continue = $ParsedOutput.PSObject.Properties['continue']
    if ($null -ne $continue -and [bool]$continue.Value -eq $false) { return 'block' }
    return 'allow'
}

function Get-FixtureCanonicalDecision {
    param([object]$Fixture)
    if ($Fixture.PSObject.Properties['canonicalDecision'] -and -not [string]::IsNullOrWhiteSpace([string]$Fixture.canonicalDecision)) {
        return [string]$Fixture.canonicalDecision
    }
    return ''
}

function Test-FixtureCanonicalDecisionContract {
    param([string]$CaseName, [object]$Fixture, [System.Collections.Generic.List[string]]$Failures)
    $canonicalDecision = Get-FixtureCanonicalDecision -Fixture $Fixture
    if (@('allow','advisory','deny','block') -notcontains $canonicalDecision) {
        $Failures.Add(('{0} must define canonicalDecision as allow, advisory, deny, or block.' -f $CaseName))
        return
    }
    if ($Fixture.PSObject.Properties['expectedDecision']) {
        $expectedDecision = [string]$Fixture.expectedDecision
        $expectedFromCanonical = if (@('allow','advisory') -contains $canonicalDecision) { 'allow' } else { $canonicalDecision }
        if ($expectedDecision -ne $expectedFromCanonical) {
            $Failures.Add(('{0} canonicalDecision {1} conflicts with expectedDecision {2}; expectedDecision should be {3}.' -f $CaseName, $canonicalDecision, $expectedDecision, $expectedFromCanonical))
        }
    }
}

function Get-FixtureTrackingState {
    param([string]$RepoRoot, [string]$Path)
    $relative = [IO.Path]::GetRelativePath($RepoRoot, $Path) -replace '\\', '/'
    $output = @(& git -C $RepoRoot ls-files -- $relative 2>$null)
    if ($LASTEXITCODE -ne 0) { return 'untracked' }
    if (($output | ForEach-Object { $_ -replace '\\', '/' } | Where-Object { $_ -eq $relative }).Count -gt 0) { return 'tracked' }
    return 'untracked'
}

function Test-FixturePreToolPermissionDecisionContract {
    param([string]$CaseName, [object]$ParsedOutput, [string]$ExpectedDecision, [System.Collections.Generic.List[string]]$Failures)
    $hookSpecific = $ParsedOutput.PSObject.Properties['hookSpecificOutput']
    if ($null -eq $hookSpecific) { return }
    $eventName = $hookSpecific.Value.PSObject.Properties['hookEventName']
    if ($null -eq $eventName -or [string]$eventName.Value -ne 'PreToolUse') { return }
    $permissionDecision = $hookSpecific.Value.PSObject.Properties['permissionDecision']
    $expectsDeny = @('deny','block') -contains [string]$ExpectedDecision
    if ($expectsDeny) {
        if ($null -eq $permissionDecision -or [string]$permissionDecision.Value -eq '') {
            $Failures.Add(('{0} must emit hookSpecificOutput.permissionDecision for deny/block PreToolUse output.' -f $CaseName))
        }
        $reason = $hookSpecific.Value.PSObject.Properties['permissionDecisionReason']
        if ($null -eq $reason -or [string]$reason.Value -eq '') {
            $Failures.Add(('{0} must emit hookSpecificOutput.permissionDecisionReason for deny/block PreToolUse output.' -f $CaseName))
        }
        return
    }
    if ($null -ne $permissionDecision) {
        $Failures.Add(('{0} must not emit hookSpecificOutput.permissionDecision for allow/advisory PreToolUse output.' -f $CaseName))
    }
}

function Test-FixtureStopOutputContract {
    param([string]$CaseName, [object]$Fixture, [object]$ParsedOutput, [string]$ExpectedDecision, [System.Collections.Generic.List[string]]$Failures)
    $eventName = $null
    if ($Fixture.PSObject.Properties['input'] -and $Fixture.input.PSObject.Properties['hook_event_name']) {
        $eventName = [string]$Fixture.input.hook_event_name
    }
    if ($eventName -ne 'Stop') { return }

    if ($ParsedOutput.PSObject.Properties['hookSpecificOutput']) {
        $Failures.Add(('{0} must not emit hookSpecificOutput for Stop output; Codex Stop supports common output fields plus decision/reason only.' -f $CaseName))
    }

    $expectsBlock = @('deny','block') -contains [string]$ExpectedDecision
    $decision = $ParsedOutput.PSObject.Properties['decision']
    $reason = $ParsedOutput.PSObject.Properties['reason']
    if ($expectsBlock) {
        if ($null -eq $decision -or [string]$decision.Value -ne 'block') {
            $Failures.Add(('{0} Stop block output must emit top-level decision: block.' -f $CaseName))
        }
        if ($null -eq $reason -or [string]$reason.Value -eq '') {
            $Failures.Add(('{0} Stop block output must emit top-level reason.' -f $CaseName))
        }
    } elseif ($null -ne $decision -and [string]$decision.Value -eq 'block') {
        $Failures.Add(('{0} Stop allow output must not emit decision: block.' -f $CaseName))
    }
}

function Get-FixtureCommandWindowsHook {
    param([object]$HookConfig, [string]$EventName)
    $eventProperty = $HookConfig.hooks.PSObject.Properties[$EventName]
    if ($null -eq $eventProperty) { throw ("hooks.json missing event {0}" -f $EventName) }
    foreach ($entry in @($eventProperty.Value)) {
        foreach ($hook in @($entry.hooks)) {
            if ([string]$hook.type -eq 'command' -and [string]$hook.commandWindows -ne '') {
                return [string]$hook.commandWindows
            }
        }
    }
    throw ("hooks.json missing commandWindows hook for {0}" -f $EventName)
}

function Invoke-FixtureCommandWindowsHook {
    param([object]$CmdInfo, [string]$CommandLine, [string]$InputJson, [string]$WorkingDirectory)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $CmdInfo.Path
    $psi.ArgumentList.Add('/d')
    $psi.ArgumentList.Add('/s')
    $psi.ArgumentList.Add('/c')
    $psi.ArgumentList.Add($CommandLine)
    $psi.WorkingDirectory = $WorkingDirectory
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $process = [System.Diagnostics.Process]::Start($psi)
    $process.StandardInput.Write($InputJson)
    $process.StandardInput.Close()
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    return [PSCustomObject]@{ Stdout = $stdout; Stderr = $stderr; ExitCode = $process.ExitCode }
}

function Test-FixtureCommandWindowsWrappers {
    param([string]$RepoRoot, [System.Collections.Generic.List[string]]$Failures)
    $cmdInfo = Resolve-FixtureShellApplication -Name 'cmd.exe'
    if (-not $cmdInfo.Available) {
        Write-Host ("Skipping commandWindows host-wrapper checks: {0}" -f $cmdInfo.Reason)
        return
    }

    $hookConfig = Get-Content -LiteralPath (Join-Path $RepoRoot 'Codex\.codex\hooks.json') -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
    if (Test-FixtureHookConfigDisabled -HookConfig $hookConfig) {
        Write-Host 'commandWindows host-wrapper checks skipped: hooks runtime disabled by lifecycle marker'
        return
    }
    $tempRoot = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path
    $tempNonRepo = Join-Path $tempRoot ('codex-hook-nonrepo-{0}' -f ([guid]::NewGuid().ToString('N')))
    New-Item -ItemType Directory -Path $tempNonRepo | Out-Null

    try {
        $cases = @(
            [PSCustomObject]@{
                Name = 'commandWindows-session-repo-root'
                Event = 'SessionStart'
                WorkingDirectory = $RepoRoot
                Input = [ordered]@{ hook_event_name = 'SessionStart'; cwd = $RepoRoot; source = 'startup' }
                ExpectedOutputRegex = 'advisory/reminder'
                ExpectedUtf8Text = '團隊模式提醒'
            },
            [PSCustomObject]@{
                Name = 'commandWindows-pretool-nonrepo-host-cwd'
                Event = 'PreToolUse'
                WorkingDirectory = $tempNonRepo
                Input = [ordered]@{ hook_event_name = 'PreToolUse'; cwd = $RepoRoot; tool_name = 'Bash'; tool_input = [ordered]@{ command = 'git diff -- Codex/.codex/hooks.json' } }
                ExpectedDecision = 'allow'
                ExpectedOutputRegex = 'advisory/reminder.*禁止隊長直接產生 broad read / validation / review / external research / memory-docs / completion evidence.*允許隊長做 coordination.*named-file local_probe.*direct_exception 只能降級成 partial / unverified / closed-with-director-risk.*single-file-readonly'
            },
            [PSCustomObject]@{
                Name = 'commandWindows-missing-script-nonrepo-cwd'
                Event = 'PreToolUse'
                WorkingDirectory = $tempNonRepo
                Input = [ordered]@{ hook_event_name = 'PreToolUse'; cwd = $tempNonRepo; tool_name = 'Bash'; tool_input = [ordered]@{ command = 'rg --files' } }
                ExpectedDecision = 'allow'
                ExpectedOutputRegex = 'hook script was not found|advisory/reminder'
            }
        )

        $passed = 0
        foreach ($case in $cases) {
            $commandLine = Get-FixtureCommandWindowsHook -HookConfig $hookConfig -EventName $case.Event
            $inputJson = $case.Input | ConvertTo-Json -Depth 64 -Compress
            $result = Invoke-FixtureCommandWindowsHook -CmdInfo $cmdInfo -CommandLine $commandLine -InputJson $inputJson -WorkingDirectory $case.WorkingDirectory
            $output = $result.Stdout.Trim()
            if ($result.ExitCode -ne 0) {
                $failures.Add(('{0} [commandWindows] exit {1}: {2}' -f $case.Name, $result.ExitCode, $result.Stderr))
                continue
            }
            $parsed = $null
            try { $parsed = $output | ConvertFrom-Json -ErrorAction Stop } catch {
                $failures.Add(('{0} [commandWindows] output was not JSON: {1}' -f $case.Name, $output))
                continue
            }
            Test-FixturePreToolPermissionDecisionContract -CaseName ('{0} [commandWindows]' -f $case.Name) -ParsedOutput $parsed -ExpectedDecision ([string]$case.ExpectedDecision) -Failures $failures
            if ($output -notmatch [string]$case.ExpectedOutputRegex) {
                $failures.Add(('{0} [commandWindows] expectedOutputRegex missed: {1}. Output: {2}' -f $case.Name, $case.ExpectedOutputRegex, $output))
            }
            if ($case.PSObject.Properties['ExpectedUtf8Text'] -and -not $output.Contains([string]$case.ExpectedUtf8Text)) {
                $failures.Add(('{0} [commandWindows] expected UTF-8 decoded stdout text missing: {1}. Output: {2}' -f $case.Name, $case.ExpectedUtf8Text, $output))
            }
            $passed++
        }
        Write-Host ("commandWindows host-wrapper checks passed: {0} case(s)" -f $passed)
    } finally {
        $resolvedTemp = Resolve-Path -LiteralPath $tempNonRepo -ErrorAction SilentlyContinue
        if ($null -ne $resolvedTemp) {
            $resolvedTempPath = $resolvedTemp.Path
            if ($resolvedTempPath.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
                Remove-Item -LiteralPath $resolvedTempPath -Recurse -Force
            }
        }
    }
}

if ($VerifyRuntimeSync) {
    if (-not (Test-FixtureFileHashEqual -SourcePath (Join-Path $RepoRoot 'Codex\.codex\hooks.json') -TargetPath (Join-Path $RepoRoot '.codex\hooks.json'))) {
        throw 'hook source/deployed sync failed: hooks.json hash mismatch'
    }
    if (-not (Test-FixtureFileHashEqual -SourcePath (Join-Path $RepoRoot 'Codex\.codex\hooks\team-native-gate.ps1') -TargetPath (Join-Path $RepoRoot '.codex\hooks\team-native-gate.ps1'))) {
        throw 'hook source/deployed sync failed: team-native-gate.ps1 hash mismatch'
    }
    Write-Host 'hook source/deployed sync verified'
}

$shells = Get-FixtureShells -Requested $Shell
$manifest = Read-FixtureManifest -FixturesRoot $FixturesRoot
$fixtures = Get-FixtureFiles -FixturesRoot $FixturesRoot
$failures = New-Object System.Collections.Generic.List[string]
$trackedFixtureCount = 0
$untrackedFixtureCount = 0

Test-FixtureManifestContract -FixturesRoot $FixturesRoot -Manifest $manifest -Failures $failures

foreach ($fixtureFile in $fixtures) {
    $fixture = Get-Content -LiteralPath $fixtureFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
    $trackingState = Get-FixtureTrackingState -RepoRoot $RepoRoot -Path $fixtureFile.FullName
    if ($trackingState -eq 'tracked') { $trackedFixtureCount++ } else { $untrackedFixtureCount++ }
    Test-FixtureCanonicalDecisionContract -CaseName $fixtureFile.Name -Fixture $fixture -Failures $failures
    foreach ($shellInfo in $shells) {
        $cleanup = New-Object System.Collections.Generic.List[string]
        try {
            $inputJson = ConvertTo-FixtureInputJson -Fixture $fixture -CleanupPaths $cleanup
            $result = Invoke-FixtureHook -ShellInfo $shellInfo -InputJson $inputJson -Fixture $fixture -CleanupPaths $cleanup
            $output = $result.Stdout.Trim()
            if ($result.ExitCode -ne 0) {
                $failures.Add(('{0} [{1}] exit {2}: {3}' -f $fixtureFile.Name, $shellInfo.Name, $result.ExitCode, $result.Stderr))
                continue
            }
            $parsed = $null
            try { $parsed = $output | ConvertFrom-Json -ErrorAction Stop } catch {
                $failures.Add(('{0} [{1}] output was not JSON: {2}' -f $fixtureFile.Name, $shellInfo.Name, $output))
                continue
            }
            Test-FixturePreToolPermissionDecisionContract -CaseName ('{0} [{1}]' -f $fixtureFile.Name, $shellInfo.Name) -ParsedOutput $parsed -ExpectedDecision ([string]$fixture.expectedDecision) -Failures $failures
            Test-FixtureStopOutputContract -CaseName ('{0} [{1}]' -f $fixtureFile.Name, $shellInfo.Name) -Fixture $fixture -ParsedOutput $parsed -ExpectedDecision ([string]$fixture.expectedDecision) -Failures $failures
            if ($fixture.PSObject.Properties['expectedDecision']) {
                $effectiveDecision = Get-FixtureEffectiveDecision -ParsedOutput $parsed
                if ([string]$effectiveDecision -ne [string]$fixture.expectedDecision) {
                    $failures.Add(('{0} [{1}] expected decision {2}, got {3}. Output: {4}' -f $fixtureFile.Name, $shellInfo.Name, $fixture.expectedDecision, $effectiveDecision, $output))
                }
            }
            if ($fixture.PSObject.Properties['expectedOutputRegex']) {
                if ($output -notmatch [string]$fixture.expectedOutputRegex) {
                    $failures.Add(('{0} [{1}] expectedOutputRegex missed: {2}. Output: {3}' -f $fixtureFile.Name, $shellInfo.Name, $fixture.expectedOutputRegex, $output))
                }
            }
            if ($fixture.PSObject.Properties['expectedReasonCodeRegex']) {
                if ($output -notmatch [string]$fixture.expectedReasonCodeRegex) {
                    $failures.Add(('{0} [{1}] expectedReasonCodeRegex missed: {2}. Output: {3}' -f $fixtureFile.Name, $shellInfo.Name, $fixture.expectedReasonCodeRegex, $output))
                }
            }
            if ($fixture.PSObject.Properties['expectedDiagnosticLabels'] -and [bool]$fixture.expectedDiagnosticLabels) {
                foreach ($label in @('Governance reminder only','Block type:','Reason code:','Missing structured fields:','Allowed next steps','Forbidden next steps')) {
                    if ($output -notmatch [regex]::Escape($label)) {
                        $failures.Add(('{0} [{1}] missing diagnostic label {2}. Output: {3}' -f $fixtureFile.Name, $shellInfo.Name, $label, $output))
                    }
                }
            }
        } finally {
            foreach ($path in $cleanup) {
                Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

if (-not $SkipHostWrapper) {
    Test-FixtureCommandWindowsWrappers -RepoRoot $RepoRoot -Failures $failures
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    throw ("Codex hook fixture failures: {0}" -f $failures.Count)
}

Write-Host ("Codex hook fixture tracking: {0} tracked, {1} untracked" -f $trackedFixtureCount, $untrackedFixtureCount)
Write-Host ("Codex hook fixtures passed: {0} fixture(s), {1} shell(s)" -f $fixtures.Count, $shells.Count)
