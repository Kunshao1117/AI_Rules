# Requirement Precision Policy

This policy prevents a request, plan, execution spec, or completion claim from
turning unstated details into requirements. It is the canonical owner of
requirement-precision semantics, the no-guessing rule, question escalation,
and trace obligations.

## Authority And Consumers

`Shared/policies/references/requirement-precision-schema.md` is the canonical
machine-readable shape for a `requirement_precision` record. The schema owns
the field catalog; this policy owns how those fields are established and used.

Consumers must reference that record instead of defining a local requirement
field set:

- `workflow-execution-spec-contract.md` consumes one schema-conformant record.
- `intent-alignment-gate` consumes this policy and the schema for requirement
  playback, traceability, and drift work.

## Precision Gate

Every formal plan, execution spec, source-impacting delivery slice, or
acceptance claim must carry one complete `requirement_precision` record. All
schema-required fields must be present. A field may be unresolved only through
the schema's explicit state and trace values; it must not be omitted or filled
with a plausible invention.

`requirement_id` identifies an already-observed requirement. Assigning an ID
does not create, broaden, narrow, or prioritize the requirement.

### No Guessing

Do not present an inference, convenience default, prior-task detail, or model
knowledge as the Director's outcome, applicability condition, scope,
non-goal, acceptance evidence, priority, or verification state. Preserve the
actual basis in the relevant field or trace.

When evidence is incomplete but proceeding is safe and reversible, record the
uncertainty in `assumption_trace` with a non-complete verification status. The
assumption is not an approved requirement and cannot widen execution,
authorization, or acceptance claims.

### Mandatory Question Conditions

Ask a targeted question before planning, authorizing, implementing, or making
an acceptance claim when a missing, ambiguous, or conflicting value would
materially change any of the following:

- the observable outcome or the condition under which it applies;
- the included boundary, a stated non-goal, or an action's authorization scope;
- the evidence that would prove acceptance;
- priority when ordering, pre-emption, or omitted work depends on it; or
- the verification state needed for the next action or claim.

Record the question in `question_trace`, including its affected fields and
blocking scope. Do not silently resolve it from a similar task or a preferred
implementation. A question may remain open only when the current action does
not depend on its answer; the affected requirement remains non-complete.

## Trace Integrity

`assumption_trace`, `question_trace`, and `acceptance_trace` are required
schema fields even when their lists are empty. They preserve why an assumption
exists, what needs an operator answer, and what evidence supports each
acceptance item.

Trace entries must identify their source or evidence and retain non-complete
states. A later consumer may verify, narrow, reroute, or risk-close a gap, but
must not silently promote `partial`, `unverified`, or `blocked` evidence.
Status meanings are consumed from
`Shared/policies/references/status-ontology.md`.

## Boundary

This policy does not authorize reads, writes, validation, review, protected
actions, or completion. Authorization, delivery slices, validation, and review
continue to use their own canonical contracts.
