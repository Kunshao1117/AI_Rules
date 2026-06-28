---
name: programming-team-governance
description: >
  [Infra] Captain-led programming team governance. Use when: 編程、開發、修復、除錯、測試、
  健檢、提交、交接、技能/規則治理，或 source/workflow tasks need captain trigger, team routing,
  role-exclusive specialists, evidence branches, isolated/text patch boundaries, or subagent boundary.
  DO NOT use when: pure discussion or non-coding no-source tasks.
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "subagent:read"]
---

# Captain-Led Programming Team Governance

## Purpose

Turn programming work into a captain-led team workflow. The Director talks to the captain; the captain classifies, boards, dispatches, integrates, adjudicates, and owns Director communication. The captain must not absorb implementation, review, validation, or memory attribution detail work when a bounded specialist packet can be produced.

This is the source for team triggers, roles, captain-only authority, and forbidden delegation. `team-task-package` owns board, packet, patch, and completion.

Formal team collaboration is split across these fixed child skills: `team-role-boundaries`, `implementation-patch-delivery`, `memory-coupled-delivery`, `team-validation-packet`, `team-review-packet`, and `team-completion-gate`. Workflow entries must load the applicable child skills instead of restating their contracts or relying on ambiguous captain judgment.

## Captain Trigger Gate

Captain-led mode starts automatically when any trigger below applies. The Director does not need to name a workflow, ask for subagents, or restate the request in framework language.

| Trigger | Examples | Captain action |
|---|---|---|
| Semantic coding trigger | build, fix, debug, test, audit, commit, release, handoff, skill/rule update | Route internally. |
| File impact trigger | source, workflow, skill, policy, memory, docs, generated copies | Build a board. |
| Risk trigger | cross-file/platform, memory, external state, release, UI/runtime, regression, public contract | Assign evidence or mark blocked/unverified. |
| Explicit workflow trigger | `$02` to `$12`, `GO`, `GO PUSH` | Treat the named workflow as a route hint, not a replacement for team governance. |
| Non-trigger | pure explanation, translation, small factual answer, non-coding discussion | Answer directly. |

When source, workflow, validation, review, memory, or release state may change, enter captain-led mode.

## Task Type Gate

After the trigger fires, classify task type before any specialist, browser, CLI, MCP, isolated patch, text patch, or broad evidence work.

| Task type | Use when | Allowed specialist roles | Forbidden roles |
|---|---|---|---|
| discussion | No source/workflow/review impact. | none | all coding specialists |
| exploration | Research or reading before edits. | requirement, architecture, review evidence | implementation |
| blueprint | Architecture, public contract, governance design. | requirement, architecture, counter-evidence, impact, review | implementation |
| build-plan | Design-to-build contract before GO. | requirement, architecture, impact, test, review | main-worktree implementation |
| implementation | GO-approved source/docs/generated copy work. | implementation patch, memory delivery, test, review, completion | self-review, ungated expansion |
| fix-debug | Root-cause repair, logs, regression. | impact, debug, test, review, completion | self-review, uncontrolled writes |
| validation-audit | Test, audit, post-change verification. | test, review, completion, CLI/browser evidence | source mutation without GO |
| commit-release | Commit, changelog, version, push, tag, release. | memory delivery, review, completion evidence | specialist git/release/memory mutation |
| handoff-skill | Handoff, skill forge, workflow/policy governance. | requirement, architecture, impact, review, completion | implementation before GO |

Task type must be visible in the board or plan.

## Dispatch Pre-Gate

No specialist branch starts before the captain has a board. The board may be lightweight, but it must exist before subagents, browser/CLI/MCP evidence, isolated patch, text patch, parallel evidence, validation, review, or completion audit.

Before the board, the captain may only bootstrap workflow/skill, rules, request, status, and memory/context index. Broad reading, impact mapping, counter-evidence, review, and completion audit are stations.

Director requests for team mode, subagents, workflow commands, or parallel agents force board creation first, not pre-board delegation.

## Draft Board And Formal Board Contract

A draft board is pre-GO planning. It may record candidate stations, role boundaries, waves, and assumptions. It cannot start formal specialists, satisfy validation/review/completion/commit/release/memory acceptance, or support full team execution claims.

After GO for implementation, validation, commit, release, or formal execution, the captain creates or promotes a formal dispatch board before any formal station. It replaces assumptions with assigned stations and records phase, dispatch wave, previous-wave input, next-wave start condition, and eligibility.

Draft evidence is previous-wave input or planning context. It becomes formal only when the formal board assigns the station, opens the wave, and receives a valid packet.

## Board Contract

Use `team-task-package` to choose the lightweight, full, or experiment board template. A valid board always records:

Captain Team Board is the required board artifact for captain-led programming work.

- board state: draft or formal
- task type
- workflow route
- implementation authorization
- phase
- dispatch wave
- previous-wave input
- next-wave start condition
- formal evidence eligibility
- allowed specialist roles
- forbidden specialist roles
- station applicability
- execution mode
- evidence owner
- role boundary
- direct exception
- completion condition

`applicable` is not a completion state. Every applicable station resolves to a valid execution mode: `direct`, `evidence branch`, `browser branch`, `CLI branch`, `MCP direct`, `isolated patch`, `text patch packet`, `blocked`, or `not-applicable`.

## Captain Routing Contract

Route map: architecture -> blueprint; approved construction -> build; bugs -> fix; validation -> test; logs -> debug; drift -> audit/routine; version prep -> commit; continuity -> handoff; skill changes -> skill-forge.

Manual workflow names are shortcuts, not required triggers and not authorization.

## Captain Minimum Execution Gate

The captain is an orchestrator/integrator, not the default worker.

Captain-only duties:

