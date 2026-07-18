# Team Task Board Field Catalog

This reference owns the complete board field catalog for
`team-task-board/SKILL.md`. Other skills cite this file and
`Shared/policies/team-trace-evidence.md` instead of copying the list.

Field names listed here are board-facing canonical names and value sets.
`team-station-handoff-packet` may repeat a field as packet overlay input,
`team-completion-gate` may repeat a field as closeout evidence, and
`team-trace-evidence` may audit the same field for trace completeness.
Those files consume this catalog; they do not define competing values.

## Canonical Board Fields

```text
board_id
board_template
board_state
task_type
workflow_route
operation_mode
operation_mode_reason
closeout_lane
yellow_classification
yellow_resolution_state
repair_loop_limit
phase
dispatch_wave
parallel_dispatch_contract
previous_wave_input
next_wave_start_condition
formal_evidence_eligibility
implementation_authorization
go_evidence
authorization_source
authorization_target
authorization_scope
authorization_phase
authorization_evidence
authorization_expiry
authorization_resolution_state
platform_mode_observed
platform_capability_route
station_family
formal_station
substation_task
member_assignment
applicability
station_state
evidence_state
station_lifecycle_state
execution_lifecycle_state
station_mode
retention_reason
conversation_health
reuse_count
handoff_summary
closure_reason
role_id
role_instance_id
exclusive_task_scope
specialist_role_source
assigned_specialist_skill
loaded_skill_refs
domain_label
handoff_packet_id
handoff_ownership
requested_execution_channel
channel_capability
channel_invocation_status
channel_run_id
channel_generation
replaces_channel_run_id
replacement_reason
execution_route
execution_channel
accepted_execution_request
acceptance_state
accepted_execution_profile
accepted_model
accepted_reasoning_effort
accepted_context_scope_ref
accepted_wait_policy_ref
acceptance_variance_reason
accepted_at
execution_profile_application_state
applied_model
applied_reasoning_effort
execution_profile_variance_reason
evidence_owner
role_boundary
direct_exception
replacement_evidence
deep_read_scope
captain_coordination_read_scope
context_visibility
unread_scope
external_grounding_required
external_research_question
external_research_artifact_id
external_grounding_state
source_tier
source_date_or_version
missing_external_evidence
allowed_inputs
allowed_tools
forbidden_actions
output_artifact_format
stop_condition
startup_started_at
workload_class
adapter_latency_class
adapter_latency_multiplier
adapter_first_useful_fraction
initial_wait_budget
initial_first_useful_budget
first_response_deadline
first_response_at
last_progress_at
heartbeat_state
status_probe_state
status_probe_sent_at
status_probe_response_at
status_probe_resume_state
status_probe_resume_sent_at
soft_timeout_at
hard_timeout_at
extension_count
extension_ceiling
timeout_action
late_result_policy
late_result_window
cancellation_state
standby_reason
resume_condition
returned_at
return_timing
receipt_decision
receipt_decision_reason
conflict_with_artifact_id
final_channel_closure_reason
delivery_artifact_type
delivery_artifact_id
delivery_artifact_status
author_role
source_input
integrable_scope
delivery_slice
delivery_slice_id
delivery_slice_state
delivery_slice_legacy_fallback
git_checkpoint_receipt
captain_authored
validation_handoff
review_handoff
memory_docs_handoff
review_state
validation_state
memory_docs_state
completion_condition
completion_state
source_deployed_pair
sync_direction
sync_evidence
```

## Field Provenance Boundary

Every board field in this catalog is `internal-governance-only`. The requested snapshot carried by
the handoff packet, nested `accepted_execution_request`, accepted flat projections,
`applied_execution_receipt`, applied flat projections, wait-policy fields, wait-baseline fields,
and lifecycle fields remain internal governance carriers even when they preserve
`observed-platform-receipt` evidence.

Use the five provenance classes owned by
`Shared/policies/references/workflow-execution-spec-contract.md`:
`official-public`, `current-session-tool-schema`, `observed-platform-receipt`,
`internal-governance-only`, and `unverified`. Provenance is evidence metadata, not a platform
request parameter or a new board value set. Internal fields must not enter a platform payload or be
described as native platform receipts.

