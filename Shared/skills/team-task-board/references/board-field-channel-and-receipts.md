# Board Fields: Channel, Lifecycle, And Receipts

This reference is the sole owner of execution-channel, wait/lifecycle,
requested/accepted/applied, probe/resume, replacement, cancellation, late
return, and receipt-ledger fields. It consumes station and slice identity from
the board index and slice/role reference.

## Channel Field Set And Boundary

```text
requested_execution_channel, channel_capability, channel_invocation_status,
channel_run_id, channel_generation, replaces_channel_run_id, replacement_reason,
execution_route, execution_channel, requested_execution_snapshot,
accepted_execution_request, acceptance_state, accepted_execution_profile,
accepted_model, accepted_reasoning_effort, accepted_context_scope_ref,
accepted_wait_policy_ref, acceptance_variance_reason, accepted_at,
applied_execution_receipt, execution_profile_application_state, applied_model,
applied_reasoning_effort, execution_profile_variance_reason, startup_started_at,
workload_class, adapter_latency_class, adapter_latency_multiplier,
adapter_first_useful_fraction, initial_wait_budget, initial_first_useful_budget,
first_response_deadline, first_response_at, last_progress_at, heartbeat_state,
status_probe_state, status_probe_sent_at, status_probe_response_at,
status_probe_pause_report, status_probe_resume_state,
status_probe_resume_sent_at, status_probe_resume_decision_ref, soft_timeout_at,
hard_timeout_at, extension_count, extension_ceiling, timeout_action,
late_result_policy, late_result_window, cancellation_state, returned_at,
return_timing, receipt_decision, receipt_decision_reason,
conflict_with_artifact_id, final_channel_closure_reason
```

All listed fields describe one channel attempt or its immutable receipt layers.
They never change `delivery_slice_id`, `slice_baseline_packet_id`,
`member_assignment`, `role_instance_id`, context, station ownership, or repair
loop. The separate explicit member-replacement record is the sole exception.

`channel_capability` is `available`, `conditional`, `unavailable`, or
`unverified`. `channel_invocation_status` is `not-started`, `requested`,
`running`, `returned`, `unavailable`, `blocked`, or `not-authorized`.
`execution_route` and `execution_channel` contain a delivery form, never a
status value.

## Requested, Accepted, And Applied Receipts

Requested, accepted, and applied are immutable peer layers. They may be
compared but never overwrite or fill one another.

`acceptance_state` is `pending`, `exact`, `alternative`, `partial`, `missing`,
`conflicting`, or `not-applicable`. The nested
`accepted_execution_request` is the ledgered receipt; its flat accepted fields
are derived projections. A nested/flat mismatch is `conflicting`.

`execution_profile_application_state` is `pending`, `applied`,
`applied-with-variance`, `unavailable`, `blocked`, `unverified`, or
`not-applicable`. `applied_model` and `applied_reasoning_effort` are a
channel-reported opaque token or `unreported`, `not-applied`, or
`not-applicable`.

`execution_profile_variance_reason` has `code` and `detail`. Codes are `none`,
`requested-model-unavailable`, `requested-effort-unavailable`,
`requested-channel-unavailable`, `platform-selected-alternative`,
`platform-receipt-missing`, `scope-unresolved`, `authorization-blocked`,
`policy-blocked`, `requested-snapshot-inconsistent`,
`channel-capability-unverified`, `receipt-conflict`, `other`, or
`not-applicable`. `none` and `not-applicable` have empty detail; every other
code has non-empty detail.

Only a complete observed receipt with matching packet and run IDs may prove
applied execution. Tool success, an agent ID, nickname, acceptance, or
transport metadata is not application evidence. A partial receipt stays
`unverified` with `platform-receipt-missing`.

## Lifecycle And Channel Resume

`execution_lifecycle_state` is `packet-ready`, `starting`, `running-silent`,
`progress-reported`, `probe-eligible`, `probe-pending`, `paused-for-probe`,
`resume-required`, `soft-overrun`, `replacement-eligible`, `cancel-pending`,
`returned`, `late-returned`, `blocked`, `unverified`, or `closed`.

`status_probe_state` is `not-sent`, `sent`, `paused-reported`,
`responded-paused`, `awaiting-resume`, `responded-extension-requested`,
`responded-blocked`, `unresponsive`, `unavailable`, or `not-applicable`.
`status_probe_resume_state` is `awaiting-resume`, `resume-sent`, `resumed`,
`blocked`, `unavailable`, or `not-applicable`.

A responding probe pauses the channel. It resumes only when the captain records
`status_probe_resume_decision_ref` for the same role instance and channel run,
then sets `status_probe_resume_state: resume-sent` and records the timestamp.
This channel resume is distinct from the captain's implementation-finding
resume in the slice/role reference.

`timeout_action` is `standby`, `replace`, `blocked`, `unverified`,
`director-input`, or `not-applicable`. `late_result_policy` is
`late-result-pending`, `receive-and-compare`, `accept-until-hard-timeout`,
`ignore-after-cancelled`, `blocked`, `unverified`, or `not-applicable`.
`cancellation_state` is `not-requested`, `cancellation-pending`, `requested`,
`acknowledged`, `ignored`, `unavailable`, or `not-applicable`.

## Channel Replacement And Late Return

`replacement_reason` is a channel-run reason such as `unresponsive`,
`hard-timeout`, `blocked-route`, `stale-context`, `channel-unavailable`, or
`not-applicable`. It opens a new `channel_generation` linked by
`replaces_channel_run_id`, while retaining the same station member, role
instance, context, packet baseline, and slice. It never makes a personnel
decision.

`return_timing` is `on-time`, `late`, `not-returned`, or `not-applicable`.
`receipt_decision` is `logged`, `included-in-synthesis-ledger`,
`routed-to-owner-station`, `superseded-by-replacement`, `out-of-scope`,
`duplicate`, `conflict-review`, `blocked`, `unverified`, or
`not-applicable`. Late artifacts are always logged and given a neutral
decision; no generation has an automatic preference.

`extension_count` has at most one accepted-slower and one applied-rebase
increase, bounded by `extension_ceiling`. Timing can never expand scope or
change station, role, validation/review depth, slice boundaries, or member
assignment. Exact deadline formulas and transitions are owned by
`Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md`.
