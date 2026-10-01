---
name: 09_commit
description: "提交、commit、push、版本紀錄、CHANGELOG、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 前置掃描與受治理備份（Use when）。不適用：尚未完成實作或只想查看 git 狀態（DO NOT use when）。"
required_skills:
  - github-ops
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

Governance references: `Shared/policies/review-governance.md`.


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

This Claude command entry is a thin route entry. It selects workflow row `09`, applies the platform adapter, and points to shared procedures when details are needed. It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Before broad reading, station work, validation, review, memory/docs, completion, or any write path:

1. Read `.agents/shared/policies/workflow-orchestration.md` for phase sequence; its legacy board, wave and station body is compatibility-only.
2. Read `.agents/shared/policies/language-governance.md` for Director-facing language, exact-evidence preservation, and change-description rules.
3. Read `.agents/shared/workflow-capability-evidence-matrix.md` and use workflow row `09` as the minimum evidence contract.
4. Read `.agents/shared/platform-capability-matrix.md` and apply only this platform's adapter semantics.
5. When editing workflow entries, skills, shared policies, or governance boundaries, read `.agents/shared/skill-governance.md` before changing placement or wording.
6. When a concrete phase checklist is needed, read `.agents/shared/workflow-stage-procedures.md` and use section `09 Commit`. Do not copy that procedure back into this entry.
7. Formal Team assignment uses `.agents/shared/policies/agent-governance.md`; no legacy station, board, handoff or fixed roster is required.
8. When memory evidence applies, use `.claude/skills/memory-ops/references/memory-mcp-tool-contract.md` plus the MCP Memory Evidence Matrix. Missing memory evidence is `unverified` or `blocked`.

## Workflow Entry Slimming Guard

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `09`.
- Procedure reference: `09 Commit` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Scan readiness and blockers; changelog/source write, memory mutation, git commit, push, tag, release, deployment, and install remain separate protected phases.
- Workflow labels select phase sequence only. Resolve the user's natural-language action and target through the authorization owner; no extra magic phrase is required.
- Existing explicit action + target is sufficient semantic authorization; no second GO is required. Native permission remains independent.
- Changelog/source edits use the current task's local_work scope; explicit Git and protected follow-up actions remain separate.
- Git commit requires a separate scope-bound intent signal plus authorization resolution for the exact staged file set, commit command, git phase, expiry, and protected gate.
- Non-mutating evidence uses observe; legacy formal-readonly is confined to frozen compatibility consumers.
- Necessary bounded implementation and local verification use current local_work authority. Protected actions and explicit local Git scope follow the authorization owner; legacy formal-write remains frozen-compatibility-only.

## Completion Boundary

Use `.agents/shared/policies/verification-strategy.md` for the acceptance-bound
focused/broad scope and direct/independent judgment; `.agents/shared/policies/review-governance.md`
for review applicability; `.agents/shared/policies/completion-policy.md` for task status.
Main may directly verify ordinary work. Use only required independent roles,
preserve source-version freshness and never infer completion from changed files.
Report changed, verified, completed, committed, published and deployed separately.
Memory completion remains separate under its frozen consumer; no legacy ladder
or fixed validation/review/Memory/completion chain is required for general work.

## Frozen verification/completion compatibility

The following original body is legacy compatibility-only for frozen Memory or
legacy release consumers. It is not a general vNext trigger, scope, roster,
completion ladder or status owner. Preserve original anchors and meanings;
never translate vNext states into its bundle, phases or receipts.

<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
## Completion Boundary

- Report evidence status as `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable` whenever the result depends on files, tools, runtime behavior, platform capability, external state, or memory evidence.
- Completion uses existing evidence/state owners; general Team requires no fixed role roster. Keep independent judgment separate from implementation ownership and preserve applicable frozen Memory and source/deployed evidence requirements.
- Missing delivery artifacts, missing parity, unavailable channels, or Director-accepted residual risk must be reported as `blocked`, `unverified`, or `closed-with-director-risk`, not `complete`.
- This entry must stay thin. If more procedure detail is needed, add or update the shared reference instead of expanding this file.

<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
