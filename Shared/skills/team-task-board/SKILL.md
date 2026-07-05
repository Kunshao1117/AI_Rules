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

This skill owns the reusable Captain Team Board fields, station rows,
delivery-form choices, direct-exception register, and closeout checklist. Keep
this main file as the routing and hard-gate surface; put field catalogs,
templates, artifact details, and long checklists in `references/`.

Use it after the Director requests governed work such as source, workflow, fix,
build, debug, test, audit, skill, memory/docs, commit, handoff, public-contract,
or governance-impact work, or after the Director asks for a team, team member,
subagent, delegation, Team-Native, or equivalent dispatch. When Team mode is
not active because the request is pure conversation, a small stable answer, or
no-impact work, these board fields do not constrain ordinary non-team work and
must not be cited as Team-Native evidence.

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

Reference routing:

| Need | Read |
|---|---|
| Complete canonical board field list and field value catalog | `references/board-field-catalog.md` |
| Board header, table, specialist assignment, artifact formats, dispatch details, direct exceptions, and closeout checklist | `references/board-templates-and-delivery.md` |

## Team Object Model

Record `station_family`, `formal_station`, `substation_task`,
`member_assignment`, `execution_channel`, and `delivery_artifact` separately.
Stations are containers, members are role instances, channels are execution
routes, and artifacts are evidence. Do not collapse them.

Execution channels include read-only evidence branch, browser evidence branch,
CLI evidence branch, MCP read branch, platform adapter, station-owned
main-worktree change delivery, isolated workspace, text artifact,
station-owned authorized change-application gate, or a platform-nondelegable
protected-action record. Reduction is allowed only at substation task or member count while
preserving station families, roles, artifact types, and evidence.

## Board Selection

After Team mode is active, choose operation mode first.

Use a lightweight board for low-risk explanation or read-only inspection, a
full board for source/workflow/public-contract impact, and an experiment board
for sandbox/prototype work. All shapes still record operation mode, reduced
station reason, and blocked/unverified/not-applicable states when applicable.

In active Team mode, canonical `board_state` values are `draft`,
`formal-readonly`, and `formal-write`.
`draft` cannot dispatch formal specialists or satisfy formal evidence.
`formal-readonly` can run no-write evidence, deep-read, research, validation
planning, review evidence, and standby stations. `formal-write` requires
scope-bound authorization for the named phase, file set, station, command, or
protected action. Display labels such as "draft board" or "formal board" must
not be written back into machine trace values; legacy `formal` must be narrowed
to either `formal-readonly` or `formal-write`.

## Canonical Board Fields

Every formal station records the board field set summarized below. The complete
catalog lives in `references/board-field-catalog.md`; other skills reference
that file instead of copying the long list.

Director-facing display uses Traditional Chinese meaning first with the exact
field in parentheses, such as `任務板狀態（board_state）`. Display labels must
not translate, rename, or derive new machine fields; Director summaries must
not be English-code-first.

Required field groups:

```text
board_id, board_template, board_state, task_type, workflow_route,
operation_mode, operation_mode_reason, closeout_lane, phase, dispatch_wave,
yellow_classification, yellow_resolution_state, repair_loop_limit,
previous_wave_input, next_wave_start_condition, formal_evidence_eligibility,
implementation_authorization, go_evidence, authorization_source,
authorization_target, authorization_scope, authorization_phase,
authorization_evidence, authorization_expiry, authorization_resolution_state,
platform_mode_observed, platform_capability_route, station_family,
formal_station, substation_task, member_assignment, applicability,
station_state, evidence_state, station_lifecycle_state, station_mode, role_id,
role_instance_id, exclusive_task_scope, specialist_role_source,
assigned_specialist_skill, loaded_skill_refs, domain_label, handoff_packet_id,
handoff_ownership, context_visibility, requested_execution_channel,
channel_capability, channel_invocation_status, execution_route,
execution_channel, evidence_owner, role_boundary, direct_exception,
startup_started_at, first_response_deadline, last_progress_at, timeout_action,
standby_reason, allowed_inputs, allowed_tools, forbidden_actions,
output_artifact_format, stop_condition, delivery_artifact_type, delivery_artifact_id,
delivery_artifact_status, author_role, source_input, integrable_scope,
captain_authored, review_state, validation_state, memory_docs_state,
completion_condition, completion_state, source_deployed_pair, sync_direction,
sync_evidence
```

Trace audit fields that are not board-facing stay in
`Shared/policies/team-trace-evidence.md`.

`station_mode`, `context_visibility`, and `handoff_ownership` are mandatory on
applicable formal stations. Their complete value catalog lives in
`references/board-field-catalog.md`.

For main-worktree implementation, `station-owned` change delivery is the default
owner. `change-application` is a fallback integration posture for returned
isolated/text artifacts or explicitly scoped sync/application work.
`platform-nondelegable-gate` is valid only when the platform cannot delegate the
physical write or protected tool call to a station and the board records the
direct exception. It records coordination and scope evidence; it does not
transfer protected-action authority to the captain.

Missing any of these fields on an applicable formal station keeps the station
blocked or unverified and cannot support `complete`.

## Board Header Template

Full template details live in
`references/board-templates-and-delivery.md#board-header-template`.

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

Full board table details live in `references/board-templates-and-delivery.md#full-board-table`.

