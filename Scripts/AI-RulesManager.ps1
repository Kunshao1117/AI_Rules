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
    [ValidateSet("Check", "Plan", "Apply", "Doctor", "SyncGlobal", "SyncProjectRules", "CleanupOrphans", "Gitignore", "MemoryMigration")]
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

    [switch]$ManagedSource,

    [switch]$RequireTeamTrace,

    [string]$TeamTraceRoot
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

if (-not $RepoRoot) {
    $RepoRoot = Split-Path $PSScriptRoot -Parent
}
$RepoRoot = (Resolve-Path $RepoRoot).Path
$ModulesDir = Join-Path $RepoRoot "Scripts\modules"

Import-Module (Join-Path $ModulesDir "Core.psm1") -Force
Import-Module (Join-Path $ModulesDir "Audit.psm1") -Force
Import-Module (Join-Path $ModulesDir "Skills-Sync.psm1") -Force
Import-Module (Join-Path $ModulesDir "Memory-Migration.psm1") -Force

function Write-ManagerHeader {
    param([string]$Title)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  AI Rules Manager — $Title" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
}

function Get-GitSnapshot {
    $head = "unknown"
    $branch = "unknown"
    $remoteHead = "unknown"
    $remoteTrackingHead = "unknown"
    $dirty = @()

    try { $head = (git -C $RepoRoot rev-parse HEAD 2>$null).Trim() } catch { }
    try { $branch = (git -C $RepoRoot branch --show-current 2>$null).Trim() } catch { }
    if ($branch) {
        try { $remoteTrackingHead = (git -C $RepoRoot rev-parse --verify "refs/remotes/origin/$branch" 2>$null).Trim() } catch { }
    }
    try {
        $remoteLine = git -C $RepoRoot ls-remote origin "refs/heads/$branch" 2>$null | Select-Object -First 1
        if ($remoteLine) { $remoteHead = (($remoteLine -split "\s+")[0]).Trim() }
    } catch { }
    try { $dirty = @(git -C $RepoRoot status --short 2>$null) } catch { }

    $relation = Get-GitRelation -Head $head -RemoteHead $remoteHead -RemoteTrackingHead $remoteTrackingHead

    return [PSCustomObject]@{
        Branch             = $branch
        Head               = $head
        RemoteHead         = $remoteHead
        RemoteTrackingHead = $remoteTrackingHead
        DirtyCount         = $dirty.Count
        DirtyFiles         = $dirty
        Relation           = $relation
        HasUpdate          = ($head -ne "unknown") -and ($remoteHead -ne "unknown") -and ($head -ne $remoteHead)
    }
}

function Test-GitCommitExists {
    param([string]$Commit)
    if (-not $Commit -or $Commit -eq "unknown") { return $false }
    git -C $RepoRoot cat-file -e "${Commit}^{commit}" 2>$null
    return $LASTEXITCODE -eq 0
}

function Test-GitAncestor {
    param(
        [string]$Ancestor,
        [string]$Descendant
    )
    if (-not (Test-GitCommitExists -Commit $Ancestor) -or -not (Test-GitCommitExists -Commit $Descendant)) {
        return $false
    }
    git -C $RepoRoot merge-base --is-ancestor $Ancestor $Descendant 2>$null
    return $LASTEXITCODE -eq 0
}

function Get-GitRelation {
    param(
        [string]$Head,
        [string]$RemoteHead,
        [string]$RemoteTrackingHead
    )
    if ($Head -eq "unknown" -or $RemoteHead -eq "unknown") { return "Unknown" }
    if ($Head -eq $RemoteHead) { return "Synced" }

    if (Test-GitCommitExists -Commit $RemoteHead) {
        $remoteContainsLocal = Test-GitAncestor -Ancestor $Head -Descendant $RemoteHead
        $localContainsRemote = Test-GitAncestor -Ancestor $RemoteHead -Descendant $Head
        if ($remoteContainsLocal -and -not $localContainsRemote) { return "FastForward" }
        if ($localContainsRemote -and -not $remoteContainsLocal) { return "LocalAhead" }
        return "Diverged"
    }

    if ($RemoteTrackingHead -ne "unknown" -and $RemoteTrackingHead -ne $RemoteHead) {
        return "RemoteChanged"
    }
    return "RemoteChanged"
}

