#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Cursor Edition 平台部署模組
.DESCRIPTION
    提供 Invoke-CursorFresh 與 Invoke-CursorUpgrade，
    處理 .cursor/rules 與 .cursor/skills 的全新安裝與差異升級。
    共用技能與工作流技能注入 .cursor/skills；治理參考與記憶仍在 .agents/。
#>

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Core.psm1') -ErrorAction Stop
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Skills-Sync.psm1') -ErrorAction Stop

function Get-CursorSharedPolicyPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot
    )

    return Join-Path (Split-Path $SharedSkillsRoot -Parent) 'policies\adapters\cursor-subagent-invocation.md'
}

function Copy-CursorRuleTree {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourceRoot,

        [Parameter(Mandatory = $true)]
        [string]$TargetRoot
    )

    if (-not (Test-Path -LiteralPath $SourceRoot -PathType Container)) {
        throw "Cursor source tree is missing: $SourceRoot"
    }

    Get-ChildItem -LiteralPath $SourceRoot -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($SourceRoot.Length).TrimStart('\', '/')
        if ($rel -like 'skills\*' -or $rel -like 'skills/*') { return }
        if ($rel -like 'hooks\*' -or $rel -like 'hooks/*') { return }
        if ((Split-Path $rel -Leaf) -eq 'hooks.json') { return }
        $dst = Join-Path $TargetRoot $rel
        $dstDir = Split-Path $dst -Parent
        if (-not (Test-Path -LiteralPath $dstDir)) {
            New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
        }
        Copy-Item -LiteralPath $_.FullName -Destination $dst -Force
    }
}

