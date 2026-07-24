# Team Trace Field Contract

This reference is the sole owner of trace-only field groups, trace hard gates,
and audit-result semantics. Board field values remain owned by the three board
field references named below.

## Canonical Sources

| Concern | Owner |
|---|---|
| Board-wide fields and generic values | `Shared/skills/team-task-board/references/board-field-catalog.md` |
| Slice roster, role, finding, repair, and member-replacement fields | `Shared/skills/team-task-board/references/board-field-slice-and-roles.md` |
| Channel, lifecycle, acceptance, application, and receipt fields | `Shared/skills/team-task-board/references/board-field-channel-and-receipts.md` |
| Authorization, status, completion, protected action, hook, exception, and copy-map values | Their canonical `Shared/policies/references/` registries |

Trace records may be readable Markdown or JSON. Canonical machine field names
remain English. Director-facing rendering follows
`Shared/policies/language-governance.md`.

## Trace Field Groups

| Group | Required fields when the corresponding claim is made |
|---|---|
| Task and route | `task_id`, `task_type`, `workflow_route`, `execution_spec_id`, `execution_spec_state`, `operation_mode`, `operation_mode_reason`, `dormant_readiness_hook_state`, `captain_pre_action_guard_state` |
| Authorization | `implementation_authorization`, `go_evidence`, `authorization_source`, `authorization_target`, `authorization_scope`, `authorization_phase`, `authorization_evidence`, `authorization_expiry`, `authorization_resolution_state`, `platform_mode_observed` |
| Station identity | `board_id`, `formal_station`, `station_family`, `substation_task`, `member_assignment`, `role_id`, `role_instance_id`, `exclusive_task_scope`, `specialist_role_source`, `assigned_specialist_skill`, `loaded_skill_refs`, `handoff_packet_id`, `handoff_ownership`, `station_mode`, `context_visibility` |
| Read and grounding | `domain_label`, `deep_read_scope`, `captain_coordination_read_scope`, `unread_scope`, `external_grounding_required`, `external_research_question`, `external_research_artifact_id`, `external_grounding_state`, `source_tier`, `source_date_or_version`, `missing_external_evidence` |
| Slice and station rounds | `delivery_slice`, `delivery_slice_id`, `slice_baseline_packet_id`, `slice_station_roster`, `slice_round`, `slice_station_round_state`, `finding_id`, `finding_source_station`, `finding_disposition`, `implementation_resume_state`, `implementation_resume_decision_ref`, `repair_loop_count`, `member_replacement_state`, `member_replacement_reason`, `replaces_role_instance_id`, `context_transfer_ref` |
| Channel and receipts | `requested_execution_channel`, `channel_capability`, `channel_invocation_status`, `channel_run_id`, `channel_generation`, `replaces_channel_run_id`, `replacement_reason`, `status_probe_state`, `status_probe_resume_state`, `status_probe_resume_decision_ref`, deadline fields, requested/accepted/applied receipt fields, cancellation, return, and ledger-decision fields |
| Delivery and closeout | `delivery_artifact`, `delivery_artifact_id`, `delivery_artifact_status`, `author_role`, `source_input`, `integrable_scope`, `validation_handoff`, `review_handoff`, `memory_docs_handoff`, `validation_state`, `review_state`, `memory_docs_state`, `stations`, `waves`, `delivery_artifacts`, `direct_exceptions`, `captain_authored`, `no_captain_authoring`, `completion_state`, `risk_close_evidence`, `residual_risk`, `source_deployed_pair`, `sync_direction`, `sync_evidence` |

`execution_route` and `execution_channel` are routes only; status values do not
belong in either field. A captain coordination read is limited to ledgering,
board maintenance, blocker/conflict handling, or scope-question routing. It is
never validation, review, memory/docs attribution, or completion evidence.

## Formal Station Hard Gates

- Every formal station has a parseable `handoff_packet_id`, role identity,
  assigned specialist skill, bounded read scope, allowed tools, forbidden
  actions, channel state, delivery artifact type, and stop condition.
- A write-capable or protected mutation records the resolved authorization,
  exact target/scope/phase/expiry, required trusted execution envelope, and
  matching receipt. Missing or untrusted evidence is `blocked` or
  `unverified`.
- Main-worktree implementation requires station-owned `change-delivery`,
  `implementation-change-delivery`, exact file allowlist, dirty-diff evidence,
  and forbidden protected actions. `change-application` is limited to a
  returned isolated/text artifact, explicit integration task, or assigned
  generated/deployed sync under its own phase.
- A slice fixes five independent station rows. `implementation`, `validation`,
  and `review` are the primary repair/rerun members; `memory-closure` and
  `completion` are preconfigured reserved members of the same delivery slice
  and start only when their dependencies are satisfied. Their
  `member_assignment` and `role_instance_id` values must differ. Each original
  context and packet remains bound across slice rounds.
- A returned primary or activated reserved station transitions to `standby`,
  not terminal closure, until the slice is accepted. A reserved member is not a
  new slice or replacement. A finding does not authorize repair on its own: an
  explicit captain decision must resume the original implementation member.
  After that returned repair, the captain explicitly resumes the original
  validation and review members.
- `repair_loop_count` one or two keeps the same slice and original station
  roster. It creates neither a repair station nor a new packet baseline. On the
  third occurrence of the same symptom, an independent `diagnosis` or
  `module-split` station may be added; its output routes back to the original
  implementation member.
- Probe, timeout, channel resume, and channel generation replacement have only
  channel effect. They never reopen a station with a different member. A member
  replacement needs the separate captain decision, permitted reason, and
  context-transfer reference from the slice/role owner.
- A returned subagent artifact is station input awaiting owner-station
  disposition. Captain ledgering may log and route it, but cannot recast it as
  a validation, review, acceptance, or completion conclusion.
- Completion requires terminal channel disposition or honest residual state for
  every opened channel, plus the applicable separated delivery artifacts. A
  pending `awaiting-resume`, `cancellation-pending`, or `late-result-pending`
  value is non-terminal.

## Audit Result Semantics

| Result | Meaning |
|---|---|
| `passed` | Required trace, station, role, packet, channel, slice, and delivery evidence exists for the claim. |
| `unverified` | Trace or required evidence is incomplete; the task may only be reported honestly as unverified. |
| `blocked` | The trace is required for formal closeout, commit, release, or completion and is absent or invalid. |
| `not-applicable` | The task is pure discussion or otherwise did not activate Team-Native work. |

No audit result grants write authority or converts a captain coordination record
into station-owned evidence.
