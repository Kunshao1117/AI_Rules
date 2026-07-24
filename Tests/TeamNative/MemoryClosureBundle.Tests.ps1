$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path

function Get-RequiredContent {
    param([Parameter(Mandatory = $true)][string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Expected canonical file is missing: $RelativePath"
    }

    Get-Content -LiteralPath $path -Raw
}

$bundle = Get-RequiredContent 'Shared\policies\references\memory-closure-bundle-contract.md'
$authorization = Get-RequiredContent 'Shared\policies\authorization-resolution.md'
$phaseRegistry = Get-RequiredContent 'Shared\policies\references\authorization-phase-registry.md'
$protectedActions = Get-RequiredContent 'Shared\policies\references\protected-action-registry.md'
$completionState = Get-RequiredContent 'Shared\policies\references\completion-state-machine.md'
$roleBoundaries = Get-RequiredContent 'Shared\skills\team-role-boundaries\SKILL.md'
$memoryOps = Get-RequiredContent 'Shared\skills\memory-ops\SKILL.md'
$memoryClosure = Get-RequiredContent 'Shared\skills\team-specialist-memory-closure\SKILL.md'
$closureArtifact = Get-RequiredContent 'Shared\skills\team-memory-closure-delivery-artifact\SKILL.md'
$boardSlice = Get-RequiredContent 'Shared\skills\team-task-board\references\board-field-slice-and-roles.md'
$packet = Get-RequiredContent 'Shared\skills\team-station-handoff-packet\references\packet-schema-and-routing.md'
$workflowMemoryEvidence = Get-RequiredContent 'Shared\policies\references\workflow-memory-evidence.md'
$stageProcedures = Get-RequiredContent 'Shared\workflow-stage-procedures.md'
$teamGovernance = Get-RequiredContent 'Shared\skills\programming-team-governance\SKILL.md'
$teamTraceEvidence = Get-RequiredContent 'Shared\policies\team-trace-evidence.md'
$teamTraceFields = Get-RequiredContent 'Shared\policies\references\team-trace-fields.md'

Describe 'Memory closure bundle contract' {
    It 'defaults to process-complete and permits source-level only by explicit exception' {
        $bundle | Should Match 'A new formal source route defaults to `process-complete`'
        $bundle | Should Match '(?s)source-level.*only when.*source-level-explicit'
        $completionState | Should Match '(?s)New formal source work selects `process-complete` by default.*source-level-explicit'
    }

    It 'binds three independent memory phases without phase carryover' {
        $bundle | Should Match 'memory_docs:'
        $bundle | Should Match 'protected_memory_write:'
        $bundle | Should Match 'protected_memory_commit:'
        $bundle | Should Match 'No candidate derives from\s+`implementation-change-delivery`'
        $phaseRegistry | Should Match 'Authorization never carries from one phase to another'
        $phaseRegistry | Should Match '(?s)separate phase bindings.*not carryover from\s+`implementation-change-delivery`'
    }

    It 'limits candidate mapping to existing owners and prohibits topology context Git and deployment carryover' {
        $bundle | Should Match '(?s)existing_owner_scope_ref.*already exist.*initial agreement.*resource scope'
        $bundle | Should Match '(?s)cannot create a card.*replace an owner.*widen from a card'
        $bundle | Should Match 'resource outside `existing_owner_scope_ref`'
        $bundle | Should Match '(?s)must not:.*source writes.*validation.*review.*completion.*Git.*deployment'
        $protectedActions | Should Match '(?s)Memory card or project context write.*protected-memory-write'
        $protectedActions | Should Match '(?s)Git mutation.*`git`'
        $protectedActions | Should Match '(?s)Deployment mutation.*`deployment`'
    }

    It 'keeps a fixed five-entry roster where reserved standby and resume are not replacements' {
        $roleBoundaries | Should Match '(?s)five independent roster entries: implementation,\s*validation, review, memory-closure, and completion'
        $roleBoundaries | Should Match '(?s)Reserved is a pre-assigned roster state, not a new slice, repair station, or\s*member replacement'
        $roleBoundaries | Should Match '(?s)After every active round, a roster entry becomes standby'
        $roleBoundaries | Should Match '(?s)Timeout, probe, channel resume, and channel replacement affect only a channel'
        $roleBoundaries | Should Match '(?s)Only an\s*explicit captain member-replacement decision.*context-transfer evidence may change a fixed roster'
    }

    It 'requires current no-write or committed memory receipts and stales prior slice revisions' {
        $memoryOps | Should Match '`memory_no_write_receipt`'
        $memoryOps | Should Match '`memory_committed_receipt`'
        $memoryOps | Should Match 'distinct write and commit receipts'
        $memoryOps | Should Match '(?s)Missing MCP capability or receipt is `memory-unverified`\s*or `blocked`; it cannot be rendered as process-complete'
        $bundle | Should Match 'Each accepted repair that changes the same delivery slice increments it once'
        $bundle | Should Match 'stale-by-slice-revision'
        $bundle | Should Match 'The historical\s+receipt remains recorded'
        $bundle | Should Match 'it cannot support the current phase or closeout'
    }

    It 'keeps memory-closure separate from memory-docs and forbids source context and closeout work' {
        $memoryClosure | Should Match '(?s)It is not `memory-docs`.*distinct role instances and\s*execution channels'
        $closureArtifact | Should Match '(?s)memory-docs.*cannot be reused\s*as this role or channel'
        $memoryClosure | Should Match '(?s)Do not write source or project context.*final closeout'
        $closureArtifact | Should Match '(?s)Perform no source, project-context.*final-closeout action'
    }

    It 'keeps missing owner conflict compaction sensitive action and absent MCP receipt non-complete' {
        $bundle | Should Match '(?s)`memory-card-missing`, owner conflict, compaction need.*blocked or unverified'
        $memoryOps | Should Match '(?s)`memory-conflict-or-compaction-blocked`.*before writing'
        $protectedActions | Should Match '(?s)Credential or secret handling.*Explicit credential scope'
        $memoryOps | Should Match '(?s)Missing MCP capability or receipt is `memory-unverified`\s*or `blocked`'
        $completionState | Should Match '(?s)If any required component.*cannot be `complete`'
    }

    It 'does not retrospectively authorize legacy execution specs' {
        $bundle | Should Match '(?s)Existing and legacy execution specs do not acquire a bundle, candidate mapping,\s*or protected authority retrospectively'
        $completionState | Should Match '(?s)Existing or legacy execution specs are not\s*retrospectively given completion-bundle candidates, memory-phase authority, or\s*protected authorization'
    }

    It 'keeps completion-bundle schema ownership and candidate mapping canonical' {
        $bundle | Should Match '(?i)sole owner of the `completion_bundle` schema'
        $bundle | Should Match '(?m)^\s*candidate_phase_map\s*:'

        $consumerReference = '(?i)memory-closure-bundle-contract\.md|completion_bundle_ref'
        $consumerSchemaDeclaration = '(?m)^\s*completion_bundle\s*:\s*\{'
        $candidateMapDeclaration = '(?m)^\s*candidate_phase_map\s*:'
        $protectedPhaseDeclaration = '(?m)^\s*protected_memory_(write|commit)\s*:'

        foreach ($consumer in @($boardSlice, $packet, $workflowMemoryEvidence, $stageProcedures)) {
            $consumer | Should Match $consumerReference
            $consumer | Should Not Match '(?i)sole owner of the `completion_bundle` schema'
            $consumer | Should Not Match $consumerSchemaDeclaration
            $consumer | Should Not Match $candidateMapDeclaration
            $consumer | Should Not Match $protectedPhaseDeclaration
        }
    }

    It 'keeps bundle transport separate from phase-specific authorization binding' {
        $packet | Should Match 'completion_bundle_ref'
        $packet | Should Not Match '(?m)^\s*(authorization_binding_ref|candidate_binding|candidate_phase_map|canonical_phase_resolution_ref)\s*:'

        foreach ($bindingField in 'authorization_source', 'authorization_target', 'authorization_scope', 'authorization_phase', 'authorization_evidence', 'authorization_expiry', 'authorization_resolution_state') {
            $authorization | Should Match ([regex]::Escape($bindingField))
        }
        $authorization | Should Match '(?i)scope-bound'

        $bundle | Should Match '(?m)^\s*candidate_phase_map\s*:'
        $bundle | Should Match '(?m)^\s*receipt_chain\s*:'
        $bundle | Should Match '(?m)^\s*candidate_state\s*'
        $bundle | Should Match '\beligible\b'
        $bundle | Should Not Match '(?m)^\s*(authorization_source|authorization_target|authorization_scope|authorization_phase|authorization_evidence|authorization_expiry|authorization_resolution_state|canonical_phase_resolution_ref)\s*:'
    }

    It 'keeps packet phase resolution canonical and separates primary from reserved roster roles' {
        $packet | Should Match 'completion_bundle_ref'
        $packet | Should Not Match '(?m)^\s*completion_bundle\s*:'
        $packet | Should Not Match '(?m)^\s*canonical_phase_resolution_ref\s*:'
        $packet | Should Not Match '(?m)^\s*(phase_resolution|candidate_phase_map|protected_memory_write|protected_memory_commit)\s*:'

        $primaryRoles = @('implementation', 'validation', 'review')
        $reservedRoles = @('memory-closure', 'completion')
        $allRosterRoles = @($primaryRoles + $reservedRoles)
        $roleOverlap = @($primaryRoles | Where-Object { $reservedRoles -contains $_ })

        $primaryRoles.Count | Should Be 3
        $reservedRoles.Count | Should Be 2
        $allRosterRoles.Count | Should Be 5
        $roleOverlap.Count | Should Be 0

        $fiveRoleSignal = '(?i)\b(?:five|5)(?:\s*-\s*|\s+)(?:role\s+|independent\s+)?(?:roster|station\s+rows?)\b'
        foreach ($rosterOwner in @($teamGovernance, $teamTraceEvidence, $teamTraceFields)) {
            foreach ($role in $allRosterRoles) {
                $rosterOwner | Should Match ([regex]::Escape($role))
            }
            $rosterOwner | Should Match '(?i)\bprimary\b'
            $rosterOwner | Should Match '(?i)\breserved\b'
            $rosterOwner | Should Match $fiveRoleSignal
        }

        foreach ($traceOwner in @($teamTraceEvidence, $teamTraceFields)) {
            $traceOwner | Should Not Match '(?i)\bthree(?:\s*-\s*|\s+)station(?:\s+rows?|\s+roster)?\b'
            $traceOwner | Should Not Match '(?i)\bthree\s+independent\s+station\s+rows?\b'
        }
    }
}
