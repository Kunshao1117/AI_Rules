# Team-Native Core Policy

This file defines the AI_Rules Team-Native Core.
As an internal policy source, keep this body concise and English-led.
Director-facing reports, replies, confirmations, status summaries, handoffs, and completion summaries remain Traditional Chinese.
Use Chinese here only for exact Director-facing examples, established localized labels, or explicit task requirements.
Do not insert abrupt Traditional Chinese prose into the English policy body.

Team-Native / subagent team mode activates only from the current Director request for governed work or equivalent dispatch.
It is not AI default-on, a single subagent feature, a single workflow, or a single skill.

## Core Contract

Team-Native Core is the highest-priority governance spine after the current Director request asks for governed work.

Governed work includes governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, and handoff.
It also includes source, public-contract, or equivalent source/governance/evidence-bearing work.
Requests for a team, team member, subagent, delegation, or Team-Native also activate Team mode.

The Director does not need to use a fixed phrase such as "啟動團隊模式".
Workflow names, platform modes, approval UI, tool capability, prior conversation state, and source impact are not triggers by themselves.
A current governed Director request is still required.

Team mode can remain inactive when the Director request is pure conversation or a small stable answer.
It can also remain inactive for work with no source/governance/evidence effect.
In that case, captain/team-board limits do not apply and no Captain Team Board is required.
Normal lifecycle, scoped authorization, protected-action gates, read-before-write, security, and source/deployed sync rules still apply.
Non-team work must not claim Team-Native completion, separated station evidence, or team review.

When Team mode is active, the valid runtime state is board-first station assignment, not captain-direct execution.
A platform that lacks native subagents remains in Team-Native mode through adapters, evidence branches, or CLI/MCP/browser channels.
It can also use station-owned main-worktree change delivery, isolated/text change delivery, or explicit standby/block states.
Missing channel capability is a station state, not permission for captain-direct work.

When active, Team-Native Core is an execution precondition, not advisory prose.
The next valid runtime state is a Captain Team Board with applicable stations, handoff packets, and channel states.
The captain must not directly perform broad/deep reads, impact mapping,
source/governance/workflow/skill/policy/script/test/hook/fixture/support
automation implementation, validation, review, memory/docs attribution,
external research, completion audit or evidence, protected mutation, or external
mutation.
The captain must not perform commit preparation, release preparation, or completion claims first and only document the team route afterward.
Lane routing cannot use `tiny` or `light` until governed/guarded action
classification and these captain prohibitions have been evaluated.

Team activation may be silent in the Director experience.
Silent activation still depends on the current governed Director request; it is not AI default-on.
The captain should surface plain-language route, risk, and next action unless exact evidence is needed.
The captain should not expose internal board, handoff, channel, or authorization field mechanics as the primary explanation.

`formal-readonly` work does not need repeated Director GO when the route is already visible and no write or protected phase is added.
Writes use one scope-bound work agreement for the named phase, station, and file set.
Memory, git, release, deployment, install, credential, and external mutation phases remain separately authorized.

The shared workflow sequence is defined by `Shared/policies/workflow-orchestration.md`.
After a governed Director request activates Team mode, that Team-Native gate is authoritative.
Workflow orchestration defines the route -> authorization -> operation_mode -> board_state -> dispatch wave order.
It also defines the delivery artifact -> closeout order used by workflow entries and stations.

Human flowcharts, diagrams, and visual plan mirrors are navigation only.
They do not replace the machine-readable `execution_spec`, station handoff packet, authorization record, or trace fields.
Those fields remain required for AI/tool execution.
They also do not count as validation, review, memory/docs, or completion evidence.

The long `execution_spec` and external-grounding field contract lives in:

- Source: `Shared/policies/references/workflow-execution-spec-contract.md`.
- Deployed: `.agents/shared/policies/references/workflow-execution-spec-contract.md`.

Central reference catalogs live in `Shared/policies/references/` and are the
canonical value owners for shared terms:

- Status meanings: `status-ontology.md`.
- Completion targets and completion states: `completion-state-machine.md`.
- Authorization phases: `authorization-phase-registry.md`.
- Protected actions: `protected-action-registry.md`.
- Hook event lifecycle: `hook-event-matrix.md`.
- Exception records: `exception-registry.md`.
- Source/runtime/generated copy roles: `platform-copy-map.md`.

