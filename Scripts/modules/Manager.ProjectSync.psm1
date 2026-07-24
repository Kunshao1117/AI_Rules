#Requires -Version 5.1

Import-Module (Join-Path $PSScriptRoot "Core.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "Skills-Sync.psm1") -Force
Import-Module (Join-Path $PSScriptRoot "Manager.Config.psm1") -Force

function Set-ManagerProjectVersionFile {
    param(
        [string]$Path,
        [string]$Version,
        [switch]$Apply
    )

    $current = Get-VersionContent -Path $Path
    if (-not $Apply) {
        if ($current -eq $Version) {
            Write-Step "版本錨點已是最新: $Path ($Version)"
        } else {
            Write-Warn "版本錨點待更新: $Path ($current → $Version)"
        }
        return
    }

    $parent = Split-Path $Path -Parent
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Set-Content -LiteralPath $Path -Value $Version -NoNewline -Encoding UTF8
    Write-Ok "版本錨點已更新: $Path → $Version"
}

function Test-ManagerProjectPlatformInstalled {
    param(
        [string]$TargetRoot,
        [ValidateSet("Codex", "Claude", "Antigravity")]
        [string]$Platform
    )

    switch ($Platform) {
        "Codex" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".codex\AGENTS.md")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".codex\config.toml"))
        }
        "Claude" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\CLAUDE.md")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\commands")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".claude\rules"))
        }
        "Antigravity" {
            return (Test-Path -LiteralPath (Join-Path $TargetRoot ".agents\rules")) -or
                (Test-Path -LiteralPath (Join-Path $TargetRoot ".agents\workflows"))
        }
    }
}

function Get-ManagerInstalledProjectPlatforms {
    param([string]$TargetRoot)

    $platforms = @()
    foreach ($platform in @("Antigravity", "Claude", "Codex")) {
        if (Test-ManagerProjectPlatformInstalled -TargetRoot $TargetRoot -Platform $platform) {
            $platforms += $platform
        }
    }
    return $platforms
}

function Write-ManagerProjectSyncNoInstallWarning {
    param(
        [string]$TargetRoot,
        [string]$Platform
    )

    Write-Host ""
    Write-Host "📊 Project Platform Selection"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "🔴 Red：0  🟡 Yellow：1"
    Write-Warn "目前專案未安裝 $Platform，專案規則同步不會自動建立未使用的平台。"
    Write-Step "Target：$TargetRoot"
}

function Get-ManagerSharedSkillDiffs {
    param(
        [string]$SharedSkillsRoot,
        [string]$TargetSkillsPath
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $SharedSkillsRoot)) { return $diffs }

    Get-ChildItem -LiteralPath $SharedSkillsRoot -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $relPath = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
            Test-SharedSkillRelativePathIncluded -RelativePath $relPath
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($SharedSkillsRoot.Length).TrimStart('\', '/')
            $targetFile = Join-Path $TargetSkillsPath $rel
            $diff = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $targetFile -RelativePath $rel
            if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
        }

    return $diffs
}

function Get-ManagerCodexWorkflowDiffs {
    param(
        [string]$WorkflowSkillsPath,
        [string]$TargetSkillsPath
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $WorkflowSkillsPath)) { return $diffs }

    Get-ChildItem -LiteralPath $WorkflowSkillsPath -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $rel = $_.FullName.Substring($WorkflowSkillsPath.Length).TrimStart('\', '/')
            Test-CodexWorkflowRelativePathIncluded -RelativePath $rel
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($WorkflowSkillsPath.Length).TrimStart('\', '/')
            $targetFile = Join-Path $TargetSkillsPath $rel
            $diff = Compare-FrameworkFile -SourcePath $_.FullName -TargetPath $targetFile -RelativePath $rel
            if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
        }

    return $diffs
}

