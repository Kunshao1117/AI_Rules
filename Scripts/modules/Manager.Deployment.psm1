#Requires -Version 5.1

Import-Module (Join-Path $PSScriptRoot "Core.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "Memory-Migration.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "Manager.ProjectSync.psm1") -Force
function Write-ManagerHeader {
    param([string]$Title)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  AI Rules Manager — $Title" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
}

function Test-ManagerGitCommitExists {
    param(
        [string]$RepoRoot,
        [string]$Commit
    )

    if (-not $Commit -or $Commit -eq "unknown") { return $false }
    git -C $RepoRoot cat-file -e "${Commit}^{commit}" 2>$null
    return $LASTEXITCODE -eq 0
}

function Test-ManagerGitAncestor {
    param(
        [string]$RepoRoot,
        [string]$Ancestor,
        [string]$Descendant
    )

    if (-not (Test-ManagerGitCommitExists -RepoRoot $RepoRoot -Commit $Ancestor) -or -not (Test-ManagerGitCommitExists -RepoRoot $RepoRoot -Commit $Descendant)) {
        return $false
    }
    git -C $RepoRoot merge-base --is-ancestor $Ancestor $Descendant 2>$null
    return $LASTEXITCODE -eq 0
}

function Get-ManagerGitRelation {
    param(
        [string]$RepoRoot,
        [string]$Head,
        [string]$RemoteHead,
        [string]$RemoteTrackingHead
    )

    if ($Head -eq "unknown" -or $RemoteHead -eq "unknown") { return "Unknown" }
    if ($Head -eq $RemoteHead) { return "Synced" }

    if (Test-ManagerGitCommitExists -RepoRoot $RepoRoot -Commit $RemoteHead) {
        $remoteContainsLocal = Test-ManagerGitAncestor -RepoRoot $RepoRoot -Ancestor $Head -Descendant $RemoteHead
        $localContainsRemote = Test-ManagerGitAncestor -RepoRoot $RepoRoot -Ancestor $RemoteHead -Descendant $Head
        if ($remoteContainsLocal -and -not $localContainsRemote) { return "FastForward" }
        if ($localContainsRemote -and -not $remoteContainsLocal) { return "LocalAhead" }
        return "Diverged"
    }

    if ($RemoteTrackingHead -ne "unknown" -and $RemoteTrackingHead -ne $RemoteHead) {
        return "RemoteChanged"
    }
    return "RemoteChanged"
}

function Get-ManagerGitSnapshot {
    param([string]$RepoRoot)

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

    $relation = Get-ManagerGitRelation -RepoRoot $RepoRoot -Head $head -RemoteHead $remoteHead -RemoteTrackingHead $remoteTrackingHead

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

function Show-ManagerGitSnapshot {
    param(
        [string]$RepoRoot,
        [object]$Snapshot,
        [switch]$ManagedSource
    )

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
        "Synced"        { Write-Host "狀態：已同步" -ForegroundColor Green }
        "FastForward"   { Write-Host "狀態：可快轉更新" -ForegroundColor Yellow }
        "Diverged"      { Write-Host "狀態：來源庫分叉" -ForegroundColor Red }
        "LocalAhead"    { Write-Host "狀態：本機領先遠端" -ForegroundColor Yellow }
        "RemoteChanged" { Write-Host "狀態：偵測到遠端更新（尚未能確認是否可快轉）" -ForegroundColor Yellow }
        default           { Write-Host "狀態：無法判斷來源庫狀態" -ForegroundColor Yellow }
    }
}

function Assert-ManagerSourceSyncedForProjectSync {
    param(
        [string]$RepoRoot,
        [switch]$ManagedSource
    )

    $snapshot = Get-ManagerGitSnapshot -RepoRoot $RepoRoot
    if (($snapshot.DirtyCount -eq 0) -and ($snapshot.Relation -eq "Synced")) {
        return
    }

    Write-Host ""
    Write-Host "📊 AI_Rules Source Freshness"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
    if ($ManagedSource) {
        Write-Fail "專案規則同步已停止：AI_Rules 管理快取未能對齊遠端版本庫；不使用舊快取同步專案。"
    } else {
        Write-Fail "專案規則同步已停止：目前指定的 AI_Rules 本機來源尚未對齊遠端版本庫；請先整理或更新來源後再同步。"
    }
    exit 1
}

