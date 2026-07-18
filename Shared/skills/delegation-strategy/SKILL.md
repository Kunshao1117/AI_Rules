---
name: delegation-strategy
description: >
  隊長派工與委派管道治理（Infra）：Vendor-neutral captain dispatch and Delegation Gate for captain-led stations,
  role-exclusive specialists, evidence/browser/CLI branches, MCP tool/read paths,
  isolated/text change delivery artifacts, and review boundaries.
  Use when: 判斷隊長制、direct_exception 記錄、站點隊員或證據/變更交付管道。
  DO NOT use when: 瀏覽器測試已確定（用 browser-testing）、CLI 掃描已確定（用 code-audit）。
metadata:
  author: antigravity
  version: "6.2"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Captain Dispatch And Delegation Strategy

Use after captain-led mode is active and the Captain Team Board exists. This
skill selects execution channels and delivery forms; it does not own team
semantics, role identity, board fields, authorization, validation, review, or
completion.

## Reference List

| Need | Read |
|---|---|
| Team semantics and station sequence | `programming-team-governance`, `Shared/policies/workflow-orchestration.md` |
| Role source and boundaries | `team-specialist-registry`, `team-role-boundaries` |
| Board fields and handoff packets | `team-task-board`, `team-station-handoff-packet` |
| Channel routing details, same-wave checks, and long gates | `references/team-dispatch-gates.md` |
| CLI branch SOP and prompt skeleton | `references/cli-delegation-sop.md`, `references/cli-capability-matrix.md`, `references/cli-prompt-skeleton.md` |
| Review lifecycle boundary | `quality-review-governance` |

## Captain Trigger Gate

Captain-led mode is active when the current Director request asks for governed
work such as governance, workflow, fix, build, debug, test, audit, skill,
memory/docs, commit, handoff, source, generated copies, public contract, or
equivalent change-shaping work. Requests for team, team member, subagent,
delegation, Team-Native, or equivalent dispatch also activate it. Pure
conversation, small stable factual answers, and no-impact work may remain
outside the Team-Native board flow.

When Team mode is not active, ordinary lifecycle, scoped authorization, and
protected gates still apply without Captain Team Board evidence. In active Team
mode, `formal-readonly` is the no-write board state for evidence that can shape
source, workflow, validation, review, memory, release, or governance decisions.

## Task Type And Dispatch Pre-Gate

When captain-led mode is active, classify task type before any specialist,
browser branch, CLI branch, MCP route, main-worktree change delivery, isolated
change delivery, text change delivery artifact, change-application fallback, or
broad evidence route. No specialist branch starts before the board exists. A
draft board cannot start formal specialists; no-write evidence that can shape
source, workflow, validation, review, memory, release, or governance decisions
uses `formal-readonly`.

The formal board lifecycle records `dispatch wave`, `previous-wave input`,
`next-wave start condition`, `formal evidence eligibility`, `yellow
classification`, and `repair loop limit`; long value catalogs stay in
`references/team-dispatch-gates.md`.

### Execution Profile Resolution

After task type is known and before any execution channel is chosen, resolve the
requested execution profile from the platform-neutral `U`, `E`, `R`, `V`, `B`,
`A`, `D`, `C`, and `F` inputs in
`Shared/policies/references/workflow-execution-spec-contract.md`. Apply its
hard-floor-plus-score behavior and record the floor and score rationale. Role or
station may recommend a profile, but task evidence, explicit requirements, and
operator answers may override that recommendation. A role or station never
binds a model.

- Pure discussion or work with no executable station uses `not-applicable`,
  `requested_model: not-requested`, `requested_reasoning_effort:
  not-requested`, and `not-applicable` context/wait references. The presence of
  these fields never activates Team mode.
- `fast` is appropriate when the hard floor stays low and the combined evidence
  remains bounded; it may request bounded extended-depth capability when the
  adapter offers it and task evidence warrants it.
- `balanced` is appropriate for ordinary bounded work above the fast range; it
  may also request bounded extended-depth capability without changing scope or
  gates.
- `deep` is quality-priority when the hard floor or combined evidence requires
  it and may request a larger bounded reasoning budget.

Reliable failure raises effective reasoning depth only when the failure is
same-scope, reproducible, and verifier-backed, and another resolution input
independently supports the raise. Failure evidence never selects `deep` by
itself. Cost or latency preference can choose among profiles above the hard
floor but cannot lower that floor.

These are the only execution profile selection rules. `high-assurance` is a
governance requirement and `scope-resolution` is a route or station; neither is
an execution profile. An exact requested model may come only from the current
Director's explicit request or the current dispatch resolution citing presently
verified platform capability or execution evidence. Do not encode named models
in profiles, policies, or long-term defaults.

An exact requested reasoning effort, `exact:<opaque-token>`, follows the same
source-legitimacy rule. It may appear only in the current per-task execution spec
when grounded in a current explicit Director request or current verified
platform/channel evidence. It must never become a permanent profile enum or
default, and it must not be inferred from prior availability. If the profile or
requested effort remains ambiguous, ask at most two targeted operator questions.
Until resolved, the execution spec is `draft` / `unverified`; do not invent a
sentinel value.

