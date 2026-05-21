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
    [ValidateSet("Check", "Plan", "Apply", "Doctor", "SyncGlobal", "SyncProjectRules", "CleanupOrphans")]
    [string]$Action = "Check",

    [string]$RepoRoot,

    [string]$Target = $PWD.Path,

    [string]$ProfileRoot = $env:USERPROFILE,

    [switch]$Apply,

    [switch]$RemoveOrphans,

    [ValidateSet("Auto", "Codex", "Claude", "Antigravity")]
    [string]$ProjectPlatform = "Auto",

    [switch]$WhatIf
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
    $dirty = @()

    try { $head = (git -C $RepoRoot rev-parse HEAD 2>$null).Trim() } catch { }
    try { $branch = (git -C $RepoRoot branch --show-current 2>$null).Trim() } catch { }
    try {
        $remoteLine = git -C $RepoRoot ls-remote origin "refs/heads/$branch" 2>$null | Select-Object -First 1
        if ($remoteLine) { $remoteHead = (($remoteLine -split "\s+")[0]).Trim() }
    } catch { }
    try { $dirty = @(git -C $RepoRoot status --short 2>$null) } catch { }

    return [PSCustomObject]@{
        Branch     = $branch
        Head       = $head
        RemoteHead = $remoteHead
        DirtyCount = $dirty.Count
        DirtyFiles = $dirty
        HasUpdate  = ($head -ne "unknown") -and ($remoteHead -ne "unknown") -and ($head -ne $remoteHead)
    }
}

function Show-GitSnapshot {
    param([object]$Snapshot)
    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "Branch：$($Snapshot.Branch)"
    Write-Host "Local HEAD：$($Snapshot.Head)"
    Write-Host "Remote HEAD：$($Snapshot.RemoteHead)"
    Write-Host "工作樹變更：$($Snapshot.DirtyCount)"
    if ($Snapshot.HasUpdate) {
        Write-Host "狀態：偵測到遠端更新" -ForegroundColor Yellow
    } else {
        Write-Host "狀態：未偵測到遠端更新" -ForegroundColor Green
    }
}

function Invoke-Check {
    Write-ManagerHeader "檢查 AI_Rules 來源狀態"
    Write-Host "用途：讀取 AI_Rules 管理來源庫的 Git 狀態，並檢查使用者層全域規則漂移；不寫入檔案。"
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
    Write-Host "- 若有遠端更新，更新 AI_Rules 來源庫時會執行 git pull --ff-only。"
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
        Write-Host "WhatIf：將對 AI_Rules 管理來源庫執行 git pull --ff-only，然後執行治理巡檢；不安裝 VSIX，也不同步目前專案規則。"
        return
    }
    if (-not $Apply) {
        Write-Host "未指定 -Apply，拒絕寫入。請由 VS Code 確認視窗或命令明確授權後再執行。" -ForegroundColor Yellow
        exit 2
    }
    git -C $RepoRoot pull --ff-only
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target
    if (-not $audit.Passed) { exit 1 }
}

function Invoke-Doctor {
    Write-ManagerHeader "治理巡檢 Doctor"
    Write-Host "用途：檢查 Shared Skill 品質、workflow metadata、policy marker、子代理語彙、全域規則漂移與 project skill links；不寫入檔案。"
    $null = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target
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
            -not ($relPath -match '^_memory[\\\/]') -and
            -not ($relPath -match '^_project[\\\/]') -and
            -not ($relPath -match '^project-')
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
        ForEach-Object {
            $rel = $_.FullName.Substring($WorkflowSkillsPath.Length).TrimStart('\', '/')
            $targetFile = Join-Path $TargetSkillsPath $rel
            $diff = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $targetFile -RelativePath $rel
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
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $agTargetRoot `
        -ScanDirs @("rules", "workflows") `
        -ProtectedDirs @("memory", "project_skills") `
        -ExcludeFiles @() `
        -PreserveProjectIdentity)

    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規範 (.agents/rules)" = { $_.Path -like "rules/*" -or $_.Path -like "rules\*" }
        "工作流程 (.agents/workflows)" = { $_.Path -like "workflows/*" -or $_.Path -like "workflows\*" }
        "專案記憶 — 受保護" = { $_.Path -like "memory/*" -or $_.Path -like "memory\*" }
        "專案技能 — 受保護" = { $_.Path -like "project_skills/*" -or $_.Path -like "project_skills\*" }
    }) -Platform "Antigravity"

    $targetSkillsPath = Join-Path $agTargetRoot "skills"
    $skillDiffs = @(Get-SharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Antigravity Shared Skills" -Diffs $skillDiffs
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
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"

    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $codexTargetRoot `
        -ScanDirs @(".") `
        -ProtectedDirs @() `
        -ExcludeFiles @() `
        -PreserveProjectIdentity)
    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規則 (.codex/)" = { $true }
    }) -Platform "Codex"

    $skillDiffs = @(Get-SharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Codex Shared Skills" -Diffs $skillDiffs
    $workflowDiffs = @(Get-CodexWorkflowDiffs -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-DiffSummary -Title "Codex Workflow Skills" -Diffs $workflowDiffs
    Set-ProjectVersionFile -Path (Join-Path $codexTargetRoot "VERSION") -Version $version -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $codexTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $codexTargetRoot "AGENTS.md") `
        -Platform Codex `
        -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    if (Test-Path -LiteralPath $workflowSkillsRoot) {
        $null = Merge-WorkflowSkills -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath
    }
}

function Invoke-SyncProjectRules {
    Write-ManagerHeader "同步專案平台規則"
    $targetRoot = (Resolve-Path $Target).Path
    $sharedSkillsRoot = Join-Path $RepoRoot "Shared\skills"

    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "Target：$targetRoot"
    Write-Host "範圍：$ProjectPlatform"

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
            ProtectedDirs = @('memory', 'project_skills')
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

switch ($Action) {
    "Check"          { Invoke-Check }
    "Plan"           { Invoke-Plan }
    "Apply"          { Invoke-ApplyUpdate }
    "Doctor"         { Invoke-Doctor }
    "SyncGlobal"     { Invoke-SyncGlobal }
    "SyncProjectRules" { Invoke-SyncProjectRules }
    "CleanupOrphans" { Invoke-CleanupOrphans }
}
