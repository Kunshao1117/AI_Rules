# Team Task Board Field Catalog

This is the compact board index for `team-task-board/SKILL.md`. It owns only
board-wide fields, generic values, provenance, and shared nested contracts.
The two focused references below are the sole owners of their respective field
and value sets.

## Canonical Board Fields

| Field family | Canonical owner |
|---|---|
| Board, authorization, wave, applicability, generic station, grounding, artifact, and closeout fields | This file |
| `delivery_slice`, roster, role, finding, repair, and member-replacement fields | `board-field-slice-and-roles.md` |
| Channel, lifecycle, wait, requested/accepted/applied receipt, and late-return fields | `board-field-channel-and-receipts.md` |

This file owns these board-wide names:

```text
board_id, board_template, board_state, task_type, workflow_route,
operation_mode, operation_mode_reason, closeout_lane, yellow_classification,
yellow_resolution_state, repair_loop_limit, phase, dispatch_wave,
parallel_dispatch_contract, previous_wave_input, next_wave_start_condition,
formal_evidence_eligibility, implementation_authorization, go_evidence,
authorization_source, authorization_target, authorization_scope,
authorization_phase, authorization_evidence, authorization_expiry,
authorization_resolution_state, platform_mode_observed,
platform_capability_route, station_family, formal_station, substation_task,
member_assignment, applicability, station_state, evidence_state,
station_lifecycle_state, station_mode, retention_reason, conversation_health,
reuse_count, handoff_summary, closure_reason, deep_read_scope,
captain_coordination_read_scope, context_visibility, unread_scope,
external_grounding_required, external_research_question,
external_research_artifact_id, external_grounding_state, source_tier,
source_date_or_version, missing_external_evidence, allowed_inputs, allowed_tools,
forbidden_actions, output_artifact_format, stop_condition, delivery_artifact_type,
delivery_artifact_id, delivery_artifact_status, author_role, source_input,
integrable_scope, validation_handoff, review_handoff, memory_docs_handoff,
review_state, validation_state, memory_docs_state, completion_condition,
completion_state, source_deployed_pair, sync_direction, sync_evidence,
git_checkpoint_receipt, captain_authored, direct_exception, replacement_evidence
```

Field names in the focused references remain canonical board names, even though
their values are not repeated here. Handoff packets and trace audits consume
these definitions and must not create competing value sets.

## Field Value Catalog

`board_state` is `draft`, `formal-readonly`, or `formal-write`. Legacy `formal`
must be narrowed before formal acceptance.

`station_state` is `assigned`, `standby`, `running`, `returned`, `blocked`,
`unverified`, `closed-with-director-risk`, or `not-applicable`. `standby` is
non-terminal and preserves the fixed slice roster.

`evidence_state` is `pending`, `returned`, `logged`, `routed-to-owner-station`,
`blocked`, `unverified`, `closed-with-director-risk`, or `not-applicable`.

`station_lifecycle_state` is a compatibility view: `assigned`, `standby`,
`retained`, `reused`, `handoff-required`, `closed`, `replaced`, `blocked`, or
`not-applicable`. Channel state is owned by the channel/receipt reference and
does not change this station lifecycle by itself.

`station_mode` is `read-only`, `change-delivery`, `change-application`,
`validation`, `review`, `memory-docs`, `completion`, `protected-gate`, or
`not-applicable`. `handoff_ownership` is `station-owned`,
`platform-nondelegable-gate`, `returned-to-captain`, `reassigned`, `blocked`,
`unverified`, or `not-applicable`.

`context_visibility` is `specialist-deep-read`, `captain-coordination-only`,
`shared-visible`, `unread`, or `not-applicable`. `external_grounding_required`
is `true`, `false`, or `unknown`; outcome belongs in
`external_grounding_state`, whose values are `not-required`, `required`,
`requested`, `sufficient`, `partial`, `no-evidence`, `conflicted`, `blocked`,
or `unverified`.

`delivery_artifact_status` is `pending`, `returned`, `logged`,
`applied-by-owner-station`, `blocked`, `unverified`,
`closed-with-director-risk`, or `not-applicable`. Implementation returns only
downstream handoff inputs; it never writes final validation, review, or
memory/docs state.

`review_state` is `not-started`, `pending`, `accepted`, `fix-required`,
`blocked`, `unverified`, `accepted-risk`, or `not-applicable`.
`validation_state` is `not-started`, `pending`, `passed`, `failed`, `blocked`,
`unverified`, or `not-applicable`. `memory_docs_state` is `not-started`,
`memory_delivery`, `blocked`, `unverified`, `closed-with-director-risk`, or
`not-applicable`. `completion_state` is `complete`,
`closed-with-director-risk`, `blocked`, `unverified`, or `not-applicable`.

`direct` is never a board state, station state, route, channel, or mode.
`direct_exception` requires the station name, reason, replacement evidence, and
a residual `blocked`, `unverified`, or `closed-with-director-risk` state.

## Field Provenance Boundary

Every board field is `internal-governance-only`. Use only the five provenance
classes owned by `Shared/policies/references/workflow-execution-spec-contract.md`:
`official-public`, `current-session-tool-schema`, `observed-platform-receipt`,
`internal-governance-only`, and `unverified`. Internal board, packet, wait, and
lifecycle fields never enter a platform payload or become a native receipt.

Only an observed receipt naming a valid actual value can populate an accepted
or applied projection. Invocation success, transport metadata, and internal
ledger transitions prove neither acceptance nor application.

## Nested Contract Schemas

### Parallel Dispatch Contract

```text
parallel_dispatch_contract: {
  contract_version, baseline_revision, baseline_status_snapshot,
  baseline_diff_fingerprint, read_scope, write_scope, forbidden_scope,
  forbidden_actions, owned_contracts, consumed_contracts, protected_invariants,
  upstream_inputs, downstream_consumers, conflict_domains,
  interface_freeze_ref, same_wave_eligibility, delivery_artifact_type,
  output_artifact_format, integration_owner, integration_barrier,
  stop_condition, escalation_condition
}
```

`same_wave_eligibility` is `eligible`, `ordered-after-upstream`,
`blocked-unfrozen-interface`, `blocked-conflict-domain`, `unverified`, or
`not-applicable`. The object is sealed for one dispatch decision. Baseline
drift, mutable interface, conflict-domain overlap, generated/source conflict,
or missing integration owner makes the candidate ordered, blocked, or
unverified; different file names alone are insufficient.

### Git Checkpoint Receipt

`git_checkpoint_receipt` is the separately authorized long-work receipt with
`checkpoint_id`, `checkpoint_state`, `delivery_slice_id`, `acceptance_ref`,
authorization snapshot, repository and index evidence, `evidence_states`,
`secret_check`, commit identity, `push_state`, `history_mode`, result, and
blocker. Its exact procedure is owned by
`Shared/skills/team-specialist-git-checkpoint/SKILL.md`; it never proves final
completion.

## Director-Facing Display

Director-facing summaries give Traditional Chinese meaning first and keep the
canonical field in parentheses only when needed, for example
`任務板狀態（board_state）`. Do not translate or rename machine fields.
