---
description: "建構執行、套用 `/03_build` design-to-build contract、已完成範圍綁定授權解析後的建構寫入、適用時的記憶影響檢視與驗證測試（Use when: build execution after resolved scope）。不要用於缺少建構合約或意圖訊號尚未解析到可見範圍的情況（DO NOT use when: contract or resolved intent is missing）。"
required_skills: [security-sre, test-patterns, trunk-ops]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: build
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before writes"
  automation_safe: false
---

A2 owner references: `Shared/policies/code-quality.md`.


Governance references: `Shared/policies/references/workflow-review-visual-evidence.md`.


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

This Antigravity workflow entry is a thin route entry. It selects workflow row `03`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `03` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `03 Build`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證（`unverified`）或阻塞（`blocked`）。

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `03`.
- Procedure reference: `03 Build` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Execute necessary local_work when current task scope covers it, then collect appropriate validation and required review evidence; Team uses only needed role evidence and Memory remains frozen.
- Confirm authorization resolution, allowed file set, phase, expiry, and protected-action exclusions.
- Dispatch or produce the implementation change delivery artifact for the named scope only.
- Record memory/docs impact and source/deployed sync direction before completion claims.
- Obtain necessary verification and applicable review after implementation; report task status through completion-policy. Frozen Memory follows its own consumer only when applicable.
- Workflow labels select phase sequence only. Resolve the user's natural-language action and target through the authorization owner; no extra magic phrase is required.
- Non-mutating evidence uses observe; legacy formal-readonly is confined to frozen compatibility consumers.
- Necessary bounded implementation and local verification use current local_work authority. Protected actions and explicit local Git scope follow the authorization owner; legacy formal-write remains frozen-compatibility-only.

## Completion Boundary

Use `.agents/shared/policies/verification-strategy.md` for focused/broad scope
and direct/independent judgment; `.agents/shared/policies/review-governance.md`
for review applicability; `.agents/shared/policies/completion-policy.md` for
overall request status. Main may directly verify ordinary work. No fixed
validation/review/Memory/completion chain or legacy completion ladder applies.
Keep the six truth facts separate; frozen Memory completion stays independent.
