# Execution Lifecycle Reference

This reference is the canonical operational owner for the handoff packet's
channel-only immutable wait baseline, mutable lifecycle ledger, deadline
revisions, probe/resume behavior, replacement generations, cancellation
boundary, and late-return decisions. Workload quantiles and deadline formulas are owned only
by `Shared/policies/references/workflow-execution-spec-contract.md`; this
reference consumes them without redefining them.

`Shared/skills/team-station-handoff-packet/SKILL.md` owns packet construction
and returned artifact routing. The channel/receipt board reference owns
canonical channel values; the slice/role board reference owns roster, finding,
repair, and member-replacement values. Platform adapters may supply latency
classes and multipliers, but they must not redefine this shared lifecycle or
place internal governance fields in a tool payload.

## Anchor Shapes

The sealed wait-policy anchor contains:

```text
#wait-policy: {
  wait_baseline: {
    workload_class,
    workload_band_source,
    workload_band_sample_count,
    workload_band_observation_window,
    workload_band_quantile_at,
    W50,
    W90,
    W99,
    requested_execution_provenance_ref,
    accepted_execution_provenance_ref,
    applied_execution_provenance_ref,
    adapter_latency_class,
    adapter_latency_multiplier,
    adapter_first_useful_fraction,
    expected_duration,
    initial_wait_budget,
    initial_first_useful_budget,
    initial_soft_budget,
    initial_hard_budget,
    extension_ceiling,
    status_probe_policy,
    replacement_policy,
    cancellation_policy,
    timeout_action,
    late_result_policy,
    late_result_window
  },
  lifecycle_ledger_ref
}
```

The mutable lifecycle ledger contains:

```text
#lifecycle-ledger: {
  ledger_revision,
  execution_lifecycle_state,
  startup_started_at,
  first_response_deadline,
  soft_timeout_at,
  hard_timeout_at,
  deadline_revision_history,
  extension_count,
  extension_ceiling_at,
  applied_rebase_used,
  last_health_at,
  last_progress_at,
  heartbeat_state,
  status_probe_state,
  status_probe_sent_at,
  status_probe_response_at,
  status_probe_pause_report,
  status_probe_resume_state,
  status_probe_resume_sent_at,
  status_probe_resume_decision_ref,
  channel_generation,
  replaces_channel_run_id,
  replacement_reason,
  cancellation_state,
  returned_at,
  return_timing,
  receipt_decision,
  receipt_decision_reason
}
```

`wait_policy_ref` binds to the immutable baseline on the same
`handoff_packet_id`. Requested, accepted, and applied provenance references
remain separate and never overwrite one another. A returned acceptance or
application receipt is immutable once appended. Pending provenance may resolve
through its pre-bound reference without rewriting an initial budget.

Changing sealed dispatch scope or any wait-baseline field requires a new packet.
A legal lifecycle-ledger revision does not.

The ledger has no authority to modify delivery_slice_id, slice packet baseline,
station, member_assignment, role_instance_id, context visibility, finding
state, repair loop, or member replacement. Those fields are owned by the
slice/role reference. Channel events remain channel events.

## Source Repair, Receipt Revision, And Resume Boundary

An `artifact_receipt_revision` for a changed source return is owned by the
packet routing contract. This lifecycle reference owns only its interaction
with channel state: the repaired implementation channel may return normally,
but that return does not refresh validation, review, memory/docs,
memory-closure, or completion evidence. The packet route marks those dependent
receipts stale and the slice route requires the appropriate explicit member
resume before fresh evidence is produced.

A channel resume restarts only the same channel generation after a probe. It is
not a source-repair resume, receipt revision, member replacement, fresh packet
baseline, or authorization change. Conversely, a finding-based source-repair
resume uses the existing slice decision and packet route; it must not rewrite a
wait baseline or lifecycle deadline merely because downstream evidence became
stale.

## Baseline Materialization And Deadline Ledger

Use the workload class, W50/W90/W99 quantiles, and platform-neutral formulas
from `Shared/policies/references/workflow-execution-spec-contract.md`. The
adapter supplies only its current latency class, multiplier, and first-useful
fraction. This lifecycle reference materializes the resulting immutable
baseline and manages the mutable ledger; it does not define workload bands or
deadline formulas.

The requested execution snapshot establishes the initial wait baseline and
published deadlines. A complete slower accepted request may make one
accepted-request revision only when its proposed deadline is later than the
currently published deadline. Acceptance never proves application, never
shortens a deadline, and never replaces requested provenance.

