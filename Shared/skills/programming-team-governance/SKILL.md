---
name: programming-team-governance
description: >
  [Infra] Captain-led programming team governance for coding, build, fix, debug, test, audit,
  commit, handoff, and skill-forge workflows. Use when: 編程、開發、修改、修復、除錯、測試、
  健檢、提交、交接、技能鍛造、規範治理、工作流調整，或任何 source/workflow governance
  task needs captain trigger, team routing, role-exclusive specialists, evidence branches, or
  subagent boundary control. DO NOT use when: pure discussion, one-line factual answers, or
  non-coding tasks with no source, workflow, validation, or review impact.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "subagent:read"]
---

# Captain-Led Programming Team Governance

## Purpose

Turn coding work into a captain-led team workflow. The Director talks to the captain; the captain routes the hidden workflow, assigns role-exclusive specialists, integrates evidence or patches, and owns the final answer.

Specialists are bounded team members. The captain keeps integration, main-worktree writes, review state, validation claims, memory updates, commits, pushes, releases, deployments, installs, and Director-facing communication. Fixed captain triggers and station checks replace vague size judgments; this governance does not authorize delegated mutation.

## Captain Trigger Gate

Captain-led mode starts automatically when a request matches any trigger below. The Director does not need to name a workflow or ask for subagents.

| Trigger | Examples | Captain action |
|---|---|---|
| Semantic coding trigger | build, change, fix, debug, test, review, audit, commit, release, handoff, skill or rule update | Enter captain-led mode and route internally. |
| File impact trigger | Source, workflow, skill, policy, memory, docs, generated deployment copies | Build a team board before plan, write, validate, review, or complete. |
| Risk trigger | Cross-file/platform, memory ownership, external state, release, UI/runtime, regression, public contract | Assign a specialist or mark blocked/unverified. |
| Explicit workflow trigger | `$02` to `$12`, `GO`, `GO PUSH` | Treat the named workflow as an internal route, not a replacement for team governance. |
| Non-trigger | Pure explanation, translation, small factual answer, or non-coding discussion with no source/workflow/review impact | Answer directly and do not create a team board. |

When uncertain, bias toward captain-led mode if source, workflow, validation, review, memory, or release state could be affected.

## Trigger Rule

For any triggered task, build a Captain Team Board before main work. The board is both dispatch contract and completion audit record. It may be brief, but every station needs a separate decision:

| Field | Allowed values | Meaning |
|---|---|---|
| Applicability | applicable / not-applicable | Whether the station belongs to this task. |
| Execution mode | direct / evidence branch / browser branch / CLI branch / MCP direct / isolated patch / blocked / not-applicable | Who handles the station and whether evidence or patch output is blocked. |
| Evidence owner | main agent / named specialist / browser adapter / CLI report / MCP tool / none | Who produces the evidence. |
| Direct exception | implementation / gate / Director communication / final acceptance / hot-path validation / no independent evidence value / not-applicable | Why an applicable evidence station is not assigned to a specialist. |
| Role boundary | requirement / architecture / implementation / test / review / completion / captain | Which role owns the station and which roles are excluded. |

`applicable` is not a completion state. Every applicable station resolves to one execution mode; non-applicable stations use `not-applicable` with a reason. Do not use vague activity, need, or size labels as final board results. Decide by station responsibility, isolation, and evidence value.

## Captain Routing Contract

The captain maps natural-language requests to internal routes while the Director-facing conversation stays with the captain: architecture uses blueprint; approved construction uses build; bugs use fix; validation uses test; logs and stack traces use debug; health or drift uses audit/routine; version and release prep use commit; continuity uses handoff; shared or project skill changes use skill-forge.

Manual workflow names remain valid shortcuts, but they are not required for captain-led mode to start.

## Team-First Contract

Coding work defaults to a captain-led team workflow, not a solo workflow with optional delegation. Evidence-oriented stations produce independent evidence unless a direct exception is explicit and reviewable.

Evidence-oriented stations by default: counter-evidence, impact map, short-loop validation, review, and completion audit when docs, memory, sync, release, or governance state is affected.

If two or more evidence-oriented stations are applicable and all are marked `direct`, the board is invalid unless each direct station has a concrete exception reason. "Faster", "small task", "delegation cost", or "not necessary" are not sufficient reasons by themselves.

## Role Exclusivity Contract

Specialists must not cross role boundaries for the same deliverable.

| Role | May do | Must not do |
|---|---|---|
| Requirement specialist | Clarify intent, contradictions, constraints, success criteria. | Implement, review final code, or expand scope. |
| Architecture specialist | Propose boundaries, interfaces, alternatives, risk model. | Write production code or quietly change requirements. |
| Implementation specialist | Produce a scoped patch proposal or isolated patch for assigned files only. | Expand requirements, decide architecture, review its own output, touch main-worktree state directly. |
| Test specialist | Design or run non-mutating validation, classify failures, report regression risk. | Change core implementation or mark completion. |
| Review specialist | Review correctness, quality, requirement fit, regression risk, and accepted risk. | Implement the same deliverable or approve its own work. |
| Completion specialist | Check docs, memory attribution, sync, drift, and handoff items. | Write memory, commit, push, release, deploy, or claim final acceptance. |
| Engineering captain | Route work, integrate outputs, write main worktree after GO, decide review state, report to Director. | Hide uncertainty, skip required specialists, or delegate final accountability. |

A deliverable is invalid if the same specialist both implements and reviews it. If role separation is unavailable, mark the review `accepted-risk`, `unverified`, or `blocked` instead of pretending independent review happened.

## Team Stations