function Show-GitSnapshot {
    param([object]$Snapshot)
    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "來源模式：$(if ($ManagedSource) { '使用者層管理快取（以遠端版本庫為準）' } else { '本機來源（不自動重設）' })"
    Write-Host "Branch：$($Snapshot.Branch)"
    Write-Host "Local HEAD：$($Snapshot.Head)"
    Write-Host "Remote HEAD：$($Snapshot.RemoteHead)"
    Write-Host "工作樹變更：$($Snapshot.DirtyCount)"
    if ($Snapshot.DirtyCount -gt 0) {
        Write-Host "工作樹狀態：工作樹有變更" -ForegroundColor Yellow
    } else {
        Write-Host "工作樹狀態：乾淨" -ForegroundColor Green
    }

    switch ($Snapshot.Relation) {
        "Synced"       { Write-Host "狀態：已同步" -ForegroundColor Green }
        "FastForward"  { Write-Host "狀態：可快轉更新" -ForegroundColor Yellow }
        "Diverged"     { Write-Host "狀態：來源庫分叉" -ForegroundColor Red }
        "LocalAhead"   { Write-Host "狀態：本機領先遠端" -ForegroundColor Yellow }
        "RemoteChanged" { Write-Host "狀態：偵測到遠端更新（尚未能確認是否可快轉）" -ForegroundColor Yellow }
        default        { Write-Host "狀態：無法判斷來源庫狀態" -ForegroundColor Yellow }
    }
}

function Assert-SourceSyncedForProjectSync {
    $snapshot = Get-GitSnapshot
    if (($snapshot.DirtyCount -eq 0) -and ($snapshot.Relation -eq "Synced")) {
        return
    }

    Write-Host ""
    Write-Host "📊 AI_Rules Source Freshness"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Show-GitSnapshot -Snapshot $snapshot
    if ($ManagedSource) {
        Write-Fail "專案規則同步已停止：AI_Rules 管理快取未能對齊遠端版本庫；不使用舊快取同步專案。"
    } else {
        Write-Fail "專案規則同步已停止：目前指定的 AI_Rules 本機來源尚未對齊遠端版本庫；請先整理或更新來源後再同步。"
    }
    exit 1
}

function Invoke-Check {
    Write-ManagerHeader "檢查 AI_Rules 來源狀態"
    Write-Host "用途：讀取 AI_Rules 來源版本庫的 Git 狀態，並檢查使用者層全域規則漂移；不寫入目前專案。"
    $snapshot = Get-GitSnapshot
    Show-GitSnapshot -Snapshot $snapshot
    $null = Measure-RuntimeGlobalDrift -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
}

function Invoke-Plan {
    Write-ManagerHeader "查看 AI_Rules 來源更新影響"
    $snapshot = Get-GitSnapshot
    Show-GitSnapshot -Snapshot $snapshot
    Write-Host ""
    Write-Host "來源庫更新計畫"
    if ($ManagedSource) {
        Write-Host "- 目前來源是使用者層管理快取；插件會先把快取對齊遠端版本庫，再執行管理腳本。"
        Write-Host "- 若快取無法對齊遠端，流程會停止，不會用舊快取巡檢或同步專案規則。"
    } else {
        Write-Host "- 目前來源是本機來源；工具只檢查狀態，不會自動重設本機變更。"
        Write-Host "- 若有遠端更新，更新動作只會嘗試快轉更新，不會重設本機變更。"
    }
    Write-Host "- 套用後會重新執行平台代理治理巡檢。"
    Write-Host "- 這不會安裝新版 VSIX，也不會同步目前專案的 .agents / .claude / .codex。"
    Write-Host "- 全域規則、專案規則與孤兒檔案仍需另外按鈕確認，不會在 Plan 階段修改。"
    if ($snapshot.DirtyCount -gt 0) {
        Write-Host ""
        Write-Host "目前工作樹不是乾淨狀態，建議先檢查以下變更：" -ForegroundColor Yellow
        $snapshot.DirtyFiles | ForEach-Object { Write-Host "  $_" }
    }
}

