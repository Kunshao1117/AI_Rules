---
name: "08-audit-健檢"
description: "全光譜專案健檢：適用於專案型態偵測、功能/端點/命令盤點、治理巡檢、深度邏輯審查、真實驗證、效能可靠性與健康報告（Use when: full audit, governance audit, health report）。不適用於只要單一測試或單一 bug 修復（DO NOT use when: single test, single bug fix）。"
required_skills: [audit-engine, quality-review-governance]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none for no-write audit; separate audit-log-write stage required for filesystem:write:logs"
  automation_safe: false
---

## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry.
It selects workflow row `08`, applies the platform adapter, and points to shared procedures when details are needed.
It does not grant source write, audit-log write during no-write audit, memory, git, release, deployment, install, credential, or external-state authority.
The `filesystem:write:logs` tool scope is a conditional capability only; writing audit logs is a separate `audit-log-write` stage scoped only to `.agents/logs/`.

## Required References

Load references on demand; this entry stays a route contract, not a fixed preflight reading list.

1. Captain entry minimum: start with workflow row `08`, the route summary below, `.agents/shared/workflow-capability-evidence-matrix.md` row `08`, `.agents/shared/policies/workflow-orchestration.md` for route/authorization order, and the minimum Team-Native entry gate in `.agents/shared/policies/team-native-core.md`.
2. Director-facing output: read `.agents/shared/policies/language-governance.md` before wording reports, confirmations, status summaries, handoffs, completion summaries, exact-evidence text, or change descriptions.
3. External facts/freshness: read `.agents/shared/policies/grounding-governance.md` and the relevant external-research sources only when external facts, dates, APIs, versions, source freshness, or research quality can affect the conclusion.
4. Platform semantics (conditional): read `.agents/shared/platform-capability-matrix.md` when platform adapter behavior, tool capability, permission surface, evidence limits, protected phases, source-impacting work, or audit-log-write capability affects the route.
5. Platform plan mapping: read `.agents/shared/policies/platform-plan-mapping.md` only when a platform plan surface, Codex `update_plan`, `plan-only`, or `build-plan` affects route, authorization wording, progress, handoff, or completion language.
6. Skill/stage governance: read `.agents/shared/skill-governance.md` only when editing workflow entries, skills, shared policies, or governance boundaries; read `.agents/shared/workflow-stage-procedures.md` only when the concrete phase checklist is needed, using section `08 Audit` without copying it back here.
7. Phase and station details: load write, protected-action, review, validation, memory/docs, completion, and delivery artifact references only when that decision, station, or phase is actually opened. Missing evidence remains `unverified`, `blocked`, or `closed-with-director-risk`; no gate is relaxed.
8. Team-Native details: opened stations load their assigned specialist, board, handoff, role-boundary, delivery, validation, review, memory/docs, and completion skills. These are station/phase-owned references, not captain-entry preloads. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix.
9. Optional deterministic scan: load `code-audit` only when a separate scan phase or returned scan artifact is requested. `audit-engine` remains the semantic and logic owner for `/08_audit`.

## Workflow Entry Slimming Guard (入口瘦身防線)

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid requirement into the existing section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `08`.
- Procedure reference: `08 Audit` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Run `08-1` inventory artifact before `08-2` logic-review artifact, and consume both before `08-3` final report; do not repair inside audit.
- Audit log writing is not part of no-write audit evidence. Open a separate `audit-log-write` stage scoped only to `.agents/logs/` before writing `profile.json`, `inventories.json`, `evidence.json`, `summary.md`, or equivalent logs.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a scope-bound Director intent signal passes authorization resolution and binds the explicit phase, file set, command, or required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Process completion requires separated implementation change delivery when a source/document change exists, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
