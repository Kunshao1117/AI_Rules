# Platform Plan Mapping Contract

This policy maps platform-visible plan surfaces to AI_Rules workflow states. It
does not replace workflow orchestration, authorization resolution, Team-Native
boards, delivery artifacts, validation, review, memory/docs delivery, or
completion gates.

Source file: `Shared/policies/platform-plan-mapping.md`.
Runtime copy: `.agents/shared/policies/platform-plan-mapping.md`.
Normal sync direction is source-to-deployed; both files must remain
content-identical when both exist.

## Plan Surface Boundary

Platform plan surfaces include Codex `update_plan`, Claude plan/checklist
surfaces, Antigravity workflow planning UI, and equivalent progress mirrors.
They may show intended steps, progress, blockers, or next routing. They are not
authorization, implementation evidence, validation evidence, review evidence,
memory/docs evidence, source/deployed parity evidence, or completion evidence.

Codex `update_plan` is a visual mirror only. A plan item marked `completed`
means the mirror says the step is done; it does not prove the underlying
workflow state is complete. Completion still requires the owning delivery
artifact, validation/review/memory/docs disposition, source/deployed parity when
relevant, and the completion gate.

A Director response to a visible plan can become an authorization signal only
after authorization resolution binds it to the current station, phase, file
allowlist, command, expiry, and required protected gate. The plan surface itself
must not be recorded as `authorization_source`, `authorization_evidence`, or a
protected-action approval.

## Workflow State Mapping

| Mapping state | Meaning | Allowed output | Forbidden shortcut |
|---|---|---|---|
| `plan-only` | Non-mutating plan, outline, option set, or architecture proposal that may guide later work. | Requirements replay, assumptions, alternatives, architecture decisions, and route recommendation. | Do not treat as build authorization, change delivery, validation, review, memory/docs delivery, or completion. |
| `02-blueprint` | Architecture contract work under workflow row `02`; normally `formal-readonly` when Team mode is active. | Build handoff boundaries, compatibility notes, unresolved risks, and acceptance expectations. | Do not write source or imply that the architecture artifact authorizes workflow `03` implementation. |
| `build-plan` | Workflow `03` design-to-build contract before implementation. | File allowlist, task-to-acceptance mapping, validation route, review expectation, memory/docs impact, source/deployed sync plan, and standby implementation trigger. | Do not confuse with `plan-only`; it prepares implementation but still waits for authorization resolution. |
| `implementation` | Authorized `formal-write` station-owned change delivery. | Main-worktree change delivery, isolated/text change delivery, or fallback change application only inside the resolved scope. | Do not use plan UI state, workflow route, or `update_plan` status as write authority. |
| `validation` | Non-mutating checks after change delivery exists or is honestly blocked/unverified/risk-closed. | Test, command, browser, MCP, or manual validation evidence with pass/fail/blocked/unverified state. | Do not mark a plan item complete as validation evidence. |
| `review` | Independent review after the relevant change delivery artifact or blocked/unverified/risk-closed state exists. | Requirement fit, correctness, maintainability, regression risk, and evidence-integrity judgment. | Do not let the implementation author self-review through a plan checklist. |
| `memory-docs` | Source-memory, documentation, index, generated-copy, or public-contract impact disposition. | `memory_impact`, `memory_delivery`, and blocked/unverified/not-required state. | Do not mutate memory from plan approval or hide memory blockers behind a completed plan item. |
| `completion` | Final completion audit after required station evidence is present or honestly non-complete. | Completion state, residual risk, parity evidence, validation/review/memory disposition, and Director-facing summary. | Do not use `update_plan` `completed` as `completion_state: complete`. |

## Plan-Only Versus Build-Plan

`plan-only` answers what should be considered and normally stops before file
scope is authorized. It may be sufficient for workflow `02` when the Director
asked only for architecture, options, or a proposal.

`build-plan` answers what exact implementation boundary is ready to hand to
workflow `03`: required behavior, allowed files, acceptance checks, validation
route, review need, memory/docs impact, and source/deployed sync expectation.
It is still not write authorization. Implementation begins only after a
scope-bound intent signal is resolved to `implementation-change-delivery` or the
matching fallback phase.

When the same conversation moves from `02-blueprint` to `build-plan`, record
the transition explicitly. The blueprint artifact may inform the build-plan,
but it does not replace the `03` authorization boundary or the later delivery,
validation, review, memory/docs, and completion states.

## Invalid Plan Mappings

These are blocked, unverified, or closed-with-director-risk patterns, not
complete work:

- Treating Codex `update_plan`, a checklist, or a UI planning surface as write
  authorization.
- Treating a plan item marked `completed` as validation, review, memory/docs,
  source/deployed parity, or completion evidence.
- Starting implementation from `plan-only` without a `build-plan` boundary when
  workflow `03` needs one.
- Expanding file scope because a plan surface is broad or ambiguous.
- Hiding blocked validation, review, memory/docs, or parity behind a progress
  mirror.
- Recording a platform plan surface as a delivery artifact instead of routing
  to the owning station artifact.