function Invoke-ApplyUpdate {
    Write-ManagerHeader "更新 AI_Rules 來源庫"
    if ($WhatIf) {
        if ($ManagedSource) {
            Write-Host "WhatIf：插件會先對齊 AI_Rules 遠端來源鏡像，然後執行治理巡檢；不安裝 VSIX，也不同步目前專案規則。"
        } else {
            Write-Host "WhatIf：將檢查本機 AI_Rules 來源並嘗試快轉更新，然後執行治理巡檢；不安裝 VSIX，也不同步目前專案規則。"
        }
        return
    }
    if (-not $Apply) {
        Write-Host "未指定 -Apply，拒絕寫入。請由 VS Code 確認視窗或命令明確授權後再執行。" -ForegroundColor Yellow
        exit 2
    }
    $snapshot = Get-GitSnapshot
    if ($snapshot.DirtyCount -gt 0) {
        Show-GitSnapshot -Snapshot $snapshot
        Write-Fail "來源庫更新失敗：工作樹有變更；已停止，不執行治理巡檢。"
        exit 1
    }
    if ($snapshot.Relation -eq "Diverged") {
        Show-GitSnapshot -Snapshot $snapshot
        Write-Fail "來源庫更新失敗：來源庫分叉；已停止，不執行治理巡檢。"
        exit 1
    }
    if ($snapshot.Relation -eq "LocalAhead") {
        Show-GitSnapshot -Snapshot $snapshot
        Write-Fail "來源庫更新失敗：本機領先遠端；已停止，不執行治理巡檢。"
        exit 1
    }
    if ($ManagedSource) {
        if ($snapshot.Relation -ne "Synced") {
            Show-GitSnapshot -Snapshot $snapshot
            Write-Fail "來源庫更新失敗：AI_Rules 管理快取未能對齊遠端版本庫；已停止，不執行治理巡檢。"
            exit 1
        }
        $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot -AuditProfile ApplyDefault
        if (-not $audit.Passed) { exit 1 }
        return
    }
    git -C $RepoRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "來源庫更新失敗：無法快轉或 Git 回報錯誤；已停止，不執行治理巡檢。"
        exit 1
    }
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot -AuditProfile ApplyDefault
    if (-not $audit.Passed) { exit 1 }
}

function Invoke-Doctor {
    Write-ManagerHeader "治理巡檢 Doctor"
    Write-Host "用途：檢查 Shared Skill 品質、workflow metadata、policy marker、Team-Native 專家技能、任務軌跡、Codex repo-managed hooks 移除／rebuild pending 狀態與 Captain-Lite 讀取模型、子代理語彙、審查治理覆蓋、下游共用參考、專案本地工具、全域規則漂移與 project skill links；不寫入檔案。"
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot -AuditProfile Full
    if (-not $audit.Passed) {
        Write-Fail "Doctor 阻塞：治理巡檢存在 Red findings，請先修正。"
        exit 1
    }
}

function Invoke-SyncGlobal {
    Write-ManagerHeader "同步使用者層規則"
    $deploy = Join-Path $RepoRoot "Scripts\Deploy.ps1"
    if ($Apply) {
        & $deploy -Action Global -ProfileRoot $ProfileRoot -Apply
    } else {
        & $deploy -Action Global -ProfileRoot $ProfileRoot
    }
}

function Test-ProjectPlatformInstalled {
    param(
        [string]$TargetRoot,
        [ValidateSet("Codex", "Claude", "Antigravity")]
        [string]$Platform
    )

    switch ($Platform) {
        "Codex" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".codex\AGENTS.md")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".codex\config.toml"))
        }
        "Claude" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\CLAUDE.md")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\commands")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\rules"))
        }
        "Antigravity" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".agents\rules")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".agents\workflows"))
        }
    }
}

function Get-InstalledProjectPlatforms {
    param([string]$TargetRoot)

    $platforms = @()
    foreach ($platform in @("Antigravity", "Claude", "Codex")) {
        if (Test-ProjectPlatformInstalled -TargetRoot $TargetRoot -Platform $platform) {
            $platforms += $platform
        }
    }
    return $platforms
}

function Write-ProjectSyncNoInstallWarning {
    param(
        [string]$TargetRoot,
        [string]$Platform
    )

    Write-Host ""
    Write-Host "📊 Project Platform Selection"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：0  🟡 Yellow：1"
    Write-Warn "目前專案未安裝 $Platform，專案規則同步不會自動建立未使用的平台。"
    Write-Step "Target：$TargetRoot"
}

