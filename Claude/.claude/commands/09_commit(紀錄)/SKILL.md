---
name: 09_commit
description: "提交、commit、push、版本紀錄、CHANGELOG、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 前置掃描與受治理備份（Use when）。不適用：尚未完成實作或只想查看 git 狀態（DO NOT use when）。"
required_skills:
  - github-ops
  - quality-review-governance
  - programming-team-governance
  - team-specialist-registry
  - team-task-board
  - team-role-boundaries
  - team-change-delivery-artifact
  - team-memory-docs-delivery-artifact
  - team-validation-delivery-artifact
  - team-review-delivery-artifact
  - team-completion-gate
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: commit
  role: sre
  memory_awareness: read
  tool_scope: ["filesystem:write", "git:write", "terminal:read"]
  human_gate: "scope-bound intent signal plus authorization resolution required before each changelog/source write, git commit, or protected phase"
  automation_safe: false
---

## Workflow Entry Contract

This Claude command entry is a thin route entry. It selects workflow row `09`, applies the platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for route, authorization, operation mode, board, wave, artifact, and completion order.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `09` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only this platform's adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read `.agents/shared/skill-governance.md` before changing placement or wording.
6. When a concrete phase checklist is needed, read `.agents/shared/workflow-stage-procedures.md` and use section `09 Commit`. Do not copy that procedure back into this entry.
7. For Team-Native work, load `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-board/SKILL.md`, `.claude/skills/team-station-handoff-packet/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, and `.claude/skills/team-completion-gate/SKILL.md`; load delivery-artifact skills only when their stations apply.
8. When memory evidence applies, use `.claude/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is `unverified` or `blocked`.

## Workflow Entry Slimming Guard

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, update both sides and verify hash or content parity before any completion claim.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `09`.
- Procedure reference: `09 Commit` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Scan readiness and blockers; changelog/source write, memory mutation, git commit, push, tag, release, deployment, and install remain separate protected phases.
- Treat workflow names, slash commands, skill triggers, workflow buttons, natural-language requests, and Director `GO` as routing or intent signals only.
- Director `GO` becomes usable authority only after authorization resolution binds the current visible plan, station, file set, command, phase, expiry, and any required protected gate.
- Changelog/source write requires its own scope-bound intent signal plus authorization resolution for the active station, file set, command, phase, expiry, and protected gate.
- Git commit requires a separate scope-bound intent signal plus authorization resolution for the exact staged file set, commit command, git phase, expiry, and protected gate.
- Use `formal-readonly` for evidence and planning that can influence source, workflow, validation, review, memory, release, or governance decisions.
- Use `formal-write` only after authorization resolution binds the active station, file set, command, phase, expiry, and required gate.

## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Full team completion requires separated implementation change delivery, memory/docs delivery, validation delivery, review delivery, source/deployed parity when relevant, and completion audit evidence.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.
