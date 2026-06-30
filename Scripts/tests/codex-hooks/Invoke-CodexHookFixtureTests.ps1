[CmdletBinding()]
param(
    [string]$RepoRoot
)

$ErrorActionPreference = 'Stop'

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

$failures = New-Object System.Collections.Generic.List[string]
$tempTranscriptPaths = New-Object System.Collections.Generic.List[string]

try {
foreach ($fixtureFile in $fixtures) {
    $fixture = Get-Content -LiteralPath $fixtureFile.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $eventName = [string]$fixture.event
    $expectedExitCode = [int]$fixture.expectedExitCode
    $expectedOutputRegex = [string]$fixture.expectedOutputRegex
    $forbiddenOutputRegex = [string]$fixture.forbiddenOutputRegex
    if ((-not $expectedOutputRegex) -and (-not $forbiddenOutputRegex)) {
        $forbiddenOutputRegex = '(?i)(permissionDecision.{0,120}deny|behavior.{0,120}deny|decision.{0,120}block)'
    }
    if ($requiredEvents -notcontains $eventName) {
        $failures.Add(("{0}: fixture event is not registered in hook config: {1}" -f $fixtureFile.Name, $eventName))
        continue
    }

    $transcriptTextProperty = $fixture.PSObject.Properties['transcriptText']
    if ($null -ne $transcriptTextProperty) {
        $payloadProperty = $fixture.PSObject.Properties['payload']
        if ($null -eq $payloadProperty) {
            $failures.Add(("{0}: transcriptText requires a payload object" -f $fixtureFile.Name))
            continue
        }

        $tempTranscriptPath = Join-Path ([IO.Path]::GetTempPath()) ("codex-hook-fixture-{0}-{1}.txt" -f $PID, ([IO.Path]::GetRandomFileName()))
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

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell'
    $psi.Arguments = ('-NoProfile -ExecutionPolicy Bypass -File "{0}" -Event "{1}"' -f $hookPath, $eventName)
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    $null = $process.Start()
    $process.StandardInput.Write($inputText)
    $process.StandardInput.Close()
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    $actualExitCode = $process.ExitCode
    $outputText = ($stdout + "`n" + $stderr).Trim()

    if ($actualExitCode -ne $expectedExitCode) {
        $failures.Add(("{0}: expected exit {1}, got {2}" -f $fixtureFile.Name, $expectedExitCode, $actualExitCode))
        continue
    }

    if ($expectedOutputRegex -and ($outputText -notmatch $expectedOutputRegex)) {
        $failures.Add(("{0}: output did not match /{1}/. Output: {2}" -f $fixtureFile.Name, $expectedOutputRegex, $outputText))
        continue
    }
    if ($forbiddenOutputRegex -and ($outputText -match $forbiddenOutputRegex)) {
        $failures.Add(("{0}: output matched forbidden /{1}/. Output: {2}" -f $fixtureFile.Name, $forbiddenOutputRegex, $outputText))
        continue
    }

    Write-Host ("[OK] {0}" -f $fixtureFile.Name)
}
} finally {
    foreach ($tempTranscriptPath in @($tempTranscriptPaths.ToArray())) {
        if (Test-Path -LiteralPath $tempTranscriptPath -PathType Leaf) {
            Remove-Item -LiteralPath $tempTranscriptPath -Force
        }
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Host ("[FAIL] {0}" -f $failure) -ForegroundColor Red
    }
    exit 1
}

Write-Host ("Codex hook fixtures passed: {0}" -f $fixtures.Count)
exit 0
