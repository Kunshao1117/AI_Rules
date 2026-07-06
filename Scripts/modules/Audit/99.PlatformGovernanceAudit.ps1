# Internal partial for Audit.psm1. Loaded by the facade only.
# Platform governance audit facade entry

function Invoke-PlatformGovernanceAudit {
    <#
    .SYNOPSIS
        執行三平台代理治理巡檢：能力矩陣、workflow metadata、MCP profile、文件數字與記憶漂移。
    .PARAMETER RepoRoot
        AI_Rules 倉庫根目錄
    .PARAMETER RequireTeamTrace
        要求 Team-Native task trace；缺少或不完整時列為紅燈
    .PARAMETER TeamTraceRoot
        Team-Native task trace 目錄；相對路徑以 TargetRoot 為基準
    #>
    param(
        [string]$RepoRoot = ".",
        [string]$ProfileRoot = $env:USERPROFILE,
        [string]$TargetRoot = ".",
        [switch]$RequireTeamTrace,
        [string]$TeamTraceRoot
    )

    $RepoRoot = (Resolve-Path $RepoRoot).Path
    $TargetRoot = (Resolve-Path $TargetRoot).Path
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8

    Write-Host ""
    Write-Host "🧭 三平台代理治理巡檢"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "TargetRoot：$TargetRoot"

    $capability = Measure-PlatformCapability -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $metadata = Measure-WorkflowMetadata -RepoRoot $RepoRoot
    $skillQuality = Measure-SkillQuality -SkillsRoot (Join-Path $RepoRoot 'Shared\skills')
    $docs = Measure-DocsConsistency -RepoRoot $RepoRoot
    $runtime = Measure-RuntimeGlobalDrift -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
    $semantics = Measure-GovernanceSemantics -RepoRoot $RepoRoot
    $reviewGovernance = Measure-ReviewGovernanceCoverage -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $programmingTeamGovernance = Measure-ProgrammingTeamGovernanceCoverage -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $teamNativeCore = Measure-TeamNativeCoreSemantics -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $teamTraceEvidence = Measure-TeamTraceEvidence -TargetRoot $TargetRoot -TeamTraceRoot $TeamTraceRoot -RequireTeamTrace:$RequireTeamTrace
    $codexHooks = Measure-CodexHookGovernance -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $subagentPolicy = Measure-SharedSubagentPolicyDrift -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $subagentVocabulary = Measure-SubagentVocabularyDrift -RepoRoot $RepoRoot
    $directorOutput = Measure-DirectorOutputContract -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $directorFacingOutputQuality = Measure-DirectorFacingOutputQuality -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $highChangeGrounding = Measure-HighChangeGroundingGap -RepoRoot $RepoRoot -TargetRoot $TargetRoot
    $projectLinks = Measure-ProjectSkillLinks -TargetRoot $TargetRoot
    $sharedContextTemplates = Measure-SharedContextTemplates -RepoRoot $RepoRoot
    $projectContext = Measure-ProjectContextCards -TargetRoot $TargetRoot
    $memoryNaming = Measure-MemoryCardNaming -TargetRoot $TargetRoot

    $metadataFail = ($metadata | Where-Object { $_.Status -eq '🔴' }).Count
    $metadataYellow = ($metadata | Where-Object { $_.Status -eq '🟡' }).Count
    $skillRed = ($skillQuality | Where-Object { $_.OverallStatus -eq '🔴' }).Count
    $skillYellow = ($skillQuality | Where-Object { $_.OverallStatus -eq '🟡' }).Count
    $docStale = $docs.StaleHits.Count
    $redTotal = $runtime.RedCount + $semantics.RedCount + $reviewGovernance.RedCount + $programmingTeamGovernance.RedCount + $teamNativeCore.RedCount + $teamTraceEvidence.RedCount + $codexHooks.RedCount + $subagentPolicy.RedCount + $subagentVocabulary.RedCount + $directorOutput.RedCount + $directorFacingOutputQuality.RedCount + $highChangeGrounding.RedCount + $projectLinks.RedCount + $sharedContextTemplates.RedCount + $projectContext.RedCount + $memoryNaming.RedCount
    $redTotal += $skillRed
    $yellowTotal = $runtime.YellowCount + $semantics.YellowCount + $reviewGovernance.YellowCount + $programmingTeamGovernance.YellowCount + $teamNativeCore.YellowCount + $teamTraceEvidence.YellowCount + $codexHooks.YellowCount + $subagentPolicy.YellowCount + $subagentVocabulary.YellowCount + $directorOutput.YellowCount + $directorFacingOutputQuality.YellowCount + $highChangeGrounding.YellowCount + $projectLinks.YellowCount + $sharedContextTemplates.YellowCount + $projectContext.YellowCount + $memoryNaming.YellowCount
    $yellowTotal += $metadataYellow + $skillYellow
    $ok = $capability.CapabilityMatrix -and $capability.WorkflowMatrix -and $capability.TargetSharedRefs -and $capability.TargetCodexSupport -and $capability.ProjectToolSource -and $capability.TargetProjectTools -and $capability.McpProfiles -and $capability.MemoryMigrationManager -and $capability.MemoryMigrationExtension -and ($metadataFail -eq 0) -and ($skillRed -eq 0) -and ($docStale -eq 0) -and ($redTotal -eq 0)

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if ($ok -and ($yellowTotal -eq 0)) {
        Write-Host "✅ 平台代理治理巡檢通過"
    } else {
        Write-Host "⚠️ 平台代理治理巡檢有待處理項目" -ForegroundColor Yellow
    }

    return [PSCustomObject]@{
        Capability = $capability
        Metadata   = $metadata
        SkillQuality = $skillQuality
        Docs       = $docs
        Runtime    = $runtime
        Semantics  = $semantics
        ReviewGovernance = $reviewGovernance
        ProgrammingTeamGovernance = $programmingTeamGovernance
        TeamNativeCore = $teamNativeCore
        TeamTraceEvidence = $teamTraceEvidence
        CodexHooks = $codexHooks
        SubagentPolicy = $subagentPolicy
        SubagentVocabulary = $subagentVocabulary
        DirectorOutput = $directorOutput
        DirectorFacingOutputQuality = $directorFacingOutputQuality
        HighChangeGrounding = $highChangeGrounding
        ProjectLinks = $projectLinks
        SharedContextTemplates = $sharedContextTemplates
        ProjectContext = $projectContext
        MemoryNaming = $memoryNaming
        RedCount   = $redTotal
        YellowCount = $yellowTotal
        Passed     = $ok
    }
}
