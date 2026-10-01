---
description: "執行 E2E、視覺測試、介面適配證據、瀏覽器功能測試、桌面 GUI 驗證、終端輸出驗證、回歸驗證或測試委派（Use when: validation/test execution）。不要用於只需要單元測試設計或純程式碼審查（DO NOT use when: only unit-test design or code review is needed）。"
required_skills: [test-automation-strategy, browser-testing, a11y-testing, trunk-ops]
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

A2 owner references: `Shared/policies/project-context-protocol.md`.


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

This Antigravity workflow entry is a thin route entry. It selects workflow row `06`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `06` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When selecting evidence, tests, failure routing, or review rendering, read `.agents/shared/policies/verification-strategy.md`; when a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `06 Verify`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證（`unverified`）或阻塞（`blocked`）。

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `06`.
- Procedure reference: `06 Verify` (`06 Test` compatibility alias) in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Select minimum-sufficient verification evidence, define the target surface and evidence level, run non-mutating verification, and route classified failures without repairing inside the validation station.
- Define target surface, evidence level, environment, commands, browser/operator path, and expected pass/fail state.
- Use non-mutating validation by default and preserve blocked or unverified evidence states.
- Classify unit, integration, regression, visual, performance, accessibility, real execution, blocked, and unverified evidence separately.
- Route failed verification to 04, 07, or 03; use `deep-audit` only for the positive triggers in `verification-strategy.md`. The validation station does not repair the implementation it verifies.
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
