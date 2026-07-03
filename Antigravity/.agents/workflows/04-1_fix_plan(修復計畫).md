---
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並執行正式修復；也涵蓋 plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關缺陷。DO NOT use when: 新功能建構或純除錯說明。"
required_skills: [memory-ops, impact-test-strategy, ai-dev-quality-gate, quality-review-governance, project-context-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: fix
  role: planner
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before writes"
  automation_safe: false
---

## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `04`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `04` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `04 Fix`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證 or 阻塞.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, Director-readable/language-governance全文, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `04`.
- Procedure reference: `04 Fix` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Plan from symptom, root cause, impact, and regression route; stop at a scoped repair plan and do not open write repair until authorization resolution binds the visible scope.
- Start with symptom, reproduction or observed failure, affected scope, and candidate root causes.
- Classify the change as emergency temporary fix, root-cause repair, local refinement, or structural refactor.
- Plan regression and real-path validation before writes when behavior depends on runtime, persistence, UI, external systems, or operator-visible output.
- Stop with a scoped repair plan; do not open write repair until authorization resolution binds the visible repair plan, station, file set, phase, expiry, and required protected gate.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a Director intent signal is resolved to the visible plan, station, file set, command, phase, expiry, and required protected gate.
