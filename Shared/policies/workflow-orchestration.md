# Workflow Orchestration Contract

This policy is the shared workflow orchestration layer for AI_Rules.

It defines how workflow entries start, hand off, wait, route back, and close.
The supported platforms are Codex, Claude, and Antigravity.

It does not replace Team-Native Core, the workflow evidence matrix, platform adapters, or team task boards.
It also does not replace specialist role skills or authorization policy.

## Source-Of-Truth Chain

Use this contract as the thin sequence layer between workflow routing and Team-Native station execution.

Layer ownership, in order:

### `Shared/policies/team-native-core.md`

- Owns: Highest-priority Team-Native gate, operation mode, station-first rule, and completion boundary.

### `Shared/policies/authorization-resolution.md`

- Owns: Scope-bound authorization fields and phase-specific write gates.

### `Shared/policies/language-governance.md`

- Owns: Audience-layer language classification, Director-facing language rules, and exact-evidence preservation.
- Also owns source/deployed language-policy parity.

### `Shared/policies/grounding-governance.md`

- Owns: External grounding gate for source type, freshness sensitivity, and no-evidence claim boundaries.

### `Shared/policies/source-document-size-governance.md`

- Owns: Source-document size/split categories, PowerShell module size signals, audit rule-pack placement, and size/split reporting contract.

### `Shared/policies/workflow-orchestration.md`

- Owns: Workflow entry sequence, transition rules, dispatch waves, and missing-evidence routing.

### `Shared/policies/workflow-orchestration-scenarios.md`

- Owns: Non-authorizing scenario playbooks.
- Those playbooks show how workflows cooperate without copying rules into entries.

### `Shared/policies/platform-plan-mapping.md`

- Owns: Platform plan-surface mapping.
- Owns `plan-only` versus `build-plan`, plus `update_plan` visual-mirror boundaries.

### Workflow execution spec pair

- Source: `Shared/policies/references/workflow-execution-spec-contract.md`.
- Deployed: `.agents/shared/policies/references/workflow-execution-spec-contract.md`.
- Owns machine-readable `execution_spec` minimum and human flowchart boundary.
- Also owns station external-grounding fields and external-research request contract.

### Central reference catalog

- `Shared/policies/references/status-ontology.md` owns shared status meanings.
- `Shared/policies/references/completion-state-machine.md` owns closeout targets,
  completion states, and complete/non-complete mutual exclusion.
- `Shared/policies/references/authorization-phase-registry.md` owns
  authorization phase values.
- `Shared/policies/references/protected-action-registry.md` owns protected
  action categories and required gates.
- `Shared/policies/references/hook-event-matrix.md` owns repo-managed hook
  event support and disabled/source-active/runtime lifecycle.
- `Shared/policies/references/exception-registry.md` owns direct and
  platform-nondelegable exception records.
- `Shared/policies/references/platform-copy-map.md` owns source/runtime,
  generated, vendor, and cache copy roles.

### Workflow orchestration boundaries pair

- Source: `Shared/policies/references/workflow-orchestration-boundaries.md`.
- Deployed: `.agents/shared/policies/references/workflow-orchestration-boundaries.md`.
- Owns invalid orchestration patterns and the entry minimum reference list outside the main sequence file.

### `Shared/skill-governance.md`

- Owns governance layer placement, skill boundaries, deduplication defenses, and source/deployed skill governance.

### `Shared/workflow-capability-evidence-matrix.md`

- Owns per-workflow route, evidence expectations, and next workflow suggestions.

### `Shared/platform-capability-matrix.md`

- Owns platform capability translation for Codex, Claude, and Antigravity.

### `Shared/skills/team-task-board/SKILL.md`

- Owns board templates, station fields, delivery artifact formats, direct exceptions, and completion checklist.

### `Shared/policies/team-trace-evidence.md`

- Owns task trace evidence fields and invalid runtime trace patterns.

Workflow entries must reference this chain instead of copying the full chain into every entry.

If two shared sources conflict, Team-Native Core and Authorization Resolution win before this orchestration contract.

Scenario playbooks live in `Shared/policies/workflow-orchestration-scenarios.md`.

They are non-authorizing examples only.

They show concrete cooperation flows, but do not grant authorization, create new completion states, or override this contract.

## Entry Sequence

Canonical stage order:

```text
workflow route
-> authorization resolution
-> operation_mode
-> board_template and board_state
-> station set, dispatch wave, and handoff packet
-> delivery artifact or terminal station state
-> validation and review
-> memory/docs attribution
-> closeout target and completion judgment
```

When Team mode is active, every workflow entry follows this team sequence before these actions:

- Broad reading, fix, build, validation, review, or implementation.
- Memory/docs attribution, commit preparation, release preparation, or completion claims.

