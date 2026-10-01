# Read-only plan for the existing four-platform Upgrade projection.
Import-Module (Join-Path $PSScriptRoot 'Core.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Skills-Sync.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Native-Agent-Projection.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Antigravity-Procedure-Projection.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Antigravity-Legacy-Workflow-Projection.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Skill-Migration.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Platform-Codex.psm1')
Import-Module (Join-Path $PSScriptRoot 'Deployment.Transaction.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Claude-Agent-Projection.psm1') -Force
Import-Module (Join-Path $PSScriptRoot 'Runtime-Copy-Resolution.psm1')

function Get-PreflightSha256 {
    param([string]$Path)
    if (-not $Path -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant()
}

function Add-PreflightRecord {
    param(
        [hashtable]$Records, [string]$Root, [string]$Platform,
        [string]$TargetPath, [string]$SourcePath, [string]$ContentType,
        [ValidateSet('ADD','UPDATE','UNCHANGED','RETIRE','PRESERVE','BLOCK','SKIP')][string]$Action,
        [string]$Reason, [string]$OwnershipClass = 'framework_projection',
        [bool]$Blocking = $false, [string]$MigrationId = '',
        [AllowNull()][object]$KnownFrameworkHashMatch = $null,
        [string]$ProvenanceStatus = ''
    )
    $full = [IO.Path]::GetFullPath($TargetPath)
    $relative = (Get-DeploymentRelativePath -Root $Root -Path $full).Replace('\','/')
    $key = $relative.ToLowerInvariant()
    $existing = $Records[$key]
    if ($existing) {
        if ($existing.planned_action -eq 'BLOCK') { return }
        if ($existing.source_path -and $SourcePath -and $existing.source_path -ne $SourcePath -and $ContentType -notin @('GeneratedEntry','Version')) {
            $existing.planned_action = 'BLOCK'
            $existing.blocking = $true
            $existing.reason = 'conflicting_platform_sources_for_same_target'
            $existing.ownership_class = 'conflict'
            return
        }
        $Platform = (@($existing.platform.Split('+') + $Platform.Split('+') | Select-Object -Unique) -join '+')
    }
    $currentHash = $null; $sourceHash = $null
    try {
        $currentHash = Get-PreflightSha256 -Path $full
        $sourceHash = Get-PreflightSha256 -Path $SourcePath
    } catch { $Action = 'BLOCK'; $Blocking = $true; $Reason = 'hash_or_read_permission_failed' }
    $Records[$key] = [PSCustomObject]@{
        platform = $Platform; target_path = $relative
        source_path = $(if ($SourcePath) { [IO.Path]::GetFullPath($SourcePath) } else { $null })
        content_type = $ContentType; planned_action = $Action; reason = $Reason
        current_sha256 = $currentHash; source_sha256 = $sourceHash
        ownership_class = $OwnershipClass
        authorization_requirement = 'protected.deployment; not granted by preflight'
        blocking = $Blocking; migration_id = $(if ($MigrationId) { $MigrationId } else { $null })
        known_framework_hash_match = $KnownFrameworkHashMatch
        provenance_status = $(if ($ProvenanceStatus) { $ProvenanceStatus } else { $null })
    }
}

function Add-PreflightCopy {
    param([hashtable]$Records, [string]$Root, [string]$Platform,
          [string]$SourcePath, [string]$TargetPath, [string]$ContentType,
          [switch]$TextEquivalent, [switch]$ForceCopyExisting,
          [string]$Reason = 'official_source_projection', [string]$SharedSkillsRoot = '')
    $action = 'BLOCK'; $blocking = $true
    try {
        Assert-DeploymentPathUnlinked -Path $TargetPath
        if (Test-Path -LiteralPath $TargetPath -PathType Container) {
            $Reason = 'target_is_directory'
        } elseif (-not (Test-Path -LiteralPath $TargetPath)) {
            $action = 'ADD'; $blocking = $false
        } else {
            $result = if ($SharedSkillsRoot) {
                $rel = (Get-DeploymentRelativePath -Root $SharedSkillsRoot -Path $SourcePath)
                $TargetPath = [IO.Path]::GetFullPath($TargetPath)
                $targetSkills = $TargetPath.Substring(0,$TargetPath.Length-$rel.Length).TrimEnd('\','/')
                Compare-SharedSkillProjection -SourcePath $SourcePath -TargetPath $TargetPath -SharedSkillsRoot $SharedSkillsRoot -TargetSkillsPath $targetSkills -RelativePath $rel
            } else { Compare-FrameworkFile -SourcePath $SourcePath -TargetPath $TargetPath -RelativePath (Split-Path $TargetPath -Leaf) -RequireExactHash:(!$TextEquivalent) }
            $action = switch ($result.Status) { 'SAME' { 'UNCHANGED' } 'NEW' { 'ADD' } default { 'UPDATE' } }
            if ($ForceCopyExisting) { $action = 'UPDATE'; $Reason = 'official_workflow_merge_force_copy' }
            $blocking = $false
            if ($action -eq 'UPDATE' -and (Get-Item -LiteralPath $TargetPath -Force -ErrorAction Stop).IsReadOnly) {
                $action = 'BLOCK'; $blocking = $true; $Reason = 'target_readonly'
            }
        }
    } catch { $Reason = "path_or_permission_conflict: $($_.Exception.Message)" }
    Add-PreflightRecord -Records $Records -Root $Root -Platform $Platform -TargetPath $TargetPath -SourcePath $SourcePath -ContentType $ContentType -Action $action -Reason $Reason -Blocking $blocking
}

function Get-PreflightContentType {
    param([string]$Path, [string]$Default = 'Reference')
    $p = $Path.Replace('\','/').ToLowerInvariant()
    if ($p -match '/references/') { return 'Reference' }
    if ($p -match '/agents/') { return 'Agent' }
    if ($p -match '/policies/') { return 'Policy' }
    if ($p -match '/workflows/|/workflow-skills/|/commands/') { return 'Workflow' }
    if ($p -match '/skills/') { return 'Skill' }
    return $Default
}

function Add-PreflightTemplateReport {
    param([hashtable]$Records, [string]$Root, [string]$Platform,
          [string]$SourceRoot, [string]$TargetRoot,
          [string[]]$ScanDirs, [string[]]$ScanFiles = @(),
          [string[]]$ExcludeFiles = @())
    $report = @(Get-UpgradeReport -SourceRoot $SourceRoot -TargetRoot $TargetRoot -ScanDirs $ScanDirs -ScanFiles $ScanFiles -ExcludeFiles $ExcludeFiles -ProtectedDirs @())
    foreach ($item in $report) {
        $target = Join-Path $TargetRoot $item.Path
        $source = Join-Path $SourceRoot $item.Path
        if ($item.Status -eq 'ORPHAN') {
            Add-PreflightRecord -Records $Records -Root $Root -Platform $Platform -TargetPath $target -SourcePath $null -ContentType 'Reference' -Action 'PRESERVE' -Reason 'source_absent_orphan_preserved' -OwnershipClass 'unconfirmed'
            continue
        }
        Add-PreflightCopy -Records $Records -Root $Root -Platform $Platform -SourcePath $source -TargetPath $target -ContentType (Get-PreflightContentType -Path $source -Default 'PlatformSource') -TextEquivalent
    }
}

function Get-DeploymentUpgradePreflight {
    param([Parameter(Mandatory = $true)][string]$RepoRoot,
          [Parameter(Mandatory = $true)][string]$TargetRoot,
          [object[]]$ProvenanceReceipts = @(),
          [string]$ClaudeFrameworkRoot = '',
          [object]$RuntimeCopyResolution = $null,
          [string]$Gate3AEvidencePath = '',
          [string]$SelectedPlatform = 'All')
    $repo = [IO.Path]::GetFullPath($RepoRoot).TrimEnd('\','/')
    $target = [IO.Path]::GetFullPath($TargetRoot).TrimEnd('\','/')
    $records = @{}
    $shared = Join-Path $repo 'Shared'; $skills = Join-Path $shared 'skills'
    if (-not (Test-Path -LiteralPath $skills -PathType Container)) { throw 'Missing current Shared Skills source.' }
    $legacyWorkflow = Get-AntigravityLegacyWorkflowProjection `
        -ManifestPath (Join-Path $repo 'Antigravity/legacy-workflow-projection.json') `
        -SourceWorkflowsRoot (Join-Path $repo 'Antigravity/.agents/workflows')
    $legacyScanDirs = if ($legacyWorkflow.Project) { @('rules','workflows') } else { @('rules') }

    $templates = @(
        @{ platform='Antigravity'; source='Antigravity/.agents'; target='.agents'; dirs=$legacyScanDirs; files=@(); exclude=@() },
        @{ platform='Claude'; source='Claude/.claude'; target='.claude'; dirs=@('commands','rules'); files=@('CLAUDE.md'); exclude=@('settings.local.json') },
        @{ platform='Codex'; source='Codex/.codex'; target='.codex'; dirs=@('.'); files=@(); exclude=@('config.toml') },
        @{ platform='Cursor'; source='Cursor/.cursor'; target='.cursor'; dirs=@('rules'); files=@(); exclude=@('hooks.json') }
    )
    foreach ($entry in $templates) {
        Add-PreflightTemplateReport -Records $records -Root $target -Platform $entry.platform -SourceRoot (Join-Path $repo $entry.source) -TargetRoot (Join-Path $target $entry.target) -ScanDirs $entry.dirs -ScanFiles $entry.files -ExcludeFiles $entry.exclude
    }
    if (-not $legacyWorkflow.Project) {
        $legacyTarget = Join-Path $target '.agents/workflows'
        if (Test-Path -LiteralPath $legacyTarget -PathType Container) {
            foreach ($file in @(Get-ChildItem -LiteralPath $legacyTarget -Recurse -File)) {
                Add-PreflightRecord -Records $records -Root $target -Platform 'Antigravity' `
                    -TargetPath $file.FullName -SourcePath $null -ContentType 'LegacyWorkflow' `
                    -Action 'PRESERVE' -Reason 'retired_platform_workflow_existing_copy_preserved_without_provenance' `
                    -OwnershipClass 'unconfirmed'
            }
        }
    }
    foreach ($entry in @(
        @{ platform='Cursor'; source='Cursor/.cursor/agents'; target='.cursor/agents' },
        @{ platform='Antigravity'; source='Antigravity/.agents/agents'; target='.agents/agents' }
    )) {
        foreach ($decision in @(Get-NativeAgentProjectionDecisions -Platform $entry.platform `
            -SourceAgentsRoot (Join-Path $repo $entry.source) `
            -CanonicalAgentsRoot (Join-Path $shared 'agents') `
            -TargetAgentsRoot (Join-Path $target $entry.target))) {
            Add-PreflightRecord -Records $records -Root $target -Platform $entry.platform `
                -TargetPath $decision.TargetPath -SourcePath $decision.SourcePath `
                -ContentType 'Agent' -Action $decision.Action -Reason $decision.Reason `
                -Blocking ($decision.Action -eq 'BLOCK')
        }
    }
    foreach ($entry in @(
        @{ platform='Antigravity'; target='.agents/rules/00_core_identity.md'; source='Antigravity/.agents/rules/00_core_identity.md'; adapter='antigravity-subagent-invocation.md'; before='(?m)^## 2\. Agentic Swarm UI Visibility'; after='' },
        @{ platform='Claude'; target='.claude/rules/core-identity.md'; source='Claude/.claude/rules/core-identity.md'; adapter='claude-subagent-invocation.md'; before='(?m)^## 2\. Multi-Agent Transparency'; after='' },
        @{ platform='Codex'; target='.codex/AGENTS.md'; source='Codex/.codex/AGENTS.md'; adapter='codex-subagent-invocation.md'; before=''; after='(?m)^Codex-specific governance:\s*$' },
        @{ platform='Cursor'; target='.cursor/rules/00-core.mdc'; source='Cursor/.cursor/rules/00-core.mdc'; adapter='cursor-subagent-invocation.md'; before=''; after='(?m)^Cursor-specific governance:\s*$' }
    )) {
        $path = Join-Path $target $entry.target
        $template = Join-Path $repo $entry.source
        $adapter = Join-Path (Join-Path $shared 'policies/adapters') $entry.adapter
        $key = $entry.target.ToLowerInvariant()
        $templateWillCopy = $records.ContainsKey($key) -and $records[$key].planned_action -in @('ADD','UPDATE')
        $basePath = if ($templateWillCopy) { $template } elseif (Test-Path -LiteralPath $path -PathType Leaf) { $path } else { $template }
        try {
            $baseText = Get-Content -LiteralPath $basePath -Raw -Encoding UTF8 -ErrorAction Stop
            $future = Get-SharedPolicyBlockProjectedText -PolicyPath $adapter -Content $baseText -Platform $entry.platform -InsertBeforePattern $entry.before -InsertAfterPattern $entry.after
            $present = Test-Path -LiteralPath $path -PathType Leaf
            $current = if ($present) { Get-Content -LiteralPath $path -Raw -Encoding UTF8 -ErrorAction Stop } else { $null }
            $action = if (-not $present) { 'ADD' } elseif ($current -ceq $future) { 'UNCHANGED' } else { 'UPDATE' }
            Add-PreflightRecord -Records $records -Root $target -Platform $entry.platform -TargetPath $path -SourcePath $adapter -ContentType 'GeneratedEntry' -Action $action -Reason 'shared_policy_block_projected_after_template_copy'
        } catch {
            Add-PreflightRecord -Records $records -Root $target -Platform $entry.platform -TargetPath $path -SourcePath $adapter -ContentType 'GeneratedEntry' -Action 'BLOCK' -Reason "policy_projection_unresolved: $($_.Exception.Message)" -Blocking $true
        }
    }

    # The Claude Upgrade adapter consumes these same registry-derived decisions.
    $claudeAgentRoot = if ($ClaudeFrameworkRoot) { $ClaudeFrameworkRoot } else { Join-Path $repo 'Claude' }
    foreach ($agent in @(Get-ClaudeAgentProjectionDecisions -FrameworkRoot $claudeAgentRoot -SharedRoot $shared -TargetRoot $target)) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Claude' -TargetPath $agent.TargetPath -SourcePath $agent.SourcePath -ContentType 'Agent' -Action $agent.Action -Reason $agent.Reason -OwnershipClass $(if ($agent.KnownFrameworkHashMatch) { 'framework_owned_source_artifact_exact_hash' } elseif ($agent.Blocking) { 'unconfirmed' } else { 'framework_projection' }) -Blocking $agent.Blocking -KnownFrameworkHashMatch $agent.KnownFrameworkHashMatch -ProvenanceStatus $(if ($agent.KnownFrameworkHashMatch) { 'historical_source_artifact_exact_hash' } elseif ($agent.Blocking) { 'unknown_or_modified' } else { 'source_projection' })
    }

    # Reuse the exact selectors and retirement hash decision used by apply.
    $skillTargets = @(
        @{ platform='Antigravity+Codex'; path='.agents/skills' },
        @{ platform='Claude'; path='.claude/skills' },
        @{ platform='Cursor'; path='.cursor/skills' }
    )
    $activeSkillSources = @(Get-ChildItem -LiteralPath $skills -Recurse -File -ErrorAction Stop | Where-Object {
        $rel = $_.FullName.Substring($skills.Length).TrimStart('\','/')
        Test-SharedSkillRelativePathIncluded -RelativePath $rel
    })
    foreach ($surface in $skillTargets) {
        $dest = Join-Path $target $surface.path
        foreach ($source in $activeSkillSources) {
            $rel = $source.FullName.Substring($skills.Length).TrimStart('\','/')
            Add-PreflightCopy -Records $records -Root $target -Platform $surface.platform -SourcePath $source.FullName -TargetPath (Join-Path $dest $rel) -ContentType 'Skill' -SharedSkillsRoot $skills
        }
        foreach ($artifact in @(Get-RetiredSharedSkillManifest)) {
            $relative = [string]$artifact.RelativePath
            $path = Join-Path $dest $relative
            try { $decision = Get-ManagedSkillRetirementDecision -TargetPath $path -KnownSha256 @($artifact.KnownSha256) }
            catch { $decision = [PSCustomObject]@{ Action='BLOCK'; Reason="retirement_path_conflict: $($_.Exception.Message)"; KnownFrameworkHashMatch=$false } }
            if ($decision.Action -eq 'SKIP') { continue }
            $action = if ($decision.Action -eq 'RETIRE') { 'RETIRE' } elseif ($decision.Action -eq 'PRESERVE') { 'PRESERVE' } else { 'BLOCK' }
            $mustBlock = $action -eq 'BLOCK' -or ($action -eq 'PRESERVE' -and (Test-LegacySkillMigrationBlockingPath -RelativePath $relative))
            $retireReason = if ($action -eq 'PRESERVE' -and -not $mustBlock) { 'unconfirmed_retired_nonentry_preserved' } else { $decision.Reason }
            $relativeTarget = $path.Substring($target.Length).TrimStart('\','/').Replace('\','/')
            $probableReceipt = @($ProvenanceReceipts | Where-Object {
                $_.path -ceq $relativeTarget -and $_.current_sha256 -eq $decision.CurrentSha256 -and
                $_.classification -ceq 'PROBABLE_FRAMEWORK_OWNED'
            }).Count -eq 1
            $provenance = if ($decision.KnownFrameworkHashMatch) { 'known_framework_hash' } elseif ($probableReceipt) { 'PROBABLE_FRAMEWORK_OWNED' } else { 'unknown_or_modified' }
            Add-PreflightRecord -Records $records -Root $target -Platform $surface.platform -TargetPath $path -SourcePath $null -ContentType 'LegacySkill' -Action $action -Reason $retireReason -OwnershipClass $(if ($decision.KnownFrameworkHashMatch) { 'framework_owned_exact_hash' } else { 'unconfirmed' }) -Blocking $mustBlock -MigrationId $relative -KnownFrameworkHashMatch $decision.KnownFrameworkHashMatch -ProvenanceStatus $provenance
        }
        if (Test-Path -LiteralPath $dest -PathType Container) {
            foreach ($file in @(Get-ChildItem -LiteralPath $dest -Recurse -File -ErrorAction Stop)) {
                $relativeToRoot = $file.FullName.Substring($target.Length).TrimStart('\','/').Replace('\','/')
                $key = $relativeToRoot.ToLowerInvariant()
                if ($records.ContainsKey($key)) { continue }
                $relativeToSkills = $file.FullName.Substring($dest.Length).TrimStart('\','/')
                if (($relativeToSkills -split '[\\/]')[0] -like 'project-*') { continue }
                Add-PreflightRecord -Records $records -Root $target -Platform $surface.platform -TargetPath $file.FullName -SourcePath $null -ContentType 'Skill' -Action 'PRESERVE' -Reason 'unmanaged_neighbor_not_retired' -OwnershipClass 'unconfirmed'
            }
        }
    }
    foreach ($rel in @(Get-SharedGovernanceReferenceRelativePaths -SharedRoot $shared)) {
        $source = Join-Path $shared $rel
        Add-PreflightCopy -Records $records -Root $target -Platform 'All' -SourcePath $source -TargetPath (Join-Path (Join-Path $target '.agents/shared') $rel) -ContentType (Get-PreflightContentType -Path $source)
    }
    foreach ($decision in @(Get-AntigravityProcedureSkillDecisions `
        -ProcedureSkillsRoot (Join-Path $repo 'Antigravity/.agents/procedure-skills') `
        -CanonicalWorkflowsRoot (Join-Path $shared 'workflows') `
        -SharedSkillsRoot $skills -TargetSkillsPath (Join-Path $target '.agents/skills'))) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Antigravity' `
            -TargetPath $decision.TargetPath -SourcePath $decision.SourcePath `
            -ContentType 'ProcedureSkill' -Action $decision.Action -Reason $decision.Reason `
            -Blocking ($decision.Action -eq 'BLOCK')
    }
    foreach ($rel in @(Get-ProjectToolRelativePaths -ProjectToolsRoot (Join-Path $shared 'project-tools'))) {
        $source = Join-Path (Join-Path $shared 'project-tools') $rel
        Add-PreflightCopy -Records $records -Root $target -Platform 'All' -SourcePath $source -TargetPath (Join-Path (Join-Path $target '.agents/tools') $rel) -ContentType 'ProjectTool' -TextEquivalent
    }
    foreach ($entry in @(@{ platform='Codex'; root='Codex/.agents/workflow-skills'; dest='.agents/skills' },
                        @{ platform='Cursor'; root='Cursor/.agents/workflow-skills'; dest='.cursor/skills' })) {
        $sourceRoot = Join-Path $repo $entry.root
        if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) { continue }
        foreach ($source in @(Get-ChildItem -LiteralPath $sourceRoot -Recurse -File -ErrorAction Stop)) {
            $rel = $source.FullName.Substring($sourceRoot.Length).TrimStart('\','/')
            if (-not (Test-CodexWorkflowRelativePathIncluded -RelativePath $rel)) { continue }
            Add-PreflightCopy -Records $records -Root $target -Platform $entry.platform -SourcePath $source.FullName -TargetPath (Join-Path (Join-Path $target $entry.dest) $rel) -ContentType 'Workflow' -ForceCopyExisting
        }
    }
    foreach ($entry in @(
        @{ platform='Antigravity'; source='Antigravity/VERSION'; target='.agents/VERSION' },
        @{ platform='Claude'; source='Claude/VERSION'; target='.claude/VERSION' },
        @{ platform='Codex'; source='Codex/VERSION'; target='.codex/VERSION' },
        @{ platform='Cursor'; source='Cursor/VERSION'; target='.cursor/VERSION' }
    )) {
        $source = Join-Path $repo $entry.source; $dest = Join-Path $target $entry.target
        $action = if (Test-Path -LiteralPath $dest -PathType Container) { 'BLOCK' } elseif (Test-Path -LiteralPath $dest -PathType Leaf) { 'UPDATE' } else { 'ADD' }
        Add-PreflightRecord -Records $records -Root $target -Platform $entry.platform -TargetPath $dest -SourcePath $source -ContentType 'Version' -Action $action -Reason $(if ($action -eq 'BLOCK') { 'version_target_is_directory' } else { 'official_version_marker_forced_write' }) -Blocking ($action -eq 'BLOCK')
    }
    $configSource = Join-Path $repo 'Codex/.codex/config.toml'
    $configTarget = Join-Path $target '.codex/config.toml'
    $configPlan = Merge-CodexConfigDefaults -SourcePath $configSource -TargetPath $configTarget
    if ($configPlan) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Codex' -TargetPath $configTarget -SourcePath $configSource -ContentType 'Config' -Action $(if (-not $configPlan.Changed) { 'UNCHANGED' } elseif (Test-Path -LiteralPath $configTarget) { 'UPDATE' } else { 'ADD' }) -Reason 'codex_config_key_merge_from_official_no_apply_logic'
    }
    $hookPlan = Remove-CodexManagedLegacyTeamNativeHooks -TargetRoot $target
    foreach ($relative in @($hookPlan.WouldRemove | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Codex' -TargetPath (Join-Path (Join-Path $target '.codex') $relative) -SourcePath $null -ContentType 'LegacyHook' -Action 'RETIRE' -Reason 'known_hash_managed_hook_retirement' -OwnershipClass 'framework_owned_exact_hash' -MigrationId 'codex-legacy-team-hook' -KnownFrameworkHashMatch $true -ProvenanceStatus 'known_framework_hash'
    }
    foreach ($relative in @($hookPlan.WouldPreserve | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Codex' -TargetPath (Join-Path (Join-Path $target '.codex') $relative) -SourcePath $null -ContentType 'LegacyHook' -Action 'PRESERVE' -Reason 'legacy_hook_group_hash_mismatch' -OwnershipClass 'unconfirmed' -Blocking $true -MigrationId 'codex-legacy-team-hook' -KnownFrameworkHashMatch $false -ProvenanceStatus 'unknown_or_modified'
    }

    # Set-GitignoreEntries uses these exact content helpers. Build the desired
    # text in memory; no Set-* function is called by this preflight.
    $gitignorePath = Join-Path $target '.gitignore'
    $existingGitignore = Get-AiRulesTextFileContent -Path $gitignorePath
    if ($null -eq $existingGitignore) { $existingGitignore = '' }
    $cleanGitignore = Remove-AiRulesGitignoreStandardLines -Content $existingGitignore
    $newline = [Environment]::NewLine
    $desiredGitignore = if ($cleanGitignore.Length -gt 0) { $cleanGitignore + $newline + $newline } else { '' }
    $desiredGitignore += ((@(Get-AiRulesGitignoreManagedBlock -AdditionalLines @('.agents/logs/', '.cartridge/'))) -join $newline) + $newline
    $gitignoreAction = if (-not (Test-Path -LiteralPath $gitignorePath)) { 'ADD' } elseif ($desiredGitignore -ceq $existingGitignore) { 'UNCHANGED' } else { 'UPDATE' }
    Add-PreflightRecord -Records $records -Root $target -Platform 'All' -TargetPath $gitignorePath -SourcePath (Join-Path $repo 'Scripts/modules/Core.Gitignore.psm1') -ContentType 'ProjectMetadata' -Action $gitignoreAction -Reason 'gitignore_managed_block_content_projection'

    # A missing Cursor runtime takes the official Upgrade-to-Fresh branch.
    if (-not (Test-Path -LiteralPath (Join-Path $target '.cursor') -PathType Container)) {
        Add-PreflightRecord -Records $records -Root $target -Platform 'Cursor' -TargetPath (Join-Path $target '.cursor') -SourcePath (Join-Path $repo 'Cursor/.cursor') -ContentType 'PlatformRoot' -Action 'SKIP' -Reason 'cursor_runtime_absent_upgrade_selects_fresh_branch; source_adds_planned_but_existing_runtime_cannot_be_compared' -OwnershipClass 'environment_limitation'
    }
    $projectSkillRoot = Join-Path $target '.agents/project_skills'
    $projectSkills = if (Test-Path -LiteralPath $projectSkillRoot -PathType Container) { @(Get-ChildItem -LiteralPath $projectSkillRoot -Directory -ErrorAction Stop) } else { @() }
    foreach ($skill in @($projectSkills | Where-Object { $_.Name -notmatch '^_' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')) })) {
        foreach ($skillRoot in @('.agents/skills','.claude/skills','.cursor/skills')) {
            $route = Join-Path (Join-Path $target $skillRoot) "project-$($skill.Name)"
            Add-PreflightRecord -Records $records -Root $target -Platform 'All' -TargetPath $route -SourcePath (Join-Path $skill.FullName 'SKILL.md') -ContentType 'ProjectSkillLink' -Action 'BLOCK' -Reason 'project_skill_backfill_link_effect_requires_separate_resolution' -OwnershipClass 'protected' -Blocking $true
        }
    }
    foreach ($name in @('antigravity','claude','codex')) {
        $path = Join-Path $target ".agents/ai-rules-manifest.$name.json"
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Add-PreflightRecord -Records $records -Root $target -Platform 'All' -TargetPath $path -SourcePath $null -ContentType 'Manifest' -Action 'PRESERVE' -Reason 'no_manifest_writer_in_current_upgrade_path' -OwnershipClass 'existing_runtime'
        }
    }
    foreach ($rel in @('.agents/project_skills/_index.md','.agents/context/_map/CONTEXT.md')) {
        $path = Join-Path $target $rel; $exists = Test-Path -LiteralPath $path -PathType Leaf
        Add-PreflightRecord -Records $records -Root $target -Platform 'All' -TargetPath $path -SourcePath $null -ContentType 'ProtectedContext' -Action $(if ($exists) { 'PRESERVE' } else { 'BLOCK' }) -Reason $(if ($exists) { 'protected_existing' } else { 'upgrade_would_initialize_protected_content' }) -OwnershipClass 'protected' -Blocking (!$exists)
    }
    $basePlan = @($records.Values | Sort-Object target_path)
    if ($null -eq $RuntimeCopyResolution) { return $basePlan }
    if (-not $Gate3AEvidencePath) { throw 'RuntimeCopyResolution.EvidencePathRequired' }
    $candidate = Get-RuntimeCopyResolutionCandidate -RepoRoot $repo -TargetRoot $target -Gate3AEvidencePath $Gate3AEvidencePath -BasePlan $basePlan
    Assert-RuntimeCopyResolution -Candidate $candidate -Resolution $RuntimeCopyResolution -SelectedPlatform $SelectedPlatform
    foreach ($entry in $candidate.targets) {
        $record = @($basePlan | Where-Object { $_.target_path -ceq $entry.path })[0]
        $record.planned_action = 'RETIRE'
        $record.reason = 'user_approved_exact_runtime_copy_resolution'
        $record.blocking = $false
        $record | Add-Member -NotePropertyName archive_required -NotePropertyValue $true -Force
        $record | Add-Member -NotePropertyName resolution_basis -NotePropertyValue 'invocation_scoped_user_decision' -Force
        $record | Add-Member -NotePropertyName original_provenance_classification -NotePropertyValue $entry.provenance_classification -Force
        $record | Add-Member -NotePropertyName resolution_invocation_id -NotePropertyValue $RuntimeCopyResolution.invocation_id -Force
    }
    return $basePlan
}

Export-ModuleMember -Function Get-DeploymentUpgradePreflight
