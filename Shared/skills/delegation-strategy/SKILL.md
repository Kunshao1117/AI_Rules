---
name: delegation-strategy
description: >
  [Infra] Vendor-neutral captain dispatch and Delegation Gate for captain-led stations,
  role-exclusive specialists, evidence/browser/CLI branches, MCP direct calls,
  isolated/text change delivery artifacts, and review boundaries.
  Use when: 判斷隊長制、主腦直做、站點隊員或證據/變更交付管道。
  DO NOT use when: 瀏覽器測試已確定（用 browser-testing）、CLI 掃描已確定（用 code-audit）。
metadata:
  author: antigravity
  version: "6.1"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---

# Captain Dispatch And Delegation Strategy

Use after captain-led mode is active and the Captain Team Board exists. This
skill selects channels; `programming-team-governance` owns team semantics,
`team-specialist-registry` owns roles, `team-task-board` owns board and artifact
fields, and `team-station-handoff-packet` owns specialist startup packets. Read
`references/cli-delegation-sop.md` only for CLI branch details.

## Captain Trigger Gate

Captain-led mode is active for code, workflow rules, skills, tests, debugging, audit, commit/release prep, source memory/docs, generated copies, public contract, or governance work. Pure conversation and small factual answers stay direct. Uncertain source/workflow/review impact enters captain-led mode.

## Task Type And Dispatch Pre-Gate

Classify task type before any specialist, browser branch, CLI branch, MCP route, isolated change delivery, text change delivery artifact, or broad evidence route. Requests for team mode or specialist channels force board creation first.

No specialist branch starts before the board exists. No-write work still opens a
`formal-readonly` team board when it can shape source, workflow, validation,
review, memory, release, or governance decisions.
No-write does not mean no-team. Read-only exploration still uses
`formal-readonly` when it can shape later source or governance decisions.

The board records task type, workflow route, implementation authorization, allowed specialist roles, forbidden specialist roles, station applicability, execution mode, evidence owner, role boundary, direct exception, completion condition, and platform route. A draft board cannot start formal specialists or satisfy formal acceptance. The formal board lifecycle is draft -> GO-backed formal promotion -> wave-gated station dispatch -> returned delivery artifacts -> review/validation/memory states -> completion audit.

Formal dispatch fields include phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, specialist lifecycle, closeout lane, Yellow classification, repair loop count, and closed-with-director-risk.

## Captain Minimum Execution Gate

The captain keeps Director communication, GO interpretation, protected integration, memory, git, release, deploy/install gates, review-state decision, and final acceptance. Gate ownership is not permission to absorb implementation, review, validation, or memory attribution.

Implementation does not default to the captain. Route to isolated change delivery, then text change delivery artifact, then `blocked`. Captain substitute authoring needs case-specific Director `closed-with-director-risk` and is not full team completion. Captain protected integration of returned delivery artifacts remains normal.

Evidence stations do not default to the captain. Counter-evidence, impact map, validation, review, and completion audit route to bounded evidence/CLI/browser/MCP paths unless a direct exception is recorded.

## Formal Wave Dispatch Gate

Dispatch is wave-gated. Open only the current wave and stations whose previous-wave input exists or is honestly marked `blocked`, `unverified`, or `closed-with-director-risk`. Same-wave stations need no dependency or implementation/review conflict. Review and validation wait for the change delivery artifact or recorded missing state.

Do not perform post-board all-at-once dispatch.

Within an open wave, evaluate station lifecycle before starting or reusing a channel. Retain or reuse only for the same role, station, delivery artifact, and preserved role boundary. Record station lifecycle state, retention reason, conversation health, reuse count, handoff summary, and closure reason. Replace when independent opinion is required, role would change, context is stale, or handoff is insufficient.

## Specialist Dispatch Gate

Route each applicable station in this order:

1. Select a specialist skill from `team-specialist-registry`.
2. Select the domain label.
3. Create the station handoff packet with loaded skill refs, read scope,
   forbidden actions, output format, startup deadline, and standby rule.
4. Select requested execution channel.
5. Record channel capability and channel invocation status.
6. Record station lifecycle, standby reason, startup timing, and closeout lane.
7. Return a delivery artifact or mark `blocked`, `unverified`, `standby`, or `closed-with-director-risk`.

Skill dispatch package fields are mandatory: Allowed inputs, Allowed tools,
Forbidden actions, Output artifact format, and Stop condition. Large-file deep
read must route to a bounded specialist; the captain must not absorb,
substitute, or deep read large files as the team evidence source.
Exact large-read rule: large-file deep read routes to a bounded specialist; the captain must not absorb, substitute, or deep read large files as the team evidence source.

