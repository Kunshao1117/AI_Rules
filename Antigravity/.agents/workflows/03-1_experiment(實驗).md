---
description: "沙盒快速實驗、可丟棄原型、API spike、創意探索（Use when: rapid sandbox experiments / disposable prototypes）。實驗名稱不會啟動 Team；依 execution-routing 選擇執行方式。Sandbox writes 必須記錄 sandbox scope、discard condition、promotion condition 與 allowed shortcuts；discard/promotion/production promotion 仍需 scope-bound authorization，且不得宣稱 production completion。不要用於生產建構、正式修復或提交/發布（DO NOT use when: production build, formal fix, or commit/release work）。"
required_skills: []
memory_awareness: none
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: experiment
  role: writer
  memory_awareness: none
  tool_scope: ["filesystem:write", "terminal:manual"]
  human_gate: "Scope-bound intent signal plus authorization resolution required before experiment writes"
  automation_safe: false
---

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

This Antigravity workflow entry is a thin route entry. It selects workflow row `03-1`, applies the Gemini/Antigravity platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `03-1` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only Antigravity/Gemini adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read the deployed skill governance reference (`.agents/shared/skill-governance.md`) and framework source reference (`Shared/skill-governance.md`) before changing placement or wording.
6. When a concrete phase checklist is needed, read the deployed stage procedure reference (`.agents/shared/workflow-stage-procedures.md`) and framework source reference (`Shared/workflow-stage-procedures.md`), then use section `03-1 Experiment`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is 未驗證（`unverified`）或阻塞（`blocked`）。

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, full Director-facing/language-governance text, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `03-1`.
- Procedure reference: `03-1 Experiment` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Declare sandbox boundary, allowed change scope, discard conditions, promotion criteria, produce disposable prototype work, mark skipped production gates, then promote or discard explicitly.
- Experiment is a phase sequence; resolve Direct / Assisted / Team through the execution owner before sandbox work.
- In Team, keep the legacy reduced experiment station/board. For every mode, record
  sandbox scope, sandbox boundary, allowed change scope, discard condition,
  promotion condition, and allowed shortcuts before sandbox writes.
- Sandbox writes and team artifacts are experiment-only. They do not equal
  production source completion, memory/docs completion, validation/review
  acceptance, release readiness, or production promotion.
- Discard, promotion, and production promotion remain scope-bound phases.
  Promotion to `03`/build or any formal production source/governance/public-contract
  write requires visible production scope and authorization resolution; in Team, preserve
  formal-write, station-owned change-delivery, validation, review, and memory/docs delivery.
- The captain may coordinate and receive artifacts but must not declare 03-1
  dirty code or team artifacts production complete.
- Keep experiment writes out of production quality, release, memory, and completion claims.
- Mark skipped lint, tests, review, validation, and memory/docs as experiment-only dispositions.
- Promote to 03 only with a production plan plus a new scope-bound intent signal resolved through authorization resolution to the visible production scope.
- Workflow labels select phase sequence only. Resolve the user's natural-language action and target through the authorization owner; no extra magic phrase is required.
- In active Team mode, use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- In active Team mode, use `formal-write` only after a Director intent signal is resolved to the visible plan, station, file set, command, phase, expiry, and required protected gate.

## Completion Boundary

Use `.agents/shared/policies/verification-strategy.md` for focused/broad scope
and direct/independent judgment; `.agents/shared/policies/review-governance.md`
for review applicability; `.agents/shared/policies/completion-policy.md` for
overall request status. Main may directly verify ordinary work. No fixed
validation/review/Memory/completion chain or legacy completion ladder applies.
Keep the six truth facts separate; frozen Memory completion stays independent.
