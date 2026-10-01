Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

# Source conformance only. These tests do not deploy, invoke agents, interpret
# natural-language prompts, perform Git mutations, or execute protected actions.
# Scenario facts are normalized from the Phase 2 acceptance examples. The small
# first-match interpreter reads the ordered rules from their canonical owners;
# it contains no routing rules, model profiles, platform runtime, or NLP engine.
function Read-VNextSource([string]$RelativePath) {
    Get-Content -LiteralPath (Join-Path $repoRoot $RelativePath) -Raw -Encoding UTF8
}
function Read-VNextTable([string]$Source, [string]$Marker) {
    $pattern = '(?s)<!-- ' + $Marker + '_START -->(.*?)<!-- ' + $Marker + '_END -->'
    $blocks = [regex]::Matches($Source, $pattern)
    if ($blocks.Count -ne 1) { throw "Expected exactly one $Marker" }
    $rows = @([regex]::Matches($blocks[0].Groups[1].Value, '(?m)^\| ([a-z_]+) \| ([a-z_]+) \|\s*$') | ForEach-Object {
        @{ Fact = $_.Groups[1].Value; Result = $_.Groups[2].Value }
    })
    if ($rows.Count -eq 0 -or $rows[-1].Fact -ne 'otherwise') { throw 'Missing final default' }
    if (@($rows | ForEach-Object { $_.Fact } | Select-Object -Unique).Count -ne $rows.Count) { throw 'Duplicate fact' }
    return $rows
}
function Invoke-VNextTable([object[]]$Rows, [hashtable]$Facts) {
    foreach ($row in $Rows) {
        if ($row.Fact -eq 'otherwise' -or ($Facts.ContainsKey($row.Fact) -and $Facts[$row.Fact] -eq $true)) {
            return $row.Result
        }
    }
    throw 'No matching decision'
}
function Get-VNextTextHash([string]$Text) {
    $normalized = ($Text -replace '\s+', ' ').Trim()
    $hash = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes($normalized)))).Replace('-', '').ToLowerInvariant() }
    finally { $hash.Dispose() }
}

$routing = Read-VNextSource 'Shared/policies/execution-routing.md'
$authorization = Read-VNextSource 'Shared/policies/authorization-resolution.md'
$registry = Read-VNextSource 'Shared/policies/references/protected-action-registry.md'
$executionRows = @(Read-VNextTable $routing 'EXECUTION_DECISION_TABLE')
$authorizationRows = @(Read-VNextTable $authorization 'AUTHORIZATION_DECISION_TABLE')

$routingCases = @(
    @{ Name = 'ordinary source bug'; Facts = @{}; Expected = 'direct' },
    @{ Name = 'coherent multi-file multi-module repair'; Facts = @{ file_count = 8; module_count = 3 }; Expected = 'direct' },
    @{ Name = 'build fix debug test source docs policy audit labels'; Facts = @{ workflow = 'build/fix/debug/test/source/docs/policy/audit' }; Expected = 'direct' },
    @{ Name = 'experiment workflow is not a Team trigger'; Facts = @{ workflow = '03-1 experiment' }; Expected = 'direct' },
    @{ Name = 'available browser MCP and subagent'; Facts = @{ browser_available = $true; mcp_available = $true; subagent_available = $true }; Expected = 'direct' },
    @{ Name = 'helper searches and main agent implements'; Facts = @{ bounded_helper_use = $true }; Expected = 'assisted' },
    @{ Name = 'explicit subagent request for finding error origin'; Facts = @{ bounded_helper_use = $true; explicit_subagent_wording = $true }; Expected = 'assisted' },
    @{ Name = 'multiple bounded helpers retain one owner'; Facts = @{ bounded_helper_use = $true; helper_count = 3 }; Expected = 'assisted' },
    @{ Name = 'explicit team with implementer and reviewer'; Facts = @{ explicit_team_ownership = $true; required_duty_separation = $true }; Expected = 'team' },
    @{ Name = 'two independent verifiable parallel streams'; Facts = @{ independent_parallel_streams = $true }; Expected = 'team' },
    @{ Name = 'high risk alone'; Facts = @{ risk = 'high' }; Expected = 'direct' },
    @{ Name = 'systemic impact alone'; Facts = @{ change_impact = 'systemic' }; Expected = 'direct' },
    @{ Name = 'high risk helper without duty separation'; Facts = @{ risk = 'high'; bounded_helper_use = $true }; Expected = 'assisted' },
    @{ Name = 'required independent review'; Facts = @{ required_duty_separation = $true }; Expected = 'team' },
    @{ Name = 'overload remains after narrowing and staging'; Facts = @{ unresolved_single_owner_overload = $true }; Expected = 'team' },
    @{ Name = 'actual platform duty separation'; Facts = @{ platform_requires_separation = $true }; Expected = 'team' },
    @{ Name = 'explicit Team wins over helper wording'; Facts = @{ bounded_helper_use = $true; explicit_team_ownership = $true }; Expected = 'team' },
    @{ Name = 'protected external does not select Team'; Facts = @{ authorization_class = 'protected.external' }; Expected = 'direct' },
    @{ Name = 'formal research team can be observe'; Facts = @{ explicit_team_ownership = $true; authorization_class = 'observe' }; Expected = 'team' }
)