Only an observed receipt that explicitly names a valid actual value may populate the corresponding
accepted or applied actual-value projection. Successful invocation, transport identifiers, and
internal wait or lifecycle transitions do not prove acceptance or application. When observed
receipt evidence is absent, use the existing missing, unreported, and unverified semantics rather
than adding a new carrier.

## Nested Contract Schemas

### Parallel Dispatch Contract

`parallel_dispatch_contract` is the canonical board object used to decide whether bounded member
assignments may enter the same dispatch wave. This catalog owns its nested shape and value set;
`Shared/policies/workflow-orchestration.md` is the sole owner of dependency, wave, and same-wave
semantics.

```text
parallel_dispatch_contract: {
  contract_version,
  baseline_revision,
  baseline_status_snapshot,
  baseline_diff_fingerprint,
  read_scope,
  write_scope,
  forbidden_scope,
  forbidden_actions,
  owned_contracts,
  consumed_contracts,
  protected_invariants,
  upstream_inputs,
  downstream_consumers,
  conflict_domains,
  interface_freeze_ref,
  same_wave_eligibility,
  delivery_artifact_type,
  output_artifact_format,
  integration_owner,
  integration_barrier,
  stop_condition,
  escalation_condition
}
```

`same_wave_eligibility` uses exactly:

- `eligible`
- `ordered-after-upstream`
- `blocked-unfrozen-interface`
- `blocked-conflict-domain`
- `unverified`
- `not-applicable`

The object is sealed for one dispatch decision. `baseline_revision`,
`baseline_status_snapshot`, and `baseline_diff_fingerprint` identify the same captured worktree
state; `interface_freeze_ref` identifies the immutable producer/consumer interface consumed by the
candidate stations. Missing or drifted baseline evidence is `unverified`, not `eligible`.
`integration_owner` names one owner for the combined output and `integration_barrier` names the
point at which downstream review/validation may begin. Handoff packets carry this object without
copying or redefining its nested fields.

### Git Checkpoint Receipt

`git_checkpoint_receipt` is the canonical board receipt for one separately authorized long-work
local Git checkpoint:

```text
git_checkpoint_receipt: {
  checkpoint_id,
  checkpoint_state,
  delivery_slice_id,
  acceptance_ref,
  authorization_snapshot: {
    authorization_source,
    authorization_target,
    authorization_scope,
    authorization_phase,
    authorization_evidence,
    authorization_expiry,
    authorization_resolution_state
  },
  repository_root,
  branch,
  head_before,
  stage_allowlist,
  index_baseline,
  staged_files,
  staged_diff_hash,
  evidence_states: {
    minimum_static_or_tool_evidence,
    known_breakage_state,
    validation_state,
    review_state,
    memory_docs_state,
    sync_evidence_state
  },
  secret_check,
  commit_subject,
  commit_sha,
  head_verified,
  push_state,
  history_mode,
  result,
  blocker
}
```

`checkpoint_state` is `eligible`, `authorized`, `staged`, `committed`, `blocked`, `unverified`, or
`not-applicable`. `result` is `checkpoint-created`, `blocked`, `unverified`, or `not-applicable`.
`authorization_phase` must be `git`, `index_baseline` must record an empty pre-stage index,
`push_state` must be `not-requested`, and `history_mode` must be `append-only`. The commit subject
must explicitly identify the commit as a checkpoint.

Pending or unverified validation, review, memory/docs, or sync evidence is allowed only when
recorded honestly in `evidence_states`; the receipt does not claim completion. The execution
procedure and prohibited Git operations are owned solely by
`Shared/skills/team-specialist-git-checkpoint/SKILL.md`.

## Field Value Catalog

`board_state` records the formal board authority level:

- `draft`
- `formal-readonly`
- `formal-write`

`draft board`, `Formal-readonly board`, and `Formal-write board` are
Director-facing display labels only. Machine traces use the exact values above;
legacy `formal` must be narrowed to `formal-readonly` or `formal-write`.

`station_state` records the station's current work state:

- `assigned`
- `standby`
- `running`
- `returned`
- `blocked`
- `unverified`
- `closed-with-director-risk`
- `not-applicable`

