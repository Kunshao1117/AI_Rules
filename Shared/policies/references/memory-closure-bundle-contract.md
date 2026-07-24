# Memory Closure Bundle Contract

This reference is the sole owner of the `completion_bundle` schema and its
exceptions. It governs pre-bound candidate mapping for the post-source memory
closure branch. It does not replace Authorization Resolution, the authorization
phase registry, the protected-action registry, the memory evidence reference,
or the completion state machine.

## Binding Model

A new formal source route defaults to `process-complete`. Its initial visible
formal-write agreement may create one `completion_bundle` that directly and
independently binds candidates for these three phases:

- `memory-docs`
- `protected-memory-write`
- `protected-memory-commit`

The candidates share the initial agreement as evidence provenance, but each is
a separate phase binding. No candidate derives from
`implementation-change-delivery`, and no candidate is executable merely
because implementation was authorized or completed. The candidate's own
target, scope, station, expiry, eligibility, and current receipt requirements
must all be satisfied.

`source-level` is available only when the initial agreement expressly records
`source-level-explicit`. That exception does not create deferred candidate
authority. A later memory phase needs a newly resolved, scope-bound agreement.

Existing and legacy execution specs do not acquire a bundle, candidate mapping,
or protected authority retrospectively. They remain governed only by the
authorization and closeout fields that were actually resolved for them.

## Canonical Schema

```text
completion_bundle: {
  completion_bundle_id,
  origin_formal_write_agreement_ref,
  closeout_target,
  source_level_exception,
  delivery_slice_ref,
  delivery_slice_revision,
  existing_owner_scope_ref,
  candidate_phase_map: {
    memory_docs: {
      authorization_binding_ref,
      target_scope_ref,
      station_ref,
      expiry,
      candidate_state
    },
    protected_memory_write: {
      authorization_binding_ref,
      target_scope_ref,
      station_ref,
      expiry,
      candidate_state
    },
    protected_memory_commit: {
      authorization_binding_ref,
      target_scope_ref,
      station_ref,
      expiry,
      candidate_state
    }
  },
  validation_review_acceptance_ref,
  receipt_chain: {
    memory_docs_receipt_ref,
    protected_memory_write_receipt_ref,
    protected_memory_commit_receipt_ref
  },
  scope_expansion_request_ref,
  bundle_state
}
```

`closeout_target` is `process-complete` unless the initial agreement contains
the `source-level-explicit` exception. `source_level_exception` is
`not-applicable` or `source-level-explicit`.

Each `authorization_binding_ref` resolves the named candidate phase directly
against the same initial visible agreement. It must preserve that phase's
separate target, scope, station, evidence, expiry, and resolution state from
Authorization Resolution. A missing, expired, revoked, mismatched, or
unverified binding leaves only that candidate non-executable.

`candidate_state` is `bound`, `not-required`, `eligible`, `executing`,
`satisfied`, `stale`, `expired`, `revoked`, `blocked`, or `unverified`.
`bundle_state` is derived from the candidate and receipt states; it does not
replace any phase or completion state.

## Existing-Owner-Only Candidate Mapping

`existing_owner_scope_ref` names only memory cards or project-context owners
that already exist and are explicitly within the initial agreement's resource
scope. A candidate cannot create a card, discover a new owner and add it to the
scope, replace an owner, or widen from a card to a directory or context area.

The map is a candidate map, not an execution queue:

1. `memory-docs` becomes eligible only after current validation and review are
   accepted for the current delivery-slice revision.
2. `protected-memory-write` becomes eligible only when the current
   memory/docs receipt says `memory-required` and the bound existing owner is
   applicable.
3. `protected-memory-commit` becomes eligible only after a current authorized
   protected-memory-write receipt confirms the active memory content update
   requires commit.

`memory-not-required` and `memory-attributed-no-write` set the later protected
candidates to `not-required`; they do not turn into authorization for a write.

## Prohibited Scope

A completion bundle must not:

- authorize source writes, change application, validation, review, completion,
  Git, release, deployment, install, credential handling, or external mutation;
- create, compact, split, move, delete, or select a new memory/context owner;
- add a memory card, project-context target, generated/deployed copy, or any
  resource outside `existing_owner_scope_ref`;
- turn a `memory-docs` disposition into a protected mutation; or
- use an implementation artifact, source-level status, or a prior receipt as a
  substitute for a current candidate binding and receipt.

## Receipt And Revision Freshness

`validation_review_acceptance_ref` identifies the accepted validation and
review artifacts that permit memory closure. It is current only when both
artifacts refer to the bundle's `delivery_slice_ref` and
`delivery_slice_revision`, and their downstream route is memory closure rather
than repair, reroute, blocked, unverified, or risk closure.

Every memory receipt in `receipt_chain` records the same delivery-slice
reference and revision as the candidate it satisfies. A receipt from another
slice or an earlier revision is historical evidence only and has
`candidate_state: stale`; it cannot support the current phase or closeout.

`delivery_slice_revision` starts at `1`.

Each accepted repair that changes the same delivery slice increments it once.

The increment marks all prior memory-docs, protected-memory-write, and
protected-memory-commit receipts stale-by-slice-revision. The historical
receipt remains recorded, but memory closure must restart after current
accepted validation and review evidence.

## Scope-Expansion Conditions

Stop the affected action and open `scope_expansion_request` before changing:

- `source-level-explicit` to a process-complete target, or the reverse;
- any candidate phase, its target, resource scope, station, or protected action;
- the existing memory/context owner or owner-card topology;
- a `not-required` candidate into a new mutation target; or
- the source acceptance, exact allowlist, authorization, risk, public contract,
  or protected-action boundary that would invalidate the current bundle.

`memory-card-missing`, owner conflict, compaction need, a changed context
target, or a request to create a new owner is not an implicit bundle update.
It remains blocked or unverified until the appropriate scope-expansion and
phase-specific authorization are resolved.