function Get-SharedSkillDiffs {
    param(
        [string]$SharedSkillsRoot,
        [string]$TargetSkillsPath
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $SharedSkillsRoot)) { return $diffs }

    Get-ChildItem -LiteralPath $SharedSkillsRoot -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $relPath = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
            Test-SharedSkillRelativePathIncluded -RelativePath $relPath
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
            $targetFile = Join-Path $TargetSkillsPath $rel
            $diff = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $targetFile -RelativePath $rel
            if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
        }

    return $diffs
}

function Get-CodexWorkflowDiffs {
    param(
        [string]$WorkflowSkillsPath,
        [string]$TargetSkillsPath
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $WorkflowSkillsPath)) { return $diffs }

    Get-ChildItem -LiteralPath $WorkflowSkillsPath -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $rel = $_.FullName.Substring($WorkflowSkillsPath.Length).TrimStart('\', '/')
            Test-CodexWorkflowRelativePathIncluded -RelativePath $rel
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($WorkflowSkillsPath.Length).TrimStart('\', '/')
            $targetFile = Join-Path $TargetSkillsPath $rel
            $diff = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $targetFile -RelativePath $rel
            if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
        }

    return $diffs
}

function Get-SharedGovernanceReferenceDiffs {
    param(
        [string]$SharedRoot,
        [string]$TargetAgentsRoot
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $SharedRoot)) { return $diffs }

    foreach ($rel in @(Get-SharedGovernanceReferenceRelativePaths -SharedRoot $SharedRoot)) {
        $sourceFile = Join-Path $SharedRoot $rel
        if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) { continue }
        $targetFile = Join-Path (Join-Path $TargetAgentsRoot "shared") $rel
        $diff = Compare-FrameworkFile -SourcePath $sourceFile -TargetPath $targetFile -RelativePath $rel
        if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
    }

    return $diffs
}

function Write-DiffSummary {
    param(
        [string]$Title,
        [array]$Diffs
    )

    Write-Host ""
    Write-Host "📊 $Title"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "NEW/CHANGED：$(@($Diffs).Count)"
    foreach ($diff in @($Diffs) | Select-Object -First 40) {
        Write-Host ("  [{0}] {1}" -f $diff.Status, $diff.Path) -ForegroundColor Yellow
    }
}

function Set-ProjectVersionFile {
    param(
        [string]$Path,
        [string]$Version,
        [switch]$Apply
    )

    $current = Get-VersionContent -Path $Path
    if (-not $Apply) {
        if ($current -eq $Version) {
            Write-Step "版本錨點已是最新: $Path ($Version)"
        } else {
            Write-Warn "版本錨點待更新: $Path ($current → $Version)"
        }
        return
    }

    $parent = Split-Path $Path -Parent
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Set-Content -LiteralPath $Path -Value $Version -NoNewline -Encoding UTF8
    Write-Ok "版本錨點已更新: $Path → $Version"
}

function Sync-ProjectSkillLinks {
    param(
        [string]$TargetRoot,
        [string[]]$Platforms
    )

    $agentsRoot = Join-Path $TargetRoot ".agents"
    if (-not (Test-Path -LiteralPath (Join-Path $agentsRoot "project_skills"))) { return }

    Write-Host ""
    Write-Host "📊 Project Skill Links"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ($Platforms -contains "Antigravity" -or $Platforms -contains "Codex") {
        $null = Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir (Join-Path $agentsRoot "skills")
    }
    if ($Platforms -contains "Claude") {
        $claudeRoot = Join-Path $TargetRoot ".claude"
        if (Test-Path -LiteralPath $claudeRoot) {
            $null = Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir (Join-Path $claudeRoot "skills")
        }
    }
}