| Station need | Specialist source | First route | Forbidden |
|---|---|---|---|
| Requirement alignment | `team-specialist-intent-requirements` | contradictions, acceptance gaps | implementation |
| Architecture boundary | `team-specialist-architecture-contract` | interfaces, boundaries, alternatives | production writes |
| Change delivery | `team-specialist-change-delivery` | isolated change delivery, then text change delivery artifact | main-worktree writes, self-review |
| Memory/docs | `team-specialist-memory-docs` | memory/docs delivery artifact | memory write, memory commit |
| Validation | `team-specialist-validation` | CLI/browser/MCP/evidence or hot-path command evidence | implementation repair |
| Review | `team-specialist-review` | independent evidence branch | authoring the reviewed deliverable |
| Completion readiness | `team-specialist-release-completion` | drift, sync, docs, completion evidence | final state mutation |

## Delegation Gate

Evaluate each station in this order:

1. Director communication, GO, final acceptance, review-state decision, source-state mutation -> `direct` with protected exception.
2. Secrets, login, credentials, external mutation, commit, push, release, deployment, install, memory write -> `direct` or `blocked`.
3. Implementation station with governed isolated workspace -> `isolated change delivery`; captain integrates after evidence.
4. Implementation station without isolation but bounded and diffable -> text change delivery artifact.
5. Source, workflow, governance, docs, generated-copy, or public contract memory impact -> memory/docs delivery artifact.
6. No isolated/text change delivery route -> `blocked`; captain substitute authoring needs Director `closed-with-director-risk`.
7. Immediate hot-path validation after integration -> `direct` with command evidence.
8. Browser/UI verification station? -> `browser branch`.
9. Large CLI-only analysis station? -> `CLI branch`.
10. Real-time tool access? -> `MCP direct`.
11. Independent read-only evidence station after special routes are excluded? -> `evidence branch`.
12. No independent evidence value for a non-implementation station -> `direct` with concrete direct exception.
13. Required route unavailable -> `blocked` or `unverified`.
14. Missing implementation, memory, review, or validation artifact before formal completion -> `blocked`, `unverified`, or `closed-with-director-risk`; do not claim full team completion.
15. Yellow finding -> classify as `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, or `informational`.
16. Repair loop limit reached after two repair attempts for the same Yellow or validation symptom -> stop incremental repair and route to root-cause repair, structural refactor, blocked, unverified, or `closed-with-director-risk`.

## Guards

Pre-Board Guard: do not open evidence, browser, CLI, MCP, or isolated change delivery routes before the Captain Team Board exists.

Hot-Path Exclusion: CLI branch is not for immediate feedback on just-written code; use the main terminal tool.

Fake-Team Guard: if two or more evidence stations resolve to `direct`, each needs a concrete exception, replacement evidence, and `closed-with-director-risk`, `unverified`, or `blocked`.

Role-Exclusivity Guard: a specialist cannot implement and review the same deliverable. Missing independent review is `closed-with-director-risk`, `unverified`, or `blocked`, never `complete`.

Lifecycle Guard: retained specialists remain valid only inside the same role and same delivery artifact. Reuse across implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or second-opinion review is invalid.

## Change Delivery Boundary

Use isolated or text change delivery only when scope is explicit, roles are separated, protected state is forbidden, and captain inspection precedes integration. If any condition is missing, mark the implementation station `blocked` or Director-risk closed.

Required fields:

```text
delivery_artifact_id:
author_role:
source_input:
integrable_scope:
變更:
檔案:
證據:
風險:
memory_impact:
review_state:
validation_state:
memory_docs_state:
captain_authored:
審查需求:
是否阻塞:
```

## Platform Adapter Mapping

Shared skills describe Team-Native Core intent, not vendor tools. Platforms map evidence, browser, CLI, MCP, isolated change delivery, or text change delivery to `native`, `adapter`, `conditional`, or `unavailable`. Conditional routes need proof. Unavailable routes cannot become routine direct.

## Direct Exception Contract

`direct` requires station, exception reason, replacement evidence, and residual `closed-with-director-risk`, `unverified`, or `blocked` state. Valid exceptions are GO interpretation, main-worktree integration of returned delivery artifacts, memory/git/release/deploy/install ownership, secret/login boundary, hot-path feedback, no independent evidence value, or Director-accepted captain substitute authoring.

## Integration Authorization Contract

Formal team completion evidence requires implementation change delivery, memory/docs delivery artifact, review delivery artifact, and validation delivery artifact. Missing artifacts, route evidence, independent review, validation, or Team-Native trace evidence stop formal completion as `blocked` or `unverified` unless the Director closes the named risk as `closed-with-director-risk`. Risk closure is incomplete team separation, not completion.

## Evidence Delivery Artifact Contract

Every delegated branch names specialist skill, domain label, requested channel, read scope, forbidden actions, review use, stop condition, and returns:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

The captain reviews and integrates artifacts. Evidence branches cannot decide GO, memory commit, commit, push, release, deployment, or mutating MCP actions.

Evidence branches can support `quality-review-governance` and review lifecycle evidence, but they cannot decide final review state, quality acceptance, GO gates, or release readiness. Review delivery still needs a role-separated reviewer artifact when completion depends on review.
