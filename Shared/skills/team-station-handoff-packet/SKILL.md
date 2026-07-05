---
name: team-station-handoff-packet
description: >
  [Infra] Team station handoff packet for Team-First specialist startup,
  loaded skill refs, deep-read scope, standby, and timeout monitoring.
  Use when: 隊長要啟動隊員、建立正式站點派工包、傳遞技能引用、分配深讀範圍、設定待機或監控隊員啟動時間。
  DO NOT use when: 純對話、沒有團隊站點、或最終隊長裁決。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Station Handoff Packet

## Purpose

This skill turns one board row into one bounded specialist assignment. It is an
operating wrapper around the board; it is not a second board template and does
not repeat the full board field list.

Read these sources first:

| Need | Source |
|---|---|
| Team-Native station-first rule, handoff packet rule, role separation, and completion boundary | `Shared/policies/team-native-core.md` |
| Board fields and station row template | `Shared/skills/team-task-board/SKILL.md` |
| Workflow sequence, board state, and dispatch waves | `Shared/policies/workflow-orchestration.md` |
| Authorization scope carried by the packet | `Shared/policies/authorization-resolution.md` |
| Role identity and boundary checks | `Shared/skills/team-role-boundaries/SKILL.md` |
| Trace audit fields | `Shared/policies/team-trace-evidence.md` |

The packet carries resolved board scope. It never creates write authorization,
protected mutation authority, final review state, or final readiness or
completion decisions.

## When To Issue A Packet

Issue a packet after a Captain Team Board exists and before opening, retaining,
replacing, or resuming a formal specialist station.

Do not issue a packet when:

- no formal station exists;
- the station has no resolved applicability, wave, or role boundary;
- the work would mutate source, memory, git, release, deployment, install, or
  external state without a matching formal-write authorization record;
- the packet would bundle multiple roles, tasks, output formats, or stop
  conditions.

## Packet Construction

One packet contains exactly one role, one concrete task, one output artifact
format, and one stop condition. Split work into separate substation tasks when
any of those changes.

Before the captain starts a specialist channel, the packet must be
startup-complete: `handoff_packet_id`, `role_id`, `role_instance_id`,
`station_mode`, `context_visibility`, `handoff_ownership`,
`assigned_specialist_skill`, `read_scope`, `allowed_tools`,
`forbidden_actions`, channel state (`requested_execution_channel`,
`channel_capability`, and `channel_invocation_status`, or an explicit
blocked/unverified reason), `delivery_artifact_type`, and `stop_condition` must
be present. If any item is missing, do not dispatch it as formal work; record the
station as blocked or unverified.

Required packet overlay:

```text
handoff_packet_id:
board_id:
station_family:
formal_station:
station_mode:
substation_task:
member_assignment:
role_id:
role_instance_id:
exclusive_task_scope:
assigned_specialist_skill:
loaded_skill_refs:
handoff_ownership:
one_concrete_task:
allowed_inputs:
read_scope:
allowed_paths_or_resources:
deep_read_scope:
captain_coordination_read_scope:
context_visibility:
unread_scope:
allowed_tools:
forbidden_actions:
requested_execution_channel:
channel_capability:
channel_invocation_status:
channel_run_id:
channel_generation:
replaces_channel_run_id:
execution_channel:
delivery_artifact_type:
integrable_scope:
review_dependency:
validation_dependency:
memory_docs_dependency:
startup_started_at:
first_response_deadline:
last_progress_at:
heartbeat_state:
status_probe_state:
status_probe_sent_at:
status_probe_response_at:
status_probe_resume_state:
status_probe_resume_sent_at:
soft_timeout_at:
hard_timeout_at:
timeout_action:
late_result_policy:
late_result_window:
cancellation_state:
standby_reason:
resume_condition:
output_artifact_format:
stop_condition:
handoff_summary:
```

The packet inherits operation mode, board state, authorization fields, phase,
dispatch wave, platform mode, and completion condition from the board row in
`team-task-board`. Do not duplicate the complete board field set here.

The packet is not startup-complete when `station_mode`, `context_visibility`, or
`handoff_ownership` is missing for an applicable formal station. Missing fields
keep the station blocked or unverified and cannot support a complete trace.

For `station_mode: change-delivery`, a main-worktree implementation packet must
prove `handoff_ownership: station-owned`, authorization phase
`implementation-change-delivery`, exact source file allowlist, dirty-diff read
requirement, and forbidden protected actions.

For `station_mode: change-application`, the packet must prove fallback
integration source input as a returned isolated/text artifact, explicit
integration task, or assigned generated/deployed sync, plus
`handoff_ownership: station-owned` by default, authorization phase
`change-application`, exact source file allowlist, dirty-diff read requirement,
and forbidden protected actions. If the platform cannot delegate the physical
write or protected tool call, set `handoff_ownership:
platform-nondelegable-gate` and record the direct exception.

`handoff_packet_id` is canonical. `dispatch_packet_id` may appear only as a
legacy alias in returned artifacts.

Director-facing packet summaries must lead with the Traditional Chinese meaning
and place the canonical field in parentheses, such as
`讀取範圍（read_scope）` or `停止條件（stop_condition）`. Keep raw canonical
keys inside packet payloads and evidence tables, not as the primary explanation.

## Loaded Skill References

Use concrete skill names or paths instead of free-form role descriptions.

