---
description: "Use when: 執行 E2E、視覺測試、介面適配證據、瀏覽器功能測試、桌面 GUI 驗證、終端輸出驗證、回歸驗證或測試委派。DO NOT use when: 只需要單元測試設計或純程式碼審查。"
required_skills: [test-automation-strategy, browser-testing, a11y-testing, trunk-ops, ai-dev-quality-gate, project-context-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: test
  role: worker
  memory_awareness: read
  tool_scope: ["browser:test", "terminal:test", "subagent:read"]
  human_gate: "none"
  automation_safe: false
---

## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `06`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `06` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `06 Test`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證 or 阻塞.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, Director-readable/language-governance全文, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `06`.
- Procedure reference: `06 Test` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Define the target surface and evidence level, run non-mutating validation, and route failures without repairing inside the test station.
- Define target surface, evidence level, environment, commands, browser/operator path, and expected pass/fail state.
- Use non-mutating validation by default and preserve blocked or unverified evidence states.
- Classify unit, integration, regression, visual, performance, accessibility, real execution, blocked, and unverified evidence separately.
- Route failed validation to 04, 07, 03, or 08; the validation station does not repair the implementation it validates.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after scoped GO tied to the visible plan, station, file set, command, or protected phase.
