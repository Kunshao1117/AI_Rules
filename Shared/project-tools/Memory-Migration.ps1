#Requires -Version 5.1
<#
.SYNOPSIS
    Project-local memory card main-file migration tool.
.DESCRIPTION
    Deployed to .agents/tools/ so downstream project agents can run the
    governed memory main-file migration without a full AI_Rules source checkout.
    Dry-run is the default. Apply requires both -Apply and -ConfirmApply.
.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1
.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\.agents\tools\Memory-Migration.ps1 -Apply -ConfirmApply
#>
param(
    [string]$TargetRoot = (Get-Location).Path,
    [switch]$Apply,
    [switch]$ConfirmApply,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$modulePath = Join-Path $PSScriptRoot "modules\Memory-Migration.psm1"
if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
    Write-Error "找不到記憶遷移工具模組：$modulePath。請重新同步 AI Rules 專案規則。"
    exit 1
}

Import-Module $modulePath -Force

try {
    $null = Invoke-MemoryMainFileMigration `
        -TargetRoot $TargetRoot `
        -Apply:$Apply `
        -ConfirmApply:$ConfirmApply `
        -WhatIf:$WhatIf
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
