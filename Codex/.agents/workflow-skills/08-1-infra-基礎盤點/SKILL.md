---
name: "08-1-infra-基礎盤點"
description: "健檢基礎盤點：適用於健檢第一階段、深度選擇、專案型態偵測、功能/端點/命令盤點、平台能力快照、技能覆蓋率、相容性與目錄衛生檢查（Use when: audit inventory, infra scan）。不適用於完整健檢入口，請改用 08-audit（DO NOT use when: full audit entry）。"
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
  human_gate: "none for no-write inventory; separate audit-log-write stage required for filesystem:write:logs"
  automation_safe: false
---

## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry.
It selects workflow row `08`, applies the platform adapter, and points to shared procedures when details are needed.
It does not grant source write, audit-log write during no-write inventory, memory, git, release, deployment, install, credential, or external-state authority.
The `filesystem:write:logs` tool scope is a conditional capability only; writing inventory logs is a separate `audit-log-write` stage scoped only to `.agents/logs/`.

## Required References

Load references on demand; this entry stays a route contract, not a fixed preflight reading list.

1. Captain entry minimum: start with workflow row `08`, the route summary below, `.agents/shared/workflow-capability-evidence-matrix.md` row `08`, `.agents/shared/policies/workflow-orchestration.md` for route/authorization order, and the minimum Team-Native entry gate in `.agents/shared/policies/team-native-core.md`.
2. Director-facing output: read `.agents/shared/policies/language-governance.md` before wording reports, confirmations, status summaries, handoffs, completion summaries, exact-evidence text, or change descriptions.
3. External facts/freshness: read `.agents/shared/policies/grounding-governance.md` and the relevant external-research sources only when external facts, dates, APIs, versions, source freshness, or research quality can affect the conclusion.
4. Platform semantics (conditional): read `.agents/shared/platform-capability-matrix.md` when platform adapter behavior, tool capability, permission surface, evidence limits, protected phases, source-impacting work, or audit-log-write capability affects the route.
5. Platform plan mapping: read `.agents/shared/policies/platform-plan-mapping.md` only when a platform plan surface, Codex `update_plan`, `plan-only`, or `build-plan` affects route, authorization wording, progress, handoff, or completion language.
6. Skill/stage governance: read `.agents/shared/skill-governance.md` only when editing workflow entries, skills, shared policies, or governance boundaries; read `.agents/shared/workflow-stage-procedures.md` only when the concrete phase checklist is needed, using section `08-1 Infra Inventory` without copying it back here.
7. Phase and station details: load write, protected-action, review, validation, memory/docs, completion, and delivery artifact references only when that decision, station, or phase is actually opened. Missing evidence remains `unverified`, `blocked`, or `closed-with-director-risk`; no gate is relaxed.
8. Team-Native details: opened stations load their assigned specialist, board, handoff, role-boundary, delivery, validation, review, memory/docs, and completion skills. These are station/phase-owned references, not captain-entry preloads. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix.

## Workflow Entry Slimming Guard (入口瘦身防線)

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid requirement into the existing section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `08`.
- Procedure reference: `08-1 Infra Inventory` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Inventory project type, surfaces, commands, routes, files, workflows, memory/context, and dependencies before judgment.
- Output contract: return the `08-1` inventory artifact and denominator for `08-2`; this is prerequisite evidence, not a final audit conclusion.
- Audit log writing is not part of no-write inventory evidence. Open a separate `audit-log-write` stage scoped only to `.agents/logs/` before writing `profile.json`, `inventories.json`, or equivalent logs.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a scope-bound Director intent signal passes authorization resolution and binds the explicit phase, file set, command, or required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Process completion requires separated implementation change delivery when a source/document change exists, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
