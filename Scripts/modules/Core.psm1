#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Core compatibility facade
.DESCRIPTION
    Loads responsibility-focused Core.* modules while preserving the historical
    Core.psm1 import path and Export-ModuleMember -Function * surface.
#>

# EXPORT / FUNCTION RESPONSIBILITY INDEX
# Module                         Responsibility                         Export group
# Core.Reporting.psm1            Console and operator reporting         Write-*
# Core.Comparison.psm1           Version and rule-equivalence checks    Get/Test/Compare-* rule helpers
# Core.Upgrade.psm1              Upgrade scan and apply lifecycle       Get-UpgradeReport, Install-Upgrade, Invoke-ConfirmGate
# Core.Infrastructure.psm1       Protected directories and initialization Backup/Restore-ProtectedDirs, Initialize-AgentInfrastructure
# Core.ProjectSkills.psm1        Project-skill discovery backfill       Invoke-ProjectSkillBackfill
# Core.Cleanup.psm1              Safe orphan removal                    Remove-OrphanFiles
# Core.Gitignore.psm1            .gitignore configuration maintenance   *-AiRulesGitignore*, Set-GitignoreEntries
#
# Compatibility: all functions remain exported from this facade exactly as
# before; consumers continue to Import-Module Core.psm1.

$moduleParts = @(
    'Core.Reporting.psm1',
    'Core.Comparison.psm1',
    'Core.Upgrade.psm1',
    'Core.Infrastructure.psm1',
    'Core.ProjectSkills.psm1',
    'Core.Cleanup.psm1',
    'Core.Gitignore.psm1'
)

foreach ($modulePart in $moduleParts) {
    Import-Module -Name (Join-Path $PSScriptRoot $modulePart) -Force
}

Export-ModuleMember -Function *
