#Requires -Version 5.1
<#
.SYNOPSIS
    AI_Rules VS Code Manager backend.
.DESCRIPTION
    Provides a stable, button-friendly PowerShell facade for the VS Code extension.
    Read-only actions are safe by default. Mutating actions require -Apply and, for
    orphan deletion, -RemoveOrphans.
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

Invoke-ManagerAction `
    -Action $Action `
    -RepoRoot $RepoRoot `
    -Target $Target `
    -ProfileRoot $ProfileRoot `
    -Apply:$Apply `
    -RemoveOrphans:$RemoveOrphans `
    -ProjectPlatform $ProjectPlatform `
    -GitignoreMode $GitignoreMode `
    -WhatIf:$WhatIf `
    -ManagedSource:$ManagedSource
