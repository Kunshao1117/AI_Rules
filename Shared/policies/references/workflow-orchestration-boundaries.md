# Workflow Orchestration Boundaries

This reference holds invalid orchestration patterns and entry minimums for the workflow orchestration contract.

- Source: `Shared/policies/workflow-orchestration.md`.
- Deployed: `.agents/shared/policies/workflow-orchestration.md`.

The main orchestration policy owns the sequence; this file owns the long boundary lists.

## Invalid Orchestration Patterns

These patterns must be treated as Red, blocked, unverified, or closed-with-director-risk, not as complete:

- Draft board dispatches or spawns a formal specialist.
- Draft evidence counts as formal acceptance evidence.
- In active Team mode, no-write or read-only work is described as no-team, without-team, or skip-team.
- Post-board all-at-once dispatch starts all stations at once.
- Standby is treated as returned evidence, validation, review, or completion.
- A wait timeout is treated as failure, cancellation, rejection, or absence without one of these evidence forms:
  - status-probe evidence.
  - hard-timeout evidence.
  - explicit cancellation.
  - returned failure artifact.
- A probed channel continues work after status response without a pause report and explicit captain resume message for the same channel.
- A replacement channel silently cancels or hides the original channel instead of recording:
  - replacement reason.
  - cancellation state.
  - late-result policy.
  - receipt decision for any late artifact.
- Closed-with-director-risk is not full team completion and must not be reported as `complete`.
- Review or validation starts before the relevant change delivery artifact state.
- Same-wave implementation and same-deliverable review are forbidden.
- The captain authors specialist implementation, validation, review, or memory attribution and then claims complete.
- While member work is running, the captain must not perform these actions:
  - context-expanding reads.
  - duplicate scans or re-checks.
  - substitute validation or substitute review.
  - memory/docs attribution.
  - rewrites of member findings as captain-owned evidence.
- Board records for blocker handling, station-output ledgering, artifact receipt, conflict, or authorization reason are coordination only.
- Board records for scope-question routing are coordination only.
- Those board records do not authorize captain broad reads.
- Those board records cannot become owner evidence or completion evidence.
- Large-file specialist deep-read is replaced by captain direct reading.
- Even with a direct exception and residual state, that captain read is coordination/direct-exception risk evidence only.
- That captain read cannot become owner evidence, validation or review evidence, memory/docs attribution, or completion evidence.
- Implementation falls back to routine captain direct work without one of these routes:
  - isolated change delivery.
  - text change delivery artifact.
  - Director risk closure.
- A dirty target file is modified without reading the current diff and target section first.
- An already modified section is adjusted by adding one of these bypasses instead of integrating the change in place:
  - sidecar file.
  - duplicate heading.
  - append-only paragraph.
  - repeated clause.
  - stacked patch layer.
- Workflow entries or policies copy the full team-task-board field list instead of citing `team-task-board` and `team-trace-evidence`.
- Codex `update_plan`, a checklist, or any platform plan UI state is treated as one of these evidence or authority types:
  - authorization.
  - implementation evidence.
  - validation evidence.
  - review evidence.
  - memory/docs evidence.
  - source/deployed parity evidence.
  - completion evidence.
- State labels are used as an execution route instead of a state:
  - `blocked`.
  - `unverified`.
  - `standby`.
  - `not-authorized`.
  - `unavailable`.
  - `closed-with-director-risk`.
- `direct` is used as `execution_route`, `execution_channel`, platform route, execution mode, or station state.
- `direct` must instead be recorded as a station-specific `direct_exception` / `direct_exceptions` entry.
- The direct-exception entry must include replacement evidence and residual state.
- Source/deployed pairs are changed without recorded sync direction and parity evidence.
- Formal station work claims completion without `station_mode`, `context_visibility`, and `handoff_ownership`.

## Workflow Family Presets

When Team mode is active, workflow entries keep their matrix row and apply the matching preset below.

### Intake and exploration