`evidence_state` records the evidence disposition:

- `pending`
- `returned`
- `logged`
- `routed-to-owner-station`
- `blocked`
- `unverified`
- `closed-with-director-risk`
- `not-applicable`

`station_lifecycle_state` records whether a role instance can continue:

- `assigned`
- `standby`
- `retained`
- `reused`
- `handoff-required`
- `closed`
- `replaced`
- `blocked`
- `not-applicable`

`station_lifecycle_state` is retained as a station-retention compatibility view. The single shared
execution lifecycle field is `execution_lifecycle_state`, with this canonical vocabulary:

- `packet-ready`
- `starting`
- `running-silent`
- `progress-reported`
- `probe-eligible`
- `probe-pending`
- `paused-for-probe`
- `resume-required`
- `soft-overrun`
- `replacement-eligible`
- `cancel-pending`
- `returned`
- `late-returned`
- `blocked`
- `unverified`
- `closed`

Adapters map their events into these values and must not add model- or vendor-specific lifecycle
states. The handoff packet owns wait-policy transitions; this catalog owns the values.

`channel_capability` records whether the requested channel can run:

- `available`
- `conditional`
- `unavailable`
- `unverified`

`channel_invocation_status` records the channel startup/result state:

- `not-started`
- `requested`
- `running`
- `returned`
- `unavailable`
- `blocked`
- `not-authorized`

`acceptance_state` records adapter acceptance separately from requested and applied state:

- `pending`
- `exact`
- `alternative`
- `partial`
- `missing`
- `conflicting`
- `not-applicable`

A complete `accepted_execution_request` contains the packet ID, run ID, acceptance state, accepted
profile, accepted model, accepted reasoning effort, accepted context reference, accepted wait
reference, variance reason, and acceptance timestamp defined by the execution spec contract. The
nested `accepted_execution_request` is the immutable ledgered receipt. The flat fields from
`acceptance_state` through `accepted_at` are projections of that one object, not independently
writable peer records. Board ledgering derives every flat field from the nested receipt; any nested
and flat mismatch is `conflicting` with `acceptance-receipt-conflict` rather than a second truth.

Canonical exact, alternative, partial, missing, and conflicting reconciliation, including the
allowed `acceptance_variance_reason` codes and empty/non-empty detail rules, is owned by
`Shared/policies/references/workflow-execution-spec-contract.md`. A legacy channel with no
acceptance receipt uses `legacy-acceptance-receipt-missing`. Tool acceptance never implies application. acceptance is not application.

Requested, accepted, and applied fields are immutable peer layers. Board reconciliation compares
them but never overwrites one layer with another, fills missing accepted values from requested
intent, or fills missing applied values from acceptance. A complete application receipt remains
necessary for an applied state.

`execution_profile_application_state` records canonical observed application
state after channel receipt handling:

- `pending`
- `applied`
- `applied-with-variance`
- `unavailable`
- `blocked`
- `unverified`
- `not-applicable`

`applied_model` records a channel-reported opaque ID, or one of:

- `unreported`
- `not-applied`
- `not-applicable`

`applied_reasoning_effort` records a channel-reported opaque token, or one of:

- `unreported`
- `not-applied`
- `not-applicable`

`execution_profile_variance_reason` is an object with `code` and `detail`.
Allowed `code` values are:

- `none`
- `requested-model-unavailable`
- `requested-effort-unavailable`
- `requested-channel-unavailable`
- `platform-selected-alternative`
- `platform-receipt-missing`
- `scope-unresolved`
- `authorization-blocked`
- `policy-blocked`
- `requested-snapshot-inconsistent`
- `channel-capability-unverified`
- `receipt-conflict`
- `other`
- `not-applicable`

The board recomputes canonical application state from the immutable requested
snapshot, board channel fields, and returned receipt. It never blindly copies
`execution_profile_application_state` from the receipt. Apply this exact
matrix; a receipt conflict takes precedence whenever an otherwise applicable
row contains inconsistent capability, packet ID, run ID, or receipt values:

| Condition | Canonical state | Applied fields | Variance |
|---|---|---|---|
| Complete non-executable sentinel tuple: `execution_profile: not-applicable`, model and effort `not-requested`, and both refs `not-applicable` | `not-applicable` | Both `not-applicable` | `not-applicable`; empty detail |
| Executable snapshot mixes `not-requested` or `not-applicable`, or either ref is `unresolved` or bound to a different packet | `unverified` | Preserve each actually reported value; each missing value is `unreported` | `scope-unresolved` for unresolved or mismatched refs; otherwise `requested-snapshot-inconsistent`; non-empty detail |
| `channel_capability: unavailable` and no actual applied value exists | `unavailable` | Both `not-applied` | `requested-channel-unavailable`; non-empty detail |
| `channel_invocation_status: unavailable`, no actual applied value exists, and no conflicting capability or receipt evidence exists | `unavailable` | Both `not-applied` | `requested-channel-unavailable`; non-empty detail |
| `channel_capability: unverified` | `unverified` | Preserve each actually reported value; each missing value is `unreported` | `channel-capability-unverified`; non-empty detail |
| Capability is `available` or `conditional`, invocation is `not-started`, `requested`, or `running`, and receipt is `pending` | `pending` | Both `unreported` | `not-applicable`; empty detail |
| Invocation is `blocked` or `not-authorized` and no actual applied value exists | `blocked` | Both `not-applied` | `policy-blocked` for `blocked`; `authorization-blocked` for `not-authorized`; non-empty detail |
| Invocation is `returned`, but the receipt is missing or partial | `unverified` | Preserve each actually reported value; each missing value is `unreported` | `platform-receipt-missing`; non-empty detail naming every missing receipt field |
| Invocation is `returned`, the receipt is complete, its self-report agrees with reconciliation, and all requested comparisons match | `applied` | Both actual channel-reported values | `none`; empty detail |
| Invocation is `returned`, the receipt is complete, its self-report agrees with reconciliation, and at least one requested comparison mismatches | `applied-with-variance` | Both actual channel-reported values | `platform-selected-alternative`, or `requested-model-unavailable` / `requested-effort-unavailable` when the channel explicitly reports that cause; non-empty detail |
| Capability, invocation, packet ID, run ID, or receipt values are inconsistent | `unverified` | Preserve each actually reported value; each missing value is `unreported`; never infer a value | `receipt-conflict`; non-empty detail naming the conflict |

A complete `applied_execution_receipt` contains every field required by the
handoff receipt schema: `handoff_packet_id`, `channel_run_id`,
`execution_profile_application_state`, `applied_model`,
`applied_reasoning_effort`, and `execution_profile_variance_reason`. The packet
ID and run ID must match the board row. The receipt application state must be a
valid complete-receipt value: `applied` or `applied-with-variance`. A complete
executable receipt also requires board `channel_capability` to be `available`
or `conditional` and `channel_invocation_status` to be `returned`. Packet and
run IDs must be non-empty, non-sentinel values and must match the board row.

The variance reason must be a non-null object containing both `code` and
`detail`. Receipt-supplied codes are limited to `none`,
`platform-selected-alternative`, `requested-model-unavailable`, and
`requested-effort-unavailable`; other canonical variance codes are board
reconciliation outputs, not claims a receipt can use to prove itself. An empty
object, unknown code, missing property, or invalid empty/non-empty detail makes
the receipt partial or conflicting according to the matrix.

Actual model and reasoning-effort values must be channel-reported, non-empty,
and must not be `unreported`, `unknown`, `unverified`, `missing`, `not-applied`,
`not-applicable`, or any other sentinel. A self-reported application state or
variance object that disagrees with the requested-value comparison is a
`receipt-conflict`; the board does not normalize that contradiction into an
applied state.

The receipt's application state and variance reason are validated inputs to
reconciliation, not canonical outputs. The board still recomputes canonical
state and variance from the requested snapshot, board channel fields, and the
whole receipt; it does not blindly copy either receipt self-report.

A receipt missing any required field, including its application state or
variance reason, is partial. A partial receipt is never complete and cannot
reach `applied` or `applied-with-variance`; it is `unverified` with
`platform-receipt-missing` and non-empty detail naming every missing field.

Requested-value comparison is exact:

