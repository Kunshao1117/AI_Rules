# Team Task Board Field Catalog

This reference owns the complete board field catalog for
`team-task-board/SKILL.md`. Other skills cite this file and
`Shared/policies/team-trace-evidence.md` instead of copying the list.

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
evidence_owner
role_boundary
direct_exception
replacement_evidence
deep_read_scope
captain_coordination_read_scope
context_visibility
unread_scope
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