| Station family | Formal station | Substation task | Applicability | Execution channel or delivery form | Station state | Evidence state | Evidence owner | Role boundary | Direct exception record | Completion condition |
|---|---|---|---|---|---|---|---|---|---|---|

Default families include requirement replay, counter-evidence, impact map, plan
authorization, implementation, memory/docs delivery, validation, review, and
completion. Omitted families must be not-applicable, blocked, unverified, or
closed-with-director-risk with a reason.

## Specialist Assignment Template

Full assignment details live in `references/board-templates-and-delivery.md#specialist-assignment-template`.

Use one assignment per substation task:

```text
Station mode:
Context visibility:
Handoff ownership:
Role ID:
Role instance ID:
Exclusive task scope:
Allowed inputs:
Allowed tools:
Forbidden actions:
Output artifact format:
Stop condition:
```

The station handoff packet may add read scope, startup monitoring, dependencies,
and channel state. Do not copy the whole board field list into the packet.
Missing startup data keeps the station blocked or unverified and cannot support
a complete team trace.

## Delivery Forms

Full delivery form details and board-facing artifact formats live in
`references/board-templates-and-delivery.md#delivery-forms`.

Implementation forms are main-worktree change delivery, isolated change
delivery, text change delivery artifact, authorized change-application gate,
and captain substitute-authoring risk record. Main-worktree implementation
requires `station_mode: change-delivery`, authorization phase
`implementation-change-delivery`, exact file allowlist, dirty diff read,
`handoff_ownership: station-owned`, and `captain_authored: false`.
Authorized change-application is fallback only for returned isolated/text
artifacts, explicit integration tasks, or assigned generated/deployed sync.
Delivery form anchors: isolated change delivery; text change delivery artifact;
captain substitute authoring is not change delivery and never full Team-Native completion.

Board-facing artifact formats stay internal and use canonical English keys.
Director-facing summaries synthesize their meaning through
`Shared/policies/language-governance.md`.

```text
artifact_type: evidence_delivery
findings:
evidence:
risk:
recommendation:
blocking:
status:
artifact_type: implementation_change_delivery
changes:
files:
evidence:
risk:
memory_impact:
review_need:
blocking:
status:
artifact_type: memory_docs_delivery
memory_impact:
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
evidence:
risk:
recommendation:
blocking:
```

Detailed validation, review, memory/docs, and completion artifact rules stay in
their dedicated skills.

## Dispatch Rules

Detailed dispatch, monitoring, and direct-exception handling live in
`references/board-templates-and-delivery.md#dispatch-rules`.

Open only the current dispatch wave. Later waves wait for prior output or an
honest blocked/unverified/risk state. Review and validation start only after
change delivery exists or is honestly blocked/unverified/risk closed.

Broad/deep read and captain substitute limits follow the `Captain Boundary
Anchor / 隊長邊界錨點` in `Shared/policies/team-native-core.md`; this board only
records route, state, `deep_read_scope`, and the smallest unblock condition.

`formal-readonly` is no-write evidence. `formal-write` requires scope-bound
authorization for implementation change delivery, change application, memory,
git, release, deployment, install, or external mutation.

Main-worktree implementation in active Team mode defaults to a named,
station-owned main-worktree `change-delivery` station with authorization phase
`implementation-change-delivery`. Change application is a fallback
station-owned gate for returned isolated/text artifacts, explicit integration
tasks, or assigned generated/deployed-copy sync. Route either path to a
platform-nondelegable protected-action record only when the platform cannot
delegate the physical write or protected tool call; the board must record the
platform limitation, exact scope, source artifact, direct exception, and
residual state. Captain coordination records the returned delivery form; it
does not become change-delivery evidence.

Timeouts open probe/standby, not failure. A probed member pauses until
`status_probe_resume_state` and `status_probe_resume_sent_at` are recorded.
Replacement needs generation, reason, cancellation state, late-result policy,
and neutral ledger decisions. A late artifact remains an artifact:
`ignore-after-cancelled` applies only after cancellation is acknowledged and the
late-result window closes with no artifact returned. If an artifact returns,
record `returned_at`, `late_result_policy`, `late_result_window`,
`return_timing`, `receipt_decision`, and `receipt_decision_reason` using the
catalog values in `references/board-field-catalog.md`; do not silently discard
it because a replacement already returned.

## Direct Exception Register

Full register rules live in
`references/board-templates-and-delivery.md#direct-exception-register`.

A direct exception is allowed only for platform-nondelegable protected-action
records, tool-only status actions, hot-path status checks with no independent
evidence value, blocker/conflict/permission routing, or Director risk-closed
captain substitute authoring recorded as non-complete risk.
`direct` is not a station state, execution route, execution channel, platform
route, or execution mode. Record it only in `direct_exception` /
`direct_exceptions` with a station-specific reason, replacement evidence, and
residual state.

If two or more evidence-oriented stations use direct exceptions, each row must
name a station-specific reason, replacement evidence, residual state, and why
full Team-Native completion is not being claimed.

## Board Closeout Checklist

Full checklist lives in
`references/board-templates-and-delivery.md#board-closeout-checklist`.

Before any completion claim, confirm scope, authorization fields,
`station_mode`, `context_visibility`, `handoff_ownership`, implementation
change delivery, memory/docs delivery, validation, review, role separation,
actual diff inspection, Director-facing language governance, channel lifecycle,
route/state separation, source/deployed parity, `team-completion-gate`, and
`Shared/policies/team-trace-evidence.md`.
