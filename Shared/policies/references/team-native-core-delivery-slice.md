# Team-Native Core Delivery Slice Reference

This reference owns the expandable delivery-slice station procedure. It is
mandatory after the Team-Native Core opens a formal delivery slice.

## Reading Index And Split Rationale

Read [Team-Native Core](../team-native-core.md) first for always-on hard rules,
then this reference before retaining, resuming, replacing, or routing a slice
member. Read [Workflow Orchestration](../workflow-orchestration.md) for waves,
[Authorization Resolution](../authorization-resolution.md) for scope-bound
authority, and [Workflow Lane Routing](workflow-lane-routing.md) for lane
selection.

The core exceeded the shared-policy split-plan threshold because it contained
both always-on boundaries and the detailed station lifecycle. This reference
owns the latter procedure so the core remains a concise guard; it does not add a
second authorization, board, handoff, or requirement-contract schema.

## Retained Station Lifecycle

Specialist stations are not disposable one-message helpers. A station may be
retained only when the same `role_id`, `role_instance_id`, station, delivery
artifact, wave, and role boundary remain. One specialist channel or role
instance must not hold more than one `role_id` in the same task trace or Captain
Team Board.

Do not reuse a channel when its role changes, when implementation crosses to
review, when validation turns into implementation, when memory/docs attribution
turns into protected memory mutation, when completion audit turns into final
closeout authority, or when a second independent opinion is required.

Every formal station records lifecycle state as `assigned`, `retained`,
`reused`, `handoff-required`, `closed`, `replaced`, or `blocked`, plus its
retention reason, conversation health, reuse count, handoff summary,
role-boundary check, and closure reason. It also records `station_mode`,
`context_visibility`, and `handoff_ownership`; missing fields leave the station
`blocked` or `unverified` and cannot support `complete`.

Timeouts are observability signals, not delivery failure, cancellation, or
rejection. Before replacing a slow channel, record a status probe or why one
cannot be sent. A probed specialist pauses, reports its stopping position,
blocker state, and safe-to-continue state, then waits for an explicit captain
resume message. A responding channel stays non-terminal at
`status_probe_resume_state: awaiting-resume`; valid next states are
`resume-sent`, `resumed`, `blocked`, and `unavailable`. A resumed station is
`station_state: running`; an extension request is
`status_probe_state: responded-extension-requested`.

Replacement does not cancel the original channel. Record the new channel
generation, replacement reason, cancellation state, and late-result policy.
`ignore-after-cancelled` applies only after acknowledged cancellation and a
closed late-result window with no artifact. Log and compare any late artifact
with its replacement; record `returned_at`, `return_timing`,
`receipt_decision`, and `receipt_decision_reason`. Valid neutral ledger
dispositions are logged, included-in-synthesis-ledger, routed-to-owner-station,
superseded-by-replacement, duplicate, conflict-review, blocked, and unverified.
Completion requires terminal closure, a late-result disposition, or visible
non-complete residual state for every opened channel.

Retain a station while the same role and delivery artifact can continue with
clear context. Use `handoff-required` when context reconstruction is material;
use `replaced` when the handoff is insufficient. Close the old station and open
a new independent role instance in a later eligible wave when the role boundary
would be crossed.

## Fixed Slice Members

A formal `delivery_slice` is the shared context and authorization container for
one acceptance objective. It references the current requirement contract without
redefining its fields; the execution specification and board catalog remain the
schema owners.

Each slice starts with five role-distinct fixed roster stations and members:

- `implementation` is the only primary station that may write in its exact
  resolved scope.
- `validation` only validates returned applied artifacts. It may not write,
  repair, or review.
- `review` only independently reviews returned applied artifacts. It may not
  write, repair, or validate.
- `memory-closure` consumes only the accepted artifact chain named by a
  pre-bound completion bundle. It may perform the bundle's minimal memory-card
  write and `memory_commit` only in their separately authorized protected
  phases.
- `completion` independently audits the returned evidence chain. It may not
  mutate source, context, memory, Git, deployment, or external state.

