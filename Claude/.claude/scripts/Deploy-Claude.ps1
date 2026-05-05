#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Claude Edition — 實際部署腳本
.DESCRIPTION
    將 Claude Code 版 Antigravity 框架部署到目標專案。
    支援 Fresh（全新安裝）與 Upgrade（預掃描→確認→執行）兩種模式。
    此腳本由 install.ps1 啟動器呼叫，不應直接執行。
.PARAMETER Target
    目標專案的絕對路徑（例如：D:\MyProject）
.PARAMETER Mode
    部署模式：Fresh（預設）或 Upgrade
.PARAMETER RemoveOrphans
    是否移除目標中已不存在於源碼的孤兒檔案（僅 Upgrade 模式有效）
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Target,
    [ValidateSet("Fresh", "Upgrade")]
    [string]$Mode = "Fresh",
    [switch]$RemoveOrphans
)

$ErrorActionPreference = "Stop"  # 任何錯誤都立即中斷（PowerShell 的嚴格模式）

# ── 路徑初始化 ─────────────────────────────────────────────────────────────────
# $PSScriptRoot 是此腳本所在目錄（.claude/scripts/），往上兩層就是框架根目錄（Claude/）
$SourceRoot    = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# $srcDotClaude — 框架源碼中的 .claude/ 目錄（包含 commands/skills/rules 等）
$srcDotClaude  = Join-Path $SourceRoot ".claude"

# 動態讀取版本號（從 .claude/VERSION 檔案取得，例如 "1.2.0"）
$versionFile = Join-Path $srcDotClaude "VERSION"
$FrameworkVersion = if (Test-Path $versionFile) { (Get-Content $versionFile -Raw).Trim() } else { "unknown" }

# ─── 輔助輸出函式 ──────────────────────────────────────────────────────────────
function Write-Step { param([string]$Msg) Write-Host "  → $Msg" -ForegroundColor Cyan }    # 進度步驟（青色）
function Write-Ok   { param([string]$Msg) Write-Host "  ✓ $Msg" -ForegroundColor Green }   # 成功訊息（綠色）
function Write-Warn { param([string]$Msg) Write-Host "  ⚠ $Msg" -ForegroundColor Yellow }  # 警告訊息（黃色）
function Write-Fail { param([string]$Msg) Write-Host "  ✗ $Msg" -ForegroundColor Red }

# ─── 衍生技能命名空間連結 Backfill（冪等）──────────────────────────────────────
function Invoke-ProjectSkillBackfill {
    <#
    .SYNOPSIS
        掃描 .agents/project_skills/ 目錄，自動補建缺少的符號連結。
        符號連結的作用是讓 AI 在 skills/ 目錄下也能「看到」衍生技能。
        此函式是冪等的（重複執行不會重複建立）。
    #>
    param([string]$AgentsRoot)  # 目標專案的 .agents/ 絕對路徑
    $skillsDir = Join-Path $AgentsRoot 'skills'          # 核心技能目錄
    $projDir   = Join-Path $AgentsRoot 'project_skills'  # 衍生技能目錄
    if (-not (Test-Path $projDir)) { return }  # 不存在就結束
    $count = 0
    # 逐一檢查 project_skills/ 底下的每個子目錄
    Get-ChildItem $projDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        # 在 skills/ 底下建立「project-技能名」符號連結，指向衍生技能
        $linkPath = Join-Path $skillsDir "project-$($_.Name)"
        if (-not (Test-Path $linkPath)) {
            New-Item -ItemType SymbolicLink -Path $linkPath -Target $_.FullName -ErrorAction SilentlyContinue | Out-Null
            Write-Ok "衍生技能符號連結已建立: project-$($_.Name)"
            $count++
        }
    }
    if ($count -eq 0) { Write-Step "衍生技能命名空間連結已是最新，無需補建。" }
}

