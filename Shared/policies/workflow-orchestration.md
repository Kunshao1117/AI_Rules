# Workflow Orchestration Contract

This policy is the shared workflow orchestration layer for AI_Rules. It defines
how workflow entries start, hand off, wait, route back, and close across
Codex, Claude, and Antigravity. It does not replace Team-Native Core, the
workflow evidence matrix, platform adapters, team task boards, specialist role
skills, or authorization policy.

## Source-Of-Truth Chain

Use this contract as the thin sequence layer between workflow routing and
Team-Native station execution.

| Layer | Owns |
|---|---|
| `Shared/policies/team-native-core.md` | Highest-priority Team-Native gate, operation mode, station-first rule, and completion boundary. |
| `Shared/policies/authorization-resolution.md` | Scope-bound authorization fields and phase-specific write gates. |
| `Shared/policies/workflow-orchestration.md` | Workflow entry sequence, transition rules, dispatch waves, and missing-evidence routing. |
| `Shared/policies/workflow-orchestration-scenarios.md` | Non-authorizing scenario playbooks that show how workflows cooperate without copying rules into entries. |
| `Shared/workflow-capability-evidence-matrix.md` | Per-workflow route, evidence expectations, and next workflow suggestions. |
| `Shared/platform-capability-matrix.md` | Platform capability translation for Codex, Claude, and Antigravity. |
| `Shared/skills/team-task-board/SKILL.md` | Board templates, station fields, delivery artifact formats, direct exceptions, and completion checklist. |
| `Shared/policies/team-trace-evidence.md` | Task trace evidence fields and invalid runtime trace patterns. |

Workflow entries must reference this chain instead of copying the full chain
into every entry. If two shared sources conflict, Team-Native Core and
Authorization Resolution win before this orchestration contract.

Scenario playbooks live in `Shared/policies/workflow-orchestration-scenarios.md`.
They are concrete examples only. They do not grant authorization, create new
completion states, or override this contract.

## Entry Sequence

Every workflow entry follows this sequence before broad reading, validation,
review, implementation, memory/docs attribution, commit preparation, release
preparation, or completion claims:

```text
Director instruction
-> workflow route
-> authorization resolution
-> operation_mode
-> board_template
-> board_state
-> station set
-> dispatch wave
-> station handoff packet
-> channel capability and channel invocation status
-> returned delivery artifact or blocked/unverified/standby state
-> captain verify-read and integration decision
-> validation, review, memory/docs, completion audit
```

Workflow route is not authorization. A workflow name, slash command, Codex
skill trigger, Antigravity workflow button, Claude command, platform mode,
approval prompt, or available channel can route the work, but it cannot grant
unbounded write authority or protected follow-on authority.

## Board-State Boundary

| Board state | Allowed orchestration | Forbidden shortcut |
|---|---|---|
| `draft board` | Pre-GO planning, candidate station list, assumptions, and proposed dispatch waves. | Draft board cannot dispatch, spawn, or open formal specialists. Draft evidence cannot satisfy formal evidence eligibility. |
| `formal-readonly` | Read-only evidence, source/doc deep-read, external research, validation planning, review evidence, and standby stations. | No-write does not mean no-team. Read-only work cannot write source, memory, git, release, deployment, install, or external state. |
| `formal-write` | GO-backed change delivery, captain protected integration, validation, review, memory/docs delivery, and completion audit inside the authorized scope. | Formal-write is not blanket authority; each phase keeps its own authorization source, target, scope, evidence, expiry, and resolution state. |

## Operation Mode

`operation_mode: daily` is allowed only for routine, low-risk, bounded evidence
with no source, workflow, skill, audit-rule, public-contract, release,
deployment, install, external-state, or protected mutation impact. A daily board
still needs role identity, a handoff packet, channel state, and honest
blocked/unverified state.

`operation_mode: full` is required for implementation, repair, bottom-layer
refactor, cross-file governance, specialist skill rewrites, Doctor/Audit
changes, commit/release/deploy preparation, protected external-state readiness,
or any source/workflow/public-contract impact.

## Dispatch Waves

Formal orchestration is wave-gated:

1. Open only the current dispatch wave.
2. Record previous-wave input before starting the next wave.
3. Record the next-wave start condition before the next wave is eligible.
4. Mark formal evidence eligibility for every station.
5. Do not perform post-board all-at-once dispatch.

Review and validation that judge a change wait until the implementation change
delivery artifact is returned, blocked, unverified, or closed-with-director-risk.
Implementation and review of the same deliverable do not run in the same wave.

## Station Handoff And Channel State

Every formal station needs a station handoff packet before it can produce
formal evidence. The packet names the assigned specialist skill, role identity,
loaded skill refs, read scope, forbidden actions, output artifact format, stop
condition, startup monitoring, and standby reason when applicable.