- Director communication
- task type and board ownership
- GO interpretation and authorization plan
- main-worktree integration of returned patch packets after GO
- review lifecycle decision
- memory, git, release, deploy, install, and mutating MCP gates
- final acceptance

Captain ownership of gates does not authorize captain absorption of implementation detail, independent review, independent validation, or memory attribution analysis. Those details remain station work unless the board marks a concrete `blocked`, `unverified`, or `accepted-risk` exception.

The captain does not perform formal implementation as a normal route. Formal implementation starts as isolated patch, then text patch packet if isolation is unavailable. If neither exists, mark `blocked` unless the Director accepts substitution risk. Substitution is not full team completion.

Counter-evidence, impact map, review, validation, and completion audit default away from the captain when bounded evidence exists. Short-loop validation may stay direct only for hot-path feedback or replacement evidence. If two or more evidence-oriented stations apply, one independent path must run unless each skipped branch has a concrete exception and replacement evidence.

If two or more evidence-oriented stations resolve to `direct`, every direct evidence station needs a concrete direct exception, replacement evidence, and `accepted-risk`, `unverified`, or `blocked`. Majority or all-direct thresholds are invalid; the threshold is two direct evidence stations.

## Role Exclusivity Contract

Use `team-role-boundaries` for role details. Minimum rule: requirement defines intent; architecture defines boundaries; implementation returns patch packets only; memory delivery returns memory impact and proposed memory delivery only; validation does non-mutating checks; review judges without patching; completion audits evidence; captain dispatches, integrates, adjudicates, and reports.

Same specialist cannot implement and review the same deliverable. If separation is unavailable, mark the station `accepted-risk`, `unverified`, or `blocked`.

## Station Semantics

Default station routes: requirement playback may be direct or requirement evidence; counter-evidence and impact map default to evidence/CLI/MCP.
Authorization plan is captain direct. Implementation is isolated patch or text patch packet. Memory delivery is evidence/MCP attribution with protected captain memory gates.
Validation uses browser/CLI/evidence/MCP or hot-path direct. Review defaults to independent evidence. Completion audit checks docs, memory, sync, drift, handoff, and final claims.

## Wave Dispatch Semantics

Formal dispatch is wave-gated. The captain opens only stations whose previous-wave input is present, blocked, unverified, or accepted-risk.

The same wave may include only stations with no dependency conflict. Dependent stations move later. Implementation and review of the same deliverable cannot share a wave. Patch-dependent validation waits for the patch packet.

A completed board does not authorize post-board all-at-once dispatch. Each next wave starts only after the board records the prior wave result and satisfies the next-wave start condition.

## Permission Boundary

Read-only evidence reads/searches/logs/docs/test output/proposed text only. Validation is non-mutating. Isolated or text patch routes may produce patch packets but not main-worktree writes, memory, git, deployment, release, or self-review. Main-thread integration is limited to approved files, generated copies, docs, gated memory, and protected state.

## Delegation Decision

Use `delegation-strategy` after the board. Dispatch order:

1. captain-only gates and protected state
2. secrets, login state, credential or external mutation boundaries
3. implementation patch packaging
4. memory delivery packet packaging
5. hot-path validation
6. browser/UI evidence
7. large CLI evidence
8. MCP direct evidence
9. bounded read-only evidence
10. protected direct exception or accepted-risk captain substitution

Missing evidence, missing isolation, or missing text patch package means `blocked` or `unverified`; specialists never write the main worktree.

## Direct Exception Register

Direct handling is for protected captain duties only: protected integration, GO/review/acceptance gates, Director communication, final acceptance, hot-path validation, no independent evidence value, or `captain substitution accepted-risk` when no isolated patch or text patch task exists. Generic reasons such as small task, faster, not necessary, or delegation cost fail the board.

## Required Output Packets

Use `team-task-package` for exact packet templates.

Evidence packets must include `發現 / 證據 / 風險 / 建議 / 是否阻塞`.

Implementation patch packets must include `變更 / 檔案 / 證據 / 風險 / memory_impact / 審查需求 / 是否阻塞`.

Memory delivery packets must include `memory_impact`, `status: memory_patch / blocked / unverified / accepted-risk`, `memory_patch`, evidence, risk, and blocker state. Review packets must come from a reviewer who did not author the patch. Validation packets must come from a route that does not modify core implementation. The captain claims formal team completion only after implementation patch, memory delivery, review, and validation packets exist, or missing packets are marked `blocked`, `unverified`, or Director-accepted risk.

Conflicts require a captain check or uncertainty label. A patch branch cannot approve itself, update memory, stage, commit, push, release, deploy, install, or mutate external state.

## Workflow Integration

Coding workflow entries load this skill, `team-task-package`, `delegation-strategy`, and the six formal team child skills before planning, execution, validation, review, completion, or experiment writes touching source, audit, commit prep, handoff, skill creation, memory, docs, or governance.

Workflow entries keep route-specific evidence rules. They must not copy the full board, specialist packet, patch packet, memory delivery packet, validation packet, review packet, completion gate, or role contract. Commands are route hints only; they do not replace the board or make all stations captain-direct.

For governance, public contract, release, or cross-platform work, pair the board with `intent-alignment-gate` and `quality-review-governance`.

## Completion Rules

Before completion, compare the request, approved plan, implementation patch, memory delivery, review, validation, source changes, docs, and memory. Mark drift as aligned, justified deviation, unauthorized deviation, or unverified. Reject missing execution modes, self-review, specialist mutation of protected state, captain-direct implementation without `accepted-risk` or `blocked`, two or more direct evidence stations without concrete exceptions, and missing implementation patch, memory delivery, review, or validation packets.

Full team completion is allowed only when implementation patch, memory delivery, independent review, validation evidence, and completion evidence exist. Missing separation or packets may be reported only as accepted risk, unverified, or blocked.