The five entries retain their original `role_instance_id`, context, handoff
packet, and member identity for the entire slice. `implementation` may begin
active; later entries begin `reserved` until their declared dependency is
ready. A reserved entry is a pre-assigned roster position, not another slice,
repair station, channel replacement, or member replacement. Once an entry has
started, a returned round makes it `standby`; it may proceed again only by an
explicit resume of that same member and packet.

After the three role-distinct primary stations—`implementation`, `validation`,
and `review`—have each completed one round, they become `standby`, not
`closed`. Their original members, contexts, and packets remain fixed for any
later finding-driven resume; this primary-station rule coexists with, and does
not replace, the reserved `memory-closure` and `completion` fixed-roster
entries.

Close the fixed roster only after all required slice acceptance conditions have
terminal evidence. A `memory-docs` station is a separately bound, read-only
input to memory closure; it is never a substitute for the `memory-closure`
roster entry and may not cross into that protected role or channel.

## Completion Bundle And Default Closeout

For a formal source-bearing delivery, the default `closeout_target` is
`process-complete`. Before implementation starts, the slice records one
`completion_bundle` that independently binds the later `memory-docs`,
`protected-memory-write`, and `protected-memory-commit` branches, together
with the fixed `memory-closure` and `completion` roster entries. The bundle
names the expected inputs, accountable owner, and canonical binding reference
for each branch; it does not restate the authorization schema.

Creating or carrying a completion bundle is preflight routing only. It neither
authorizes implementation nor converts any protected branch into an automatic
phase. `memory-docs` remains read-only. The `memory-closure` station may start
only after it receives the accepted, non-stale source and memory/docs artifacts
and each protected phase has its own separately resolved authority. Its
minimal card write and its `memory_commit` are distinct protected phases.

The completion station remains reserved until the bundle has terminal evidence
or an honest blocked, unverified, or protected-follow-up state. It independently
audits that evidence and cannot mutate it or decide final closeout. A missing
or unexecuted protected branch means the delivery cannot present itself as
`process-complete`; retain the truthful lower or pending state instead.

## Finding Handling And Captain Decisions

When validation or review returns a numbered finding, the captain records it and
selects the route without doing station work:

| Decision | Required route |
| --- | --- |
| `continue` | Advance a retained station only when no unresolved finding or slice boundary blocks its next permitted action. |
| `repair` | For the first or second occurrence of the same symptom, `restore/resume` the original implementation member. Repair is that station's new working state, not a new station or member, and reuses slice authorization. |
| `rerun` | After the returned implementation artifact, restore/resume the original validation and review members for affected evidence in dependency order. They remain role-distinct and cannot repair it. |
| `diagnose` | On the third same-symptom occurrence, open an independent diagnosis or module-split station. Return its output to the original implementation member without closing the slice. |
| `replace` | Replace a retained member only through an explicit captain decision for unavailability, lost context, or an independent-review requirement. Preserve `replacement_reason`, context transfer, and the original member's artifact and lifecycle disposition. |
| `escalate` | Stop the affected action and open a newly authorized slice only when scope, allowlist, authorization, acceptance, risk, public contract, or protected action changes. |

The first two same-symptom repairs remain in the current slice. The third
same-symptom diagnosis or module-split route also remains there unless the
captain records a slice-boundary change. A module-split station may write only
when the unchanged authorization and exact allowlist already cover the work;
otherwise escalate before execution.

## Yellow Findings

Classify Yellow findings before starting a repair loop as `fix-this-cycle`,
`residual-accepted`, `deferred-follow-up`, `local-customization`, or
`informational`. Escalate a Yellow finding to blocked, unverified, or Red when
it affects the current completion claim, required Team-Native trace,
independent review, validation, memory/docs attribution, public contract,
deployment sync, or release readiness.

The same Yellow finding must not create an unbounded repair loop. After two
repairs for the same symptom family, file region, or operator path, the captain
chooses `diagnose` or module split under the decision table. Neither route alone
opens a new slice.