function Get-ManagerSharedGovernanceReferenceDiffs {
    param(
        [string]$SharedRoot,
        [string]$TargetAgentsRoot
    )

    $diffs = @()
    if (-not (Test-Path -LiteralPath $SharedRoot)) { return $diffs }

    foreach ($rel in @(Get-SharedGovernanceReferenceRelativePaths -SharedRoot $SharedRoot)) {
        $sourceFile = Join-Path $SharedRoot $rel
        if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) { continue }
        $targetFile = Join-Path (Join-Path $TargetAgentsRoot "shared") $rel
        $diff = Compare-FrameworkFile -SourcePath $sourceFile -TargetPath $targetFile -RelativePath $rel
        if ($diff.Status -in @("NEW", "CHANGED")) { $diffs += $diff }
    }

    return $diffs
}

function Write-ManagerDiffSummary {
    param(
        [string]$Title,
        [array]$Diffs
    )

    Write-Host ""
    Write-Host "📊 $Title"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host "NEW/CHANGED：$(@($Diffs).Count)"
    foreach ($diff in @($Diffs) | Select-Object -First 40) {
        Write-Host ("  [{0}] {1}" -f $diff.Status, $diff.Path) -ForegroundColor Yellow
    }
}

function Sync-ManagerProjectSkillLinks {
    param(
        [string]$TargetRoot,
        [string[]]$Platforms
    )

    $agentsRoot = Join-Path $TargetRoot ".agents"
    if (-not (Test-Path -LiteralPath (Join-Path $agentsRoot "project_skills"))) { return }

    Write-Host ""
    Write-Host "📊 Project Skill Links"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ($Platforms -contains "Antigravity" -or $Platforms -contains "Codex") {
        $null = Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir (Join-Path $agentsRoot "skills")
    }
    if ($Platforms -contains "Claude") {
        $claudeRoot = Join-Path $TargetRoot ".claude"
        if (Test-Path -LiteralPath $claudeRoot) {
            $null = Invoke-ProjectSkillBackfill -AgentsRoot $agentsRoot -SkillsDir (Join-Path $claudeRoot "skills")
        }
    }
}

function New-ManagerProjectSyncStageResult {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Stage,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Succeeded', 'Failed', 'Skipped')]
        [string]$Status,

        [string]$Detail = ''
    )

    return [PSCustomObject]@{
        Stage = $Stage
        Required = $true
        Status = $Status
        Succeeded = $Status -eq 'Succeeded'
        Detail = $Detail
    }
}

function Invoke-ManagerProjectSyncRequiredStage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Stage,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    try {
        $previousErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
        try {
            $null = & $Action
        } finally {
            $ErrorActionPreference = $previousErrorActionPreference
        }
        return New-ManagerProjectSyncStageResult -Stage $Stage -Status Succeeded
    } catch {
        $detail = $_.Exception.Message
        Write-Fail "專案規則同步必要階段失敗：$Stage ($detail)"
        return New-ManagerProjectSyncStageResult -Stage $Stage -Status Failed -Detail $detail
    }
}

function Assert-ManagerCodexPolicyPointerTemplate {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TemplatePath,

        [Parameter(Mandatory = $true)]
        [string]$PolicyPath
    )

    if (-not (Test-Path -LiteralPath $TemplatePath -PathType Leaf)) {
        throw "Codex source template is missing: $TemplatePath"
    }

    $content = Get-Content -LiteralPath $TemplatePath -Raw -Encoding UTF8 -ErrorAction Stop
    $startMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->'
    $endMarker = '<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->'
    $markerPattern = "(?ms)$([regex]::Escape($startMarker))\s*(.*?)\s*$([regex]::Escape($endMarker))"
    $matches = [regex]::Matches($content, $markerPattern)
    if ($matches.Count -ne 1) {
        throw "Codex source template must contain exactly one generated policy marker: $TemplatePath"
    }

    $expectedPointer = (Get-CodexGeneratedPolicyPointer -PolicyPath $PolicyPath) -replace "`r`n|`r", "`n"
    $actualPointer = $matches[0].Groups[1].Value.Trim() -replace "`r`n|`r", "`n"
    if ($actualPointer -cne $expectedPointer.Trim()) {
        throw "Codex source template policy marker must match the generated pointer: $TemplatePath"
    }
}