Parallel dispatch consumes the canonical `parallel_dispatch_contract` from the
board catalog; `Shared/policies/workflow-orchestration.md` alone owns
dependency, wave, and same-wave semantics. Cross-conversation continuation
uses `Shared/policies/references/cross-thread-handoff-contract.md`, with
platform transport kept in its adapter. Protected long-work local checkpoints
route only to `team-specialist-git-checkpoint`; the core does not copy either
schema or procedure.

## Core Boundary And Policy Placement Rule

Team-Native Core owns the governed team safety invariants after activation.
It covers board-first activation, role separation, captain thin-context limits, delivery artifact requirements, and authorization handoff.
It also covers non-complete states for missing evidence.
It must stay short enough to load as a core guard.

Long workflow recipes, board field catalogs, scenario examples, platform-specific adapter steps, and tool recipes belong outside this core.
Place them in shared policies, workflow matrices, team skills, or skill `references/` files.

When a rule is needed across workflows but is too detailed for the core, place the canonical contract in `Shared/policies/`.
Cite that contract from platform core or workflow entries.
When a rule is operational and only needed after a skill is loaded, place it in a shared skill or that skill's references.
When a fact is project-specific, place it in memory.
When a stable preference or design DNA is needed, place it in project context.
Core text must not grow by copying those layers back into always-on instructions.

Condensing Team-Native text is allowed only when executable defenses remain.
Required gates, forbidden shortcuts, evidence requirements, blocked/unverified states, and source/deployed sync obligations must survive.
Removing duplicate examples is good; deleting the guard that made a rule enforceable is not.

## Core Injection Hard Gate

After a governed Director request activates Team mode, core injection rules enforce the shortest Team-Native gate first.
No phase-owning skill, workflow, platform adapter, captain broad-work tool call, or evidence-producing read may soften that gate.
When Team mode is not active, these captain/team-board gates are not evaluated.

Once Team-Native Core applies, the following actions are forbidden until the required trace exists:

- broad file reading, repository-wide grep, recursive scans, and whole-repository file lists.
- validation, review, memory/docs attribution, completion audit, source writes, and completion claims.

The required trace must include:

- a Captain Team Board, applicable stations, and a station handoff packet.
- role identity through `role_id`, `role_instance_id`, and assigned specialist skill.
- channel state through `requested_execution_channel`, `channel_capability`, and `channel_invocation_status`.
- an explicit standby/block state when a channel state cannot be produced.
- lifecycle fields through `station_mode`, `context_visibility`, and `handoff_ownership`.

This gate applies before the captain runs tools for those actions.
Tool availability, fast local commands, workflow route names, and prior conversation context do not permit broad evidence gathering first.
The captain must not gather broad evidence first and document the board afterward.

Conversation-start and dormant Team readiness injection hooks are no-write readiness checks.
They are not active Team mode by default.
They may prime the Team-Native activation test, captain boundary, subagent opening prerequisites, and blocked/unverified vocabulary.
They do not authorize broad reads, source writes, validation, review, memory/docs, protected actions, or completion evidence.
They are not station-owned evidence, validation evidence, review evidence, memory/docs attribution, or completion proof.
The dormant hook becomes operative only when the current Director request is governed work.
It also becomes operative when the request explicitly asks for a team, subagent, delegation, Team-Native, or equivalent dispatch.

### Captain Minimum Entry / 隊長最小入口

Captain entry only routes activation, opens the first station path, and reports
missing evidence; it never performs station work or relaxes a later phase gate.
The required intake, handoff, and evidence procedure is in [Team-Native Core
Captain Boundary Reference](references/team-native-core-captain-boundary.md).

### Captain Boundary Anchor / 隊長邊界錨點

The captain coordinates only; it never substitutes station implementation,
validation, review, research, protected execution, or completion evidence.
Missing owner evidence remains non-complete. The detailed boundary, direct
exception, authorization, and dirty-diff procedure is in [Captain Boundary
Reference](references/team-native-core-captain-boundary.md).

