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

Dispatch sequencing is governed by `Shared/policies/workflow-orchestration.md`.
This skill chooses execution channels only after the formal board state, dispatch
wave, previous-wave input, next-wave start condition, and formal evidence
eligibility are established.

## Captain Trigger Gate

Captain-led mode is active when the current Director request asks for governed
work: governance, workflow, fix, build, debug, test, audit, skill, memory, docs,
commit, handoff, source, generated copies, public contract, or equivalent
change-shaping work. Requests for a team, team member, subagent, delegation,
Team-Native, or equivalent dispatch also activate captain-led mode. The Director
does not need a fixed phrase; workflow and skill names are route signals, and
when the request itself is governed work the request activates captain-led mode.
Pure conversation, small stable factual answers, and work with no source,
governance, workflow, validation, review, memory, release, or evidence impact
may stay direct. Without a current governed Director request or team-dispatch
request, do not create a Captain Team Board, apply captain/team-board
restrictions, or claim Team-Native evidence.

## Task Type And Dispatch Pre-Gate

When captain-led mode is active, classify task type before any specialist,
browser branch, CLI branch, MCP route, main-worktree change delivery, isolated
change delivery, text change delivery artifact, change-application fallback, or
broad evidence route. Requests for team mode or specialist channels force board
creation first.

No specialist branch starts before the board exists. In active captain-led mode, no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions opens a `formal-readonly` team board.

The board records task type, workflow route, implementation authorization, allowed specialist roles, forbidden specialist roles, station applicability, execution mode, evidence owner, role boundary, direct exception, completion condition, and platform route. A draft board cannot start formal specialists or satisfy formal acceptance. The formal board lifecycle is draft -> authorization-resolved formal promotion -> wave-gated station dispatch -> returned delivery artifacts -> review/validation/memory states -> completion audit.

Formal dispatch fields include phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, specialist lifecycle, closeout lane, Yellow classification, repair loop count, and closed-with-director-risk.

## Captain Minimum Execution Gate

The captain keeps Director communication, requirement intake, scope-bound authorization interpretation, board maintenance,
dispatch, delivery receipt, blocker/conflict/authorization handling, memory,
git, release, deploy/install gates, and final reporting. Gate ownership is not
permission to absorb implementation, review, validation, or memory attribution.
The captain must not call `apply_patch`, shell writes, editor tools, or any
other source-writing tool and package that captain-authored output as change
delivery.

Implementation does not default to the captain. For main-worktree source
changes, route to a named station-owned `change-delivery` station with
`formal-write`, authorization phase `implementation-change-delivery`, exact file
allowlist, dirty-diff read, and forbidden protected actions. If main-worktree
write is not authorized but a governed artifact route exists, route to isolated
change delivery, then text change delivery artifact, then `blocked`. Captain
substitute authoring needs case-specific Director `closed-with-director-risk`
and is not full team completion. Captain receipt of returned delivery artifacts
is normal; change application is a fallback integration station and must not
become captain-authored evidence.

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
| Change delivery | `team-specialist-change-delivery` | station-owned main-worktree change delivery when `formal-write` implementation authorization is scoped; otherwise isolated change delivery, then text change delivery artifact | captain source writes, self-review, protected mutation |
| Memory/docs | `team-specialist-memory-docs` | memory/docs delivery artifact | memory write, memory commit |
| Validation | `team-specialist-validation` | CLI/browser/MCP/evidence; hot-path non-mutating status checks are direct feedback only and do not satisfy validation artifacts | implementation repair |
| Review | `team-specialist-review` | independent evidence branch | authoring the reviewed deliverable |
| Completion readiness | `team-specialist-release-completion` | drift, sync, docs, completion evidence | final state mutation |

## Delegation Gate

Evaluate each station in this order:

