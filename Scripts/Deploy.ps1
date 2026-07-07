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
    特殊動作：Global（安裝/更新全局觸發器）/ Audit（三平台代理治理巡檢，包含 Team-Native 專家技能與任務軌跡）
.PARAMETER RemoveOrphans
    Upgrade 模式：是否自動清除孤兒檔案
.PARAMETER Apply
    Global 動作：實際寫入使用者層全域規則；未指定時只報告差異
.PARAMETER ProfileRoot
    使用者層全域規則根目錄。預設為目前使用者 Profile，可用於 temp profile 測試
.PARAMETER RequireTeamTrace
    要求 Team-Native task trace；缺少或不完整的軌跡會讓治理巡檢回報紅燈
.PARAMETER TeamTraceRoot
    Team-Native task trace 目錄；相對路徑會以目標專案根目錄為基準
.EXAMPLE
    # 選單模式
    .\Deploy.ps1

    # 參數模式
    .\Deploy.ps1 -Platform Antigravity -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform Claude -Mode Upgrade
    .\Deploy.ps1 -Platform Codex -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform All -Mode Sync
    .\Deploy.ps1 -Action Global
    .\Deploy.ps1 -Action Global -Apply
    .\Deploy.ps1 -Action Audit
#>
param(
    [ValidateSet("Antigravity", "Claude", "Codex", "All")]
    [string]$Platform,

    [ValidateSet("Fresh", "Upgrade", "Audit", "Sync")]
    [string]$Mode,

    [string]$Target = $PWD.Path,

    [ValidateSet("Global", "Audit")]
    [string]$Action,

    [switch]$RemoveOrphans,

    [switch]$Apply,

    [string]$ProfileRoot = $env:USERPROFILE,

    [switch]$RequireTeamTrace,

    [string]$TeamTraceRoot
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding          = [System.Text.Encoding]::UTF8

# ── 路徑計算 ──────────────────────────────────────────────────────────────────
# $PSScriptRoot = Scripts/ 目錄，往上一層就是 AI_Rules 根目錄
$RepoRoot         = Split-Path $PSScriptRoot -Parent
$ModulesDir       = Join-Path $PSScriptRoot "modules"
$SharedRoot       = Join-Path $RepoRoot "Shared"
$SharedSkillsRoot = Join-Path $RepoRoot "Shared\skills"
$ProjectToolsRoot = Join-Path $SharedRoot "project-tools"
$SharedPolicyPath = Join-Path $RepoRoot "Shared\policies\subagent-invocation.md"
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

function Merge-CodexGlobalConfigDefaults {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

        [Parameter(Mandatory = $true)]
        [string]$BackupRoot,

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
    if (-not $maxThreadsLine) { $maxThreadsLine = "max_threads = 6" }

    $current = ''
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        $current = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8
    }

    $merged = $current
    $actions = @()

    $before = $merged
    $merged = Add-TomlTopLevelKeyIfMissing -Text $merged -Key "project_doc_fallback_filenames" -Line $fallbackLine
    if ($merged -ne $before) { $actions += "add top-level project_doc_fallback_filenames" }

    $before = $merged
    $merged = Set-TomlSectionBooleanTrue -Text $merged -Section "features" -Key "multi_agent"
    if ($merged -ne $before) { $actions += "set [features].multi_agent = true" }

    $before = $merged
    $merged = Set-TomlSectionBooleanTrue -Text $merged -Section "features" -Key "hooks"
    if ($merged -ne $before) { $actions += "set [features].hooks = true" }

    $before = $merged
    $merged = Add-TomlSectionKeyIfMissing -Text $merged -Section "agents" -Key "max_threads" -Line $maxThreadsLine
    if ($merged -ne $before) { $actions += "add [agents].max_threads default" }

    $merged = $merged.TrimEnd() + "`n"

    if ($current -eq $merged) {
        Write-Step "Codex config.toml required keys already match section-aware defaults"
        return
    }

    if (-not $Apply) {
        Write-Warn "Codex config.toml would be updated ($($actions -join '; ')): $TargetPath"
        return
    }

    New-Item -ItemType Directory -Force -Path (Split-Path $TargetPath -Parent) | Out-Null
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
        Copy-Item $TargetPath (Join-Path $BackupRoot "config.toml.$timestamp.bak") -Force
    }
    [System.IO.File]::WriteAllText($TargetPath, $merged, [System.Text.UTF8Encoding]::new($false))
    Write-Ok "Codex config.toml required keys merged ($($actions -join '; ')): $TargetPath"
}