The board records requested execution channel, channel capability, channel
invocation status, execution channel, delivery artifact type, delivery artifact
status, evidence owner, role boundary, direct exception, and completion
condition. Missing channel capability is not a reason to erase a station; it is
blocked, unverified, standby, unavailable, not-authorized, or
closed-with-director-risk.

## Workflow Family Presets

Workflow entries keep their specific row in the workflow evidence matrix, then
apply the matching preset below:

| Family | Workflows | Default orchestration |
|---|---|---|
| Intake and exploration | 00, 01 | Direct only for pure conversation. Evidence-bearing work upgrades to formal-readonly with bounded source, research, or counter-evidence stations. |
| Architecture and diagnosis | 02, 07 | Formal-readonly for intent, counter-evidence, architecture, impact, and root-cause evidence. Route to build, fix, experiment, or audit when writes or broader evidence are needed. |
| Change production | 03-1, 03, 04, 12 | Formal-write only after scoped GO. Implementation produces a change delivery artifact, then validation, review, memory/docs, and completion run in later eligible waves. |
| Validation and audit | 06, 08, 08-1, 08-2, 08-3, 10 | Read-only validation/audit stations do not repair core code. Failed validation routes back to fix, debug, build, or audit; audit report follows inventory and logic evidence. |
| Knowledge and closeout | 05, 09, 11 | Source memory/docs, commit prep, and handoff use evidence and completion stations. Commit, push, release, deployment, and memory commit remain separate protected phases. |

## Transition Rules

| From | To | Required condition | Forbidden shortcut |
|---|---|---|---|
| 00 chat | 01, 02, or formal-readonly | Files, memory/context, rules, tool output, agent behavior, screenshots, or governance evidence are needed. | Do not stay direct while performing broad file reads or evidence work. |
| 01 explore | 02, 03-1, or 08 | Evidence is current enough to shape architecture, experiment, or audit. | Do not start build from insufficient evidence. |
| 02 blueprint | 03, 03-1, 08, or 11 | Handoff contract, assumptions, acceptance evidence, and write boundary are clear. | Do not treat architecture output as write authorization. |
| 03-1 experiment | 03 or 11 | Prototype is promoted or discarded with clear scope. | Do not commit or claim production quality for disposable prototype work. |
| 07 debug | 04 or 08 | Root cause is found, or broader audit is needed. | Debug stations do not patch core code. |
| 03 or 04 | 06, review, memory/docs, 09 | Change delivery exists or is honestly marked blocked/unverified/closed-with-director-risk. | Do not validate, review, or commit before change delivery state exists. |
| 06 failed validation | 04, 07, or 03 | Failure maps to repair, diagnosis, or missing implementation. | Validation stations do not repair the implementation they validate. |
| 08 | 08-1, 08-2, 08-3, 03, 04, 09 | Inventory, logic review, and report evidence are ordered. | Do not issue audit report before inventory and logic evidence. |
| 10 routine | 08, 04, 02, or 12 | Anomaly, drift, or rule gap is found. | Routine inspection does not write fixes. |
| 09 commit | 03, 04, 05, 06, 08, or 11 | Preflight finds source, memory, validation, audit, or handoff gaps. | Commit flow does not hide blockers or complete unfinished work. |

## Invalid Orchestration Patterns

These patterns must be treated as Red, blocked, unverified, or
closed-with-director-risk, not as complete:

- Draft board dispatches or spawns a formal specialist.
- Draft evidence counts as formal acceptance evidence.
- No-write or read-only work is described as no-team, without-team, or skip-team.
- Post-board all-at-once dispatch starts all stations at once.
- Standby is treated as returned evidence, validation, review, or completion.
- Closed-with-director-risk is not full team completion and must not be
  reported as `complete`.
- Review or validation starts before the relevant change delivery artifact state.
- Same-wave implementation and same-deliverable review are allowed.
- The captain authors specialist implementation, validation, review, or memory attribution and then claims complete.
- A captain deep read of large files replaces specialist deep-read without direct exception and residual state.
- Implementation falls back to routine captain direct work without isolated change delivery, text change delivery artifact, or Director risk closure.

## Entry Minimum Reference

Workflow entries should keep a short reference block only:

1. Read the deployed workflow orchestration contract.
2. Use the scenario playbooks only as non-authorizing examples when a concrete
   flow is needed.
3. Read the matching workflow evidence matrix row.
4. Apply the platform capability matrix.
5. Build or promote the Captain Team Board before broad evidence, change
   delivery, validation, review, memory/docs, or completion work.
6. Route missing stations, handoff packets, channel states, or delivery
   artifacts to blocked, unverified, standby, or closed-with-director-risk.

The detailed board field list stays in `team-task-board`, detailed trace fields
stay in `team-trace-evidence`, and platform execution channel rules stay in
`subagent-invocation`.
