#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Antigravity (Gemini) 平台部署模組
.DESCRIPTION
    提供 Invoke-AgFresh 與 Invoke-AgUpgrade 兩個函式，
    分別處理 .agents/ 目錄的全新安裝與差異升級。
    從 Deploy-Antigravity.ps1 遷移，邏輯完整保留。
#>

using module ".\Core.psm1"
using module ".\Skills-Sync.psm1"

function Invoke-AgFresh {
    <#
    .SYNOPSIS
        Antigravity Fresh 部署 — 全新安裝 .agents/ 目錄。
    .PARAMETER FrameworkRoot
        Antigravity 框架根目錄（含 .agents/ 子目錄）
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

    $sourceDir  = Join-Path $FrameworkRoot ".agents"
    $targetDir  = Join-Path $Target ".agents"
    $version    = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")
    $agentsRoot = $targetDir
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    Write-Banner "Antigravity v$version — Fresh 安裝 | 目標: $Target" "Magenta"

    if (-Not (Test-Path $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }

    # D06 安全網備份
    $backup = Backup-ProtectedDirs -AgentsRoot $agentsRoot

    try {
        # 建立目標 .agents/ 目錄
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        Write-Step "部署 .agents/ 框架檔案（rules/workflows）..."

        # 複製 rules/workflows（排除受保護知識層與 skills/，由 Shared/ 注入）
        Get-ChildItem $sourceDir | Where-Object {
            $_.Name -notin @("memory", "project_skills", "context", "skills")
        } | ForEach-Object {
            Copy-Item $_.FullName $targetDir -Recurse -Force
        }

        Write-Step "注入共用子代理政策（Shared/policies/ → .agents/rules/00_core_identity.md）..."
        $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
            -TargetPath (Join-Path $targetDir "rules\00_core_identity.md") `
            -Platform Antigravity `
            -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'

        # 技能注入：從 Shared/ 注入 36 套共用技能
        Write-Step "注入共用技能（Shared/skills/）..."
        $targetSkillsPath = Join-Path $targetDir "skills"
        $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                          -TargetSkillsPath $targetSkillsPath `
                          -Mode Full

        Write-Step "注入共用治理參考（Shared/ → .agents/shared/）..."
        $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot `
                          -TargetAgentsRoot $agentsRoot `
                          -Mode Full

        Write-Step "注入專案本地工具（Shared/project-tools/ → .agents/tools/）..."
        $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot `
                          -TargetAgentsRoot $agentsRoot `
                          -Mode Full

        # 基礎設施確保
        Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot

        # .gitignore 設定
        Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

        # 衍生技能 Backfill
        Write-Step "掃描並補建衍生技能命名空間連結..."
        Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

        # 寫入版本號
        $versionFile = Join-Path $targetDir "VERSION"
        Set-Content $versionFile $version -NoNewline
        Write-Ok "版本 v$version 已寫入。"

    } finally {
        Restore-ProtectedDirs -Backup $backup -AgentsRoot $agentsRoot

        # 統計
        $skillsDir = Join-Path $targetDir "skills"
        $totalSkills   = @(Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue |
            Where-Object { ($_.Name -notmatch '^project-') -and (Test-Path (Join-Path $_.FullName "SKILL.md")) }).Count
        $linkedSkills  = @(Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -like "project-*" }).Count
        $memDir        = Join-Path $targetDir "memory"
        $memCards      = @(Get-ChildItem $memDir -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }).Count
        $ctxDir        = Join-Path $targetDir "context"
        $contextCards  = @(Get-ChildItem $ctxDir -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName "CONTEXT.md") }).Count

        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host "  Antigravity v$version 框架已部署完成。" -ForegroundColor Green
        Write-Host "  技能: $totalSkills 套核心 + $linkedSkills 套衍生（已掛載）+ $memCards 張記憶卡 + $contextCards 張脈絡卡" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
        Write-Host ""
    }
}

function Invoke-AgUpgrade {
    <#
    .SYNOPSIS
        Antigravity Upgrade 部署 — 差異比對升級 .agents/ 目錄。
    .PARAMETER FrameworkRoot
        Antigravity 框架根目錄
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

    $sourceDir  = Join-Path $FrameworkRoot ".agents"
    $targetDir  = Join-Path $Target ".agents"
    $version    = Get-VersionContent -Path (Join-Path $FrameworkRoot "VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    if (-Not (Test-Path $targetDir)) {
        Write-Warn "目標尚未安裝 Antigravity，切換為 Fresh 模式。"
        Invoke-AgFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        return
    }

    $targetVersion = Get-VersionContent -Path (Join-Path $targetDir "VERSION")
    Write-Banner "Antigravity Upgrade v$targetVersion → v$version | 目標: $Target" "DarkCyan"

    Write-Step "正在掃描 .agents/ 差異（rules/workflows）..."

    # 掃描框架結構檔案（不掃 skills/，技能由 Shared/ 獨立管理）
    $categoryMap = [ordered]@{
        "規則 (Rules)"          = { $_.Path -like "rules/*" }
        "工作流程 (Workflows)"  = { $_.Path -like "workflows/*" }
        "專案記憶 — 受保護"    = { $_.Path -like "memory/*" -and $_.Status -eq "KEEP" }
        "衍生技能 — 受保護"    = { $_.Path -like "project_skills/*" -and $_.Status -eq "KEEP" }
        "專案脈絡 — 受保護"    = { $_.Path -like "context/*" -and $_.Status -eq "KEEP" }
    }

    $report = Get-UpgradeReport `
        -SourceRoot $sourceDir `
        -TargetRoot $targetDir `
        -ScanDirs @("rules", "workflows") `
        -ProtectedDirs @("memory", "project_skills", "context") `
        -ExcludeFiles @()

    $stats = Write-UpgradeReport -Report $report -CategoryMap $categoryMap -Platform "Antigravity"

    # 顯示 CHANGELOG
    $notesPath = Join-Path $FrameworkRoot "CHANGELOG.md"
    $notes = Get-ReleaseNotes -ChangelogPath $notesPath
    if ($notes.Count -gt 0) {
        Write-Host ""
        Write-Host "  📋 最新版本更新說明" -ForegroundColor White
        foreach ($noteLine in $notes) { Write-Host "  $noteLine" }
    }

    # AGENTS.md PROJECT IDENTITY 保護
    $agentsMdPath = Join-Path $targetDir "rules\AGENTS.md"
    $savedIdentity = $null
    if (Test-Path $agentsMdPath) {
        $agentsContent = Get-Content $agentsMdPath -Raw
        if ($agentsContent -match '(?s)(## \[PROJECT IDENTITY[^\r\n]*\r?\n.*?<!-- /PROJECT_IDENTITY_END -->)') {
            $savedIdentity = $Matches[1]
            Write-Step "偵測到 PROJECT IDENTITY 保護區段，升級後將自動還原。"
        }
    }

    # 確認閘門
    $applied = 0
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        if (Invoke-ConfirmGate -Message "是否套用框架檔案變更？(Y/N)") {
            Write-Step "正在套用變更..."
            $applied = Install-Upgrade -Report $report -SourceRoot $sourceDir -TargetRoot $targetDir
        } else {
            Write-Warn "已跳過框架檔案更新。"
        }
    } else {
        Write-Ok "框架檔案均已是最新版本，無需更新。"
    }

    # 技能差異注入
    Write-Step "同步技能差異（Shared/skills/）..."
    $targetSkillsPath = Join-Path $targetDir "skills"
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                      -TargetSkillsPath $targetSkillsPath `
                      -Mode Diff

    Write-Step "同步共用治理參考（Shared/ → .agents/shared/）..."
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot `
                      -TargetAgentsRoot $targetDir `
                      -Mode Diff

    Write-Step "同步專案本地工具（Shared/project-tools/ → .agents/tools/）..."
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot `
                      -TargetAgentsRoot $targetDir `
                      -Mode Diff

    # PROJECT IDENTITY 還原
    if ($savedIdentity -and (Test-Path $agentsMdPath)) {
        $newContent = Get-Content $agentsMdPath -Raw
        if ($newContent -notmatch '## \[PROJECT IDENTITY') {
            $restored = $newContent.TrimEnd() + "`n`n" + $savedIdentity
            [System.IO.File]::WriteAllText($agentsMdPath, $restored, [System.Text.Encoding]::UTF8)
            Write-Ok "PROJECT IDENTITY 保護區段已還原（UTF-8）。"
        }
    }

    Write-Step "同步共用子代理政策（Shared/policies/ → .agents/rules/00_core_identity.md）..."
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $targetDir "rules\00_core_identity.md") `
        -Platform Antigravity `
        -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'

    # 孤兒處理
    if ($stats.Orphan -gt 0) {
        if ($RemoveOrphans) {
            Remove-OrphanFiles -Report $report -TargetRoot $targetDir -ProtectedDirs @("memory", "project_skills", "context")
        } else {
            Write-Warn "$($stats.Orphan) 個孤兒檔案。加入 -RemoveOrphans 可自動清除。"
        }
    }

    # 基礎設施確保
    Initialize-AgentInfrastructure -AgentsRoot $targetDir -ContextTemplatesRoot $contextTemplatesRoot

    # .gitignore 設定
    Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

    # Backfill
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $targetDir

    # 版本更新
    $versionFile = Join-Path $targetDir "VERSION"
    Set-Content $versionFile $version -NoNewline
    Write-Ok ".agents\VERSION → $version"

    Write-Banner "升級完成 — Antigravity v$version（更新 $applied 個框架檔案）" "Green"
}

Export-ModuleMember -Function Invoke-AgFresh, Invoke-AgUpgrade
