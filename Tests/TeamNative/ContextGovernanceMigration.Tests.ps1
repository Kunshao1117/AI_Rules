$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Get-CanonicalText {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    Get-Content -LiteralPath (Join-Path $repoRoot $RelativePath) -Raw
}

Describe 'Context governance migration' {
    BeforeAll {
        $script:boardSlice = Get-CanonicalText 'Shared\skills\team-task-board\references\board-field-slice-and-roles.md'
        $script:boardCatalog = Get-CanonicalText 'Shared\skills\team-task-board\references\board-field-catalog.md'
        $script:packet = Get-CanonicalText 'Shared\skills\team-station-handoff-packet\references\packet-schema-and-routing.md'
        $script:executionSpec = Get-CanonicalText 'Shared\policies\references\workflow-execution-spec-contract.md'
        $script:trace = Get-CanonicalText 'Shared\policies\team-trace-evidence.md'
        $script:core = Get-CanonicalText 'Shared\policies\team-native-core.md'
        $script:captainBoundary = Get-CanonicalText 'Shared\policies\references\team-native-core-captain-boundary.md'
        $script:deliverySlice = Get-CanonicalText 'Shared\policies\references\team-native-core-delivery-slice.md'
        $script:roleBoundaries = Get-CanonicalText 'Shared\skills\team-role-boundaries\SKILL.md'
    }

    It 'keeps reserved responsibility slots unbound until their activation condition is met' {
        $boardSlice | Should Match '(?is)reserved.*need not.*member assignment.*handoff packet.*live context'
        $boardSlice | Should Match '(?is)activation condition.*only then.*role instance.*handoff packet.*context scope.*channel'
        $trace | Should Match '(?is)reserved slot.*no live member.*context.*packet'
    }

    It 'binds every activated role instance while preserving role independence' {
        $boardSlice | Should Match '(?is)activation condition.*role instance.*handoff packet.*context scope.*channel'
        $boardSlice | Should Match '(?is)implementation station.*repairs only.*cited finding'
        $boardSlice | Should Match '(?is)original validation and review stations run independently'
        $roleBoundaries | Should Match '(?is)validation checks without repairing'
        $roleBoundaries | Should Match '(?is)review judges without authoring'
    }

    It 'allows captain reporting from evidence without allowing captain evidence authoring' {
        $core | Should Match '(?is)may synthesize and report.*completion state'
        $core | Should Match '(?is)not.*new completion evidence'
        $captainBoundary | Should Match '(?is)report.*completion state.*existing.*station artifacts'
        $captainBoundary | Should Match '(?is)must not.*produce.*replace.*upgrade.*station evidence'
    }

    It 'keeps minimal_reference_packet as the only station-to-captain reference packet' {
        $packet | Should Match '(?is)minimal_reference_packet.*only canonical.*station-to-captain'
        $packet | Should Match '(?is)do not create.*decision receipt'
        $executionSpec | Should Match '(?is)minimal_reference_packet.*only canonical.*station-to-captain'
    }

    It 'separates requested scope from observed context-delivery evidence' {
        $boardCatalog | Should Match '(?is)context_visibility.*read.*visibility.*not.*isolation'
        $packet | Should Match '(?is)context_scope_ref.*requested.*sealed.*scope'
        $packet | Should Match '(?is)observed context.*must not.*context_scope_ref'
        $trace | Should Match '(?is)context delivery evidence.*locally-verified.*officially-documented-unverified.*known-inherited-or-shared.*unknown'
    }

    It 'requires version-bound evidence for committed and dirty source states' {
        $executionSpec | Should Match '(?is)committed.*immutable revision'
        $executionSpec | Should Match '(?is)uncommitted.*base HEAD.*relevant paths.*worktree.*index.*diff fingerprint'
        $packet | Should Match '(?is)delivery artifact revision'
        $packet | Should Match '(?is)path.*line.*not.*sufficient'
    }

    It 'removes reflection skills and all formal canonical references' {
        foreach ($relativePath in @(
            'Shared\skills\coding-reflection-gate\SKILL.md',
            'Shared\skills\design-reflection-gate\SKILL.md',
            '.agents\skills\coding-reflection-gate\SKILL.md',
            '.agents\skills\design-reflection-gate\SKILL.md',
            '.claude\skills\coding-reflection-gate\SKILL.md',
            '.claude\skills\design-reflection-gate\SKILL.md'
        )) {
            (Test-Path -LiteralPath (Join-Path $repoRoot $relativePath)) | Should Be $false
        }

        foreach ($relativePath in @(
            'Shared\policies\references\workflow-execution-spec-contract.md',
            'Shared\policies\workflow-orchestration.md',
            'Shared\skills\_index.md',
            'Shared\skills\ai-dev-quality-gate\SKILL.md',
            'Shared\skills\intent-alignment-gate\SKILL.md',
            'Shared\skills\structured-reasoning\SKILL.md',
            'Shared\workflow-capability-evidence-matrix.md',
            'Shared\workflow-stage-procedures.md',
            'Codex\.agents\workflow-skills\03-build-建構\SKILL.md',
            'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md',
            'Codex\.agents\workflow-skills\07-debug-除錯\SKILL.md'
        )) {
            $content = Get-CanonicalText $relativePath
            $content | Should Not Match 'coding-reflection-gate|design-reflection-gate|coding reflection|design reflection'
        }
    }

    It 'keeps changed canonical owners byte-identical to managed runtime copies' {
        $pairs = @(
            @{ Source = 'Shared\skills\team-task-board\references\board-field-slice-and-roles.md'; Runtime = '.agents\skills\team-task-board\references\board-field-slice-and-roles.md' },
            @{ Source = 'Shared\skills\team-task-board\references\board-field-catalog.md'; Runtime = '.agents\skills\team-task-board\references\board-field-catalog.md' },
            @{ Source = 'Shared\skills\team-station-handoff-packet\references\packet-schema-and-routing.md'; Runtime = '.agents\skills\team-station-handoff-packet\references\packet-schema-and-routing.md' },
            @{ Source = 'Shared\skills\team-station-handoff-packet\SKILL.md'; Runtime = '.agents\skills\team-station-handoff-packet\SKILL.md' },
            @{ Source = 'Shared\policies\references\workflow-execution-spec-contract.md'; Runtime = '.agents\shared\policies\references\workflow-execution-spec-contract.md' },
            @{ Source = 'Shared\policies\references\team-trace-fields.md'; Runtime = '.agents\shared\policies\references\team-trace-fields.md' },
            @{ Source = 'Shared\policies\team-trace-evidence.md'; Runtime = '.agents\shared\policies\team-trace-evidence.md' },
            @{ Source = 'Shared\policies\team-native-core.md'; Runtime = '.agents\shared\policies\team-native-core.md' },
            @{ Source = 'Shared\policies\references\team-native-core-captain-boundary.md'; Runtime = '.agents\shared\policies\references\team-native-core-captain-boundary.md' },
            @{ Source = 'Shared\policies\references\team-native-core-delivery-slice.md'; Runtime = '.agents\shared\policies\references\team-native-core-delivery-slice.md' },
            @{ Source = 'Shared\policies\workflow-orchestration.md'; Runtime = '.agents\shared\policies\workflow-orchestration.md' },
            @{ Source = 'Shared\workflow-capability-evidence-matrix.md'; Runtime = '.agents\shared\workflow-capability-evidence-matrix.md' },
            @{ Source = 'Shared\workflow-stage-procedures.md'; Runtime = '.agents\shared\workflow-stage-procedures.md' },
            @{ Source = 'Shared\skills\_index.md'; Runtime = '.agents\skills\_index.md' },
            @{ Source = 'Shared\skills\ai-dev-quality-gate\SKILL.md'; Runtime = '.agents\skills\ai-dev-quality-gate\SKILL.md' },
            @{ Source = 'Shared\skills\programming-team-governance\SKILL.md'; Runtime = '.agents\skills\programming-team-governance\SKILL.md' },
            @{ Source = 'Shared\skills\intent-alignment-gate\SKILL.md'; Runtime = '.agents\skills\intent-alignment-gate\SKILL.md' },
            @{ Source = 'Shared\skills\structured-reasoning\SKILL.md'; Runtime = '.agents\skills\structured-reasoning\SKILL.md' },
            @{ Source = 'Shared\skills\team-role-boundaries\SKILL.md'; Runtime = '.agents\skills\team-role-boundaries\SKILL.md' },
            @{ Source = 'Codex\.agents\workflow-skills\03-build-建構\SKILL.md'; Runtime = '.agents\skills\03-build-建構\SKILL.md' },
            @{ Source = 'Codex\.agents\workflow-skills\04-fix-修復\SKILL.md'; Runtime = '.agents\skills\04-fix-修復\SKILL.md' },
            @{ Source = 'Codex\.agents\workflow-skills\07-debug-除錯\SKILL.md'; Runtime = '.agents\skills\07-debug-除錯\SKILL.md' },
            @{ Source = 'Codex\.codex\AGENTS.md'; Runtime = '.codex\AGENTS.md' }
        )

        foreach ($pair in $pairs) {
            $sourcePath = Join-Path $repoRoot $pair.Source
            $runtimePath = Join-Path $repoRoot $pair.Runtime
            (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash | Should Be (Get-FileHash -LiteralPath $runtimePath -Algorithm SHA256).Hash
        }
    }
}