# ─── 單檔比對 ──────────────────────────────────────────────────────────────────
function Compare-ClaudeFile {
    <#
    .SYNOPSIS
        比對「來源」與「目標」的同一個檔案是否有差異。
        回傳狀態：NEW（目標不存在）/ SAME（完全相同）/ CHANGED（內容有變）
    .NOTES
        效能最佳化：先比「修改時間」，只有時間不同時才計算 SHA256 雜湊值。
    #>
    param(
        [string]$SourcePath,    # 來源檔案的完整路徑
        [string]$TargetPath,    # 目標檔案的完整路徑
        [string]$RelativePath   # 相對路徑（用於報告顯示）
    )

    # 如果目標檔案不存在，代表是全新檔案
    if (-Not (Test-Path $TargetPath)) {
        return [PSCustomObject]@{ Status = "NEW"; Path = $RelativePath }
    }
    # 第一層篩選：比較「最後修改時間」（速度最快）
    $srcTime = (Get-Item $SourcePath).LastWriteTime
    $tgtTime = (Get-Item $TargetPath).LastWriteTime
    if ($srcTime -eq $tgtTime) {
        return [PSCustomObject]@{ Status = "SAME"; Path = $RelativePath }
    }
    # 第二層篩選：時間不同時，計算 SHA256 雜湊值做精確比對
    $srcHash = (Get-FileHash $SourcePath  -Algorithm SHA256).Hash
    $tgtHash = (Get-FileHash $TargetPath  -Algorithm SHA256).Hash
    if ($srcHash -eq $tgtHash) {
        # 雖然修改時間不同，但內容完全相同（可能只是被觸碰過）
        return [PSCustomObject]@{ Status = "SAME"; Path = $RelativePath }
    }
    # 時間不同、內容也不同 → 確認是有變更的檔案
    return [PSCustomObject]@{ Status = "CHANGED"; Path = $RelativePath }
}

# ─── 全量掃描，產出差異報告 ────────────────────────────────────────────────────
function Get-UpgradeReport {
    param([string]$SrcClaude, [string]$DstClaude)

    $results = @()
    $scanDirs = @("commands", "skills", "rules", "scripts")

    # 來源 → 目標 差異偵測
    foreach ($dir in $scanDirs) {
        $srcDir = Join-Path $SrcClaude $dir
        if (-Not (Test-Path $srcDir)) { continue }

        Get-ChildItem $srcDir -File -Recurse | ForEach-Object {
            # 排除不應部署的檔案（部署腳本本身 + 本地設定檔）
            if ($_.Name -eq "Deploy-Claude.ps1")   { return }
            if ($_.Name -eq "settings.local.json")  { return }

            # 從絕對路徑截取相對路徑（例如 commands\04_fix\全檔.md）
            $rel     = $_.FullName.Substring($SrcClaude.Length + 1)
            $tgtFile = Join-Path $DstClaude $rel
            $results += Compare-ClaudeFile -SourcePath $_.FullName -TargetPath $tgtFile -RelativePath $rel
        }
    }

    # ── 反向掃描：目標 → 來源（孤兒偵測）──
    # 「孤兒」= 目標專案裡有，但框架源碼已刪除的檔案
    foreach ($dir in $scanDirs) {
        $dstDir = Join-Path $DstClaude $dir
        if (-Not (Test-Path $dstDir)) { continue }

        Get-ChildItem $dstDir -File -Recurse | ForEach-Object {
            $rel     = $_.FullName.Substring($DstClaude.Length + 1)
            $srcFile = Join-Path $SrcClaude $rel

            if ($rel -like "agents\*")       { return }  # 官方 Claude Code 管理目錄
            if ($rel -eq "VERSION")          { return }  # 動態寫入，不算孤兒

            if (-Not (Test-Path $srcFile)) {
                $results += [PSCustomObject]@{ Status = "ORPHAN"; Path = $rel }
            }
        }
    }

    return $results
}

