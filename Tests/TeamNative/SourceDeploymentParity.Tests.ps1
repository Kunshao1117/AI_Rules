$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Import-Module (Join-Path $repoRoot 'Scripts\modules\Skills-Sync.psm1') -Force

Describe 'Source deployment parity' {
    BeforeEach {
        $script:tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("ai-rules-source-parity-" + [guid]::NewGuid())
        New-Item -ItemType Directory -Force -Path $script:tempRoot | Out-Null
    }

    AfterEach {
        if (Test-Path -LiteralPath $script:tempRoot) {
            Remove-Item -LiteralPath $script:tempRoot -Recurse -Force
        }
    }

    It 'keeps rebuildable Shared runtime copies out of the repository index' {
        $relativePaths = @(
            'policies/references/user-facing-output-examples.md',
            'policies/references/workflow-execution-spec-contract.md',
            'policies/requirement-precision.md',
            'policies/workflow-orchestration.md'
        )
        foreach ($relativePath in $relativePaths) {
            $sourcePath = Join-Path $repoRoot ("Shared/" + $relativePath)
            if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) { throw "Canonical source is missing: $relativePath" }
            $runtimePath = ".agents/shared/" + $relativePath
            $tracked = @(git -C $repoRoot ls-files -- $runtimePath)
            if ($LASTEXITCODE -ne 0) { throw "Could not inspect Git tracking for: $runtimePath" }
            if ($tracked.Count -ne 0) { throw "Rebuildable runtime copy is still tracked: $runtimePath" }
            $ignored = @(git -C $repoRoot check-ignore --no-index -- $runtimePath)
            if ($LASTEXITCODE -ne 0 -or $ignored.Count -ne 1) { throw "Runtime copy is not ignored: $runtimePath" }
        }
    }

    It 'rebuilds the untracked Shared copies from source without touching protected data' {
        $relativePaths = @(
            'policies/references/user-facing-output-examples.md',
            'policies/references/workflow-execution-spec-contract.md',
            'policies/requirement-precision.md',
            'policies/workflow-orchestration.md'
        )
        $sharedRoot = Join-Path $repoRoot 'Shared'
        $runtimeRoot = Join-Path $script:tempRoot 'runtime'
        $agentsRoot = Join-Path $runtimeRoot '.agents'
        $protectedPaths = @('.agents/memory/keep/MEMORY.md', '.agents/context/keep.md', '.agents/project_skills/keep/SKILL.md', '.cartridge/index.json')
        $protectedHashes = @{}
        foreach ($relativePath in $protectedPaths) {
            $path = Join-Path $runtimeRoot $relativePath
            New-Item -ItemType Directory -Force -Path (Split-Path $path -Parent) | Out-Null
            [System.IO.File]::WriteAllText($path, 'keep existing local bytes', [System.Text.UTF8Encoding]::new($false))
            $protectedHashes[$relativePath] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        }
        $sourceHashes = @{}
        foreach ($relativePath in $relativePaths) {
            $sourceHashes[$relativePath] = (Get-FileHash -LiteralPath (Join-Path $sharedRoot $relativePath) -Algorithm SHA256).Hash
        }

        $null = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot -Mode Full
        foreach ($relativePath in $relativePaths) {
            $runtimePath = Join-Path $agentsRoot ("shared/" + $relativePath)
            if ((Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash -ne $sourceHashes[$relativePath]) { throw "Rebuilt copy differs from source: $relativePath" }
        }
        $updated = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot -Mode Diff
        if ($updated -ne 0) { throw "Unchanged Shared projection was not idempotent: $updated updates." }

        # Remove only this test's generated files, then exercise missing-copy regeneration.
        foreach ($relativePath in $relativePaths) {
            Remove-Item -LiteralPath (Join-Path $agentsRoot ("shared/" + $relativePath)) -Force
        }
        $updated = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $agentsRoot -Mode Diff
        if ($updated -ne $relativePaths.Count) { throw "Expected four missing copies to be rebuilt; received $updated." }
        foreach ($relativePath in $relativePaths) {
            $runtimePath = Join-Path $agentsRoot ("shared/" + $relativePath)
            $sourcePath = Join-Path $sharedRoot $relativePath
            if ((Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash -ne $sourceHashes[$relativePath]) { throw "Regenerated copy differs from source: $relativePath" }
            if ((Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash -ne $sourceHashes[$relativePath]) { throw "Projection changed its source: $relativePath" }
        }
        foreach ($relativePath in $protectedPaths) {
            if ((Get-FileHash -LiteralPath (Join-Path $runtimeRoot $relativePath) -Algorithm SHA256).Hash -ne $protectedHashes[$relativePath]) { throw "Projection changed protected data: $relativePath" }
        }
    }

    It 'keeps the Codex generated marker as a pointer while the adapter owns the full policy' {
        $policyPath = Join-Path $repoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $targetPath = Join-Path $script:tempRoot '.codex\AGENTS.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($targetPath, "# Test core`r`n`r`nCodex-specific governance:`r`n", [System.Text.UTF8Encoding]::new($false))

        $updated = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Codex -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
        if ($updated -ne 1) { throw "Expected one generated-marker update; received $updated." }

        $targetContent = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($targetContent -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') { throw 'Generated Codex marker is not a pointer.' }
        if ($targetContent -notmatch 'Shared/policies/adapters/codex-subagent-invocation\.md') { throw 'Generated Codex marker does not identify the canonical adapter.' }
        if ($targetContent -match 'The governed Codex candidate rungs are exactly') { throw 'Generated Codex marker copied the full adapter policy.' }

        $adapterContent = Get-Content -LiteralPath $policyPath -Raw -Encoding UTF8
        if ($adapterContent -notmatch 'model/effort selection or variance') { throw 'Adapter lacks model/effort lifecycle retention wording.' }
        if ($adapterContent -notmatch 'role_instance_id') { throw 'Adapter lacks role-instance retention wording.' }
        if ($adapterContent -notmatch 'Only an explicit captain `replace`') { throw 'Adapter lacks explicit replacement wording.' }
    }

    It 'keeps the checked-in Codex source template idempotent with its generated pointer' {
        $policyPath = Join-Path $repoRoot 'Shared\policies\adapters\codex-subagent-invocation.md'
        $sourceTemplatePath = Join-Path $repoRoot 'Codex\.codex\AGENTS.md'
        $targetPath = Join-Path $script:tempRoot '.codex\AGENTS.md'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        Copy-Item -LiteralPath $sourceTemplatePath -Destination $targetPath -Force
        $before = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        $updated = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Codex -InsertAfterPattern '(?m)^Codex-specific governance:\s*$'
        if ($updated -ne 0) { throw "Expected the checked-in template to be unchanged; received $updated." }
        $after = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($before -cne $after) { throw 'The checked-in Codex source template is not idempotent with its generated pointer.' }
    }

    It 'keeps the Cursor generated marker as a pointer while the adapter owns the full policy' {
        $policyPath = Join-Path $repoRoot 'Shared\policies\adapters\cursor-subagent-invocation.md'
        $targetPath = Join-Path $script:tempRoot '.cursor\rules\00-core.mdc'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        [System.IO.File]::WriteAllText($targetPath, "# Test core`r`n`r`nCursor-specific governance:`r`n", [System.Text.UTF8Encoding]::new($false))

        $updated = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Cursor -InsertAfterPattern '(?m)^Cursor-specific governance:\s*$'
        if ($updated -ne 1) { throw "Expected one generated-marker update; received $updated." }

        $targetContent = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($targetContent -notmatch 'Shared Subagent Invocation Policy \(generated pointer\)') { throw 'Generated Cursor marker is not a pointer.' }
        if ($targetContent -notmatch 'Shared/policies/adapters/cursor-subagent-invocation\.md') { throw 'Generated Cursor marker does not identify the canonical adapter.' }
        if ($targetContent -match 'Current Cursor channel names include') { throw 'Generated Cursor marker copied the full adapter policy.' }
    }

    It 'keeps the checked-in Cursor source template idempotent with its generated pointer' {
        $policyPath = Join-Path $repoRoot 'Shared\policies\adapters\cursor-subagent-invocation.md'
        $sourceTemplatePath = Join-Path $repoRoot 'Cursor\.cursor\rules\00-core.mdc'
        $targetPath = Join-Path $script:tempRoot '.cursor\rules\00-core.mdc'
        New-Item -ItemType Directory -Force -Path (Split-Path $targetPath -Parent) | Out-Null
        Copy-Item -LiteralPath $sourceTemplatePath -Destination $targetPath -Force
        $before = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8

        $updated = Sync-SharedPolicyBlock -PolicyPath $policyPath -TargetPath $targetPath -Platform Cursor -InsertAfterPattern '(?m)^Cursor-specific governance:\s*$'
        if ($updated -ne 0) { throw "Expected the checked-in Cursor template to be unchanged; received $updated." }
        $after = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
        if ($before -cne $after) { throw 'The checked-in Cursor source template is not idempotent with its generated pointer.' }
    }

    It 'syncs V2 policies, references, and skills as exact SHA256 copies' {
        $sharedRoot = Join-Path $script:tempRoot 'Shared'
        $skillsRoot = Join-Path $sharedRoot 'skills'
        $targetAgentsRoot = Join-Path $script:tempRoot 'target\.agents'
        $targetSkillsRoot = Join-Path $targetAgentsRoot 'skills'

        $policySource = Join-Path $sharedRoot 'policies\team-native-v2.md'
        $referenceSource = Join-Path $sharedRoot 'policies\references\team-native-v2-contract.md'
        $skillSource = Join-Path $skillsRoot 'team-native-v2\SKILL.md'
        foreach ($path in @($policySource, $referenceSource, $skillSource)) {
            New-Item -ItemType Directory -Force -Path (Split-Path $path -Parent) | Out-Null
        }
        [System.IO.File]::WriteAllText($policySource, "v2 policy`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText($referenceSource, "v2 reference`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::WriteAllText($skillSource, "---`nname: team-native-v2`n---`n", [System.Text.UTF8Encoding]::new($false))

        $referenceUpdates = Sync-SharedGovernanceReferences -SharedRoot $sharedRoot -TargetAgentsRoot $targetAgentsRoot -Mode Diff
        if ($referenceUpdates -ne 2) { throw "Expected two governance/reference updates; received $referenceUpdates." }
        $skillUpdates = Sync-SharedSkills -SharedSkillsRoot $skillsRoot -TargetSkillsPath $targetSkillsRoot -Mode Diff
        if ($skillUpdates -ne 1) { throw "Expected one skill update; received $skillUpdates." }

        $deployedPolicy = Join-Path $targetAgentsRoot 'shared\policies\team-native-v2.md'
        $deployedReference = Join-Path $targetAgentsRoot 'shared\policies\references\team-native-v2-contract.md'
        $deployedSkill = Join-Path $targetSkillsRoot 'team-native-v2\SKILL.md'
        foreach ($pair in @(
            @{ Source = $policySource; Target = $deployedPolicy },
            @{ Source = $referenceSource; Target = $deployedReference },
            @{ Source = $skillSource; Target = $deployedSkill }
        )) {
            $sourceHash = (Get-FileHash -LiteralPath $pair.Source -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash -LiteralPath $pair.Target -Algorithm SHA256).Hash
            if ($sourceHash -ne $targetHash) { throw "SHA256 mismatch after sync: $($pair.Source)" }
        }
    }

    It 'keeps beginner-facing reporting centralized while runtime copies remain exact' {
        $runtimeRoot = Join-Path $script:tempRoot 'runtime'
        $agentsRoot = Join-Path $runtimeRoot '.agents'
        $skillsRoot = Join-Path $agentsRoot 'skills'
        $null = Sync-SharedSkills -SharedSkillsRoot (Join-Path $repoRoot 'Shared\skills') -TargetSkillsPath $skillsRoot -Mode Full
        $null = Sync-SharedGovernanceReferences -SharedRoot (Join-Path $repoRoot 'Shared') -TargetAgentsRoot $agentsRoot -Mode Full

        $pairs = @(
            @{ Source = 'Shared\policies\language-governance.md'; Runtime = '.agents\shared\policies\language-governance.md' },
            @{ Source = 'Shared\policies\references\status-ontology.md'; Runtime = '.agents\shared\policies\references\status-ontology.md' },
            @{ Source = 'Shared\policies\review-governance.md'; Runtime = '.agents\shared\policies\review-governance.md' },
            @{ Source = 'Shared\policies\completion-policy.md'; Runtime = '.agents\shared\policies\completion-policy.md' },
            @{ Source = 'Shared\agents\reviewer.md'; Runtime = '.agents\shared\agents\reviewer.md' },
            @{ Source = 'Shared\skills\browser-testing\SKILL.md'; Runtime = '.agents\skills\browser-testing\SKILL.md' },
            @{ Source = 'Shared\skills\security-sre\SKILL.md'; Runtime = '.agents\skills\security-sre\SKILL.md' }
        )

        foreach ($pair in $pairs) {
            $sourcePath = Join-Path $repoRoot $pair.Source
            $runtimePath = Join-Path $runtimeRoot $pair.Runtime
            if ((Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash) {
                throw "Source/runtime reporting parity failed: $($pair.Source)"
            }
        }

        $languagePolicy = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\language-governance.md') -Raw
        foreach ($requiredRule in @('### User-Visible Response Boundary', '### Technical Detail Boundary', '### Beginner Readability Check', 'This boundary applies equally to Direct and delegated work.')) {
            if (-not $languagePolicy.Contains($requiredRule)) { throw "Language governance is missing: $requiredRule" }
        }
        if ($languagePolicy.Contains('must be introduced as `繁體中文(English)`')) { throw 'Language governance still requires automatic English parentheticals.' }

        $statusOntology = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\references\status-ontology.md') -Raw
        foreach ($requiredLabel in @('`pass_with_followups` | 已完成，另有不影響目前結果的後續建議', '`block` | 目前無法繼續')) {
            if (-not $statusOntology.Contains($requiredLabel)) { throw "Status display label is missing: $requiredLabel" }
        }

        foreach ($platformCore in @('Codex\.codex\AGENTS.md', 'Claude\.claude\rules\core-identity.md', 'Antigravity\.agents\rules\00_core_identity.md', 'Cursor\.cursor\rules\00-core.mdc')) {
            $content = Get-Content -LiteralPath (Join-Path $repoRoot $platformCore) -Raw
            if (-not $content.Contains('Shared/policies/language-governance.md')) { throw "Platform core is missing the language-policy pointer: $platformCore" }
        }
    }
}
