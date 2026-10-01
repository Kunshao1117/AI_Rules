#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Framework Manager — 統一部署主入口
.DESCRIPTION
    管理 Antigravity、Claude Edition、Codex、Cursor 四個平台的部署。
    支援選單模式（無參數互動）與參數模式（自動化呼叫）兩用。
.PARAMETER Platform
    目標平台：Antigravity / Claude / Codex / Cursor / All
.PARAMETER Mode
    操作模式：Fresh / Upgrade / Sync
.PARAMETER Target
    目標專案絕對路徑（Fresh/Upgrade 必填，預設為當前目錄）
.PARAMETER Action
    特殊動作：Global（安裝/更新全局觸發器）
.PARAMETER RemoveOrphans
    Upgrade 模式：列報並保留未知所有權的孤兒檔案；退休只採明確雜湊名單
.PARAMETER Apply
    Global 動作：實際寫入使用者層全域規則；未指定時只報告差異
.PARAMETER ProfileRoot
    使用者層全域規則根目錄。預設為目前使用者 Profile，可用於 temp profile 測試
.PARAMETER RuntimeCopyResolutionPath
    An invocation-scoped, exact 58-path resolution supplied only after a separate user decision.
.PARAMETER Gate3AEvidencePath
    The exact Gate 3A individual-records evidence bound by that resolution.
.EXAMPLE
    # 選單模式
    .\Deploy.ps1

    # 參數模式
    .\Deploy.ps1 -Platform Antigravity -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform Claude -Mode Upgrade
    .\Deploy.ps1 -Platform Codex -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform Cursor -Mode Fresh -Target "D:\MyProject"
    .\Deploy.ps1 -Platform All -Mode Sync
    .\Deploy.ps1 -Action Global
    .\Deploy.ps1 -Action Global -Apply
#>
param(
    [ValidateSet("Antigravity", "Claude", "Codex", "Cursor", "All")]
    [string]$Platform,

    [ValidateSet("Fresh", "Upgrade", "Sync")]
    [string]$Mode,

    [string]$Target = $PWD.Path,

    [ValidateSet("Global")]
    [string]$Action,

    [switch]$RemoveOrphans,

    [switch]$Apply,

    [string]$ProfileRoot = $env:USERPROFILE,

    [string]$RuntimeCopyResolutionPath = '',

    [string]$Gate3AEvidencePath = ''
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
$SharedAdapterRoot = Join-Path $RepoRoot "Shared\policies\adapters"
$SharedAdapterPaths = @{
    Antigravity = Join-Path $SharedAdapterRoot "antigravity-subagent-invocation.md"
    Claude      = Join-Path $SharedAdapterRoot "claude-subagent-invocation.md"
    Codex       = Join-Path $SharedAdapterRoot "codex-subagent-invocation.md"
    Cursor      = Join-Path $SharedAdapterRoot "cursor-subagent-invocation.md"
}
$AgRoot           = Join-Path $RepoRoot "Antigravity"
$ClaudeRoot       = Join-Path $RepoRoot "Claude"
$CodexRoot        = Join-Path $RepoRoot "Codex"
$CursorRoot       = Join-Path $RepoRoot "Cursor"

# ── 模組載入 ──────────────────────────────────────────────────────────────────
Import-Module (Join-Path $ModulesDir "Core.psm1")            -Force
Import-Module (Join-Path $ModulesDir "Skills-Sync.psm1")     -Force
Import-Module (Join-Path $ModulesDir "Platform-Antigravity.psm1") -Force
Import-Module (Join-Path $ModulesDir "Platform-Claude.psm1") -Force
Import-Module (Join-Path $ModulesDir "Platform-Codex.psm1")  -Force
Import-Module (Join-Path $ModulesDir "Platform-Cursor.psm1") -Force
Import-Module (Join-Path $ModulesDir "Deployment.Transaction.psm1") -Force
Import-Module (Join-Path $ModulesDir "Runtime-Copy-Resolution.psm1") -Force

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
                    Sync-SharedPolicyBlock -PolicyPath $SharedAdapterPaths.Antigravity `
                        -TargetPath (Join-Path $TargetPath ".agents\rules\00_core_identity.md") `
                        -Platform Antigravity `
                        -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'
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
                    Sync-SharedPolicyBlock -PolicyPath $SharedAdapterPaths.Claude `
                        -TargetPath (Join-Path $TargetPath ".claude\rules\core-identity.md") `
                        -Platform Claude `
                        -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'
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
                    Sync-SharedPolicyBlock -PolicyPath $SharedAdapterPaths.Codex `
                        -TargetPath (Join-Path $TargetPath ".codex\AGENTS.md") `
                        -Platform Codex `
                        -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
                }
            }
        }
        "Cursor" {
            switch ($DeployMode) {
                "Fresh"   { Invoke-CursorFresh   -FrameworkRoot $CursorRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot }
                "Upgrade" { Invoke-CursorUpgrade -FrameworkRoot $CursorRoot -Target $TargetPath -SharedSkillsRoot $SharedSkillsRoot -RemoveOrphans:$RemoveOrphans }
                "Sync"    {
                    Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath (Join-Path $TargetPath ".cursor\skills") -Mode Diff
                    Sync-SharedGovernanceReferences -SharedRoot $SharedRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-ProjectTools -ProjectToolsRoot $ProjectToolsRoot -TargetAgentsRoot (Join-Path $TargetPath ".agents") -Mode Diff
                    Sync-SharedPolicyBlock -PolicyPath $SharedAdapterPaths.Cursor `
                        -TargetPath (Join-Path $TargetPath ".cursor\rules\00-core.mdc") `
                        -Platform Cursor `
                        -InsertAfterPattern '(?m)^Cursor-specific governance:\s*$'
                }
            }
        }
    }
}

