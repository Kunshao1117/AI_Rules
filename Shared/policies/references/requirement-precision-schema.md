# Requirement Precision Schema

This reference defines the machine-readable shape of the canonical
`requirement_precision` record. Semantic rules, no-guessing behavior, and
mandatory question conditions are owned by
`Shared/policies/requirement-precision.md`.

## Canonical Record

Every field below is required. Use an explicit unresolved state or an empty
trace list where the schema permits it; do not omit a field.

```text
requirement_precision: {
  schema_version,
  requirement_id,
  outcome,
  applicability_conditions,
  scope,
  non_goals,
  acceptance_evidence,
  priority,
  verification_status,
  assumption_trace,
  question_trace,
  acceptance_trace
}
```

## Required Fields

| Field | Required shape | Rule |
|---|---|---|
| `schema_version` | `1.0` | Version of this record shape. |
| `requirement_id` | Stable, unique identifier | Identifies an observed requirement; never encodes a guessed priority or scope. |
| `outcome` | `{ statement, source_ref, verification_status }` | States the observable result being requested. |
| `applicability_conditions` | `{ items, source_ref, verification_status }` | States when, for whom, or under what conditions the outcome applies. |
| `scope` | `{ included, boundaries, source_ref, verification_status }` | States the allowed subject, action, or file/system boundary. |
| `non_goals` | `{ items, source_ref, verification_status }` | States deliberately excluded outcomes or changes. |
| `acceptance_evidence` | Non-empty list of acceptance items | Each item has `acceptance_id`, `criterion`, `evidence_target`, `source_ref`, and `verification_status`. |
| `priority` | `{ level, source_ref, verification_status }` | `level` is `P0`, `P1`, `P2`, `P3`, `unverified`, or `not-applicable`; do not infer a ranked level. |
| `verification_status` | Evidence state | One of `sufficient`, `partial`, `unverified`, `blocked`, or `not-applicable`. |
| `assumption_trace` | List | Uses the shape below; `[]` when no assumption is used. |
| `question_trace` | List | Uses the shape below; `[]` when no question is open or resolved. |
| `acceptance_trace` | List | Uses the shape below; one entry per acceptance item once evidence is considered. |

`not-applicable` requires a concrete reason in the field's `source_ref` or
trace entry. `acceptance_evidence` is never empty: when no acceptance target is
known, create a `question_trace` entry and keep the associated acceptance item
`unverified` rather than claiming acceptance.

## Trace Shapes

```text
assumption_trace: [
  {
    assumption_id,
    statement,
    basis,
    affected_requirement_fields,
    verification_status
  }
]

question_trace: [
  {
    question_id,
    question,
    reason,
    affected_requirement_fields,
    blocking_scope,
    status,
    answer_ref
  }
]

acceptance_trace: [
  {
    acceptance_id,
    acceptance_evidence_ref,
    evidence_collected,
    verification_status
  }
]
```

`question_trace.status` is `open`, `answered`, `blocked`, or `not-applicable`.
An `open` or `blocked` question whose answer is required by the policy's
mandatory-question conditions prevents the dependent action. An answered
question records its answer in `answer_ref`; it does not erase the original
question.

`acceptance_trace.acceptance_id` must match an item in `acceptance_evidence`.
The trace records evidence collection only; it does not replace independent
validation or review evidence.

## Consumer Rule

Consumers may add a reference to this record, but must not redefine, rename,
or locally supplement this field catalog. Use the policy for no-guessing and
question escalation semantics.
