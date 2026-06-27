---
name: programming-team-governance
description: >
  [Infra] Programming team governance for coding, build, fix, debug, test, audit, commit,
  handoff, and skill-forge workflows. Use when: 編程、開發、修改、修復、除錯、測試、健檢、
  提交、交接、技能鍛造或任何 source/workflow governance task needs a team-station board,
  read-only evidence branches, or subagent boundary control. DO NOT use when: pure discussion,
  one-line factual answers, or non-coding tasks with no source, workflow, validation, or review impact.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "subagent:read"]
---

# Programming Team Governance

## Purpose

Use this skill to turn coding work into a governed team workflow. The main agent acts as the engineering captain. Evidence branches act as specialists. The main agent keeps responsibility for integration, source writes, review state, validation claims, memory updates, commits, pushes, releases, deployments, installs, and Director-facing communication.

This skill upgrades coding delegation from vague size judgments to fixed station checks. It does not authorize source writes, memory writes, commits, pushes, installs, deployments, or mutating MCP calls.

## Trigger Rule

For any task that touches code, workflow rules, skills, tests, debugging, audit, release preparation, commit preparation, experiment work, or source memory, build a Programming Team Board before the main work proceeds.

The board may be brief for narrow tasks, but it must explicitly cover the stations below with two separate decisions:

| Field | Allowed values | Meaning |
|---|---|---|
| Applicability | applicable / not-applicable | Whether the station belongs to this task. |
| Execution mode | direct / delegated / blocked / not-applicable | Who handles the station and whether evidence is blocked. |

`applicable` is not a completion state. Every applicable station must resolve to `direct`, `delegated`, or `blocked`; a station that does not apply must use `not-applicable` with a short reason. Do not use vague states such as active, pending, optional, or if-needed as final board results.

Do not decide by small, medium, or large task labels. Decide by station responsibility, isolation, and evidence value.

## Team Stations

| Station | Responsibility | Delegation default | Main-agent duty |
|---|---|---|---|
| Requirement playback | Restate goal, non-goals, constraints, assumptions, and success criteria. | direct unless a contradiction check is independently useful | Own final task boundary. |
| Counter-evidence | Look for wrong assumptions, missing risk, overreach, or under-scoped validation. | delegated when an independent read-only challenge can run in parallel | Decide whether to change the plan. |
| Impact map | Inspect affected files, owners, memory cards, docs, sync paths, and compatibility. | delegated when broad file or documentation reading is separable | Convert evidence into the implementation scope. |
| Authorization plan | Produce plan, review state, acceptance matrix, and GO boundary. | direct | Never delegate Director approval or gate interpretation. |
| Implementation | Modify approved source, generated copies, docs, and memory files. | direct in v1 | Write only from the main thread. |
| Short-loop validation | Run targeted tests, scans, command checks, or real-path probes while errors are still cheap to fix. | delegated only for read-only result analysis or non-mutating verification | Fix and integrate results. |
| Review | Check requirement alignment, correctness, quality, regression risk, and accepted risk. | delegated when a read-only review packet can run in parallel | Map evidence to review lifecycle status. |
| Completion | Update docs, memory, sync outputs, drift audit, and final report. | direct | Own completion claims and unresolved items. |

## Role Model

| Role | May do | Must not do |
|---|---|---|
| Engineering captain | Integrate evidence, write files after GO, run validations, update memory, report completion. | Hide uncertainty or treat branch evidence as automatic approval. |
| Counter-evidence specialist | Read files and return risks, contradictions, or missing validation. | Rewrite the plan or decide approval. |
| Impact specialist | Read owners, relations, sync paths, docs, and compatibility surfaces. | Modify source or memory. |
| Test specialist | Analyze non-mutating test output, real-path evidence, or blocked validation conditions. | Mark a feature complete without main-agent review. |
| Review specialist | Return correctness, quality, and regression findings. | Decide final review lifecycle state. |
| Completion specialist | Suggest documentation, memory, and handoff items as text. | Write memory, commit, push, release, deploy, or mutate external state. |

## Permission Boundary

| Layer | Allowed | Forbidden |
|---|---|---|
| Read-only evidence | Read files, search, inspect logs, summarize docs, analyze test output, propose text. | Source writes, memory writes, git writes, installs, deployments, cloud/resource changes, issue/PR mutation, mutating MCP calls. |
| Non-mutating validation | Run commands that do not rewrite tracked source, collect output, classify failures. | Formatters, codegen, migrations, or commands whose purpose is to change tracked source. |
| Main-thread write | Modify approved files, generated copies, docs, and memory after the workflow gate allows it. | Blanket staging, ungated external state changes, or hiding unrelated dirty files. |
| Future isolated write | Prepare a patch in an isolated worktree or sandbox. | Write to the main worktree directly. This is v2 only. |

## Delegation Decision

Use `delegation-strategy` after the board is drafted:

1. If the station is implementation, a gate decision, Director communication, or final acceptance, use `direct`.
2. If the next main-thread step is blocked on the answer, use `direct` and explain why delegation would stall the work.
3. If the work needs secrets, login state, private credentials, or external mutation, use `direct` or `blocked`.
4. If the station involves UI, DOM, screenshots, browser interaction, or visual verification, use a browser branch or the main agent's browser tool through the platform adapter.
5. If the station involves large CLI output, scan summaries, test logs, or command evidence that can be isolated as a report, use a CLI branch.
6. If the station requires real-time MCP/tool access, use `MCP direct`; MCP remains a main-agent tool, not a delegated worker.
7. If the station is independently bounded, read-only, and useful while the main thread can continue non-overlapping work, use an evidence branch.
8. If the branch would duplicate the main agent's current work, use `direct`.

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

## Workflow Integration

Coding-related workflow entries should load this skill before planning or execution when they touch source, validation, audit, commit preparation, handoff, skill creation, or experiment writes. The workflow should report the board in a compact form:

| Station | Applicability | Execution mode | Evidence owner | Completion condition |
|---|---|---|---|---|

For very small edits, the board can be one table. For heavy governance, public contract, release, or cross-platform work, the board should be paired with `intent-alignment-gate` and `quality-review-governance`.

## Completion Rules

Before completion:

1. Compare the original request, approved plan, actual changes, evidence packets, validation output, docs, and memory updates.
2. Mark drift as aligned, justified deviation, unauthorized deviation, or unverified.
3. Do not claim completion if required validation, review state, source sync, or memory attribution is missing.
4. List accepted v1 limitations separately from unresolved bugs or blockers.
5. Reject any board whose applicable stations do not resolve to `direct`, `delegated`, or `blocked`.

## V1 Default

Use B-first workflow and A-safe execution:

- Team stations are the default workflow structure.
- Evidence branches are read-only.
- The main agent writes and integrates.
- Controlled write agents remain a future v2 capability.
