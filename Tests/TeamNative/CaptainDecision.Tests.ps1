$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$core = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\team-native-core.md') -Raw
$deliverySlice = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\references\team-native-core-delivery-slice.md') -Raw
$orchestration = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\workflow-orchestration.md') -Raw
$authorization = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\policies\authorization-resolution.md') -Raw
$boardSlice = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\skills\team-task-board\references\board-field-slice-and-roles.md') -Raw
$packet = Get-Content -LiteralPath (Join-Path $repoRoot 'Shared\skills\team-station-handoff-packet\references\packet-schema-and-routing.md') -Raw

Describe 'Captain delivery-slice decisions' {
    It 'assigns the captain route decisions without assigning station work' {
        $core | Should Match 'team-native-core-delivery-slice\.md'
        $deliverySlice | Should Match 'captain\s+records\s+it\s+and\s+selects\s+the\s+route'
        foreach ($decision in 'continue', 'repair', 'rerun', 'diagnose', 'replace', 'escalate') {
            $deliverySlice | Should Match ('\| `{0}` \|' -f $decision)
        }
    }

    It 'restores the original implementation member instead of creating a repair station' {
        $deliverySlice | Should Match '(?s)restore/resume.*original\s+implementation\s+member'
        $deliverySlice | Should Match 'not\s+a\s+new\s+station\s+or\s+member'
        $orchestration | Should Match 'does\s+not\s+create\s+an\s+automatic\s+repair\s+station\s+or\s+member'
    }

    It 'retains slice members on standby until slice acceptance closes them' {
        $deliverySlice | Should Match '(?s)retain\s+their\s+original\s+`role_instance_id`,\s+context,\s+handoff\s+packet,\s+and\s+member\s+identity'
        foreach ($primaryRole in 'implementation', 'validation', 'review') {
            $deliverySlice | Should Match $primaryRole
        }
        $deliverySlice | Should Match 'standby'
        foreach ($rosterRole in 'implementation', 'validation', 'review', 'memory-closure', 'completion') {
            $boardSlice | Should Match $rosterRole
        }
        $boardSlice | Should Match 'fixed\s+roster'
        $boardSlice | Should Match 'whole-slice\s+acceptance'
        $packet | Should Match 'whole-slice\s+acceptance'
    }

    It 'returns third-symptom diagnosis or module-split output to the original implementation member' {
        $deliverySlice | Should Match '(?s)third\s+same-symptom.*output\s+to\s+the\s+original\s+implementation\s+member'
    }

    It 'limits replacement to an explicit decision with a reason and context transfer' {
        $deliverySlice | Should Match 'only\s+through\s+an\s+explicit\s+captain\s+decision'
        $deliverySlice | Should Match '`replacement_reason`,\s+context\s+transfer'
        $authorization | Should Match 'only\s+an\s+explicit\s+captain\s+`replace`\s+decision'
    }
}
