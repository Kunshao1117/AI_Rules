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
| Invocation is `returned`, the receipt is complete, and all requested comparisons match | `applied` | Both actual channel-reported values | `none`; empty detail |
| Invocation is `returned`, the receipt is complete, and at least one requested comparison mismatches | `applied-with-variance` | Both actual channel-reported values | `platform-selected-alternative`, or `requested-model-unavailable` / `requested-effort-unavailable` when the channel explicitly reports that cause; non-empty detail |
| Capability, invocation, packet ID, run ID, or receipt values are inconsistent | `unverified` | Preserve each actually reported value; each missing value is `unreported`; never infer a value | `receipt-conflict`; non-empty detail naming the conflict |

A complete `applied_execution_receipt` contains every field required by the
handoff receipt schema: `handoff_packet_id`, `channel_run_id`,
`execution_profile_application_state`, `applied_model`,
`applied_reasoning_effort`, and `execution_profile_variance_reason`. The packet
ID and run ID must match the board row. The receipt application state must be a
valid application-state value, and the variance reason must contain a valid
code and a detail that follows the empty/non-empty rule below. Actual model and
reasoning-effort values must be channel-reported and must not be `unreported`,
`not-applied`, `not-applicable`, or any other sentinel.

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