$authorizationCases = @(
    @{ Name = 'read search git diff status docs without GO'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' },
    @{ Name = 'necessary local bug edits without formal-write or board'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' },
    @{ Name = 'bounded local tests build browser and temporary evidence'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' },
    @{ Name = 'unrelated framework replacement'; Facts = @{ current_scope_allows = $true; out_of_scope = $true }; Expected = 'scope_decision_required' },
    @{ Name = 'fix alone cannot commit'; Facts = @{ current_scope_allows = $true; missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'fix and explicit local commit without second GO'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true }; Expected = 'authorized' },
    @{ Name = 'source task cannot create branch or stash'; Facts = @{ current_scope_allows = $true; missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'explicit local branch action'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true }; Expected = 'authorized' },
    @{ Name = 'fix alone cannot push merge release deploy'; Facts = @{ current_scope_allows = $true; missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'release v1.3 to GitHub Release without GO RELEASE'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true }; Expected = 'authorized' },
    @{ Name = 'external action with unresolved target'; Facts = @{ current_scope_allows = $true; missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'platform deny defeats explicit authorization'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true; platform_denied = $true }; Expected = 'stop_affected_action' },
    @{ Name = 'platform allow cannot supply user authority'; Facts = @{ platform_allowed = $true }; Expected = 'not_authorized' },
    @{ Name = 'no issuer signature nonce capability is not a denial'; Facts = @{ current_scope_allows = $true; crypto_available = $false }; Expected = 'authorized' },
    @{ Name = 'protected external with no crypto capability'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true; crypto_available = $false }; Expected = 'authorized' },
    @{ Name = 'actual required native contract invalid'; Facts = @{ current_scope_allows = $true; native_required_contract_invalid = $true }; Expected = 'stop_affected_action' },
    @{ Name = 'explicit exclusion beats necessary local work'; Facts = @{ current_scope_allows = $true; user_excluded_or_revoked = $true }; Expected = 'not_authorized' },
    @{ Name = 'Memory does not inherit source authority'; Facts = @{ current_scope_allows = $true; frozen_memory_action = $true }; Expected = 'legacy_memory_contract' },
    @{ Name = 'Memory crypto absence keeps original consumer'; Facts = @{ frozen_memory_action = $true; crypto_available = $false }; Expected = 'legacy_memory_contract' },
    @{ Name = 'platform deny also stops Memory action'; Facts = @{ frozen_memory_action = $true; platform_denied = $true }; Expected = 'stop_affected_action' },
    @{ Name = 'explicit Memory exclusion remains denied'; Facts = @{ frozen_memory_action = $true; user_excluded_or_revoked = $true }; Expected = 'not_authorized' },
    @{ Name = 'destructive action missing material rollback evidence'; Facts = @{ current_scope_allows = $true; missing_material_destructive_safety = $true }; Expected = 'safety_evidence_required' },
    @{ Name = 'destructive action target and safety resolved'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true }; Expected = 'authorized' },
    @{ Name = 'existing lockfile necessary project-local restore'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' },
    @{ Name = 'minimal required dependency stays scoped'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' },
    @{ Name = 'dependency changes core architecture'; Facts = @{ out_of_scope = $true }; Expected = 'scope_decision_required' },
    @{ Name = 'host global install cannot borrow source scope'; Facts = @{ current_scope_allows = $true; missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'explicit host action and target'; Facts = @{ current_scope_allows = $true; explicit_action_target = $true }; Expected = 'authorized' },
    @{ Name = 'agent secret read lacks authorization'; Facts = @{ missing_explicit_action_target = $true }; Expected = 'not_authorized' },
    @{ Name = 'eligible product opaque credential consumption'; Facts = @{ current_scope_allows = $true }; Expected = 'authorized' }
)

Describe 'VNext normalized execution scenario contract (not platform behavior)' {
    It '<Name>' -TestCases $routingCases {
        param($Name, $Facts, $Expected)
        Invoke-VNextTable $executionRows $Facts | Should Be $Expected
    }
}
Describe 'VNext normalized authorization scenario contract (no actions executed)' {
    It '<Name>' -TestCases $authorizationCases {
        param($Name, $Facts, $Expected)
        Invoke-VNextTable $authorizationRows $Facts | Should Be $Expected
    }
    It 'does not let execution mode change authority for any scenario' {
        foreach ($case in $authorizationCases) {
            foreach ($mode in @('direct', 'assisted', 'team')) {
                $facts = $case.Facts.Clone(); $facts.execution_mode = $mode
                Invoke-VNextTable $authorizationRows $facts | Should Be $case.Expected
            }
        }
    }
}

Describe 'VNext source contracts (static evidence, separate from scenarios)' {
    It 'keeps exactly one canonical decision table for each axis' {
        $executionOwners = @(Get-ChildItem (Join-Path $repoRoot 'Shared/policies') -Recurse -Filter '*.md' | Where-Object { (Get-Content $_.FullName -Raw -Encoding UTF8).Contains('<!-- EXECUTION_DECISION_TABLE_START -->') })
        $authorizationOwners = @(Get-ChildItem (Join-Path $repoRoot 'Shared/policies') -Recurse -Filter '*.md' | Where-Object { (Get-Content $_.FullName -Raw -Encoding UTF8).Contains('<!-- AUTHORIZATION_DECISION_TABLE_START -->') })
        $executionOwners.Count | Should Be 1
        $executionOwners[0].Name | Should Be 'execution-routing.md'
        $authorizationOwners.Count | Should Be 1
        $authorizationOwners[0].Name | Should Be 'authorization-resolution.md'
    }
    It 'limits the general protected catalog to four classes' {
        $catalog = ($registry -split '## Non-Protected Local Work')[0]
        $classes = @([regex]::Matches($catalog, '`(protected\.[a-z_]+)`') | ForEach-Object { $_.Groups[1].Value })
        ($classes | Sort-Object) -join ',' | Should Be 'protected.credential_privilege,protected.destructive,protected.external,protected.system'
        $registry | Should Match 'force push is destructive and external'
    }
    It 'preserves the complete old authorization body only inside frozen Memory scope' {
        $match = [regex]::Match($authorization, '(?s)<!-- LEGACY_MEMORY_AUTHORIZATION_START -->(.*?)<!-- LEGACY_MEMORY_AUTHORIZATION_END -->')
        $match.Success | Should Be $true
        $restored = $match.Groups[1].Value -replace '(?m)^#(#{2,}) ', '$1 '
        # Original normalized body at Phase 2 baseline HEAD 2914703211003ae8adad4f6e8522467b74908da6.
        Get-VNextTextHash $restored | Should Be 'aa570f0c51529776bbcb7eb72dd5a0364fae1082d7f06786b220f931611ac6b5'
        $general = ($authorization -split '## Legacy Memory Compatibility')[0]
        $general | Should Not Match 'A protected mutation requires a trusted tool execution envelope'
        $general | Should Match 'No general routing decision decides Memory eligibility or completion'
    }
    It 'preserves frozen Memory registry rows and credential isolation eligibility' {
        $registry | Should Match '\| Memory card or project context write \| protected \| `protected-memory-write`'
        $registry | Should Match '\| Memory commit \| protected \| `protected-memory-commit`'
        $credential = Read-VNextSource 'Shared/policies/references/credential-boundary-contract.md'
        $credential | Should Match '`AGENT_SECRET_HANDLING` \| yes'
        $credential | Should Match '`APPROVED_PRODUCT_OWNED_CREDENTIAL_CONSUMPTION` \| no, when eligible'
        $credential | Should Match 'does not\s+read, stat, existence-probe, hash, resolve, copy, move, link, modify, or\s+delete'
    }
    It 'retires pre-vNext Codex scoring from the active adapter and uses one profile owner' {
        $codex = (Read-VNextSource 'Shared/policies/adapters/codex-subagent-invocation.md') -replace "`r`n", "`n"
        $active = [regex]::Replace($codex, '(?s)<!-- LEGACY_TEAM_COMPATIBILITY_START -->.*?<!-- LEGACY_TEAM_COMPATIBILITY_END -->', '')
        $active | Should Match 'model-profile-routing.md'
        $active | Should Match 'codex-model-resolution.md'
        $active | Should Not Match 'governed Codex candidate rungs|Bootstrap Codex latency|W50|W90|W99'
        $codex | Should Match 'LEGACY_TEAM_COMPATIBILITY_START'
        $codex | Should Not Match 'multi_agent_v1__spawn_agent|V1_NOT_AVAILABLE|required V1 runtime schema'
        $codex | Should Match 'current callable helper/subagent schema'
    }
    It 'aligns every platform core and bootstrap with independent modes and authority' {
        $paths = @('Codex/.codex/AGENTS.md','Cursor/.cursor/rules/00-core.mdc','Claude/.claude/rules/core-identity.md','Claude/.claude/CLAUDE.md','Antigravity/.agents/rules/00_core_identity.md','Codex/global/AGENTS.md','Claude/global/CLAUDE.md','Antigravity/global/GEMINI.md')
        foreach ($path in $paths) {
            $source = Read-VNextSource $path
            foreach ($required in @('Direct','Assisted','execution-routing','authorization-resolution','local_work')) {
                if (-not $source.Contains($required)) { throw "$path lacks $required" }
            }
            if ($source -match 'starts when the Director requests governed work|Covered governed work includes|only after the Director explicitly inputs') { throw "Old entry gate: $path" }
        }
    }
    It 'routes general workflows to bounded Agents and removes automatic experiment activation' {
        $roots = @('Codex/.agents/workflow-skills','Cursor/.agents/workflow-skills','Claude/.claude/commands','Antigravity/.agents/workflows')
        $checked = 0
        foreach ($root in $roots) {
            foreach ($file in Get-ChildItem (Join-Path $repoRoot $root) -Recurse -Filter '*.md') {
                # Memory workflows and Git-only routine are preserved, not general route consumers.
                if ($file.Name.StartsWith('_') -or $file.Name -match '^(05|10)' -or $file.Directory.Name -match '^(05|10)') { continue }
                $source = Get-Content $file.FullName -Raw -Encoding UTF8
                $source | Should Match 'execution-routing.md'
                $source | Should Match 'authorization-resolution.md'
                $source | Should Match 'bounded helper use is Assisted'
                $source | Should Not Match 'prototype activates Team|觸發 Team mode|promote evidence-bearing requests to formal-readonly'
                $frontmatter = ($source -split '---')[1]
                $frontmatter | Should Not Match 'programming-team-governance|team-task-board|team-specialist-registry'
                $checked++
            }
        }
        $checked | Should Be 47
    }
    It 'keeps generated canonical core markers derived from their adapters' {
        Import-Module (Join-Path $repoRoot 'Scripts/modules/Skills-Sync.psm1') -Force
        foreach ($platform in @('Claude', 'Antigravity')) {
            $corePath = if ($platform -eq 'Claude') { 'Claude/.claude/rules/core-identity.md' } else { 'Antigravity/.agents/rules/00_core_identity.md' }
            $source = Read-VNextSource $corePath
            $marker = [regex]::Match($source, '(?s)<!-- AI_RULES_SHARED_SUBAGENT_POLICY_START -->(.*?)<!-- AI_RULES_SHARED_SUBAGENT_POLICY_END -->')
            $expected = Get-SharedPolicyBlock -PolicyPath (Join-Path $repoRoot ('Shared/policies/adapters/' + $platform.ToLowerInvariant() + '-subagent-invocation.md')) -Platform $platform
            Get-VNextTextHash $marker.Groups[1].Value | Should Be (Get-VNextTextHash $expected)
        }
    }
}
