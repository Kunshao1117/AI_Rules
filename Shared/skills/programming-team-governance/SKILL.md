---
name: programming-team-governance
description: >
  [Infra] Captain-led programming team governance. Use when: 編程、開發、修復、除錯、測試、
  健檢、提交、交接、技能/規則治理，或 source/workflow tasks need captain trigger, team routing,
  role-exclusive specialists, evidence branches, isolated/text change delivery, or execution-channel boundaries.
  DO NOT use when: pure discussion or non-coding no-source tasks.
metadata:
  author: antigravity
  version: "1.2"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Captain-Led Programming Team Governance

## Purpose

Captain-led programming governance makes Team-Native Core the default for source, workflow, validation, review, memory, commit, release, deployment, install, generated-copy, public-contract, or governance-impact work. The Director talks to the captain; the captain classifies, boards, dispatches, supervises, integrates artifacts, adjudicates, and reports.

Specialist roles come from `team-specialist-registry` plus matching `team-specialist-*`. `team-task-board` owns board, station, artifact, change delivery, and completion templates. Routes are `native`, `adapter`, `conditional`, or `unavailable`; missing route evidence is `blocked`, `unverified`, or `closed-with-director-risk`.

Flow: intake -> Captain Team Board -> dispatch waves -> delivery artifacts -> validation/review -> integration -> audit -> report.

## Captain Trigger Gate

Captain-led mode starts for semantic coding triggers, file impact triggers, risk triggers, or explicit workflow triggers. Examples: build, fix, debug, test, audit, commit, release, handoff, skill/rule update, source files, workflow files, policies, memory, docs, generated copies, public contracts, and cross-platform drift. Discussion, translation, and small factual answers stay direct.

Workflow names are route hints, not authorization. When source, workflow, validation, review, memory, or release may change, enter captain-led mode.

## Task Type Gate

Classify task type before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, broad evidence, validation, review, or completion work.

| Task type | Allowed specialist roles | Forbidden roles |
|---|---|---|
| discussion | none | coding specialists |
| exploration | requirement, architecture, review evidence | implementation |
| blueprint | requirement, architecture, impact, review | implementation |
| build-plan | requirement, architecture, impact, test, review | main-worktree implementation |
| implementation | implementation change delivery, memory delivery, test, review, completion | self-review, ungated expansion |
| fix-debug | impact, debug, test, review, completion | self-review, uncontrolled writes |
| validation-audit | test, review, completion, CLI/browser evidence | source mutation without GO |
| commit-release | memory delivery, review, completion evidence | specialist git/release/memory mutation |
| handoff-skill | requirement, architecture, impact, review, completion | implementation before GO |

Task type must be visible in the board.

## Dispatch Pre-Gate

No specialist branch starts before the captain has a board. The board must exist before specialist channels, browser/CLI/MCP evidence, isolated or text change delivery, parallel evidence, validation, review, or completion audit.

Before the board, the captain may only bootstrap workflow/skill, rules, request, status, and memory/context index. Broad reading, impact mapping, counter-evidence, review, and audit are stations. Director requests for team mode or specialist channels force board creation first.

## Assignment Gate

Applicable specialist stations are assigned before execution-channel selection. Tool limits never cancel station assignment; they only change channel capability and channel invocation status. If a channel, isolated workspace, or text route is unavailable, the station remains `blocked`, `unverified`, or `closed-with-director-risk`.

## Draft Board And Formal Board Contract

A draft board is pre-GO planning. It records candidate stations, role boundaries, waves, and assumptions; it cannot start formal specialists or satisfy acceptance.

After GO, the captain creates or promotes a formal dispatch board. Formal board lifecycle: draft -> GO-backed formal promotion -> wave-gated station dispatch -> returned delivery artifacts -> review/validation/memory states -> completion audit. Draft evidence becomes formal only when assigned to a formal station with open wave and valid artifact.

## Board Contract

Use `team-task-board`. Captain Team Board records:

- board state, task type, workflow route, implementation authorization
- platform capability route, delivery sequence state, phase, dispatch wave
- previous-wave input, next-wave start condition, formal evidence eligibility
- specialist role source, assigned specialist skill, domain label
- allowed specialist roles, forbidden specialist roles, station applicability
- execution mode, execution channel, requested execution channel
- channel capability, channel invocation status, evidence owner, role boundary
- station lifecycle state, retention reason, conversation health, reuse count, handoff summary, closure reason
- closeout lane, Yellow classification, Yellow resolution state, repair loop count
- delivery artifact ID, delivery artifact type, delivery artifact status
- author role, source input, integrable scope
- review state, validation state, memory/docs state
- captain specialist content state and direct exception
- completion condition

Every applicable station resolves to `direct`, `evidence branch`, `browser branch`, `CLI branch`, `MCP direct`, `isolated change delivery`, `text change delivery artifact`, `blocked`, or `not-applicable`, and records platform route `native`, `adapter`, `conditional`, or `unavailable`.

## Captain Routing Contract

Route map: architecture -> blueprint; construction -> build; bugs -> fix; validation -> test; logs -> debug; drift -> audit/routine; version prep -> commit; continuity -> handoff; skill changes -> skill-forge.

## Captain Minimum Execution Gate

Captain-only duties are Director communication, task type and board ownership, GO interpretation, main-worktree integration of returned change delivery artifacts, review lifecycle decision, memory/git/release/deploy/install gates, mutating MCP gates, and final acceptance.

The captain does not author separable implementation, review, validation, or memory attribution as a normal route. Implementation uses isolated change delivery, then text change delivery, then `blocked`. Captain substitute authoring requires Director `closed-with-director-risk` and is not Full team completion.

Counter-evidence, impact map, review, validation, and completion audit default to bounded evidence when useful. If two or more evidence-oriented stations resolve to `direct`, each needs a concrete exception, replacement evidence, and `closed-with-director-risk`, `unverified`, or `blocked`.

## Role Exclusivity Contract

Use `team-specialist-registry`, matching `team-specialist-*`, and `team-role-boundaries`. Requirement defines intent; architecture defines boundaries; implementation returns change delivery artifacts only; memory delivery returns impact/proposal only; validation checks without mutation; review judges without authoring; completion audits evidence; captain dispatches, integrates, adjudicates, and reports.

Same specialist cannot implement and review the same deliverable. If independent review is unavailable, mark `closed-with-director-risk`, `unverified`, or `blocked`; it cannot support `complete`. Review and validation are separate from implementation and from final captain acceptance.

## Station Semantics

Requirement playback may use protected direct handling when facts are complete. Counter-evidence and impact map route to evidence/CLI/MCP. Authorization planning is protected captain work. Implementation is isolated or text change delivery. Memory delivery is evidence/MCP attribution. Validation uses browser/CLI/evidence/MCP or hot-path direct. Review routes to evidence. Completion audit checks docs, memory, sync, drift, handoff, and final claims.

## Wave Dispatch Semantics

Formal dispatch is wave-gated. Open only the current dispatch wave and stations whose previous-wave input is present, blocked, unverified, or closed-with-director-risk. Same-wave stations must not conflict. Implementation and same-deliverable review do not share a wave. Change-dependent validation waits for the change delivery artifact. Completion waits for change delivery, memory/docs, validation, and independent review states.

## Specialist Lifecycle Semantics

Team-Native execution uses specialist lifecycle instead of mechanical close/reopen. Retain only for the same role, same station, same delivery artifact, and preserved role boundary. Record station lifecycle state, retention reason, conversation health, reuse count, handoff summary, and closure reason.

Retain validation specialists for repeated non-mutating checks on the same artifact; retain review specialists for follow-up review on the same artifact; retain memory/docs specialists for the same attribution surface. Do not retain across implementation-to-review, validation-to-repair, memory attribution-to-memory mutation, completion audit-to-final acceptance, or any role-exclusive boundary. Stale or unclear context becomes `handoff-required`; insufficient handoff opens a replacement station.