function Invoke-GlobalInstall {
    Write-Banner "全域規則安全閘門" "Cyan"
    
    $profile = if ($ProfileRoot) { $ProfileRoot } else { $env:USERPROFILE }
    $backupRoot = Join-Path $profile ".ai_rules\global_backups"
    $modeText = if ($Apply) { "Apply：會寫入使用者層規則並備份舊檔" } else { "Dry-run：只報告差異，不寫入" }
    Write-Step $modeText

    # Antigravity: ~/.gemini/GEMINI.md
    $geminiSrc = Join-Path $AgRoot "global\GEMINI.md"
    $geminiDst = Join-Path $profile ".gemini\GEMINI.md"
    if (Test-Path $geminiSrc) {
        Compare-GlobalRule -SourcePath $geminiSrc -TargetPath $geminiDst -Apply:$Apply -BackupRoot $backupRoot
    }

    # Claude: ~/.claude/CLAUDE.md
    $claudeSrc = Join-Path $ClaudeRoot "global\CLAUDE.md"
    $claudeDst = Join-Path $profile ".claude\CLAUDE.md"
    if (Test-Path $claudeSrc) {
        Compare-GlobalRule -SourcePath $claudeSrc -TargetPath $claudeDst -Apply:$Apply -BackupRoot $backupRoot
    }

    # Codex: ~/.codex/AGENTS.md
    $codexSrc = Join-Path $CodexRoot "global\AGENTS.md"
    $codexDst = Join-Path $profile ".codex\AGENTS.md"
    if (Test-Path $codexSrc) {
        Compare-GlobalRule -SourcePath $codexSrc -TargetPath $codexDst -Apply:$Apply -BackupRoot $backupRoot
    }

    # Codex: ~/.codex/config.toml
    $codexConfigSrc = Join-Path $CodexRoot "global\config.toml"
    $codexConfigDst = Join-Path $profile ".codex\config.toml"
    if (Test-Path $codexConfigSrc) {
        Merge-CodexGlobalConfigDefaults -SourcePath $codexConfigSrc -TargetPath $codexConfigDst -BackupRoot $backupRoot -Apply:$Apply
    }

    Write-Banner "全域規則處理完成" "Green"
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
                "Sync"    {
                    Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".agents\skills") -Mode Diff
                    Sync-SharedGovernanceReferences -SharedRoot $SharedRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-ProjectTools -ProjectToolsRoot $ProjectToolsRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-SharedPolicyBlock -PolicyPath $SharedPolicyPath `
                        -TargetPath (Join-Path $TargetPath ".agents\rules\00_core_identity.md") `
                        -Platform Antigravity `
                        -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'
                }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".agents\skills")
                    return (Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $TargetPath -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot)
                }
            }
        }
        "Claude" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-ClaudeFresh   -FrameworkRoot $ClaudeRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-ClaudeUpgrade -FrameworkRoot $ClaudeRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    {
                    Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".claude\skills") -Mode Diff
                    Sync-SharedGovernanceReferences -SharedRoot $SharedRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-ProjectTools -ProjectToolsRoot $ProjectToolsRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-SharedPolicyBlock -PolicyPath $SharedPolicyPath `
                        -TargetPath (Join-Path $TargetPath ".claude\rules\core-identity.md") `
                        -Platform Claude `
                        -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'
                }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".claude\skills")
                    return (Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $TargetPath -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot)
                }
            }
        }
        "Codex" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-CodexFresh   -FrameworkRoot $CodexRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-CodexUpgrade -FrameworkRoot $CodexRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    {
                    Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".agents\skills") -Mode Diff
                    Sync-SharedGovernanceReferences -SharedRoot $SharedRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-ProjectTools -ProjectToolsRoot $ProjectToolsRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-SharedPolicyBlock -PolicyPath $SharedPolicyPath `
                        -TargetPath (Join-Path $TargetPath ".codex\AGENTS.md") `
                        -Platform Codex `
                        -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
                }
                "Audit"   {
                    Invoke-DocScan    -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Invoke-HealthAudit -ProjectRoot $TargetPath -AgentsDir (Join-Path $TargetPath ".agents")
                    Measure-SkillQuality -SkillsRoot (Join-Path $TargetPath ".agents\skills")
                    return (Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $TargetPath -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot)
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
    Write-Host "    [A] Audit   健檢掃描（含 Team-Native 專家技能與任務軌跡）" -ForegroundColor Magenta
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
        $auditFailures = 0
        foreach ($p in @("Antigravity", "Claude", "Codex")) {
            $audit = Invoke-PlatformDeploy -PlatformName $p -DeployMode $selectedMode -TargetPath $selectedTarget
            if (($selectedMode -eq "Audit") -and $audit -and (-not $audit.Passed)) {
                $auditFailures++
            }
        }
        if (($selectedMode -eq "Audit") -and ($auditFailures -gt 0)) {
            exit 1
        }
    } else {
        $audit = Invoke-PlatformDeploy -PlatformName $selectedPlatform -DeployMode $selectedMode -TargetPath $selectedTarget
        if (($selectedMode -eq "Audit") -and $audit -and (-not $audit.Passed)) {
            exit 1
        }
    }
}

# ══════════════════════════════════════════════════════════
# 主流程：判斷參數模式或選單模式
# ══════════════════════════════════════════════════════════

if ($Action -eq "Global") {
    Invoke-GlobalInstall
    exit 0
}

if ($Action -eq "Audit") {
    $audit = Invoke-PlatformGovernanceAudit -RepoRoot $RepoRoot -ProfileRoot $ProfileRoot -TargetRoot $Target -RequireTeamTrace:$RequireTeamTrace -TeamTraceRoot $TeamTraceRoot
    if (-not $audit.Passed) {
        exit 1
    }
    exit 0
}

if ($Platform -and $Mode) {
    # 參數模式
    if ($Platform -eq "All") {
        $auditFailures = 0
        foreach ($p in @("Antigravity", "Claude", "Codex")) {
            $audit = Invoke-PlatformDeploy -PlatformName $p -DeployMode $Mode -TargetPath $Target
            if (($Mode -eq "Audit") -and $audit -and (-not $audit.Passed)) {
                $auditFailures++
            }
        }
        if (($Mode -eq "Audit") -and ($auditFailures -gt 0)) {
            exit 1
        }
    } else {
        $audit = Invoke-PlatformDeploy -PlatformName $Platform -DeployMode $Mode -TargetPath $Target
        if (($Mode -eq "Audit") -and $audit -and (-not $audit.Passed)) {
            exit 1
        }
    }
} else {
    # 選單模式
    Show-Menu
}
