---
name: programming-team-governance
description: >
  [Infra] Captain-led programming team governance. Use when: 編程、開發、修復、除錯、測試、
  健檢、提交、交接、技能/規則治理，或 source/workflow tasks need captain trigger, team routing,
  role-exclusive specialists, evidence branches, isolated/text change delivery, or execution-channel boundaries.
  DO NOT use when: pure discussion or non-coding no-source tasks.
metadata:
  author: antigravity
  version: "1.3"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Captain-Led Programming Team Governance

## Purpose

Use this skill as the on-demand operating guide for captain-led Team-Native
work. It tells the captain how to route, board, dispatch, supervise, receive,
and report without copying the hard rules into every workflow or specialist
skill.

Source of truth:

| Need | Read first |
|---|---|
| Team-Native priority, station-first rule, role separation, delivery sequence, direct exceptions, and completion boundary | `Shared/policies/team-native-core.md` |
| Workflow route, operation mode, board state, dispatch waves, transition rules, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Scope-bound authorization, natural-language binding, protected phases, and expiry | `Shared/policies/authorization-resolution.md` |
| Required task trace fields, invalid trace patterns, and trace audit semantics | `Shared/policies/team-trace-evidence.md` |
| Board fields, station rows, delivery forms, and template-level checklists | `Shared/skills/team-task-board/SKILL.md` |

This skill adds operational sequence and editing hygiene only. If a hard rule is
already in a policy, cite the policy instead of restating it here.

Director-facing plans, board summaries, dispatch summaries, and closeout reports
must describe the Traditional Chinese meaning first and keep the canonical field
code in parentheses when field names are needed. Do not present raw English-only
board, trace, or handoff field lists as the primary explanation.

## Trigger And Route

Enter captain-led handling when the task touches source, workflow, validation,
review, memory/docs, commit, release, deployment, install, generated copies,
public contracts, governance rules, or broad evidence that can shape those
areas. Explicit workflow names are route hints, not authorization.

Before broad reading, evidence gathering, implementation, validation, review,
memory/docs attribution, commit prep, release prep, or completion claims:

1. Classify the task route and risk surface.
2. Resolve the current authorization target, scope, phase, evidence, and expiry.
3. Select operation mode and board state through the workflow orchestration policy.
4. Create or reuse the Captain Team Board from `team-task-board`.
5. Assign stations and role-exclusive specialists before choosing execution channels.

## 已變更檔案併修防線

Before changing an already modified file, the role instance holding the current
write station must run this guard. If the captain is the actor, record it as a
direct exception or captain-owned gate, not default station work:

1. Read the current diff and nearby source context for every file in the allowed
   scope.
2. Identify whether existing changes are from the Director, another station, a
   generated copy, or the current station. If ownership is unclear and the edit
   can overwrite work, stop and return blocked/unverified.
3. Modify the existing reasonable section instead of appending a new duplicate
   block at the end of the file.
4. Replace or consolidate duplicated rules. Do not stack another patch that says
   the same rule in different words.
5. If a rule belongs to `team-native-core`, `workflow-orchestration`,
   `authorization-resolution`, or `team-trace-evidence`, cite that policy and
   keep only task-specific operating steps in the skill.
6. Keep the detailed board field list in `team-task-board`; other skills must
   reference it rather than copying the full list.
7. Keep delivery artifact format details in the delivery artifact skills unless
   `team-task-board` needs the compact board-facing form.
8. Do not put the same rule in core policy, workflow entry, board skill, and
   specialist skill at once. Pick the source of truth, then reference it.
9. Preserve role exclusivity, change delivery separation, validation/review
   separation, memory/docs separation, and completion gate requirements when
   condensing text.
10. Do not touch hooks, hook tests, generated/deployed copies, memory, git, or
    release state unless the current station explicitly owns that scope.

## Board And Station Use

Use `team-task-board` as the only board template owner. This skill should name
the board requirement, not duplicate the field list.

Required station families stay visible on the board when applicable:
requirement replay, counter-evidence, impact map, plan authorization,
implementation change delivery, memory/docs delivery, validation, review, and
completion. A station can close only as returned, blocked, unverified,
not-applicable, or closed-with-director-risk according to the trace and
completion policies.

Use `team-station-handoff-packet` to turn one board row into one bounded
assignment. A handoff packet carries resolved board scope; it does not grant new
authorization.

## Role And Delivery Boundaries

Use `team-role-boundaries` plus `team-specialist-registry` for role identity.
The captain owns routing, authorization interpretation, supervision, delivery
receipt, board status synthesis, blocker/conflict handling, protected
memory/git/release/deploy/install gates, and final Director-facing reporting.

Specialists own bounded delivery artifacts only:

| Work | Required delivery boundary |
|---|---|
| Implementation | Isolated change delivery or text change delivery artifact; no self-review, memory write, git, release, deploy, install, or external mutation. |
| Memory/docs | Memory/docs delivery artifact with impact and proposed attribution; no memory mutation or final acceptance. |
| Validation | Non-mutating validation evidence; no repair of the implementation under validation. |
| Review | Independent review delivery artifact from a role that did not author the change. |
| Completion | Completion audit evidence; no protected mutation or final captain acceptance. |

If a delivery route is unavailable, record blocked/unverified or
closed-with-director-risk. Do not convert the captain into the primary
implementation, review, validation, or memory attribution worker and then claim
full Team-Native completion.

## Dispatch And Integration Procedure

1. Load the workflow and policy refs needed for the task.
2. Run the already-changed-file integration guard.
3. Build or promote the board through `team-task-board`.
4. Prepare station handoff packets before dispatch. They must include
   `handoff_packet_id`, `role_id`, `role_instance_id`,
   `assigned_specialist_skill`, `read_scope`, `allowed_tools`,
   `forbidden_actions`, channel state, `delivery_artifact_type`, and
   `stop_condition`, plus loaded skill refs, dependencies, startup monitoring,
   and output format. Missing startup data keeps the station blocked or
   unverified.
5. Dispatch only the current eligible wave. Later waves wait for returned,
   blocked, unverified, or risk-closed input from previous waves.
6. Supervise channel lifecycle without treating wait timeouts as failures. If a
   channel misses its first response or soft timeout, send a status probe when
   possible. A probed member must pause current action, report current position,
   blocker state, and safe-to-continue state, then wait. The captain must record
   that response and send an explicit resume message before the responding
   channel continues inside the same role and station. Unresponsive channels may
   be marked blocked/unverified and replaced with a recorded late-result policy.
   Replacement does not cancel the original channel unless cancellation is
   explicit, and late artifacts still require a receipt decision.
7. Receive artifacts, update the board, and route formal checking to validation,
   review, memory/docs, or completion stations as applicable.
8. Apply changes only through a station-owned authorized change-application
   station held by a named role instance, or through a recorded captain-owned
   gate when the platform cannot delegate the write or a protected direct
   exception applies; the captain must not rewrite returned artifacts as
   captain-owned evidence or full completion.
9. Run validation, independent review, memory/docs disposition, and completion
   gate as separate states before claiming completion.

## Direct Exceptions

Direct captain handling is limited to Director communication, authorization
interpretation, board maintenance, delivery receipt, blocker/conflict handling,
protected state gates, final Director-facing reporting, tool-only status checks,
or hot-path non-mutating status checks with no independent evidence value.

Every direct exception must name the station, reason, replacement evidence, and
residual state. Generic speed, convenience, small task size, or channel friction
is not enough.

## Output

Return operational findings in this form:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

For implementation closeout, also report changed files, de-duplication or
reference moves, preserved semantics, newly added integration guard, residual
risk, and whether the station is blocked.
