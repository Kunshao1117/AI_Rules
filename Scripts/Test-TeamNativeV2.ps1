#Requires -Version 5.1
<##
.SYNOPSIS
    Team-Native V2 Pester runner skeleton.

.DESCRIPTION
    Runs the TeamNative test directory without coupling the runner to a fixed test inventory.
#>
[CmdletBinding()]
param(
    [string]$TestPath,

    [switch]$PassThru
)

if ([string]::IsNullOrWhiteSpace($TestPath)) {
    $repoRoot = Split-Path -Parent $PSScriptRoot
    $TestPath = Join-Path $repoRoot 'Tests\TeamNative'
}

$invokePester = Get-Command -Name Invoke-Pester -ErrorAction SilentlyContinue
if (-not $invokePester) {
    throw 'Pester is required to run Team-Native V2 tests.'
}

if (-not (Test-Path -LiteralPath $TestPath -PathType Container)) {
    throw "Team-Native V2 test path was not found: $TestPath"
}

$invokeParameters = @{ Script = $TestPath; PassThru = $true }
if ($Error.Count -gt 0) { throw 'Team-Native runner received pre-existing PowerShell error records.' }
$result = Invoke-Pester @invokeParameters

if ($result.FailedCount -gt 0) {
    throw "Team-Native tests failed: $($result.FailedCount) failed, $($result.PassedCount) passed."
}

# Bind each retained negative exception to a literal Should Throw declaration,
# its throwing scriptblock's source lines, and the exact passed Describe/It.
# A caught error elsewhere, an assertion failure, a skipped test, or a merely
# similar message has no such proof and remains an unexpected error.
$verifiedThrows = @()
foreach ($file in @(Get-ChildItem -LiteralPath $TestPath -Recurse -File -Filter '*.Tests.ps1')) {
    $tokens = $null; $parseErrors = $null
    $ast = [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
    foreach ($command in @($ast.FindAll({ param($node)
        $node -is [Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Should'
    }, $true))) {
        $elements = $command.CommandElements
        if ($elements.Count -ne 3 -or $elements[1].Extent.Text -cne 'Throw' -or
            $elements[2] -isnot [Management.Automation.Language.StringConstantExpressionAst] -or
            [string]::IsNullOrWhiteSpace($elements[2].Value) -or
            $command.Parent -isnot [Management.Automation.Language.PipelineAst]) { continue }
        $left = $command.Parent.PipelineElements[0]
        if ($left -isnot [Management.Automation.Language.CommandExpressionAst] -or
            $left.Expression -isnot [Management.Automation.Language.ScriptBlockExpressionAst]) { continue }
        $it = $command.Parent
        while ($it -and -not ($it -is [Management.Automation.Language.CommandAst] -and $it.GetCommandName() -eq 'It')) { $it = $it.Parent }
        if (-not $it -or $it.CommandElements[1] -isnot [Management.Automation.Language.StringConstantExpressionAst]) { continue }
        $describe = $it.Parent
        while ($describe -and -not ($describe -is [Management.Automation.Language.CommandAst] -and $describe.GetCommandName() -eq 'Describe')) { $describe = $describe.Parent }
        if (-not $describe -or $describe.CommandElements[1] -isnot [Management.Automation.Language.StringConstantExpressionAst]) { continue }
        $passed = @($result.TestResult | Where-Object {
            $_.Result -ceq 'Passed' -and $_.Name -ceq $it.CommandElements[1].Value -and $_.Describe -ceq $describe.CommandElements[1].Value
        })
        if ($passed.Count -ne 1) { continue }
        $verifiedThrows += [pscustomobject]@{
            File = $file.FullName; Message = $elements[2].Value
            FirstLine = $left.Expression.Extent.StartLineNumber; LastLine = $left.Expression.Extent.EndLineNumber
        }
    }
}

# Pester 3.4.0 retains caught error records from negative-path tests in the
# automatic $Error collection. These records are expected only when the test
# verifies the fail-closed identity and fixture path below. Do not let that
# compatibility behavior hide unrelated PowerShell errors in local or CI runs.
$expectedPesterErrors = @($Error | Where-Object {
    $errorId = [string]$_.FullyQualifiedErrorId
    $message = [string]$_.Exception.Message
    $stack = [string]$_.ScriptStackTrace
    if ($errorId -notmatch '^PesterAssertionFailed') {
        foreach ($negative in $verifiedThrows) {
            if ($negative.Message -notmatch '[A-Za-z0-9]' -or -not $message.Contains($negative.Message)) { continue }
            foreach ($site in [regex]::Matches($stack, [regex]::Escape($negative.File) + ':\D*(\d+)')) {
                $line = [int]$site.Groups[1].Value
                if ($line -ge $negative.FirstLine -and $line -le $negative.LastLine) { return $true }
            }
        }
    }
    $isKnownFixture = $message -match '(?i)[\\/]ai-rules-(policy-sync|platform-preflight|manager-sync)-'

    if ($errorId -match '^SharedPolicy\.(PolicyFileMissing|PolicyBlockMissing)' -and $isKnownFixture) {
        return $true
    }

    return (
        $errorId -eq 'CopyFileInfoItemIOError,Microsoft.PowerShell.Commands.CopyItemCommand' -and
        $_.Exception -is [System.IO.DirectoryNotFoundException] -and
        $message -match '(?i)[\\/]ai-rules-manager-sync-[^\\/]+[\\/]project[\\/]\.agents[\\/]shared[\\/]'
    )
})
$unexpectedPesterErrors = @($Error | Where-Object { $_ -notin $expectedPesterErrors })

if ($PassThru) {
    $result
}

if ($unexpectedPesterErrors.Count -gt 0) {
    $details = $unexpectedPesterErrors | ForEach-Object {
        "$($_.FullyQualifiedErrorId): $($_.Exception.Message)"
    }
    throw "Team-Native tests produced $($unexpectedPesterErrors.Count) unexpected PowerShell error record(s): $($details -join ' | ')"
}

foreach ($record in $expectedPesterErrors) { $Error.Remove($record) }

# Native negative-path probes may leave a nonzero child exit code after Pester
# has verified that failure. Report this entry's successful verdict only after
# every assertion and unexpected-error guard has passed. Do not let a caller's
# native-exit propagation mistake the verified probe for this runner failing.
$global:LASTEXITCODE = 0
