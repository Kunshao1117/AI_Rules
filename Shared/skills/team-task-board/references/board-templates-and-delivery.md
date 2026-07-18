# Board Templates And Delivery Forms

This reference holds task-board templates, assignment details, delivery forms,
dispatch rules, direct exceptions, and the closeout checklist for
`team-task-board/SKILL.md`.

## Board Header Template

```text
Board template:
Board state:
Task type:
Workflow route:
Operation mode:
Implementation authorization:
Authorization scope:
Phase:
Dispatch wave:
Parallel dispatch contract:
Allowed specialist roles:
Forbidden specialist roles:
Direct exceptions:
External grounding:
Completion condition:
```

## Full Board Table

The full board table uses these columns:

- Station family
- Formal station
- Substation task
- Applicability
- Execution channel or delivery form
- Station state
- Evidence state
- Evidence owner
- External grounding
- Role boundary
- Direct exception record
- Completion condition

Default station families are requirement replay, counter-evidence, impact map,
plan authorization, implementation, memory/docs delivery, validation, review,
and completion. Omit a family only by marking it not-applicable, blocked,
unverified, or closed-with-director-risk with a reason.

Valid execution channels or delivery forms are:

- `read-only evidence branch`
- `browser evidence branch`
- `CLI evidence branch`
- `MCP read branch`
- `external research evidence branch`
- `station-owned main-worktree change delivery`
- `isolated change delivery`
- `text change delivery artifact`
- `station-owned authorized change-application gate`
- `platform-nondelegable protected-action record`

State values such as `blocked`, `unverified`, `standby`, `unavailable`,
`not-authorized`, `not-applicable`, and `closed-with-director-risk` are not
execution channels.

## Specialist Assignment Template

Use one assignment per substation task:

```text
Station family:
Formal station:
Station mode:
Context visibility:
Handoff ownership:
Substation task:
Member assignment:
Role:
Role ID:
Role instance ID:
Exclusive task scope:
One concrete task:
Allowed inputs:
External grounding required:
External research question:
External research artifact:
External grounding state:
Source tier:
Source date or version:
Missing external evidence:
Allowed tools:
Forbidden actions:
Output artifact format:
Stop condition:
Channel run ID:
Channel generation:
Status probe state:
Status probe resume state:
Late result policy:
Parallel dispatch contract ref:
```

The station handoff packet may add read scope, startup monitoring,
dependencies, and channel state. Do not copy the whole board field list into the
packet.

Before dispatch, pair this assignment with a startup-complete handoff packet
containing `handoff_packet_id`, `role_id`, `role_instance_id`,
`station_mode`, `context_visibility`, `handoff_ownership`,
`assigned_specialist_skill`, `read_scope`, `allowed_tools`,
`forbidden_actions`, channel state, `delivery_artifact_type`, and
`stop_condition`. Missing startup data keeps the station blocked or unverified.
When a station may depend on fresh outside evidence, also record
`external_grounding_required`, `external_research_question`,
`external_research_artifact_id`, `external_grounding_state`, `source_tier`,
`source_date_or_version`, and `missing_external_evidence`.

Same-wave candidates carry the complete canonical
`parallel_dispatch_contract` from `board-field-catalog.md` through the station
handoff packet. This template references that object only; it does not copy its
nested schema or decide eligibility.

## Delivery Forms

Implementation work uses one of these forms:

`Main-worktree change delivery`
: Meaning: A formal `station_mode: change-delivery` station directly edits main-worktree source
  under `formal-write` authorization.
: Boundary: Requires authorization phase `implementation-change-delivery`, exact file allowlist,
  dirty diff read, `handoff_ownership: station-owned`, and `captain_authored: false`; no
  self-review, memory mutation, git, release, deploy, install, or external mutation. If the platform
  can only return a fork or text artifact, mark it `fork-only` or `text-only` and do not claim a
  station-authored main-worktree write.

`Isolated change delivery`
: Meaning: Specialist modifies an isolated copy and returns diff/evidence.
: Boundary: No main worktree write, self-review, memory mutation, git, release, deploy, install, or
  external mutation.

`Text change delivery artifact`
: Meaning: Specialist returns proposed edits with paths, rationale, evidence, risk, and memory
  impact.
: Boundary: Do not claim the artifact has been applied or accepted by review.

`Authorized change-application gate`
: Meaning: A formal `station_mode: change-application` station applies a returned isolated/text
  artifact, explicit integration task, or assigned generated/deployed copy sync.
: Boundary: Requires `formal-write`, authorization phase `change-application`, exact file allowlist,
  dirty diff read, and `handoff_ownership: station-owned`; no self-review, memory mutation, git,
  release, deploy, install, or external mutation.

`Captain substitute-authoring risk record`
: Meaning: No qualified delivery route exists and the Director explicitly closes that risk.
: Boundary: Not change delivery and never full Team-Native completion.

`Git checkpoint receipt`
: Meaning: Intermediate stability receipt returned only by the separately
  authorized `git-checkpoint` station.
: Boundary: Uses the canonical receipt in `board-field-catalog.md`; it is not
  implementation, validation, review, memory/docs, sync, final commit,
  completion, push, or release evidence.

Board-facing artifact formats use canonical English keys and are for station
delivery only. Director-facing summaries must synthesize Traditional Chinese
meaning first through `Shared/policies/language-governance.md`; do not paste raw
artifacts into the Director-facing body.

Any station artifact may carry `external_grounding_required`,
`external_research_question`, `external_research_artifact_id`,
`external_grounding_state`, `source_tier`, `source_date_or_version`, and
`missing_external_evidence`. Non-research stations use those fields to request
or consume evidence. Only an `external-research` station returns the
source-tiered evidence packet. If a role-specific external-research artifact
uses `external_grounding_artifact_id`, the returned artifact must map it to the
canonical `external_research_artifact_id`.