- Workflows: 00, 01.
- Default orchestration: Direct only for pure conversation, small stable answers, or no-impact read-only work.
- Evidence-bearing work uses `formal-readonly` with bounded source, research, or counter-evidence stations.

### Architecture and diagnosis

- Workflows: 02, 07.
- Default orchestration: `formal-readonly` for intent, counter-evidence, architecture, impact, and root-cause evidence.
- Route to build, fix, or experiment when writes or broader evidence are needed.

### Change production

- Workflows: 03-1, 03, 04, 12.
- Default orchestration: `formal-write` only after scoped authorization resolution.
- Implementation returns change delivery before validation, review, memory/docs, and completion.

### Validation and routine

- Workflows: 06, 10.
- Default orchestration: Read-only validation or routine stations do not repair implementation.
- Failed validation routes back to fix, debug, or build.

### Knowledge and closeout

- Workflows: 05, 09, 11.
- Default orchestration: Source memory/docs, commit prep, and handoff use evidence and completion stations.
- Commit, push, release, deployment, and memory commit stay protected phases.

## Transition Rules

### 00 chat -> 01, 02, or `formal-readonly`

- Required condition:
  - Files, memory/context, rules, tool output, agent behavior, screenshots, or governance evidence are needed.
  - The need appears under an active governed request.
  - Normal routing needs another workflow.
- Forbidden shortcut: Do not stay direct while performing broad file reads or evidence work in active Team mode.

### 01 explore -> 02 or 03-1

- Required condition: Evidence is current enough to shape architecture or experiment.
- Forbidden shortcut: Do not start build from insufficient evidence.

### 02 blueprint -> 03, 03-1, or 11

- Required condition: Handoff contract, assumptions, acceptance evidence, write boundary, and platform plan mapping state are clear.
- Forbidden shortcut: Do not treat architecture output, `plan-only`, or a platform plan mirror as write authorization.

### 03-1 experiment -> 03 or 11

- Required condition: Prototype is promoted or discarded with clear scope.
- Forbidden shortcut: Do not commit or claim production quality for disposable prototype work.

### 07 debug -> 04

- Required condition: Root cause is found.
- Forbidden shortcut: Debug stations do not patch core code.

### 03 or 04 -> 06, review, memory/docs, 09

- Required condition: Change delivery exists or is honestly marked blocked, unverified, or risk-closed.
- Forbidden shortcut: Do not validate, review, or commit before change delivery state exists.

### 06 failed validation -> 04, 07, or 03

- Required condition: Failure maps to repair, diagnosis, or missing implementation.
- Forbidden shortcut: Validation stations do not repair the implementation they validate.

### 10 routine -> 04, 02, or 12

- Required condition: Anomaly, drift, or rule gap is found.
- Forbidden shortcut: Routine inspection does not write fixes.

### 09 commit -> 03, 04, 05, 06, or 11

- Required condition: Preflight finds source, memory, validation, or handoff gaps.
- Forbidden shortcut: Commit flow does not hide blockers or complete unfinished work.

## Entry Minimum Reference

Workflow entries must keep a short reference block only:

1. Read the deployed workflow orchestration contract.
2. Use the scenario playbooks only as non-authorizing examples when a concrete flow is needed.
3. Read platform plan mapping when `plan-only`, `build-plan`, Codex `update_plan`, checklist, or planning UI affects the work.
4. Read the matching workflow evidence matrix row.
5. Read the skill governance contract when editing workflow entries, skills, or shared governance boundaries.
6. Read deployed language governance before workflow-specific output-language, audience-layer, handoff, or change-description rules.
7. Read deployed grounding governance before relying on external sources, freshness-sensitive claims, or outside documentation.
8. Apply the platform capability matrix.
9. When Team mode is active, build or promote the Captain Team Board before broad evidence or station work.
10. Route missing stations, handoff packets, channel states, or delivery artifacts to the matching non-complete state.

Detailed board field lists stay in `team-task-board`.

Detailed trace fields stay in `team-trace-evidence`.

Platform execution channel rules stay in `subagent-invocation`.
