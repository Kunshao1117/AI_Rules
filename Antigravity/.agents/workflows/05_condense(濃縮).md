---
description: "適用於專案濃縮初始化、萃取 PROJECT IDENTITY、掃描代碼庫並建立永久上下文；使用此工作流區分穩定 source-backed facts、偏好、暫時觀察與排除材料；觸發於需要 project condensation / durable context creation 時，執行記憶或 context 寫入前仍需對應 protected gate。不要用於只讀既有記憶或一般架構說明（DO NOT use when: only memory read or architecture explanation is needed）。"
required_skills: [tech-stack-protocol]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: condense
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before memory/context writes"
  automation_safe: false
---

A2 owner references: `Shared/policies/project-context-protocol.md`, `Shared/policies/references/legacy-skills/team-task-board/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-change-delivery-artifact/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-validation-delivery-artifact/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-review-delivery-artifact/REFERENCE.md`.
Frozen relation IDs still use `Shared/policies/references/legacy-skill-migration.md`; read documents without Skill invocation or changed Memory semantics.


Governance references: `Shared/policies/agent-governance.md`, `Shared/policies/agent-governance.md`, `Shared/policies/completion-policy.md`, `Shared/agents/_registry.md`.
Frozen legacy dependencies use `Shared/policies/references/legacy-skill-migration.md`
as document references for frozen compatibility only; they do not activate
Memory roles, bundles, or the old artifact Skill in ordinary work.


## Workflow Entry Contract

This Antigravity workflow entry is a thin route entry. It selects workflow row `05`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `05` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `05 Condense`. Do not copy that procedure back into this entry.
7. For ordinary work, use `.agents/shared/policies/memory-governance.md` for relevant Memory Impact Review, `.agents/shared/policies/authorization-resolution.md` for writes, and `.agents/shared/policies/completion-policy.md` for completion. Team selection uses the formal Agent owner, not old governance Skills.
8. Discover `memory-ops` when Memory evidence or card method is relevant; discover `memory-arch` only for owner/topology ambiguity. Existing frozen consumers may resolve legacy board, bundle, and receipt references through `.agents/shared/policies/references/legacy-memory-team-transition.md`, never as an ordinary workflow dependency.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `05`.
- Procedure reference: `05 Condense` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Separate durable source-backed facts from temporary observations; any necessary Memory or Context write follows its own owner and authorization boundary.
- Read relevant memory/context inventory before proposing durable facts.
- Separate stable source-backed facts from preferences, task evidence, raw logs, screenshots, failed attempts, and rejected ideas.
- Present the candidate condensation for Director review with evidence status and excluded material.
- Write memory or context only under the matching protected authorization and follow the memory/context procedure.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a Director intent signal is resolved to the visible plan, station, file set, command, phase, expiry, and required protected gate.
