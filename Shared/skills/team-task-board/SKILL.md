---
name: team-task-board
description: >
  [Infra] Task board and specialist artifact templates for
  captain-led programming work. Use when: 編程團隊治理已觸發，需要建立隊長任務板、
  專家站點、證據/變更交付件、隔離或文字交付、隊長受限例外紀錄或收尾檢查表。
  DO NOT use when: pure discussion, non-coding answers, or when team mode is not active.
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Team Task Board

## Purpose

Reusable Team Task Board, station, artifact, handoff packet, standby, and
completion templates. Use `programming-team-governance` for semantics,
`team-station-handoff-packet` for startup payloads, and `delegation-strategy`
for channel selection. Platform runners are channels, not role sources.
Stations are work containers, not people. Team members are assigned to
substation tasks through registered roles, and execution channels never become
role sources.

The shared entry sequence is owned by
`Shared/policies/workflow-orchestration.md`. This skill owns the board and
station templates used after the workflow route, authorization, operation mode,
board state, and dispatch wave are selected.

The board is the first executable Team-Native state, not a recap. Stations that
cannot start remain standby, blocked, unverified, unavailable, or not-authorized.

## Team Object Model

Record these objects separately before dispatch:

| Object | Meaning | Boundary |
|---|---|---|
| `station_family` | Capability family such as implementation, review, validation, memory/docs, or completion. | A family only groups explicitly assigned formal stations and substation tasks; it does not authorize work by itself. |
| `formal_station` | Governed board row owning applicability, state, dependencies, and acceptance condition. | A station is a work container, not a team member. |
| `substation_task` | One concrete task inside a formal station. | Smallest dispatchable unit. |
| `member_assignment` | One registered role instance assigned to one substation task. | A member assignment is not a station and cannot hold multiple task-scoped roles. |
| `execution_channel` | Read-only evidence branch, browser evidence branch, CLI evidence branch, MCP read branch, platform adapter, isolated workspace, text artifact, or protected captain gate. | A channel is not a role source and does not change role boundaries. |
| `delivery_artifact` | The returned evidence, change delivery, memory/docs attribution, validation, review, or completion artifact. | An artifact is evidence for a task; it is not final captain acceptance. |

Do not collapse these objects. A station is not a member, a member assignment is
not a station, and an execution channel is not a specialist role source.

## Template Selection

Choose exactly one board shape before dispatch: Lightweight board for
explanation, read-only inspection, narrow sync, or low-risk Yellow drift; Full
board for build, fix, debug, test, audit, commit prep, handoff, skill/rule
update, behavior docs, memory update, or cross-file work; Experiment board for
sandbox/prototype work with discard and upgrade rules.

Choose `operation_mode` before board shape. `daily` may use a lightweight board
only for reduced routine evidence and must record `operation_mode_reason`.
`full` is required for implementation, repair, bottom-layer refactor, cross-file
governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy
preparation, external-state readiness, or any source/workflow/public-contract
impact. Do not dispatch until the selected operation mode and board exist.

## Board State

A board is `draft`, `formal-readonly`, or `formal-write`. `draft` is pre-GO
planning. `formal-readonly` covers no-write evidence, deep-read, research,
validation planning, review evidence, and standby. `formal-write` is GO-backed
dispatch for change delivery, protected adoption/merge, memory/docs, validation,
review, completion, commit prep, or release prep. Lifecycle: draft ->
formal-readonly or formal-write -> wave-gated dispatch -> artifacts ->
review/validation/memory states -> protected adoption/merge decisions ->
completion audit.

Formal board lifecycle is wave-gated from promotion to completion audit.

## Board Header

Every board begins with compact fields: Board template:, Task type:, Workflow route:, Execution route:, Implementation authorization:, Channel capability:, Channel invocation status:, Delivery artifact status:, Allowed specialist roles:, Forbidden specialist roles:, Specialist role source:, Assigned specialist skill:, Domain label:, Requested execution channel:, Delivery artifact type:, Applicability, Execution channel, Evidence owner, Role boundary, Direct exception, Completion condition.