Only a complete slower applied receipt that actually extends a published
deadline may perform the one-time applied rebase. A faster accepted or applied
result preserves every published deadline and neither shortens a deadline nor
consumes the rebase.

`extension_count` counts only actual deadline increases. It has exactly two
eligible revision kinds: at most one `accepted-slower` revision and at most one
`applied-rebase` revision. There is no progress-only, generic second-extension,
or other extension path. The absolute bound is
`published_hard_deadline - startup_started_at <= extension_ceiling`, where
`extension_ceiling = 2 * initial_hard_budget`. A third revision, a duplicate
kind, or a proposed deadline beyond that ceiling is denied. Every ledger entry
records its revision kind, trigger, previous deadline, new deadline,
extension count, and the matching receipt evidence; only an actual
`applied-rebase` sets `applied_rebase_used: true`.

Timing never changes scope, authorization, station, member, role instance,
context, review depth, validation obligations, protected gates, or
delivery-slice boundaries.

## Shared Lifecycle States

Every adapter uses the same state names. Model family and reasoning effort
change only the wait-policy inputs; they do not create another lifecycle:

```text
packet-ready
→ starting
→ running-silent | progress-reported
→ soft-overrun
→ probe-eligible
→ probe-pending
→ paused-for-probe
→ resume-required
→ running-silent

soft-overrun
→ replacement-eligible
→ returned | late-returned
→ closed
```

`blocked`, `unverified`, and `cancel-pending` remain available when their
evidence is present. `running-silent` means the platform still reports running
inside the current wait policy. `soft-overrun` is a monitoring state, not a
failure. `probe-eligible` permits a decision but does not send a probe.
`resume-required` prohibits further work until explicit resume. A
`replacement-eligible` channel remains present when a new generation starts.

## Lifecycle Transitions

| Trigger | Required evidence | Ledger result |
|---|---|---|
| Initial dispatch | Sealed scope, requested snapshot, and wait baseline | Initialize deadlines with `extension_count: 0` and `applied_rebase_used: false`. |
| Slower accepted request | Complete acceptance receipt, no prior `accepted-slower` revision, and a later proposed deadline within the ceiling | Append one `accepted-slower` revision and increment the shared extension count. |
| Slower applied receipt | Complete application receipt, no prior applied rebase, and a later proposed deadline within the ceiling | Append one `applied-rebase` revision, set `applied_rebase_used: true`, and increment the shared extension count. |
| Faster or non-extending receipt | Complete acceptance or application evidence that does not produce a later deadline | Preserve all published deadlines; do not rewrite the baseline, increment the count, or consume the rebase. |
| Any other extension request or ceiling overrun | A progress-only request, duplicate revision kind, count already two, or proposed deadline beyond the ceiling | Deny without changing scope; record blocked or unverified timing state. |
| Probe sent | Probe eligibility evidence | Move to `probe-pending`. |
| Probe response | Actual response with position, blocker, and safe-to-continue status | Record pause report; move to `paused-for-probe`, then `resume-required`; the channel waits. |
| Explicit channel resume | Captain decision reference for the same role instance and channel run | Record `resume-sent` and `resumed`; return the same generation to running state. |
| Channel replacement | Hard-policy eligibility or concrete blocked/unresponsive evidence | Open a new generation, preserve the original station member and identity, and record linkage without implicit cancellation. |
| Changed source-repair return | Existing slice repair decision and returned source artifact | Record the channel return without a deadline revision; packet routing emits its receipt revision and stale-dependency routing. |
| Late return | Artifact from an original or replaced generation after its normal window | Record `late-returned` and a neutral receipt decision; never discard or auto-prefer it. |

The first-response deadline and soft timeout are monitoring thresholds, not
failure declarations. A probe is prohibited inside the normal silence budget,
while useful progress is recent, or while credible health exists. A probe
receipt pauses the channel. No channel work resumes before an explicit captain
decision for the same role instance and channel run. This is distinct from a
finding-based implementation resume.

Soft overrun alone is not replacement eligibility. Channel replacement requires
the hard policy condition or concrete blocked/unresponsive evidence. It does
not cancel the original channel, replace a station member, or change the slice
roster. Cancellation requires an explicit request and acknowledgement.

Every generation keeps its packet and run identity. A late result is logged,
compared with replacement output when present, and given a neutral decision
such as logged, included-in-synthesis-ledger, routed-to-owner-station,
superseded-by-replacement, duplicate, conflict-review, blocked, or unverified.
First-returned, newest-generation, and fastest output have no automatic
preference. The original and replacement artifacts are never treated as
independent review of one another.
