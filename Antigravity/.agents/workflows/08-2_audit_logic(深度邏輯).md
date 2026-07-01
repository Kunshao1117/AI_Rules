---
name: 08-2_audit_logic(深度邏輯)
description: "Use when: 健檢第二階段、依盤點清單做深度邏輯審查、安全架構、API/端點/資料流比對、真實功能驗證、視覺/瀏覽器採證、效能可靠性、測試覆蓋缺口與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08_audit。"
required_skills:
  - delegation-strategy
  - code-audit
  - audit-engine
  - security-sre
  - impact-test-strategy
  - test-patterns
  - browser-testing
  - performance-audit
  - quality-review-governance
  - programming-team-governance
  - team-specialist-registry
  - team-task-board
  - team-role-boundaries
  - team-change-delivery-artifact
  - team-memory-docs-delivery-artifact
  - team-validation-delivery-artifact
  - team-review-delivery-artifact
  - team-completion-gate
trigger: manual
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---

## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `08`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `08` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `08-2 Logic Review`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證 or 阻塞.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, Director-readable/language-governance全文, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `08`.
- Procedure reference: `08-2 Logic Review` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Use 08-1 inventory as input, review logic and evidence integrity, then route repairable findings with explicit evidence state.
- Use 08-1 inventory as the required input.
- Review architecture, state/data flow, security, reliability, validation coverage, governance consistency, and evidence integrity.
- Map review lifecycle, real operation evidence, performance, accessibility, and compatibility without issuing final audit conclusions early.
- Route repairable findings to the right workflow with evidence status and blockers.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after scoped GO tied to the visible plan, station, file set, command, or protected phase.
