#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Claude Edition — 實際部署腳本
.DESCRIPTION
    將 Claude Code 版 Antigravity 框架部署到目標專案。
    支援 Fresh（全新安裝）與 Upgrade（SHA256 差異升級）兩種模式。
    此腳本由 install.ps1 啟動器呼叫，不應直接執行。
.PARAMETER Target
    目標專案的絕對路徑（例如：D:\MyProject）
.PARAMETER Mode
    部署模式：Fresh（預設）或 Upgrade
.PARAMETER RemoveOrphans
    是否移除目標中已不存在於源碼的孤兒檔案（僅 Upgrade 模式）
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Target,
    [ValidateSet("Fresh", "Upgrade")]
    [string]$Mode = "Fresh",
    [switch]$RemoveOrphans
)

$ErrorActionPreference = "Stop"
# 源碼根目錄：Deploy-Claude.ps1 位於 .claude/scripts/ 下，需往上兩層到 Claude/
$SourceRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$FrameworkVersion = "1.1.0"

function Write-Step { param([string]$Msg) Write-Host "  → $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  ✓ $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  ⚠ $Msg" -ForegroundColor Yellow }
function Write-Fail { param([string]$Msg) Write-Host "  ✗ $Msg" -ForegroundColor Red }
function Write-New  { param([string]$Rel) Write-Host "    [NEW]    $Rel" -ForegroundColor Green }
function Write-Upd  { param([string]$Rel) Write-Host "    [UPDATE] $Rel" -ForegroundColor Yellow }

function Get-FileHash256 {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA256).Hash
}

function Deploy-File {
    param([string]$Src, [string]$Dst, [bool]$IsUpgrade)
    $dstDir = Split-Path $Dst -Parent
    if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }

    if ($IsUpgrade -and (Test-Path $Dst)) {
        $srcHash = Get-FileHash256 $Src
        $dstHash = Get-FileHash256 $Dst
        if ($srcHash -eq $dstHash) { return "SKIP" }
        Copy-Item $Src $Dst -Force
        return "UPDATE"
    }
    Copy-Item $Src $Dst -Force
    return "COPY"
}

# ─── 驗證目標路徑 ─────────────────────────────────────────────────────────────
if (-not (Test-Path $Target)) {
    Write-Fail "目標路徑不存在：$Target"
    exit 1
}

$isUpgrade = $Mode -eq "Upgrade"
$claudeMarker = Join-Path $Target ".claude"

