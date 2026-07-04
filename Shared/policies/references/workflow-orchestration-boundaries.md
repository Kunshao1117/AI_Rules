# Workflow Orchestration Boundaries

This reference holds invalid orchestration patterns and entry minimums for
`source: Shared/policies/workflow-orchestration.md; deployed: .agents/shared/policies/workflow-orchestration.md`. The main orchestration policy owns
the sequence; this file owns the long boundary lists.

## Invalid Orchestration Patterns

These patterns must be treated as Red, blocked, unverified, or
closed-with-director-risk, not as complete:

- Draft board dispatches or spawns a formal specialist.
- Draft evidence counts as formal acceptance evidence.
- In active Team mode, no-write or read-only work is described as no-team,
  without-team, or skip-team.
- Post-board all-at-once dispatch starts all stations at once.
- Standby is treated as returned evidence, validation, review, or completion.
- A wait timeout is treated as failure, cancellation, rejection, or absence
  without status-probe evidence, hard-timeout evidence, explicit cancellation,
  or returned failure artifact.
- A probed channel continues work after status response without a pause report
  and explicit captain resume message for the same channel.
- A replacement channel silently cancels or hides the original channel instead
  of recording replacement reason, cancellation state, late-result policy, and
  receipt decision for any late artifact.
- Closed-with-director-risk is not full team completion and must not be
  reported as `complete`.
- Review or validation starts before the relevant change delivery artifact state.
- Same-wave implementation and same-deliverable review are forbidden.
- The captain authors specialist implementation, validation, review, or memory attribution and then claims complete.
- While member work is running, the captain performs context-expanding reads,
  duplicate scans, re-checks, substitute validation, substitute review,
  memory/docs attribution, or rewrites member findings as captain-owned
  evidence. Board records for blocker handling, station-output ledgering,
  artifact receipt, conflict, authorization reason, or scope-question routing
  permit captain coordination only; they do not authorize captain broad reads
  and cannot become owner evidence or completion evidence.
- Large-file specialist deep-read is replaced by captain direct reading. Even
  with a direct exception and residual state, that captain read is
  coordination/direct-exception risk evidence only; it cannot become owner
  evidence, validation or review evidence, memory/docs attribution, or
  completion evidence.
- Implementation falls back to routine captain direct work without isolated change delivery, text change delivery artifact, or Director risk closure.
- A dirty target file is modified without reading the current diff and target
  section first.
- An already modified section is adjusted by adding a sidecar file, duplicate
  heading, append-only paragraph, repeated clause, or stacked patch layer instead
  of integrating the change in place.
- Workflow entries or policies copy the full team-task-board field list instead
  of citing `team-task-board` and `team-trace-evidence`.
- Codex `update_plan`, a checklist, or any platform plan UI state is treated as
  authorization, implementation evidence, validation evidence, review evidence,
  memory/docs evidence, source/deployed parity evidence, or completion evidence.
- `blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, or
  `closed-with-director-risk` is used as an execution route instead of a state.
- `direct` is used as `execution_route`, `execution_channel`, platform route,
  execution mode, or station state instead of being recorded as a
  station-specific `direct_exception` / `direct_exceptions` entry with
  replacement evidence and residual state.
- Source/deployed pairs are changed without recorded sync direction and parity
  evidence.
- Formal station work claims completion without `station_mode`,
  `context_visibility`, and `handoff_ownership`.

## Workflow Family Presets

When Team mode is active, workflow entries keep their matrix row and apply the
matching preset below.

| Family | Workflows | Default orchestration |
|---|---|---|
| Intake and exploration | 00, 01 | Direct only for pure conversation, small stable answers, or no-impact read-only work. Evidence-bearing work uses `formal-readonly` with bounded source, research, or counter-evidence stations. |
| Architecture and diagnosis | 02, 07 | `formal-readonly` for intent, counter-evidence, architecture, impact, and root-cause evidence. Route to build, fix, experiment, or audit when writes or broader evidence are needed. |
| Change production | 03-1, 03, 04, 12 | `formal-write` only after scoped authorization resolution. Implementation returns change delivery before validation, review, memory/docs, and completion. |
| Validation and audit | 06, 08, 08-1, 08-2, 08-3, 10 | Read-only validation/audit stations do not repair implementation. Failed validation routes back to fix, debug, build, or audit. |
| Knowledge and closeout | 05, 09, 11 | Source memory/docs, commit prep, and handoff use evidence and completion stations. Commit, push, release, deployment, and memory commit stay protected phases. |

## Transition Rules

| From | To | Required condition | Forbidden shortcut |
|---|---|---|---|
| 00 chat | 01, 02, or `formal-readonly` | Files, memory/context, rules, tool output, agent behavior, screenshots, or governance evidence are needed under an active governed request, or normal routing needs another workflow. | Do not stay direct while performing broad file reads or evidence work in active Team mode. |
| 01 explore | 02, 03-1, or 08 | Evidence is current enough to shape architecture, experiment, or audit. | Do not start build from insufficient evidence. |
| 02 blueprint | 03, 03-1, 08, or 11 | Handoff contract, assumptions, acceptance evidence, write boundary, and platform plan mapping state are clear. | Do not treat architecture output, `plan-only`, or a platform plan mirror as write authorization. |
| 03-1 experiment | 03 or 11 | Prototype is promoted or discarded with clear scope. | Do not commit or claim production quality for disposable prototype work. |
| 07 debug | 04 or 08 | Root cause is found, or broader audit is needed. | Debug stations do not patch core code. |
| 03 or 04 | 06, review, memory/docs, 09 | Change delivery exists or is honestly marked blocked, unverified, or risk-closed. | Do not validate, review, or commit before change delivery state exists. |
| 06 failed validation | 04, 07, or 03 | Failure maps to repair, diagnosis, or missing implementation. | Validation stations do not repair the implementation they validate. |
| 08 | 08-1, 08-2, 08-3, 03, 04, 09 | Inventory, logic review, and report evidence are ordered. | Do not issue audit report before inventory and logic evidence. |
| 10 routine | 08, 04, 02, or 12 | Anomaly, drift, or rule gap is found. | Routine inspection does not write fixes. |
| 09 commit | 03, 04, 05, 06, 08, or 11 | Preflight finds source, memory, validation, audit, or handoff gaps. | Commit flow does not hide blockers or complete unfinished work. |

## Entry Minimum Reference

Workflow entries must keep a short reference block only:

1. Read the deployed workflow orchestration contract.
2. Use the scenario playbooks only as non-authorizing examples when a concrete
   flow is needed.
3. Read the platform plan mapping contract when `plan-only`, `build-plan`,
   Codex `update_plan`, a checklist, or platform planning UI affects the work.
4. Read the matching workflow evidence matrix row.
5. Read the skill governance contract when editing workflow entries, skills, or
   shared governance boundaries.
6. Read the deployed language governance policy before applying workflow-specific
   output-language, audience-layer, handoff, or change-description rules.
7. Read the deployed grounding governance policy before relying on external
   sources, freshness-sensitive claims, or outside documentation as formal
   evidence.
8. Apply the platform capability matrix.
9. When Team mode is active, build or promote the Captain Team Board
   before broad evidence, change delivery, validation, review, memory/docs, or
   completion work.
10. Route missing stations, handoff packets, channel states, or delivery
   artifacts to blocked, unverified, standby, or closed-with-director-risk.

The detailed board field list stays in `team-task-board`, detailed trace fields
stay in `team-trace-evidence`, and platform execution channel rules stay in
`subagent-invocation`.