function Assert-ManagerProjectSyncPreflight {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepoRoot,

        [Parameter(Mandatory = $true)]
        [string]$SharedSkillsRoot,

        [Parameter(Mandatory = $true)]
        [string[]]$Platforms
    )

    if (-not (Test-Path -LiteralPath $SharedSkillsRoot -PathType Container)) {
        throw "Shared skills source is missing: $SharedSkillsRoot"
    }

    $preflight = @()
    foreach ($platform in $Platforms) {
        $sourceRoot = ''
        $versionPath = ''
        $policyPath = Join-Path $RepoRoot 'Shared\policies\subagent-invocation.md'

        switch ($platform) {
            'Antigravity' {
                $sourceRoot = Join-Path $RepoRoot 'Antigravity\.agents'
                $versionPath = Join-Path $RepoRoot 'Antigravity\VERSION'
            }
            'Claude' {
                $sourceRoot = Join-Path $RepoRoot 'Claude\.claude'
                $versionPath = Join-Path $RepoRoot 'Claude\VERSION'
            }
            'Codex' {
                $sourceRoot = Join-Path $RepoRoot 'Codex\.codex'
                $versionPath = Join-Path $RepoRoot 'Codex\VERSION'
                $policyPath = Join-Path $RepoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
            }
        }

        if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
            throw "Project sync source is missing for ${platform}: $sourceRoot"
        }
        if (-not (Test-Path -LiteralPath $versionPath -PathType Leaf)) {
            throw "Project sync version source is missing for ${platform}: $versionPath"
        }

        $null = Get-SharedPolicyBlock -PolicyPath $policyPath -Platform $platform
        if ($platform -eq 'Codex') {
            Assert-ManagerCodexPolicyPointerTemplate -TemplatePath (Join-Path $sourceRoot 'AGENTS.md') -PolicyPath $policyPath
        }

        $preflight += [PSCustomObject]@{
            Platform = $platform
            SourceRoot = $sourceRoot
            PolicyPath = $policyPath
        }
    }

    return $preflight
}

