---
name: 05_condense
description: "專案濃縮初始化、萃取 PROJECT IDENTITY、掃描代碼庫並寫入永久上下文（使用時機：永久上下文 / permanent context）。不適用：只要讀取既有記憶或一般架構說明（DO NOT use when）。"
required_skills: [tech-stack-protocol]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: condense
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
  human_gate: "Director invocation required"
  automation_safe: false
---

A2 owner references: `Shared/policies/project-context-protocol.md`, `Shared/policies/references/legacy-skills/team-task-board/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-change-delivery-artifact/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-validation-delivery-artifact/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-review-delivery-artifact/REFERENCE.md`.
Frozen relation IDs still use `Shared/policies/references/legacy-skill-migration.md`; read documents without Skill invocation or changed Memory semantics. Relevant Memory methods are discovered on demand; the old delivery artifact is not an ordinary command dependency.


Governance references: `Shared/policies/agent-governance.md`, `Shared/policies/agent-governance.md`, `Shared/policies/completion-policy.md`, `Shared/agents/_registry.md`.
Frozen legacy dependencies use `Shared/policies/references/legacy-skill-migration.md`
as document references for existing frozen consumers only; do not activate
Memory roles, bundles, or the old artifact Skill in ordinary work.


## Workflow Entry Contract

This Claude command entry is a thin route entry. It selects workflow row `05`, applies the platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `05` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only this platform's adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read `.agents/shared/skill-governance.md` before changing placement or wording.
6. When a concrete phase checklist is needed, read `.agents/shared/workflow-stage-procedures.md` and use section `05 Condense`. Do not copy that procedure back into this entry.
7. For ordinary work, use `.agents/shared/policies/memory-governance.md` for relevant Memory Impact Review, `.agents/shared/policies/authorization-resolution.md` for writes, and `.agents/shared/policies/completion-policy.md` for completion. Team selection uses the formal Agent owner, not old governance Skills.
8. Discover `memory-ops` when Memory evidence or card method is relevant; discover `memory-arch` only for owner/topology ambiguity. Existing frozen consumers may resolve legacy board, bundle, and receipt references through `.agents/shared/policies/references/legacy-memory-team-transition.md`, never as an ordinary command dependency.

## Workflow Entry Slimming Guard

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `05`.
- Procedure reference: `05 Condense` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Separate stable source-backed facts from temporary observations and propose memory/context updates only through protected gates.
- Treat workflow names, slash commands, skill triggers, workflow buttons, and natural-language requests as routing signals only.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use formal-write only after a scope-bound intent signal has been resolved through authorization resolution to the visible plan, file set, station, command, phase, expiry, and required protected gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Ordinary completion follows `.agents/shared/policies/completion-policy.md`; a no-write Memory review needs no invented receipt or fixed memory/docs delivery. Frozen legacy consumers retain their own completion contract only when applicable.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