function Invoke-ManagerCheck {
    param(
        [string]$RepoRoot,
        [switch]$ManagedSource
    )

    Write-ManagerHeader "檢查 AI_Rules 來源狀態"
    Write-Host "用途：讀取 AI_Rules 來源版本庫的 Git 狀態與版本關係；不寫入目前專案，也不解析規範、技能、文件、記憶、hook、設定或來源內容。"
    $snapshot = Get-ManagerGitSnapshot -RepoRoot $RepoRoot
    Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
}

function Invoke-ManagerPlan {
    param(
        [string]$RepoRoot,
        [switch]$ManagedSource
    )

    Write-ManagerHeader "查看 AI_Rules 來源更新影響"
    $snapshot = Get-ManagerGitSnapshot -RepoRoot $RepoRoot
    Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
    Write-Host ""
    Write-Host "來源庫更新計畫"
    if ($ManagedSource) {
        Write-Host "- 目前來源是使用者層管理快取；插件會先把快取對齊遠端版本庫，再執行管理腳本。"
        Write-Host "- 若快取無法對齊遠端，流程會停止，不會用舊快取巡檢或同步專案規則。"
    } else {
        Write-Host "- 目前來源是本機來源；工具只檢查狀態，不會自動重設本機變更。"
        Write-Host "- 若有遠端更新，更新動作只會嘗試快轉更新，不會重設本機變更。"
    }
    Write-Host "- 套用只會對齊來源庫並回報 Git 狀態；不會解析規範、技能、文件、記憶、hook、設定或來源內容。"
    Write-Host "- 這不會安裝新版 VSIX，也不會同步目前專案的 .agents / .claude / .codex。"
    Write-Host "- 全域規則、專案規則與孤兒檔案仍需另外按鈕確認，不會在 Plan 階段修改。"
    if ($snapshot.DirtyCount -gt 0) {
        Write-Host ""
        Write-Host "目前工作樹不是乾淨狀態，建議先檢查以下變更：" -ForegroundColor Yellow
        $snapshot.DirtyFiles | ForEach-Object { Write-Host "  $_" }
    }
}

function Invoke-ManagerApplyUpdate {
    param(
        [string]$RepoRoot,
        [switch]$Apply,
        [switch]$ManagedSource,
        [switch]$WhatIf
    )

    Write-ManagerHeader "更新 AI_Rules 來源庫"
    if ($WhatIf) {
        if ($ManagedSource) {
            Write-Host "WhatIf：插件會先對齊 AI_Rules 遠端來源鏡像；不安裝 VSIX，也不同步目前專案規則。"
        } else {
            Write-Host "WhatIf：將檢查本機 AI_Rules 來源並嘗試快轉更新；不安裝 VSIX，也不同步目前專案規則。"
        }
        return
    }
    if (-not $Apply) {
        Write-Host "未指定 -Apply，拒絕寫入。請由 VS Code 確認視窗或命令明確授權後再執行。" -ForegroundColor Yellow
        exit 2
    }
    $snapshot = Get-ManagerGitSnapshot -RepoRoot $RepoRoot
    if ($snapshot.DirtyCount -gt 0) {
        Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
        Write-Fail "來源庫更新失敗：工作樹有變更；已停止。"
        exit 1
    }
    if ($snapshot.Relation -eq "Diverged") {
        Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
        Write-Fail "來源庫更新失敗：來源庫分叉；已停止。"
        exit 1
    }
    if ($snapshot.Relation -eq "LocalAhead") {
        Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
        Write-Fail "來源庫更新失敗：本機領先遠端；已停止。"
        exit 1
    }
    if ($ManagedSource) {
        if ($snapshot.Relation -ne "Synced") {
            Show-ManagerGitSnapshot -RepoRoot $RepoRoot -Snapshot $snapshot -ManagedSource:$ManagedSource
            Write-Fail "來源庫更新失敗：AI_Rules 管理快取未能對齊遠端版本庫；已停止。"
            exit 1
        }
        return
    }
    git -C $RepoRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "來源庫更新失敗：無法快轉或 Git 回報錯誤；已停止。"
        exit 1
    }
}

