# Workflow Orchestration Scenarios

These scenarios are executable examples for the shared workflow orchestration contract.

They are not authorization.

They do not replace these gates or owner sources:

- Team-Native Core.
- Authorization Resolution.
- Workflow evidence matrix.
- Platform adapters.
- Team task boards.
- Specialist skills.
- Delivery artifacts.
- Memory gates.
- Validation.
- Review.
- Commit, release, deployment, install, or external mutation gates.

Shared value catalogs:

- Status meanings: `Shared/policies/references/status-ontology.md`.
- Completion targets and states:
  `Shared/policies/references/completion-state-machine.md`.
- Authorization phases:
  `Shared/policies/references/authorization-phase-registry.md`.
- Protected actions:
  `Shared/policies/references/protected-action-registry.md`.
- Hook event lifecycle:
  `Shared/policies/references/hook-event-matrix.md`.

Use these scenarios when a model needs a concrete flow to follow.

If a scenario conflicts with `workflow-orchestration.md`, the orchestration contract wins.

## Scenario Format

Every scenario records:

```text
trigger:
workflow_route:
operation_mode:
board_state:
dispatch wave:
previous-wave input:
next-wave start condition:
handoff_packet_id:
channel_capability:
channel_invocation_status:
delivery artifact:
route-back:
completion state:
```

`blocked`, `unverified`, `partial`, `standby`, and `closed-with-director-risk`
are honest states from the status ontology, not completion.

`closed-with-director-risk` is not full team completion.

Process completion requires these artifacts and fields:

- Implementation change delivery.
- Memory/docs delivery artifact.
- Review delivery artifact.
- Validation delivery artifact.
- Completion evidence.
- `memory_impact`.
- `memory_delivery`.

If any required artifact is missing, blocked, unverified, or risk-closed, use the matching non-complete state.

Do not report full team completion.

For the same closeout target, `complete` is mutually exclusive with every
non-complete state listed in `completion-state-machine.md`.

## Scenario 1: Read-Only Evidence Station

Use when a no-write question needs project evidence.

The question may come from conversation, exploration, blueprint, or commit-preflight work.

Evidence inputs may include project files, memory/context, rules, logs, screenshots, or tool output.

```text
trigger: Director asks for evidence, comparison, review, or research.
workflow_route: 00, 01, 02, 07, 09, 10, or 11 as appropriate.
operation_mode: daily for bounded routine evidence; full for governance-impact evidence.
board_state: formal-readonly.
dispatch wave: 1 evidence station.
previous-wave input: Director request and read scope.
next-wave start condition: evidence artifact returned or marked blocked/unverified.
handoff_packet_id: required before specialist work starts.
channel_capability: available, conditional, unavailable, or unverified.
channel_invocation_status: requested, running, returned, blocked, unavailable, or not-authorized.
delivery artifact: evidence artifact with findings, evidence, risk, advice, blocker state.
route-back: route to blueprint, build, fix, or commit only after evidence is sufficient.
completion state: complete only for the read-only question; not source completion.
```

Invalid shortcut: staying direct while doing broad file reads or treating a read-only summary as write authorization.

## Scenario 2: Blueprint To Build

Use when architecture output is accepted and the Director wants implementation.

```text
trigger: Blueprint or architecture contract is ready for implementation.
workflow_route: 02 -> 03 or 03-1.
operation_mode: full.
board_state:
  draft for implementation plan, then formal-write only after authorization
  resolution binds the Director intent signal to the implementation phase or
  file/station scope.
dispatch wave 1: requirement replay, scope impact, architecture boundary.
previous-wave input: approved blueprint, assumptions, acceptance evidence.
next-wave start condition: authorization resolution names and binds the phase, files, station, and any expiry.
dispatch wave 2: implementation change delivery.
handoff_packet_id: one packet for the change-delivery station.
delivery artifact: implementation change delivery artifact with memory_impact.
route-back: if scope is unclear, return to 02 or formal-readonly evidence.
completion state: not complete until validation, review, memory/docs, and completion audit exist.
```