## Fast Closeout And Yellow Signal Semantics

Closeout lane is `light`, `standard`, or `release-grade`. Light closeout fits documentation, generated-copy sync, Yellow drift, or low-risk governance wording only when omitted stations are not-applicable, blocked, unverified, or closed-with-director-risk. Multi-file governance, skills, matrices, audit logic, workflow semantics, or memory/docs impact use at least standard closeout. Commit, tag, release, deployment, install, external mutation, credentials, or operator readiness use release-grade closeout.

Yellow classification values are `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, and `informational`. Yellow that affects completion evidence, Team-Native trace, independent review, validation, memory/docs attribution, public contract, deployment sync, or release readiness escalates to blocked, unverified, or Red. Repair loop limit: after two repair attempts for the same Yellow or validation symptom, stop incremental repair and route to root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Permission Boundary

Read-only evidence covers reads, searches, logs, docs, test output, and proposed text only. Validation is non-mutating. Change delivery routes produce artifacts, not main-worktree writes, memory, git, deployment, release, or self-review.

## Delegation Decision

Use `delegation-strategy` after the board. Dispatch order: captain-only gates, protected state, credential/external mutation boundaries, implementation change delivery, memory/docs delivery artifact, hot-path validation, browser/UI evidence, large CLI evidence, MCP direct evidence, bounded read-only evidence, and protected direct exception or Director-risk substitute authoring. Missing evidence, isolation, platform route, or text change delivery artifact means `blocked` or `unverified`; Director risk closure is not complete.

## Direct Exception Register

Direct handling is for protected captain duties: returned artifact integration, GO/review/acceptance gates, Director communication, final acceptance, hot-path validation, no independent evidence value, or Director-accepted captain substitute authoring recorded as `closed-with-director-risk`. Generic size, speed, convenience, or cost labels fail the board.

## Required Delivery Artifacts

Evidence delivery artifacts include `發現 / 證據 / 風險 / 建議 / 是否阻塞`.

Implementation change delivery artifacts include `變更 / 檔案 / 證據 / 風險 / memory_impact / 審查需求 / 是否阻塞`.

Memory/docs delivery artifacts include `memory_impact`, `status: memory_delivery / blocked / unverified / closed-with-director-risk`, `memory_delivery`, evidence, risk, and blocker state.

Full team completion needs implementation change delivery, memory/docs delivery artifact, review delivery artifact, and validation delivery artifact. Change delivery branches cannot approve themselves, update memory, stage, commit, push, release, deploy, install, or mutate external state.

## Workflow Integration

Coding workflow entries load this skill, `team-task-board`, `delegation-strategy`, `team-specialist-registry`, matching `team-specialist-*`, `team-role-boundaries`, `team-change-delivery-artifact`, `team-memory-docs-delivery-artifact`, `team-validation-delivery-artifact`, `team-review-delivery-artifact`, and `team-completion-gate`. Governance, public contract, release, or cross-platform work also loads `intent-alignment-gate` and `quality-review-governance`.

## Completion Rules

Before completion, compare request, approved plan, implementation change delivery, memory/docs delivery, review, validation, source changes, docs, and memory. Reject missing execution modes, self-review, specialist mutation of protected state, captain-direct implementation without Director-accepted `closed-with-director-risk` or `blocked`, two or more evidence-oriented stations resolving to direct without concrete exceptions, and missing implementation change delivery, memory/docs delivery, review, or validation artifacts.

Full team completion is allowed only when implementation change delivery, memory delivery, independent review, validation evidence, completion evidence, and required Team-Native trace evidence exist. Missing separation, route evidence, trace evidence, independent review, validation, or delivery artifacts may be reported only as `closed-with-director-risk`, `unverified`, or `blocked`, and `closed-with-director-risk` is not complete.
