# Workflow Team Evidence Reference

This reference holds Team-Native, board, change-delivery, and closeout evidence
details that are too large for
`Shared/workflow-capability-evidence-matrix.md`. The workflow matrix keeps
per-workflow rows; this file keeps the supporting team evidence tables.

Canonical sources remain authoritative:

| Need | Source |
|---|---|
| Team-Native activation, station-first rule, operation mode, and completion boundary | `Shared/policies/team-native-core.md` |
| Route order, authorization position, dispatch waves, and source/deployed sync | `Shared/policies/workflow-orchestration.md` |
| Scope-bound authorization and protected phases | `Shared/policies/authorization-resolution.md` |
| Board fields, station rows, delivery forms, and checklist | `Shared/skills/team-task-board/SKILL.md` |
| Trace fields and invalid trace patterns | `Shared/policies/team-trace-evidence.md` |
| Change delivery artifact rules | `Shared/skills/team-change-delivery-artifact/SKILL.md` |

## Team-Native Minimum

Team-Native Core is the collaboration model after the Director asks for
governed work. Programming, workflow, validation, review, memory, commit,
handoff, skill forge, source, and governance-impact requests trigger Team mode;
the Director does not need a fixed phrase. Requests for a team, team member,
subagent, delegation, or equivalent dispatch also trigger it.

Minimum evidence: Team mode active tasks need a Captain Team Board before broad
file reads, change delivery, validation, review, memory attribution, or
completion claims. Read-only evidence uses `formal-readonly`; resolved write
stations use `formal-write`. Applicable formal stations record `station_mode`,
`context_visibility`, and `handoff_ownership`. Missing channel, artifact, trace,
or lifecycle fields is `standby`, `blocked`, `unverified`, `unavailable`, or
`closed-with-director-risk`, not `complete`.

The captain translates Director requests into station tasks, dispatches,
coordinates channels, logs received station output into the synthesis ledger,
maintains board state, handles blockers and permission questions, and reports
to the Director. Formal checking, validation, review, authorization decisions,
protected gates, and memory/docs interpretation stay with their policies or
owner stations. Captain ledgering or summary does not fill a missing station
artifact.

## Operation Mode And Board States

Team-Native records execution depth before board template, board state,
closeout lane, or station set:

```text
operation_mode -> board_template -> board_state -> closeout_lane -> station set
```

`daily` is reduced Team-Native mode for routine checks, lightweight evidence,
low-risk documentation alignment, generated-copy checks, or bounded governance
drift. It still requires board, `operation_mode_reason`, role identity, handoff
packet, trace evidence, and explicit blocked/unverified states. It is not valid
for bottom-layer refactor, cross-file governance changes, specialist skill
rewrites, Doctor/Audit rule changes, commit/release/deploy preparation,
protected external-state readiness, or full-only completion claims.

`full` is required for implementation, repair, bottom-layer refactor,
cross-file governance, specialist skill rewrites, Doctor/Audit changes,
commit/release/deploy preparation, high-risk external-state work, or any
source/workflow/public-contract impact.

| Governed Team mode | Activation | Minimum evidence | Must not claim |
|---|---|---|---|
| `formal-readonly` | Team mode is active and no-write evidence, research, audit, review, validation planning, broad read, or counter-evidence applies | Formal station, read-only scope, evidence owner, citations, missing evidence list, captain synthesis-ledger entry, and board update | Source/memory/git/release/deploy/install/external mutation, or read summary as write authorization |
| `formal-write` | Team mode is active and source, docs, workflow, deployed copy, generated copy, or skill content needs writing | Resolved scope, authorization state, exact file/station scope, station-owned main-worktree change delivery or fallback station-owned change application, `memory_impact`, and later review/validation route | Auto-upgrade from workflow name, draft board, standby station, read-only evidence, or one bare `GO` |
| `standby` station | A later wave may need the role but prior input is not returned | Role, trigger condition, allowed scope, and non-execution state | Evidence, validation, review, or completion |
| `deep-read` / `verify-read` | Large files, long reports, external docs, or evidence volume make captain-only reading unreliable | Specialist deep-read artifact, cited locations, summary limits, captain synthesis-ledger entry, and board update | Captain absorbing, substituting, or claiming full-file read evidence |
| `captain context freeze` | Specialist work is in progress | Captain maintains board, unblocks, receives artifacts, handles conflicts, or resolves authorization | Parallel reads, duplicate scans, substitute validation/review, memory/docs interpretation, or rewriting member results |

## Programming Team Governance