## Operation Mode Rule

Every Team-Native board records `operation_mode` before selecting board template, board state, closeout lane, or station set.

```text
operation_mode -> board_template -> board_state -> closeout_lane -> station set
```

Operation mode entries:

- `daily`
  - Use when: routine inspection, lightweight evidence, low-risk documentation alignment, or generated-copy checks.
  - Use when: bounded governance drift has no source, workflow, skill, release, or deployment impact.
  - Use when: bounded governance drift has no install, external-state, or protected mutation impact.
  - Completion boundary: reduced Team-Native evidence may close daily work only.
  - Completion boundary: it still requires a Captain board, `role_id`, handoff packet, and trace evidence.
  - Completion boundary: it still requires `operation_mode_reason` and explicit blocked/unverified states.
  - Completion boundary: it cannot claim full team completion unless the task itself does not require full station separation.
- `full`
  - Use when: implementation, repair, bottom-layer refactor, cross-file governance, or specialist skill rewrites.
  - Use when: commit/release/deploy preparation, high-risk external state, or changes to source or workflow.
  - Use when: changes affect memory/docs obligations, public contracts, generated copies, or completion semantics.
  - Completion boundary: full completion requires separated change delivery, validation, review, memory/docs, and completion evidence.
  - Completion boundary: full completion also requires role identity evidence and required trace evidence.

`daily` is a reduced Team-Native mode, not a no-team shortcut.
A `daily` board that discovers full-only impact must promote to `full`, stop as blocked, or return unverified evidence.
The returned evidence must include the smallest promotion path.
Missing `operation_mode` is incomplete trace evidence.
A trace that claims `complete` without `operation_mode` is invalid.

## Team Topology And Reduction Rule

Team-Native work decomposes in this order:

```text
Captain Team Board -> station family -> formal station -> sub-station task -> member allocation -> execution channel -> delivery artifact
```

A station family groups related work such as scope, implementation, validation, review, memory/docs, or completion.
A formal station is the authorized unit.
A sub-station task is the smallest bounded piece that one member can perform without crossing role boundaries.
Member allocation decides how many people or channels are assigned to that bounded task.
Execution channels are only routes for assigned members.
They do not create roles, authorization, or completion evidence by themselves.

Multiple members does not mean multiple subagents.
A member can be a native subagent, project custom agent, browser branch, CLI branch, or MCP read path.
A member can also be a station-owned main-worktree change delivery route or isolated workspace.
A member can also be a text change delivery path or other governed channel.
The board records the member role, role instance, assigned specialist skill, sub-station task, and channel request.
It also records channel capability, channel invocation status, delivery artifact type, and delivery artifact status.

Reduction is allowed only at the sub-station task or member-count layer after the formal station family remains visible.
The captain may merge adjacent sub-station tasks only when key separation remains intact.
Required separation includes role exclusivity, delivery artifact ownership, review independence, and validation independence.
It also includes memory/docs attribution.
Speed, convenience, cost, small task size, lack of preference, or "the captain already saw it" are not valid reduction reasons.
Governance, workflow, hook, validation, memory, release, deployment, install, and protected-state work cannot become captain-direct work.
Public-contract work cannot become captain-direct work.

## Governed Team Activation Rule

When the Director asks for governed work or for Team-Native / subagent team mode, the captain must create or reuse a team board first.
The board comes before broad context-heavy work or any team-scoped station work.
The minimum activation is a board row for each applicable station, a selected specialist skill, and an attempted execution channel.
An explicit standby/block record may replace a channel attempt when the channel cannot run.

Board states are:

Board state entries:

- `draft`
  - Allowed work: pre-GO planning, candidate stations, assumptions, and scope shaping.
  - Write authority: no write authority and no formal specialist evidence.
- `formal-readonly`
  - Allowed work: read-only exploration, counter-evidence, impact mapping, document or file deep-read, and external research.
  - Allowed work: validation planning, review evidence, and standby specialist preparation.
  - Continuation: it may continue from the visible route without repeated GO when no write or protected action is added.
  - Write authority: no source, memory, git, release, deployment, install, or external-state writes.
