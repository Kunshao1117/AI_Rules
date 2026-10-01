Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Import-Module (Join-Path $repo 'Scripts/modules/Core.psm1') -Force
Import-Module (Join-Path $repo 'Scripts/modules/Skills-Sync.psm1') -Force
Import-Module (Join-Path $repo 'Scripts/modules/Native-Agent-Projection.psm1') -Force
Import-Module (Join-Path $repo 'Scripts/modules/Antigravity-Procedure-Projection.psm1') -Force
Import-Module (Join-Path $repo 'Scripts/modules/Antigravity-Legacy-Workflow-Projection.psm1') -Force

function Read-C3([string]$path) {
    Get-Content -LiteralPath (Join-Path $repo $path) -Raw -Encoding UTF8
}
function Get-C3Roles {
    $registry = Read-C3 'Shared/agents/_registry.md'
    @([regex]::Matches($registry, '(?m)^\| (?!Role )([^|]+) \| `([^`]+)\.md` \|\r?$') |
        ForEach-Object { [PSCustomObject]@{ Role=$_.Groups[1].Value.Trim(); Id=$_.Groups[2].Value } })
}

Describe 'Phase 5C3 native Agent and procedure source projection' {
    It 'maps exactly the six canonical roles to Cursor native agents' {
        $roles = @(Get-C3Roles)
        $roles.Count | Should Be 6
        $files = @(Get-ChildItem -LiteralPath (Join-Path $repo 'Cursor/.cursor/agents') -File -Filter '*.md')
        $files.Count | Should Be $roles.Count
        foreach ($role in $roles) {
            $name = "ai-rules-$($role.Id)"
            $body = Read-C3 "Cursor/.cursor/agents/$name.md"
            $body | Should Match "(?m)^name: $name\r?$"
            $body | Should Match '(?m)^model: inherit\r?$'
            $body | Should Match "\.agents/shared/agents/$($role.Id)\.md"
            $body | Should Not Match '(?m)^model: (?!inherit)'
            if ($role.Id -eq 'implementer') {
                $body | Should Match '(?m)^readonly: false\r?$'
                $body | Should Match 'authorization-resolution\.md'
            } else {
                $body | Should Match '(?m)^readonly: true\r?$'
            }
            Test-Path -LiteralPath (Join-Path $repo "Claude/.claude/agents/$name.md") | Should Be $true
        }
        @($files | Where-Object Name -Match '(explorer|memory|git|release)').Count | Should Be 0
    }

    It 'documents Cursor compatibility precedence without claiming runtime UI deduplication' {
        $fixture = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($dir in @('.cursor/agents','.claude/agents','.codex/agents')) {
            $null = New-Item -ItemType Directory -Path (Join-Path $fixture $dir) -Force
        }
        $name = 'ai-rules-reviewer.md'
        Copy-Item -LiteralPath (Join-Path $repo "Cursor/.cursor/agents/$name") -Destination (Join-Path $fixture ".cursor/agents/$name")
        foreach ($dir in @('.claude/agents','.codex/agents')) {
            [IO.File]::WriteAllText((Join-Path $fixture "$dir/$name"), 'compatibility definition')
        }
        $chosen = @('.cursor/agents','.claude/agents','.codex/agents') |
            Where-Object { Test-Path -LiteralPath (Join-Path $fixture "$_/$name") } |
            Select-Object -First 1
        $chosen | Should Be '.cursor/agents'
        (Read-C3 'Shared/policies/adapters/cursor-subagent-invocation.md') | Should Match 'CURSOR_REAL_DISCOVERY_SMOKE_PENDING'
        (Read-C3 'Scripts/modules/Platform-Cursor.psm1') | Should Match 'Sync-NativeAgentProjection'
    }

    It 'maps exactly six Antigravity delegated roles with documented tool IDs' {
        $roles = @(Get-C3Roles)
        $files = @(Get-ChildItem -LiteralPath (Join-Path $repo 'Antigravity/.agents/agents') -File -Filter '*.md')
        $files.Count | Should Be $roles.Count
        foreach ($role in $roles) {
            $body = Read-C3 "Antigravity/.agents/agents/$($role.Id).md"
            $body | Should Match "(?m)^name: $($role.Id)\r?$"
            $body | Should Match '(?m)^subagent: true\r?$'
            $body | Should Match '(?m)^mainAgent: false\r?$'
            $body | Should Match '(?m)^model: inherit\r?$'
            $body | Should Match "\.agents/shared/agents/$($role.Id)\.md"
            foreach ($tool in @([regex]::Matches($body, '(?m)^  - ([a-z_]+)\r?$') | ForEach-Object { $_.Groups[1].Value })) {
                @('view_file','grep_search','run_command','replace_file_content') -Contains $tool | Should Be $true
            }
            if ($role.Id -eq 'implementer') {
                $body | Should Match '(?m)^  - replace_file_content\r?$'
                $body | Should Match 'authorization'
            } else {
                $body | Should Not Match '(?m)^  - replace_file_content\r?$'
            }
        }
        @($files | Where-Object Name -Match '(explorer|memory|git|release)').Count | Should Be 0
        (Read-C3 'Scripts/modules/Platform-Antigravity.psm1') | Should Match 'Sync-AntigravityProcedureSkills'
    }

    It 'projects native agents into isolated targets without overwriting unknown same-name copies' {
        foreach ($platform in @('Cursor','Antigravity')) {
            $sourceRel = if ($platform -eq 'Cursor') { 'Cursor/.cursor/agents' } else { 'Antigravity/.agents/agents' }
            $targetRel = if ($platform -eq 'Cursor') { '.cursor/agents' } else { '.agents/agents' }
            $source = Join-Path $repo $sourceRel
            $target = Join-Path (Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))) $targetRel
            $decisions = @(Get-NativeAgentProjectionDecisions -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target)
            @($decisions | Where-Object Action -eq 'ADD').Count | Should Be 6
            $null = Sync-NativeAgentProjection -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target
            @(Get-ChildItem -LiteralPath $target -File -Filter '*.md').Count | Should Be 6
            $same = @(Get-NativeAgentProjectionDecisions -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target)
            @($same | Where-Object Action -eq 'UNCHANGED').Count | Should Be 6
            $collision = $same[0].TargetPath
            [IO.File]::AppendAllText($collision, "`nuser customization")
            $blocked = @(Get-NativeAgentProjectionDecisions -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target)
            @($blocked | Where-Object Action -eq 'BLOCK').Count | Should Be 1
            if ($platform -eq 'Cursor') {
                { Sync-NativeAgentProjection -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target } | Should Throw 'Cursor native Agent projection stopped at an existing unconfirmed target copy.'
            } else {
                { Sync-NativeAgentProjection -Platform $platform -SourceAgentsRoot $source -CanonicalAgentsRoot (Join-Path $repo 'Shared/agents') -TargetAgentsRoot $target } | Should Throw 'Antigravity native Agent projection stopped at an existing unconfirmed target copy.'
            }
            (Get-Content -LiteralPath $collision -Raw) | Should Match 'user customization'
        }
    }

    It 'projects four canonical procedures with an explicit UI delivery alias' {
        $source = Join-Path $repo 'Antigravity/.agents/procedure-skills'
        $workflows = Join-Path $repo 'Shared/workflows'
        $skills = Join-Path $repo 'Shared/skills'
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $targetSkills = Join-Path $target '.agents/skills'
        $ids = @(Get-ChildItem -LiteralPath $workflows -File -Filter '*.md' | ForEach-Object BaseName | Sort-Object)
        $ids.Count | Should Be 4
        $planned = @(Get-AntigravityProcedureSkillDecisions -ProcedureSkillsRoot $source -CanonicalWorkflowsRoot $workflows -SharedSkillsRoot $skills -TargetSkillsPath $targetSkills)
        @($planned | Where-Object Action -eq 'ADD').Count | Should Be 4
        @($planned | Where-Object { $_.Id -eq 'ui-design-exploration' -and $_.DeliveryId -eq 'ui-design-exploration-procedure' }).Count | Should Be 1
        $null = Sync-AntigravityProcedureSkills -ProcedureSkillsRoot $source -CanonicalWorkflowsRoot $workflows -SharedSkillsRoot $skills -TargetSkillsPath $targetSkills
        foreach ($id in $ids) {
            $deliveryId = if ($id -eq 'ui-design-exploration') { 'ui-design-exploration-procedure' } else { $id }
            $body = Get-Content -LiteralPath (Join-Path $targetSkills "$deliveryId/SKILL.md") -Raw -Encoding UTF8
            $body | Should Match "(?m)^name: $deliveryId\r?$"
            $body | Should Match "\.agents/shared/workflows/$id\.md"
            Test-Path -LiteralPath (Join-Path $skills "$deliveryId/SKILL.md") | Should Be $false
        }
        @(Get-ChildItem -LiteralPath $targetSkills -Recurse -File -Filter SKILL.md).Count | Should Be 4
        Test-Path -LiteralPath (Join-Path $targetSkills 'ui-design-exploration/SKILL.md') | Should Be $false
        Test-Path -LiteralPath (Join-Path $target '.agents/memory') | Should Be $false
        Test-Path -LiteralPath (Join-Path $target '.agents/context') | Should Be $false
    }

    It 'preserves an unknown same-name Skill and stops the entire wrapper projection' {
        $source = Join-Path $repo 'Antigravity/.agents/procedure-skills'
        $workflows = Join-Path $repo 'Shared/workflows'
        $skills = Join-Path $repo 'Shared/skills'
        $target = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $targetSkills = Join-Path $target '.agents/skills'
        $collision = Join-Path $targetSkills 'plugin-release/SKILL.md'
        $null = New-Item -ItemType Directory -Path (Split-Path $collision -Parent) -Force
        [IO.File]::WriteAllText($collision, 'user-authored skill')
        $decisions = @(Get-AntigravityProcedureSkillDecisions -ProcedureSkillsRoot $source -CanonicalWorkflowsRoot $workflows -SharedSkillsRoot $skills -TargetSkillsPath $targetSkills)
        @($decisions | Where-Object Action -eq 'BLOCK').Count | Should Be 1
        { Sync-AntigravityProcedureSkills -ProcedureSkillsRoot $source -CanonicalWorkflowsRoot $workflows -SharedSkillsRoot $skills -TargetSkillsPath $targetSkills } | Should Throw 'Antigravity procedure Skill projection stopped at an existing unconfirmed target copy.'
        (Get-Content -LiteralPath $collision -Raw) | Should Be 'user-authored skill'
        Test-Path -LiteralPath (Join-Path $targetSkills 'git-checkpoint/SKILL.md') | Should Be $false
    }

    It 'keeps legacy Workflow copies separate from the four future procedure deliveries' {
        $map = Read-C3 'Shared/policies/references/antigravity-procedure-delivery.md'
        $map | Should Match '2026-11-01'
        $map | Should Match 'not a Shared Skill registry'
        $map | Should Match 'distinct legacy command'
        $platform = Read-C3 'Scripts/modules/Platform-Antigravity.psm1'
        $platform | Should Match 'procedure-skills'
        $platform | Should Match 'Sync-AntigravityProcedureSkills'
        $platform | Should Match 'Sync-SharedGovernanceReferences'
        $platform | Should Match 'Get-AntigravityLegacyWorkflowProjection'
        $platform | Should Match 'Sync-NativeAgentProjection'
        $platform | Should Match '-ScanDirs \$legacyScanDirs'
    }

    It 'gates all 16 legacy commands and two includes at the documented retirement date' {
        $manifest = Join-Path $repo 'Antigravity/legacy-workflow-projection.json'
        $source = Join-Path $repo 'Antigravity/.agents/workflows'
        $before = Get-AntigravityLegacyWorkflowProjection -ManifestPath $manifest -SourceWorkflowsRoot $source -AsOf ([datetime]'2026-10-31')
        $after = Get-AntigravityLegacyWorkflowProjection -ManifestPath $manifest -SourceWorkflowsRoot $source -AsOf ([datetime]'2026-11-01')
        $before.Project | Should Be $true
        $after.Project | Should Be $false
        $before.CommandCount | Should Be 16
        @($before.SourceFiles).Count | Should Be 18
        (Read-C3 'Scripts/modules/Manager.ProjectSync.psm1') | Should Match '-ScanDirs \$legacyScanDirs'
        (Read-C3 'Scripts/modules/Deployment.Preflight.psm1') | Should Match 'retired_platform_workflow_existing_copy_preserved_without_provenance'
        (Read-C3 'Scripts/modules/Deployment.Preflight.psm1') | Should Match 'dirs=\$legacyScanDirs'
    }

    It 'keeps new projection functions outside the existing Shared Skill sync responsibility' {
        $old = Read-C3 'Scripts/modules/Skills-Sync.psm1'
        $old | Should Not Match 'function Get-NativeAgentProjectionDecisions'
        $old | Should Not Match 'function Get-AntigravityProcedureSkillDecisions'
        Test-Path -LiteralPath (Join-Path $repo 'Scripts/modules/Native-Agent-Projection.psm1') | Should Be $true
        Test-Path -LiteralPath (Join-Path $repo 'Scripts/modules/Antigravity-Procedure-Projection.psm1') | Should Be $true
        Test-Path -LiteralPath (Join-Path $repo 'Scripts/modules/Antigravity-Legacy-Workflow-Projection.psm1') | Should Be $true
    }
}