Implementation and authorized change-application artifacts return a post-change
handoff bundle for captain ledgering and next-wave routing. The bundle uses the
canonical implementation artifact fields below and the full authorization
metadata from `team-change-delivery-artifact` when that skill owns the station.
It includes `delivery_artifact_id`, `source_input`, `memory_impact`,
`source_deployed_pair`, `sync_direction`, `sync_evidence`,
`validation_handoff`, `review_handoff`, `memory_docs_handoff`, and
`next_wave_start_condition`. The implementer supplies these downstream handoff
fields only; implementers do not fill final `validation_state`, `review_state`,
or `memory_docs_state`.

```text
artifact_type: evidence_delivery
findings:
evidence:
risk:
recommendation:
blocking:
status:
```

```text
artifact_type: implementation_change_delivery
delivery_artifact_id:
source_input:
changes:
files:
evidence:
risk:
memory_impact:
source_deployed_pair:
sync_direction:
sync_evidence:
validation_handoff:
review_handoff:
memory_docs_handoff:
next_wave_start_condition:
review_need:
captain_authored:
recommendation:
blocking:
status:
```

```text
artifact_type: memory_docs_delivery
memory_impact:
status: memory_delivery / blocked / unverified / closed-with-director-risk
memory_delivery:
evidence:
risk:
recommendation:
blocking:
```

Detailed validation, review, memory/docs, and completion artifact rules stay in
their dedicated skills.

## Dispatch Rules

Open only the current dispatch wave. Later waves wait for prior output or an
honest blocked/unverified/risk state. Review and validation of a change start
only after change delivery exists or is explicitly blocked/unverified/risk
closed. Completion starts after implementation, memory/docs, validation, and
review states exist.

Same-wave dispatch follows only `Shared/policies/workflow-orchestration.md`.
The board stores the canonical `parallel_dispatch_contract`; different write
files alone do not make a station eligible. Actual dispatch checks stay in
`delegation-strategy/references/team-dispatch-gates.md`.

When a station needs current external facts, it records
`external_grounding_required: true`, `external_grounding_state: requested`,
and `external_research_question` with the exact question and local anchor.
The next eligible wave routes that request to a formal `external-research`
station. The captain logs and routes the request but does not perform temporary
research as captain-owned evidence.

Large-file deep read routes to a bounded specialist station. The captain must
not absorb, substitute, or deep read large files as the team evidence source;
when no route exists, record blocked or unverified with the smallest unblock
condition.

`formal-readonly` stations can open without write authorization when they are
strictly read-only and have a handoff packet. `formal-write` stations require
scope-bound authorization for the implementation change delivery, change
application, memory, git, release, deployment, install, or external-mutation
phase.

Main-worktree implementation in active Team mode defaults to a named,
station-owned main-worktree `change-delivery` station with authorization phase
`implementation-change-delivery`. Change application is a fallback
station-owned gate for returned isolated/text artifacts, explicit integration
tasks, or assigned generated/deployed-copy sync. Route either path to a
platform-nondelegable protected-action record only when the platform cannot
delegate the physical write or protected tool call; the board must record the
platform limitation, exact scope, source artifact, direct exception, and
residual state.
Captain coordination must not call `apply_patch` or any other write tool and
present the result as change-delivery evidence.

Status probes separate monitoring from failure. Timeout opens probe or standby;
the probed member pauses, reports position/blocker/safe-to-continue, and stays
`awaiting-resume` until `status_probe_resume_state` plus
`status_probe_resume_sent_at` are recorded. Replacement needs generation,
reason, cancellation state, late-result policy, and neutral ledger decisions.

## Direct Exception Register

A direct exception is allowed only for platform-nondelegable protected-action
records, tool-only status actions, hot-path status checks with no independent
evidence value, blocker/conflict/permission routing, or Director risk-closed
captain substitute authoring recorded as non-complete risk. `direct` is not a
station state, execution route, execution channel, platform route, or execution
mode. Record it only in `direct_exception` / `direct_exceptions` with a
station-specific reason, replacement evidence, and residual state.

If two or more evidence-oriented stations use direct exceptions, each row must
name a station-specific reason, replacement evidence, residual state, and why
full Team-Native completion is not being claimed.

## Board Closeout Checklist

Before the board supports any completion claim, check:

- Scope matches the approved file set and exclusions.
- Authorization fields are present for every write/protected phase.
- Applicable formal stations include `station_mode`, `context_visibility`, and
  `handoff_ownership`; missing fields block `complete`.
- Implementation change delivery, memory/docs delivery, validation, and review
  states are present or honestly blocked/unverified/risk closed.
- Implementation and review are not owned by the same role instance.
- Captain ledgering or status synthesis did not become substitute implementation,
  validation, review, or memory/docs attribution.
- Any review or validation of a change inspects the actual main-worktree diff,
  or explicitly states that a `fork-only` or `text-only` artifact is not
  applied.
- Board-facing artifact formats were not pasted verbatim into Director-facing
  output; captain summaries follow `Shared/policies/language-governance.md`.
- Opened channels have probe/resume, replacement, cancellation, late-result,
  and neutral ledger evidence when those lifecycle states apply.
- Any `git_checkpoint_receipt` remains intermediate evidence and is not counted
  as final commit, completion, push, or release readiness.
- No running, unknown, unresponsive, late-result-pending, or
  cancellation-pending channel is hidden behind a `complete` claim.
- Route fields contain routes/channels/forms, while
  blocked/unverified/standby and closed-with-director-risk remain state values.
- Source/deployed pairs have sync direction and parity evidence when
  applicable.
- Completion state follows `team-completion-gate` and trace evidence follows
  `Shared/policies/team-trace-evidence.md`.