Requested profile, model, and effort are intent, not authority or availability
guarantees. They cannot remove roles, alter route or scope, relax authorization
or protected gates, reduce review depth or validation obligations, alter a
delivery slice, or change completion requirements. If the requested channel,
model, or effort is unavailable, preserve requested intent and record the
`unavailable` / `not-applied` / variance outcome through the canonical board
fields; do not silently downgrade. Applied-field values and consistency rules
remain owned by the board field catalog. Delegation selects requested intent
only; it never derives accepted or applied state and never sets wait durations.
Adapter acceptance is recorded in `accepted_execution_request`, and acceptance
never proves application. Materialized startup timing is owned by Handoff Packet
Startup Monitoring through the current `wait_policy_ref`; do not add
profile-specific fixed wait durations.

## Team-Native Minimum Execution Gate

Captain limits follow the `Captain Boundary Anchor / 隊長邊界錨點` in
`Shared/policies/team-native-core.md`. This skill only selects execution routes
and delivery forms after the board exists; it does not turn captain
coordination into station evidence.

Implementation routes to a named station-owned main-worktree change delivery
station when `formal-write`, authorization phase `implementation-change-delivery`,
exact file allowlist, dirty-diff read, forbidden protected actions, and
`handoff_ownership: station-owned` are present. If main-worktree writing is not
authorized, route to isolated change delivery, then text change delivery
artifact, then `blocked`.

## Specialist Dispatch Gate

For each applicable station:

1. Select the specialist from `team-specialist-registry`.
2. Resolve the execution profile and requested model/effort intent under the
   pre-gate above.
3. Build a handoff packet with the immutable requested execution snapshot,
   loaded skill refs, read scope, forbidden actions, output format, referenced
   wait policy, and stop condition.
4. When same-wave parallel work is proposed, run the concrete dispatch checks
   in `references/team-dispatch-gates.md` against the packet's canonical
   `parallel_dispatch_contract`; do not infer eligibility from different write
   files.
5. Record requested execution channel, channel capability, channel invocation
   status, station lifecycle, standby reason, and closeout lane. Ledger returned
   applied execution state through the canonical board fields.
6. Return a delivery artifact or mark `blocked`, `unverified`, `standby`, or
   `closed-with-director-risk`.

Mandatory route anchors remain: Implementation station with governed isolated
workspace; text change delivery artifact; Browser/UI verification station;
Large CLI-only analysis station; Real-time tool access; Independent read-only
evidence station after special routes are excluded.

Skill dispatch package fields are mandatory: Allowed inputs, Allowed tools,
Forbidden actions, Output artifact format, and Stop condition.

Large-file deep read routes to a bounded specialist under the core captain
boundary.

Special route outputs: Browser/UI verification station -> `browser branch`;
Large CLI-only analysis station -> `CLI branch`; Real-time tool access -> `MCP
read/tool path`; Independent read-only evidence station after special routes
are excluded -> `evidence branch`.

Regression anchors kept in this thin entry: governed isolated implementation,
text change delivery, browser/UI verification, large CLI-only analysis,
real-time tool access, independent read-only evidence, formal board lifecycle,
dispatch wave, previous-wave input, next-wave start condition, formal evidence
eligibility, yellow classification, and repair loop limit.

## Mandatory Guards

- Pre-Board Guard: no evidence, browser, CLI, MCP, main-worktree change delivery,
  isolated change delivery, text delivery, or fallback change-application route
  starts before the Captain Team Board exists.
- Fake-Team Guard: two or more evidence stations using `direct_exception` need
  station-specific reason, replacement evidence, and residual
  `closed-with-director-risk`, `unverified`, or `blocked`.
- Role-Exclusivity Guard: a specialist cannot implement and review the same
  deliverable; missing independent review is never `complete`.
- Lifecycle Guard: retain or reuse a specialist only inside the same role,
  station, delivery artifact, and role boundary.

## Change Delivery Boundary

Station-owned main-worktree change delivery is valid only for scoped
`implementation-change-delivery` work with exact allowlist, dirty diff read,
forbidden protected actions, and `handoff_ownership: station-owned`.
`change-application` is fallback only for a returned isolated/text artifact,
explicit integration task, or assigned generated/deployed sync. Missing
conditions close as `blocked`, `unverified`, or Director-risk closed.

## Direct Exception Contract

`direct_exception` is a record, not an execution route, mode, channel, station
state, or completion state. It requires station, reason, replacement evidence,
and residual state. Valid uses are coordination, blocker/conflict routing,
permission routing, hot-path non-mutating status feedback without validation
value, no independent evidence value, or Director-accepted captain substitute
authoring.

## Review And Evidence Boundary

Evidence branches can support `quality-review-governance` and review lifecycle
evidence, but they cannot decide final review state, quality acceptance,
authorization gates, or release readiness. Review delivery still needs a
role-separated reviewer artifact when completion depends on review.

## Output Contract

Delegated branches return internal artifacts with canonical English keys. The
compact field list and full routing order live in
`references/team-dispatch-gates.md`; Director-facing summaries must synthesize
Traditional Chinese meaning first.

## Platform Adapter Mapping

Shared skills describe Team-Native Core intent, not vendor tools. Platforms map
evidence, browser, CLI, MCP, main-worktree change delivery, isolated change
delivery, text change delivery, or fallback change application to `native`,
`adapter`, `conditional`, or `unavailable`. Conditional routes need proof.
Unavailable routes cannot become legacy invalid/forbidden `routine direct` or
routine captain work. Vendor-specific named model and reasoning-effort tables
remain adapter-owned.
