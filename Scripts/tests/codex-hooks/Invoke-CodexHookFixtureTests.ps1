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
                ExpectedOutputRegex = 'advisory/reminder.*請先停止這次工具呼叫.*不要直接替隊員完成.*single-file-readonly'
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
$fixtures = Get-ChildItem -LiteralPath $FixturesRoot -Filter '*.json' -File | Sort-Object Name
$failures = New-Object System.Collections.Generic.List[string]

foreach ($fixtureFile in $fixtures) {
    $fixture = Get-Content -LiteralPath $fixtureFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
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

Write-Host ("Codex hook fixtures passed: {0} fixture(s), {1} shell(s)" -f $fixtures.Count, $shells.Count)