Invalid shortcut: treating the blueprint itself as write authorization.

## Scenario 3: Build Or Fix To Validation, Review, Memory, And Commit Prep

Use after an implementation or repair change delivery artifact exists.

```text
trigger: Change delivery artifact returned, blocked, unverified, or closed-with-director-risk.
workflow_route: 03 or 04 -> 06, review, memory/docs, completion, then 09.
operation_mode: full.
board_state: formal-write for integration, then eligible validation/review/memory stations.
dispatch wave 1: receive the one complete change delivery artifact produced after all ordered steps and files in the resolved scope, or perform only its authorized change application and integration.
previous-wave input: change delivery artifact and scoped authorization.
intermediate checkpoint: only for a material change to scope or authorization, public contract, migration, security posture, or an irreversible/protected action.
next-wave start condition: complete delivery, including applicable source/deployed sync, or a recorded blocked/unverified state.
dispatch wave 2: validation and independent review run as siblings; independent checks may run in parallel and dependency-ordered checks stay sequential.
dispatch wave 3: memory/docs attribution after validation and review reach terminal evidence states.
dispatch wave 4: completion audit and commit preparation.
delivery artifact: validation delivery, memory/docs delivery, review delivery, completion evidence.
route-back: failed validation routes to 04, 07, or 03; missing memory routes to memory/docs.
completion state: complete only when all applicable delivery artifacts exist and required evidence is verified.
non-complete state: use blocked, unverified, or closed-with-director-risk when required evidence is missing.
```

Invalid shortcut: restarting formal review after every file, starting memory/docs before validation and review are terminal, or committing before change delivery exists.

## Scenario 4: Failed Validation Route-Back

Use when test, browser, MCP, or manual validation finds a failure.

```text
trigger: validation_state is failed, blocked, or unverified.
workflow_route: 06 -> 04, 07, or 03.
operation_mode: full when source/workflow impact exists.
board_state: formal-readonly for diagnosis, formal-write only after authorization resolution binds the repair scope.
dispatch wave: diagnosis first; repair starts only after root cause or repair scope is clear.
previous-wave input: failing command, browser path, MCP read, or manual blocker evidence.
next-wave start condition: root cause found, missing implementation identified, or blocker removed.
handoff_packet_id: new packet for diagnosis or repair; do not reuse validation as repair.
delivery artifact: validation artifact plus diagnosis or change delivery artifact.
route-back: 04 for repair, 07 for deeper diagnosis, or 03 for missing build work.
completion state: validation failure is not completion.
```

Invalid shortcut: the validation station repairing the implementation it validated.

## Scenario 5: Commit-Preflight Blocker

Use when commit preparation discovers dirty files, stale memory, missing validation, missing review, missing sync, or untracked new files.

```text
trigger: commit-preflight or 09 finds a blocker.
workflow_route: 09 -> 03, 04, 05, 06, or 11.
operation_mode: full for commit/release readiness.
board_state: formal-readonly for scan; formal-write only for named repairs or memory phase.
dispatch wave: scan first, route-back second, commit only after blockers clear.
previous-wave input: dirty file list, memory state, validation state, review state.
next-wave start condition: blocker owner and repair workflow are identified.
delivery artifact: release-completion or commit-preflight evidence artifact.
route-back: memory/docs for stale memory, validation for missing tests, review for missing review.
completion state: blocked until source, memory, validation, review, and sync blockers clear.
```

Invalid shortcut: hiding a blocker inside a commit summary.

## Scenario 6: Generated Or Deployed Copy Sync

Use when source governance files have deployed copies.

