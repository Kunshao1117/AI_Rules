# Board Fields: Slice, Role, And Finding Continuity

This reference is the sole owner of `delivery_slice`, fixed responsibility slots,
role separation, numbered finding, implementation resume, repair loop,
diagnosis/module-split, member-replacement fields, and the board's
`completion_bundle_ref` attachment. It consumes generic board values from
`board-field-catalog.md` and channel values from
`board-field-channel-and-receipts.md`.

## Slice Identity And Fixed Responsibility Slots

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

`slice_station_roster` is sealed when the slice enters `authorized` state. It
fixes the responsibility slots, their activation conditions, independence
requirements, and required artifacts; it does not pre-create live members or
contexts:

```text
slice_station_roster: {
  implementation: {
    role_id: change-delivery, activation_condition, independence_requirement,
    required_artifacts, formal_station_id?, role_instance_id?,
    member_assignment?, handoff_packet_id?, context_scope_ref?, channel?
  },
  validation: {
    role_id: validation, activation_condition, independence_requirement,
    required_artifacts, formal_station_id?, role_instance_id?,
    member_assignment?, handoff_packet_id?, context_scope_ref?, channel?
  },
  review: {
    role_id: review, activation_condition, independence_requirement,
    required_artifacts, formal_station_id?, role_instance_id?,
    member_assignment?, handoff_packet_id?, context_scope_ref?, channel?
  },
  memory_closure: {
    role_id: memory-closure, activation_condition, independence_requirement,
    required_artifacts, formal_station_id?, role_instance_id?,
    member_assignment?, handoff_packet_id?, context_scope_ref?, channel?
  },
  completion: {
    role_id: release-completion, activation_condition, independence_requirement,
    required_artifacts, formal_station_id?, role_instance_id?,
    member_assignment?, handoff_packet_id?, context_scope_ref?, channel?
  }
}
```

`reserved` means a fixed responsibility slot whose activation condition is not
yet met. A reserved slot need not have a member assignment, handoff packet, or
live context. When its activation condition is met, only then bind its formal station,
member assignment, role instance, handoff packet, context scope, and channel
before the station starts. Activated entries must have distinct
`formal_station_id`, `member_assignment`, and `role_instance_id` values where
independence is required. Once activated, a role instance retains its original
context and packet between rounds. `slice_baseline_packet_id` names the accepted
slice baseline; a resumed round does not create another baseline.

`delivery_slice_state` is `draft`, `authorized`, `in-delivery`,
`review-validation-pending`, `memory-closure-pending`,
`completion-audit-pending`, `returned-for-repair`, `blocked`, `unverified`,
`closed`, or `not-applicable`. `slice_station_round_state` is `reserved`,
`active`, `standby`, `resume-required`, `resumed`, `returned`,
`close-eligible`, `closed`, `blocked`, `unverified`, or `not-applicable`.

`close-eligible` is reached only after the whole slice acceptance chain. A
returned activated station becomes `standby`; it must not close or auto-open a
new member for the next round. `reserved` is an unbound responsibility slot: it
is not a new slice, repair station, channel, or member replacement. An activated
member may advance only through `standby` and explicit `resume-required` /
`resumed` handling.

## Completion Bundle Attachment

The board attaches `completion_bundle_ref` to the delivery slice but does not
define, interpret, or extend the referenced bundle. `Shared/policies/references/
memory-closure-bundle-contract.md` is the sole owner of the completion-bundle
schema, candidate map, closeout target, phase bindings, receipt chain, and
bundle state.

The board continues to own only responsibility-slot state: `memory-closure`
remains a fixed `reserved` slot until its canonical bundle route permits the
station to start, and `completion` remains a fixed independent non-mutating
audit slot. Neither slot state substitutes for a candidate phase reference or
authorization.

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

The following normal sequence applies after the relevant responsibility slots
have been activated:

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

Channel replacement is not member replacement. An activated responsibility slot
may change member only when the captain records
`member_replacement_state: captain-approved`
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