Coding-related and governed requests trigger Team-Native Core because they are
Director requests for governed work. Workflow commands and skill names are route
hints, not write authorization and not fixed passwords. In active Team mode,
read-only stations use `formal-readonly`; write stations require
`formal-write` after scoped authorization resolution.

Required child delivery routes include `team-change-delivery-artifact`,
`team-memory-docs-delivery-artifact`, `team-review-delivery-artifact`,
`team-validation-delivery-artifact`, `team-role-boundaries`, and
`team-completion-gate`. Each formal row records assigned specialist skill,
channel capability, and channel invocation status before evidence is logged or
routed to the next owner station.

| Board state | Allowed use | Must not be used as | Required next step |
|---|---|---|---|
| Draft board | Pre-intent planning, candidate station map, proposed dispatch waves, assumptions | Formal specialist launch, formal evidence, validation evidence, review evidence, completion evidence | Promote to formal-readonly for no-write evidence or formal-write after scoped authorization resolution |
| Formal-readonly board | No-write team evidence, specialist standby, deep-read, external research, review evidence, validation planning | Source, memory, git, release, deployment, install, or external-state mutation | Record skill handoff packet, phase, wave, previous input, next condition, formal evidence eligibility, and channel state |
| Formal-write board | Resolved-scope station dispatch, implementation change delivery, authorized change application, validation, review, memory/docs, completion trace | Blanket all-at-once dispatch or unscoped protected actions | Record scoped authorization, phase, dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility for every applicable station |

Formal evidence eligibility requires a formal-readonly or formal-write board
station, current open wave, assigned evidence owner, valid delivery artifact
format, registered specialist role source, skill handoff packet, role boundary,
`station_mode`, `context_visibility`, and `handoff_ownership`.

## Delivery And Role Boundaries

Natural-language programming or governance tasks create a team task board when
the user has requested governed work. The workflow command only chooses the
route; it does not authorize skipping the board after activation, collapsing
roles, or claiming team completion without station evidence.

Implementation returns change delivery with `memory_impact`; memory/docs,
validation, review, and completion remain separate artifacts. A specialist may
not both implement and review the same deliverable. Missing independent role
separation is `closed-with-director-risk`, `unverified`, or `blocked`, never
`complete`.

In active Team mode, formal implementation is not a normal captain-direct
route. Main-worktree implementation is owned by a named `change-delivery`
station under `implementation-change-delivery`, exact file allowlist,
dirty-diff read, and forbidden protected actions. Isolated or text delivery is
used when the platform cannot directly write the main worktree. Change
application is a fallback station-owned gate for returned isolated/text
artifacts, explicit integration tasks, or assigned generated/deployed sync.

| Change delivery form | Evidence status | Use when | Completion impact |
|---|---|---|---|
| Station-owned main-worktree change delivery | Sufficient after exact file allowlist, dirty-diff read, `implementation-change-delivery` authorization, change ledger entry, and later validation/review are visible | The platform can delegate main-worktree implementation to a formal `change-delivery` station | The station writes source changes directly and returns a change delivery artifact or ledger entry; a platform-nondelegable protected-action record is used only when the platform cannot delegate the physical write or protected tool call. |
| Isolated workspace change delivery | Sufficient when file scope, isolation, changed files, memory impact, and validation are visible | A fork, sandbox, checkpoint, or worktree can safely contain implementation writes outside the main worktree | The station-owned authorized change-application gate applies the returned artifact only within scoped change-application authorization; later stations handle memory delivery, independent review, and validation delivery artifacts. |
| Text change delivery artifact | Partial until a station-owned authorized change-application gate applies it and a validation station verifies it | No safe isolated filesystem exists, but the task is bounded and diffable | The station-owned authorized change-application gate can apply only the precise returned artifact or return it for correction; captain rewrite or reimplementation is substitute authoring risk, not successful text delivery. |
| Station-owned change application | Sufficient after returned-artifact/application/sync input, dirty-diff read, exact file allowlist, change-application ledger entry, and later validation/review are visible | A returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync must be applied | The station applies only the fallback integration scope; a platform-nondelegable protected-action record is used only when the platform cannot delegate the physical write or protected tool call. |
| Captain substitute authoring risk record | `closed-with-director-risk` or unverified | No isolated or text change delivery can be packaged and captain must author after the Director risk-closes this exact case | Cannot claim full team completion. |

