Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
function Read-Source([string]$relativePath) {
    return Get-Content -LiteralPath (Join-Path $repoRoot $relativePath) -Raw -Encoding UTF8
}
function Assert-Meaning([string]$text, [string]$pattern, [string]$caseName) {
    if ($text -notmatch "(?is)$pattern") { throw "Missing source contract for: $caseName ($pattern)" }
}
function Assert-Concepts([string]$text, [string[]]$patterns, [string]$caseName) {
    foreach ($pattern in $patterns) { Assert-Meaning $text $pattern $caseName }
}

$grounding = Read-Source 'Shared/policies/grounding-governance.md'
$verification = Read-Source 'Shared/policies/verification-strategy.md'
$requirements = Read-Source 'Shared/policies/requirement-precision.md'
$authorization = Read-Source 'Shared/policies/authorization-resolution.md'
$completion = Read-Source 'Shared/policies/completion-policy.md'
$language = Read-Source 'Shared/policies/language-governance.md'
$humanExamples = Read-Source 'Shared/policies/references/user-facing-output-examples.md'
$truthFacts = Read-Source 'Shared/policies/references/status-ontology.md'
$judgment = ($grounding -split '## General Factual Judgment Boundary', 2)[1] -split '## Source Of Truth And Precedence', 2 | Select-Object -First 1
$tiers = ($grounding -split '## AI Prior And Grounding Tiers', 2)[1] -split '## Source Ranking', 2 | Select-Object -First 1

Describe 'Phase 5B2 factual judgment source contract' {
    It 'keeps one factual-grounding owner and the neighboring policy owners' {
        Assert-Meaning $grounding 'owner of general factual-judgment grounding' 'general owner'
        Assert-Concepts $grounding @('does not select verification scope', 'define requirements', 'authorize actions', 'decide task completion', 'Director-facing wording') 'owner boundaries'
        Assert-Meaning $verification 'single general owner of verification scope' 'verification owner'
        Assert-Meaning $requirements '(?s)canonical owner of.*requirement-precision semantics' 'requirement owner'
        Assert-Meaning $authorization 'semantic authorization owner' 'authorization owner'
        Assert-Meaning $completion 'sole owner of general vNext work completion' 'completion owner'
        Assert-Meaning $language 'universal source of truth for language selection' 'communication owner'
    }

    It 'allows ordinary concept explanation but not model recall as current proof' {
        Assert-Concepts $judgment @('Model-internal knowledge', 'not, by itself, evidence', 'current external', 'Model knowledge is not proof') 'model knowledge limit'
        Assert-Concepts $judgment @('stable concepts', 'Ordinary conceptual\s+explanations need no external search') 'proportionality'
    }

    It 'does not infer deployment from a user statement or a canonical requirement' {
        Assert-Concepts $judgment @('canonical governance source', 'specification', 'empirical question requiring current evidence') 'normative versus empirical'
        Assert-Concepts $judgment @('user.s direct account', 'not automatically proof', 'external or deployed') 'user evidence scope'
        Assert-Meaning $truthFacts 'deployed \| Actual application to the named runtime/environment' 'deployment evidence'
    }

    It 'bounds Memory and documentation against more direct current source evidence' {
        Assert-Concepts $judgment @('Source labels alone do not confer empirical truth', 'Memory', 'project context', 'README/docs', 'newer or more direct current evidence') 'memory and docs boundary'
    }

    It 'treats a database completed flag and passing tests as scoped evidence' {
        Assert-Concepts $judgment @('status = completed', 'database currently records', 'not that the underlying work satisfies') 'database flag'
        Assert-Concepts $judgment @('test supports only', 'environment', 'conditions it actually covered') 'test coverage'
    }

    It 'uses contextual evidence factors without a universal score or rank' {
        Assert-Concepts $judgment @('directness', 'recency', 'applicable scope', 'verifiability') 'four evidence factors'
        Assert-Meaning $grounding 'not a universal ranking or numerical score' 'no universal scoring'
        Assert-Concepts $grounding @('local version', 'runtime evidence more probative') 'version-specific local evidence'
    }

    It 'preserves unresolved reliable conflicts instead of choosing a convenient answer' {
        Assert-Concepts $judgment @('credible evidence conflicts', 'time, environment, scope, or version', 'preserve the conflict or uncertainty', 'Do not select a convenient side') 'conflict resolution'
    }

    It 'lowers claim strength when the user forbids needed browsing or access' {
        Assert-Concepts $judgment @('may constrain scope', 'browsing', 'excluded or unavailable', 'lower the conclusion.s strength', 'Do not fill it with model recall') 'user constraints'
    }

    It 'keeps hypothetical and advocacy material separate from verified facts' {
        Assert-Concepts $judgment @('Hypotheses', 'requested advocacy', 'do not become verified facts') 'hypothesis boundary'
    }

    It 'does not hide a required failure behind user-defined acceptance' {
        Assert-Concepts $judgment @('User-defined acceptance', 'does not erase underlying factual failures') 'acceptance versus actual failure'
        Assert-Concepts $completion @('Risk acceptance cannot', 'supply evidence') 'completion evidence remains separate'
    }

    It 'lets better evidence revise a prior AI conclusion' {
        Assert-Concepts $judgment @('Earlier assistant conclusions', 'revisable', 'better relevant evidence') 'prior answer revision'
    }

    It 'does not require disagreement, Team, or Reviewer for ordinary work' {
        Assert-Concepts $judgment @('neither agrees with nor opposes', 'consequential decisions', 'contradictory evidence', 'do not impose a Team, Reviewer') 'proportionate challenge'
    }

    It 'keeps G3 evidence depth independent of legacy Team station machinery' {
        Assert-Concepts $tiers @('G3.*formal external research', 'G3.*record dated sources', 'G3.*not a Team or station', 'Main may gather it directly', 'Legacy Team.*artifact ID') 'G3 ownership'
        if ($tiers -match 'station-owned external research') { throw 'G3 still asserts general station ownership' }
    }

    It 'expresses likelihood and conflict for people without changing machine states' {
        Assert-Meaning $humanExamples '高度可能，但尚未確認' 'human likelihood example'
        Assert-Meaning $humanExamples '證據仍互相矛盾' 'human conflict example'
        Assert-Meaning $humanExamples '不要把「高度可能」寫回機器狀態' 'machine state boundary'
        Assert-Meaning $language 'Director-facing reports.*begin with Traditional Chinese meaning' 'human communication owner'
    }
}