- `formal-write`
  - Allowed work: resolved-scope station-owned main-worktree implementation change delivery.
  - Allowed work: isolated/text change delivery, authorized change application, validation, and review.
  - Allowed work: memory/docs delivery and completion audit.
  - Allowed work: protected follow-on gates when separately scoped.
  - Write authority: only the scoped target, phase, station, files, commands, or tool calls resolved by authorization.

The captain must not treat `formal-readonly` as weaker than team mode.
It is the formal team state for no-write work.
If no execution channel can be opened, the station is recorded as `blocked`, `unverified`, or `standby`.
The station record must include the smallest unblock condition.
The captain must not absorb the station into main-thread direct work unless the board records a direct exception.
That record must include replacement evidence, residual risk, and non-complete or risk-closed state.
Director-facing status should say what is being read, why, and what risk remains.
It should not expose raw board or handoff field inventories as the main explanation.

### Route And State Separation

Execution route fields may name only an actual channel or delivery form.
Allowed route examples include:

- native subagent, project custom agent, adapter, browser evidence, command evidence, MCP read, or external research.
- station-owned main-worktree change delivery, isolated change delivery, or text change delivery artifact.
- platform-nondelegable protected-action record or station-owned authorized change-application gate.

`blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, and `closed-with-director-risk` are states only.
They belong to station, evidence, authorization, or completion fields.
They must not be stored as `execution_route`, `execution_channel`, platform route, or execution mode.

`direct` is also not an execution route or station state.
Record it only as a `direct_exception` / `direct_exceptions` entry.
That entry must include station-specific reason, replacement evidence, and residual state.

When a route cannot run, keep the attempted or requested route visible.
Move the failure to `station_state`, `evidence_state`, `authorization_resolution_state`, or `completion_state`.
A missing or unavailable route never becomes routine captain work, and it never supports a complete claim.

## Skill Handoff Packet Rule

Specialist identity is not a narrative label.
Every formal station must receive a skill handoff packet that names the operation mode, assigned role, and role instance.
It also names the assigned specialist skill, loaded skill references, task row, read scope, forbidden actions, and output artifact format.
The packet must name the startup threshold and stop condition.
The handoff packet may be produced from `team-station-handoff-packet` or an equivalent platform adapter.
It must be visible in the board or delivery trace.

Station startup, cross-thread continuation, and platform thread movement are
different contracts. Only station startup uses `handoff_packet_id`; a
cross-thread package and platform transport metadata cannot satisfy this rule.

The packet must include these fields when applicable:

- `operation_mode`, `operation_mode_reason`, `role_id`, `role_instance_id`, and `exclusive_task_scope`.
- `loaded_skill_refs`, `handoff_packet_id`, `station_mode`, `context_visibility`, and `handoff_ownership`.
- `deep_read_scope`, `captain_coordination_read_scope`, and `unread_scope`.
- `startup_started_at`, `first_response_deadline`, `last_progress_at`, `heartbeat_state`, and `status_probe_state`.
- `soft_timeout_at`, `hard_timeout_at`, `status_probe_resume_state`, and `status_probe_resume_sent_at`.
- `late_result_policy`, `cancellation_state`, `timeout_action`, and `standby_reason`.

## Deep-Read And Captain Context Rule

The captain may perform only micro-read and coordination read; specialist stations
own deep/repository-scale reads and their evidence. The detailed read split,
channel, authorization, and station-assignment procedure is in [Captain Boundary
Reference](references/team-native-core-captain-boundary.md).

### Captain-Lite Reading Model

Micro-read, protected authorization, specialist assignment, research, and standby
details are in [Captain Boundary Reference](references/team-native-core-captain-boundary.md).

## Station-First Rule

After Team mode activation, the captain must create the Captain Team Board before any specialist work starts.
This applies after activation by a governed Director request.
It applies before any specialist, subagent execution channel, browser branch, CLI branch, or MCP read evidence.
It also applies before any main-worktree change-delivery branch.
It also applies before isolated change-delivery, text change-delivery, validation, review, and completion audit.
It applies before commit preparation or release preparation.
The board is created from `programming-team-governance` and `team-task-board`.

Before a formal route is resolved, work uses a draft board.
A draft board can structure planning and assumptions.
It cannot start formal specialists, satisfy validation/review/completion evidence, or support a full-team completion claim.

After authorization resolution promotes the route to `formal-readonly` or `formal-write`, the captain must create a formal dispatch board.
Promoting an existing board is also valid.
That board must exist before formal station work starts.
Every applicable station records the canonical station and trace fields defined by `team-task-board` and `team-trace-evidence`.

Core minimums are:

- operation mode, board state, dispatch wave, and formal evidence eligibility.
- specialist role source, role identity, authorization resolution, and channel state.
- delivery artifact status, role boundary, completion condition, and any direct exception.

The full field catalog must not be duplicated in core policy text.

The formal board opens only the current dispatch wave.
Review, validation, memory/docs delivery, and completion stations that depend on a change must wait.
They wait for the required change delivery artifact.
If that artifact is not returned, it must be explicitly marked blocked, unverified, or closed-with-director-risk.
A formal board is invalid when it launches all waves at once.

Each delivery ledger entry records the canonical delivery trace fields defined by `team-task-board` and `team-trace-evidence`.

Core minimums are:

- delivery artifact ID, author role, role identity, source input, and integrable scope.
- authorization resolution, review state, validation state, and memory/docs state.
- captain authoring state, dispatch wave, previous-wave input, and next-wave condition.

Detailed field catalogs stay in the referenced board and trace sources instead of being repeated here.

The board must keep the topology explicit when work is split or reduced.
Station family, formal station, sub-station task, member allocation, execution channel, and returned delivery artifact are separate fields.
Collapsing member count does not collapse station families.
A one-member station can still be valid; a no-station captain shortcut is not valid for Team-Native completion.

## Tool Execution Envelope Rule

Tool layers may receive a `tool_execution_envelope` only as a structured carrier for the current Team-Native trace.
The carrier may include board, station, handoff packet, role, channel capability, authorization scope, and delivery status.
The envelope is not a new authorization source.
It must mirror the current formal trace instead of expanding it.

A write-capable or protected tool execution envelope must include the current board and station identifiers.
It must also include:

- `handoff_packet_id`, `role_id`, `role_instance_id`, and assigned specialist skill.
- `requested_execution_channel`, `channel_capability`, and `channel_invocation_status`.
- authorization source, authorization target, authorization scope, authorization phase, and authorization evidence.
- authorization expiry, authorization resolution state, delivery artifact ID, delivery artifact type, and delivery artifact status.
- trusted issuer, signature, nonce, and issued-at evidence.

A trusted envelope is one verified by the tool layer as coming from a trusted issuer, with a valid signature and fresh nonce.
Model-filled envelopes, assistant-authored JSON, transcript text, and text-only `team_native_trace` payloads are untrusted by default.
They stay untrusted unless the platform verifies the trusted issuer, signature, and nonce.
Untrusted envelopes can explain context.
They cannot authorize source writes, change application, memory, git, release, deployment, install, or MCP mutation.
They also cannot authorize external-state mutation.

Each tool action returns an `execution_receipt`.
The receipt names the envelope or nonce, requested action, allow/block decision, reason, resulting state, and delivery artifact status.
A receipt records execution evidence; it cannot retroactively authorize a missing phase.

Invalid payload fail-closed rule:

- malformed payloads keep write-capable and protected actions blocked or unverified.
- missing envelopes, trusted issuer, signature, nonce, or fresh nonce keep those actions blocked or unverified.
- scope mismatch or absent execution receipt keeps those actions blocked or unverified.

After a block, any retry, channel switch, transcript substitution, or alternate-tool attempt is a post-block bypass hard block.
The only exceptions are current scope-bound evidence or Director risk close evidence.

## Specialist Lifecycle Rule

A `delivery_slice` is shared context and authorization, not a composite worker:
roles stay separate, only implementation writes, and validation/review never
repair. Open a new slice only when scope, allowlist, authorization, acceptance,
risk, public contract, or protected action changes. The mandatory retained-member
and finding procedure is [Team-Native Core Delivery Slice Reference](references/team-native-core-delivery-slice.md); it never replaces board, handoff, authorization, or trace contracts.

## Fast Closeout Rule

Closeout is risk-tiered so Team-Native Core stays rigorous without mechanical all-agent relaunches.

Closeout lane entries:

- `light`
  - Use when: the negative lane contract and guarded-action precedence leave only no-write, non-guarded documentation or status drift.
  - Constraint: no source, workflow, governance, generated/runtime copy, evidence-surface, release, protected, or external-state mutation.
  - Minimum stations: scope/impact, change delivery or sync delivery, validation, completion audit.
- `standard`
  - Use when: multi-file policies, skills, matrices, workflow semantics, or memory/docs impact.
  - Minimum stations: scope/impact, change delivery, memory/docs, validation, independent review, completion audit.
- `release-grade`
  - Use when: commit, tag, release, deployment, install, external state, credentials, or public operator readiness.
  - Minimum stations: standard lane plus release completion and security/reliability.

Fast closeout never lowers the completion bar and does not replace `operation_mode`.
It only reduces unnecessary station churn inside the selected mode after the negative lane contract is satisfied.
A light lane uses fewer stations only when the board records why review or memory/docs is not applicable.
It may also record the missing station as blocked, unverified, or closed-with-director-risk.
Any source, workflow, governance, generated-copy, memory, or public-contract write promotes the lane to at least `standard`.
It normally requires `operation_mode: full` unless the board records a concrete non-full reason and does not claim full team completion.

## Yellow Signal Rule

Yellow findings are classified before repair loops start.
Valid Yellow classifications are `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, and `informational`.
A Yellow finding must escalate when it affects the current completion claim, required Team-Native trace, independent review, or validation.
It must also escalate when it affects memory/docs attribution, public contract, deployment sync, or release readiness.
Escalation means blocked, unverified, or Red instead of harmless Yellow.