| Required delivery artifact | Owner boundary | Missing delivery artifact result |
|---|---|---|
| Implementation change delivery artifact | Implementation specialist; one concrete task only; no self-review; includes `memory_impact` | `blocked`, or `closed-with-director-risk` only when the Director risk-closes captain substitute authoring |
| Memory/docs delivery artifact | Memory/docs specialist owns attribution; platform-nondelegable protected-action records only handle scoped protected memory state or mutation after separate attribution exists, and do not produce memory/docs attribution evidence | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Review delivery artifact | Review specialist who did not author the change delivery | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Validation delivery artifact | Test/validation route that does not modify core implementation | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |
| Team-Native trace evidence | Board trace plus station artifacts; records authorization, role identity, channel state, lifecycle fields, artifact IDs, review/validation/memory-docs states, waves, exception records, and missing evidence state | `blocked`, `unverified`, or `closed-with-director-risk`; no full-team completion claim |

Formal team completion can be claimed only after the four delivery artifact
classes and required Team-Native trace evidence are present, independent, and
non-mutating. Missing evidence states are non-complete closures, not substitutes
for `complete`.

## Lifecycle And Closeout

Specialist channels may be retained only when the role boundary remains
unchanged. Retention is evidence, not convenience.

| Lifecycle state | Minimum evidence | Completion impact |
|---|---|---|
| `assigned` | Role, station, delivery artifact, wave, and channel request exist | May start when the wave is open |
| `standby` | Role and handoff are ready but the wave, prior input, channel warmup, or external unblock is pending | Non-terminal; prevents premature closure |
| `retained` | Same role and delivery artifact continue; conversation health is clear | Valid evidence when role boundary is preserved |
| `reused` | Same role performs bounded follow-up using prior artifact input | Valid only with source input and reuse count |
| `handoff-required` | Context is stale, over budget, or no longer self-contained | Blocks next wave until handoff summary exists |
| `replaced` | Handoff is insufficient or independent opinion is needed | New station must cite prior closure reason |
| `closed` | Delivery returned or role boundary would be crossed | Valid only with closure reason |
| `blocked` | No safe channel or role-separated route exists | Non-complete closure unless unblocked |

| Closeout lane | Minimum evidence | Escalates when |
|---|---|---|
| `light` | Scope/impact, change or sync delivery, validation, completion audit, Yellow classification when present | Source, workflow, governance, generated-copy, memory/docs, public-contract, release, deployment, or external-state impact is present |
| `standard` | Scope/impact, change delivery, memory/docs, validation, independent review, completion audit | Commit, tag, release, deployment, install, external mutation, or operator readiness is present |
| `release-grade` | Standard lane plus release completion and security/reliability evidence | Any required protected state action is blocked or unverified |

Yellow findings must be classified as `fix-this-cycle`,
`residual-accepted`, `deferred-follow-up`, `local-customization`, or
`informational`. A completion-relevant Yellow finding escalates to blocked,
unverified, or Red. After two repair attempts for the same symptom family, file
region, or operator path, route to root-cause repair, structural refactor,
blocked, unverified, or `closed-with-director-risk`.

## Task Type And Dispatch Pre-Gate Matrix

After Team mode is active, before any specialist branch starts, the captain must
record task type, workflow route, implementation authorization, allowed
specialist roles, and forbidden specialist roles. Workflow commands such as
`$02`, `$03`, `$04`, or `$09` are route hints only.

| Task type | Allowed specialists | Forbidden specialists | Minimum evidence |
|---|---|---|---|
| discussion | none | all coding specialists | no source/workflow/review impact stated |
| exploration | `formal-readonly` requirement, research, architecture, counter-evidence, review evidence | implementation and `formal-write` | research scope, source tier, non-write boundary, and deep-read/verify-read when evidence is large |
| blueprint | `formal-readonly` requirement, architecture, counter-evidence, impact, review | implementation and `formal-write` | decisions, alternatives, compatibility, build handoff, and standby write trigger when later implementation is expected |
| build-plan | `formal-readonly` requirement, architecture, impact, test strategy, review; standby implementation station | main-worktree implementation before resolved `formal-write` | intent boundary, acceptance matrix, validation route, and exact formal-write file scope |
| implementation | resolved `formal-write` station-owned main-worktree `change-delivery` under `implementation-change-delivery`; isolated/text delivery only as fallback; memory delivery, test, review, completion | self-review and ungated scope expansion | approved file scope, dirty-diff read, change delivery evidence, fallback artifact/application evidence when used, memory impact, and memory delivery status |
| fix-debug | `formal-readonly` impact/debug/test/review plus resolved `formal-write` repair delivery when fixing | self-review and uncontrolled writes | symptom, cause, regression route, and repair station authorization |
| validation-audit | `formal-readonly` test, review, completion, CLI/browser/MCP evidence | source mutation unless separately authorized as `formal-write` | command/browser/MCP evidence and blocked items |
| commit-release | `formal-readonly` memory delivery, review, completion evidence | git/release/memory mutation by specialists | dirty file list, review state, memory status, owner station or authorization path for protected actions, and platform-nondelegable protected-action record only when the platform cannot delegate the scoped gate; captain routing and synthesis only |
| handoff-skill | `formal-readonly` requirement, architecture, impact, review, completion; resolved `formal-write` only for approved skill/source changes | implementation until authorized | handoff scope, skill ownership, governance trace, and standby next-wave trigger |