| Substation task need | Required skill refs |
|---|---|
| Requirement | `team-specialist-intent-requirements`, `team-role-boundaries` |
| Scope or impact | `team-specialist-scope-impact`, `team-role-boundaries` |
| Architecture | `team-specialist-architecture-contract`, `team-role-boundaries` |
| Change delivery | `team-specialist-change-delivery`, `team-change-delivery-artifact`, `team-role-boundaries` |
| Memory/docs | `team-specialist-memory-docs`, `team-memory-docs-delivery-artifact`, `memory-ops` |
| Validation | `team-specialist-validation`, `team-validation-delivery-artifact` |
| Review | `team-specialist-review`, `team-review-delivery-artifact`, `quality-review-governance` |
| Security/reliability | `team-specialist-security-reliability`, `team-role-boundaries`, `security-sre` |
| Completion | `team-specialist-release-completion`, `team-completion-gate` |
| External research | `team-specialist-external-research`, relevant official-docs skill if available |

## Deep Read And Captain Coordination Read

Deep-read and captain coordination boundaries inherit the `Captain Boundary
Anchor / 隊長邊界錨點` in `Shared/policies/team-native-core.md`. Assign broad,
repetitive, external, or large-file inspection to `deep_read_scope`. Use
`captain_coordination_read_scope` only for the captain's minimum read needed to
receive artifacts, maintain the board, resolve blockers/conflicts, or confirm
authorization boundaries. If either side cannot read a relevant area, record it
in `unread_scope` and return blocked or unverified.

Deep read may discover scope gaps, but it does not authorize expansion. The
specialist reports the gap and stops unless the board is updated.

## Startup Monitoring

Record startup monitoring for every packet:

| Station type | First useful response default |
|---|---|
| Small read-only evidence | 2 to 5 minutes |
| Broad file or external research | 5 to 12 minutes |
| Isolated change delivery | 10 to 20 minutes |
| Authorized change-application | 5 to 15 minutes |
| Validation command branch | Command timeout plus 2 minutes |

Thresholds are monitoring defaults, not automatic failure claims. If setup
needs longer, record the reason in `standby_reason`.

Valid timeout actions are standby, replace, blocked, unverified, or ask the
Director.

The first response deadline and soft timeout are monitoring thresholds, not
failure declarations. When a channel is slow or unknown, send a status probe if
the platform permits it. A member that receives a status probe must immediately
pause its current action, report the exact current position, whether it is
blocked, and whether continuing is safe, then wait for an explicit captain
resume message. If the channel responds, keep the same role instance active and
update progress, extension, blocked state, or resume decision from that
response. The member may continue only after the captain records the response
and sends the explicit resume message. If the channel does not respond, record
it as unresponsive, blocked, or unverified and only then decide whether to open
a replacement.

Replacement opens a new channel generation. It does not cancel the original
channel unless cancellation is explicitly requested and acknowledged. Each
packet must name the late-result policy and late-result window so a late
artifact can still be received, compared with replacement output, and assigned
a neutral ledger decision.

## Artifact Routing And Ledgering

Before logging a returned artifact, check the packet, the returned artifact, and
only the minimum cited source or policy material needed to decide whether the
artifact should be logged in the synthesis ledger, routed onward, marked
blocked/unverified, or returned for scope clarification. Formal validation,
review, and memory/docs interpretation belong to their stations.

Returned artifacts must include:

```text
handoff_packet_id:
substation_task:
member_assignment:
specialist_deep_read_evidence:
```

Then use the matching delivery format from `team-task-board` or the dedicated
delivery artifact skill.

Late returned artifacts are still artifacts. Logging them, including them in
the synthesis ledger, routing them to an owner station, superseding them,
marking them out of scope or duplicate, or routing them to conflict review
requires a recorded neutral ledger decision and reason. Do not silently drop a
late artifact merely because a replacement channel already returned.

## Gotchas

- A station is a work container; a member assignment is one role instance bound
  to one substation task.
- A subagent, browser, command, MCP route, platform adapter, isolated workspace,
  or text artifact is an execution channel, not a specialist role.
- Channel unavailability never relaxes role boundaries or authorization scope.
- Standby means assigned but not evidence-complete.
- A wait timeout means status is unknown; it is not a failure, cancellation, or
  rejection without probe, hard-timeout, or explicit returned evidence.
- A status probe is a pause point. A responding member must not continue work
  until the captain sends an explicit resume message for that same role
  instance and channel.
- Replacement is not cancellation; late returns still need a neutral ledger
  decision.
- A packet without loaded skill references is not a formal handoff.
- Captain coordination read follows the core captain boundary and is not
  implementation, validation, review, memory/docs attribution, or completion
  evidence.
- A main-worktree implementation packet uses station-owned `change-delivery` as
  the primary route when authorization phase `implementation-change-delivery`,
  exact file allowlist, dirty diff read, and no protected actions are present;
  `change-application` is only fallback integration for a returned
  isolated/text artifact, explicit integration task, or assigned
  generated/deployed sync. If platform capability blocks delegation, the board
  must record a platform-nondelegable protected-action record.
- Missing work routes back to an eligible station or closes as blocked,
  unverified, or closed-with-director-risk.

## Constraints

This skill is read-only. It does not authorize source writes, memory writes,
commits, pushes, tags, releases, deployments, installs, mutating MCP calls, or
external state changes.