The same Yellow finding must not create an unbounded repair loop; validation and review only report findings. Apply the bounded repair and third-symptom procedure in the [delivery-slice reference](references/team-native-core-delivery-slice.md).

## Strict State Machine And Delivery Semantics

Team-Native Core keeps the hard boundary, while detailed value catalogs live in
the central references:

- Status meanings and route/state separation:
  `Shared/policies/references/status-ontology.md`.
- Completion targets, target transitions, and the `complete` versus
  non-complete mutual-exclusion rule:
  `Shared/policies/references/completion-state-machine.md`.
- Exception records for `direct_exception`, `platform-nondelegable`, and
  `closed-with-director-risk`:
  `Shared/policies/references/exception-registry.md`.
- Authorization phase values:
  `Shared/policies/references/authorization-phase-registry.md`.
- Protected-action categories:
  `Shared/policies/references/protected-action-registry.md`.

The core minimum remains:

- `direct_exception`, `closed-with-director-risk`, main-worktree change
  delivery, and text change delivery artifacts are not non-team shortcuts.
- They are exception records, formal station states, or delivery forms with
  stricter evidence requirements.
- Review lifecycle risk states do not become Team-Native station,
  missing-artifact, completion, or capability states.
- Diff output may be used only as an implementation representation; the
  governance object is the change delivery artifact.