## Captain Minimum Execution Contract

The captain keeps only coordination duties: Director communication, translating
requests into station tasks, task board maintenance, dispatch and handoff
coordination, channel coordination, neutral synthesis-ledger updates, status
synthesis, blocker and permission routing, and final Director-facing reporting.
The captain does not decide authorization, validate, review, produce
memory/docs attribution, decide quality disposition, execute protected actions
as station evidence, or produce completion evidence.

Platform-nondelegable protected-action records are coordination records only.
They do not produce memory/docs attribution, validation evidence, review
evidence, or completion evidence; when the formal memory/docs or validation
station is missing, the state remains `blocked`, `unverified`, or
`closed-with-director-risk` and cannot support `complete`.

Counter-evidence, impact map, memory delivery, testing, review, and completion
audit default away from the captain. All-direct evidence boards are invalid
unless every station carries its own exception and risk-closure or replacement
evidence.

Formal dispatch is wave-gated. Same-wave stations must be independent of each
other. Review and validation of a change must not start before the related
change delivery artifact exists or is explicitly recorded as blocked,
unverified, or `closed-with-director-risk`.

| Station | Applies to | Default station route / captain coordination | Minimum evidence | Not delegable |
|---|---|---|---|---|
| Requirement replay | 02, 03, 04, 08, 12, or unclear programming tasks | Captain coordination only for Director communication and requirement clarification; if recorded in trace, use `direct_exception` record only; conflict check may use `evidence branch` | Goal, non-goals, constraints, assumptions, success criteria | Final requirement boundary and Director communication |
| Counter-evidence | 02, 03, 04, 07, 08, 12 | `evidence branch` unless a station-specific `direct_exception` record is used | Wrong-assumption search, missing-risk list, kept or cleared concern | Final plan decision |
| Impact | 03, 04, 07, 08, 09, 12 | `evidence branch`, `CLI branch`, or `MCP read branch` | Files, memory cards, docs, sync paths, compatibility and regression surface | Scope approval and source writes |
| Plan authorization | 02, 03, 04, 09, 12 | Captain coordination only / `direct_exception` record only; authorization-resolution policy owns decision evidence | Review state, acceptance matrix, authorization boundary | Director communication and policy routing |
| Implementation | 03, 04, 12 and Antigravity execute stages | `station-owned main-worktree change delivery` under `implementation-change-delivery`; isolated/text delivery when main-worktree station delegation is unavailable; fallback `change-application` applies returned artifacts, explicit integration tasks, or assigned generated/deployed sync | Approved file list, security gate, dirty-tree protection, change delivery artifact or ledger entry, fallback change-application ledger entry when applicable | Specialists do not update memory, stage/commit/push, deploy, self-review, or write main worktree outside an authorized `change-delivery` or fallback `change-application` station |
| Memory delivery | 03, 04, 08, 09, 10, 11, 12 when source, workflow, governance, docs, generated copies, or public contract may change | `evidence branch` or `MCP read branch` for attribution; platform-nondelegable protected-action record only for scoped memory state or mutation after attribution exists, not as attribution evidence | `memory_impact`, `memory_delivery`, and blocked/unverified/closed-with-director-risk status | memory_commit, final memory write approval, source writes |
| Short-loop validation | 03, 04, 06, 07, 08 | `browser branch`, `CLI branch`, or `evidence branch`; hot-path `direct` exception can record non-evidence status only, not validation evidence | Test output, real-path attempt, blocked evidence path | Completion claim |
| Review | 02, 03, 04, 08, 09, 10, 12 | `evidence branch` unless direct exception | Review purpose, lifecycle state, review lifecycle risk decision, blockers, independence from implementation | Final review lifecycle status |
| Closeout | 03, 04, 09, 10, 11, 12 | `evidence branch` for drift/docs checks; platform-nondelegable protected-action record only for scoped memory/git/release mutation coordination, not missing station evidence | Docs, memory, drift audit, sync evidence, unresolved items, cross-check against test and review delivery artifacts | memory_commit, commit, push, release, deployment |

Missing station evidence, specialists, isolation, text delivery, Team-Native
trace, independent review, or memory delivery must be reported as unverified,
`closed-with-director-risk`, or blocked. Do not silently downgrade it or
describe it as full team completion.
