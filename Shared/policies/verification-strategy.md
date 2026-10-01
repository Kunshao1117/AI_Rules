# Verification Strategy Policy

This is the single general owner of verification scope, independence, evidence
selection, test admission and failure classification. Review applicability is
owned by `review-governance.md`; task completion by `completion-policy.md`.
Provider selection and action permission remain with `capability-resolution.md`
and `authorization-resolution.md`. None of these axes implies another.

## Two independent axes

`verification_scope` is exactly `focused | broad`.
`verification_independence` is exactly `direct | independent`.
Assess each from current acceptance and actual affected boundaries; default to
focused + direct. Independent is not a scope/intensity or a synonym for broad.

- Focused: obtain sufficient direct evidence for this acceptance/affected boundary.
  It can cross files, use several tests, or involve browser/API/runtime evidence.
- Broad: cover actual affected consumers of a shared library, public interface,
  schema, shared runtime/configuration, broad refactor or compatibility boundary.
  Map consumers and failure modes; broad does not mean all tests or a full suite.
- Direct: Main/current work owner can execute and judge ordinary evidence.
- Independent: the required judgment comes from a suitable role that does not
  own that implementation. Use Phase 3 roles, never a mandatory roster.

The following ordered tables consume evidenced normalized facts for source
conformance tests, not a platform runtime engine. `affected_boundary_is_broad`
means demonstrated multiple consumers/cross-boundary impact, not a file count.
`required_judgment_separation` means an actual acceptance, explicit request or
formal/security responsibility that requires separation, not a risk label.

<!-- VERIFICATION_SCOPE_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| affected_boundary_is_broad | broad |
| otherwise | focused |
<!-- VERIFICATION_SCOPE_TABLE_END -->

<!-- VERIFICATION_INDEPENDENCE_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| required_judgment_separation | independent |
| otherwise | direct |
<!-- VERIFICATION_INDEPENDENCE_TABLE_END -->

All four combinations are valid. A small authentication fix may be focused +
independent; a large low-risk refactor may be broad + direct. Broad, deep model,
protected authorization, source writes, multiple files, browser/API/test usage
and high risk alone cannot force independent roles or a wider evidence scope.
Review scope/need is independently resolved through `review-governance.md`.

## Evidence selection and claim limits

Choose the closest sufficient evidence to the acceptance, not the tool name.
Prefer an existing direct evidence route, then relevant existing tests and
project-native validation, then real runtime interaction when it best proves
the claim. These are discovery preferences, not a mandatory execution ladder:
skip irrelevant static evidence and go directly to the required real behavior.
Static inspection is sufficient only for claims that static evidence can prove.

Evidence may use source_analysis, test_execution, browser_control, api_query,
database_read or runtime_observation as needed. Shared specifies no universal
verifier, package manager or optional vendor. Discover project-native routes in
manifests, scripts, lockfiles, existing configuration and installed project tools;
let capability resolution choose eligible providers without installation/login.
For PROJECT_DERIVED verification knowledge, read
`Shared/policies/references/project-derived-verification.md` on demand. It
discovers fitting project evidence routes; it does not select verification
scope, independence, review applicability or completion.

| Evidence | Supports, when matched to acceptance | Does not alone establish |
|---|---|---|
| Static UI inspection/test | Source structure or static logic | Real rendering/runtime interaction |
| Actual browser DOM/runtime observation | Inspected rendered state and exercised behavior | Unobserved persistence or backend effects |
| Screenshot | Visible state/layout at capture time | Database persistence, transaction/API correctness or release success |
| API response | The response contract actually observed | Durable persistence unless the API contract or follow-up evidence establishes it |
| Follow-up persisted-state read | Observed persistence for the named operation/version | Unrelated transactions or deployment |
| Project-native parser/build/test/output | Its explicit checked contract | Unexecuted consumer behavior |

Command-driven real browser automation can yield DOM, runtime, screenshot and
trace evidence. A terminal provider does not make that evidence merely static.
The compact claim table below is a source-test contract for already observed,
authentic evidence matched to acceptance/version; it is not proof that any tool
ran. A yes applies only to the named observed claim. API durable-contract evidence
requires an authoritative persistence guarantee for that operation, or a matching
follow-up state read; an arbitrary successful response does not qualify.