# ─── 格式化輸出差異報告 ────────────────────────────────────────────────────────
function Write-UpgradeReport {
    <#
    .SYNOPSIS
        將 Get-UpgradeReport 的報告結果格式化輸出到終端機。
        依類別分組顯示（指令/技能/規範/腳本），並統計各狀態數量。
    #>
    param([array]$Report)  # Get-UpgradeReport 回傳的報告陣列

    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+08:00")

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan
    Write-Host "  升級差異報告 — $timestamp" -ForegroundColor DarkCyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    # 將報告依「路徑前綴」分成四大類
    $categories = @{
        "COMMANDS" = $Report | Where-Object { $_.Path -like "commands\*" -or $_.Path -like "commands/*" }  # 工作流指令
        "SKILLS"   = $Report | Where-Object { $_.Path -like "skills\*"   -or $_.Path -like "skills/*" }    # 操作技能
        "RULES"    = $Report | Where-Object { $_.Path -like "rules\*"    -or $_.Path -like "rules/*" }      # 治理規範
        "SCRIPTS"  = $Report | Where-Object { $_.Path -like "scripts\*"  -or $_.Path -like "scripts/*" }    # 工具腳本
    }

    # 每個類別的中文顯示名稱
    $displayNames = @{
        "COMMANDS" = "工作流指令 (Commands)"
        "SKILLS"   = "操作技能 (Skills)"
        "RULES"    = "治理規範 (Rules)"
        "SCRIPTS"  = "工具腳本 (Scripts)"
    }

    # 各狀態對應的顯示顏色
    $statusColors = @{
        "NEW"     = "Green"     # 綠色：新增
        "CHANGED" = "Yellow"    # 黃色：變更
        "SAME"    = "DarkGray"  # 灰色：相同
        "ORPHAN"  = "Magenta"   # 紫色：孤兒
    }

    # 依序輸出每個類別
    foreach ($cat in @("COMMANDS", "SKILLS", "RULES", "SCRIPTS")) {
        $items = $categories[$cat]
        if ($null -eq $items -or @($items).Count -eq 0) { continue }  # 空的類別跳過

        Write-Host ""
        Write-Host "  $($displayNames[$cat])" -ForegroundColor White
        Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkGray

        # 依狀態排序：新增 → 變更 → 孤兒 → 相同
        $sorted = @($items) | Sort-Object {
            switch ($_.Status) { "NEW" { 0 } "CHANGED" { 1 } "ORPHAN" { 2 } "SAME" { 3 } }
        }
        foreach ($item in $sorted) {
            $color = $statusColors[$item.Status]
            $tag   = "[$($item.Status)]".PadRight(10)  # 狀態標籤右側補空白對齊
            Write-Host "  $tag $($item.Path)" -ForegroundColor $color
        }
    }

    # 統計各狀態的數量
    $newCount    = @($Report | Where-Object { $_.Status -eq "NEW" }).Count
    $changedCount= @($Report | Where-Object { $_.Status -eq "CHANGED" }).Count
    $sameCount   = @($Report | Where-Object { $_.Status -eq "SAME" }).Count
    $orphanCount = @($Report | Where-Object { $_.Status -eq "ORPHAN" }).Count

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan
    Write-Host "  新增: $newCount | 變更: $changedCount | 相同: $sameCount | 孤兒: $orphanCount" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    return @{ New = $newCount; Changed = $changedCount; Same = $sameCount; Orphan = $orphanCount }
}

