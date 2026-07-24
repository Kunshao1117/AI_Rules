# Invalid Team Trace Patterns

This reference is the sole owner of invalid Team-Native trace patterns. It
consumes field definitions from `team-trace-fields.md` and board values from the
board field references; it does not redefine either.

## Station, Slice, And Finding Failures

- Treating a `delivery_slice` as permission to merge implementation, validation,
  or review into one station, member, role instance, context, or packet.
- Closing an implementation, validation, or review station between rounds and
  silently assigning a new member for the next round.
- Treating a finding as automatic repair authority, or resuming an
  implementation station without the explicit captain resume decision.
- Creating a separate repair station or a new repair member for a first or
  second same-symptom finding. Repair is resumed work by the original
  implementation station in the same slice.
- Resuming validation or review before the original implementation station has
  returned its numbered-finding repair.
- Letting validation or review write, repair, or approve its own implementation.
- Letting the implementation member validate or review its own repair.
- Running a third same-symptom repair without a recorded independent diagnosis
  or module-split escalation, or allowing that escalation station to replace the
  original implementation station without a valid replacement decision.
- Changing a fixed slice member, role instance, context, or packet baseline for
  convenience, elapsed time, a timeout, or a channel event.
- Treating a channel generation replacement as a personnel or station
  replacement.
- Changing a member without a captain decision, allowed replacement reason,
  prior role-instance reference, and sealed context-transfer evidence.

## Channel And Receipt Failures

- Treating a wait timeout, missing first response, or soft overrun as failure,
  cancellation, absence, or authorization to change station membership.
- Continuing a probed channel after its response without the pause report and
  explicit captain channel-resume decision for the same run.
- Replacing a channel without `channel_generation`, `replaces_channel_run_id`,
  `replacement_reason`, late-result policy, and cancellation state.
- Dropping a late artifact, or treating the first, fastest, or newest result as
  automatically preferred.
- Treating requested values, tool acceptance, transport identifiers, or a
  successful call as observed application evidence.
- Filling an accepted or applied field from another provenance layer, or
  accepting a partial/conflicting receipt as applied.

## Captain And Evidence Failures

- Treating a returned subagent reply as the captain's conclusion, validation,
  review, quality disposition, acceptance, or completion evidence.
- Rewriting a returned artifact as captain-authored station evidence or using a
  captain broad/deep read as a substitute for the owner station.
- Treating `direct` as a route, channel, station state, or completion state.
- Claiming full completion while a required station, visibility field, packet,
  delivery artifact, channel closure, sync record, or residual-risk disposition
  is missing.

## Authorization And Completion Failures

- Treating a workflow name, natural-language intent, interface button, platform
  mode, sandbox, tool availability, or execution receipt as authority beyond
  the current resolved target, scope, phase, and expiry.
- Reusing implementation authorization for repair outside the existing slice
  scope, change application, memory, Git, release, deployment, install, or
  external mutation.
- Using a flowchart, checklist, visual plan, transport success, or historical
  transcript as execution spec, handoff, authorization, validation, review, or
  completion evidence.
- Reporting `closed-with-director-risk` without current, explicit, scope-bound
  `risk_close_evidence`, or reporting it as complete.
- Omitting required external-grounding fields when current external facts,
  versions, security, compliance, cost, deployment, or release facts affect the
  claim.