# ══════════════════════════════════════════════════════════
# 選單模式（無參數時啟動）
# ══════════════════════════════════════════════════════════

function Invoke-ProjectDeployBatch {
    param([string]$SelectedPlatform, [string]$SelectedMode, [string]$SelectedTarget,
          [object]$ResolutionInput = $null, [string]$EvidencePath = '')
    $platforms = if ($SelectedPlatform -eq 'All') {
        @('Antigravity', 'Claude', 'Codex', 'Cursor')
    } else { @($SelectedPlatform) }
    $candidate = $null; $archive = $null; $receipts = @()
    if ($null -ne $ResolutionInput) {
        if ($SelectedPlatform -cne 'All' -or $SelectedMode -cne 'Upgrade') {
            throw 'RuntimeCopyResolution.RequiresAllPlatformUpgrade'
        }
        if (-not $EvidencePath) { throw 'RuntimeCopyResolution.EvidencePathRequired' }
        Import-Module (Join-Path $ModulesDir 'Deployment.Preflight.psm1') -Force
        Import-Module (Join-Path $ModulesDir 'Deployment.Transaction.psm1') -Force
        $receipts = @(Get-Content -LiteralPath $EvidencePath -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json)
        $basePlan = @(Get-DeploymentUpgradePreflight -RepoRoot $RepoRoot -TargetRoot $SelectedTarget -ProvenanceReceipts $receipts)
        $candidate = Get-RuntimeCopyResolutionCandidate -RepoRoot $RepoRoot -TargetRoot $SelectedTarget -Gate3AEvidencePath $EvidencePath -BasePlan $basePlan
        Assert-RuntimeCopyResolution -Candidate $candidate -Resolution $ResolutionInput -SelectedPlatform $SelectedPlatform
        $otherBlockers = @($basePlan | Where-Object { $_.blocking -and $_.target_path -cnotin @($candidate.targets | ForEach-Object path) })
        if ($otherBlockers.Count -gt 0) { throw 'RuntimeCopyResolution.OtherDeploymentBlockersRemain' }
        $resolvedPlan = @(Get-DeploymentUpgradePreflight -RepoRoot $RepoRoot -TargetRoot $SelectedTarget -ProvenanceReceipts $receipts -RuntimeCopyResolution $ResolutionInput -Gate3AEvidencePath $EvidencePath -SelectedPlatform $SelectedPlatform)
        if (@($resolvedPlan | Where-Object { $_.resolution_basis -eq 'invocation_scoped_user_decision' -and $_.planned_action -eq 'RETIRE' }).Count -ne 58) {
            throw 'RuntimeCopyResolution.PreflightApplyMismatch'
        }
        $archiveRoot = Join-Path $ProfileRoot '.ai_rules/deployment-archives'
        $archive = New-RuntimeCopyArchive -Candidate $candidate -Resolution $ResolutionInput -RepoRoot $RepoRoot -ArchiveRoot $archiveRoot
    }
    $batchOutput = @(Invoke-DeploymentTransaction -TargetRoot $SelectedTarget -Action {
        if ($null -ne $ResolutionInput) {
            $freshPlan = @(Get-DeploymentUpgradePreflight -RepoRoot $RepoRoot -TargetRoot $SelectedTarget -ProvenanceReceipts $receipts)
            $freshCandidate = Get-RuntimeCopyResolutionCandidate -RepoRoot $RepoRoot -TargetRoot $SelectedTarget -Gate3AEvidencePath $EvidencePath -BasePlan $freshPlan
            Assert-RuntimeCopyResolution -Candidate $freshCandidate -Resolution $ResolutionInput -SelectedPlatform $SelectedPlatform
            $null = Assert-RuntimeCopyArchive -Candidate $freshCandidate -Resolution $ResolutionInput -ArchivePath $archive
            Remove-ResolvedRuntimeCopies -Candidate $freshCandidate -Resolution $ResolutionInput -ArchivePath $archive
        }
        foreach ($p in $platforms) {
            $platformOutput = @(Invoke-PlatformDeploy -PlatformName $p -DeployMode $SelectedMode -TargetPath $SelectedTarget)
            $platformOutput
            if (@($platformOutput | Where-Object {
                $null -ne $_ -and $null -ne $_.PSObject.Properties['Succeeded'] -and -not $_.Succeeded
            }).Count -gt 0) { return }
        }
        if ($null -ne $ResolutionInput) {
            foreach ($entry in $candidate.targets) {
                if (Test-Path -LiteralPath (Join-Path $SelectedTarget $entry.path)) {
                    throw "RuntimeCopyResolution.RetiredEntryStillActive: $($entry.path)"
                }
            }
            Import-Module (Join-Path $ModulesDir 'Claude-Agent-Projection.psm1') -Force
            foreach ($agent in @(Get-ClaudeAgentSourceFiles -FrameworkRoot $ClaudeRoot -SharedRoot $SharedRoot)) {
                $targetAgent = Join-Path $SelectedTarget $agent.TargetRelativePath
                if (-not (Test-Path -LiteralPath $targetAgent -PathType Leaf) -or
                    (Get-FileHash -LiteralPath $targetAgent -Algorithm SHA256).Hash -ne
                    (Get-FileHash -LiteralPath $agent.SourcePath -Algorithm SHA256).Hash) {
                    throw "RuntimeCopyResolution.AgentProjectionSmokeFailed: $($agent.TargetRelativePath)"
                }
            }
            $null = Assert-RuntimeCopyArchive -Candidate $candidate -Resolution $ResolutionInput -ArchivePath $archive
        }
    })
    $batchOutput
    if ($null -ne $ResolutionInput -and @($batchOutput | Where-Object {
        $null -ne $_ -and $null -ne $_.PSObject.Properties['Succeeded'] -and -not $_.Succeeded
    }).Count -gt 0) {
        throw 'RuntimeCopyResolution.DeploymentRolledBack'
    }
}

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
    Write-Host "    [4] Cursor" -ForegroundColor DarkCyan
    Write-Host "    [5] 全部平台 (All)" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  操作選擇:" -ForegroundColor White
    Write-Host "    [F] Fresh   全新安裝（目標目錄由下一步指定）" -ForegroundColor Green
    Write-Host "    [U] Upgrade 差異升級" -ForegroundColor Yellow
    Write-Host "    [S] Sync    僅同步技能" -ForegroundColor DarkGray
    Write-Host "    [G] Global  安裝/更新全局觸發器" -ForegroundColor Cyan
    Write-Host "    [Q] 退出" -ForegroundColor DarkGray
    Write-Host ""

    $platInput = Read-Host "  選擇平台 [1/2/3/4/5]"
    $modeInput = Read-Host "  選擇操作 [F/U/S/G/Q]"

    if ($modeInput -match "^[Qq]$") { Write-Host "已退出。"; return }
    if ($modeInput -match "^[Gg]$") { Invoke-GlobalInstall; return }

    $selectedPlatform = switch ($platInput) {
        "1" { "Antigravity" }
        "2" { "Claude" }
        "3" { "Codex" }
        "4" { "Cursor" }
        "5" { "All" }
        default { Write-Fail "無效平台選擇"; return }
    }

    $selectedMode = switch ($modeInput.ToUpper()) {
        "F" { "Fresh" }
        "U" { "Upgrade" }
        "S" { "Sync" }
        default { Write-Fail "無效操作選擇"; return }
    }

    $selectedTarget = $Target
    if ($selectedMode -in @("Fresh", "Upgrade")) {
        $inputTarget = Read-Host "  目標專案路徑 [Enter 使用當前目錄: $Target]"
        if ($inputTarget -and $inputTarget.Trim()) { $selectedTarget = $inputTarget.Trim() }
    }

    Invoke-ProjectDeployBatch -SelectedPlatform $selectedPlatform -SelectedMode $selectedMode -SelectedTarget $selectedTarget
}

# ══════════════════════════════════════════════════════════
# 主流程：判斷參數模式或選單模式
# ══════════════════════════════════════════════════════════

if ($Action -eq "Global" -and ($RuntimeCopyResolutionPath -or $Gate3AEvidencePath)) {
    throw 'RuntimeCopyResolution.NotSupportedForGlobalAction'
}

if ($Action -eq "Global") {
    Invoke-GlobalInstall
    exit 0
}

if ($Platform -and $Mode) {
    # 參數模式
    $resolution = $null
    if ($RuntimeCopyResolutionPath) {
        Assert-DeploymentPathUnlinked -Path $RuntimeCopyResolutionPath
        $resolution = Get-Content -LiteralPath $RuntimeCopyResolutionPath -Raw -Encoding UTF8 -ErrorAction Stop | ConvertFrom-Json
    }
    Invoke-ProjectDeployBatch -SelectedPlatform $Platform -SelectedMode $Mode -SelectedTarget $Target -ResolutionInput $resolution -EvidencePath $Gate3AEvidencePath
} else {
    if ($RuntimeCopyResolutionPath) { throw 'RuntimeCopyResolution.RequiresExplicitPlatformAndMode' }
    # 選單模式
    Show-Menu
}
