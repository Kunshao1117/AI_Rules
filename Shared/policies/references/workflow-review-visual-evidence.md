# Workflow Review And Visual Evidence Reference

This reference holds workflow evidence rules that are too detailed for `Shared/workflow-capability-evidence-matrix.md`.

The matrix keeps the per-workflow rows; this file keeps the supporting review, intent, and visual evidence tables.

## Change Intent Classification Matrix

Production build, fix, test, and audit workflows must classify the requested change before writing or declaring completion.

The classification is evidence governance, not wording preference.

### Emergency patch

- Allowed use: Temporarily stop an acute failure, isolate risk, or unblock operation while preserving a follow-up path.
- Minimum evidence:
  - Reproduced symptom, smallest affected scope, and rollback or follow-up note.
  - Explicit unresolved-root-cause marker when root cause is not fixed.
- Must escalate when:
  - Same area needs a second patch.
  - Cause remains unknown.
  - Behavior crosses module boundaries.
  - Verification depends on real data/operator flow.

### Root-cause fix

- Allowed use: Correct a confirmed defect, regression, or invariant violation.
- Minimum evidence:
  - Symptom, root cause, repair scope, and regression route.
  - Affected memory ownership and real-path evidence when the behavior is observable.
- Must escalate when: Structural duplication, unclear module boundary, repeated failures, or fix requires changing public behavior/contract.

### Local cleanup

- Allowed use: Improve local clarity, naming, documentation, test boundary, or maintainability without changing behavior.
- Minimum evidence:
  - Behavior-unchanged rationale, affected scope, and targeted validation.
  - No hidden user-visible/data/public-interface impact.
- Must escalate when: Data flow, state model, interface behavior, cross-workflow rule, or repeated adjacent edits are touched.

### Structural refactor

- Allowed use: Redraw module boundaries, remove patch stacks, simplify shared contracts, or reduce systemic maintenance risk.
- Minimum evidence:
  - Dependency impact, migration or compatibility path, and regression matrix.
  - Memory/docs impact and visual/real evidence where surfaces are user-visible.
- Must escalate when: Verification capacity is insufficient; split into reviewable stages instead of pretending the refactor is complete.

Patch-stack rule: a workflow must not keep adding emergency patches after one patch in the same symptom family.

The same limit applies to the same file region or operator path.

It must route to root-cause repair or structural refactor.

The exception is explicit Director acceptance of a temporary unresolved-risk marker.

## Intent Alignment Governance Matrix

Architecture and build workflows must preserve Director intent as a traceable contract instead of relying on agreeable summaries.

### Requirement replay

- Required artifact: Goal, non-goals, constraints, and success criteria.
- Minimum evidence: Current prompt, relevant memory/context, source files, and explicitly marked assumptions.

### Neutral counter-evidence

- Required artifact: Observed facts, possible issues, and recommended handling.
- Minimum evidence: Source/tool/official evidence when available; inference must be labeled.

### Decision record

- Required artifact: Accepted, rejected, and deferred decisions with alternatives and trade-offs.
- Minimum evidence: Decision status plus evidence level.

### Requirement trace

- Required artifact: Requirement-to-plan and task-to-acceptance mapping.
- Minimum evidence: Every requirement has a planned task or a recorded rejection/narrowing decision.

### Drift audit

- Required artifact: Aligned, justified deviation, unauthorized deviation, or unverified.
- Minimum evidence: Original request, approved plan, actual changes, and validation evidence compared before completion.

## Review Lifecycle Governance Matrix

Engineering review is separate from evidence collection.

Evidence branches may collect facts.

Review purpose, review state, and lifecycle risk decisions stay with the owner station or completion gate.

Release/completion readiness evidence also stays with the owner station or completion gate.

The captain synthesizes station results for Director-facing reporting only.

`accepted-risk` belongs only to the review lifecycle: it accepts a bounded review risk.

It is not a station, evidence, missing-artifact, platform, or completion state.

`closed-with-director-risk` closes a named Team-Native evidence gap by Director decision and remains non-complete.

