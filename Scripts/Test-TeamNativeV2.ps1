#Requires -Version 5.1
<##
.SYNOPSIS
    Team-Native V2 Pester runner skeleton.

.DESCRIPTION
    Runs the TeamNative test directory without coupling the runner to a fixed test inventory.
#>
[CmdletBinding()]
param(
    [string]$TestPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'Tests\TeamNative'),

    [switch]$PassThru
)

$invokePester = Get-Command -Name Invoke-Pester -ErrorAction SilentlyContinue
if (-not $invokePester) {
    throw 'Pester is required to run Team-Native V2 tests.'
}

if (-not (Test-Path -LiteralPath $TestPath -PathType Container)) {
    throw "Team-Native V2 test path was not found: $TestPath"
}

$invokeParameters = @{ Script = $TestPath; PassThru = $true }
$result = Invoke-Pester @invokeParameters

if ($PassThru) {
    $result
}

if ($result.FailedCount -gt 0) {
    exit 1
}
