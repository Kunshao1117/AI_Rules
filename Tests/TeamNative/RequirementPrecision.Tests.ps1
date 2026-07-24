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

$policy = Get-RequiredContent 'Shared/policies/requirement-precision.md'
$schema = Get-RequiredContent 'Shared/policies/references/requirement-precision-schema.md'
$executionSpec = Get-RequiredContent 'Shared/policies/references/workflow-execution-spec-contract.md'
$intentSkill = Get-RequiredContent 'Shared/skills/intent-alignment-gate/SKILL.md'

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
Assert-Contains -Content $executionSpec -Expected '`requirement-precision.md`; this execution contract does not redefine them.' -Label 'Workflow execution spec'

Assert-Contains -Content $intentSkill -Expected 'Shared/policies/requirement-precision.md' -Label 'Intent alignment skill'
Assert-Contains -Content $intentSkill -Expected 'Shared/policies/references/requirement-precision-schema.md' -Label 'Intent alignment skill'
Assert-NotContains -Content $intentSkill -Unexpected '- Goal: what outcome the Director is trying to achieve.' -Label 'Intent alignment skill'
Assert-NotContains -Content $intentSkill -Unexpected '| Requirement | Source | Plan or task | Acceptance evidence | Status |' -Label 'Intent alignment skill'

Write-Output 'Requirement precision contract tests passed.'
