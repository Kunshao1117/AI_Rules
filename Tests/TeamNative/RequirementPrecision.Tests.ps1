Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Get-RequiredContent {
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Expected canonical file is missing: $RelativePath"
    }

    return Get-Content -LiteralPath $path -Raw
}

function Assert-Contains {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Expected,
        [Parameter(Mandatory)][string]$Label
    )

    if (-not $Content.Contains($Expected)) {
        throw "$Label must contain '$Expected'."
    }
}

function Assert-NotContains {
    param(
        [Parameter(Mandatory)][string]$Content,
        [Parameter(Mandatory)][string]$Unexpected,
        [Parameter(Mandatory)][string]$Label
    )

    if ($Content.Contains($Unexpected)) {
        throw "$Label must not declare duplicate content '$Unexpected'."
    }
}

function Normalize-Whitespace {
    param([Parameter(Mandatory)][string]$Content)

    return (($Content -replace '\s+', ' ').Trim())
}

$policy = Get-RequiredContent 'Shared/policies/requirement-precision.md'
$schema = Get-RequiredContent 'Shared/policies/references/requirement-precision-schema.md'
$executionSpec = Get-RequiredContent 'Shared/policies/references/workflow-execution-spec-contract.md'
$intentSkill = Get-RequiredContent 'Shared/skills/intent-alignment-gate/SKILL.md'
$orchestration = Get-RequiredContent 'Shared/policies/workflow-orchestration.md'
$normalizedPolicy = Normalize-Whitespace -Content $policy
$normalizedExecutionSpec = Normalize-Whitespace -Content $executionSpec
$normalizedOverreach = Normalize-Whitespace -Content ($executionSpec + $orchestration)
$normalizedIntentSkill = Normalize-Whitespace -Content $intentSkill

foreach ($requiredPolicyRule in @(
        '## Precision Gate',
        '### No Guessing',
        '### Mandatory Question Conditions',
        '## Trace Integrity',
        'assumption_trace',
        'question_trace',
        'acceptance_trace'
    )) {
    Assert-Contains -Content $policy -Expected $requiredPolicyRule -Label 'Requirement precision policy'
}

foreach ($requiredField in @(
        'requirement_id',
        'outcome',
        'applicability_conditions',
        'scope',
        'non_goals',
        'acceptance_evidence',
        'priority',
        'verification_status',
        'assumption_trace',
        'question_trace',
        'acceptance_trace'
    )) {
    Assert-Contains -Content $schema -Expected $requiredField -Label 'Requirement precision schema'
}

Assert-Contains -Content $executionSpec -Expected 'Requirement precision schema:' -Label 'Workflow execution spec'
Assert-Contains -Content $executionSpec -Expected '`requirement_precision`' -Label 'Workflow execution spec'
Assert-Contains -Content $normalizedPolicy -Expected 'Every material assertion is classified as `explicit`, `inferred`, `unknown`, or `conflict`.' -Label 'Requirement precision policy'
Assert-Contains -Content $normalizedExecutionSpec -Expected 'Its field catalog, no-guessing gate, mandatory question conditions, and trace semantics are consumed from `requirement-precision.md`; this execution contract does not redefine them.' -Label 'Workflow execution spec'

foreach ($requiredScopeRule in @(
        '### Product Decision Boundary',
        'Users decide the product goal, observable behavior, and policies.',
        'Suggestions, best practices, risk findings, and possible future needs',
        '`explicit-scope`',
        '`minimal-implementation-detail`',
        '`approval-required-expansion`',
        '`suggestion-only`',
        'Classification describes only the nature of the proposed content.',
        'result` and `next_action` remain independent dispositions',
        'independently managed subsystem or significant internal state',
        'hidden retry, background work, cache, queue, or schedule',
        'execution paths, failure modes, or debugging difficulty',
        'general abstraction for future needs',
        'explicit acceptance condition, an existing public contract, or confirmed existing normal behavior fail',
        'Missing completeness, professionalism, best practice, or future convenience is not necessity.',
        'It does not block authorized work or request a decision by default',
        'current explicit result depends on that decision',
        'stop only the affected action and continue other authorized work',
        'All conditions are required.',
        'never constitute implementation authorization',
        'A risk finding never authorizes a new product feature',
        'law or platform hard limits, authorization boundaries, evidence honesty, worktree protection, protected-action gates, or non-negotiable safety conditions',
        'Default maturity is a working, understandable, verifiable minimum version',
        'requires the corresponding concrete scope to be defined',
        'Do not ask a non-engineer to choose a framework, design pattern, data structure'
    )) {
    Assert-Contains -Content $normalizedPolicy -Expected $requiredScopeRule -Label 'Requirement precision scope ceiling'
}

foreach ($requiredOverreachRule in @(
        '`classification`',
        'Exactly one of `explicit-scope`, `minimal-implementation-detail`,',
        '`approval-required-expansion`, or `suggestion-only`',
        'Classification describes content only.',
        'result` and `next_action` remain independent dispositions',
        'A category never',
        'creates authorization'
    )) {
    Assert-Contains -Content $normalizedOverreach -Expected $requiredOverreachRule -Label 'Existing overreach check'
}

Assert-Contains -Content $intentSkill -Expected 'Shared/policies/requirement-precision.md' -Label 'Intent alignment skill'
Assert-Contains -Content $intentSkill -Expected 'Shared/policies/references/requirement-precision-schema.md' -Label 'Intent alignment skill'
Assert-Contains -Content $intentSkill -Expected '### 1.1 Product Decision Boundary And Overreach Classification' -Label 'Intent alignment skill'
Assert-Contains -Content $normalizedIntentSkill -Expected 'Classification describes content only' -Label 'Intent alignment skill'
Assert-Contains -Content $normalizedIntentSkill -Expected 'does not block or ask by default' -Label 'Intent alignment skill'
Assert-Contains -Content $normalizedIntentSkill -Expected 'stop only the affected action while other authorized work continues' -Label 'Intent alignment skill'
Assert-Contains -Content $normalizedIntentSkill -Expected 'A material risk finding is a reason to stop or ask about the affected action' -Label 'Intent alignment skill'
Assert-NotContains -Content $intentSkill -Unexpected '- Goal: what outcome the Director is trying to achieve.' -Label 'Intent alignment skill'
Assert-NotContains -Content $intentSkill -Unexpected '| Requirement | Source | Plan or task | Acceptance evidence | Status |' -Label 'Intent alignment skill'

Write-Output 'Requirement precision contract tests passed.'