# ─── 執行更新：只寫入 NEW / CHANGED 的檔案 ────────────────────────────────────
function Install-Upgrade {
    <#
    .SYNOPSIS
        執行實際的檔案更新。只複製狀態為 NEW 或 CHANGED 的檔案，
        跳過所有 SAME / ORPHAN 的檔案。
    #>
    param(
        [array]$Report,      # Get-UpgradeReport 回傳的報告陣列
        [string]$SrcClaude,   # 來源的 .claude/ 目錄
        [string]$DstClaude    # 目標的 .claude/ 目錄
    )
    $applied = 0  # 計算實際更新了幾個檔案
    foreach ($item in $Report) {
        # 只處理新增和變更的檔案，其他狀態跳過
        if ($item.Status -notin @("NEW", "CHANGED")) { continue }
        $srcFile = Join-Path $SrcClaude $item.Path
        $dstFile = Join-Path $DstClaude $item.Path
        # 如果目標資料夾不存在，先建立它
        $dstDir  = Split-Path $dstFile -Parent
        if (-Not (Test-Path $dstDir)) { New-Item -ItemType Directory $dstDir -Force | Out-Null }
        # 複製檔案（覆寫目標）
        Copy-Item $srcFile $dstFile -Force
        $verb = if ($item.Status -eq "NEW") { "已建立" } else { "已更新" }
        Write-Ok "${verb}: $($item.Path)"
        $applied++
    }
    return $applied  # 回傳更新數量
}

# ─── 擷取 CHANGELOG 中兩個版本之間的更新說明 ──────────────────────────────────
function Get-ReleaseNotes {
    <#
    .SYNOPSIS
        擷取 CHANGELOG.md 中最新的更新說明區段。
        從第一個 "## " 標題開始讀，讀到第二個 "## " 標題就停止。
    #>
    param(
        [string]$ChangelogPath,  # CHANGELOG.md 的完整路徑
        [string]$FromVersion     # 目標專案的當前版本（目前未使用，保留供未來精確篩選）
    )

    # 如果檔案不存在，回傳空陣列
    if (-Not (Test-Path $ChangelogPath)) { return @() }

    $lines     = Get-Content $ChangelogPath
    $capturing = $false  # 是否正在擷取內容
    $notes     = @()     # 收集擷取的行

    foreach ($line in $lines) {
        # 匹配 ## [YYYY-MM-DD] 或 ## vX.Y.Z 格式的版本標題
        if ($line -match "^## ") {
            if ($capturing) { break }   # 已讀完最新區段，停止
            $capturing = $true
            continue
        }
        if ($capturing) { $notes += $line }
    }

    return $notes
}

# ─── 驗證目標路徑 ─────────────────────────────────────────────────────────────
if (-not (Test-Path $Target)) {
    Write-Fail "目標路徑不存在：$Target"
    exit 1
}

# ── 主流程變數初始化 ───────────────────────────────────────────────────────────
$isUpgrade     = $Mode -eq "Upgrade"                   # 是否為升級模式
$dstDotClaude  = Join-Path $Target ".claude"            # 目標專案的 .claude/ 目錄
$agentsRoot    = Join-Path $Target ".agents"            # 目標專案的 .agents/ 目錄（共用記憶庫）
$sharedMemory  = Join-Path $agentsRoot "memory"         # 專案記憶卡目錄
$sharedProject = Join-Path $agentsRoot "project_skills" # 衍生技能目錄