### `not-started`

- Use when: Review is not required yet, or no review trigger is present.
- Minimum evidence: No-review reason or pending trigger.

### `collecting-evidence`

- Use when: Files, commands, docs, logs, or helper evidence are still being gathered.
- Minimum evidence: Evidence scope and current missing pieces.

### `findings-open`

- Use when: Concrete issues exist and still need disposition.
- Minimum evidence: Issue list tied to source, tool output, docs, logs, or observed behavior.

### `fix-required`

- Use when: At least one issue blocks acceptance.
- Minimum evidence: Required fix, owner workflow, and validation path.

### `fixed-pending-validation`

- Use when: A fix exists, but verification has not passed yet.
- Minimum evidence: Changed scope and pending validation command or real-path check.

### `accepted`

- Use when: Evidence supports correctness, quality, and required validation.
- Minimum evidence: Passing validation and alignment evidence.

### `accepted-risk`

- Use when: Review lifecycle can proceed with a known bounded risk.
- Minimum evidence: Explicit risk, reason, owner, and Director-visible limitation.

### `blocked`

- Use when: Required access, evidence, approval, or external state is missing.
- Minimum evidence: Blocker, attempted evidence path, and smallest unblock condition.

Review state is mandatory for governance, workflow, public contract, release/plugin behavior, and security changes.

It is also mandatory for cross-module, data/state, repeated fragile-code, or high-recovery-cost changes.

Low-risk local edits may record targeted validation without a lifecycle review.

## Visual Evidence Governance Matrix

Visual validation must inspect details and prefer real information.

Screenshots prove visible state only.

They do not prove data correctness, persistence, business logic, permissions, system integration, or post-action side effects.

### Detail inspection

- Must do:
  - Inspect text clipping, button alignment, spacing, border breaks, and overlap.
  - Inspect focus state, disabled state, loading flicker, empty state, error state, density, and hierarchy.
- Must not claim: Do not pass a UI by saying the overall screenshot looks fine.

### Real information first

- Must do:
  - Use real pages, real data, real account state, current logs, and current responses before synthetic examples.
  - Use an equivalent real path before synthetic examples when direct real information is unavailable.
- Must not claim: Do not treat mock, fixture, seeded, fake, or idealized sample data as completed real validation.

### Fake-data fallback

- Must do: Use fake data only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized.
- Must do: Record the fake-data reason and risk.
- Must not claim: Do not present fallback fake-data screenshots as real production-like evidence.

### State coverage

- Must do: Cover normal, loading, empty, error, permission/disabled, and before/after interaction states when applicable.
- Must not claim: Do not use a single initial screenshot to pass a whole flow.

### Size coverage

- Must do:
  - Match mobile/tablet/desktop for web.
  - Match panel widths/themes for IDE panels.
  - Match window sizes for desktop GUI and narrow output for terminal.
- Must not claim: Do not treat one large desktop screenshot as responsive or interface adaptation proof.

### Visual regression

- Must do: For refactor or broad UI adjustment, compare before/after and explain intended and unintended detail differences.
- Must not claim: Do not ignore all diffs, and do not fail all diffs without semantic review.

### Pure document or rules

- Minimum evidence: Source read, semantic search, and rule consistency evidence.
- Additional requirement: Do not claim product UI validation.

### Component or page styling

- Minimum evidence: Real rendered screenshots across required sizes plus detail-observation notes.
- Additional requirement: Screenshots must use real-information pages first; fake data is fallback only.

### Interactive flow

- Minimum evidence: User-path evidence, before/after state, failure or blocked states, and detail checks after action.
- Additional requirement: Include focus, disabled, confirmation, validation, toast/message, and feedback states where relevant.

### Data-driven screen

- Minimum evidence: Real-data normal state plus empty/loading/error or blocked-state evidence.
- Additional requirement: If fake data is used, label why and what remains unverified.

### High-risk visual regression

- Minimum evidence: Before/after comparison, difference explanation, and acceptance rationale.
- Additional requirement: Detail-level deltas must be named, not summarized as only overall direction.
