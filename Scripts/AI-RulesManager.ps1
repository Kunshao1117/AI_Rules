#Requires -Version 5.1
<#
.SYNOPSIS
    AI_Rules VS Code Manager backend.
.DESCRIPTION
    Provides a stable, button-friendly PowerShell facade for the VS Code extension.
    Read-only actions are safe by default. Mutating actions require -Apply.
    CleanupOrphans preserves unknown ownership even with -Apply -RemoveOrphans;
    retirement is limited to explicit historical hash allowlists.
#>
param(
    [ValidateSet("Check", "Plan", "Apply", "SyncGlobal", "SyncProjectRules", "CleanupOrphans", "Gitignore", "MemoryMigration")]
    [string]$Action = "Check",

    [string]$RepoRoot,

    [string]$Target = $PWD.Path,

    [string]$ProfileRoot = $env:USERPROFILE,

    [switch]$Apply,

    [switch]$RemoveOrphans,

    [ValidateSet("Auto", "Codex", "Claude", "Antigravity")]
    [string]$ProjectPlatform = "Auto",

    [ValidateSet("Append", "CleanSimilar", "Overwrite")]
    [string]$GitignoreMode = "Append",

    [switch]$WhatIf,

    [switch]$ManagedSource
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not $RepoRoot) {
    $RepoRoot = Split-Path $PSScriptRoot -Parent
}
$RepoRoot = (Resolve-Path $RepoRoot).Path
$ModulesDir = Join-Path $RepoRoot "Scripts\modules"

# Manager helper index: commands → Manager.Commands/Invoke-ManagerAction;
# configuration and TOML merge → Manager.Config; deployment coordination → Manager.Deployment.
Import-Module (Join-Path $ModulesDir "Manager.Commands.psm1") -Force

$arguments = @{
    Action = $Action; RepoRoot = $RepoRoot; Target = $Target; ProfileRoot = $ProfileRoot
    Apply = $Apply; RemoveOrphans = $RemoveOrphans; ProjectPlatform = $ProjectPlatform
    GitignoreMode = $GitignoreMode; WhatIf = $WhatIf; ManagedSource = $ManagedSource
}
if ($Action -eq 'SyncProjectRules') {
    $output = @(Invoke-ManagerAction @arguments)
    $results = @($output | Where-Object {
        $null -ne $_ -and $null -ne $_.PSObject.Properties['Succeeded']
    })
    $syncResult = if ($results.Count -eq 1) { $results[0] } else { $null }
    $envelope = @{ Version = 1; Action = $Action; Result = $syncResult }
    Write-Host ('AI_RULES_MANAGER_RESULT:' + ($envelope | ConvertTo-Json -Depth 10 -Compress))
    if ($null -eq $syncResult -or $syncResult.Succeeded -isnot [bool]) { exit 2 }
    if (-not $syncResult.Succeeded) { exit 1 }
} else {
    Invoke-ManagerAction @arguments
}