```text
Director instruction
-> dormant Team readiness injection when present, as no-write route context only
-> workflow route
   including platform plan mapping when a platform plan surface, `plan-only`, or `build-plan` affects routing
   including Director-facing output gate when producing Director-visible text, governed by language-governance
   including external grounding gate when external facts, sources, or freshness affect formal evidence
-> authorization resolution
-> machine-readable `execution_spec` gate
   when station or tool execution depends on workflow instructions
-> existing worktree change integration gate when the target file is dirty
-> source-document size/split impact gate
   when source-bearing documents, scripts, modules, skills, policies, or rule packs are written or grown
-> operation_mode
-> board_template
-> board_state
-> station set
-> dispatch wave
-> station handoff packet
-> station mode, context visibility, and handoff ownership recorded
-> captain boundary pre-action guard before any captain broad or evidence-producing tool action
-> channel capability and channel invocation status
-> first response and lifecycle event policy recorded when applicable
   status probe pause, captain resume, timeout, replacement, cancellation, late result
-> hook event lifecycle check when repo-managed hooks provide route context
-> returned delivery artifact or blocked/unverified/standby state
-> captain receipt, board update, blocker/conflict/authorization handling
-> validation, review, drift/sync evidence
-> memory/docs disposition after validation and review reach terminal evidence states
-> protected-memory-write when `closeout_target` requires process-complete or release-ready
   and memory is required
-> protected-memory-commit after protected-memory-write when required memory mutation must be
   committed
-> completion audit
```

Workflow route is not authorization.

A route signal can route the work.
It cannot grant unbounded write authority or protected follow-on authority.

Route signals include:

- Workflow names.
- Slash commands.
- Codex skill triggers.
- Antigravity workflow buttons.
- Claude commands.
- Platform mode.
- Approval prompts.
- Available channels.

Dormant readiness injection and captain boundary pre-action guard output are also non-authorizing route context.

They can prime no-write Team readiness, identify missing trace fields, or mark would-block boundary risk.

They cannot create Team mode without a current governed Director request.
They cannot replace scope-bound authorization or stop execution by themselves.

Route-or-state principle:

After the Director's visible request or agreement has selected the current route, the workflow should take one of these actions:

- Proceed in the matching no-write route.
- Dispatch the scoped station.
- Report `blocked`, `unverified`, `standby`, or `closed-with-director-risk`.

Do not re-ask the Director for GO only because internal board, handoff, or channel labels need recording.

Ask the Director only when continuing would expand scope, cost, external tool or state access, protected action exposure, or residual risk.
Do not mechanically interrupt after a fixed number of modules, batches, or files when the visible route and scope are unchanged.

Platform-visible plan surfaces are governed by `Shared/policies/platform-plan-mapping.md`.

Codex `update_plan`, checklists, and planning UI are visual progress mirrors only.

They can reflect `plan-only`, `build-plan`, implementation, validation, review, memory/docs, or completion steps.

They do not create authorization, delivery artifacts, validation/review evidence, or memory/docs evidence.
They also do not create source/deployed parity evidence or completion state.

After routing and before accepting formal evidence or making completion claims, the workflow applies two thin gates by reference only.

Director-facing text uses the output gate in `language-governance`.

External claims, outside sources, and freshness-sensitive facts use the grounding gate in `grounding-governance`.

This orchestration contract only records gate placement and does not copy the verification procedure from either policy.

Flowcharts, diagrams, checklists, and visual plan mirrors are human navigation only.

They can point to the route.
They cannot act as AI execution specs, authorization, station handoff, validation evidence, review evidence, or completion evidence.

Executable station or tool work uses the machine-readable `execution_spec` minimum in the paired reference files:

- `source: Shared/policies/references/workflow-execution-spec-contract.md`
- `deployed: .agents/shared/policies/references/workflow-execution-spec-contract.md`

If executable work depends on a flowchart without a resolved `execution_spec`, the affected work is `unverified` or `blocked`.
The same rule applies when the station handoff packet is missing.

Team-Native / subagent team mode activates when the current Director request asks for governed work in any of these areas:

- Governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, or handoff.
- Source, public-contract, or equivalent source/governance/evidence-bearing work.

Requests for a team, team member, subagent, delegation, Team-Native, or equivalent dispatch also activate Team mode.

Workflow names and skill names are route signals, not fixed passwords.
If the request itself is governed work, Team mode is triggered by that user request.

Workflow names, source impact, platform mode, approval prompts, or available channels do not activate Team mode by themselves.
They require a current governed Director request.

They also do not authorize writes or protected actions.

When Team mode is not active, captain/team-board limits do not apply.

Normal lifecycle, scoped authorization, protected-action gates, read-before-write, and source/deployed sync rules still apply.

Pure conversation, small stable answers, and no-impact read-only work remain outside Team mode only when they have no relevant impact.

