---
name: team-station-handoff-packet
description: >
  [Infra] Team station handoff packet for Team-First specialist startup,
  loaded skill refs, deep-read scope, standby, and timeout monitoring.
  Use when: 隊長要啟動隊員、建立正式站點派工包、傳遞技能引用、分配深讀範圍、設定待機或監控隊員啟動時間。
  DO NOT use when: 純對話、沒有團隊站點、或最終隊長裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Station Handoff Packet — Specialist Startup Contract

## Purpose

This skill defines the handoff packet that turns a board station into a bounded
specialist assignment for one substation task. The packet is the contract
between the captain board and one registered role instance assigned to one
concrete task. It prevents vague delegation, records startup monitoring, and
preserves role boundaries when a station is retained, put on standby, replaced,
or closed.

Use this with `programming-team-governance`, `team-task-board`,
`team-specialist-registry`, and `team-role-boundaries`. A handoff packet is not
authorization for protected mutation. It carries only the authorization already
resolved by the board.

Station startup follows `Shared/policies/workflow-orchestration.md`. The packet
must be issued only after the workflow route, authorization state, operation
mode, board state, dispatch wave, previous-wave input, next-wave start
condition, and formal evidence eligibility are known.

## Trigger Conditions

Use this skill after a Captain Team Board exists and before opening, retaining,
or replacing any formal specialist station.

Do not use it to authorize writes, replace the board, decide final review
state, or mutate memory, git, release, deployment, install, or external state.

## Procedure

### 1. Build The Packet

Create one packet per substation task inside one formal station. One packet
must contain exactly one role, one concrete task, one output artifact format,
and one stop condition. Do not bundle multiple roles, multiple tasks, multiple
output formats, or multiple stop conditions into one packet. Do not reuse a
packet across role-exclusive boundaries or across different `role_id` values.
In the same task trace, a `role_instance_id` with `exclusive_task_scope: task`
must not hold more than one `role_id` or more than one substation task. Do not
reuse a packet across implementation to review, validation failure to repair,
memory attribution to memory mutation, or completion audit to final acceptance.

`handoff_packet_id` is the canonical field name. `dispatch_packet_id` must be used
only as a legacy alias in returned artifacts; new traces use
`handoff_packet_id`.

`formal-readonly` packets must assign only read-only evidence work. If the
station needs source, memory, git, release, deployment, install, or external
mutation, the packet is blocked until a write-capable formal board and matching
authorization exist.

Required fields:

```text
handoff_packet_id:
operation_mode:
operation_mode_reason:
board_state:
task_type:
workflow_route:
execution_route:
station_state:
evidence_state:
station_family:
formal_station:
substation_task:
member_assignment:
station:
role_id:
role_instance_id:
exclusive_task_scope:
assigned_specialist_skill:
loaded_skill_refs:
specialist_role_source:
authorization_source:
authorization_target:
authorization_scope:
authorization_phase:
authorization_evidence:
authorization_expiry:
authorization_resolution_state:
platform_mode_observed:
domain_label:
one_concrete_task:
allowed_inputs:
read_scope:
allowed_paths_or_resources:
deep_read_scope:
captain_verify_read_scope:
unread_scope:
allowed_tools:
forbidden_actions:
requested_execution_channel:
channel_capability:
channel_invocation_status:
execution_channel:
delivery_artifact:
source_deployed_pair:
sync_direction:
sync_evidence:
startup_started_at:
first_response_deadline:
first_response_at:
last_progress_at:
startup_decision:
timeout_action:
standby_reason:
resume_condition:
output_artifact_format:
delivery_artifact_type:
integrable_scope:
review_dependency:
validation_dependency:
memory_docs_dependency:
stop_condition:
handoff_summary:
```

`station` is allowed only as a legacy alias for `formal_station`; new packets must
use `station_family`, `formal_station`, `substation_task`, and
`member_assignment` as separate fields.

### 2. Pass Skills As References

`loaded_skill_refs` must list concrete skill names or paths that the specialist
must read. Use direct skill references over free-form role descriptions.

Minimum refs:

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

### 3. Split Deep Read From Verify Read

Assign broad, repetitive, or large-file inspection to `deep_read_scope`.
Assign captain verification to the minimum risky snippets in
`captain_verify_read_scope`. If either side cannot read a relevant area, record
it in `unread_scope`.

### 4. Set Startup Monitoring

Every packet records:

- `startup_started_at`: local timestamp when the channel is requested.
- `first_response_deadline`: expected first useful return or heartbeat.
- `last_progress_at`: latest returned progress evidence.
- `timeout_action`: standby, replace, mark blocked, mark unverified, or ask
  Director.

Required first-response monitoring defaults:

| Station type | Required threshold |
|---|---|
| Small read-only evidence | 2 to 5 minutes |
| Broad file or external research | 5 to 12 minutes |
| Isolated change delivery | 10 to 20 minutes |
| Validation command branch | command timeout plus 2 minutes |

Thresholds are monitoring defaults, not automatic failure claims. If the task
needs longer setup, record the reason in `standby_reason`.

### 5. Accept Returned Artifacts

Before accepting a returned artifact, the captain verify-reads the packet, the
artifact, and enough source or policy material named in
`captain_verify_read_scope` to decide whether the artifact is integrable,
blocked, unverified, or closed-with-director-risk.

Evidence delivery artifacts include:

```text
handoff_packet_id:
substation_task:
member_assignment:
specialist_deep_read_evidence:
發現:
證據:
風險:
建議:
是否阻塞:
```

Change delivery artifacts include:

```text
handoff_packet_id:
substation_task:
member_assignment:
specialist_deep_read_evidence:
變更:
檔案:
證據:
風險:
memory_impact:
審查需求:
是否阻塞:
```

Memory/docs delivery artifacts include:

```text
handoff_packet_id:
substation_task:
member_assignment:
specialist_deep_read_evidence:
memory_impact:
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
證據:
風險:
是否阻塞:
```

## Gotchas

- A station is a work container, not a member. A member assignment is one
  registered role instance bound to one substation task.
- A subagent, browser, command, or MCP route is an execution channel, not the
  specialist role.
- An execution channel cannot become `specialist_role_source`, and channel
  availability cannot relax the selected role boundary.
- `blocked`, `unverified`, `standby`, `unavailable`, `not-authorized`, and
  `closed-with-director-risk` are states. They must not be used as
  `execution_route` or `execution_channel`.
- `operation_mode` controls execution depth before board template, board state,
  closeout lane, or station set. `daily` is reduced Team-Native mode, not a
  no-team route.
- `role_id`, `role_instance_id`, and `exclusive_task_scope` prove role identity
  and same-task exclusivity. A role instance cannot become a second specialist
  role inside the same task.
- Standby means the station is assigned but not yet evidence-complete.
- A packet without loaded skill references is not a formal Team-First handoff.
- A packet with more than one role, concrete task, output artifact format, or
  stop condition is not a valid specialist handoff; split it into substation
  tasks.
- A captain deep-reading everything is a captain direct-exception record, not
  full team separation.
- Deep-read does not authorize scope expansion. If the specialist discovers
  required material outside the packet, it must report the gap and stop or ask
  for a packet update.
- Captain verification-read is not substitute authoring. Missing work routes
  back to an eligible station or becomes blocked, unverified, or
  closed-with-director-risk.

## Constraints

- This skill is read-only.
- It does not authorize source writes, memory writes, commits, pushes, releases,
  deployments, installs, or mutating MCP calls.
- It does not replace `team-task-board`; it fills the station handoff and
  startup-monitor fields inside that board.
