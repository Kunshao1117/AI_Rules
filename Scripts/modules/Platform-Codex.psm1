#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Codex 平台部署模組
.DESCRIPTION
    提供 Invoke-CodexFresh 與 Invoke-CodexUpgrade 兩個函式，
    處理 .codex/ 目錄與 .agents/skills/ 的全新安裝與差異升級。
    Codex 原生掃描 .agents/skills/，工作流技能合併至同一目錄。
#>

using module ".\Core.psm1"
using module ".\Skills-Sync.psm1"

function Invoke-CodexFresh {
    <#
    .SYNOPSIS
        Codex Fresh 部署 — 全新安裝 .codex/ + .agents/ 目錄。
    .PARAMETER FrameworkRoot
        Codex/ 框架根目錄（含 .codex/ 和 .agents/workflow-skills/ 子目錄）
    .PARAMETER Target
        目標專案絕對路徑
    .PARAMETER SharedSkillsRoot
        Shared/skills/ 的絕對路徑（唯一共用技能來源）
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$FrameworkRoot,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot
    )

    $srcDotCodex     = Join-Path $FrameworkRoot ".codex"
    $dstDotCodex     = Join-Path $Target ".codex"
    $srcWorkflowSkills = Join-Path $FrameworkRoot ".agents\workflow-skills"
    $agentsRoot      = Join-Path $Target ".agents"
    $targetSkillsPath = Join-Path $agentsRoot "skills"
    $version         = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")

    Write-Banner "Codex v$version — Fresh 安裝 | 目標: $Target" "Magenta"

    if (-Not (Test-Path $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }

    # D06 安全網備份
    $backup = Backup-ProtectedDirs -AgentsRoot $agentsRoot

    try {
        # 部署 .codex/ 目錄（核心治理規則）
        Write-Step "部署 .codex/ 治理規則..."
        if (Test-Path $srcDotCodex) {
            New-Item -ItemType Directory -Force -Path $dstDotCodex | Out-Null
            Get-ChildItem $srcDotCodex -Recurse -File | ForEach-Object {
                $rel    = $_.FullName.Substring($srcDotCodex.Length + 1)
                $dst    = Join-Path $dstDotCodex $rel
                $dstDir = Split-Path $dst -Parent
                if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory $dstDir -Force | Out-Null }
                Copy-Item $_.FullName $dst -Force
            }
            Write-Ok ".codex/ 治理規則已部署"
        } else {
            Write-Warn ".codex/ 源碼不存在，跳過。"
        }

        # 技能注入（兩步驟）：
        # Step 1: 注入 36 套共用技能（Shared/skills/ → .agents/skills/）
        Write-Step "注入共用技能（Shared/skills/ → .agents/skills/）..."
        Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                          -TargetSkillsPath $targetSkillsPath `
                          -Mode Full

        # Step 2: 合併工作流技能（.agents/workflow-skills/ → .agents/skills/）
        Write-Step "合併工作流技能（workflow-skills/ → .agents/skills/）..."
        if (Test-Path $srcWorkflowSkills) {
            Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
                                  -TargetSkillsPath $targetSkillsPath
        } else {
            Write-Warn "workflow-skills/ 不存在，跳過工作流技能合併。"
        }

        # 基礎設施確保
        Initialize-AgentInfrastructure -AgentsRoot $agentsRoot

        # .gitignore 設定
        Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

        # 衍生技能 Backfill
        Write-Step "掃描並補建衍生技能命名空間連結..."
        Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

        # 寫入版本號（在 .agents/ 下）
        $versionFile = Join-Path $agentsRoot "VERSION"
        Set-Content $versionFile $version -NoNewline
        Write-Ok ".agents\VERSION → $version"

    } finally {
        Restore-ProtectedDirs -Backup $backup -AgentsRoot $agentsRoot

        # 統計
        $skillCount = @(Get-ChildItem $targetSkillsPath -Directory -ErrorAction SilentlyContinue |
            Where-Object { (Test-Path (Join-Path $_.FullName "SKILL.md")) }).Count
        $codexFiles = @(Get-ChildItem $dstDotCodex -File -Recurse -ErrorAction SilentlyContinue).Count

        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host "  Codex v$version 框架已部署完成。" -ForegroundColor Green
        Write-Host "  技能: $skillCount 套（共用 + 工作流）| .codex: $codexFiles 個治理檔案" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host ""
    }
}

function Invoke-CodexUpgrade {
    <#
    .SYNOPSIS
        Codex Upgrade 部署 — 差異比對升級 .codex/ 與技能目錄。
    .PARAMETER FrameworkRoot
        Codex/ 框架根目錄
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

    $srcDotCodex     = Join-Path $FrameworkRoot ".codex"
    $dstDotCodex     = Join-Path $Target ".codex"
    $agentsRoot      = Join-Path $Target ".agents"
    $targetSkillsPath = Join-Path $agentsRoot "skills"
    $version         = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")

    if (-Not (Test-Path $dstDotCodex)) {
        Write-Warn "目標尚未安裝 Codex，切換為 Fresh 模式。"
        Invoke-CodexFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        return
    }

    $targetVersion = Get-VersionContent -Path (Join-Path $agentsRoot "VERSION")
    Write-Banner "Codex Upgrade v$targetVersion → v$version | 目標: $Target" "DarkCyan"

    # 掃描 .codex/ 差異
    Write-Step "正在掃描 .codex/ 差異..."
    $report = Get-UpgradeReport `
        -SourceRoot $srcDotCodex `
        -TargetRoot $dstDotCodex `
        -ScanDirs @(".") `
        -ProtectedDirs @() `
        -ExcludeFiles @()

    $categoryMap = [ordered]@{
        "治理規則 (.codex/)" = { $true }
    }
    $stats = Write-UpgradeReport -Report $report -CategoryMap $categoryMap -Platform "Codex"

    # CHANGELOG
    $notesPath = Join-Path $FrameworkRoot "CHANGELOG.md"
    $notes = Get-ReleaseNotes -ChangelogPath $notesPath
    if ($notes.Count -gt 0) {
        Write-Host ""
        Write-Host "  📋 最新版本更新說明" -ForegroundColor White
        foreach ($noteLine in $notes) { Write-Host "  $noteLine" }
    }

    # .codex/AGENTS.md PROJECT IDENTITY 保護
    $codexAgentsMdPath = Join-Path $dstDotCodex "AGENTS.md"
    $savedIdentity = $null
    if (Test-Path $codexAgentsMdPath) {
        $codexContent = Get-Content $codexAgentsMdPath -Raw
        if ($codexContent -match '(?s)(## \[PROJECT IDENTITY[^\r\n]*\r?\n.*?<!-- /PROJECT_IDENTITY_END -->)') {
            $savedIdentity = $Matches[1]
            Write-Step "偵測到 PROJECT IDENTITY 保護區段，升級後將自動還原。"
        }
    }

    # 確認閘門
    $applied = 0
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        if (Invoke-ConfirmGate -Message "是否套用 .codex/ 變更？(Y/N)") {
            $applied = Install-Upgrade -Report $report -SourceRoot $srcDotCodex -TargetRoot $dstDotCodex
        } else {
            Write-Warn "已跳過 .codex/ 更新。"
        }
    } else {
        Write-Ok ".codex/ 檔案均已是最新版本，無需更新。"
    }

    # PROJECT IDENTITY 還原
    if ($savedIdentity -and (Test-Path $codexAgentsMdPath)) {
        $newContent = Get-Content $codexAgentsMdPath -Raw
        if ($newContent -notmatch '## \[PROJECT IDENTITY') {
            $restored = $newContent.TrimEnd() + "`n`n" + $savedIdentity
            [System.IO.File]::WriteAllText($codexAgentsMdPath, $restored, [System.Text.Encoding]::UTF8)
            Write-Ok "PROJECT IDENTITY 保護區段已還原（UTF-8）。"
        }
    }

    # 技能差異注入（兩步驟）
    Write-Step "同步共用技能差異（Shared/skills/ → .agents/skills/）..."
    Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                      -TargetSkillsPath $targetSkillsPath `
                      -Mode Diff

    # 工作流技能差異合併
    $srcWorkflowSkills = Join-Path $FrameworkRoot ".agents\workflow-skills"
    if (Test-Path $srcWorkflowSkills) {
        Write-Step "同步工作流技能差異（workflow-skills/ → .agents/skills/）..."
        Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
                              -TargetSkillsPath $targetSkillsPath
    }

    # 基礎設施確保
    Initialize-AgentInfrastructure -AgentsRoot $agentsRoot

    # Backfill
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

    # 版本更新
    $versionFile = Join-Path $agentsRoot "VERSION"
    Set-Content $versionFile $version -NoNewline
    Write-Ok ".agents\VERSION → $version"

    Write-Banner "升級完成 — Codex v$version（更新 $applied 個 .codex/ 檔案）" "Green"
}

Export-ModuleMember -Function Invoke-CodexFresh, Invoke-CodexUpgrade
