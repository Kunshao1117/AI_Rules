# Workflow Review And Visual Evidence Reference

This reference holds workflow evidence rules that are too detailed for
`Shared/workflow-capability-evidence-matrix.md`. The matrix keeps the
per-workflow rows; this file keeps the supporting review, intent, and visual
evidence tables.

## Change Intent Classification Matrix

Production build, fix, test, and audit workflows must classify the requested
change before writing or declaring completion. The classification is evidence
governance, not wording preference.

| Change intent | Allowed use | Minimum evidence | Must escalate when |
|---|---|---|---|
| Emergency patch | Temporarily stop an acute failure, isolate risk, or unblock operation while preserving a follow-up path | Reproduced symptom, smallest affected scope, rollback or follow-up note, and explicit unresolved-root-cause marker when root cause is not fixed | Same area needs a second patch, cause remains unknown, behavior crosses module boundaries, or verification depends on real data/operator flow |
| Root-cause fix | Correct a confirmed defect, regression, or invariant violation | Symptom, root cause, repair scope, regression route, affected memory ownership, and real-path evidence when the behavior is observable | Structural duplication, unclear module boundary, repeated failures, or fix requires changing public behavior/contract |
| Local cleanup | Improve local clarity, naming, documentation, test boundary, or maintainability without changing behavior | Behavior-unchanged rationale, affected scope, targeted validation, and no hidden user-visible/data/public-interface impact | Data flow, state model, interface behavior, cross-workflow rule, or repeated adjacent edits are touched |
| Structural refactor | Redraw module boundaries, remove patch stacks, simplify shared contracts, or reduce systemic maintenance risk | Dependency impact, migration or compatibility path, regression matrix, memory/docs impact, and visual/real evidence where surfaces are user-visible | Verification capacity is insufficient; split into reviewable stages instead of pretending the refactor is complete |

Patch-stack rule: a workflow must not keep adding emergency patches when the
same symptom family, file region, or operator path has already been patched once
in the current cycle. It must route to root-cause repair or structural refactor
unless the Director explicitly accepts a temporary unresolved-risk marker.

## Intent Alignment Governance Matrix

Architecture and build workflows must preserve Director intent as a traceable
contract instead of relying on agreeable summaries.

| Phase | Required artifact | Minimum evidence |
|---|---|---|
| Requirement replay | Goal, non-goals, constraints, and success criteria | Current prompt, relevant memory/context, source files, and explicitly marked assumptions |
| Neutral counter-evidence | Observed facts, possible issues, and recommended handling | Source/tool/official evidence when available; inference must be labeled |
| Decision record | Accepted, rejected, and deferred decisions with alternatives and trade-offs | Decision status plus evidence level |
| Requirement trace | Requirement-to-plan and task-to-acceptance mapping | Every requirement has a planned task or a recorded rejection/narrowing decision |
| Drift audit | Aligned, justified deviation, unauthorized deviation, or unverified | Original request, approved plan, actual changes, and validation evidence compared before completion |

## Review Lifecycle Governance Matrix

Engineering review is separate from evidence collection. Evidence branches may
collect facts, but review purpose, review state, lifecycle risk decisions, and
release/completion readiness evidence stay with the owner station or
completion gate. The captain synthesizes station results for Director-facing
reporting only.

`accepted-risk` belongs only to the review lifecycle: it accepts a bounded
review risk. It is not a station, evidence, missing-artifact, platform, or
completion state. `closed-with-director-risk` closes a named Team-Native
evidence gap by Director decision and remains non-complete.

| Review state | Use when | Minimum evidence |
|---|---|---|
| `not-started` | Review is not required yet, or no review trigger is present | No-review reason or pending trigger |
| `collecting-evidence` | Files, commands, docs, logs, or helper evidence are still being gathered | Evidence scope and current missing pieces |
| `findings-open` | Concrete issues exist and still need disposition | Issue list tied to source, tool output, docs, logs, or observed behavior |
| `fix-required` | At least one issue blocks acceptance | Required fix, owner workflow, and validation path |
| `fixed-pending-validation` | A fix exists, but verification has not passed yet | Changed scope and pending validation command or real-path check |
| `accepted` | Evidence supports correctness, quality, and required validation | Passing validation and alignment evidence |
| `accepted-risk` | Review lifecycle can proceed with a known bounded risk | Explicit risk, reason, owner, and Director-visible limitation |
| `blocked` | Required access, evidence, approval, or external state is missing | Blocker, attempted evidence path, and smallest unblock condition |

Review state is mandatory for governance, workflow, public contract,
release/plugin behavior, security, cross-module, data/state, repeated
fragile-code, or high-recovery-cost changes. Low-risk local edits may record
targeted validation without a lifecycle review.

## Visual Evidence Governance Matrix

Visual validation must inspect details and prefer real information. Screenshots
prove visible state only; they do not prove data correctness, persistence,
business logic, permissions, system integration, or post-action side effects.

| Principle | Must do | Must not claim |
|---|---|---|
| Detail inspection | Inspect text clipping, button alignment, spacing, border breaks, overlap, focus state, disabled state, loading flicker, empty state, error state, density, and hierarchy | Do not pass a UI by saying the overall screenshot looks fine |
| Real information first | Use real pages, real data, real account state, current logs, current responses, or an equivalent real path before synthetic examples | Do not treat mock, fixture, seeded, fake, or idealized sample data as completed real validation |
| Fake-data fallback | Use fake data only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized; record the reason and risk | Do not present fallback fake-data screenshots as real production-like evidence |
| State coverage | Cover normal, loading, empty, error, permission/disabled, and before/after interaction states when applicable | Do not use a single initial screenshot to pass a whole flow |
| Size coverage | Match the interface surface: mobile/tablet/desktop for web, panel widths/themes for IDE panels, window sizes for desktop GUI, narrow output for terminal | Do not treat one large desktop screenshot as responsive or interface adaptation proof |
| Visual regression | For refactor or broad UI adjustment, compare before/after and explain intended and unintended detail differences | Do not ignore all diffs, and do not fail all diffs without semantic review |

| Interface type | Minimum evidence | Additional requirement |
|---|---|---|
| Pure document or rules | Source read, semantic search, and rule consistency evidence | Do not claim product UI validation |
| Component or page styling | Real rendered screenshots across required sizes plus detail-observation notes | Screenshots must use real-information pages first; fake data is fallback only |
| Interactive flow | User-path evidence, before/after state, failure or blocked states, and detail checks after action | Include focus, disabled, confirmation, validation, toast/message, and feedback states where relevant |
| Data-driven screen | Real-data normal state plus empty/loading/error or blocked-state evidence | If fake data is used, label why and what remains unverified |
| High-risk visual regression | Before/after comparison, difference explanation, and acceptance rationale | Detail-level deltas must be named, not summarized as only overall direction |
