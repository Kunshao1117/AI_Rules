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

Turn programming work into a captain-led team workflow. The Director talks to the captain; the captain classifies the task, builds the board, assigns one bounded station per specialist, integrates packets, and owns acceptance.

This skill is the semantic source for when team mode starts, which roles are allowed, what the captain may keep, and what is forbidden. `team-task-package` is the template source for board formats, specialist packets, patch packet types, and completion checklists.

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
| implementation | GO-approved source/docs/generated copy work. | implementation patch, test, review, completion | self-review, ungated expansion |
| fix-debug | Root-cause repair, logs, regression. | impact, debug, test, review, completion | self-review, uncontrolled writes |
| validation-audit | Test, audit, post-change verification. | test, review, completion, CLI/browser evidence | source mutation without GO |
| commit-release | Commit, changelog, version, push, tag, release. | review, completion evidence | specialist git/release/memory mutation |
| handoff-skill | Handoff, skill forge, workflow/policy governance. | requirement, architecture, impact, review, completion | implementation before GO |

Task type must be visible in the board or plan.

## Dispatch Pre-Gate

No specialist branch starts before the captain has a board. The board may be lightweight, but it must exist before subagents, browser branches, CLI branches, MCP evidence routes, isolated patch branches, text patch packets, parallel evidence, validation, review, or completion audit.

Before the board, the captain may only bootstrap: active workflow/skill, governance rules, request, workspace status, and relevant memory/context index. Broad reading, impact mapping, counter-evidence, review, and completion audit are stations.

Director requests for team mode, subagents, workflow commands, or parallel agents force board creation first. They do not authorize pre-board delegation.

## Board Contract

Use `team-task-package` to choose the lightweight, full, or experiment board template. A valid board always records:

Captain Team Board is the required board artifact for captain-led programming work.

- task type
- workflow route
- implementation authorization
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

The captain does not perform formal implementation as a normal route. Formal implementation starts as an isolated patch; if no isolation exists, it becomes a text patch packet; if neither can be produced, the implementation station is `blocked` unless the Director explicitly accepts captain substitution risk. Captain substitution is not full team completion.

Counter-evidence, impact map, review, validation, and completion audit default away from the captain when a bounded evidence path exists. Short-loop validation may stay direct only for hot-path feedback or concrete replacement evidence. If two or more evidence-oriented stations apply, at least one independent evidence path must run unless every skipped branch has a concrete direct exception and replacement evidence.

## Role Exclusivity Contract

| Role | May do | Must not do |
|---|---|---|
| Requirement specialist | Intent, contradictions, constraints, success criteria. | Implement, final-review, expand scope. |
| Architecture specialist | Boundaries, interfaces, alternatives, risk. | Production code or hidden requirement changes. |
| Implementation specialist | Isolated workspace patch or text patch packet. | Requirements, architecture, review, self-review, main-worktree writes. |
| Test specialist | Non-mutating validation and regression risk. | Core implementation or completion claims. |
| Review specialist | Correctness, quality, requirement fit, risk. | Implement, patch, or approve own work. |
| Completion specialist | Docs, memory attribution, sync, drift, handoff checks. | Memory writes, commit, push, release, deploy, final acceptance. |
| Engineering captain | Route, integrate, decide review state, report to Director. | Hide uncertainty, skip specialists, delegate accountability. |

Same specialist cannot implement and review the same deliverable. If separation is unavailable, mark the station `accepted-risk`, `unverified`, or `blocked`.

## Station Semantics

| Station | Responsibility | Default team route | Captain duty |
|---|---|---|---|
| Requirement playback | Goal, non-goals, constraints, success criteria. | direct or requirement evidence | Own boundary. |
| Counter-evidence | Bad assumptions, missing risk, weak validation. | evidence branch | Adjust plan. |
| Impact map | Files, owners, memory, docs, sync, compatibility. | evidence branch, CLI branch, or MCP direct | Set scope. |
| Authorization plan | Plan, review state, acceptance matrix, GO boundary. | direct | Keep gates. |
| Implementation | Approved source, generated copies, docs. | isolated patch or text patch packet | Integrate after GO. |
| Short-loop validation | Targeted tests, scans, real-path probes. | browser, CLI, evidence, MCP, or hot-path direct | Fix/integrate results. |
| Review | Requirement fit, correctness, quality, regression, risk. | evidence branch unless concrete exception | Set lifecycle state. |
| Completion audit | Docs, memory, sync, drift audit, final report. | evidence branch for audit; direct for protected writes | Own final claims. |

