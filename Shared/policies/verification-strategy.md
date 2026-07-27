# Verification Strategy Policy

This policy owns minimum-sufficient verification evidence selection, ordinary
test admission, focused-versus-full verification boundaries, verification
budget, failure classification, and Director-facing verification outcomes.
It does not authorize source writes or protected actions, define Team artifact
schemas, or replace workflow routing. Those concerns remain with
`authorization-resolution.md`, the workflow procedures and matrix, and the
matching Team delivery-artifact skills.

## Evidence Selection

Select the lowest sufficient evidence level that can directly establish the
named acceptance or bounded risk. Do not add a new test, test framework,
runner, fixture system, or full suite by default. A broader level is justified
only when the lower level cannot prove the same acceptance and the stated risk
needs the broader evidence.

The seven-level ladder is:

1. `parse_or_structured_static`: parse, schema, frontmatter, reference, or
   source/deployed-parity check.
2. `targeted_lint_or_type`: a targeted lint, type, or deterministic static
   rule check.
3. `targeted_existing_local_test`: one existing, targeted local test.
4. `scoped_deterministic_scan`: a bounded deterministic scan of the affected
   surface.
5. `controlled_local_runtime`: a local or controlled real operator path.
6. `affected_regression_set`: the focused regression set for the changed
   contract or impact surface.
7. `full_suite`: the project-wide suite.

The ladder is a selection boundary, not an automatic sequence. Stop at the
first level that supplies sufficient evidence. `full_suite` requires an
explicit reason that the focused route cannot bound the acceptance or risk.
For a UI, layout, interaction, or operator-visible change, static, unit, and
CLI evidence cannot replace real UI or visual proof matched to the affected
surface. A screenshot proves visible state only; data, persistence, and
integration claims also need their corresponding real-path evidence.

## Existing Test Classification

Classify an existing test before selecting it:

- `local_non_destructive`: uses local, read-safe inputs and does not mutate a
  persistent, shared, or external target. A targeted existing test in this
  class is ordinary verification.
- `local_side_effectful`: creates or changes a local target. Use it only with
  an isolated or temporary target, planned cleanup, and a dirty-worktree
  safety check.
- `external_or_protected`: reaches external state or a protected surface. It
  requires the matching protected gate; its test label never bypasses it.
- `unknown`: its side effects or target are not established. Inspect it before
  execution; do not infer a safe class.

## Durable Test Admission And Budget

Admit a new durable test only when all of these hold:

1. It protects a stable, named invariant or a confirmed regression that lower
   ladder levels cannot directly prove.
2. The project already has a suitable local test pattern and runner; this
   admission never justifies a new framework or runner.
3. The assertion has an independent oracle: it comes from accepted behavior,
   an authoritative contract, or an observable result rather than duplicating
   the implementation or merely confirming a test helper.
4. Pre-change evidence records the prior behavior or defect condition, and
   post-change evidence uses the same oracle to show the intended regression
   boundary. When pre-change execution is unavailable, record why instead of
   inventing it.
5. The durable delta stays within the default budget: one named behavior in
   one existing test file, plus at most one indispensable adjacent fixture. It
   adds no framework, runner configuration, broad helper layer, bulk snapshot,
   or unrelated test cleanup.
6. The exact test files and any test execution remain within separately
   resolved write and execution scope.

Otherwise use the smallest sufficient non-test evidence or report the gap.
This policy's admission decision does not itself grant the write or protected
authority required by another owner.

## Failure Classification And Stop Rule

Classify a failed check before retrying, repairing, or widening its scope as
exactly one of:

- `product_defect`
- `test_or_checker_defect`
- `environment_or_tool_defect`
- `requirement_ambiguity`
- `intentional_behavior_change`

For `environment_or_tool_defect`, one safe retry or equivalent local path may
be used when it is likely to resolve readiness or tooling noise. Two
consecutive infrastructure failures on the same evidence path stop further
retries and route the result as blocked with the attempted path and missing
condition. A validation failure alone does not launch `deep-audit`; route the
classified issue to the existing fix, debug, build, or explore path.

## Review Rendering

One concentrated independent review covers the selected scope. Its internal
terminal decision is exactly `pass`, `pass_with_followups`, or `block`.
User-visible wording is synthesized through
`Shared/policies/language-governance.md` and the status display labels in
`status-ontology.md`; never lead a general reply with those raw values. A
single recheck is permitted only for the declared blockers from that review;
do not start an unbounded re-review loop. Review lifecycle fields and delivery
artifacts stay with their specialist owners.

## Direct And Formal Trace Boundaries

Ordinary Direct verification records only the target, selected method,
evidence, judgment, and residual risk. It does not require a Team board,
station, handoff packet, or formal trace.

Formal trace is required only for delegated topology, a protected action,
release, migration, explicitly requested `deep-audit`, or an explicitly
required durable trace. It is not required merely because a check, test,
failure, review, or verification route exists.

## Deep-Audit Boundary

`deep-audit` is admitted only for a positive trigger:

- the Director explicitly requests it;
- a credible security, data-integrity, or irreversible-loss concern is in
  scope;
- a release or migration needs comprehensive cross-surface assurance;
- repeated same-scope evidence conflicts after the bounded repair and
  verification route has been exhausted; or
- a shared or public contract has high blast radius and the selected ladder
  cannot distinguish the material failure mode.

A single failed check, ordinary regression, routine lint result, unclear log,
or a desire for extra certainty is not a `deep-audit` trigger. When selected,
use `code-audit` only for the explicitly scoped deterministic scan method.
