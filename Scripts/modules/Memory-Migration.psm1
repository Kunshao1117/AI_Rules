#Requires -Version 5.1
<#
.SYNOPSIS
    Compatibility shim for the shared project-local memory migration tool.
.DESCRIPTION
    AI_Rules Manager imports this module from Scripts/modules. The actual
    migration implementation lives under Shared/project-tools so the same logic
    can be deployed to downstream projects as .agents/tools/.
#>

$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$sharedModulePath = Join-Path $repoRoot "Shared\project-tools\modules\Memory-Migration.psm1"

if (-not (Test-Path -LiteralPath $sharedModulePath -PathType Leaf)) {
    throw "Shared project tool module not found: $sharedModulePath"
}

Import-Module $sharedModulePath -Force -Global
