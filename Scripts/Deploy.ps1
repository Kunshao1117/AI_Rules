#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 統一部署主入口
.DESCRIPTION
    管理 Antigravity、Claude Edition、Codex 三個平台的部署。
    支援選單模式（無參數互動）與參數模式（自動化呼叫）兩用。
.PARAMETER Platform
    目標平台：Antigravity / Claude / Codex / All
.PARAMETER Mode
    操作模式：Fresh / Upgrade / Audit / Sync
.PARAMETER Target
    目標專案絕對路徑（Fresh/Upgrade 必填，預設為當前目錄）
.PARAMETER Action
    特殊動作：Global（安裝/更新全局觸發器）
.PARAMETER RemoveOrphans
    Upgrade 模式：是否自動清除孤兒檔案
.EXAMPLE
    # 選單模式
    .\Deploy.ps1

    # 參數模式
    .\Deploy.ps1 -Platform Antigravity -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform Claude -Mode Upgrade
    .\Deploy.ps1 -Platform Codex -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform All -Mode Sync
    .\Deploy.ps1 -Action Global
#>
param(
    [ValidateSet("Antigravity", "Claude", "Codex", "All")]
    [string]$Platform,

    [ValidateSet("Fresh", "Upgrade", "Audit", "Sync")]
    [string]$Mode,

    [string]$Target = $PWD.Path,

    [ValidateSet("Global")]
    [string]$Action,

    [switch]$RemoveOrphans
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding          = [System.Text.Encoding]::UTF8

# ── 路徑計算 ──────────────────────────────────────────────────────────────────
# $PSScriptRoot = Scripts/ 目錄，往上一層就是 AI_Rules 根目錄
$RepoRoot         = Split-Path $PSScriptRoot -Parent
$ModulesDir       = Join-Path $PSScriptRoot "modules"
$SharedSkillsRoot = Join-Path $RepoRoot "Shared\skills"
$AgRoot           = Join-Path $RepoRoot "Antigravity"
$ClaudeRoot       = Join-Path $RepoRoot "Claude"
$CodexRoot        = Join-Path $RepoRoot "Codex"

# ── 模組載入 ──────────────────────────────────────────────────────────────────
Import-Module (Join-Path $ModulesDir "Core.psm1")            -Force
Import-Module (Join-Path $ModulesDir "Skills-Sync.psm1")     -Force
Import-Module (Join-Path $ModulesDir "Platform-Antigravity.psm1") -Force
Import-Module (Join-Path $ModulesDir "Platform-Claude.psm1") -Force
Import-Module (Join-Path $ModulesDir "Platform-Codex.psm1")  -Force
Import-Module (Join-Path $ModulesDir "Audit.psm1")           -Force

# ══════════════════════════════════════════════════════════
# Global 動作：安裝/更新全局觸發器
# ══════════════════════════════════════════════════════════

function Invoke-GlobalInstall {
    Write-Banner "安裝/更新全局觸發器" "Cyan"

    # Antigravity: ~/.gemini/GEMINI.md
    $geminiSrc = Join-Path $AgRoot "global\GEMINI.md"
    $geminiDst = Join-Path $env:USERPROFILE ".gemini\GEMINI.md"
    if (Test-Path $geminiSrc) {
        New-Item -ItemType Directory -Force -Path (Split-Path $geminiDst -Parent) | Out-Null
        Copy-Item $geminiSrc $geminiDst -Force
        Write-Ok "Antigravity → $geminiDst"
    } else { Write-Warn "Antigravity/global/GEMINI.md 不存在，跳過。" }

    # Claude: ~/.claude/CLAUDE.md
    $claudeSrc = Join-Path $ClaudeRoot "global\CLAUDE.md"
    $claudeDst = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
    if (Test-Path $claudeSrc) {
        New-Item -ItemType Directory -Force -Path (Split-Path $claudeDst -Parent) | Out-Null
        Copy-Item $claudeSrc $claudeDst -Force
        Write-Ok "Claude Edition → $claudeDst"
    } else { Write-Warn "Claude/global/CLAUDE.md 不存在，跳過。" }

    # Codex: ~/.codex/AGENTS.md
    $codexSrc = Join-Path $CodexRoot "global\AGENTS.md"
    $codexDst = Join-Path $env:USERPROFILE ".codex\AGENTS.md"
    if (Test-Path $codexSrc) {
        New-Item -ItemType Directory -Force -Path (Split-Path $codexDst -Parent) | Out-Null
        Copy-Item $codexSrc $codexDst -Force
        Write-Ok "Codex → $codexDst"
    } else { Write-Warn "Codex/global/AGENTS.md 不存在，跳過。" }

    # Codex: ~/.codex/config.toml (project_doc_fallback_filenames bridge)
    $codexConfigSrc = Join-Path $CodexRoot "global\config.toml"
    $codexConfigDst = Join-Path $env:USERPROFILE ".codex\config.toml"
    New-Item -ItemType Directory -Force -Path (Split-Path $codexConfigDst -Parent) | Out-Null
    if (-not (Test-Path $codexConfigDst)) {
        if (Test-Path $codexConfigSrc) { Copy-Item $codexConfigSrc $codexConfigDst -Force }
        Write-Ok "Codex config.toml → $codexConfigDst (created)"
    } else {
        $existing = Get-Content $codexConfigDst -Raw -ErrorAction SilentlyContinue
        if ($existing -notmatch '\.codex/AGENTS\.md') {
            Add-Content $codexConfigDst "`n# Antigravity Codex Edition bridge`nproject_doc_fallback_filenames = [`".codex/AGENTS.md`"]"
            Write-Ok "Codex config.toml → $codexConfigDst (fallback entry appended)"
        } else {
            Write-Ok "Codex config.toml already contains fallback entry, skipped."
        }
    }

    Write-Banner "全局觸發器安裝完成" "Green"
}

# ══════════════════════════════════════════════════════════
# 平台部署分派
# ══════════════════════════════════════════════════════════

function Invoke-PlatformDeploy {
    param(
        [string]$PlatformName,
        [string]$DeployMode,
        [string]$TargetPath
    )

    switch ($PlatformName) {
        "Antigravity" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-AgFresh   -FrameworkRoot $AgRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-AgUpgrade -FrameworkRoot $AgRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    { Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".agents\skills") -Mode Diff }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".agents\skills")
                }
            }
        }
        "Claude" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-ClaudeFresh   -FrameworkRoot $ClaudeRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-ClaudeUpgrade -FrameworkRoot $ClaudeRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    { Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".claude\skills") -Mode Diff }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".claude\skills")
                }
            }
        }
        "Codex" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-CodexFresh   -FrameworkRoot $CodexRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-CodexUpgrade -FrameworkRoot $CodexRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    { Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".agents\skills") -Mode Diff }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".agents\skills")
                }
            }
        }
    }
}

# ══════════════════════════════════════════════════════════
# 選單模式（無參數時啟動）
# ══════════════════════════════════════════════════════════

function Show-Menu {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║    Antigravity Framework Manager v1.0            ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  平台選擇:" -ForegroundColor White
    Write-Host "    [1] Antigravity (Gemini)" -ForegroundColor DarkCyan
    Write-Host "    [2] Claude Edition" -ForegroundColor DarkCyan
    Write-Host "    [3] Codex" -ForegroundColor DarkCyan
    Write-Host "    [4] 全部平台 (All)" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  操作選擇:" -ForegroundColor White
    Write-Host "    [F] Fresh   全新安裝（目標目錄由下一步指定）" -ForegroundColor Green
    Write-Host "    [U] Upgrade 差異升級" -ForegroundColor Yellow
    Write-Host "    [A] Audit   健檢掃描" -ForegroundColor Magenta
    Write-Host "    [S] Sync    僅同步技能" -ForegroundColor DarkGray
    Write-Host "    [G] Global  安裝/更新全局觸發器" -ForegroundColor Cyan
    Write-Host "    [Q] 退出" -ForegroundColor DarkGray
    Write-Host ""

    $platInput = Read-Host "  選擇平台 [1/2/3/4]"
    $modeInput = Read-Host "  選擇操作 [F/U/A/S/G/Q]"

    if ($modeInput -match "^[Qq]$") { Write-Host "已退出。"; return }
    if ($modeInput -match "^[Gg]$") { Invoke-GlobalInstall; return }

    $selectedPlatform = switch ($platInput) {
        "1" { "Antigravity" }
        "2" { "Claude" }
        "3" { "Codex" }
        "4" { "All" }
        default { Write-Fail "無效平台選擇"; return }
    }

    $selectedMode = switch ($modeInput.ToUpper()) {
        "F" { "Fresh" }
        "U" { "Upgrade" }
        "A" { "Audit" }
        "S" { "Sync" }
        default { Write-Fail "無效操作選擇"; return }
    }

    $selectedTarget = $Target
    if ($selectedMode -in @("Fresh", "Upgrade")) {
        $inputTarget = Read-Host "  目標專案路徑 [Enter 使用當前目錄: $Target]"
        if ($inputTarget -and $inputTarget.Trim()) { $selectedTarget = $inputTarget.Trim() }
    }

    if ($selectedPlatform -eq "All") {
        foreach ($p in @("Antigravity", "Claude", "Codex")) {
            Invoke-PlatformDeploy -PlatformName $p -DeployMode $selectedMode -TargetPath $selectedTarget
        }
    } else {
        Invoke-PlatformDeploy -PlatformName $selectedPlatform -DeployMode $selectedMode -TargetPath $selectedTarget
    }
}

# ══════════════════════════════════════════════════════════
# 主流程：判斷參數模式或選單模式
# ══════════════════════════════════════════════════════════

if ($Action -eq "Global") {
    Invoke-GlobalInstall
    exit 0
}

if ($Platform -and $Mode) {
    # 參數模式
    if ($Platform -eq "All") {
        foreach ($p in @("Antigravity", "Claude", "Codex")) {
            Invoke-PlatformDeploy -PlatformName $p -DeployMode $Mode -TargetPath $Target
        }
    } else {
        Invoke-PlatformDeploy -PlatformName $Platform -DeployMode $Mode -TargetPath $Target
    }
} else {
    # 選單模式
    Show-Menu
}