```text
trigger: source policy, workflow, command, shared skill, or generated copy changes.
workflow_route: 03 or 12 -> validation/review -> 09.
operation_mode: full for public-contract or workflow impact.
board_state: formal-write for source integration and generated-copy sync.
dispatch wave 1: source change delivery.
dispatch wave 2: generated or deployed copy sync.
dispatch wave 3: hash/content validation and independent review may run as sibling work when independent; dependency-ordered checks stay sequential.
previous-wave input: source file list and generated-copy target list.
next-wave start condition: sync completes or is marked blocked/unverified.
delivery artifact: change delivery plus validation and review evidence, including source/deployed parity.
route-back: if drift remains, return to sync or mark residual risk.
completion state: complete only when source/deployed parity is checked and clean.
non-complete state: use blocked or unverified when source/deployed sync cannot be verified.
```

Invalid shortcut: claiming deployed behavior changed when only source files were updated.

## Scenario 7: Hook-Guided Captain-Lite Read

Use when a platform hook must avoid blocking useful orientation reads.

It must still prevent unauthorized writes and false completion claims.

```text
trigger: Model performs a small read, broad read, write, protected mutation, or completion claim.
workflow_route: current workflow route or formal-readonly if the route is still being located.
operation_mode: daily for bounded orientation; full for governance-impact or source-impact work.
board_state: no board for micro-read only; formal-readonly for broad evidence; formal-write for scoped writes.
dispatch wave: micro-probe, specialist deep-read, scoped change, then validation/review/memory.
previous-wave input: user request and any hook context warning.
next-wave start condition: route found, board opened, or action blocked/unverified.
handoff_packet_id: required before specialist deep-read or write station.
channel_capability: recorded for specialist deep-read and later stations.
channel_invocation_status: running, returned, blocked, unavailable, or not-authorized.
delivery artifact: read evidence, change delivery, validation delivery, review delivery, memory/docs delivery.
route-back:
  broad read without deep-read evidence routes back to formal-readonly;
  unauthorized write routes back to authorization resolution.
completion state: blocked or unverified if the model only performed captain broad-read or lacks delivery artifacts.
```

Invalid shortcut: treating a hook warning as permission to complete.

Invalid shortcut: treating a formal-write board as authorization for protected actions without a protected authorization record.

Protected actions include git, memory commit, release, deploy, install, and destructive file operations.

They also include package publication and external-state mutation.

The canonical protected-action catalog lives in
`Shared/policies/references/protected-action-registry.md`.

## Scenario 9: Channel Life Probe Transition

Use when a running specialist channel receives a status probe, resume, wait timeout, replacement, or late result.

```text
trigger: Director or captain sends a status probe to a running channel.
workflow_route: current workflow route; no new authorization is granted.
operation_mode: inherits the active station.
board_state: keep the current formal-readonly or formal-write state.
dispatch wave: pause-and-report, resume, wait timeout, replacement, late result.
previous-wave input: active handoff packet and channel_invocation_status: running.
next-wave start condition: captain resume, hard timeout evidence, replacement decision, or late-result receipt decision.
handoff_packet_id: keep the original packet; replacement gets its own packet.
channel_capability: unchanged unless replacement records a new capability.
channel_invocation_status: status-probed, paused, resumed, timeout, replacement-running, returned-late.
delivery artifact: pause report with read position, blocker state, safe-to-continue state, or late artifact receipt decision.
route-back: timeout routes to blocked/unverified; replacement records cancellation and late-result policy.
completion state:
  not complete while status_probe_resume_state: awaiting-resume,
  cancellation_state: cancellation-pending, or
  late_result_policy: late-result-pending.
```

Invalid shortcut: continuing after pause-and-report without resume.

Invalid shortcut: treating wait timeout as cancellation without evidence.

Invalid shortcut: hiding a late result after a replacement channel starts.

## Anti-Examples

- Draft board dispatches formal specialists.
- Draft evidence satisfies formal acceptance.
- Post-board all-at-once dispatch starts every station at once.
- Read-only means no-team.
- Standby means evidence returned.
- Closed-with-director-risk means complete.
- Review or validation starts before the related change delivery state exists.
- The captain authors specialist implementation, validation, review, or memory attribution and claims full team completion.
