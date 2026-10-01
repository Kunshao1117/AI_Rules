---
description: "技能鍛造、建立新技能、建立 Shared/project/Codex skill、從健檢/除錯/總監指令萃取可重用方法論、plugin/extension、VSIX、Release/發布、version/版本、tag、update reminder 相關技能設計（Use when: skill forging）。不要用於只討論技能想法、不準備寫入，或只修改既有技能描述（DO NOT use when: no write is planned or only an existing description changes）。"
required_skills: [skill-factory]
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

A2 owner references: `Shared/policies/project-context-protocol.md`.


## Workflow Entry Contract

Execution mode is owned by `.agents/shared/policies/execution-routing.md`:
Direct is default; bounded helper use is Assisted; Team needs a positive trigger.
Action authority is independently owned by `.agents/shared/policies/authorization-resolution.md`.
Workflow names select phase sequence only. Direct and Assisted need no Team
board, station, role instance, handoff, wave, or Team completion chain.
Main is owner and ordinary implementer in all modes. Team uses only needed roles
from `.agents/shared/agents/_registry.md` under `.agents/shared/policies/agent-governance.md`.
Model intent belongs to `.agents/shared/policies/model-profile-routing.md`.
All legacy station/roster/board/handoff/lifecycle prescriptions below are
compatibility-only, not required for general vNext work, including Team.
General Verification/Review/Completion use their canonical policies; domain methods remain;
frozen Memory retains its own contracts, authority and receipt requirements.

This Antigravity workflow entry is a thin route entry. It selects workflow row `12`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `12` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `12 Skill Forge`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證（`unverified`）或阻塞（`blocked`）。

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `12`.
- Procedure reference: `12 Skill Forge` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Place skill content in the right governance layer, keep trigger language in frontmatter, and validate source/deployed sync.
- Decide whether content belongs in core, shared policy, workflow entry, operational skill, reference file, memory, or project context.
- Keep trigger language in frontmatter description and move long examples, templates, and procedures into references.
- Stop for Director review before source writes when skill design, governance placement, file scope, phase, expiry, or required protected gate is still open.
- Validate naming, description specificity, boundary language, metadata, source/deployed sync, and memory/docs impact.
- Workflow labels select phase sequence only. Resolve the user's natural-language action and target through the authorization owner; no extra magic phrase is required.
- Use authorization-resolution for local_work, explicit local Git and protected actions. Memory/project-context phase, station, expiry and gates remain frozen; they do not gate ordinary source work.
- Non-mutating evidence uses observe; legacy formal-readonly is confined to frozen compatibility consumers.
- Necessary bounded implementation and local verification use current local_work authority. Protected actions and explicit local Git scope follow the authorization owner; legacy formal-write remains frozen-compatibility-only.

## Completion Boundary

Use `.agents/shared/policies/verification-strategy.md` for focused/broad scope
and direct/independent judgment; `.agents/shared/policies/review-governance.md`
for review applicability; `.agents/shared/policies/completion-policy.md` for
overall request status. Main may directly verify ordinary work. No fixed
validation/review/Memory/completion chain or legacy completion ladder applies.
Keep the six truth facts separate; frozen Memory completion stays independent.
