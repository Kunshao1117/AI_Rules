---
description: "適用於架構設計、藍圖、技術堆疊探勘、系統初始化、重大技術轉向、ER 圖、API 路由設計與三平台代理治理架構宣告；也適用於 plugin/extension、VSIX、Release/發布、version/版本、tag、update reminder 的架構判斷。使用此工作流釐清需求、邊界、替代方案與交接合約；觸發於需要 architecture/blueprint decisions 時，執行後再交付建構或健檢。不要用於同一輪直接建構功能；改用建構流程的 design-to-build contract（DO NOT use when: immediate build is the goal）。"
required_skills: [tech-stack-protocol]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: blueprint
  role: planner
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read", "mcp:cartridge-system"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before memory/context writes"
  automation_safe: false
---

A2 owner references: `Shared/policies/project-context-protocol.md`.


Governance references: `Shared/policies/references/workflow-review-visual-evidence.md`, `Shared/policies/requirement-precision.md`, `Shared/policies/review-governance.md`.


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

This Antigravity workflow entry is a thin route entry. It selects workflow row `02`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `02` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `02 Blueprint`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證（`unverified`）或阻塞（`blocked`）。

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `02`.
- Procedure reference: `02 Blueprint` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Replay requirements, ground assumptions, record architecture decisions, then hand off to build or audit only with clear boundaries.
- Replay requirements, non-goals, constraints, assumptions, and acceptance criteria.
- Ground architecture claims against current files, tool output, memory/context, and official sources when relevant.
- Record decisions, rejected alternatives, compatibility impact, migration path, and rollback path.
- Produce a build handoff contract only when implementation boundary, validation expectation, memory/docs impact, and unresolved risks are clear.
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
