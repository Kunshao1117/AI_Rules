---
name: "11-handoff-交接"
description: "交接與接手提示產出：適用於 handoff、跨 Codex 對話 continuation package、彙整目前成果並產出下一個 AI 可接手的提示（Use when: handoff, cross-thread continuation, transition prompt）。不適用於在目前對話繼續實作或執行提交（DO NOT use when: continue implementation here, commit execution）。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["cursor"]
  lifecycle_phase: handoff
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "mcp:read"]
  human_gate: "none"
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

This Cursor workflow skill entry is a thin route entry.
It selects workflow row `11`, applies the platform adapter, and points to shared procedures when details are needed.
It does not grant write, memory, git, release, deployment, install, credential, or external-state authority.

## Required References

Load references on demand; this entry stays a route contract, not a fixed preflight reading list.

1. Entry minimum: start with workflow row `11`, the route summary below, `.agents/shared/workflow-capability-evidence-matrix.md` row `11`, `.agents/shared/policies/workflow-orchestration.md` for phase sequence. Use `.agents/shared/policies/agent-governance.md` only when formal role assignment is needed.
2. Director-facing output: read `.agents/shared/policies/language-governance.md` before wording reports, confirmations, status summaries, handoffs, completion summaries, exact-evidence text, or change descriptions.
3. External facts/freshness: read `.agents/shared/policies/grounding-governance.md` and the relevant external-research sources only when external facts, dates, APIs, versions, source freshness, or research quality can affect the conclusion.
4. Platform semantics: read `.agents/shared/platform-capability-matrix.md` only when platform adapter behavior, tool capability, permission surface, or evidence limits affect the route.
5. Platform plan mapping: read `.agents/shared/policies/platform-plan-mapping.md` only when a platform plan surface, Cursor plan surfaces, `plan-only`, or `build-plan` affects route, authorization wording, progress, handoff, or completion language.
6. Skill/stage governance: read `.agents/shared/skill-governance.md` only when editing workflow entries, skills, shared policies, or governance boundaries; read `.agents/shared/workflow-stage-procedures.md` only when the concrete phase checklist is needed, using section `11 Handoff` without copying it back here.
7. Phase and station details: load write, protected-action, review, validation, memory/docs, completion, and delivery artifact references only when that decision, station, or phase is actually opened. Missing evidence remains `unverified`, `blocked`, or `unverified`; no gate is relaxed.
8. Formal Team assignment uses Agent Governance; lazy-load only task-specific methods. Frozen Memory uses its unchanged memory-ops contract and evidence matrix when applicable.
9. Cross-thread continuation: load
   `.agents/shared/policies/references/cross-thread-handoff-contract.md` for the
   semantic package, freshness, lifecycle, and target confirmation. Load
   `.agents/shared/policies/adapters/codex-thread-handoff.md` only when current
   Codex thread transport is actually requested.

## Workflow Entry Slimming Guard (入口瘦身防線)

- This entry owns route selection, workflow-specific phase order, minimum load gates, the matching evidence-matrix row, and platform adapter reference only.
- Do not add copied Team-Native policy, board field lists, delivery artifact schemas, completion checklists, specialist lifecycle details, or full stage playbooks here.
- Put durable governance in shared policies, reusable operating procedure in shared skills or references, and workflow stage details in `.agents/shared/workflow-stage-procedures.md`.
- If a source/deployed pair exists, record source-to-runtime direction; verify parity after authorized sync or report deployment pending. Source edits do not authorize sync.
- If the target file already has worktree changes, read the current diff and integrate the still-valid requirement into the existing section instead of appending a duplicate rule block.

## Phase Order

- Workflow row: `11`.
- Procedure reference: `11 Handoff` in `.agents/shared/workflow-stage-procedures.md`.
- Route summary: Summarize current state, per-path worktree state, evidence,
  blockers, memory/context state, validation/review state, and next route.
- For cross-thread continuation, build the shared semantic package first.
  Station handoff, cross-thread handoff, and Codex transport remain separate
  objects and do not share `handoff_packet_id`.
- Codex send/create/move procedures stay in the adapter. Transport success is
  not target confirmation, and the target must re-resolve current authorization
  and protected gates because authority is not transferred.
- Workflow labels select phase sequence only. Resolve the user's natural-language action and target through the authorization owner; no extra magic phrase is required.
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