# 如果目標還沒有 .claude/ 資料夾，自動切換為 Fresh 模式
if ($isUpgrade -and -not (Test-Path $dstDotClaude)) {
    Write-Warn "目標專案尚未安裝 Claude 版 Antigravity，切換為 Fresh 模式。"
    $isUpgrade = $false
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  Antigravity Claude Edition v$FrameworkVersion — 部署引擎" -ForegroundColor Magenta
Write-Host "  模式: $($isUpgrade ? 'Upgrade' : 'Fresh') | 目標: $Target" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""

# ============================================================
# Upgrade 模式：預掃描 → 報告 → 確認 → 執行
# ============================================================

if ($isUpgrade) {
    # 讀取目標版本
    $dstVersionFile   = Join-Path $dstDotClaude "VERSION"
    $targetVersion    = if (Test-Path $dstVersionFile) { (Get-Content $dstVersionFile -Raw).Trim() } else { "未知" }

    Write-Step "版本：v$targetVersion → v$FrameworkVersion"
    Write-Step "正在掃描 .claude/ 差異..."

    $report = Get-UpgradeReport -SrcClaude $srcDotClaude -DstClaude $dstDotClaude
    $stats  = Write-UpgradeReport -Report $report

    # 顯示 CHANGELOG 最新區段
    $changelogPath = Join-Path $SourceRoot "CHANGELOG.md"
    $releaseNotes  = Get-ReleaseNotes -ChangelogPath $changelogPath -FromVersion $targetVersion
    if ($releaseNotes.Count -gt 0) {
        Write-Host ""
        Write-Host "  📋 最新版本更新說明" -ForegroundColor White
        Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkGray
        foreach ($noteLine in $releaseNotes) { Write-Host "  $noteLine" }
    }

    # 確認閘門
    $applied = 0
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        Write-Host ""
        $confirm = Read-Host "  是否套用上述變更？(Y/N)"
        if ($confirm -match "^[Yy]$") {
            Write-Step "正在套用變更..."
            $applied = Install-Upgrade -Report $report -SrcClaude $srcDotClaude -DstClaude $dstDotClaude
        } else {
            Write-Warn "已跳過框架檔案更新。"
        }
    } else {
        Write-Ok "所有 .claude/ 檔案均已是最新版本，無需更新。"
    }

    # 孤兒檔案處理：如果有孤兒且使用者有加 -RemoveOrphans 參數，就實際刪除
    if ($stats.Orphan -gt 0) {
        if ($RemoveOrphans) {
            Write-Step "正在清除 $($stats.Orphan) 個孤兒檔案..."
            $orphanList = $report | Where-Object { $_.Status -eq "ORPHAN" }
            foreach ($item in $orphanList) {
                $orphanPath = Join-Path $dstDotClaude $item.Path
                if (Test-Path $orphanPath) {
                    Remove-Item $orphanPath -Force -ErrorAction SilentlyContinue
                    Write-Ok "已刪除孤兒: $($item.Path)"
                }
            }
            # 清理刪除後留下的空資料夾（從最深層往上清）
            Get-ChildItem $dstDotClaude -Directory -Recurse |
                Sort-Object { $_.FullName.Length } -Descending |
                ForEach-Object {
                    if (@(Get-ChildItem $_.FullName -Force).Count -eq 0) {
                        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                    }
                }
            Write-Ok "孤兒檔案清除完成。"
        } else {
            Write-Warn "$($stats.Orphan) 個孤兒檔案（源碼已刪除但目標仍存在），加入 -RemoveOrphans 可自動清除。"
        }
    }

    # 基礎設施確保（不受確認閘門影響，每次 Upgrade 都會執行）
    # 確保 .agents/memory/ 和 .agents/project_skills/ 目錄存在
    if (-not (Test-Path $sharedMemory))  { New-Item -ItemType Directory $sharedMemory  -Force | Out-Null; Write-Ok ".agents\memory\ 已建立（D01）" }
    if (-not (Test-Path $sharedProject)) { New-Item -ItemType Directory $sharedProject -Force | Out-Null; Write-Ok ".agents\project_skills\ 已建立" }

    # 掃描並補建衍生技能的命名空間符號連結
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

    # 將目標專案的版本號更新為最新版
    $FrameworkVersion | Set-Content $dstVersionFile -Encoding UTF8
    Write-Ok ".claude\VERSION → $FrameworkVersion"

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host "  升級完成 — 更新 $applied 個檔案" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host ""
    return
}

# ============================================================
# Fresh 模式：完整部署（含 D06 記憶卡保護安全網）
# 流程：備份記憶卡 → 複製框架 → 無論成敗都還原記憶卡
# ============================================================

# D06 安全網：在系統暫存目錄建立備份，防止覆蓋過程中記憶卡遺失
$tmpMemory  = Join-Path $env:TEMP "cc_backup_memory_$(Get-Random)"
$tmpProject = Join-Path $env:TEMP "cc_backup_project_$(Get-Random)"

