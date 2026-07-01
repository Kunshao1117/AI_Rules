---
description: "Use when: 純對話討論、腦力激盪、概念釐清、無外部證據依賴的輕量程式碼問答。When the request involves files, screenshots, memory/context cards, rules/workflows/policies, agent behavior, evidence checks, source/tool output, or later governance impact, promote to a Team-Native formal-readonly station. DO NOT use when: 需要深度研究、架構藍圖、建構、修復、測試、提交、發布或正式寫入交付。"
required_skills: []
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: chat
  role: reader
  memory_awareness: read
  tool_scope: ["conversation", "filesystem:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---

## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `00`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `00` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `00 Chat`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證 or 阻塞.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, Director-readable/language-governance全文, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `00`.
- Procedure reference: `00 Chat` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Answer directly only for pure conversation; promote evidence-bearing requests to formal-readonly and route write work onward.
- Confirm the request can be answered from conversation, provided snippets, or stable reasoning.
- If files, screenshots, memory/context, workflow rules, agent behavior, tool output, or governance evidence are needed, promote to formal-readonly.
- Route research, architecture, build, fix, test, commit, release, or write-producing work to the matching workflow.
- Do not mutate files, memory, git, release state, deployment, installs, credentials, or external state.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after scoped GO tied to the visible plan, station, file set, command, or protected phase.
