#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Claude Edition 平台部署模組
.DESCRIPTION
    提供 Invoke-ClaudeFresh 與 Invoke-ClaudeUpgrade 兩個函式，
    分別處理 .claude/ 目錄的全新安裝與差異升級。
    從 Deploy-Claude.ps1 遷移，含 PROJECT IDENTITY 還原機制。
#>

using module ".\Core.psm1"
using module ".\Skills-Sync.psm1"

function Invoke-ClaudeFresh {
    <#
    .SYNOPSIS
        Claude Edition Fresh 部署 — 全新安裝 .claude/ 目錄。
    .PARAMETER FrameworkRoot
        Claude/ 框架根目錄（含 .claude/ 子目錄）
    .PARAMETER Target
        目標專案絕對路徑
    .PARAMETER SharedSkillsRoot
        Shared/skills/ 的絕對路徑（唯一技能來源）
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$FrameworkRoot,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot
    )

    $srcDotClaude  = Join-Path $FrameworkRoot ".claude"
    $dstDotClaude  = Join-Path $Target ".claude"
    $agentsRoot    = Join-Path $Target ".agents"
    $version       = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    Write-Banner "Claude Edition v$version — Fresh 安裝 | 目標: $Target" "Magenta"

    if (-Not (Test-Path $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }

    # D06 安全網備份（memory/、project_skills/ 與 context/ 在 .agents/ 下，三平台共用）
    $backup = Backup-ProtectedDirs -AgentsRoot $agentsRoot

    try {
        Write-Step "部署 .claude/ 全套框架（commands/rules）..."
        # 複製所有框架檔案，排除：settings.local.json、skills/（由 Shared/ 注入）
        Get-ChildItem $srcDotClaude -Recurse -File | ForEach-Object {
            $rel = $_.FullName.Substring($srcDotClaude.Length + 1)
            if ($rel -like "settings.local.json")        { return }
            if ($rel -like "skills\*")                    { return }
            $dst    = Join-Path $dstDotClaude $rel
            $dstDir = Split-Path $dst -Parent
            if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory $dstDir -Force | Out-Null }
            Copy-Item $_.FullName $dst -Force
        }

        Write-Step "注入共用子代理政策（Shared/policies/ → .claude/rules/core-identity.md）..."
        $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
            -TargetPath (Join-Path $dstDotClaude "rules\core-identity.md") `
            -Platform Claude `
            -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'

        # 技能注入：從 Shared/ 注入共用技能到 .claude/skills/
        Write-Step "注入共用技能（Shared/skills/ → .claude/skills/）..."
        $targetSkillsPath = Join-Path $dstDotClaude "skills"
        $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                          -TargetSkillsPath $targetSkillsPath `
                          -Mode Full

        # 寫入版本號
        Set-Content (Join-Path $dstDotClaude "VERSION") $version -Encoding UTF8
        Write-Ok ".claude\VERSION → $version"

        # 基礎設施確保（.agents/memory/、.agents/project_skills/ 和 .agents/context/）
        Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot

        # .gitignore 設定
        Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

        # 衍生技能 Backfill
        Write-Step "掃描並補建衍生技能命名空間連結..."
        Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir $targetSkillsPath

    } finally {
        Restore-ProtectedDirs -Backup $backup -AgentsRoot $agentsRoot

        # 統計
        $cmdCount   = @(Get-ChildItem (Join-Path $dstDotClaude "commands") -File -Recurse -EA SilentlyContinue).Count
        $skillCount = @(Get-ChildItem (Join-Path $dstDotClaude "skills")   -File -Recurse -EA SilentlyContinue).Count
        $ruleCount  = @(Get-ChildItem (Join-Path $dstDotClaude "rules")    -File -Recurse -EA SilentlyContinue).Count

        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host "  Claude Edition v$version 框架已部署完成。" -ForegroundColor Green
        Write-Host "  目標專案現在已具備 Claude Code 治理能力。" -ForegroundColor Green
        Write-DeployStats -Commands $cmdCount -Skills $skillCount -Rules $ruleCount -Label "統計"
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host ""
    }
}

function Invoke-ClaudeUpgrade {
    <#
    .SYNOPSIS
        Claude Edition Upgrade 部署 — 差異比對升級 .claude/ 目錄。
    .PARAMETER FrameworkRoot
        Claude/ 框架根目錄
    .PARAMETER Target
        目標專案絕對路徑
    .PARAMETER SharedSkillsRoot
        Shared/skills/ 的絕對路徑
    .PARAMETER RemoveOrphans
        是否自動清除孤兒檔案
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

    $srcDotClaude = Join-Path $FrameworkRoot ".claude"
    $dstDotClaude = Join-Path $Target ".claude"
    $agentsRoot   = Join-Path $Target ".agents"
    $version      = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    if (-Not (Test-Path $dstDotClaude)) {
        Write-Warn "目標尚未安裝 Claude Edition，切換為 Fresh 模式。"
        Invoke-ClaudeFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        return
    }

    $dstVersionFile = Join-Path $dstDotClaude "VERSION"
    $targetVersion  = Get-VersionContent -Path $dstVersionFile
    Write-Banner "Claude Edition Upgrade v$targetVersion → v$version | 目標: $Target" "DarkCyan"

    Write-Step "正在掃描 .claude/ 差異（commands/rules）..."

    # 掃描框架結構（排除 skills/，由 Shared/ 獨立管理）
    $categoryMap = [ordered]@{
        "工作流指令 (Commands)" = { $_.Path -like "commands\*" -or $_.Path -like "commands/*" }
        "治理規範 (Rules)"      = { $_.Path -like "rules\*"    -or $_.Path -like "rules/*" }
    }

    $excludeFiles = @("settings.local.json")
    # 從 srcDotClaude 掃描 commands/rules（跳過 skills/）
    $report = Get-UpgradeReport `
        -SourceRoot $srcDotClaude `
        -TargetRoot $dstDotClaude `
        -ScanDirs @("commands", "rules") `
        -ProtectedDirs @() `
        -ExcludeFiles $excludeFiles

    $stats = Write-UpgradeReport -Report $report -CategoryMap $categoryMap -Platform "Claude"

    # CHANGELOG
    $changelogPath = Join-Path $FrameworkRoot "CHANGELOG.md"
    $notes = Get-ReleaseNotes -ChangelogPath $changelogPath
    if ($notes.Count -gt 0) {
        Write-Host ""
        Write-Host "  📋 最新版本更新說明" -ForegroundColor White
        foreach ($noteLine in $notes) { Write-Host "  $noteLine" }
    }

    # CLAUDE.md PROJECT IDENTITY 保護
    $claudeMdPath  = Join-Path $dstDotClaude "CLAUDE.md"
    $savedIdentity = $null
    if (Test-Path $claudeMdPath) {
        $claudeContent = Get-Content $claudeMdPath -Raw
        if ($claudeContent -match '(?s)(## \[PROJECT IDENTITY[^\r\n]*\r?\n.*?<!-- /PROJECT_IDENTITY_END -->)') {
            $savedIdentity = $Matches[1]
            Write-Step "偵測到 PROJECT IDENTITY 保護區段，升級後將自動還原。"
        }
    }

    # 確認閘門
    $applied = 0
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        if (Invoke-ConfirmGate -Message "是否套用上述變更？(Y/N)") {
            Write-Step "正在套用變更..."
            $applied = Install-Upgrade -Report $report -SourceRoot $srcDotClaude -TargetRoot $dstDotClaude
        } else {
            Write-Warn "已跳過框架檔案更新。"
        }
    } else {
        Write-Ok "所有 .claude/ 檔案均已是最新版本，無需更新。"
    }

    # 技能差異注入
    Write-Step "同步技能差異（Shared/skills/ → .claude/skills/）..."
    $targetSkillsPath = Join-Path $dstDotClaude "skills"
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                      -TargetSkillsPath $targetSkillsPath `
                      -Mode Diff

    # PROJECT IDENTITY 還原
    if ($savedIdentity -and (Test-Path $claudeMdPath)) {
        $newContent = Get-Content $claudeMdPath -Raw
        if ($newContent -notmatch '## \[PROJECT IDENTITY') {
            $restored = $newContent.TrimEnd() + "`n`n" + $savedIdentity
            [System.IO.File]::WriteAllText($claudeMdPath, $restored, [System.Text.Encoding]::UTF8)
            Write-Ok "PROJECT IDENTITY 保護區段已還原（UTF-8）。"
        }
    }

    Write-Step "同步共用子代理政策（Shared/policies/ → .claude/rules/core-identity.md）..."
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $dstDotClaude "rules\core-identity.md") `
        -Platform Claude `
        -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'

    # 孤兒處理
    if ($stats.Orphan -gt 0) {
        if ($RemoveOrphans) {
            Remove-OrphanFiles -Report $report -TargetRoot $dstDotClaude
        } else {
            Write-Warn "$($stats.Orphan) 個孤兒檔案。加入 -RemoveOrphans 可自動清除。"
        }
    }

    # 基礎設施確保
    Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot

    # .gitignore 設定
    Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

    # Backfill
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir $targetSkillsPath

    # 版本更新
    Set-Content $dstVersionFile $version -Encoding UTF8
    Write-Ok ".claude\VERSION → $version"

    Write-Banner "升級完成 — Claude Edition v$version（更新 $applied 個框架檔案）" "Green"
}

Export-ModuleMember -Function Invoke-ClaudeFresh, Invoke-ClaudeUpgrade