## Permission Boundary

| Layer | Allowed | Forbidden |
|---|---|---|
| Read-only evidence | Read/search/logs/docs/test output/proposed text. | Source, memory, git, install, deploy, cloud, issue/PR, mutating MCP. |
| Non-mutating validation | Non-rewriting checks and failure classification. | Formatters, codegen, migrations, source-changing commands. |
| Isolated or text patch | Governed fork/sandbox/worktree patch, or text-only patch proposal. | Main-worktree writes, memory, git, deployment, release, self-review. |
| Main-thread integration | Approved files, generated copies, docs, gated memory. | Blanket staging, ungated external state, hiding unrelated dirty files. |

## Delegation Decision

Use `delegation-strategy` after the board. The dispatch order is:

1. captain-only gates and protected state
2. secrets, login state, credential or external mutation boundaries
3. implementation patch packaging
4. hot-path validation
5. browser/UI evidence
6. large CLI evidence
7. MCP direct evidence
8. bounded read-only evidence
9. protected direct exception or accepted-risk captain substitution

Missing evidence, missing isolation, or missing text patch package means `blocked` or `unverified`; specialists never write the main worktree.

## Direct Exception Register

Direct handling is reserved for protected captain duties. Captain implementation is not a normal fallback. If no isolated patch or text patch task exists, mark `blocked` or record `captain substitution accepted-risk` with the missing condition.

Valid direct exception reasons:

| Reason | Valid use |
|---|---|
| protected integration | Main-worktree/generated copy/docs integration, memory, git, release, deploy, external-state write. |
| captain substitution accepted-risk | No isolated/text patch task package exists; board records risk and missing condition. |
| gate | GO, approval, review state, or acceptance. |
| Director communication | Direct conversation is required. |
| final acceptance | Completion or accepted risk. |
| hot-path validation | Immediate check after a just-written change. |
| no independent evidence value | No separable read scope; board records why. |

Generic reasons such as small task, faster, not necessary, or delegation cost fail the board.

## Required Output Packets

Use `team-task-package` for exact packet templates.

Evidence packets must include `發現 / 證據 / 風險 / 建議 / 是否阻塞`.

Patch packets must include `變更 / 檔案 / 證據 / 風險 / 審查需求 / 是否阻塞`.

Review packets must be produced by a reviewer who did not author the patch. Validation packets must be produced by a validation route that does not modify core implementation. The captain may integrate into the main worktree only after the patch packet, review packet, and validation packet are present, or after missing packets are explicitly marked `blocked`, `unverified`, or Director-accepted risk.

Conflicts require a captain check or an uncertainty label. A patch branch cannot approve itself, update memory, stage files, commit, push, release, deploy, install, or mutate external state.

## Workflow Integration

Coding workflow entries load this skill and `team-task-package` before planning, execution, validation, review, completion, or experiment writes when touching source, validation, audit, commit prep, handoff, skill creation, memory, docs, or governance.

Workflow entries keep route-specific evidence rules. They must not copy the full board template, specialist packet template, patch packet template, or role exclusivity contract. Commands are route hints only; they do not replace the board or make all stations captain-direct.

For heavy governance, public contract, release, or cross-platform work, pair the board with `intent-alignment-gate` and `quality-review-governance`.

## Completion Rules

Before completion:

1. Compare request, approved plan, packets, source changes, validation, docs, and memory.
2. Mark drift: aligned, justified deviation, unauthorized deviation, or unverified.
3. Do not claim completion if validation, review state, source sync, or memory attribution is missing.
4. Reject boards whose applicable stations lack a valid execution mode.
5. Reject boards where two or more evidence stations are direct without concrete exceptions.
6. Reject self-review and specialist output that mutates main-worktree, memory, git, release, deploy, install, or external state.
7. Reject implementation stations that fall back to captain direct without `accepted-risk` or `blocked`.
8. Reject full-team completion claims when patch, review, or validation packets are missing.

Full team completion is allowed only when implementation patch, independent review, validation evidence, and completion evidence exist. Missing separation or missing packets may be reported only as accepted risk, unverified, or blocked.
