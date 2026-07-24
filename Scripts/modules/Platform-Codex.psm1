#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — Codex 平台部署模組
.DESCRIPTION
    提供 Invoke-CodexFresh 與 Invoke-CodexUpgrade 兩個函式，
    處理 .codex/ 目錄與 .agents/skills/ 的全新安裝與差異升級。
    Codex 原生掃描 .agents/skills/，工作流技能合併至同一目錄。
#>

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Core.psm1') -Force -ErrorAction Stop
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Skills-Sync.psm1') -Force -ErrorAction Stop

function Merge-CodexConfigDefaults {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath,

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
    if (-not $maxThreadsLine) { $maxThreadsLine = "max_threads = 8" }

    $current = ''
    if (Test-Path -LiteralPath $TargetPath -PathType Leaf) {
        $current = Get-Content -LiteralPath $TargetPath -Raw -Encoding UTF8
    }

    $text = $current
    $actions = @()

    $before = $text
    $text = Add-TomlTopLevelKeyIfMissing -Text $text -Key "project_doc_fallback_filenames" -Line $fallbackLine
    if ($text -ne $before) { $actions += "add top-level project_doc_fallback_filenames" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "multi_agent"
    if ($text -ne $before) { $actions += "set [features].multi_agent = true" }

    $before = $text
    $text = Set-TomlSectionBooleanTrue -Text $text -Section "features" -Key "hooks"
    if ($text -ne $before) { $actions += "set [features].hooks = true" }

    $before = $text
    $text = Add-TomlSectionKeyIfMissing -Text $text -Section "agents" -Key "max_threads" -Line $maxThreadsLine
    if ($text -ne $before) { $actions += "add [agents].max_threads default" }

    $merged = $text.TrimEnd() + "`n"
    if ($current -eq $merged) {
        Write-Step "Codex config.toml required keys already match section-aware defaults: $TargetPath"
        return [PSCustomObject]@{ Changed = $false; Actions = @(); TargetPath = $TargetPath }
    }

    if (-not $Apply) {
        Write-Warn "Codex config.toml would be updated ($($actions -join '; ')): $TargetPath"
        return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
    }

    $targetDir = Split-Path $TargetPath -Parent
    if (-not (Test-Path -LiteralPath $targetDir)) { New-Item -ItemType Directory -Force -Path $targetDir | Out-Null }
    [System.IO.File]::WriteAllText($TargetPath, $merged, [System.Text.UTF8Encoding]::new($false))
    Write-Ok "Codex config.toml defaults merged ($($actions -join '; ')): $TargetPath"
    return [PSCustomObject]@{ Changed = $true; Actions = $actions; TargetPath = $TargetPath }
}

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
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\adapters\codex-subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    $null = Get-SharedPolicyBlock -PolicyPath $sharedPolicyPath -Platform Codex

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
                if (($rel -replace '\\', '/') -eq 'config.toml') { return }
                $dst    = Join-Path $dstDotCodex $rel
                $dstDir = Split-Path $dst -Parent
                if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory $dstDir -Force | Out-Null }
                Copy-Item $_.FullName $dst -Force
            }
            $null = Merge-CodexConfigDefaults -SourcePath (Join-Path $srcDotCodex "config.toml") -TargetPath (Join-Path $dstDotCodex "config.toml") -Apply
            Write-Ok ".codex/ 治理規則已部署"

            Write-Step "注入共用子代理政策（Shared/policies/ → .codex/AGENTS.md）..."
            $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
                -TargetPath (Join-Path $dstDotCodex "AGENTS.md") `
                -Platform Codex `
                -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
        } else {
            Write-Warn ".codex/ 源碼不存在，跳過。"
        }

        # 技能注入（兩步驟）：
        # Step 1: 注入共用技能（Shared/skills/ → .agents/skills/）
        Write-Step "注入共用技能（Shared/skills/ → .agents/skills/）..."
        $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                          -TargetSkillsPath $targetSkillsPath `
                          -Mode Full

        # Step 2: 合併工作流技能（.agents/workflow-skills/ → .agents/skills/）
        Write-Step "合併工作流技能（workflow-skills/ → .agents/skills/）..."
        if (Test-Path $srcWorkflowSkills) {
            $null = Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
                                  -TargetSkillsPath $targetSkillsPath
        } else {
            Write-Warn "workflow-skills/ 不存在，跳過工作流技能合併。"
        }

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

        # 寫入 Codex 專屬版本號，避免與 Antigravity 共用 .agents/VERSION。
        $versionFile = Join-Path $dstDotCodex "VERSION"
        Set-Content $versionFile $version -NoNewline
        Write-Ok ".codex\VERSION → $version"

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
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\adapters\codex-subagent-invocation.md"
    $contextTemplatesRoot = Join-Path (Split-Path $SharedSkillsRoot -Parent) "context"

    $null = Get-SharedPolicyBlock -PolicyPath $sharedPolicyPath -Platform Codex

    if (-Not (Test-Path $dstDotCodex)) {
        Write-Warn "目標尚未安裝 Codex，切換為 Fresh 模式。"
        Invoke-CodexFresh -FrameworkRoot $FrameworkRoot -Target $Target -SharedSkillsRoot $SharedSkillsRoot
        return
    }

    $targetVersion = Get-VersionContent -Path (Join-Path $dstDotCodex "VERSION")
    if ($targetVersion -eq "unknown") {
        $targetVersion = Get-VersionContent -Path (Join-Path $agentsRoot "VERSION")
    }
    Write-Banner "Codex Upgrade v$targetVersion → v$version | 目標: $Target" "DarkCyan"

    # 掃描 .codex/ 差異
    Write-Step "正在掃描 .codex/ 差異..."
    $report = Get-UpgradeReport `
        -SourceRoot $srcDotCodex `
        -TargetRoot $dstDotCodex `
        -ScanDirs @(".") `
        -ProtectedDirs @() `
        -ExcludeFiles @("config.toml")

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
            Write-Step "偵測到 PROJECT IDENTITY 保護區段；若本次套用 .codex/ 變更，升級後將自動還原。"
        }
    }

    # 確認閘門
    $applied = 0
    $applyCodexChanges = $true
    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        if (Invoke-ConfirmGate -Message "是否套用 .codex/ 變更？(Y/N)") {
            $applied = Install-Upgrade -Report $report -SourceRoot $srcDotCodex -TargetRoot $dstDotCodex
        } else {
            Write-Warn "已跳過 .codex/ 更新；本次不會寫入 .codex/config.toml、.codex/AGENTS.md 或 .codex/VERSION。"
            $applyCodexChanges = $false
        }
    } else {
        Write-Ok ".codex/ 檔案均已是最新版本，無需更新。"
    }

    if ($applyCodexChanges) {
        $null = Merge-CodexConfigDefaults -SourcePath (Join-Path $srcDotCodex "config.toml") -TargetPath (Join-Path $dstDotCodex "config.toml") -Apply
    } else {
        Write-Warn "已跳過 Codex config.toml 合併；因本次 .codex/ 差異檔案更新未套用。"
    }

    # PROJECT IDENTITY 還原
    if ($applyCodexChanges -and $savedIdentity -and (Test-Path $codexAgentsMdPath)) {
        $newContent = Get-Content $codexAgentsMdPath -Raw
        if ($newContent -notmatch '## \[PROJECT IDENTITY') {
            $restored = $newContent.TrimEnd() + "`n`n" + $savedIdentity
            [System.IO.File]::WriteAllText($codexAgentsMdPath, $restored, [System.Text.Encoding]::UTF8)
            Write-Ok "PROJECT IDENTITY 保護區段已還原（UTF-8）。"
        }
    }

    if ($applyCodexChanges) {
        Write-Step "同步共用子代理政策（Shared/policies/ → .codex/AGENTS.md）..."
        $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
            -TargetPath $codexAgentsMdPath `
            -Platform Codex `
            -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
    } else {
        Write-Warn "已跳過共用子代理政策同步至 .codex/AGENTS.md；因本次 .codex/ 差異檔案更新未套用。"
    }

    # 技能差異注入（兩步驟）
    Write-Step "同步共用技能差異（Shared/skills/ → .agents/skills/）..."
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot `
                      -TargetSkillsPath $targetSkillsPath `
                      -Mode Diff

    # 工作流技能差異合併
    $srcWorkflowSkills = Join-Path $FrameworkRoot ".agents\workflow-skills"
    if (Test-Path $srcWorkflowSkills) {
        Write-Step "同步工作流技能差異（workflow-skills/ → .agents/skills/）..."
        $null = Merge-WorkflowSkills -WorkflowSkillsPath $srcWorkflowSkills `
                              -TargetSkillsPath $targetSkillsPath
    }

    Write-Step "同步共用治理參考（Shared/ → .agents/shared/）..."
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot `
                      -TargetAgentsRoot $agentsRoot `
                      -Mode Diff

    Write-Step "同步專案本地工具（Shared/project-tools/ → .agents/tools/）..."
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot `
                      -TargetAgentsRoot $agentsRoot `
                      -Mode Diff

    # 基礎設施確保
    Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot

    # .gitignore 設定
    Set-GitignoreEntries -ProjectRoot $Target -Lines @(".agents/logs/", ".cartridge/")

    # Backfill
    Write-Step "掃描並補建衍生技能命名空間連結..."
    Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot

    # 版本更新：Codex 專屬版本錨點在 .codex/，.agents/VERSION 保留給 Antigravity。
    $versionFile = Join-Path $dstDotCodex "VERSION"
    if ($applyCodexChanges) {
        Set-Content $versionFile $version -NoNewline
        Write-Ok ".codex\VERSION → $version"
    } else {
        Write-Warn "已跳過 .codex\VERSION 寫入；因本次 .codex/ 差異檔案更新未套用。"
    }

    if ($applyCodexChanges) {
        Write-Banner "升級完成 — Codex v$version（更新 $applied 個 .codex/ 差異檔案）" "Green"
    } else {
        Write-Banner "升級完成 — 已跳過 .codex/ 更新（其他非 .codex 同步仍已執行）" "Green"
    }
}

Export-ModuleMember -Function Invoke-CodexFresh, Invoke-CodexUpgrade