if ($isUpgrade -and -not (Test-Path $claudeMarker)) {
    Write-Warn "目標專案尚未安裝 Claude 版 Antigravity，切換為 Fresh 模式。"
    $isUpgrade = $false
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  Antigravity Claude Edition v$FrameworkVersion — 部署引擎" -ForegroundColor Magenta
Write-Host "  模式: $($isUpgrade ? 'Upgrade' : 'Fresh') | 目標: $Target" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""

$stats = @{ Copy = 0; Update = 0; Skip = 0; Orphan = 0 }
$diffLog = [System.Collections.Generic.List[string]]::new()

try {
    # ─── 1. 部署 .claude/（規則、指令、技能、腳本）────────────────────────────
    # CLAUDE.md、commands/、skills/、rules/、scripts/ 全部在 .claude/ 下統一處理
    Write-Step "部署 .claude/ 全套框架..."
    $srcDotClaude = Join-Path $SourceRoot ".claude"
    $dstDotClaude = Join-Path $Target ".claude"

    Get-ChildItem $srcDotClaude -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($srcDotClaude.Length + 1)

        # 跳過部署腳本本身（不需要部署到子專案）
        if ($rel -like "scripts\Deploy-Claude.ps1") { return }

        # 跳過本機設定檔（settings.local.json 為個人偏好，不進版控）
        if ($rel -like "settings.local.json") { return }

        $dst = Join-Path $dstDotClaude $rel
        $result = Deploy-File $_.FullName $dst $isUpgrade
        $key = if ($result -eq "SKIP") { "Skip" } elseif ($result -eq "UPDATE") { "Update" } else { "Copy" }
        $stats[$key]++
        switch ($result) {
            "COPY"   { Write-New ".claude\$rel"; $diffLog.Add("[NEW]    .claude\$rel") }
            "UPDATE" { Write-Upd ".claude\$rel"; $diffLog.Add("[UPDATE] .claude\$rel") }
            "SKIP"   { $diffLog.Add("[SKIP]   .claude\$rel") }
        }
    }

    # ─── 2. 寫入 VERSION 版本追蹤檔 ──────────────────────────────────────────
    $versionFile = Join-Path $dstDotClaude "VERSION"
    $FrameworkVersion | Set-Content $versionFile -Encoding UTF8
    Write-Ok ".claude\VERSION → $FrameworkVersion"

    # ─── 3. 建立基礎設施目錄（Fresh 模式）───────────────────────────────────
    if (-not $isUpgrade) {
        Write-Step "建立基礎設施目錄..."

        # D01 架構決策：確保雙 AI 共用記憶庫著陸點存在
        $sharedMemory = Join-Path $Target ".agents\memory"
        if (-not (Test-Path $sharedMemory)) {
            New-Item -ItemType Directory -Path $sharedMemory -Force | Out-Null
            Write-Ok ".agents\memory\ 共用記憶庫目錄已建立（D01 雙 AI 共用架構）"
        }

        # .gitignore 新增 cartridge-system 本地索引排除規則
        $gitignore = Join-Path $Target ".gitignore"
        if (Test-Path $gitignore) {
            $content = Get-Content $gitignore -Raw
            if ($content -notmatch "\.cartridge") {
                Add-Content $gitignore "`n# Antigravity Claude Edition — 本地記憶索引（不進版控）`n.cartridge/"
                Write-Ok ".gitignore 已新增 .cartridge/ 排除規則"
            }
        }
    }

    # ─── 4. 孤兒掃描（Upgrade 模式）─────────────────────────────────────────
    if ($isUpgrade -and $RemoveOrphans) {
        Write-Step "掃描孤兒檔案..."

        Get-ChildItem (Join-Path $Target ".claude") -Recurse -File | ForEach-Object {
            $rel = $_.FullName.Substring((Join-Path $Target ".claude").Length + 1)
            $srcPath = Join-Path $SourceRoot ".claude\$rel"

            # agents/ 目錄由官方 Claude Code 工具管理，整個目錄視為受保護
            if ($rel -like "agents\*") { return }

            # VERSION 檔案由腳本動態寫入，不算孤兒
            if ($rel -eq "VERSION") { return }

            if (-not (Test-Path $srcPath)) {
                Write-Warn "[ORPHAN] .claude\$rel — 源碼已刪除，請手動確認是否移除"
                $stats.Orphan++
            }
        }
    }

    # ─── 5. 彩色差異報告（Upgrade 模式）──────────────────────────────────────
    if ($isUpgrade) {
        $changed = $diffLog | Where-Object { $_ -notlike "[SKIP]*" }
        if ($changed.Count -gt 0) {
            Write-Host ""
            Write-Host "  ── 差異報告 ──────────────────────────────────" -ForegroundColor DarkCyan
            foreach ($entry in $changed) {
                $color = if ($entry -like "[NEW]*") { "Green" } elseif ($entry -like "[UPDATE]*") { "Yellow" } else { "Gray" }
                Write-Host "  $entry" -ForegroundColor $color
            }
            Write-Host "  ──────────────────────────────────────────────" -ForegroundColor DarkCyan
        } else {
            Write-Host ""
            Write-Ok "所有檔案均已是最新版本，無需更新。"
        }
    }

} finally {
    # ─── 完成摘要（try/finally 安全網：無論成敗都會執行）────────────────────
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host "  部署完成摘要" -ForegroundColor Magenta
    Write-Host "  新增: $($stats.Copy) | 更新: $($stats.Update) | 略過: $($stats.Skip) | 孤兒: $($stats.Orphan)" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  Antigravity Claude Edition v$FrameworkVersion 框架已部署完成。" -ForegroundColor Green
    Write-Host "  目標專案現在已具備 Claude Code 治理能力。" -ForegroundColor Green
    Write-Host ""
}
