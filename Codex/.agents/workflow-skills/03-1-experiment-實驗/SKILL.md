---
name: "03-1-experiment-實驗"
description: "Use when: 沙盒快速實驗、髒碼原型、API spike 或可丟棄原型。DO NOT use when: 生產建構、正式修復或提交準備。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: experiment
  role: writer
  memory_awareness: none
  tool_scope: ["filesystem:write", "terminal:manual"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before experiment writes"
  automation_safe: false
---

## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry. It selects workflow row `03-1`, applies the platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `03-1` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only this platform's adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read `.agents/shared/skill-governance.md` before changing placement or wording.
6. When a concrete phase checklist is needed, read `.agents/shared/workflow-stage-procedures.md` and use section `03-1 Experiment`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md` first; load board, handoff, role-boundary, delivery, validation, review, memory/docs, and completion skills only for stations opened by the current board.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is `unverified` or `blocked`.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `03-1`.
- Procedure reference: `03-1 Experiment` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Declare sandbox boundary, allowed change scope, discard conditions, promotion criteria, allowed shortcuts, and no production completion claim.
- `03-1` experiment is a governed workflow route: a Director request for `03-1`,
  experiment, sandbox prototype, spike, or dirty-code prototype activates Team
  mode; the mainline acts as captain and records the experiment board before
  broad evidence, station work, writes, promotion, or completion claims.
- Use a reduced/minimal experiment station/board, not a no-team path. Record
  sandbox scope, sandbox boundary, allowed change scope, discard condition,
  promotion condition, and allowed shortcuts before sandbox writes.
- Sandbox writes and team artifacts are experiment-only. They do not equal
  production source completion, memory/docs completion, validation/review
  acceptance, release readiness, or production promotion.
- Discard, promotion, and production promotion remain scope-bound phases.
  Promotion to `03`/build or any formal production source/governance/public-contract
  write requires a new visible production plan plus authorization resolution,
  `formal-write`, station-owned `change-delivery`, validation, review, and
  memory/docs delivery.
- The captain may coordinate and receive artifacts but must not declare 03-1
  dirty code or team artifacts production complete.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- In active Team mode, use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- In active Team mode, use `formal-write` only after a scope-bound Director intent signal passes authorization resolution and binds the explicit phase, file set, command, or required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Full team completion requires separated implementation change delivery, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
