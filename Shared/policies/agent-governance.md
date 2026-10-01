# Agent Governance

This is the sole general-work owner of bounded Agent assignments, role scope,
independence and source-version binding. `Shared/agents/_registry.md` owns the
six formal role definitions. They are not Skills or a mandatory roster.
`execution-routing.md` selects Direct / Assisted / Team; authorization and
provider resolution remain with their own policies.

## Ownership And Activation

The main agent is the work owner and ordinary implementer in every mode.
Direct creates no formal Agent assignment and does not spawn an Implementer.
Assisted adds a bounded auxiliary worker, not another implementation owner or
a Team record. Native exploration/search helpers are sufficient; Explorer is
not a formal AI_Rules role. Tool usage alone never creates a worker.

Only resolved Team uses formal role assignments. Select only responsibilities
the task actually needs: Main + Reviewer or Main + Verifier can be sufficient.
There is no fixed roster. Conditional Implementer is eligible only when Team
needs a separate, independently bounded implementation stream: parallel delivery,
context isolation, explicit role split or concrete duty separation. Main may
implement while a distinct role reviews or verifies that deliverable.

## Minimal Assignment

For Team, bind `execution_mode`, `reason`, `role`, `scope`,
`required_capabilities`, `write_boundary`, `independence`, `model_intent`,
`model_profile_or_exact_request`, `source_revision_ref`, and `expected_output`.
These are assignment facts, not platform tool parameters. They may remain in
the conversation; a board, station or separate artifact is not required.
An optional Team record contains reason, these assignments and their results.
Assisted uses only the needed helper scope, capabilities, model intent and
expected evidence/result; no formal Agent object is required.

Use `model-profile-routing.md` when a model choice is needed. Required
capabilities describe evidence/action needs; `capability-resolution.md` and
the platform adapter select current providers. Roles grant no tool availability,
source-write or protected authority. Resolve scope before invoking a worker.
Missing independent-worker capability is blocked/unverified, not self-review.

## Independence And Write Boundaries

Reviewer and Security Reviewer do not implement or repair the deliverable
they judge. A Verifier assigned independent evidence cannot own that same
implementation; failures return evidence and classification to its owner.
Changing tools, models or windows does not remove implementation ownership.
The main agent's ordinary direct verification remains valid evidence but is
not relabeled independent. Researcher supplies facts, Architect supplies bounded
design decisions; neither becomes the implementation owner by being assigned.

Verifier source repair is forbidden. Authorized test/runtime incidental local
artifacts, such as temporary output or caches, are distinct from source repair.
Inspect the evidence path's actual effects and native permission; external or
protected verification still needs matching authorization. A role template is
not a filesystem isolation guarantee. Skills are task-specific lazy loads;
do not preload all quality/testing Skills or inherit their legacy machinery.

## Result And Freshness

Bind each result to its assignment and `source_revision_ref`, such as a diff
fingerprint, artifact version or equivalent stable evidence; no Git mutation
is required. Return outcome (`success`, `finding`, `blocked`, `unverified`),
evidence and material limits. Source version, not arrival order, determines fit.
Review or verification of revision A cannot approve changed revision B.
Reassess affected evidence against B; do not carry stale approval forward.

The following is a deterministic source contract for evidenced facts, not a
runtime engine. `version_matches` requires a stable comparable reference.

<!-- AGENT_FRESHNESS_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| implementation_owned_by_judge | not_independent |
| version_missing | unverified |
| version_changed | stale |
| version_matches | current |
| otherwise | unverified |
<!-- AGENT_FRESHNESS_TABLE_END -->

## Platform Lifecycle And Frozen Consumers

The platform owns spawn, wait, follow-up, resume, interruption, cancellation,
replacement, thread limits and transport lifecycle. AI_Rules adds no scheduler,
polling/probe protocol, dispatch waves, timeout quantiles or retained-member
state machine. Preserve assignment scope and freshness across native actions;
successfully starting a worker is neither a model receipt nor a task result.

Legacy Team bodies at their original paths are compatibility-only, not required
for general vNext work. Frozen Memory retains its own stations, role instances,
delivery slices, bundle and receipt semantics. Do not synthesize those records
from vNext assignments or infer Memory authority/completion. Git and release
remain workflows. `verification-strategy.md`, `review-governance.md` and
`completion-policy.md` consume these unchanged role/freshness boundaries;
they do not add a roster or change frozen Memory ownership.

Assignment wording methods: `Shared/policies/references/task-assignment-methods.md#bounded-assignment-wording`; these do not select roles or execution modes.