- `platform-default` accepts any actual channel-reported value, never a sentinel.
- `exact:<opaque>` strips only the `exact:` prefix and compares the remainder verbatim.
- Requested effort `low`, `medium`, or `high` compares verbatim with the actual effort.

An exact model mismatch, exact effort mismatch, unreported model or effort,
unavailable channel, or unverified channel cannot yield `applied`. A partial
receipt is always `unverified`, never `applied-with-variance`.

For `none` and `not-applicable`, `detail` must be empty. For every other
variance code, `detail` must be non-empty.

`station_mode` records the station posture:

- `read-only`
- `change-delivery`
- `change-application`
- `validation`
- `review`
- `memory-docs`
- `completion`
- `protected-gate`
- `not-applicable`

`workload_class` uses the platform-neutral handoff classes:

- `short-evidence`
- `broad-read`
- `architecture-research`
- `change-delivery`
- `validation-command`
- `external-tool`

`adapter_latency_class`, `adapter_latency_multiplier`, and
`adapter_first_useful_fraction` are opaque adapter-reported timing inputs. The
wait baseline computes `initial_first_useful_budget` from the formal formula in
the execution spec contract. These fields may extend wait budgets only under
the handoff wait-policy contract and never select a profile, change scope or
gates, or prove applied execution. `extension_count` is at most two and
`extension_ceiling` is at most two times `initial_wait_budget`.

`delivery_slice` is the acceptance-sized implementation/review/validation unit from the execution
spec contract. `delivery_slice_state` values are:

- `draft`
- `authorized`
- `in-delivery`
- `checkpoint-required`
- `delivered`
- `review-validation-pending`
- `returned-for-repair`
- `blocked`
- `unverified`
- `closed`

`delivery_slice_legacy_fallback` is `not-applicable` or `inferred-current-acceptance`. Legacy
fallback maps only the current delivery artifact or authorized acceptance unit and never expands
scope. Review and validation ledger against the slice rather than individual files or micro-steps.

`context_visibility` records who actually saw the assigned scope:

- `specialist-deep-read`
- `captain-coordination-only`
- `shared-visible`
- `unread`
- `not-applicable`

`external_grounding_required` records whether the station needs current external
evidence:

- `true`
- `false`
- `unknown`

Use `external_grounding_state` or prose for blocked, unverified, or
not-applicable outcomes. Do not encode those outcomes in
`external_grounding_required`.

`external_research_question` records the exact external fact, version, API,
security, legal, pricing, status, or vendor-doc question a station needs. Use
`not-applicable` when no external evidence is needed.

`external_research_artifact_id` records the returned formal
`external-research` artifact ID. If a role-specific artifact uses
`external_grounding_artifact_id`, the returned artifact must map that value to
canonical `external_research_artifact_id`.

`external_grounding_state` records whether current external evidence is needed,
requested, sufficient, incomplete, missing, conflicted, blocked, or unverified:

- `not-required`
- `required`
- `requested`
- `sufficient`
- `partial`
- `no-evidence`
- `conflicted`
- `blocked`
- `unverified`

Route and receipt events are prose, not machine states. Describe that an
external-research route opened or that an artifact returned without adding
those events to the `external_grounding_state` value set.

`source_tier` records the source quality tier returned by the
`external-research` station:

- `official`
- `primary`
- `high-confidence-secondary`
- `low-confidence-community`
- `local-tool-output`
- `not-applicable`
- `unknown`

`source_date_or_version` records the publication date, retrieval date, API
version, product version, standard version, or `not-applicable`.

`missing_external_evidence` records the blocked/unverified reason when no
artifact or sufficient source exists. Use `none` when external evidence is not
missing.

`handoff_ownership` records who owns the current handoff state:

- `station-owned`
- `platform-nondelegable-gate`
- `returned-to-captain`
- `reassigned`
- `blocked`
- `unverified`
- `not-applicable`

`status_probe_state` records status-probe lifecycle:

- `not-sent`
- `sent`
- `paused-reported`
- `responded-paused`
- `awaiting-resume`
- `responded-extension-requested`
- `responded-blocked`
- `unresponsive`
- `unavailable`
- `not-applicable`

`status_probe_resume_state` records only the resume lifecycle after a status
probe response:

