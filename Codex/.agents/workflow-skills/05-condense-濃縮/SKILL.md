---
name: "05-condense-濃縮"
description: "專案濃縮與永久上下文建立：適用於初始化濃縮、萃取 PROJECT IDENTITY、掃描代碼庫並寫入永久上下文（Use when: condense, project identity, persistent context）。不適用於只讀既有記憶或一般架構說明（DO NOT use when: memory read, architecture explanation）。"
required_skills: []
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: condense
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
  human_gate: "Director invocation required"
  automation_safe: false
---

A2 owner references: `Shared/policies/project-context-protocol.md`.
Frozen relation IDs still use `Shared/policies/references/legacy-skill-migration.md`; read documents without Skill invocation or changed Memory semantics.


## Workflow Entry Contract

This Codex workflow skill entry is a thin route entry.
It selects workflow row `05`, applies the platform adapter, and points to shared procedures when details are needed.
It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Load references on demand; this entry stays a route contract, not a fixed preflight reading list.

1. Start with workflow row `05`, the route summary below, `.agents/shared/workflow-capability-evidence-matrix.md` row `05`, and `.agents/shared/policies/workflow-orchestration.md` for route/authorization order. Team-specific references apply only if execution-routing actually selects Team or an existing frozen consumer requires them.
2. Director-facing output: read `.agents/shared/policies/language-governance.md` before wording reports, confirmations, status summaries, handoffs, completion summaries, exact-evidence text, or change descriptions.
3. External facts/freshness: read `.agents/shared/policies/grounding-governance.md` and the relevant external-research sources only when external facts, dates, APIs, versions, source freshness, or research quality can affect the conclusion.
4. Platform semantics: read `.agents/shared/platform-capability-matrix.md` only when platform adapter behavior, tool capability, permission surface, or evidence limits affect the route.
5. Platform plan mapping: read `.agents/shared/policies/platform-plan-mapping.md` only when a platform plan surface, Codex `update_plan`, `plan-only`, or `build-plan` affects route, authorization wording, progress, handoff, or completion language.
6. Skill/stage governance: read `.agents/shared/skill-governance.md` only when editing workflow entries, skills, shared policies, or governance boundaries; read `.agents/shared/workflow-stage-procedures.md` only when the concrete phase checklist is needed, using section `05 Condense` without copying it back here.
7. Load `.agents/shared/policies/memory-governance.md` for relevant Memory Impact Review, `.agents/shared/policies/authorization-resolution.md` for any proposed write, and `.agents/shared/policies/completion-policy.md` for completion. Memory method detail comes from `memory-ops` on demand and `memory-arch` only for owner/topology ambiguity; neither grants authority.
8. Existing frozen consumers may separately resolve legacy board, station, bundle, and receipt references through `.agents/shared/policies/references/legacy-memory-team-transition.md`. Do not load them as ordinary condensation prerequisites.

## Workflow Entry Slimming Guard (入口瘦身防線)

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid requirement into the existing section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `05`.
- Procedure reference: `05 Condense` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Separate stable source-backed facts from temporary observations and propose memory/context updates only through protected gates.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after a scope-bound Director intent signal passes authorization resolution and binds the explicit phase, file set, command, or required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Ordinary completion follows `.agents/shared/policies/completion-policy.md`; a no-write Memory review requires no invented receipt or fixed memory/docs delivery. Frozen legacy consumers retain their own completion contract only when applicable.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