## Full Board Table

Full Board Table columns are Station family, Formal station, Substation task,
Applicability, Execution channel or delivery form, Station state, Evidence
state, Evidence owner, Role boundary, Direct exception record, and Completion
condition. Required station families are Requirement replay, Counter-evidence,
Impact map, Plan authorization, Implementation, Memory delivery, Short-loop
validation, Review, and Completion. Valid execution channels or delivery forms
are `read-only evidence branch`, `browser evidence branch`, `CLI evidence
branch`, `MCP read branch`, `isolated change delivery`, `text change delivery
artifact`, and `captain protective adoption/merge of returned qualified
artifacts`. State values such as `blocked`, `unverified`, `standby`,
`not-authorized`, `unavailable`, `closed-with-director-risk`, and
`not-applicable` are not execution channels or delivery forms.

## Required Team-Native Trace Evidence

Every applicable formal station records: Phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, repair loop limit, operation_mode,
operation_mode_reason, role_id, role_instance_id, exclusive_task_scope,
Authorization source, Authorization target, Authorization scope, Authorization phase, Authorization evidence, Authorization expiry, Authorization resolution state, Platform mode observed, authorization_source, authorization_target,
authorization_scope, authorization_phase, authorization_evidence,
authorization_expiry, authorization_resolution_state, platform_mode_observed,
Platform capability route: native / adapter / conditional / unavailable,
Specialist role source, Assigned specialist skill, Station family, Formal
station, Substation task, Member assignment, Loaded skill refs, Handoff packet
ID, Domain label, Requested execution channel, channel_capability / Channel
capability, channel_invocation_status / Channel invocation status:, execution_route
/ Execution route, Execution channel, station/evidence state, lifecycle, Deep
read scope, Captain verify read scope, Unread scope, startup_started_at,
first_response_deadline, last_progress_at, timeout_action, standby_reason,
Closeout lane, Yellow classification, Yellow resolution state, Delivery artifact
ID/type/status, Source/deployed pair, Sync direction, and Sync evidence.

`formal` requires a formal station, operation mode, open wave, assigned skill,
`role_id`, `role_instance_id`, owner, artifact format, and no forbidden
boundary. `draft-input-only` cannot satisfy acceptance.

## Reusable Scenario Templates

Short board-fill examples only; detailed examples live in
`Shared/policies/workflow-orchestration-scenarios.md` and are non-authorizing.

Templates: Read-Only Evidence Station Template (`formal-readonly` evidence
returns/blocks), Change Delivery Wave Template (`full`, scoped `formal-write`,
change delivery -> memory/docs plus validation -> independent review ->
completion audit), Failure Route-Back Template (finding station routes; it does
not repair), and Commit-Preflight Template (scan is `formal-readonly`; repairs,
sync, and memory phase need scoped `formal-write`).

## Wave Dispatch Rules

The captain dispatches only the current open wave. Later waves wait for prior output or an honest blocked/unverified/risk state. Review and validation of a change start only after change delivery exists or is honestly blocked. Completion starts after review, validation, memory/docs, and change delivery states exist.

`formal-readonly` stations can open without GO-write when they are strictly
read-only and have a handoff packet. `formal-write` stations require scoped
authorization for the write, protected adoption/merge, memory, git, release,
deployment, install, or external-mutation phase.

No-write does not mean no-team. Read-only exploration still uses
`formal-readonly` when it can shape source, workflow, validation, review, memory,
release, or governance decisions.

## Specialist Lifecycle Rules

