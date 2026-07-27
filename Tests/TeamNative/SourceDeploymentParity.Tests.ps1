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
        $pairs = @(
            @{ Source = 'Shared\policies\language-governance.md'; Runtime = '.agents\shared\policies\language-governance.md' },
            @{ Source = 'Shared\policies\references\status-ontology.md'; Runtime = '.agents\shared\policies\references\status-ontology.md' },
            @{ Source = 'Shared\skills\quality-review-governance\SKILL.md'; Runtime = '.agents\skills\quality-review-governance\SKILL.md' },
            @{ Source = 'Shared\skills\team-completion-gate\SKILL.md'; Runtime = '.agents\skills\team-completion-gate\SKILL.md' },
            @{ Source = 'Shared\skills\team-change-delivery-artifact\SKILL.md'; Runtime = '.agents\skills\team-change-delivery-artifact\SKILL.md' },
            @{ Source = 'Shared\skills\team-review-delivery-artifact\SKILL.md'; Runtime = '.agents\skills\team-review-delivery-artifact\SKILL.md' },
            @{ Source = 'Shared\skills\team-validation-delivery-artifact\SKILL.md'; Runtime = '.agents\skills\team-validation-delivery-artifact\SKILL.md' }
        )

        foreach ($pair in $pairs) {
            $sourcePath = Join-Path $repoRoot $pair.Source
            $runtimePath = Join-Path $repoRoot $pair.Runtime
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

        foreach ($platformCore in @('Codex\.codex\AGENTS.md', 'Claude\.claude\rules\core-identity.md', 'Antigravity\.agents\rules\00_core_identity.md')) {
            $content = Get-Content -LiteralPath (Join-Path $repoRoot $platformCore) -Raw
            if (-not $content.Contains('Shared/policies/language-governance.md')) { throw "Platform core is missing the language-policy pointer: $platformCore" }
        }
    }
}
