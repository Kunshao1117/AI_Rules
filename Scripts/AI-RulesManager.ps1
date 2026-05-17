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
    [ValidateSet("Check", "Plan", "Apply", "Doctor", "SyncGlobal", "CleanupOrphans")]
    [string]$Action = "Check",

    [string]$RepoRoot,

    [string]$Target = $PWD.Path,

    [string]$ProfileRoot = $env:USERPROFILE,

    [switch]$Apply,

    [switch]$RemoveOrphans,

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
    Write-ManagerHeader "檢查更新"
    $snapshot = Get-GitSnapshot
    Show-GitSnapshot -Snapshot $snapshot
    $null = Measure-RuntimeGlobalDrift -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
}

function Invoke-Plan {
    Write-ManagerHeader "查看更新內容"
    $snapshot = Get-GitSnapshot
    Show-GitSnapshot -Snapshot $snapshot
    Write-Host ""
    Write-Host "更新計畫"
    Write-Host "- 若有遠端更新，套用時會執行 git pull --ff-only。"
    Write-Host "- 套用後會重新執行平台代理治理巡檢。"
    Write-Host "- 全域規則與孤兒檔案仍需另外按鈕確認，不會在 Plan 階段修改。"
    if ($snapshot.DirtyCount -gt 0) {
        Write-Host ""
        Write-Host "目前工作樹不是乾淨狀態，建議先檢查以下變更：" -ForegroundColor Yellow
        $snapshot.DirtyFiles | ForEach-Object { Write-Host "  $_" }
    }
}

function Invoke-ApplyUpdate {
    Write-ManagerHeader "套用更新"
    if ($WhatIf) {
        Write-Host "WhatIf：將執行 git pull --ff-only，然後執行治理巡檢。"
        return
    }
    if (-not $Apply) {
        Write-Host "未指定 -Apply，拒絕寫入。請由 VS Code 確認視窗或命令明確授權後再執行。" -ForegroundColor Yellow
        exit 2
    }
    git -C $RepoRoot pull --ff-only
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
    if (-not $audit.Passed) { exit 1 }
}

function Invoke-Doctor {
    Write-ManagerHeader "健康檢查"
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot
    if (-not $audit.Passed) { exit 1 }
}

function Invoke-SyncGlobal {
    Write-ManagerHeader "同步全域規則"
    $deploy = Join-Path $RepoRoot "Scripts\Deploy.ps1"
    if ($Apply) {
        & $deploy -Action Global -ProfileRoot $ProfileRoot -Apply
    } else {
        & $deploy -Action Global -ProfileRoot $ProfileRoot
    }
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
    "CleanupOrphans" { Invoke-CleanupOrphans }
}