try {
    # 備份現有的記憶卡和衍生技能到暫存目錄
    if (Test-Path $sharedMemory)  { Copy-Item $sharedMemory  $tmpMemory  -Recurse -Force; Write-Step "已備份共用記憶卡（D06 安全防線）..." }
    if (Test-Path $sharedProject) { Copy-Item $sharedProject $tmpProject -Recurse -Force; Write-Step "已備份衍生技能（D06 安全防線）..." }

    # 部署 .claude/ 全套框架
    Write-Step "部署 .claude/ 全套框架..."
    # 逐一複製源碼中的所有檔案到目標 .claude/ 目錄
    Get-ChildItem $srcDotClaude -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($srcDotClaude.Length + 1)
        # 排除不應部署的檔案（部署腳本本身 + 本地設定檔）
        if ($rel -like "scripts\Deploy-Claude.ps1") { return }
        if ($rel -like "settings.local.json")        { return }
        $dst    = Join-Path $dstDotClaude $rel
        # 如果目標資料夾不存在，先建立它
        $dstDir = Split-Path $dst -Parent
        if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory $dstDir -Force | Out-Null }
        Copy-Item $_.FullName $dst -Force
    }

    # 寫入版本號
    $FrameworkVersion | Set-Content (Join-Path $dstDotClaude "VERSION") -Encoding UTF8
    Write-Ok ".claude\VERSION → $FrameworkVersion"

    # 確保 .agents/memory/ 目錄存在（專案記憶卡存放處）
    Write-Step "建立基礎設施目錄..."
    if (-not (Test-Path $sharedMemory)) {
        New-Item -ItemType Directory $sharedMemory -Force | Out-Null
        Write-Ok ".agents\memory\ 共用記憶庫目錄已建立（D01）"
    }
    # 確保 .agents/project_skills/ 目錄存在（衍生技能存放處）
    if (-not (Test-Path $sharedProject)) {
        New-Item -ItemType Directory $sharedProject -Force | Out-Null
        Write-Ok ".agents\project_skills\ 衍生技能目錄已建立"
    }
    # 如果衍生技能路由表不存在，建立一個空的模板
    $projectIndexFile = Join-Path $sharedProject "_index.md"
    if (-not (Test-Path $projectIndexFile)) {
        @"
# Project Skill Registry (專案衍生技能路由表)

| Keywords (EN) | 關鍵字 (ZH) | Skill | MCP Server |
|--------------|------------|-------|------------|
"@ | Set-Content $projectIndexFile -Encoding UTF8
        Write-Ok "衍生技能路由表模板已建立"
    }

    # .gitignore 設定：確保 .cartridge/ 不會被納入版控
    $gitignore = Join-Path $Target ".gitignore"
    if (Test-Path $gitignore) {
        $content = Get-Content $gitignore -Raw
        if ($content -notmatch "\.cartridge") {
            Add-Content $gitignore "`n# Antigravity Claude Edition — 本地記憶索引（不進版控）`n.cartridge/"
            Write-Ok ".gitignore 已新增 .cartridge/ 排除規則"
        }
    }

    # 掃描並補建衍生技能的命名空間符號連結
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

} finally {
    # D06 安全網：無論上面的複製過程是否成功，都會執行這裡的還原
    if (Test-Path $tmpMemory) {
        Copy-Item $tmpMemory $sharedMemory -Recurse -Force
        Remove-Item $tmpMemory -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "共用記憶卡已完整保留並還原。"
    }
    if (Test-Path $tmpProject) {
        Copy-Item $tmpProject $sharedProject -Recurse -Force
        Remove-Item $tmpProject -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "衍生技能已完整保留並還原。"
    }

    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host "  Antigravity Claude Edition v$FrameworkVersion 框架已部署完成。" -ForegroundColor Green
    Write-Host "  目標專案現在已具備 Claude Code 治理能力。" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host ""
}
