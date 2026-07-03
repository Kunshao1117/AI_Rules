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
- `captain-owned-gate`
- `returned-to-captain`
- `reassigned`
- `blocked`
- `unverified`
- `not-applicable`

For main-worktree implementation, `station-owned` change delivery is the
default owner. `change-application` is a fallback integration posture for
returned isolated/text artifacts, explicit integration tasks, or assigned
generated/deployed sync. `captain-owned-gate` is valid only when the platform
cannot delegate the physical write or protected tool call and the board records
the direct exception.

## Director-Facing Display

Director-facing summaries use Traditional Chinese meaning first and preserve
canonical field names in parentheses when needed, such as
`任務板狀態（board_state）`. Do not translate, rename, or derive new machine
fields.

Trace audit fields that are not board-facing stay in
`Shared/policies/team-trace-evidence.md`.
