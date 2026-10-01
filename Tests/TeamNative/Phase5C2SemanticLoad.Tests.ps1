Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
function Read-Phase5C2([string]$relativePath) {
    Get-Content -LiteralPath (Join-Path $repoRoot $relativePath) -Raw -Encoding UTF8
}

$globalClaude = Read-Phase5C2 'Claude/global/CLAUDE.md'
$claudeEntry = Read-Phase5C2 'Claude/.claude/CLAUDE.md'
$implementer = Read-Phase5C2 'Shared/agents/implementer.md'
$reviewer = Read-Phase5C2 'Shared/agents/reviewer.md'
$claudeAdapter = Read-Phase5C2 'Shared/policies/adapters/claude-subagent-invocation.md'
$antigravityQuality = Read-Phase5C2 'Antigravity/.agents/rules/02_code_quality_security.md'
$load = Read-Phase5C2 'Shared/policies/load-semantics.md'

Describe 'Phase 5C2 semantic ownership and actual load surfaces' {
    It 'keeps implementation conditional without a global Claude no-write override' {
        $globalClaude | Should Not Match 'FORBIDDEN from modifying source files|All proposed code changes MUST be returned as text'
        $globalClaude | Should Match 'selected Shared Agent'
        $implementer | Should Match 'Only authorized local_work in the exact source allowlist'
        $implementer | Should Match 'source_edit'
        $claudeAdapter | Should Match 'Conditional Implementer permits bounded Bash/Edit/Write under parent permissions'
        (Read-Phase5C2 'Shared/policies/authorization-resolution.md') | Should Match 'semantic authorization owner'
    }

    It 'does not turn read-only reviewers into implementers' {
        $reviewer | Should Match 'No source writes or repairs'
        $reviewerProjection = Read-Phase5C2 'Claude/.claude/agents/ai-rules-reviewer.md'
        $reviewerProjection | Should Match 'disallowedTools: \["Edit", "Write"\]'
        $reviewerProjection | Should Not Match '(?m)^tools: \[[^\]]*"Edit"'
        $globalClaude | Should Match '(?s)grants neither a\s+blanket read-only restriction nor general write permission'
    }

    It 'uses real Claude discovery semantics rather than task-shaped path globs' {
        $claudeEntry | Should Not Match '@\.claude/rules/'
        $claudeEntry | Should Match '沒有 `paths` 限定的規則'
        $claudeEntry | Should Match '`paths` 只按讀取檔案路徑觸發'
        $claudeEntry | Should Match '使用者也可用斜線指令明確呼叫'
        foreach ($name in @('core-identity.md','cross-lingual-guard.md','memory-contract.md','mcp-guardrails.md','project-skill-contract.md')) {
            Test-Path -LiteralPath (Join-Path $repoRoot "Claude/.claude/rules/$name") | Should Be $true
        }
        foreach ($name in @('code-quality.md','forbidden-vocab.md')) {
            Test-Path -LiteralPath (Join-Path $repoRoot "Claude/.claude/rules/$name") | Should Be $false
            Test-Path -LiteralPath (Join-Path $repoRoot "Shared/policies/references/claude-legacy-rules/$name") | Should Be $true
            $claudeEntry | Should Match "claude-legacy-rules/$name"
        }
        $claudeEntry | Should Not Match '關鍵閘門速覽|\[LINTER GATE\]|程式碼驗證連續失敗三次'
        $claudeEntry | Should Match 'project-skill-contract.md.*已常駐'
    }

    It 'keeps task references out of automatic rule loading and follows the current M5A Memory route' {
        $claudeEntry | Should Match '按需參考'
        $claudeEntry | Should Match 'rules/memory-contract.md.*按需載入 `memory-ops`'
        (Read-Phase5C2 'Claude/.claude/rules/cross-lingual-guard.md') | Should Match 'Memory Path Boundary'
        (Read-Phase5C2 'Claude/.claude/rules/memory-contract.md') | Should Match 'Do not call `memory_list`.*every conversation start'
        $claudeEntry | Should Match 'session-checkpoint-recovery.md'
        $projectSkillRule = Read-Phase5C2 'Claude/.claude/rules/project-skill-contract.md'
        $projectSkillRule | Should Match 'memory_awareness: none\|read\|full'
        $projectSkillRule | Should Match 'Shared/skills/skill-factory/SKILL.md'
        $projectSkillRule | Should Not Match '\[PROJECT SKILL GATE\]|requires the Writer role|Role Lock Gate'
    }

    It 'leaves Antigravity quality choices project-derived and owner-linked' {
        $antigravityQuality | Should Match 'project.s actual language, configuration and checks'
        $antigravityQuality | Should Match 'Shared/policies/code-quality.md'
        $antigravityQuality | Should Match 'Shared/policies/verification-strategy.md'
        $antigravityQuality | Should Match 'Shared/policies/authorization-resolution.md'
        $antigravityQuality | Should Not Match 'process\.env|\.env\.example|Zod|所有 coding workflows|永遠啟用|Max 3 retries'
    }

    It 'has one thin load contract independent of canonical type and platform format' {
        foreach ($mode in @('CORE_ALWAYS_ON','SCOPED_CONDITIONAL','DISCOVERABLE_ON_DEMAND','DELEGATED_ISOLATED','LAZY_REFERENCE')) {
            $load | Should Match $mode
        }
        $load | Should Match '(?s)Policy does not mean\s+always-on'
        $load | Should Match 'full body only when selected'
        $load | Should Match 'full Agent contract for the assigned worker'
        $load | Should Match 'Do not inject the full Reference at startup'
        $load | Should Match 'derived delivery content'
        $load | Should Match 'multiple always-on surfaces'
        $load | Should Match '(?s)not authorization.*second content registry'
        $load | Should Match '(?s)adds no loader,\s+context score, registry'
    }

    It 'projects lazy references through the existing Shared reference path' {
        Import-Module (Join-Path $repoRoot 'Scripts/modules/Skills-Sync.psm1') -Force
        $paths = @(Get-SharedGovernanceReferenceRelativePaths -SharedRoot (Join-Path $repoRoot 'Shared'))
        foreach ($name in @('code-quality.md','forbidden-vocab.md')) {
            @($paths | Where-Object { ($_ -replace '\\','/') -eq "policies/references/claude-legacy-rules/$name" }).Count | Should Be 1
        }
    }
}