1. 總監溝通、scope-bound approval interpretation、final reporting、board maintenance、delivery receipt、blocker/conflict/authorization handling -> captain coordination lane; use a protected captain gate only for a separately authorized protected phase.
2. Primary implementation, rewrite, validation, review, memory attribution, or source-state mutation that is not an authorized station-owned change-delivery station or fallback change-application gate -> route to the matching formal station; the captain must not absorb it as routine direct work.
3. Secrets, login, credentials, external mutation, commit, push, release, deployment, install, memory write -> `direct` or `blocked`.
4. Implementation station with scoped main-worktree authorization -> station-owned `main-worktree change delivery`.
5. Implementation station with governed isolated workspace but no main-worktree authorization -> `isolated change delivery`; fallback change application waits for scoped authorization and later station routing.
6. Implementation station without isolation but bounded and diffable -> text change delivery artifact.
7. Source, workflow, governance, docs, generated-copy, or public contract memory impact -> memory/docs delivery artifact.
8. No main-worktree/isolated/text change delivery route -> `blocked`; captain substitute authoring needs Director `closed-with-director-risk`.
9. Immediate hot-path non-mutating status check after integration -> `direct` feedback only; it does not satisfy a validation artifact or completion evidence.
10. Browser/UI verification station? -> `browser branch`.
11. Large CLI-only analysis station? -> `CLI branch`.
12. Real-time tool access? -> `MCP direct`.
13. Independent read-only evidence station after special routes are excluded? -> `evidence branch`.
14. No independent evidence value for a non-implementation station -> `direct` with concrete direct exception.
15. Required route unavailable -> `blocked` or `unverified`.
16. Missing implementation, memory, review, or validation artifact before formal completion -> `blocked`, `unverified`, or `closed-with-director-risk`; do not claim full team completion.
17. Yellow finding -> classify as `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, or `informational`.
18. Repair loop limit reached after two repair attempts for the same Yellow or validation symptom -> stop incremental repair and route to root-cause repair, structural refactor, blocked, unverified, or `closed-with-director-risk`.

## Guards

Pre-Board Guard: after captain-led mode is active, do not open evidence,
browser, CLI, MCP, main-worktree change delivery, isolated change delivery, text
delivery, or fallback change-application routes before the Captain Team Board
exists.

Hot-Path Exclusion: CLI branch is not for immediate feedback on just-written
code; use the main terminal tool only for non-mutating status checks. Hot-path
feedback does not satisfy validation artifacts or completion evidence.

Fake-Team Guard: if two or more evidence stations resolve to `direct`, each needs a concrete exception, replacement evidence, and `closed-with-director-risk`, `unverified`, or `blocked`.

Role-Exclusivity Guard: a specialist cannot implement and review the same deliverable. Missing independent review is `closed-with-director-risk`, `unverified`, or `blocked`, never `complete`.

Lifecycle Guard: retained specialists remain valid only inside the same role and same delivery artifact. Reuse across implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or second-opinion review is invalid.

## Change Delivery Boundary

Use station-owned main-worktree change delivery only when scope is explicit,
roles are separated, protected state is forbidden, authorization phase is
`implementation-change-delivery`, exact file allowlist and dirty-diff read are
present, and `handoff_ownership: station-owned`. Use isolated or text change
delivery when main-worktree writing is not authorized but an artifact route is
available. Use `change-application` only as a fallback integration route for a
returned isolated/text artifact, explicit integration task, or assigned
generated/deployed sync. If any condition is missing, mark the implementation
station `blocked` or Director-risk closed.

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

Shared skills describe Team-Native Core intent, not vendor tools. Platforms map evidence, browser, CLI, MCP, main-worktree change delivery, isolated change delivery, text change delivery, or fallback change application to `native`, `adapter`, `conditional`, or `unavailable`. Conditional routes need proof. Unavailable routes cannot become routine direct.

## Direct Exception Contract

`direct` requires station, exception reason, replacement evidence, and residual `closed-with-director-risk`, `unverified`, or `blocked` state. Valid exceptions are scope-bound authorization interpretation, board maintenance, delivery receipt, blocker/conflict/authorization handling, memory/git/release/deploy/install ownership, secret/login boundary, hot-path non-mutating status feedback that is not validation/completion evidence, no independent evidence value, or Director-accepted captain substitute authoring.

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

The captain receives artifacts, updates the board, and routes them onward.
Evidence branches cannot decide authorization resolution, memory commit, commit, push, release,
deployment, or mutating MCP actions.

Evidence branches can support `quality-review-governance` and review lifecycle evidence, but they cannot decide final review state, quality acceptance, authorization gates, or release readiness. Review delivery still needs a role-separated reviewer artifact when completion depends on review.