Relevant impact includes source, workflow, validation, review, memory, release, governance, or evidence impact.

After Team mode is active, the workflow route must create or promote the board-first path before these actions:

- Governance, workflow, fix, build, or broad evidence.
- Change delivery, validation, review, memory/docs, protected action, or completion work.

Missing specialist channel capability becomes standby, blocked, unverified, unavailable, or closed-with-director-risk station state.

It does not downgrade active Team mode to captain-direct execution.

Director-facing workflow status describes the plain-language route, evidence state, residual risk, and next action.

Raw board, handoff, channel, lifecycle, and authorization fields stay internal unless cited as an evidence appendix.

In active Team mode, small read-only probes are permitted before the formal board only for narrow purposes.
They are allowed when needed to identify the route or locate explicitly named files.

They must stay narrow, non-mutating, and non-evidence-producing.

Allowed probes are named-file status, named-file diff, named-file hash, or a search constrained to explicitly named files.

Small probes explicitly exclude:

- Repository-wide grep.
- `git grep` or `rg` against the repository root.
- Recursive `Get-Content`.
- Recursive `Get-ChildItem` used as a file inventory.
- `rg --files`, `git ls-files`, and whole-repository file lists.
- Validation, review, implementation, memory/docs attribution, and completion claims.

In active Team mode, these actions require the formal sequence above:

- Broad reads, recursive scans, and repository-wide grep.
- Validation, review, implementation, memory/docs attribution, and completion claims.

The sequence must run before a station-owned broad-read or evidence station starts.
It must also run before the captain may ledger returned evidence.

Do not treat early broad context as evidence before that trace exists.
This applies to hooks, dormant readiness injection, pre-action guards, and platform-supplied context.

Treat it as non-authorizing route context.

It stays non-authorizing until a specialist station returns evidence or the board records a direct exception with residual state.

That context cannot be promoted into validation, review, memory/docs, completion, or station-owned evidence.

## Board-State Boundary

Board states exist only after Team mode is active.

This sequence layer uses `draft`, `formal-readonly`, and `formal-write` as route states.

It leaves board fields, station rows, direct exceptions, and trace details to the dedicated board and trace sources:

- `Shared/skills/team-task-board/SKILL.md`
- `Shared/policies/team-trace-evidence.md`

`formal-readonly` can gather evidence.
It cannot write source, memory, git, release, deployment, install, or external state.

It does not require repeated GO when the no-write route is already visible.

`formal-write` is a scope-bound one-work-agreement.
It applies to the resolved phase, file set, station, expiry, and protected gates.

It never carries into protected follow-on phases.

## Operation Mode

This contract records where `operation_mode` is selected.

The daily/full eligibility rules stay in `Shared/policies/team-native-core.md`.

Workflow rows and station artifacts record only the chosen mode, reason, and evidence state.

## Dispatch Waves

Formal orchestration is wave-gated:

1. Open only the current dispatch wave.
2. Record previous-wave input before starting the next wave.
3. Record the next-wave start condition before the next wave is eligible.
4. Mark formal evidence eligibility for every station.
5. Do not perform post-board all-at-once dispatch.

Review and validation that judge a change wait for the implementation change delivery artifact.

That artifact must be returned, blocked, unverified, or closed-with-director-risk.

Implementation and review of the same deliverable do not run in the same wave.

Memory/docs that attributes source, workflow, skill, governance, or durable documentation impact
waits for validation and review to reach terminal evidence states. The implementation artifact may
include a `memory_impact` hint and `memory_docs_handoff`, but the memory/docs station consumes the
validated and reviewed artifact chain rather than pre-validating unfinished work. When that
disposition says memory is required, the closeout branch either records protected follow-up pending
for `source-level` or routes built-in `protected-memory-write` and `protected-memory-commit`
phases for `process-complete` and `release-ready`.

## Workflow Loop Contract

Workflow execution is a bounded control loop:

```text
Director request
-> workflow route
-> machine-readable execution_spec
-> station handoff packet
-> station work
-> minimal_reference_packet or delivery artifact
-> captain drift_check
-> transition_decision
-> next wave, retry, reroute, blocked, unverified, or risk closure
```

The canonical loop fields and transition values live in
`Shared/policies/references/workflow-execution-spec-contract.md`. This policy owns only the
sequence, where `transition_decision` is recorded, and where the resulting next wave, retry,
reroute, blocked, unverified, no-evidence, conflicted, or Director-risk state is consumed.

After two normal retries for the same symptom family, file region, operator path, or decision
surface, the loop must change route to root-cause, architecture, scope-impact, external-research,
blocked, unverified, or Director risk closure.

The captain receives minimal reference packets and delivery artifacts, records a neutral ledger
decision, and synthesizes Director-facing status. The captain must not fill missing station-owned
evidence with broad search or promote missing research, validation, review, or memory/docs
evidence to verified status.

