#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Claude Edition — 部署腳本
.DESCRIPTION
    將 Claude Code 版 Antigravity 框架部署到目標專案。
    支援 Fresh（全新安裝）與 Upgrade（SHA256 差異升級）兩種模式。
.PARAMETER Target
    目標專案的絕對路徑（例如：D:\MyProject）
.PARAMETER Mode
    部署模式：Fresh（預設）或 Upgrade
.PARAMETER RemoveOrphans
    是否移除目標中已不存在於源碼的孤兒檔案（僅 Upgrade 模式）
.EXAMPLE
    & .\install.ps1 -Target "D:\MyProject"
    & .\install.ps1 -Target "D:\MyProject" -Mode Upgrade
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Target,
    [ValidateSet("Fresh", "Upgrade")]
    [string]$Mode = "Fresh",
    [switch]$RemoveOrphans
)

$ErrorActionPreference = "Stop"
$SourceRoot = $PSScriptRoot

function Write-Step { param([string]$Msg) Write-Host "  → $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  ✓ $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  ⚠ $Msg" -ForegroundColor Yellow }
function Write-Fail { param([string]$Msg) Write-Host "  ✗ $Msg" -ForegroundColor Red }

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

# ─── Validate target ───────────────────────────────────────────────────────────
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
Write-Host "  Antigravity Claude Edition — 部署引擎" -ForegroundColor Magenta
Write-Host "  模式: $($isUpgrade ? 'Upgrade' : 'Fresh') | 目標: $Target" -ForegroundColor Magenta
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""

$stats = @{ Copy = 0; Update = 0; Skip = 0; Orphan = 0 }

# ─── 1. Deploy CLAUDE.md ────────────────────────────────────────────────────────
Write-Step "部署主規則 CLAUDE.md..."
$dstClaude = Join-Path $Target "CLAUDE.md"
if ($isUpgrade -and (Test-Path $dstClaude)) {
    Write-Warn "CLAUDE.md 已存在。升級模式下保留現有檔案（不覆蓋）。"
    Write-Warn "如需強制更新主規則，請手動替換或使用 [SUDO] 覆寫。"
} else {
    Copy-Item (Join-Path $SourceRoot "CLAUDE.md") $dstClaude -Force
    Write-Ok "CLAUDE.md 已部署"
    $stats.Copy++
}

# ─── 2. Deploy .claude/ (rules + skills) ───────────────────────────────────────
Write-Step "部署 .claude/ 規則與技能..."
$srcDotClaude = Join-Path $SourceRoot ".claude"
$dstDotClaude = Join-Path $Target ".claude"

Get-ChildItem $srcDotClaude -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($srcDotClaude.Length + 1)
    $dst = Join-Path $dstDotClaude $rel
    $result = Deploy-File $_.FullName $dst $isUpgrade
    $stats[$result == "SKIP" ? "Skip" : ($result == "UPDATE" ? "Update" : "Copy")]++
    if ($result -ne "SKIP") { Write-Ok ".claude\$rel [$result]" }
}

# ─── 3. Deploy .agents/skills/ ─────────────────────────────────────────────────
Write-Step "部署操作型知識庫 .agents/skills/..."
$srcSkills = Join-Path $SourceRoot ".agents\skills"
$dstSkills = Join-Path $Target ".agents\skills"

if (Test-Path $srcSkills) {
    Get-ChildItem $srcSkills -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($srcSkills.Length + 1)
        $dst = Join-Path $dstSkills $rel
        $result = Deploy-File $_.FullName $dst $isUpgrade
        $stats[$result == "SKIP" ? "Skip" : ($result == "UPDATE" ? "Update" : "Copy")]++
        if ($result -ne "SKIP") { Write-Ok ".agents\skills\$rel [$result]" }
    }
}

# ─── 4. Create protected directories (Fresh only) ───────────────────────────────
if (-not $isUpgrade) {
    Write-Step "建立受保護目錄（執行期建立）..."
    @(".agents\memory", ".agents\project_skills", ".agents\logs") | ForEach-Object {
        $dir = Join-Path $Target $_
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Ok "$_ 目錄已建立"
        }
    }

    # .gitignore entry for logs
    $gitignore = Join-Path $Target ".gitignore"
    if (Test-Path $gitignore) {
        $content = Get-Content $gitignore -Raw
        if ($content -notmatch "\.agents/logs/") {
            Add-Content $gitignore "`n# Antigravity — 暫存日誌（不進版控）`n.agents/logs/"
            Write-Ok ".gitignore 已新增 .agents/logs/ 排除規則"
        }
    }
}

# ─── 5. Orphan scan (Upgrade only) ─────────────────────────────────────────────
if ($isUpgrade -and $RemoveOrphans) {
    Write-Step "掃描孤兒檔案..."
    $protectedDirs = @(".agents\memory", ".agents\project_skills", ".agents\logs")
    $srcFiles = (Get-ChildItem (Join-Path $SourceRoot ".claude") -Recurse -File) +
                (Get-ChildItem (Join-Path $SourceRoot ".agents\skills") -Recurse -File -ErrorAction SilentlyContinue)

    Get-ChildItem (Join-Path $Target ".claude") -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring((Join-Path $Target ".claude").Length + 1)
        $srcPath = Join-Path $SourceRoot ".claude\$rel"
        if (-not (Test-Path $srcPath)) {
            $isProtected = $protectedDirs | Where-Object { $_.FullName -like "*$_*" }
            if (-not $isProtected) {
                Write-Warn "[ORPHAN] .claude\$rel — 源碼已刪除，請手動確認是否移除"
                $stats.Orphan++
            }
        }
    }
}

# ─── Summary ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  部署完成摘要" -ForegroundColor Magenta
Write-Host "  新增: $($stats.Copy) | 更新: $($stats.Update) | 略過: $($stats.Skip) | 孤兒: $($stats.Orphan)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Antigravity Claude Edition 框架已部署完成。" -ForegroundColor Green
Write-Host "  目標專案現在已具備 Claude Code 治理能力。" -ForegroundColor Green
Write-Host ""
