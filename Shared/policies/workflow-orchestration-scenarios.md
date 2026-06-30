# Workflow Orchestration Scenarios

These scenarios are executable examples for the shared workflow orchestration
contract. They are not authorization. They do not replace Team-Native Core,
Authorization Resolution, the workflow evidence matrix, platform adapters, team
task boards, specialist skills, delivery artifacts, memory gates, validation,
review, commit, release, deployment, install, or external mutation gates.

Use these scenarios when a model needs a concrete flow to follow. If a scenario
conflicts with `workflow-orchestration.md`, the orchestration contract wins.

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

`blocked`, `unverified`, `standby`, and `closed-with-director-risk` are honest
states, not completion. `closed-with-director-risk` is not full team completion.
Full team completion requires implementation change delivery, memory/docs
delivery artifact, review delivery artifact, validation delivery artifact,
completion evidence, `memory_impact`, and `memory_delivery`. If any required
artifact is missing, blocked, unverified, or risk-closed, the state is
`blocked`, `unverified`, or `closed-with-director-risk`; do not report full team
completion.

## Scenario 1: Read-Only Evidence Station

Use when a conversation, exploration, blueprint, audit, or commit-preflight
question needs project files, memory/context, rules, logs, screenshots, or tool
output but must not write files.

```text
trigger: Director asks for evidence, comparison, review, or research.
workflow_route: 00, 01, 02, 07, 08, 09, 10, or 11 as appropriate.
operation_mode: daily for bounded routine evidence; full for governance-impact evidence.
board_state: formal-readonly.
dispatch wave: 1 evidence station.
previous-wave input: Director request and read scope.
next-wave start condition: evidence artifact returned or marked blocked/unverified.
handoff_packet_id: required before specialist work starts.
channel_capability: available, conditional, unavailable, or unverified.
channel_invocation_status: requested, running, returned, blocked, unavailable, or not-authorized.
delivery artifact: evidence artifact with findings, evidence, risk, advice, blocker state.
route-back: route to blueprint, build, fix, audit, or commit only after evidence is sufficient.
completion state: complete only for the read-only question; not source completion.
```

Invalid shortcut: staying direct while doing broad file reads or treating a
read-only summary as write authorization.

## Scenario 2: Blueprint To Build

Use when architecture output is accepted and the Director wants implementation.

```text
trigger: Blueprint or architecture contract is ready for implementation.
workflow_route: 02 -> 03 or 03-1.
operation_mode: full.
board_state: draft for implementation plan, then formal-write after scoped GO.
dispatch wave 1: requirement replay, scope impact, architecture boundary.
previous-wave input: approved blueprint, assumptions, acceptance evidence.
next-wave start condition: scoped GO names the phase, files, or station.
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
dispatch wave 1: captain protected integration of returned change delivery artifact.
previous-wave input: change delivery artifact and scoped authorization.
next-wave start condition: integrated change or recorded blocked/unverified state.
dispatch wave 2: validation and memory/docs attribution.
dispatch wave 3: independent review after the change delivery state exists.
dispatch wave 4: completion audit and commit preparation.
delivery artifact: validation delivery, memory/docs delivery, review delivery, completion evidence.
route-back: failed validation routes to 04, 07, or 03; missing memory routes to memory/docs.
completion state: complete only when all applicable delivery artifacts exist and required evidence is verified.
non-complete state: use blocked, unverified, or closed-with-director-risk when required evidence is missing.
```

Invalid shortcut: validating, reviewing, or committing before change delivery
state exists.

## Scenario 4: Failed Validation Route-Back

Use when test, browser, MCP, or manual validation finds a failure.