## Closeout Targets

Workflow closeout must name the target being judged.

The canonical `closeout_target` values and transition catalog live in
`Shared/policies/references/completion-state-machine.md`. The executable field
shape lives in `Shared/policies/references/workflow-execution-spec-contract.md`.

Target meanings, aliases, and transition values are not repeated here; use
`Shared/policies/references/completion-state-machine.md`.
This policy only places the closeout decision after source delivery, validation, review,
memory/docs attribution, and any required protected follow-up phases.

Do not collapse the closeout layers:

- Source or document delivery means the applied source/document layer has change delivery, validation, review, and sync/parity evidence for that layer.
- Process evidence complete means the governed artifact chain has also resolved memory/docs disposition, lifecycle closure, and completion audit.
- Commit or release readiness means the process is complete and the additional protected git, release, deployment, install, credential, or external-mutation gates are either satisfied or explicitly out of scope.

Director-facing status should say which target is closed and which protected follow-up remains.

Do not expose the distinction as raw board jargon.

Do not repeatedly ask for internal phase words when the only honest next state is protected follow-up pending.

## Station Handoff And Channel State

Every formal station needs a handoff packet before it can produce formal evidence.

This policy records the handoff point in the sequence.

Packet fields and channel lifecycle details stay in the sources below.
The same is true for status probe, replacement, cancellation, late-result, and receipt-decision details.

- `team-station-handoff-packet`
- `team-task-board`
- `Shared/policies/team-trace-evidence.md`

Minimal lifecycle anchors stay thin here.

The trace tokens are:

- Draft board.
- `status_probe_resume_state`.
- `cancellation_state`.
- `late_result_policy`.
- `receipt_decision`.

Detailed value catalogs stay in the board, handoff, and trace sources above.

Missing channel capability is recorded as station or evidence state.
It does not erase the station, become an execution route, or support completion.

## Workflow Preset And Transition Reference

Workflow family presets and transition conditions live in the paired boundaries files:

- `source: Shared/policies/references/workflow-orchestration-boundaries.md`
- `deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`

The main orchestration policy keeps only the sequence.
It points workflow-specific evidence back to `Shared/workflow-capability-evidence-matrix.md`.

## Source Document Size/Split Rule

When a workflow creates or modifies core, shared policy/reference, `SKILL.md`,
memory card, PowerShell script/module, audit rule pack, or general source files,
it cites `Shared/policies/source-document-size-governance.md` and records
size/split impact in the relevant delivery, review, validation, audit, build, or
fix artifact.

Size alone is a signal.
Split work is required only when the policy's responsibility, public-interface,
or test-isolation signals are present.

Existing oversized source documents or modules may be baselined during an
initial governance batch.
That baseline is not a completion claim and does not authorize follow-on
refactor work.

## Source/Deployed Sync Rule

Framework source files are the source of truth. Deployed project copies are runtime copies.

Copy roles and sync direction values are governed by
`Shared/policies/references/platform-copy-map.md`.

Governance, workflow, skill, shared policy, generated-copy, public-contract, and hook changes must record sync evidence.

Required fields are `source_deployed_pair`, `sync_direction`, and `sync_evidence`.

This applies when a runtime copy exists.

The normal direction is source first, then deployed copy.

If a deployed copy is patched first during emergency repair, record `sync_direction: deployed-to-source-backfill`.

Backfill the source before completion.

Hash or content parity is required before any completion claim.
Missing parity is Red, blocked, or unverified, not a Yellow advisory.

Changing only a deployed copy is invalid completion for framework governance.

When the current wave is intentionally source-only, the report must name the deployed pair.

It must record the sync strategy as pending, blocked, unverified, or not-applicable.

A later deploy/sync wave must compare content or hashes rather than relying on narrative claims.

## Invalid Orchestration Patterns

Invalid patterns are maintained in the paired boundaries files:

- `source: Shared/policies/references/workflow-orchestration-boundaries.md`
- `deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`

They remain Red, blocked, unverified, or closed-with-director-risk patterns.

They are not `complete` or full Team-Native completion.

Shared status meanings and the `complete` versus non-complete boundary come
from `Shared/policies/references/status-ontology.md` and
`Shared/policies/references/completion-state-machine.md`.

This main contract only keeps their reference.
That avoids repeating the long list in multiple workflow documents.

## Entry Minimum Reference

Workflow entries keep a short reference block only.
They must not copy board, trace, platform channel, scenario, or completion catalogs into the entry.

The complete entry minimum list is in the paired boundaries files:

- `source: Shared/policies/references/workflow-orchestration-boundaries.md`
- `deployed: .agents/shared/policies/references/workflow-orchestration-boundaries.md`
