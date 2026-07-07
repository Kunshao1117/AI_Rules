---
name: team-task-board
description: >
  團隊任務板與交付件模板（Infra）：Task board and specialist artifact templates for
  captain-led programming work. Use when: 編程團隊治理已觸發，需要建立隊長任務板、
  專家站點、證據/變更交付件、隔離或文字交付、隊長受限例外紀錄或收尾檢查表。
  DO NOT use when: 純討論、非程式答覆，或 Team mode 尚未啟動；
  English: pure discussion, non-coding answers, or inactive team mode.
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

This skill is the routing and hard-gate surface for Captain Team Board work. Keep canonical field
catalogs, full templates, artifact formats, dispatch details, direct-exception rules, and closeout
checklists in `references/`.

Use it after the Director requests governed source, workflow, fix, build, debug, test, audit,
skill, memory/docs, commit, handoff, public-contract, governance-impact, team, subagent,
delegation, or Team-Native dispatch work. Do not cite these board fields as Team-Native evidence
for pure conversation, small stable answers, or no-impact work where Team mode is inactive.

## Source Chain

- `Shared/policies/team-native-core.md`: Team-Native priority, station-first rule, delivery
  sequence, and completion boundary.
- `Shared/policies/workflow-orchestration.md`: Workflow route, operation mode, board state,
  dispatch waves, and source/deployed sync.
- `Shared/policies/authorization-resolution.md`: Authorization fields and natural-language
  binding.
- `Shared/policies/team-trace-evidence.md`: Full trace field audit and invalid trace patterns.
- `Shared/skills/team-role-boundaries/SKILL.md`: Role boundary checks.
- `Shared/skills/team-station-handoff-packet/SKILL.md`: Station handoff payloads.
- `Shared/skills/team-completion-gate/SKILL.md`: Completion gate.
- `references/board-field-catalog.md`: Canonical board fields and value catalog.
- `references/board-templates-and-delivery.md`: Board templates, assignment payloads, delivery
  forms, dispatch rules, direct exceptions, and closeout checklist.

## Team Object Model

Record `station_family`, `formal_station`, `substation_task`, `member_assignment`,
`execution_channel`, and `delivery_artifact` separately. Stations are containers, members are role
instances, channels are execution routes, and artifacts are evidence. Do not collapse them.

Reduction is allowed only at substation task or member count while preserving station families,
roles, artifact types, evidence ownership, and completion honesty. Use
`references/board-templates-and-delivery.md#full-board-table` for valid execution channels and
delivery forms.

## Board Selection

After Team mode is active, choose operation mode first.

Use a lightweight board for low-risk explanation or read-only inspection, a full board for
source/workflow/public-contract impact, and an experiment board for sandbox/prototype work. All
shapes still record operation mode, reduced station reason, and blocked/unverified/not-applicable
states when applicable.

In active Team mode, canonical `board_state` values are `draft`, `formal-readonly`, and
`formal-write`. `draft` cannot dispatch formal specialists or satisfy formal evidence.
`formal-readonly` can run no-write evidence, deep-read, research, validation planning, review
evidence, and standby stations. `formal-write` requires scope-bound authorization for the named
phase, file set, station, command, or protected action. Display labels such as "draft board" or
"formal board" must not be written back into machine trace values; legacy `formal` must be narrowed
to either `formal-readonly` or `formal-write`.

## Required Board References

Use references instead of copying long lists or templates into this file:

- Field set and values: `references/board-field-catalog.md#canonical-board-fields` and
  `references/board-field-catalog.md#field-value-catalog`.
- Board header and station table: `references/board-templates-and-delivery.md#board-header-template`
  and `references/board-templates-and-delivery.md#full-board-table`.
- Specialist assignment payload:
  `references/board-templates-and-delivery.md#specialist-assignment-template`.
- Delivery forms and artifact formats:
  `references/board-templates-and-delivery.md#delivery-forms`.
- Dispatch, timeout, replacement, and late-result handling:
  `references/board-templates-and-delivery.md#dispatch-rules`.
- Direct exception register:
  `references/board-templates-and-delivery.md#direct-exception-register`.
- Closeout checklist:
  `references/board-templates-and-delivery.md#board-closeout-checklist`.

Director-facing display uses Traditional Chinese meaning first with exact field names in
parentheses when precision is needed. Board-facing machine keys stay canonical English and must not
be translated, renamed, or derived locally.
Team-member delivery artifacts and board-facing payloads are internal evidence and must not be
pasted into the Director-facing body; the captain must synthesize the artifacts into Traditional
Chinese meaning-first reports.
Director-facing tables must use Traditional Chinese column labels as primary labels. When canonical
fields are needed, append them after the Chinese label, such as `完成狀態（completion_state）`.

## Hard Gates

- Every applicable formal station records the canonical board field set from
  `references/board-field-catalog.md`; missing required fields keeps the station blocked or
  unverified and cannot support `complete`.
- `station_mode`, `context_visibility`, and `handoff_ownership` are mandatory on applicable formal
  stations.
- Current external evidence is requested through board grounding fields and routed to a formal
  `external-research` station; the captain may log and route the request but does not become the
  evidence owner. Downstream stations consume `external_research_artifact_id` and preserve
  `partial`, `no-evidence`, `conflicted`, `blocked`, and `unverified` states instead of upgrading
  them to verified evidence.
- Returned formal station artifacts include a `minimal_reference_packet` with read scope,
  specialist evidence, canonical rule references, unread scope, missing evidence, and recommended
  transition. Missing required packet fields keep the artifact unverified or routed back to the
  owner station; captain broad search cannot repair station-owned evidence.
- Main-worktree implementation defaults to a station-owned `change-delivery` station under
  `formal-write`, authorization phase `implementation-change-delivery`, exact file allowlist, dirty
  diff read, `handoff_ownership: station-owned`, and `captain_authored: false`.
- `change-application` is a station-owned fallback for returned isolated/text artifacts, explicit
  integration work, or assigned generated/deployed-copy sync.
- `platform-nondelegable-gate` is valid only when the platform cannot delegate the physical write or
  protected tool call; it records scope and direct-exception evidence without transferring
  protected-action authority to the captain.
- Open only the current dispatch wave. Later waves wait for returned output or an honest
  blocked/unverified/risk state.
- Review and validation start only after the implementation or change-application handoff bundle
  exists or is honestly blocked, unverified, or risk-closed.
- Memory/docs starts only after validation and review reach terminal evidence states. An
  implementation artifact may provide `memory_impact` and `memory_docs_handoff`, but memory/docs
  disposition consumes the validated and reviewed artifact chain.
- `full-completion`, commit-ready, and release-ready planning must bind `closeout_target`, protected
  memory phase applicability, memory card scope, and the `memory_commit` phase before those
  protected phases become eligible. This is an in-flow protected branch, not an ad hoc tail
  authorization.
- `source-level` approval alone does not authorize memory mutation. It may close the source layer
  with `protected-follow-up-pending`, while `protected-memory-write` and `protected-memory-commit`
  require their own scope-bound protected authorization.
- `direct` is not a station state, execution route, execution channel, platform route, or execution
  mode. Record exceptions only in `direct_exception` / `direct_exceptions`.

## Completion Boundary

Before any completion claim, apply
`references/board-templates-and-delivery.md#board-closeout-checklist`,
`Shared/skills/team-completion-gate/SKILL.md`, and `Shared/policies/team-trace-evidence.md`.
Report unresolved evidence gaps as `blocked`, `unverified`, or `closed-with-director-risk`.