| Station | Responsibility | Delegation default | Main-agent duty |
|---|---|---|---|
| Requirement playback | Goal, non-goals, constraints, assumptions, success criteria. | direct unless ambiguity needs contradiction evidence | Own task boundary. |
| Counter-evidence | Wrong assumptions, missing risk, overreach, weak validation. | evidence branch for coding, governance, review, release impact | Adjust plan if needed. |
| Impact map | Files, owners, memory, docs, sync, compatibility. | evidence branch for multi-file/platform/memory/sync impact | Set implementation scope. |
| Authorization plan | Plan, review state, acceptance matrix, GO boundary. | direct | Never delegate approval or gate interpretation. |
| Implementation | Approved source, generated copies, docs, memory files. | direct for main worktree; isolated patch only in governed isolation | Integrate/reject patches; captain writes main worktree. |
| Short-loop validation | Targeted tests, scans, command checks, real-path probes. | browser branch, CLI branch, evidence branch, or main-tool path | Fix and integrate results. |
| Review | Requirement fit, correctness, quality, regression, risk. | evidence branch for governance, public contract, cross-module, bug, release, accepted-risk work | Map evidence to review lifecycle. |
| Completion | Docs, memory, sync outputs, drift audit, final report. | direct for writes; evidence branch for read-only completion audit | Own completion claims. |

## Permission Boundary

| Layer | Allowed | Forbidden |
|---|---|---|
| Read-only evidence | Read files, search, inspect logs, summarize docs, analyze test output, propose text. | Source writes, memory writes, git writes, installs, deployments, cloud/resource changes, issue/PR mutation, mutating MCP calls. |
| Non-mutating validation | Run commands that do not rewrite tracked source, collect output, classify failures. | Formatters, codegen, migrations, or commands whose purpose is to change tracked source. |
| Isolated patch | Produce a patch in a governed fork, sandbox, or isolated worktree with a declared file scope. | Direct main-worktree writes, memory writes, git state changes, deployment, release, or self-review. |
| Main-thread write | Modify approved files, generated copies, docs, and memory after the workflow gate allows it. | Blanket staging, ungated external state changes, or hiding unrelated dirty files. |

## Delegation Decision

Use `delegation-strategy` after drafting the board. Resolve in this order: captain-only responsibilities and gates -> secrets/login/external mutation -> hot-path validation -> browser/UI -> large CLI evidence -> MCP direct -> governed isolated patch -> bounded read-only evidence -> direct with a concrete exception. If required evidence or isolation is unavailable, mark `blocked`, `unverified`, or `direct` with an exception; never let specialists write the main worktree as fallback.

## Required Evidence Packet

Every evidence branch must receive a bounded task and return:

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

The main agent must review the packet before using it. Conflicting packets require a main-thread check or an explicit uncertainty label.

## Required Patch Packet

Every isolated patch branch must receive a bounded file scope and return:

```text
變更:
檔案:
證據:
風險:
審查需求:
是否阻塞:
```

Patch packets are proposals. The captain must review, integrate, validate, and own the final main-worktree change. A patch branch cannot approve itself, update memory, stage files, commit, push, release, deploy, or mutate external state.

## Direct Exception Register

Direct handling is always allowed for implementation, gates, Director communication, final acceptance, memory writes, commits, pushes, releases, deployments, installs, and mutating MCP calls.

Direct handling of an evidence-oriented station requires one of these reasons:

| Reason | Valid use |
|---|---|
| implementation | The station would write source, generated copies, docs, memory, git, release, deployment, or external state. |
| gate | The station interprets GO, approval, review state, or acceptance. |
| Director communication | The station requires direct conversation with the Director. |
| final acceptance | The station decides completion or accepted risk. |
| hot-path validation | The main agent must immediately check the result of a just-written change. |
| no independent evidence value | The station has no separable read scope, and the board records why. |

For evidence-oriented stations, direct exception text must be concrete. Generic phrases such as "small task", "faster", "not necessary", or "delegation cost" fail the board.

## Workflow Integration

Coding-related workflow entries should load this skill before planning or execution when they touch source, validation, audit, commit preparation, handoff, skill creation, or experiment writes. The workflow should report the board in a compact form:

| Station | Applicability | Execution mode | Evidence owner | Role boundary | Direct exception | Completion condition |
|---|---|---|---|---|---|---|

For narrow edits, the board can be one table. For heavy governance, public contract, release, or cross-platform work, the board should be paired with `intent-alignment-gate` and `quality-review-governance`.

## Completion Rules

Before completion:

1. Compare the original request, approved plan, actual changes, evidence packets, validation output, docs, and memory updates.
2. Mark drift as aligned, justified deviation, unauthorized deviation, or unverified.
3. Do not claim completion if required validation, review state, source sync, or memory attribution is missing.
4. List accepted v1 limitations separately from unresolved bugs or blockers.
5. Reject any board whose applicable stations do not resolve to a valid execution mode.
6. Reject any board that marks two or more applicable evidence-oriented stations as `direct` without concrete direct exceptions.
7. Reject any board where the same specialist implements and reviews the same deliverable.
8. Reject any specialist output that directly modifies main-worktree, memory, git, release, deployment, install, or external state.

## Captain-Led Default

Use captain-led workflow and guarded execution:

- Captain trigger starts automatically for coding, workflow, validation, review, memory, commit, and release-impact work.
- The captain is the only Director-facing owner and main-worktree integrator.
- Evidence branches are read-only.
- Isolated patch branches are allowed only when the platform provides a governed isolated workspace and the patch has a declared file scope.
- The captain writes or merges into the main worktree, updates memory, and owns final acceptance.
