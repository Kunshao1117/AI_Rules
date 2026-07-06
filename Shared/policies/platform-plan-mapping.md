# Platform Plan Mapping Contract

This policy maps platform-visible plan surfaces to AI_Rules workflow states.

It does not replace these owner layers:

- Workflow orchestration.
- Authorization resolution.
- Team-Native boards.
- Delivery artifacts.
- Validation.
- Review.
- Memory/docs delivery.
- Completion gates.

Source file: `Shared/policies/platform-plan-mapping.md`.

Runtime copy: `.agents/shared/policies/platform-plan-mapping.md`.

Normal sync direction is source-to-deployed; both files must remain content-identical when both exist.

## Plan Surface Boundary

Platform plan surfaces include these progress mirrors:

- Codex `update_plan`.
- Claude plan/checklist surfaces.
- Antigravity workflow planning UI.
- Equivalent progress mirrors.

They may show intended steps, progress, blockers, or next routing.

They are not these evidence or authority types:

- Authorization.
- Implementation evidence.
- Validation evidence.
- Review evidence.
- Memory/docs evidence.
- Source/deployed parity evidence.
- Completion evidence.

Codex `update_plan` is a visual mirror only.

A plan item marked `completed` means the mirror says the step is done; it does not prove the underlying workflow state is complete.

Completion still requires the owning delivery artifact and validation/review/memory/docs disposition.

It also requires source/deployed parity and the completion gate.

A Director response to a visible plan can become an authorization signal only after authorization resolution binds the current scope.

The binding must identify the current station, phase, file allowlist, command, expiry, and required protected gate.

The plan surface itself must not be recorded as `authorization_source`, `authorization_evidence`, or a protected-action approval.

## Workflow State Mapping

### `plan-only`

- Meaning: Non-mutating plan, outline, option set, or architecture proposal that may guide later work.
- Allowed output: Requirements replay, assumptions, alternatives, architecture decisions, and route recommendation.
- Forbidden shortcut: Do not treat as build authorization, change delivery, validation, review, memory/docs delivery, or completion.

### `02-blueprint`

- Meaning: Architecture contract work under workflow row `02`; normally `formal-readonly` when Team mode is active.
- Allowed output: Build handoff boundaries, compatibility notes, unresolved risks, and acceptance expectations.
- Forbidden shortcut: Do not write source or imply that the architecture artifact authorizes workflow `03` implementation.

### `build-plan`

- Meaning: Workflow `03` design-to-build contract before implementation.
- Allowed output:
  - File allowlist, task-to-acceptance mapping, and validation route.
  - Review expectation, memory/docs impact, source/deployed sync plan, and standby implementation trigger.
- Forbidden shortcut: Do not confuse with `plan-only`; it prepares implementation but still waits for authorization resolution.

### `implementation`

- Meaning: Authorized `formal-write` station-owned change delivery.
- Allowed output:
  - Main-worktree change delivery.
  - Isolated/text change delivery.
  - Fallback change application only inside the resolved scope.
- Forbidden shortcut: Do not use plan UI state, workflow route, or `update_plan` status as write authority.

### `validation`

- Meaning: Non-mutating checks after change delivery exists or is honestly blocked/unverified/risk-closed.
- Allowed output: Test, command, browser, MCP, or manual validation evidence with pass/fail/blocked/unverified state.
- Forbidden shortcut: Do not mark a plan item complete as validation evidence.

### `review`

- Meaning: Independent review after the relevant change delivery artifact or blocked/unverified/risk-closed state exists.
- Allowed output: Requirement fit, correctness, maintainability, regression risk, and evidence-integrity judgment.
- Forbidden shortcut: Do not let the implementation author self-review through a plan checklist.

### `memory-docs`

- Meaning: Source-memory, documentation, index, generated-copy, or public-contract impact disposition.
- Allowed output: `memory_impact`, `memory_delivery`, and blocked/unverified/not-required state.
- Forbidden shortcut: Do not mutate memory from plan approval or hide memory blockers behind a completed plan item.

### `completion`

- Meaning: Final completion audit after required station evidence is present or honestly non-complete.
- Allowed output: Completion state, residual risk, parity evidence, validation/review/memory disposition, and Director-facing summary.
- Forbidden shortcut: Do not use `update_plan` `completed` as `completion_state: complete`.

## Plan-Only Versus Build-Plan

`plan-only` answers what should be considered and normally stops before file scope is authorized.

It may be sufficient for workflow `02` when the Director asked only for architecture, options, or a proposal.

`build-plan` answers what exact implementation boundary is ready to hand to workflow `03`.

The boundary includes required behavior, allowed files, acceptance checks, validation route, and review need.

The boundary also includes memory/docs impact and source/deployed sync expectation.

It is still not write authorization.

Implementation begins only after a scope-bound intent signal resolves to `implementation-change-delivery` or the matching fallback phase.

When the same conversation moves from `02-blueprint` to `build-plan`, record the transition explicitly.

The blueprint artifact may inform the build-plan.

It does not replace the `03` authorization boundary or the later delivery, validation, review, memory/docs, and completion states.

## Invalid Plan Mappings

These are blocked, unverified, or closed-with-director-risk patterns, not complete work:

- Treating Codex `update_plan`, a checklist, or a UI planning surface as write authorization.
- Treating a plan item marked `completed` as validation, review, memory/docs, source/deployed parity, or completion evidence.
- Starting implementation from `plan-only` without a `build-plan` boundary when workflow `03` needs one.
- Expanding file scope because a plan surface is broad or ambiguous.
- Hiding blocked validation, review, memory/docs, or parity behind a progress mirror.
- Recording a platform plan surface as a delivery artifact instead of routing to the owning station artifact.