function Invoke-SyncAntigravityProjectRules {
    param(
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Antigravity\.agents"
    $agTargetRoot = Join-Path $ProjectRoot ".agents"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Antigravity\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $agTargetRoot `
        -ScanDirs @("rules", "workflows") `
        -ProtectedDirs @("memory", "project_skills", "context") `
        -ExcludeFiles @() `
        -PreserveProjectIdentity)

    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規範 (.agents/rules)" = { $_.Path -like "rules/*" -or $_.Path -like "rules\*" }
        "工作流程 (.agents/workflows)" = { $_.Path -like "workflows/*" -or $_.Path -like "workflows\*" }
        "專案記憶 — 受保護" = { $_.Path -like "memory/*" -or $_.Path -like "memory\*" }
        "專案技能 — 受保護" = { $_.Path -like "project_skills/*" -or $_.Path -like "project_skills\*" }
        "專案脈絡 — 受保護" = { $_.Path -like "context/*" -or $_.Path -like "context\*" }
    }) -Platform "Antigravity"

    $targetSkillsPath = Join-Path $agTargetRoot "skills"
    $skillDiffs = @(Get-SharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Antigravity Shared Skills" -Diffs $skillDiffs
    $governanceDiffs = @(Get-SharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot $agTargetRoot)
    Write-DiffSummary -Title "Antigravity Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agTargetRoot)
    Write-DiffSummary -Title "Antigravity Project Tools" -Diffs $toolDiffs
    Set-ProjectVersionFile -Path (Join-Path $agTargetRoot "VERSION") -Version $version -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $agTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $agTargetRoot "rules\00_core_identity.md") `
        -Platform Antigravity `
        -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agTargetRoot -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agTargetRoot -Mode Diff
}

function Invoke-SyncClaudeProjectRules {
    param(
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Claude\.claude"
    $claudeTargetRoot = Join-Path $ProjectRoot ".claude"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Claude\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $claudeTargetRoot `
        -ScanDirs @("commands", "rules") `
        -ProtectedDirs @() `
        -ExcludeFiles @("settings.local.json") `
        -ScanFiles @("CLAUDE.md") `
        -PreserveProjectIdentity)

    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "入口規則 (.claude/CLAUDE.md)" = { $_.Path -eq "CLAUDE.md" }
        "工作流指令 (.claude/commands)" = { $_.Path -like "commands/*" -or $_.Path -like "commands\*" }
        "治理規範 (.claude/rules)" = { $_.Path -like "rules/*" -or $_.Path -like "rules\*" }
    }) -Platform "Claude"

    $targetSkillsPath = Join-Path $claudeTargetRoot "skills"
    $skillDiffs = @(Get-SharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Claude Shared Skills" -Diffs $skillDiffs
    $governanceDiffs = @(Get-SharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents"))
    Write-DiffSummary -Title "Claude Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents"))
    Write-DiffSummary -Title "Claude Project Tools" -Diffs $toolDiffs
    Set-ProjectVersionFile -Path (Join-Path $claudeTargetRoot "VERSION") -Version $version -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $claudeTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $claudeTargetRoot "rules\core-identity.md") `
        -Platform Claude `
        -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents") -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents") -Mode Diff
}

function Merge-CodexProjectConfigDefaults {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [switch]$Apply
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) { return }

    function Get-TomlSectionBounds {
        param(
            [string]$Text,
            [string]$Section
        )

        $headers = [regex]::Matches($Text, '(?m)^\s*\[([^\]]+)\]\s*(?:#.*)?(?:\r?\n|$)')
        for ($i = 0; $i -lt $headers.Count; $i++) {
            if ($headers[$i].Groups[1].Value.Trim() -eq $Section) {
                $end = $Text.Length
                if (($i + 1) -lt $headers.Count) { $end = $headers[$i + 1].Index }
                return [PSCustomObject]@{
                    BodyStart = $headers[$i].Index + $headers[$i].Length
                    End       = $end
                }
            }
        }

        return $null
    }

    function Get-TomlTopLevelKeyLine {
        param(
            [string]$Text,
            [string]$Key
        )

        $rootEnd = $Text.Length
        $firstSection = [regex]::Match($Text, '(?m)^\s*\[[^\]]+\]\s*(?:#.*)?(?:\r?\n|$)')
        if ($firstSection.Success) { $rootEnd = $firstSection.Index }
        $rootText = $Text.Substring(0, $rootEnd)
        $match = [regex]::Match($rootText, ("(?m)^\s*{0}\s*=.*$" -f [regex]::Escape($Key)))
        if ($match.Success) { return $match.Value.Trim() }
        return $null
    }

    function Get-TomlSectionKeyLine {
        param(
            [string]$Text,
            [string]$Section,
            [string]$Key
        )

        $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
        if (-not $bounds) { return $null }
        $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
        $match = [regex]::Match($sectionText, ("(?m)^\s*{0}\s*=.*$" -f [regex]::Escape($Key)))
        if ($match.Success) { return $match.Value.Trim() }
        return $null
    }

    function Add-TomlTopLevelKeyIfMissing {
        param(
            [string]$Text,
            [string]$Key,
            [string]$Line
        )

        if (Get-TomlTopLevelKeyLine -Text $Text -Key $Key) { return $Text }
        if (-not $Text) { return $Line + "`n" }
        return $Line + "`n`n" + $Text.TrimStart()
    }

    function Add-TomlSectionKeyIfMissing {
        param(
            [string]$Text,
            [string]$Section,
            [string]$Key,
            [string]$Line
        )

        $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
        if ($bounds) {
            $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
            if ($sectionText -match ("(?m)^\s*{0}\s*=" -f [regex]::Escape($Key))) { return $Text }
            return $Text.Insert($bounds.BodyStart, $Line + "`n")
        }

        if ($Text -and -not $Text.EndsWith("`n")) { $Text += "`n" }
        return $Text + "`n[$Section]`n$Line`n"
    }

    function Set-TomlSectionBooleanTrue {
        param(
            [string]$Text,
            [string]$Section,
            [string]$Key
        )

        $line = "$Key = true"
        $bounds = Get-TomlSectionBounds -Text $Text -Section $Section
        if (-not $bounds) {
            if ($Text -and -not $Text.EndsWith("`n")) { $Text += "`n" }
            return $Text + "`n[$Section]`n$line`n"
        }

        $sectionText = $Text.Substring($bounds.BodyStart, $bounds.End - $bounds.BodyStart)
        $match = [regex]::Match($sectionText, ("(?m)^(\s*){0}\s*=\s*([^\r\n#]*)([^\r\n]*)(?:\r)?$" -f [regex]::Escape($Key)))
        if (-not $match.Success) { return $Text.Insert($bounds.BodyStart, $line + "`n") }

        if ($match.Groups[2].Value.Trim() -ceq "true") { return $Text }
        $tail = $match.Groups[3].Value
        $comment = ""
        if ($tail.TrimStart().StartsWith("#")) { $comment = " " + $tail.TrimStart() }
        $replacement = "$($match.Groups[1].Value)$Key = true$comment"
        $start = $bounds.BodyStart + $match.Index
        return $Text.Remove($start, $match.Length).Insert($start, $replacement)
    }

    $sourceText = Get-Content -LiteralPath $SourcePath -Raw -Encoding UTF8
    $fallbackLine = Get-TomlTopLevelKeyLine -Text $sourceText -Key "project_doc_fallback_filenames"
    if (-not $fallbackLine) { $fallbackLine = 'project_doc_fallback_filenames = [".codex/AGENTS.md"]' }
    $maxThreadsLine = Get-TomlSectionKeyLine -Text $sourceText -Section "agents" -Key "max_threads"
    if (-not $maxThreadsLine) { $maxThreadsLine = "max_threads = 8" }

    $current = ''
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        $current = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8
    }

    $text = $current
    $actions = @()

    $before = $text
    $text = Add-TomlTopLevelKeyIfMissing -Text $text -Key "project_doc_fallback_filenames" -Line $fallbackLine
    if ($text -ne $before) { $actions += "add top-level project_doc_fallback_filenames" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "multi_agent"
    if ($text -ne $before) { $actions += "set [features].multi_agent = true" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "hooks"
    if ($text -ne $before) { $actions += "set [features].hooks = true" }

    $before = $text
    $text = Add-TomlSectionKeyIfMissing -Text $text -Section "agents" -Key "max_threads" -Line $maxThreadsLine
    if ($text -ne $before) { $actions += "add [agents].max_threads default" }

    $merged = $text.TrimEnd() + "`n"
    if ($current -eq $merged) {
        Write-Step "Codex config.toml required keys already match section-aware defaults: $TargetPath"
        return [PSCustomObject]@{ Changed = $false; Actions = @(); TargetPath = $TargetPath }
    }

    if (-not $Apply) {
        Write-Warn "Codex config.toml would be updated ($($actions -join '; ')): $TargetPath"
        return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
    }

    $targetDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path -LiteralPath $targetDir)) { New-Item -ItemType Directory -Force -Path $targetDir | Out-Null }
    [System.IO.File]::WriteAllText($TargetPath, $merged, [System.Text.UTF8Encoding]::new($false))
    Write-Ok "Codex config.toml defaults merged ($($actions -join '; ')): $TargetPath"
    return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
}

function Invoke-SyncCodexProjectRules {
    param(
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Codex\.codex"
    $codexTargetRoot = Join-Path $ProjectRoot ".codex"
    $workflowSkillsRoot = Join-Path $RepoRoot "Codex\.agents\workflow-skills"
    $agentsRoot = Join-Path $ProjectRoot ".agents"
    $targetSkillsPath = Join-Path $agentsRoot "skills"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Codex\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"

    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $codexTargetRoot `
        -ScanDirs @(".") `
        -ProtectedDirs @() `
        -ExcludeFiles @("config.toml") `
        -PreserveProjectIdentity)
    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規則 (.codex/)" = { $true }
    }) -Platform "Codex"

    $skillDiffs = @(Get-SharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Codex Shared Skills" -Diffs $skillDiffs
    $workflowDiffs = @(Get-CodexWorkflowDiffs -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Codex Workflow Skills" -Diffs $workflowDiffs
    $governanceDiffs = @(Get-SharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot)
    Write-DiffSummary -Title "Codex Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agentsRoot)
    Write-DiffSummary -Title "Codex Project Tools" -Diffs $toolDiffs
    Set-ProjectVersionFile -Path (Join-Path $codexTargetRoot "VERSION") -Version $version -Apply:$Apply
    $null = Merge-CodexProjectConfigDefaults -SourcePath (Join-Path $sourceRoot "config.toml") -TargetPath (Join-Path $codexTargetRoot "config.toml") -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $codexTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $codexTargetRoot "AGENTS.md") `
        -Platform Codex `
        -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agentsRoot -Mode Diff
    if (Test-Path -LiteralPath $workflowSkillsRoot) {
        $null = Merge-WorkflowSkills -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath
    }
}

function Invoke-SyncProjectRules {
    Write-ManagerHeader "同步專案平台規則"
    $targetRoot = (Resolve-Path $Target).Path
    $sharedSkillsRoot = Join-Path $RepoRoot "Shared\skills"
    $contextTemplatesRoot = Join-Path (Split-Path $sharedSkillsRoot -Parent) "context"

    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "來源模式：$(if ($ManagedSource) { '使用者層管理快取（以遠端版本庫為準）' } else { '本機來源（不自動重設）' })"
    Write-Host "Target：$targetRoot"
    Write-Host "範圍：$ProjectPlatform"

    Assert-SourceSyncedForProjectSync

    Write-Host ""
    Write-Host "📊 Project Platform Selection"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $installed = @(Get-InstalledProjectPlatforms -TargetRoot $targetRoot)
    Write-Host "已安裝平台：$(if ($installed.Count -gt 0) { $installed -join ', ' } else { '無' })"

    $selected = @()
    if ($ProjectPlatform -eq "Auto") {
        $selected = $installed
    } elseif (Test-ProjectPlatformInstalled -TargetRoot $targetRoot -Platform $ProjectPlatform) {
        $selected = @($ProjectPlatform)
    } else {
        Write-ProjectSyncNoInstallWarning -TargetRoot $targetRoot -Platform $ProjectPlatform
        return
    }

    if ($selected.Count -eq 0) {
        Write-ProjectSyncNoInstallWarning -TargetRoot $targetRoot -Platform "任何支援平台"
        return
    }
    Write-Host "同步平台：$($selected -join ', ')"

    foreach ($platform in $selected) {
        switch ($platform) {
            "Antigravity" { Invoke-SyncAntigravityProjectRules -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
            "Claude"      { Invoke-SyncClaudeProjectRules -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
            "Codex"       { Invoke-SyncCodexProjectRules -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
        }
    }

    if (-not $Apply) {
        Write-Host ""
        Write-Host "Dry-run：未指定 -Apply，不會寫入目前專案規則。" -ForegroundColor Yellow
        return
    }

    $agentsRoot = Join-Path $targetRoot ".agents"
    Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot
    Set-GitignoreEntries -ProjectRoot $targetRoot -Lines @(".agents/logs/", ".cartridge/")
    Sync-ProjectSkillLinks -TargetRoot $targetRoot -Platforms $selected
    Write-Ok "目前專案規則同步完成：$($selected -join ', ')"
}

function Get-OrphanReports {
    param([string]$TargetRoot)

    $reports = @()
    $platforms = @(
        [PSCustomObject]@{
            Name = 'Antigravity'
            Source = Join-Path $RepoRoot 'Antigravity\.agents'
            Target = Join-Path $TargetRoot '.agents'
            ScanDirs = @('rules', 'workflows')
            ProtectedDirs = @('memory', 'project_skills', 'context')
        },
        [PSCustomObject]@{
            Name = 'Claude'
            Source = Join-Path $RepoRoot 'Claude\.claude'
            Target = Join-Path $TargetRoot '.claude'
            ScanDirs = @('commands', 'rules')
            ProtectedDirs = @()
        },
        [PSCustomObject]@{
            Name = 'Codex'
            Source = Join-Path $RepoRoot 'Codex\.codex'
            Target = Join-Path $TargetRoot '.codex'
            ScanDirs = @('.')
            ProtectedDirs = @()
        }
    )

    foreach ($platform in $platforms) {
        if (-not (Test-Path -LiteralPath $platform.Source) -or -not (Test-Path -LiteralPath $platform.Target)) { continue }
        $report = Get-UpgradeReport `
            -SourceRoot $platform.Source `
            -TargetRoot $platform.Target `
            -ScanDirs $platform.ScanDirs `
            -ProtectedDirs $platform.ProtectedDirs `
            -ExcludeFiles @()
        $reports += [PSCustomObject]@{
            Platform = $platform.Name
            TargetRoot = $platform.Target
            ProtectedDirs = $platform.ProtectedDirs
            Report = @($report)
            Orphans = @($report | Where-Object { $_.Status -eq 'ORPHAN' })
        }
    }

    return $reports
}

function Invoke-CleanupOrphans {
    Write-ManagerHeader "清理孤兒檔案"
    $targetRoot = (Resolve-Path $Target).Path
    $reports = Get-OrphanReports -TargetRoot $targetRoot
    $total = 0
    foreach ($entry in $reports) {
        $count = @($entry.Orphans).Count
        $total += $count
        Write-Host "$($entry.Platform)：$count 個孤兒檔案"
        foreach ($orphan in $entry.Orphans) {
            Write-Host "  [ORPHAN] $($orphan.Path)" -ForegroundColor Magenta
        }
    }

    if ($total -eq 0) {
        Write-Host "未偵測到孤兒檔案。" -ForegroundColor Green
        return
    }
    if (-not $Apply -or -not $RemoveOrphans) {
        Write-Host "Dry-run：未指定 -Apply -RemoveOrphans，不會刪除檔案。" -ForegroundColor Yellow
        return
    }

    foreach ($entry in $reports) {
        Remove-OrphanFiles -Report $entry.Report -TargetRoot $entry.TargetRoot -ProtectedDirs $entry.ProtectedDirs
    }
}

function Invoke-GitignoreMaintenance {
    Write-ManagerHeader "版控排除規則健檢"
    $targetRoot = (Resolve-Path $Target).Path
    Write-Host "Target：$targetRoot"
    Write-Host "模式：$(if ($GitignoreMode -in @('CleanSimilar', 'Overwrite')) { '刪除清單列出的相似規則，再補入帶繁中註解的 AI Rules 精準標準規則' } else { '只補入帶繁中註解的 AI Rules 精準標準規則，相似規則僅列出提醒' })"
    $null = Invoke-AiRulesGitignoreMaintenance -ProjectRoot $targetRoot -Mode $GitignoreMode -Apply:$Apply
}

function Invoke-MemoryMigration {
    Write-ManagerHeader "記憶主檔命名遷移"
    $targetRoot = (Resolve-Path $Target).Path
    Write-Host "用途：掃描 .agents/memory/ 內仍使用 SKILL.md 的作用中記憶卡主檔；預設只做 dry-run。"
    Write-Host "Target：$targetRoot"
    $null = Invoke-MemoryMainFileMigration -TargetRoot $targetRoot -Apply:$Apply -ConfirmApply:$Apply -WhatIf:$WhatIf
}

switch ($Action) {
    "Check"          { Invoke-Check }
    "Plan"           { Invoke-Plan }
    "Apply"          { Invoke-ApplyUpdate }
    "Doctor"         { Invoke-Doctor }
    "SyncGlobal"     { Invoke-SyncGlobal }
    "SyncProjectRules" { Invoke-SyncProjectRules }
    "CleanupOrphans" { Invoke-CleanupOrphans }
    "Gitignore"      { Invoke-GitignoreMaintenance }
    "MemoryMigration" { Invoke-MemoryMigration }
}