- `closed-with-director-risk` is never `complete`.

State labels are not fallback routes.
If a template, trace, hook payload, handoff packet, or report places a state label into an execution route field, the station is invalid.
Affected state labels include `blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, and `closed-with-director-risk`.
The same rule applies to `direct`.
The route field must be corrected and the state must be moved into a state field.

## Completion Rule

Completion targets and state transitions are defined in
`Shared/policies/references/completion-state-machine.md`.

Process completion requires the separated artifact chain: change delivery,
memory/docs disposition, independent review, validation, sync evidence when
applicable, and completion audit.

`operation_mode: daily` can close daily work only within its reduced scope.
It must not be reported as full team completion for full-only work.
`operation_mode: full` is required for bottom-layer refactor, cross-file governance changes, and specialist skill rewrites.
It is also required for release preparation or protected external-state readiness.

Station-owned main-worktree change delivery and fallback change application
follow the authorization phase registry and protected-action registry. Forked
or text artifacts must not be reported as applied source.

The captain may ledger station output and synthesize status, but must not turn
ledgering into implementation, validation, review, memory/docs attribution, or
completion evidence. Captain substitute authoring remains blocked or
risk-closed, never `complete`, under the exception registry.

Review and validation remain independent and inspect the actual applied diff
when source is applied. Missing required artifacts, independent review, or
validation keep the target blocked, unverified, or risk-closed.

For the same closeout target, `complete` is mutually exclusive with
`blocked`, `unverified`, `partial`, `no-evidence`, `conflicted`,
`not-applicable`, and `closed-with-director-risk` according to the completion
state machine and status ontology.

Protected follow-on phases require their own authorization resolution and
protected-action gate. Source write approval does not authorize memory, git,
release, deployment, install, credential, or external mutation.

A long-work Git checkpoint is protected Git work and is never process
completion, final commit readiness, or release readiness. Its triggering event
only opens eligibility evaluation; execution still requires the separate Git
station, authorization, and receipt.

Scope-bound implementation authorization is one work agreement for the visible change-delivery phase, not a blanket workflow pass.
It can cover the named station and allowlist through the current delivery.
It cannot carry into a protected phase or unrelated file set.

When a hook or platform guard blocks an action, the block is governance evidence.
The next valid captain response is to stop that action and report blocked, unverified, or closed-with-director-risk.
The report must name the missing structured fields.
The captain must wait for scope-bound evidence or Director risk closure.
The captain must not retry through another tool, switch channels, or use transcript text as authorization.
The captain must not claim progress as if the station continued.

`closed-with-director-risk` requires current, explicit, scope-bound Director risk close evidence.
The evidence must name the residual risk, risk-closed scope, and the missing artifact.
It must also name missing validation, review, memory/docs, receipt, trusted envelope, or authorization conditions when those gaps exist.
It is never `complete` and never upgrades an untrusted tool execution envelope into protected mutation authority.

## Platform Adapter Contract

Team-Native Core is platform-neutral.
Platform differences do not activate Team mode without a governed Director request and do not widen captain authority.
Once Team mode is active, platform capability only chooses a station channel or a blocked/unverified state:

- Codex maps stations to native subagents, project custom agents, browser/terminal/MCP evidence, and station-owned change delivery.
- Codex also maps stations to isolated workspaces or text change delivery artifacts.
- Codex unavailable channels become standby, blocked, or unverified station states.
- Claude maps stations to built-in/custom/plugin subagents, description-driven delegation, hooks/checkpoints, and command evidence.
- Claude also maps stations to station-owned main-worktree change delivery, isolated workspaces, or text change delivery artifacts.
- Claude unavailable channels become standby, blocked, or unverified station states.
- Antigravity / Gemini maps stations through Gemini/Antigravity adapters, browser-capable agents, CLI evidence, and plugin adapters.
- Antigravity / Gemini also maps stations to station-owned main-worktree change delivery or text change delivery artifacts.
- Antigravity / Gemini unavailable channels become standby, blocked, or unverified station states.

Missing platform capability in active Team mode is not normal direct work.
It is blocked, unverified, or closed-with-director-risk with evidence.

## MCP Boundary

MCP tools are evidence or protected-action tools invoked by the captain path.
MCP servers are not team members.
Mutating MCP tools require a scope-bound intent signal, authorization resolution, and the matching protected gate.
They require HITL evidence when the platform requires it.

## Trace Requirement

Team-Native Core needs two kinds of verification:

1. Static governance checks: policy, skill, workflow, matrix, and documentation semantics.
2. Execution trace checks: task-level board/delivery trace for route, authorization, station, artifact, and completion evidence.

Execution trace checks include operation mode, operation mode reason, draft/formal board state, and dispatch waves.
They also include previous-wave input and next-wave conditions.
They include authorization source/target/scope/phase/evidence/expiry/resolution state and observed platform mode.
They include specialist role source, `role_id`, `role_instance_id`, and `exclusive_task_scope`.
They include delivery artifact IDs, author roles, source inputs, integrable scopes, and delivery artifact classes.
They include review/validation/memory-docs states, captain authoring state, role boundaries, direct exceptions, and completion state.

When execution trace evidence is required and absent, validation is unverified or blocked.
