[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string[]]$Shell = @(),
    [switch]$RequireAllShells
)

$ErrorActionPreference = 'Stop'
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false
[Console]::OutputEncoding = $Utf8NoBom
$OutputEncoding = $Utf8NoBom

if (-not $RepoRoot) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $RepoRoot = (Resolve-Path -LiteralPath (Join-Path $scriptDir '..\..\..')).Path
} else {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
}

$fixtureRoot = Join-Path $RepoRoot 'Scripts\tests\codex-hooks\fixtures'
$hookPath = Join-Path $RepoRoot '.codex\hooks\team-native-gate.ps1'
$hookConfigPath = Join-Path $RepoRoot '.codex\hooks.json'
$sourceHookConfigPath = Join-Path $RepoRoot 'Codex\.codex\hooks.json'

if (-not (Test-Path -LiteralPath $hookPath -PathType Leaf)) {
    throw "Hook script missing: $hookPath"
}
if (-not (Test-Path -LiteralPath $hookConfigPath -PathType Leaf)) {
    throw "Project hook config missing: $hookConfigPath"
}
if (-not (Test-Path -LiteralPath $sourceHookConfigPath -PathType Leaf)) {
    throw "Source hook config missing: $sourceHookConfigPath"
}
if (-not (Test-Path -LiteralPath $fixtureRoot -PathType Container)) {
    throw "Fixture directory missing: $fixtureRoot"
}

$hookConfig = Get-Content -LiteralPath $hookConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
$sourceHookConfig = Get-Content -LiteralPath $sourceHookConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
$requiredEvents = @('UserPromptSubmit', 'PreToolUse', 'PermissionRequest', 'SubagentStart', 'SubagentStop', 'Stop')

function Test-FixtureFileHashEqual {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { return $false }
    if (-not (Test-Path -LiteralPath $TargetPath -PathType Leaf)) { return $false }
    $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $SourcePath).Hash
    $targetHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $TargetPath).Hash
    return ($sourceHash -eq $targetHash)
}

function Get-DecodedHookCommandText {
    param([object]$Handler)

    $texts = New-Object System.Collections.Generic.List[string]
    foreach ($propertyName in @('command', 'commandWindows')) {
        $property = $Handler.PSObject.Properties[$propertyName]
        if ($null -eq $property) { continue }
        $value = [string]$property.Value
        if (-not $value) { continue }
        $texts.Add($value)

        $match = [regex]::Match($value, '(?i)-EncodedCommand\s+([A-Za-z0-9+/=]+)')
        if ($match.Success) {
            try {
                $decoded = [Text.Encoding]::Unicode.GetString([Convert]::FromBase64String($match.Groups[1].Value))
                $texts.Add($decoded)
            } catch {
                $texts.Add("encoded-command-decode-failed: $($_.Exception.Message)")
            }
        }
    }
    return (@($texts.ToArray()) -join "`n")
}

foreach ($requiredEvent in $requiredEvents) {
    if ($null -eq $hookConfig.hooks.PSObject.Properties[$requiredEvent]) {
        throw "Project hook config missing event: $requiredEvent"
    }
    if ($null -eq $sourceHookConfig.hooks.PSObject.Properties[$requiredEvent]) {
        throw "Source hook config missing event: $requiredEvent"
    }
}

if (-not (Test-FixtureFileHashEqual -SourcePath $sourceHookConfigPath -TargetPath $hookConfigPath)) {
    throw "Hook source/deployed config mismatch: Codex\.codex\hooks.json -> .codex\hooks.json"
}
if (-not (Test-FixtureFileHashEqual -SourcePath (Join-Path $RepoRoot 'Codex\.codex\hooks\team-native-gate.ps1') -TargetPath $hookPath)) {
    throw "Hook source/deployed script mismatch: Codex\.codex\hooks\team-native-gate.ps1 -> .codex\hooks\team-native-gate.ps1"
}
Write-Host "[OK] hook source/deployed sync"