- `awaiting-resume`
- `resume-sent`
- `resumed`
- `blocked`
- `unavailable`

Use `status_probe_state: not-sent` or `status_probe_state: not-applicable`
when no resume lifecycle exists. Ongoing work belongs in
`station_state: running`; an extension request belongs in
`status_probe_state: responded-extension-requested`.

`timeout_action` records the next lifecycle action after timeout:

- `standby`
- `replace`
- `blocked`
- `unverified`
- `director-input`
- `not-applicable`

`late_result_policy` records how late artifacts will be handled:

- `late-result-pending`
- `receive-and-compare`
- `accept-until-hard-timeout`
- `ignore-after-cancelled`
- `blocked`
- `unverified`
- `not-applicable`

`ignore-after-cancelled` is valid only when `cancellation_state: acknowledged`
and the late-result window closes with no artifact returned. Once an artifact
returns, record `returned_at`, `return_timing`, `receipt_decision`, and
`receipt_decision_reason`.

`cancellation_state` records cancellation state separately from replacement:

- `not-requested`
- `cancellation-pending`
- `requested`
- `acknowledged`
- `ignored`
- `unavailable`
- `not-applicable`

`return_timing` records whether an artifact arrived on schedule:

- `on-time`
- `late`
- `not-returned`
- `not-applicable`

`receipt_decision` records the neutral ledger disposition for returned or late
artifacts:

- `logged`
- `included-in-synthesis-ledger`
- `routed-to-owner-station`
- `superseded-by-replacement`
- `out-of-scope`
- `duplicate`
- `conflict-review`
- `blocked`
- `unverified`
- `not-applicable`

`delivery_artifact_status` records delivery state:

- `pending`
- `returned`
- `logged`
- `applied-by-owner-station`
- `blocked`
- `unverified`
- `closed-with-director-risk`
- `not-applicable`

`validation_handoff`, `review_handoff`, and `memory_docs_handoff` record the
post-change downstream handoff bundle returned by implementation or
change-application stations. They are inputs for later stations only;
implementers do not fill final `validation_state`, `review_state`, or
`memory_docs_state`.

`review_state` records review lifecycle only:

- `not-started`
- `pending`
- `accepted`
- `fix-required`
- `blocked`
- `unverified`
- `accepted-risk`
- `not-applicable`

`accepted-risk` is a review lifecycle state only. It is not a station state,
delivery status, evidence status, or completion state.

`validation_state` records validation result:

- `not-started`
- `pending`
- `passed`
- `failed`
- `blocked`
- `unverified`
- `not-applicable`

`memory_docs_state` records memory/docs delivery disposition:

- `not-started`
- `memory_delivery`
- `blocked`
- `unverified`
- `closed-with-director-risk`
- `not-applicable`

`completion_state` records closeout honesty:

- `complete`
- `closed-with-director-risk`
- `blocked`
- `unverified`
- `not-applicable`

`closed-with-director-risk` is a non-complete risk-closure state. It requires
current, scope-bound Director risk-close evidence and cannot substitute for
missing delivery, validation, review, memory/docs, sync, or trace evidence.

For main-worktree implementation, `station-owned` change delivery is the
default owner. `change-application` is a fallback integration posture for
returned isolated/text artifacts, explicit integration tasks, or assigned
generated/deployed sync. `platform-nondelegable-gate` is valid only when the
platform cannot delegate the physical write or protected tool call and the board
records the direct exception. It is a coordination record and does not transfer
protected-action authority to the captain.

`direct_exception` records a station-specific exception. `direct` is never a
canonical `board_state`, `station_state`, `execution_route`,
`execution_channel`, platform route, or execution mode. Evidence-oriented
`direct_exception` records require station name, exception reason, replacement evidence, and a
residual state of `blocked`, `unverified`, or `closed-with-director-risk`.

## Director-Facing Display

Director-facing summaries use Traditional Chinese meaning first and preserve
canonical field names in parentheses when needed, such as
`任務板狀態（board_state）`. Do not translate, rename, or derive new machine
fields.

Trace audit fields that are not board-facing stay in
`Shared/policies/team-trace-evidence.md`.
