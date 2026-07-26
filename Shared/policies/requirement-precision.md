# Requirement Precision Policy

This policy prevents a request, plan, execution spec, or completion claim from
turning unstated details into requirements. It is the canonical owner of
requirement-precision semantics, the no-guessing rule, question escalation,
and trace obligations.

## Authority And Consumers

`Shared/policies/references/requirement-precision-schema.md` is the canonical
shape for the Compact Task Contract, its Extended Contract, and the legacy
`requirement_precision` 1.0 representation. The schema owns their field
catalogs; this policy owns how those fields are established and used.

Consumers must reference that record instead of defining a local requirement
field set:

- `workflow-execution-spec-contract.md` consumes the applicable
  schema-conformant contract.
- `intent-alignment-gate` consumes this policy and the schema for requirement
  playback, traceability, and drift work.

## Precision Gate

The Compact Task Contract is the default for ordinary local Direct work. It
has exactly four top-level keys: `goal`, `in_scope`, `done_when`, and
`must_preserve`. It may remain ephemeral and Director-facing; no repository
artifact is required for compact work.

An Extended Contract is required only for boundary, systemic, protected, or
materially ambiguous or conflicting work. It adds exactly
`explicit_requirements`, `inferred_requirements`, `unknowns`, `conflicts`,
`public_contracts`, `persistent_state`, `compatibility_expectation`,
`acceptance_evidence`, and `rollback_or_migration` to the Compact Task
Contract.

Every material assertion is classified as `explicit`, `inferred`, `unknown`,
or `conflict`. Preserve its basis in the assertion's wording, source, or
trace when one exists; a fifth compact top-level field is not required.
`must_preserve` names existing behavior, public interfaces or data, security,
and worktree constraints. It is not excluded scope or a list of non-goals.

The legacy `requirement_precision` 1.0 record, including `requirement_id` and
its traces, remains a backward-compatible Extended Contract representation
only. `requirement_id` identifies an already-observed requirement; assigning
an ID does not create, broaden, narrow, or prioritize it. New compact work
must not be forced to create that 12-field representation.

Resolve assertions in this precedence order:

1. locked safety/evidence invariants;
2. current explicit task requirement within authorization;
3. approved public contract, specification, or ADR;
4. approved project or module context;
5. verified existing behavior;
6. tests or examples;
7. file-local or ecosystem convention;
8. AI inference.

Task instructions cannot override evidence honesty, dirty-work protection, or
protected authorization.

### No Guessing

Do not present an inference, convenience default, prior-task detail, or model
knowledge as an explicit requirement, outcome, scope, preservation constraint,
acceptance condition, priority, or verification state. Preserve the actual
basis in the relevant assertion or trace.

A reversible, low-risk internal assumption is allowed only when no public
contract applies, it matches local convention, and focused verification is
possible. Mark it `inferred`. It is not an approved requirement and cannot
widen execution, authorization, scope, or acceptance claims.

### Mandatory Question Conditions

Ask a targeted Director question before planning, authorizing, implementing,
or making an acceptance claim when public API, CLI, configuration, schema,
data format, persistent data, security, credentials, or user-visible behavior
lacks a unique contract, implies irreversible action, or has a high-priority
conflict.

Also ask when a missing, ambiguous, or conflicting value would materially
change the observable outcome, included boundary, authorization scope,
acceptance evidence, priority-dependent ordering, or verification state needed
for the next action or claim.

Record the question in `question_trace`, including its affected fields and
blocking scope. Do not silently resolve it from a similar task or a preferred
implementation. A question may remain open only when the current action does
not depend on its answer; the affected requirement remains non-complete.

## Trace Integrity

In the legacy `requirement_precision` 1.0 representation,
`assumption_trace`, `question_trace`, and `acceptance_trace` remain required
fields even when their lists are empty. They preserve why an assumption exists,
what needs an operator answer, and what evidence supports each acceptance item.

Trace entries must identify their source or evidence and retain non-complete
states. A later consumer may verify, narrow, reroute, or risk-close a gap, but
must not silently promote `partial`, `unverified`, or `blocked` evidence.
Status meanings are consumed from
`Shared/policies/references/status-ontology.md`.

## Boundary

This policy does not authorize reads, writes, validation, review, protected
actions, or completion. Authorization, delivery slices, validation, and review
continue to use their own canonical contracts.