```text
trigger: validation_state is failed, blocked, or unverified.
workflow_route: 06 -> 04, 07, 03, or 08.
operation_mode: full when source/workflow impact exists.
board_state: formal-readonly for diagnosis, formal-write only after scoped repair GO.
dispatch wave: diagnosis first; repair starts only after root cause or repair scope is clear.
previous-wave input: failing command, browser path, MCP read, or manual blocker evidence.
next-wave start condition: root cause found, missing implementation identified, or blocker removed.
handoff_packet_id: new packet for diagnosis or repair; do not reuse validation as repair.
delivery artifact: validation artifact plus diagnosis or change delivery artifact.
route-back: 04 for repair, 07 for deeper diagnosis, 03 for missing build work, 08 for systemic audit.
completion state: validation failure is not completion.
```

Invalid shortcut: the validation station repairing the implementation it
validated.

## Scenario 5: Audit Fan-Out

Use when health audit, routine inspection, or broad governance review finds
different categories of work.

```text
trigger: 08 or 10 finds drift, bug, missing evidence, or rule gap.
workflow_route: 08 -> 08-1 -> 08-2 -> 08-3, then 03, 04, 06, 09, or 12.
operation_mode: daily only for bounded routine evidence; full for governance-impact findings.
board_state: formal-readonly until an authorized write workflow starts.
dispatch wave 1: inventory evidence.
dispatch wave 2: logic, security, reliability, or governance review.
dispatch wave 3: report and route recommendation.
previous-wave input: inventory before logic, logic before report.
next-wave start condition: finding is mapped to build, fix, test, commit, or skill-forge.
delivery artifact: audit evidence artifact and route-back recommendation.
route-back: build for missing feature, fix for defect, test for evidence gap, skill-forge for rule gap.
completion state: audit report is complete only for audit scope, not for the routed repair.
```

Invalid shortcut: issuing a final audit report before inventory and logic
evidence exist.

## Scenario 6: Commit-Preflight Blocker

Use when commit preparation discovers dirty files, stale memory, missing
validation, missing review, missing sync, or untracked new files.

```text
trigger: commit-preflight or 09 finds a blocker.
workflow_route: 09 -> 03, 04, 05, 06, 08, or 11.
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

## Scenario 7: Generated Or Deployed Copy Sync

Use when source governance files have deployed copies.

```text
trigger: source policy, workflow, command, shared skill, or generated copy changes.
workflow_route: 03 or 12 -> validation/review -> 09.
operation_mode: full for public-contract or workflow impact.
board_state: formal-write for source integration and generated-copy sync.
dispatch wave 1: source change delivery.
dispatch wave 2: generated or deployed copy sync.
dispatch wave 3: hash or content validation.
previous-wave input: source file list and generated-copy target list.
next-wave start condition: sync completes or is marked blocked/unverified.
delivery artifact: change delivery plus validation evidence for source/deployed parity.
route-back: if drift remains, return to sync or mark residual risk.
completion state: complete only when source/deployed parity is checked and clean.
non-complete state: use blocked or unverified when source/deployed sync cannot be verified.
```

Invalid shortcut: claiming deployed behavior changed when only source files were
updated.

## Scenario 8: Hook-Guided Captain-Lite Read

Use when a platform hook must avoid blocking useful orientation reads while
still preventing unauthorized writes and false completion claims.

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
route-back: broad read without deep-read evidence routes back to formal-readonly; unauthorized write routes back to authorization resolution.
completion state: blocked or unverified if the model only performed captain broad-read or lacks delivery artifacts.
```

Invalid shortcut: treating a hook warning as permission to complete, or treating
a formal-write board as authorization for git, memory commit, release, deploy,
install, destructive file operations, package publication, or external-state
mutation without a protected authorization record.

## Anti-Examples

- Draft board dispatches formal specialists.
- Draft evidence satisfies formal acceptance.
- Post-board all-at-once dispatch starts every station at once.
- Read-only means no-team.
- Standby means evidence returned.
- Closed-with-director-risk means complete.
- Review or validation starts before the related change delivery state exists.
- The captain authors specialist implementation, validation, review, or memory
  attribution and claims full team completion.