foreach ($eventProperty in $hookConfig.hooks.PSObject.Properties) {
    foreach ($group in @($eventProperty.Value)) {
        foreach ($handler in @($group.hooks)) {
            if ($handler.type -ne 'command') {
                throw "Unsupported hook handler type for $($eventProperty.Name): $($handler.type)"
            }
            $commandText = Get-DecodedHookCommandText -Handler $handler
            if ($commandText -notmatch '\.codex[\\\/]hooks[\\\/]team-native-gate\.ps1') {
                throw "Hook handler does not point to team-native-gate.ps1 for $($eventProperty.Name)"
            }
        }
    }
}
Write-Host "[OK] hooks.json"

$fixtures = @(Get-ChildItem -LiteralPath $fixtureRoot -Filter '*.json' -File | Sort-Object Name)
if ($fixtures.Count -eq 0) {
    throw "No hook fixtures found: $fixtureRoot"
}

function Get-FixtureShells {
    param(
        [string[]]$RequestedShells,
        [switch]$RequireAllShells
    )

    if (($null -eq $RequestedShells) -or ($RequestedShells.Count -eq 0)) {
        $RequestedShells = @('powershell', 'pwsh')
    }

    $resolved = New-Object System.Collections.Generic.List[object]
    foreach ($shellName in $RequestedShells) {
        if ([string]::IsNullOrWhiteSpace($shellName)) { continue }
        $shellApplication = Resolve-FixtureShellApplication -ShellName $shellName
        if ($null -eq $shellApplication) {
            $message = "Requested shell is unavailable or not an application path: $shellName"
            if ($RequireAllShells) {
                throw $message
            }
            Write-Warning ("Skipping shell. {0}" -f $message)
            continue
        }

        $resolved.Add($shellApplication)
    }

    if ($resolved.Count -eq 0) {
        throw "No requested shell application path is available for hook fixture execution."
    }

    return @($resolved.ToArray())
}

function Resolve-FixtureShellApplication {
    param([string]$ShellName)

    $trimmedShellName = $ShellName.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmedShellName)) { return $null }

    if (([IO.Path]::IsPathRooted($trimmedShellName)) -or ($trimmedShellName -match '[\\/]')) {
        if (-not (Test-Path -LiteralPath $trimmedShellName -PathType Leaf)) { return $null }
        $resolvedPath = (Resolve-Path -LiteralPath $trimmedShellName).Path
        return [PSCustomObject]@{
            Name  = $ShellName
            Label = Split-Path -Leaf $resolvedPath
            Path  = $resolvedPath
        }
    }

    $candidateNames = New-Object System.Collections.Generic.List[string]
    $candidateNames.Add($trimmedShellName)
    if (-not $trimmedShellName.EndsWith('.exe', [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidateNames.Add(("{0}.exe" -f $trimmedShellName))
    }

    foreach ($candidateName in @($candidateNames.ToArray() | Select-Object -Unique)) {
        $commands = @(Get-Command -Name $candidateName -CommandType Application -All -ErrorAction SilentlyContinue)
        foreach ($command in $commands) {
            $candidatePath = @($command.Source, $command.Path, $command.Definition) |
                Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } |
                Select-Object -First 1
            if (-not $candidatePath) { continue }

            try {
                $resolvedPath = (Resolve-Path -LiteralPath $candidatePath -ErrorAction Stop).Path
            } catch {
                continue
            }
            if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) { continue }

            $label = [string]$command.Name
            if ([string]::IsNullOrWhiteSpace($label)) {
                $label = Split-Path -Leaf $resolvedPath
            }

            return [PSCustomObject]@{
                Name  = $ShellName
                Label = $label
                Path  = $resolvedPath
            }
        }
    }

    return $null
}

function Set-FixtureProcessEncoding {
    param(
        [System.Diagnostics.ProcessStartInfo]$ProcessStartInfo,
        [System.Text.Encoding]$Encoding
    )

    foreach ($propertyName in @('StandardInputEncoding', 'StandardOutputEncoding', 'StandardErrorEncoding')) {
        if ($null -eq $ProcessStartInfo.PSObject.Properties[$propertyName]) { continue }
        try {
            $ProcessStartInfo.$propertyName = $Encoding
        } catch {
            continue
        }
    }
}

