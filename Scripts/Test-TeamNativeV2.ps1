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
$Error.Clear()
$result = Invoke-Pester @invokeParameters

# Pester 3.4.0 retains caught error records from negative-path tests in the
# automatic $Error collection. These records are expected only when the test
# verifies the fail-closed identity and fixture path below. Do not let that
# compatibility behavior hide unrelated PowerShell errors in local or CI runs.
$expectedPesterErrors = @($Error | Where-Object {
    $errorId = [string]$_.FullyQualifiedErrorId
    $message = [string]$_.Exception.Message
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

if ($result.FailedCount -gt 0) {
    exit 1
}

if ($unexpectedPesterErrors.Count -gt 0) {
    $details = $unexpectedPesterErrors | ForEach-Object {
        "$($_.FullyQualifiedErrorId): $($_.Exception.Message)"
    }
    throw "Team-Native tests produced $($unexpectedPesterErrors.Count) unexpected PowerShell error record(s): $($details -join ' | ')"
}

$Error.Clear()
