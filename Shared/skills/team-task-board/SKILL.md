---
name: team-task-board
description: >
  [Infra] Task board and specialist artifact templates for
  captain-led programming work. Use when: 編程團隊治理已觸發，需要建立隊長任務板、
  專家站點、證據/變更交付件、隔離或文字交付、隊長受限例外紀錄或收尾檢查表。
  DO NOT use when: pure discussion, non-coding answers, or when team mode is not active.
metadata:
  author: antigravity
  version: "1.2"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Task Board

## Purpose

This skill owns the reusable Captain Team Board, station rows, board field list,
delivery-form choices, direct-exception register, and board-facing closeout
checklist. Other Team-Native skills reference this file instead of duplicating
the board fields.

Source of truth chain:

| Need | Source |
|---|---|
| Team-Native priority, station-first rule, delivery sequence, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow route, operation mode, board state, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Authorization fields and natural-language binding | `Shared/policies/authorization-resolution.md` |
| Full trace field audit and invalid trace patterns | `Shared/policies/team-trace-evidence.md` |
| Role boundary checks | `Shared/skills/team-role-boundaries/SKILL.md` |
| Station handoff payloads | `Shared/skills/team-station-handoff-packet/SKILL.md` |
| Completion gate | `Shared/skills/team-completion-gate/SKILL.md` |

## Team Object Model

Record these objects separately before dispatch:

| Object | Meaning | Boundary |
|---|---|---|
| `station_family` | Capability family such as requirement, impact, implementation, review, validation, memory/docs, or completion. | Groups assigned formal stations only; does not authorize work. |
| `formal_station` | Governed board row owning applicability, state, dependencies, and completion condition. | A station is a work container, not a person. |
| `substation_task` | One concrete task inside a formal station. | Smallest dispatchable unit. |
| `member_assignment` | One registered role instance assigned to one substation task. | A member assignment is not a station and cannot hold multiple task-scoped roles. |
| `execution_channel` | Read-only evidence branch, browser evidence branch, CLI evidence branch, MCP read branch, platform adapter, isolated workspace, text artifact, or protected captain gate. | A channel is not a role source. |
| `delivery_artifact` | Returned evidence, change delivery, memory/docs attribution, validation, review, or completion artifact. | Evidence for a task; not final captain acceptance. |

Do not collapse these objects. Reduction is allowed only at substation task or
member-count level while preserving station families, formal stations, role
boundaries, artifact types, and completion evidence.

## Board Selection

Choose operation mode before board shape.

| Board shape | Use when | Boundary |
|---|---|---|
| Lightweight board | Explanation, read-only inspection, narrow generated-copy sync, or low-risk Yellow drift. | Must still record operation mode, reduced station reason, and blocked/unverified/not-applicable states. |
| Full board | Build, fix, debug, test, audit, commit prep, handoff, skill/rule update, memory/docs impact, behavior docs, or cross-file work. | Required for source/workflow/public-contract impact. |
| Experiment board | Sandbox/prototype work. | Must record discard/upgrade route and cannot imply production completion. |

Board state values are `draft`, `formal-readonly`, and `formal-write`.
`draft` cannot dispatch formal specialists or satisfy acceptance.
`formal-readonly` can run no-write evidence, deep-read, research, validation
planning, review evidence, and standby stations. `formal-write` requires
scope-bound authorization for the named phase, file set, station, command, or
protected action.

## Canonical Board Fields

Every formal station records the board field set below. Keep this long list here
and reference it from other skills.

Director-facing display must not expose this as a raw English-only field list.
When showing board fields to the Director, write the Traditional Chinese meaning
first and keep the exact field in parentheses, for example
`任務板狀態（board_state）`, `正式站點（formal_station）`, or
`交付件狀態（delivery_artifact_status）`. These labels are display aids only;
do not translate, rename, or derive new canonical machine fields from them.
This applies to board headers, station tables, closeout reports, and handoff
summaries. A raw canonical field list may remain in this source section, but the
Director-facing summary must not be English-code-first.

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
requested_execution_channel
channel_capability
channel_invocation_status
execution_route
execution_channel
evidence_owner
role_boundary
direct_exception
replacement_evidence
deep_read_scope
captain_coordination_read_scope
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
timeout_action
standby_reason
resume_condition
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

Trace audit fields that are not board-facing stay in
`Shared/policies/team-trace-evidence.md`.

## Board Header Template

```text
Board template:
Board state:
Task type:
Workflow route:
Operation mode:
Implementation authorization:
Authorization scope:
Phase:
Dispatch wave:
Allowed specialist roles:
Forbidden specialist roles:
Direct exceptions:
Completion condition:
```