Retain only when station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Record lifecycle state, retention reason, conversation health, reuse count, handoff summary when needed, startup thresholds, and closure reason. Valid lifecycle decisions are `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, and `blocked`. Never retain across role-exclusive boundaries; one task-scoped role instance holds one `role_id`.

## Fast Closeout Lane

Closeout lanes sit inside `operation_mode`: `light` for docs/generated-copy sync/low-risk wording, `standard` for policies, skills, matrices, audit logic, workflow semantics, memory/docs, and public contracts, and `release-grade` for commit, tag, release, deployment, install, external mutation, credentials, or operator readiness.

## Yellow Classification Rules

Every Yellow finding records classification and resolution state. Yellow affecting trace evidence, independent review, validation, memory/docs attribution, public contract, deployment sync, or release readiness becomes blocked, unverified, or Red. After two attempts for the same symptom, route to root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Specialist Assignment

Every specialist receives one substation task inside one formal station family
and one responsibility:

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

This is the skill dispatch package for one substation task. Large-file deep read
must be assigned as a bounded specialist substation task; the captain must not absorb, substitute, or deep read large files as the team evidence source.
Required boundary: large-file deep read must route to a bounded specialist or be marked blocked/unverified.

Evidence delivery artifact format:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## Change Delivery Artifact Types

Implementation work uses only these forms: Isolated workspace change delivery
(modify isolated copy and return diff summary; no main worktree, self-review,
memory, commit, push, or release), Text change delivery artifact (return
proposed edits with paths, rationale, tests; no write, integration claim, or
review acceptance), and Captain substitute-authoring risk record, not change
delivery (record no route and Director risk closure; never protective adoption,
change delivery, or full completion).

Executable template rule: a captain direct-exception route may appear only when
no isolated change delivery or text change delivery artifact can be produced,
and even then this is an exception that must be recorded as blocked,
unverified, or closed-with-director-risk unless the Director explicitly accepts
captain substitute authoring as a non-full-team risk state. Captain protective
adoption/merge is only protective adoption or merge of returned qualified
artifacts and is not a change delivery form.

Change delivery artifact fields: `delivery_artifact_id`, authorization_fields,
`author_role`, `source_input`, `integrable_scope`, 變更:, 檔案:, 證據:, 風險:,
`memory_impact`, `review_state`, `validation_state`, `memory_docs_state`,
`captain_authored`, 審查需求:, 是否阻塞:.

Memory/docs delivery artifact fields: `memory_impact`, authorization_fields,
status: memory_delivery / blocked / unverified / closed-with-director-risk,
`memory_delivery`, 證據:, 風險:, 是否阻塞:.

Validation identifies command, browser path, MCP read, or blocked condition; validation specialists do not repair implementation.

## Direct Exception Rules

The captain may record a Direct exception route only for a protected
captain-owned gate, tool-only status action, hot-path validation command with no
independent evidence value, captain protective adoption/merge of returned
qualified artifacts, or captain substitute authoring closed-with-director-risk.
Executable template rule: direct only when no isolated change delivery or text change delivery artifact can be produced. If two or more evidence stations use
captain direct-exception routes, each needs a station-specific exception,
replacement evidence, residual state, and not full team completion. Anchors:
Direct Exception Rules; Direct exception; Completion condition; Implementation
change delivery, memory delivery, review, and validation artifacts.

## Protective Adoption And Completion Authorization

Formal team completion requires implementation change delivery, memory/docs
delivery artifact, review delivery artifact, validation delivery artifact, board
authorization fields, and independent review. Missing implementation,
memory/docs, review, or validation delivery becomes `blocked`, `unverified`, or
`closed-with-director-risk`; closed-with-director-risk is not full team
completion. Implementation change delivery, memory delivery, review, and validation artifacts are the minimum full-team evidence set. Captain protective
adoption/merge can integrate returned qualified artifacts; it cannot replace the
specialist artifact itself.

## Workflow Entry Contract

Workflow entries load `programming-team-governance`, `delegation-strategy`, this skill, `team-specialist-registry`, applicable `team-specialist-*`, role-boundary, delivery, validation, review, memory/docs, and completion skills. Workflow name is only a route hint.

## Completion Rules

A task may be reported complete only when all applicable stations have returned
qualified artifacts, implementation was not self-reviewed, captain
direct-exception records are recorded, memory/git/release/external state stays
captain-owned, and
implementation change delivery, memory delivery, review, and validation
artifacts exist. If any station is blocked, unverified, or risk-closed, report
that non-complete state and name residual memory, validation, review, sync, or
trace gaps as risk.