<!-- EVIDENCE_CLAIM_TABLE_START -->
| Evidence | rendering | exercised_behavior | persistence | publication |
|---|---|---|---|---|
| static_ui | no | no | no | no |
| browser_dom_runtime | yes | yes | no | no |
| screenshot | yes | no | no | no |
| api_response | no | yes | no | no |
| api_durable_contract | no | yes | yes | no |
| persisted_state_read | no | no | yes | no |
| publication_receipt | no | no | no | yes |
<!-- EVIDENCE_CLAIM_TABLE_END -->

Name the revision, acceptance, selected scope/independence, method, observation
and material limits; no board, station or durable artifact is needed by default.
Existing Agent Governance owns source-version freshness; same filename is not
proof that old evidence applies. Missing required proof is reported through
completion policy, without converting source-only acceptance into runtime scope.

## Existing tests and durable test admission

Classify an existing route as local_non_destructive, local_side_effectful,
external_or_protected, or unknown before running it. Inspect unknown effects.
Incidental local caches/output require suitable authorized scope and native
permissions; protected/external tests keep their separate gate. A test label
never authorizes a write, login, cleanup or permission bypass.

Do not create a new test by default. Add one only for stable long-term behavior,
a confirmed regression, reusable boundary or repeated failure mode. Use the
project's existing pattern/runner and an independent acceptance oracle; avoid
brittle one-off implementation assertions or a new framework for convenience.
Record pre-change evidence or why it cannot be obtained, then check the same
oracle after the change. Keep the test delta proportionate to the named boundary.
A broad scope/full suite needs actual affected-consumer justification; review
presence, confidence seeking or model strength is not sufficient justification.

## Failure classification and repair

Classify the observed failure before changing code, tests, expectations or tools:

<!-- VERIFICATION_FAILURE_CLASSES_START -->
| Class | Required interpretation |
|---|---|
| implementation_defect | Accepted product behavior fails on a valid evidence path |
| test_evidence_defect | Test, harness or observation is defective; establish the accepted oracle before repair |
| environment_tool_failure | Environment, readiness or tool failed; not proof that product behavior failed |
| stale_expectation | Expectation predates an accepted behavior/version change; prove the change before updating it |
| capability_limitation | Required evidence function/provider is unavailable or unsupported |
| authorization_permission_block | Required action is blocked by authorization or native permission |
| unknown | Evidence cannot yet distinguish the cause; narrow investigation, do not guess |
<!-- VERIFICATION_FAILURE_CLASSES_END -->

Never change a test just to turn it green. Requirement ambiguity stays unknown
until resolved; an intentional change needs accepted-contract evidence before
classifying the old expectation as stale. Consider a safe bounded retry only
for a diagnosed transient condition; native denial stops the affected action.
Do not switch providers to bypass denial or equate a tool error with product failure.

Direct Main may repair an implementation defect within current source scope.
An independent Verifier/Reviewer returns finding + evidence to Main/Implementer,
who produces the new revision. Reassess affected prior evidence and rerun the
needed checks; no retained-member or replacement lifecycle is required.
Independent roles never repair the implementation and then self-certify it.

Deep-audit remains exceptional: explicit request, a concrete security/integrity
concern, or demonstrated cross-surface uncertainty that bounded evidence cannot
resolve. It neither selects every test nor authorizes a scan/tool by itself.
Memory retains its original verification/artifact consumer contracts below.

## Frozen verification/completion compatibility

The following original body is legacy compatibility-only for frozen Memory or
legacy release consumers. It is not a general vNext trigger, scope, roster,
completion ladder or status owner. Preserve original anchors and meanings;
never translate vNext states into its bundle, phases or receipts.

<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
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

## Direct / Assisted And Formal Trace Boundaries

Ordinary Direct and Assisted verification records only the target, selected method,
evidence, judgment, and residual risk. It does not require a Team board,
station, handoff packet, or formal trace.

Team trace is required only after `execution-routing.md` resolves Team.
Protected actions, release, migration, deep-audit, or an explicit durable-trace
request may need appropriate action evidence, but do not imply a Team board.
Authorization and native evidence follow `authorization-resolution.md`;
Memory keeps its frozen contract. No new verification axes or completion states
are introduced here.

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

<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