## Full Board Table

| Station family | Formal station | Substation task | Applicability | Execution channel or delivery form | Station state | Evidence state | Evidence owner | Role boundary | Direct exception record | Completion condition |
|---|---|---|---|---|---|---|---|---|---|---|

Default station families are requirement replay, counter-evidence, impact map,
plan authorization, implementation, memory/docs delivery, validation, review,
and completion. Omit a family only by marking it not-applicable, blocked,
unverified, or closed-with-director-risk with a reason.

Valid execution channels or delivery forms are:

- `read-only evidence branch`
- `browser evidence branch`
- `CLI evidence branch`
- `MCP read branch`
- `isolated change delivery`
- `text change delivery artifact`
- `authorized change-application gate`
- `protected captain gate`

State values such as `blocked`, `unverified`, `standby`, `unavailable`,
`not-authorized`, `not-applicable`, and `closed-with-director-risk` are not
execution channels.

## Specialist Assignment Template

Use one assignment per substation task:

```text
Station family:
Formal station:
Substation task:
Member assignment:
Role:
Role ID:
Role instance ID:
Exclusive task scope:
One concrete task:
Allowed inputs:
Allowed tools:
Forbidden actions:
Output artifact format:
Stop condition:
```

The station handoff packet may add read scope, startup monitoring, dependencies,
and channel state. Do not copy the whole board field list into the packet.
Before dispatch, pair this assignment with a startup-complete handoff packet
containing `handoff_packet_id`, `role_id`, `role_instance_id`,
`assigned_specialist_skill`, `read_scope`, `allowed_tools`, `forbidden_actions`,
channel state, `delivery_artifact_type`, and `stop_condition`. Missing startup
data keeps the station blocked or unverified and cannot support a complete team
trace.

## Delivery Forms

Implementation work uses one of these forms:

| Form | Meaning | Boundary |
|---|---|---|
| Isolated change delivery | Specialist modifies an isolated copy and returns diff/evidence. | No main worktree write, self-review, memory mutation, git, release, deploy, install, or external mutation. |
| Text change delivery artifact | Specialist returns proposed edits with paths, rationale, evidence, risk, and memory impact. | No integration claim or review acceptance. |
| Captain substitute-authoring risk record | No qualified delivery route exists and the Director explicitly closes that risk. | Not change delivery and never full Team-Native completion. |

Board-facing artifact formats:

```text
Evidence delivery:
發現:
證據:
風險:
建議:
是否阻塞:
```

```text
Implementation change delivery:
變更:
檔案:
證據:
風險:
memory_impact:
審查需求:
是否阻塞:
```

```text
Memory/docs delivery:
memory_impact:
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
證據:
風險:
是否阻塞:
```

Detailed validation, review, memory/docs, and completion artifact rules stay in
their dedicated skills.

## Dispatch Rules

Open only the current dispatch wave. Later waves wait for prior output or an
honest blocked/unverified/risk state. Review and validation of a change start
only after change delivery exists or is explicitly blocked/unverified/risk
closed. Completion starts after implementation, memory/docs, validation, and
review states exist.

Large-file deep read routes to a bounded specialist station. The captain must not absorb, substitute, or deep read large files as the team evidence source;
when no route exists, record blocked or unverified with the smallest unblock
condition.

`formal-readonly` stations can open without write authorization when they are
strictly read-only and have a handoff packet. `formal-write` stations require
scope-bound authorization for the write, change application, memory, git,
release, deployment, install, or external-mutation phase.

## Direct Exception Register

A direct exception is allowed only for protected captain-owned gates, tool-only
status actions, hot-path status checks with no independent evidence value,
blocker/conflict/authorization handling, or Director-accepted captain substitute
authoring recorded as non-complete risk.

If two or more evidence-oriented stations use direct exceptions, each row must
name a station-specific reason, replacement evidence, residual state, and why
full Team-Native completion is not being claimed.

## Board Closeout Checklist

Before the board supports any completion claim, check:

- Scope matches the approved file set and exclusions.
- Authorization fields are present for every write/protected phase.
- Implementation change delivery, memory/docs delivery, validation, and review
  states are present or honestly blocked/unverified/risk closed.
- Implementation and review are not owned by the same role instance.
- Captain receipt or status synthesis did not become substitute implementation,
  validation, review, or memory/docs attribution.
- Route fields contain routes/channels/forms, while blocked/unverified/standby
  and closed-with-director-risk remain state values.
- Source/deployed pairs have sync direction and parity evidence when applicable.
- Completion state follows `team-completion-gate` and trace evidence follows
  `Shared/policies/team-trace-evidence.md`.
