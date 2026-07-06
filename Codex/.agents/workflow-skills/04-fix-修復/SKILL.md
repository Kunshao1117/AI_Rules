---
name: "04-fix-修復"
description: "正式修復與回歸處理：適用於修 bug、修復回歸、排除錯誤、診斷缺陷後執行修復（Use when: fix, bug repair, regression repair）。不適用於新功能建構或純除錯說明（DO NOT use when: feature build, debug-only explanation）。"
required_skills: [impact-test-strategy]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: fix
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "scope-bound intent signal plus authorization resolution required before writes"
  automation_safe: false
---

## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry.
It selects workflow row `04`, applies the platform adapter, and points to shared procedures when details are needed.
It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Load references on demand; this entry stays a route contract, not a fixed preflight reading list.

1. Captain entry minimum: start with workflow row `04`, the route summary below, `.agents/shared/workflow-capability-evidence-matrix.md` row `04`, `.agents/shared/policies/workflow-orchestration.md` for route/authorization order, and the minimum Team-Native entry gate in `.agents/shared/policies/team-native-core.md`.
2. Director-facing output: read `.agents/shared/policies/language-governance.md` before wording reports, confirmations, status summaries, handoffs, completion summaries, exact-evidence text, or change descriptions.
3. External facts/freshness: read `.agents/shared/policies/grounding-governance.md` and the relevant external-research sources only when external facts, dates, APIs, versions, source freshness, or research quality can affect the conclusion.
4. Platform semantics: read `.agents/shared/platform-capability-matrix.md` only when platform adapter behavior, tool capability, permission surface, or evidence limits affect the route.
5. Platform plan mapping: read `.agents/shared/policies/platform-plan-mapping.md` only when a platform plan surface, Codex `update_plan`, `plan-only`, or `build-plan` affects route, authorization wording, progress, handoff, or completion language.
6. Skill/stage governance: read `.agents/shared/skill-governance.md` only when editing workflow entries, skills, shared policies, or governance boundaries; read `.agents/shared/workflow-stage-procedures.md` only when the concrete phase checklist is needed, using section `04 Fix` without copying it back here.
7. Phase and station details: load write, protected-action, review, validation, memory/docs, completion, and delivery artifact references only when that decision, station, or phase is actually opened. Missing evidence remains `unverified`, `blocked`, or `closed-with-director-risk`; no gate is relaxed.
8. Team-Native details: opened stations load their assigned specialist, board, handoff, role-boundary, delivery, validation, review, memory/docs, and completion skills. These are station/phase-owned references, not captain-entry preloads. When memory evidence applies, use `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix.

## Workflow Entry Slimming Guard (入口瘦身防線)

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If target files already have worktree changes, read the current diff first, integrate still-valid requirements into the existing section, and do not append duplicate rule blocks.

## Phase Order

- Workflow row: `04`.
- Procedure reference: `04 Fix` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Start from symptom and root cause; plan regression evidence; repair only the scoped cause after scoped authorization resolution.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a scope-bound intent signal has been resolved to the visible plan, station, file set, command, phase, expiry, and any required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Full team completion requires separated implementation change delivery, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