function Invoke-ManagerSyncAntigravityProjectRules {
    param(
        [string]$RepoRoot,
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Antigravity\.agents"
    $agTargetRoot = Join-Path $ProjectRoot ".agents"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Antigravity\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $agTargetRoot `
        -ScanDirs @("rules", "workflows") `
        -ProtectedDirs @("memory", "project_skills", "context") `
        -ExcludeFiles @() `
        -PreserveProjectIdentity)

    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規範 (.agents/rules)" = { $_.Path -like "rules/*" -or $_.Path -like "rules\*" }
        "工作流程 (.agents/workflows)" = { $_.Path -like "workflows/*" -or $_.Path -like "workflows\*" }
        "專案記憶 — 受保護" = { $_.Path -like "memory/*" -or $_.Path -like "memory\*" }
        "專案技能 — 受保護" = { $_.Path -like "project_skills/*" -or $_.Path -like "project_skills\*" }
        "專案脈絡 — 受保護" = { $_.Path -like "context/*" -or $_.Path -like "context\*" }
    }) -Platform "Antigravity"

    $targetSkillsPath = Join-Path $agTargetRoot "skills"
    $skillDiffs = @(Get-ManagerSharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-ManagerDiffSummary -Title "Antigravity Shared Skills" -Diffs $skillDiffs
    $governanceDiffs = @(Get-ManagerSharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot $agTargetRoot)
    Write-ManagerDiffSummary -Title "Antigravity Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agTargetRoot)
    Write-ManagerDiffSummary -Title "Antigravity Project Tools" -Diffs $toolDiffs
    Set-ManagerProjectVersionFile -Path (Join-Path $agTargetRoot "VERSION") -Version $version -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $agTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $agTargetRoot "rules\00_core_identity.md") `
        -Platform Antigravity `
        -InsertBeforePattern '(?m)^## 2\. Agentic Swarm UI Visibility'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agTargetRoot -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agTargetRoot -Mode Diff
}

function Invoke-ManagerSyncClaudeProjectRules {
    param(
        [string]$RepoRoot,
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Claude\.claude"
    $claudeTargetRoot = Join-Path $ProjectRoot ".claude"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Claude\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\subagent-invocation.md"
    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $claudeTargetRoot `
        -ScanDirs @("commands", "rules") `
        -ProtectedDirs @() `
        -ExcludeFiles @("settings.local.json") `
        -ScanFiles @("CLAUDE.md") `
        -PreserveProjectIdentity)

    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "入口規則 (.claude/CLAUDE.md)" = { $_.Path -eq "CLAUDE.md" }
        "工作流指令 (.claude/commands)" = { $_.Path -like "commands/*" -or $_.Path -like "commands\*" }
        "治理規範 (.claude/rules)" = { $_.Path -like "rules/*" -or $_.Path -like "rules\*" }
    }) -Platform "Claude"

    $targetSkillsPath = Join-Path $claudeTargetRoot "skills"
    $skillDiffs = @(Get-ManagerSharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-ManagerDiffSummary -Title "Claude Shared Skills" -Diffs $skillDiffs
    $governanceDiffs = @(Get-ManagerSharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents"))
    Write-ManagerDiffSummary -Title "Claude Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents"))
    Write-ManagerDiffSummary -Title "Claude Project Tools" -Diffs $toolDiffs
    Set-ManagerProjectVersionFile -Path (Join-Path $claudeTargetRoot "VERSION") -Version $version -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $claudeTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $claudeTargetRoot "rules\core-identity.md") `
        -Platform Claude `
        -InsertBeforePattern '(?m)^## 2\. Multi-Agent Transparency'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents") -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot (Join-Path $ProjectRoot ".agents") -Mode Diff
}

function Invoke-ManagerSyncCodexProjectRules {
    param(
        [string]$RepoRoot,
        [string]$ProjectRoot,
        [string]$SharedSkillsRoot,
        [switch]$Apply
    )

    $sourceRoot = Join-Path $RepoRoot "Codex\.codex"
    $codexTargetRoot = Join-Path $ProjectRoot ".codex"
    $workflowSkillsRoot = Join-Path $RepoRoot "Codex\.agents\workflow-skills"
    $agentsRoot = Join-Path $ProjectRoot ".agents"
    $targetSkillsPath = Join-Path $agentsRoot "skills"
    $version = Get-VersionContent -Path (Join-Path $RepoRoot "Codex\VERSION")
    $sharedRoot = Split-Path $SharedSkillsRoot -Parent
    $projectToolsRoot = Join-Path $sharedRoot "project-tools"
    $sharedPolicyPath = Join-Path (Split-Path $SharedSkillsRoot -Parent) "policies\adapters\codex-subagent-invocation.md"

    $report = @(Get-UpgradeReport `
        -SourceRoot $sourceRoot `
        -TargetRoot $codexTargetRoot `
        -ScanDirs @(".") `
        -ProtectedDirs @() `
        -ExcludeFiles @("config.toml") `
        -PreserveProjectIdentity)
    $stats = Write-UpgradeReport -Report $report -CategoryMap ([ordered]@{
        "治理規則 (.codex/)" = { $true }
    }) -Platform "Codex"

    $skillDiffs = @(Get-ManagerSharedSkillDiffs -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-ManagerDiffSummary -Title "Codex Shared Skills" -Diffs $skillDiffs
    $workflowDiffs = @(Get-ManagerCodexWorkflowDiffs -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath)
    Write-ManagerDiffSummary -Title "Codex Workflow Skills" -Diffs $workflowDiffs
    $governanceDiffs = @(Get-ManagerSharedGovernanceReferenceDiffs -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot)
    Write-ManagerDiffSummary -Title "Codex Shared Governance References" -Diffs $governanceDiffs
    $toolDiffs = @(Get-ProjectToolDiffs -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agentsRoot)
    Write-ManagerDiffSummary -Title "Codex Project Tools" -Diffs $toolDiffs
    Set-ManagerProjectVersionFile -Path (Join-Path $codexTargetRoot "VERSION") -Version $version -Apply:$Apply
    $null = Merge-ManagerCodexProjectConfigDefaults -SourcePath (Join-Path $sourceRoot "config.toml") -TargetPath (Join-Path $codexTargetRoot "config.toml") -Apply:$Apply

    if (-not $Apply) { return }

    if ($stats.New -gt 0 -or $stats.Changed -gt 0) {
        $null = Install-Upgrade -Report $report -SourceRoot $sourceRoot -TargetRoot $codexTargetRoot -PreserveProjectIdentity
    }
    $null = Sync-SharedPolicyBlock -PolicyPath $sharedPolicyPath `
        -TargetPath (Join-Path $codexTargetRoot "AGENTS.md") `
        -Platform Codex `
        -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
    $null = Sync-SharedSkills -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkillsPath -Mode Diff
    $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot -Mode Diff
    $null = Sync-ProjectTools -ProjectToolsRoot $projectToolsRoot -TargetAgentsRoot $agentsRoot -Mode Diff
    if (Test-Path -LiteralPath $workflowSkillsRoot) {
        $null = Merge-WorkflowSkills -WorkflowSkillsPath $workflowSkillsRoot -TargetSkillsPath $targetSkillsPath
    }
}

function Invoke-ManagerProjectRulesSync {
    param(
        [string]$RepoRoot,
        [string]$Target,
        [ValidateSet("Auto", "Codex", "Claude", "Antigravity")]
        [string]$ProjectPlatform,
        [switch]$Apply,
        [switch]$ManagedSource,
        [Parameter(Mandatory = $true)]
        [scriptblock]$WriteHeaderAction,
        [Parameter(Mandatory = $true)]
        [scriptblock]$AssertSourceSyncedAction
    )

    & $WriteHeaderAction "同步專案平台規則"
    $targetRoot = (Resolve-Path $Target).Path
    $sharedSkillsRoot = Join-Path $RepoRoot "Shared\skills"
    $contextTemplatesRoot = Join-Path (Split-Path $sharedSkillsRoot -Parent) "context"

    Write-Host "RepoRoot：$RepoRoot"
    Write-Host "來源模式：$(if ($ManagedSource) { '使用者層管理快取（以遠端版本庫為準）' } else { '本機來源（不自動重設）' })"
    Write-Host "Target：$targetRoot"
    Write-Host "範圍：$ProjectPlatform"

    & $AssertSourceSyncedAction $RepoRoot $ManagedSource

    Write-Host ""
    Write-Host "📊 Project Platform Selection"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $installed = @(Get-ManagerInstalledProjectPlatforms -TargetRoot $targetRoot)
    Write-Host "已安裝平台：$(if ($installed.Count -gt 0) { $installed -join ', ' } else { '無' })"

    $selected = @()
    if ($ProjectPlatform -eq "Auto") {
        $selected = $installed
    } elseif (Test-ManagerProjectPlatformInstalled -TargetRoot $targetRoot -Platform $ProjectPlatform) {
        $selected = @($ProjectPlatform)
    } else {
        Write-ManagerProjectSyncNoInstallWarning -TargetRoot $targetRoot -Platform $ProjectPlatform
        return
    }

    if ($selected.Count -eq 0) {
        Write-ManagerProjectSyncNoInstallWarning -TargetRoot $targetRoot -Platform "任何支援平台"
        return
    }
    Write-Host "同步平台：$($selected -join ', ')"

    $preflight = @(Assert-ManagerProjectSyncPreflight -RepoRoot $RepoRoot -SharedSkillsRoot $sharedSkillsRoot -Platforms $selected)
    Write-Step "必要同步資料已預先驗證：$($preflight.Count) 個平台"

    $stageResults = @()
    $hasRequiredStageFailure = $false
    foreach ($platform in $selected) {
        $stage = "平台規則：$platform"
        if ($hasRequiredStageFailure) {
            $stageResults += New-ManagerProjectSyncStageResult -Stage $stage -Status Skipped -Detail 'Skipped after an earlier required stage failed.'
            continue
        }

        $stageResult = Invoke-ManagerProjectSyncRequiredStage -Stage $stage -Action {
            switch ($platform) {
                "Antigravity" { Invoke-ManagerSyncAntigravityProjectRules -RepoRoot $RepoRoot -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
                "Claude"      { Invoke-ManagerSyncClaudeProjectRules -RepoRoot $RepoRoot -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
                "Codex"       { Invoke-ManagerSyncCodexProjectRules -RepoRoot $RepoRoot -ProjectRoot $targetRoot -SharedSkillsRoot $sharedSkillsRoot -Apply:$Apply }
            }
        }
        $stageResults += $stageResult
        if (-not $stageResult.Succeeded) { $hasRequiredStageFailure = $true }
    }

    if (-not $Apply -and -not $hasRequiredStageFailure) {
        Write-Host ""
        Write-Host "Dry-run：未指定 -Apply，不會寫入目前專案規則。" -ForegroundColor Yellow
    }

    if ($Apply) {
        $agentsRoot = Join-Path $targetRoot ".agents"
        foreach ($requiredStage in @(
            [PSCustomObject]@{
                Name = '初始化 Agent 基礎設施'
                Action = { Initialize-AgentInfrastructure -AgentsRoot $agentsRoot -ContextTemplatesRoot $contextTemplatesRoot }
            },
            [PSCustomObject]@{
                Name = '更新 .gitignore 規則'
                Action = { Set-GitignoreEntries -ProjectRoot $targetRoot -Lines @(".agents/logs/", ".cartridge/") }
            },
            [PSCustomObject]@{
                Name = '回填專案技能連結'
                Action = { Sync-ManagerProjectSkillLinks -TargetRoot $targetRoot -Platforms $selected }
            }
        )) {
            if ($hasRequiredStageFailure) {
                $stageResults += New-ManagerProjectSyncStageResult -Stage $requiredStage.Name -Status Skipped -Detail 'Skipped after an earlier required stage failed.'
                continue
            }

            $stageResult = Invoke-ManagerProjectSyncRequiredStage -Stage $requiredStage.Name -Action $requiredStage.Action
            $stageResults += $stageResult
            if (-not $stageResult.Succeeded) { $hasRequiredStageFailure = $true }
        }
    }

    if ($hasRequiredStageFailure) {
        $failedStages = @($stageResults | Where-Object { $_.Status -ne 'Succeeded' } | ForEach-Object { $_.Stage })
        Write-Fail "目前專案規則同步失敗；未輸出完成訊息。失敗或略過階段：$($failedStages -join ', ')"
        return [PSCustomObject]@{
            Succeeded = $false
            Applied = [bool]$Apply
            Platforms = @($selected)
            RequiredStageResults = @($stageResults)
        }
    }

    if ($Apply) {
        Write-Ok "目前專案規則同步完成：$($selected -join ', ')"
    }
    return [PSCustomObject]@{
        Succeeded = $true
        Applied = [bool]$Apply
        Platforms = @($selected)
        RequiredStageResults = @($stageResults)
    }
}

Export-ModuleMember -Function Invoke-ManagerProjectRulesSync