function Invoke-ManagerSyncGlobal {
    param(
        [string]$RepoRoot,
        [string]$ProfileRoot,
        [switch]$Apply
    )

    Write-ManagerHeader "同步使用者層規則"
    $deploy = Join-Path $RepoRoot "Scripts\Deploy.ps1"
    if ($Apply) {
        & $deploy -Action Global -ProfileRoot $ProfileRoot -Apply
    } else {
        & $deploy -Action Global -ProfileRoot $ProfileRoot
    }
}

function Invoke-ManagerSyncProjectRules {
    param(
        [string]$RepoRoot,
        [string]$Target,
        [ValidateSet("Auto", "Codex", "Claude", "Antigravity")]
        [string]$ProjectPlatform,
        [switch]$Apply,
        [switch]$ManagedSource
    )

    $writeHeaderAction = {
        param([string]$Title)
        Write-ManagerHeader -Title $Title
    }
    $assertSourceSyncedAction = {
        param(
            [string]$SourceRoot,
            [switch]$SourceManaged
        )

        Assert-ManagerSourceSyncedForProjectSync -RepoRoot $SourceRoot -ManagedSource:$SourceManaged
    }

    return Invoke-ManagerProjectRulesSync `
        -RepoRoot $RepoRoot `
        -Target $Target `
        -ProjectPlatform $ProjectPlatform `
        -Apply:$Apply `
        -ManagedSource:$ManagedSource `
        -WriteHeaderAction $writeHeaderAction `
        -AssertSourceSyncedAction $assertSourceSyncedAction
}

function Get-ManagerOrphanReports {
    param(
        [string]$RepoRoot,
        [string]$TargetRoot
    )

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

function Invoke-ManagerCleanupOrphans {
    param(
        [string]$RepoRoot,
        [string]$Target,
        [switch]$Apply,
        [switch]$RemoveOrphans
    )

    Write-ManagerHeader "清理孤兒檔案"
    $targetRoot = (Resolve-Path $Target).Path
    $reports = Get-ManagerOrphanReports -RepoRoot $RepoRoot -TargetRoot $targetRoot
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

function Invoke-ManagerGitignoreMaintenance {
    param(
        [string]$Target,
        [ValidateSet("Append", "CleanSimilar", "Overwrite")]
        [string]$GitignoreMode,
        [switch]$Apply
    )

    Write-ManagerHeader "版控排除規則健檢"
    $targetRoot = (Resolve-Path $Target).Path
    Write-Host "Target：$targetRoot"
    Write-Host "模式：$(if ($GitignoreMode -in @('CleanSimilar', 'Overwrite')) { '刪除清單列出的相似規則，再補入帶繁中註解的 AI Rules 精準標準規則' } else { '只補入帶繁中註解的 AI Rules 精準標準規則，相似規則僅列出提醒' })"
    $null = Invoke-AiRulesGitignoreMaintenance -ProjectRoot $targetRoot -Mode $GitignoreMode -Apply:$Apply
}

function Invoke-ManagerMemoryMigration {
    param(
        [string]$Target,
        [switch]$Apply,
        [switch]$WhatIf
    )

    Write-ManagerHeader "記憶主檔命名遷移"
    $targetRoot = (Resolve-Path $Target).Path
    Write-Host "用途：掃描 .agents/memory/ 內仍使用 SKILL.md 的作用中記憶卡主檔；預設只做 dry-run。"
    Write-Host "Target：$targetRoot"
    $null = Invoke-MemoryMainFileMigration -TargetRoot $targetRoot -Apply:$Apply -ConfirmApply:$Apply -WhatIf:$WhatIf
}

Export-ModuleMember -Function @(
    'Invoke-ManagerCheck',
    'Invoke-ManagerPlan',
    'Invoke-ManagerApplyUpdate',
    'Invoke-ManagerSyncGlobal',
    'Invoke-ManagerSyncProjectRules',
    'Invoke-ManagerCleanupOrphans',
    'Invoke-ManagerGitignoreMaintenance',
    'Invoke-ManagerMemoryMigration'
)
