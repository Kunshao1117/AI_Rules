# Requirement Precision Schema

This reference defines the Compact Task Contract, its Extended Contract, and
the backward-compatible `requirement_precision` 1.0 representation. Semantic
rules, no-guessing behavior, and mandatory question conditions are owned by
`Shared/policies/requirement-precision.md`.

## Compact Task Contract

The Compact Task Contract is the default for ordinary local Direct work. It is
ephemeral and Director-facing unless another policy independently requires an
artifact. It has exactly these four top-level keys:

```text
{
  goal,
  in_scope,
  done_when,
  must_preserve
}
```

| Key | Meaning |
|---|---|
| `goal` | The requested observable outcome. |
| `in_scope` | The included task boundary. |
| `done_when` | The evidence or condition that establishes completion. |
| `must_preserve` | Existing behavior, public interfaces or data, security, and worktree constraints that must remain intact. It is not excluded scope or non-goals. |

Each material assertion in a compact key is `explicit`, `inferred`, `unknown`,
or `conflict`. Preserve its basis in the assertion wording, source, or an
available trace; no fifth compact top-level field is required.

## Extended Contract

Use the Extended Contract only for boundary, systemic, protected, or materially
ambiguous or conflicting work. It retains the Compact Task Contract and adds
exactly these keys:

```text
{
  goal,
  in_scope,
  done_when,
  must_preserve,
  explicit_requirements,
  inferred_requirements,
  unknowns,
  conflicts,
  public_contracts,
  persistent_state,
  compatibility_expectation,
  acceptance_evidence,
  rollback_or_migration
}
```

## Legacy Requirement Precision 1.0 Record

The following record remains a backward-compatible Extended Contract
representation only. New compact work does not create it merely to satisfy
this schema.

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

## Legacy Required Fields

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

## Legacy Trace Shapes

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

Consumers may reference the Compact Task Contract or the applicable Extended
Contract, but must not redefine, rename, or locally supplement their field
catalogs. `requirement_precision` 1.0 and its identifiers and traces remain
available only as the backward-compatible Extended Contract representation.
Use the policy for no-guessing and question escalation semantics.
