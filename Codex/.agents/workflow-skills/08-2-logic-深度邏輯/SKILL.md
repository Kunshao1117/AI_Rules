---
name: "08-2-logic-深度邏輯"
description: "Use when: 健檢第二階段、依盤點清單做深度邏輯審查、安全架構、API/端點/資料流串接比對、功能操作驗證、狀態不變量、測試覆蓋缺口、真實證據缺口、效能可靠性、plugin、VSIX、Release、version、tag、update reminder 與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [audit-engine, quality-review-governance, programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---

## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry. It selects workflow row `08`, applies the platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `08` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only this platform's adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read `.agents/shared/skill-governance.md` before changing placement or wording.
6. When a concrete phase checklist is needed, read `.agents/shared/workflow-stage-procedures.md` and use section `08-2 Logic Review`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, and `.agents/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is `未驗證` or `阻塞`.

## 入口瘦身防線（Workflow Entry Slimming Guard）

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `08`.
- Procedure reference: `08-2 Logic Review` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Review architecture, state flow, security, reliability, validation coverage, governance consistency, and evidence integrity.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after scoped GO tied to the visible plan, station, file set, command, or protected phase.

## Completion Boundary

- Report evidence status as `足夠證據`, `部分證據`, `未驗證`, `阻塞`, or `不適用` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Full team completion requires separated implementation change delivery, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
