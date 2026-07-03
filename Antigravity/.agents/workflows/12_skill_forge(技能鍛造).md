---
description: "Use when: 技能鍛造、建立新技能、建立 Shared skill、建立 project skill、建立 Codex skill、從健檢/除錯/總監指令萃取可重用方法論、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關技能設計。DO NOT use when: 只是討論技能想法、不準備寫入，或只要修改既有技能描述。"
required_skills: [skill-factory, memory-ops, project-context-protocol, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: full
skill_generation: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: skill-forge
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before each write or protected phase"
  automation_safe: false
---

## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `12`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `12` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `12 Skill Forge`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證 or 阻塞.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, Director-readable/language-governance全文, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `12`.
- Procedure reference: `12 Skill Forge` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Place skill content in the right governance layer, keep trigger language in frontmatter, and validate source/deployed sync.
- Decide whether content belongs in core, shared policy, workflow entry, operational skill, reference file, memory, or project context.
- Keep trigger language in frontmatter description and move long examples, templates, and procedures into references.
- Stop for Director review before source writes when skill design, governance placement, file scope, phase, expiry, or required protected gate is still open.
- Validate naming, description specificity, boundary language, metadata, source/deployed sync, and memory/docs impact.
- Treat workflow names, slash commands, skill triggers, workflow buttons, Director `GO` text, and natural-language requests as routing or intent signals only.
- Require authorization resolution before source write, memory mutation, project-context mutation, git, release, deploy, install, credential, or external-state phases; bind the visible plan, station, file set, command, phase, expiry, and matching protected gate.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a Director intent signal is resolved to the visible plan, station, file set, command, phase, expiry, and required protected gate.
