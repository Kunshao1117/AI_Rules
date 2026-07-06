#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 整合審計模組
.DESCRIPTION
    整合原本分散在 AG/Claude 兩個平台的 6 支審計腳本：
    - Invoke-DocScan × 2 → Invoke-DocScan
    - Invoke-HealthAudit × 2 → Invoke-HealthAudit
    - Measure-SkillQuality × 2 → Measure-SkillQuality
    支援指定平台（Antigravity / Claude / Codex / All）執行。
#>

using module ".\Core.psm1"

. (Join-Path $PSScriptRoot 'Audit\00.Common.ps1')
. (Join-Path $PSScriptRoot 'Audit\10.LegacyScans.ps1')
. (Join-Path $PSScriptRoot 'Audit\20.SkillQuality.ps1')
. (Join-Path $PSScriptRoot 'Audit\30.WorkflowPlatform.ps1')
. (Join-Path $PSScriptRoot 'Audit\40.PolicySemantics.ps1')
. (Join-Path $PSScriptRoot 'Audit\50.CodexHookGovernance.ps1')
. (Join-Path $PSScriptRoot 'Audit\60.ProgrammingTeamGovernance.ps1')
. (Join-Path $PSScriptRoot 'Audit\70.DirectorOutputGrounding.ps1')
. (Join-Path $PSScriptRoot 'Audit\80.ProjectStores.ps1')
. (Join-Path $PSScriptRoot 'Audit\90.TeamNativeCore.ps1')
. (Join-Path $PSScriptRoot 'Audit\91.TeamTraceEvidence.ps1')
. (Join-Path $PSScriptRoot 'Audit\99.PlatformGovernanceAudit.ps1')

Export-ModuleMember -Function Invoke-DocScan, Invoke-HealthAudit, Measure-SkillQuality, Measure-WorkflowMetadata, Measure-DocsConsistency, Measure-PlatformCapability, Measure-RuntimeGlobalDrift, Measure-SharedSubagentPolicyDrift, Measure-SubagentVocabularyDrift, Measure-GovernanceSemantics, Measure-ReviewGovernanceCoverage, Measure-ProgrammingTeamGovernanceCoverage, Measure-TeamNativeCoreSemantics, Measure-TeamTraceEvidence, Measure-CodexHookGovernance, Measure-DirectorOutputContract, Measure-DirectorFacingOutputQuality, Measure-HighChangeGroundingGap, Test-DirectorLanguageDominance, Test-RawArtifactLedOutput, Measure-ProjectSkillLinks, Measure-SharedContextTemplates, Measure-ProjectContextCards, Measure-MemoryCardNaming, Invoke-PlatformGovernanceAudit