function Invoke-CursorFresh {
    <#
    .SYNOPSIS
        Cursor Edition Fresh 部署 — 全新安裝 .cursor/ 目錄。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$FrameworkRoot,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot
    )

    $srcDotCursor = Join-Path $FrameworkRoot '.cursor'
    $dstDotCursor = Join-Path $Target '.cursor'
    $srcWorkflowSkills = Join-Path $FrameworkRoot '.agents\workflow-skills'
    $agentsRoot = Join-Path $Target '.agents'
    $targetSkillsPath = Join-Path $dstDotCursor 'skills'
    $coreRulePath = Join-Path $dstDotCursor 'rules\00-core.mdc'
    $version = Get-VersionContent -Path (Join-Path $FrameworkRoot 'VERSION')
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot 'project-tools'
    $sharedPolicyPath = Get-CursorSharedPolicyPath -SharedSkillsRoot $SharedSkillsRoot
    $contextTemplatesRoot = Join-Path $sharedRoot 'context'

    $null = Get-SharedPolicyBlock -PolicyPath $sharedPolicyPath -Platform Cursor
    if (-not (Test-Path -LiteralPath $SharedSkillsRoot -PathType Container)) {
        throw "Shared skills source is missing: $SharedSkillsRoot"
    }

    Write-Banner "Cursor Edition v$version — Fresh 安裝 | 目標: $Target" 'Magenta'

    if (-not (Test-Path -LiteralPath $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }

    $backup = Backup-ProtectedDirs -AgentsRoot $agentsRoot

    try {
        Write-Step '部署 .cursor/ 規則...'
        New-Item -ItemType Directory -Force -Path $dstDotCursor | Out-Null
        Copy-CursorRuleTree -SourceRoot $srcDotCursor -TargetRoot $dstDotCursor

        Write-Step '注入共用子代理政策（Shared/policies/ → .cursor/rules/00-core.mdc）...'
        $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
            -TargetPath $coreRulePath `
            -Platform Cursor `
            -InsertAfterPattern '(?m)^Cursor-specific governance:\s*$'

        Write-Step '注入共用技能（Shared/skills/ → .cursor/skills/）...'
        $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
            -TargetSkillsPath $targetSkillsPath `
            -Mode Full

        Write-Step '合併工作流技能（workflow-skills/ → .cursor/skills/）...'
        if (Test-Path -LiteralPath $srcWorkflowSkills) {
            $null = Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
                -TargetSkillsPath $targetSkillsPath
        } else {
            Write-Warn 'workflow-skills/ 不存在，跳過工作流技能合併。'
        }

        Write-Step '注入共用治理參考（Shared/ → .agents/shared/）...'
        $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot `
            -TargetAgentsRoot $agentsRoot `
            -Mode Full

        Write-Step '注入專案本地工具（Shared/project-tools/ → .agents/tools/）...'
        $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot `
            -TargetAgentsRoot $agentsRoot `
            -Mode Full

        Set-Content -LiteralPath (Join-Path $dstDotCursor 'VERSION') -Value $version -Encoding UTF8
        Write-Ok ".cursor\VERSION → $version"

        Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot
        Set-GitignoreEntries -ProjectRoot $Target -Lines @('.agents/logs/', '.cartridge/')

        Write-Step '掃描並補建衍生技能命名空間連結...'
        Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir $targetSkillsPath
    } finally {
        Restore-ProtectedDirs -Backup $backup -AgentsRoot $agentsRoot

        $skillCount = @(Get-ChildItem -LiteralPath $targetSkillsPath -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }).Count
        $ruleCount = @(Get-ChildItem -LiteralPath (Join-Path $dstDotCursor 'rules') -File -Recurse -ErrorAction SilentlyContinue).Count

        Write-Host ''
        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Magenta
        Write-Host "  Cursor Edition v$version 框架已部署完成。" -ForegroundColor Green
        Write-Host "  目標專案現在已具備 Cursor 治理能力。" -ForegroundColor Green
        Write-Host "  技能: $skillCount 套（共用 + 工作流）| 規則: $ruleCount" -ForegroundColor Cyan
        Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Magenta
        Write-Host ''
    }
}

function Invoke-CursorUpgrade {
    <#
    .SYNOPSIS
        Cursor Edition Upgrade 部署 — 差異比對升級 .cursor/ 目錄。
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$FrameworkRoot,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot,

        [switch]$RemoveOrphans
    )

    $srcDotCursor = Join-Path $FrameworkRoot '.cursor'
    $dstDotCursor = Join-Path $Target '.cursor'
    $srcWorkflowSkills = Join-Path $FrameworkRoot '.agents\workflow-skills'
    $agentsRoot = Join-Path $Target '.agents'
    $targetSkillsPath = Join-Path $dstDotCursor 'skills'
    $coreRulePath = Join-Path $dstDotCursor 'rules\00-core.mdc'
    $version = Get-VersionContent -Path (Join-Path $FrameworkRoot 'VERSION')
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot 'project-tools'
    $sharedPolicyPath = Get-CursorSharedPolicyPath -SharedSkillsRoot $SharedSkillsRoot
    $contextTemplatesRoot = Join-Path $sharedRoot 'context'

    $null = Get-SharedPolicyBlock -PolicyPath $sharedPolicyPath -Platform Cursor

    if (-not (Test-Path -LiteralPath $dstDotCursor)) {
        Write-Warn '目標尚未安裝 Cursor Edition，切換為 Fresh 模式。'
        Invoke-CursorFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        return
    }

    $dstVersionFile = Join-Path $dstDotCursor 'VERSION'
    $targetVersion = Get-VersionContent -Path $dstVersionFile
    Write-Banner "Cursor Edition Upgrade v$targetVersion → v$version | 目標: $Target" 'DarkCyan'

    Write-Step '正在掃描 .cursor/ 差異（rules/VERSION）...'
    $categoryMap = [ordered]@{
        '治理規則 (Rules)' = { $_.Path -like 'rules\*' -or $_.Path -like 'rules/*' }
    }

    $report = Get-UpgradeReport `
        -SourceRoot $srcDotCursor `
        -TargetRoot $dstDotCursor `
        -ScanDirs @('rules') `
        -ProtectedDirs @() `
        -ExcludeFiles @('hooks.json')

    $stats = Write-UpgradeReport -Report $report -CategoryMap $categoryMap -Platform 'Cursor'

    $changelogPath = Join-Path $FrameworkRoot 'CHANGELOG.md'
    $notes = Get-ReleaseNotes -ChangelogPath $changelogPath
    if ($notes.Count -gt 0) {
        Write-Host ''
        Write-Host '  最新版本更新說明' -ForegroundColor White
        foreach ($noteLine in $notes) { Write-Host "  $noteLine" }
    }

    $applied = 0
    $applyCursorChanges = $true
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        if (Invoke-ConfirmGate -Message '是否套用上述 .cursor/ 變更？(Y/N)') {
            Write-Step '正在套用變更...'
            $applied = Install-Upgrade -Report $report -SourceRoot $srcDotCursor -TargetRoot $dstDotCursor
        } else {
            Write-Warn '已拒絕框架檔案更新；本次升級維持部分／未驗證狀態，未更新 VERSION，且不輸出完成訊息。'
            $applyCursorChanges = $false
            return
        }
    } else {
        Write-Ok '所有 .cursor/ 規則檔均已是最新版本，無需更新。'
    }

    $ErrorActionPreference = 'Stop'

    Write-Step '同步技能差異（Shared/skills/ → .cursor/skills/）...'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
        -TargetSkillsPath $targetSkillsPath `
        -Mode Diff

    if (Test-Path -LiteralPath $srcWorkflowSkills) {
        Write-Step '同步工作流技能差異（workflow-skills/ → .cursor/skills/）...'
        $null = Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
            -TargetSkillsPath $targetSkillsPath
    }

    Write-Step '同步共用治理參考（Shared/ → .agents/shared/）...'
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot `
        -TargetAgentsRoot $agentsRoot `
        -Mode Diff

    Write-Step '同步專案本地工具（Shared/project-tools/ → .agents/tools/）...'
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot `
        -TargetAgentsRoot $agentsRoot `
        -Mode Diff

    if ($applyCursorChanges) {
        Write-Step '同步共用子代理政策（Shared/policies/ → .cursor/rules/00-core.mdc）...'
        $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
            -TargetPath $coreRulePath `
            -Platform Cursor `
            -InsertAfterPattern '(?m)^Cursor-specific governance:\s*$'
    }

    if ($stats.Orphan -gt 0) {
        if ($RemoveOrphans) {
            Remove-OrphanFiles -Report $report -TargetRoot $dstDotCursor
        } else {
            Write-Warn "$($stats.Orphan) 個孤兒檔案。加入 -RemoveOrphans 可自動清除。"
        }
    }

    Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot
    Set-GitignoreEntries -ProjectRoot $Target -Lines @('.agents/logs/', '.cartridge/')

    Write-Step '掃描並補建衍生技能命名空間連結...'
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir $targetSkillsPath

    Set-Content -LiteralPath $dstVersionFile -Value $version -Encoding UTF8
    Write-Ok ".cursor\VERSION → $version"

    Write-Banner "升級完成 — Cursor Edition v$version（更新 $applied 個框架檔案）" 'Green'
}

Export-ModuleMember -Function Invoke-CursorFresh, Invoke-CursorUpgrade
