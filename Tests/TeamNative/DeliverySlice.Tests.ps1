$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$core = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\team-native-core.md') -Raw
$deliverySlice = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\references\team-native-core-delivery-slice.md') -Raw
$orchestration = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\workflow-orchestration.md') -Raw
$authorization = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\authorization-resolution.md') -Raw
$roleBoundaries = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\skills\team-role-boundaries\SKILL.md') -Raw
$lane = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\references\workflow-lane-routing.md') -Raw
$procedures = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\workflow-stage-procedures.md') -Raw
$matrix = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\workflow-capability-evidence-matrix.md') -Raw

Describe 'Team-Native delivery slice contract' {
    It 'requires a requirement-contract reference without defining its fields' {
        $orchestration | Should Match 'must\s+reference\s+a\s+requirement\s+contract'
        $authorization | Should Match 'does\s+not\s+define\s+or\s+duplicate\s+the\s+requirement\s+contract'
        $procedures | Should Match 'do\s+not\s+reproduce\s+that\s+contract'
    }

    It 'keeps primary roles isolated inside the complete fixed roster' {
        $core | Should Match 'team-native-core-delivery-slice\.md'
        $deliverySlice | Should Match 'three\s+role-distinct\s+primary\s+stations'
        $deliverySlice | Should Match '(?s)validation.*may\s+not\s+write,\s+repair,\s+or\s+review'
        $deliverySlice | Should Match '(?s)review.*may\s+not\s+write,\s+repair,\s+or\s+validate'
        $lane | Should Match 'cannot\s+merge\s+implementation,\s+validation,\s+and\s+review'
        $deliverySlice | Should Match 'five\s+role-distinct\s+fixed\s+roster\s+stations\s+and\s+members'
        $deliverySlice | Should Match '`memory-closure`'
        $deliverySlice | Should Match '`completion`'
        $roleBoundaries | Should Match '(?s)fixed slice roster has distinct implementation, validation,\s*review, memory-closure, and completion members/role instances'
    }

    It 'keeps the first two same-symptom repairs in the original slice' {
        $orchestration | Should Match '(?s)first\s+two\s+acceptance-required\s+repairs.*same\s+slice'
        $authorization | Should Match 'They\s+reuse\s+the\s+current\s+resolved\s+authorization'
        $matrix | Should Match 'first\s+two\s+same-symptom\s+restore/resume-and-rerun\s+cycles'
    }

    It 'keeps third-symptom diagnosis or module split in the original slice' {
        $deliverySlice | Should Match 'third\s+same-symptom\s+diagnosis\s+or\s+module-split\s+route\s+also\s+remains\s+there'
        $procedures | Should Match 'third\s+same-symptom\s+route\s+adds\s+diagnosis\s+or\s+module'
    }

    It 'opens a new slice only for the fixed boundary changes' {
        $orchestration | Should Match 'only\s+when\s+scope,\s+allowlist,\s+authorization,\s+acceptance,\s+risk,\s+public\s+contract,\s+or\s+protected\s+action\s+changes'
    }
}