$failures = New-Object System.Collections.Generic.List[string]
$tempTranscriptPaths = New-Object System.Collections.Generic.List[string]
$tempHostEvidencePaths = New-Object System.Collections.Generic.List[string]
$fixtureShells = @(Get-FixtureShells -RequestedShells $Shell -RequireAllShells:$RequireAllShells)
$caseCount = 0

try {
foreach ($fixtureShell in $fixtureShells) {
foreach ($fixtureFile in $fixtures) {
    $fixture = Get-Content -LiteralPath $fixtureFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $eventName = [string]$fixture.event
    $expectedExitCode = [int]$fixture.expectedExitCode
    $expectedOutputRegex = [string]$fixture.expectedOutputRegex
    $forbiddenOutputRegex = [string]$fixture.forbiddenOutputRegex
    $expectedDiagnosticLabels = $false
    $expectedDiagnosticLabelsProperty = $fixture.PSObject.Properties['expectedDiagnosticLabels']
    if ($null -ne $expectedDiagnosticLabelsProperty) {
        $expectedDiagnosticLabels = [bool]$expectedDiagnosticLabelsProperty.Value
    }
    if ((-not $expectedOutputRegex) -and (-not $forbiddenOutputRegex)) {
        $forbiddenOutputRegex = '(?i)(permissionDecision.{0,120}deny|behavior.{0,120}deny|decision.{0,120}block)'
    }
    if ($requiredEvents -notcontains $eventName) {
        $failures.Add(("{0}/{1}: fixture event is not registered in hook config: {2}" -f $fixtureShell.Label, $fixtureFile.Name, $eventName))
        continue
    }

    $transcriptTextProperty = $fixture.PSObject.Properties['transcriptText']
    if ($null -ne $transcriptTextProperty) {
        $payloadProperty = $fixture.PSObject.Properties['payload']
        if ($null -eq $payloadProperty) {
            $failures.Add(("{0}/{1}: transcriptText requires a payload object" -f $fixtureShell.Label, $fixtureFile.Name))
            continue
        }

        $safeShellLabel = $fixtureShell.Label -replace '[^A-Za-z0-9_.-]', '_'
        $tempTranscriptPath = Join-Path ([IO.Path]::GetTempPath()) ("codex-hook-fixture-{0}-{1}-{2}.txt" -f $safeShellLabel, $PID, ([IO.Path]::GetRandomFileName()))
        Set-Content -LiteralPath $tempTranscriptPath -Value ([string]$transcriptTextProperty.Value) -Encoding UTF8
        $tempTranscriptPaths.Add($tempTranscriptPath)
        $fixture.payload | Add-Member -NotePropertyName 'transcript_path' -NotePropertyValue $tempTranscriptPath -Force
    }

    $rawInputProperty = $fixture.PSObject.Properties['rawInput']
    if ($null -ne $rawInputProperty) {
        $inputText = [string]$rawInputProperty.Value
    } else {
        $inputText = $fixture.payload | ConvertTo-Json -Depth 20 -Compress
    }

    $hostEvidenceJson = $null
    $hostEvidencePath = $null
    $hostEvidenceProperty = $fixture.PSObject.Properties['hostVerifiedToolLayerEvidence']
    if ($null -ne $hostEvidenceProperty) {
        $hostEvidenceJson = $hostEvidenceProperty.Value | ConvertTo-Json -Depth 20 -Compress
        if ($hostEvidenceJson.Length -gt 30000) {
            $safeShellLabel = $fixtureShell.Label -replace '[^A-Za-z0-9_.-]', '_'
            $hostEvidencePath = Join-Path ([IO.Path]::GetTempPath()) ("codex-hook-host-evidence-{0}-{1}-{2}.json" -f $safeShellLabel, $PID, ([IO.Path]::GetRandomFileName()))
            Set-Content -LiteralPath $hostEvidencePath -Value $hostEvidenceJson -Encoding UTF8
            $tempHostEvidencePaths.Add($hostEvidencePath)
            $hostEvidenceJson = $null
        }
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $fixtureShell.Path
    $psi.Arguments = ('-NoProfile -ExecutionPolicy Bypass -File "{0}" -Event "{1}"' -f $hookPath, $eventName)
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.EnvironmentVariables.Remove('CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_JSON')
    $psi.EnvironmentVariables.Remove('CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_PATH')
    if (-not [string]::IsNullOrWhiteSpace($hostEvidenceJson)) {
        $psi.EnvironmentVariables['CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_JSON'] = $hostEvidenceJson
    }
    if (-not [string]::IsNullOrWhiteSpace($hostEvidencePath)) {
        $psi.EnvironmentVariables['CODEX_HOOK_HOST_VERIFIED_TOOL_LAYER_EVIDENCE_PATH'] = $hostEvidencePath
    }
    Set-FixtureProcessEncoding -ProcessStartInfo $psi -Encoding $Utf8NoBom
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    $null = $process.Start()
    $caseCount++
    $process.StandardInput.Write($inputText)
    $process.StandardInput.Close()
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    $actualExitCode = $process.ExitCode
    $outputText = ($stdout + "`n" + $stderr).Trim()

    if ($actualExitCode -ne $expectedExitCode) {
        $failures.Add(("{0}/{1}: expected exit {2}, got {3}" -f $fixtureShell.Label, $fixtureFile.Name, $expectedExitCode, $actualExitCode))
        continue
    }

    if ($expectedOutputRegex -and ($outputText -notmatch $expectedOutputRegex)) {
        $failures.Add(("{0}/{1}: output did not match /{2}/. Output: {3}" -f $fixtureShell.Label, $fixtureFile.Name, $expectedOutputRegex, $outputText))
        continue
    }
    if ($forbiddenOutputRegex -and ($outputText -match $forbiddenOutputRegex)) {
        $failures.Add(("{0}/{1}: output matched forbidden /{2}/. Output: {3}" -f $fixtureShell.Label, $fixtureFile.Name, $forbiddenOutputRegex, $outputText))
        continue
    }
    if ($expectedDiagnosticLabels) {
        $diagnosticLabels = @(
            'Governance hard gate hit',
            'Block type:',
            'Current action:',
            'Blocked action:',
            'Reason code:',
            'Reason:',
            'Missing structured fields:',
            'Missing evidence categories:',
            'Trusted fields:',
            'Untrusted fields:',
            'Missing evidence',
            'Allowed next steps:',
            'Forbidden next steps:',
            'Minimum unblock conditions:'
        )
        $caseMissingDiagnosticLabel = $false
        foreach ($diagnosticLabel in $diagnosticLabels) {
            if ($outputText -notmatch [regex]::Escape($diagnosticLabel)) {
                $failures.Add(("{0}/{1}: output missing diagnostic label /{2}/. Output: {3}" -f $fixtureShell.Label, $fixtureFile.Name, $diagnosticLabel, $outputText))
                $caseMissingDiagnosticLabel = $true
                break
            }
        }
        if ($caseMissingDiagnosticLabel) { continue }
    }

    Write-Host ("[OK] {0} {1}" -f $fixtureShell.Label, $fixtureFile.Name)
}
}
} finally {
    foreach ($tempTranscriptPath in @($tempTranscriptPaths.ToArray())) {
        if (Test-Path -LiteralPath $tempTranscriptPath -PathType Leaf) {
            Remove-Item -LiteralPath $tempTranscriptPath -Force
        }
    }
    foreach ($tempHostEvidencePath in @($tempHostEvidencePaths.ToArray())) {
        if (Test-Path -LiteralPath $tempHostEvidencePath -PathType Leaf) {
            Remove-Item -LiteralPath $tempHostEvidencePath -Force
        }
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Host ("[FAIL] {0}" -f $failure) -ForegroundColor Red
    }
    exit 1
}

Write-Host ("Codex hook fixtures passed: {0} fixtures x {1} shells = {2} cases" -f $fixtures.Count, $fixtureShells.Count, $caseCount)
exit 0
