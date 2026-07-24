# Board Fields: Slice, Role, And Finding Continuity

This reference is the sole owner of `delivery_slice`, fixed station roster,
role separation, numbered finding, implementation resume, repair loop,
diagnosis/module-split, member-replacement fields, and the board's
`completion_bundle_ref` attachment. It consumes generic board values from
`board-field-catalog.md` and channel values from
`board-field-channel-and-receipts.md`.

## Slice Identity And Fixed Roster

`delivery_slice` is one acceptance-sized unit. It is not a person, channel, or
per-file dispatch. Each slice records:

```text
delivery_slice, delivery_slice_id, slice_baseline_packet_id, slice_round,
slice_station_roster, slice_station_round_state, repair_loop_count,
finding_id, finding_source_station, finding_disposition,
implementation_resume_state, implementation_resume_decision_ref,
member_replacement_state, member_replacement_reason,
replaces_role_instance_id, context_transfer_ref,
completion_bundle_ref
```

`slice_station_roster` is sealed when the slice enters `authorized` state:

```text
slice_station_roster: {
  implementation: {
    formal_station_id, role_id: change-delivery, role_instance_id,
    member_assignment, handoff_packet_id, context_scope_ref
  },
  validation: {
    formal_station_id, role_id: validation, role_instance_id,
    member_assignment, handoff_packet_id, context_scope_ref
  },
  review: {
    formal_station_id, role_id: review, role_instance_id,
    member_assignment, handoff_packet_id, context_scope_ref
  },
  memory_closure: {
    formal_station_id, role_id: memory-closure, role_instance_id,
    member_assignment, handoff_packet_id, context_scope_ref
  },
  completion: {
    formal_station_id, role_id: release-completion, role_instance_id,
    member_assignment, handoff_packet_id, context_scope_ref
  }
}
```

The five entries must have distinct `formal_station_id`, `member_assignment`,
and `role_instance_id` values. The role instances do not change between rounds:
each retains its original context and packet. `slice_baseline_packet_id` names
the accepted slice baseline; a resumed round does not create another baseline.

`delivery_slice_state` is `draft`, `authorized`, `in-delivery`,
`review-validation-pending`, `memory-closure-pending`,
`completion-audit-pending`, `returned-for-repair`, `blocked`, `unverified`,
`closed`, or `not-applicable`. `slice_station_round_state` is `reserved`,
`active`, `standby`, `resume-required`, `resumed`, `returned`,
`close-eligible`, `closed`, `blocked`, `unverified`, or `not-applicable`.

`close-eligible` is reached only after the whole slice acceptance chain. A
returned activated station becomes `standby`; it must not close or auto-open a
new member for the next round. `reserved` is pre-assignment only: it is not a
new slice, a repair station, or a member replacement. An activated member may
advance only through `standby` and explicit `resume-required` / `resumed`
handling.

## Completion Bundle Attachment

The board attaches `completion_bundle_ref` to the delivery slice but does not
define, interpret, or extend the referenced bundle. `Shared/policies/references/
memory-closure-bundle-contract.md` is the sole owner of the completion-bundle
schema, candidate map, closeout target, phase bindings, receipt chain, and
bundle state.

The board continues to own only roster state: `memory-closure` remains a fixed
`reserved` entry until its canonical bundle route permits the station to start,
and `completion` remains a fixed independent non-mutating audit entry. Neither
roster state substitutes for a candidate phase reference or authorization.

## Finding And Repair Loop

`finding_id` is a stable, numbered finding from the original validation or
review station. `finding_source_station` is `validation` or `review`.
`finding_disposition` is `open`, `captain-resume-requested`,
`implementation-resumed`, `repair-returned`, `validation-resumed`,
`review-resumed`, `verified`, `escalated`, `blocked`, `unverified`, or
`not-applicable`.

`implementation_resume_state` is `not-requested`, `finding-returned`,
`captain-resume-sent`, `resumed-for-repair`, `repair-returned`, `blocked`,
`unverified`, or `not-applicable`. `implementation_resume_decision_ref` is
the captain's explicit coordination record naming the original implementation
station, original member, finding IDs, allowed existing-slice scope, and next
validation/review order. It records routing only; it is not a quality,
validation, review, or completion conclusion.

The only normal sequence is:

1. The implementation station returns and enters `standby`.
2. The original validation and review stations run independently and enter
   `standby` after their round.
3. A numbered finding causes the captain to explicitly resume the original
   implementation station. That station repairs only the cited finding inside
   its existing slice scope, context, and packet.
4. After repair returns, the captain explicitly resumes the original validation
   and review stations. They independently recheck the applicable finding and
   enter `standby` again.
5. All three stations close only after whole-slice acceptance.

`repair_loop_count` counts same-symptom cycles. Counts one and two retain the
same slice, roster, contexts, and packet baseline. They never create a
`repair` station, new implementation member, new role instance, or new packet
baseline.

On a third occurrence of the same symptom, add an independent station before
the next implementation resume: `diagnosis` uses an appropriate non-author
analysis role such as `scope-impact` or `security-reliability`; `module-split`
uses `architecture-contract`. Its artifact is input for the original
implementation member, not a replacement implementation or an independent
approval. It creates a new slice only if acceptance scope, contract, or
authorization actually changes.

## Explicit Member Replacement

Channel replacement is not member replacement. The fixed roster may change
only when the captain records `member_replacement_state: captain-approved`
with all of:

```text
formal_station_id, prior_member_assignment, replacement_member_assignment,
replaces_role_instance_id, replacement_role_instance_id,
member_replacement_reason, context_transfer_ref, captain_decision_ref
```

Allowed `member_replacement_reason` values are `unavailable`, `context-lost`,
`independence-required`, `blocked-route`, `unverified-context`, or
`not-applicable`. The replacement receives a sealed assignment overlay and
context transfer, but retains the same `delivery_slice_id`, accepted scope, and
`slice_baseline_packet_id`. It is not a new slice or a new packet baseline.
Missing reason or transfer evidence leaves the station `blocked` or
`unverified`.

## Role Boundary

Implementation may repair only through its own explicitly resumed
`change-delivery` station. Validation and review remain separate, non-mutating
stations and may not author the repair. The implementation author may not
validate or review its own repair. A captain may ledger, route, and issue a
resume or replacement decision, but cannot treat a subagent reply as a
conclusion or substitute for the required owner-station artifact.
