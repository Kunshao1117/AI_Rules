# Cross-Platform Subagent Invocation Policy

This file is the single source of truth for AI_Rules subagent execution-channel governance across platforms.

The shared layer defines:

- how Team mode is activated by a current governed Director request;
- when delegated evidence branches are required after activation;
- when main-worktree change delivery is required after activation;
- when isolated change delivery is required after activation;
- when text change delivery artifacts are required after activation;
- how the captain receives and synthesizes returned evidence.

Shared policy must stay vendor-neutral.

Platform cores may store only marker blocks generated from this file.

Workflows and skills must inherit this file and these sources:

- `Shared/policies/team-native-core.md`
- `Shared/policies/workflow-orchestration.md`
- `Shared/policies/team-trace-evidence.md`
- `Shared/skills/programming-team-governance/SKILL.md`
- `Shared/skills/team-task-board/SKILL.md`
- `Shared/skills/delegation-strategy/SKILL.md`
- `Shared/skills/team-role-boundaries/SKILL.md`
- `Shared/skills/team-change-delivery-artifact/SKILL.md`
- `Shared/skills/team-memory-docs-delivery-artifact/SKILL.md`
- `Shared/skills/team-validation-delivery-artifact/SKILL.md`
- `Shared/skills/team-review-delivery-artifact/SKILL.md`
- `Shared/skills/team-completion-gate/SKILL.md`

Those sources must not define a parallel activation policy.

Specialist role sources must cite `team-specialist-registry` and the matching `team-specialist-*` skill.

Evidence branches provide review material only.

They do not replace review-state decisions.

Those decisions are governed by `Shared/skills/quality-review-governance/SKILL.md`.

Subagent invocation follows `Shared/policies/workflow-orchestration.md`.

The orchestration contract decides board state, dispatch wave, previous-wave input, and next-wave start condition.

It also decides formal evidence eligibility before this policy maps a station to an execution channel.

## Official And Internal Schema Boundary

Official Codex subagent semantics cover agent spawning, routing, waiting, and consolidated responses only when explicitly requested.

For AI_Rules Codex Edition, when the current Director request is governed work
and a `SessionStart` or `PreToolUse` hook injects a Team/delegation reminder,
that combination satisfies the Codex explicitly-requested delegation gate for
opening Codex subagents.
This exception resolves only the request/route precondition.
Codex subagents may start only after Team-Native board, station, role, handoff,
dispatch wave, and channel state are recorded.
It does not authorize source writes, memory mutation, git, release, deploy,
install, credentials, or external-state mutation.

Claude and Antigravity / Gemini have their own platform-tool semantics.

AI_Rules role IDs, station modes, dispatch waves, delivery artifacts, `execution_spec`, and memory/docs states are internal schema.

Team-Native trace fields are also internal governance schema.

Do not describe them as official default schema for any platform.

`external-research` is an AI_Rules evidence station role.

When freshness from official, public, or internal sources can affect a station decision, use upstream research.

That upstream evidence branch is `external-research`.

Each consuming station requests that work through `external_research_request`.

That request names the question, source tier, freshness need, acceptable evidence, and stop condition.

Returned research is station input or blocking evidence only.

Returned research does not authorize source writes or protected actions.

## Shared Semantics

### Team-Native Core

Team-Native Core is the cross-platform captain-led team model.

It is triggered by the Director's current request for governed work.

Governed work includes governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, and handoff.

Governed work also includes source, public-contract, or equivalent source/governance/evidence-bearing work.

It is also triggered by a request for a team, team member, subagent, delegation, Team-Native, or equivalent dispatch.

The Director does not need to say a fixed phrase such as `啟動團隊模式`.

The expected sequence starts with Director request -> captain intake -> translation -> team board.

Then specialist skill dispatch -> specialist work.

Then captain monitoring -> delivery/evidence artifact receipt -> synthesis ledger and board update.

Then independent validation, review, and memory/docs stations -> completion audit -> report.

The captain coordinates, ledgers artifacts, routes scope/authorization questions, and coordinates owner stations.

The captain also produces Director-facing synthesis.

Formal checks, change delivery, authorization decisions, protected gates, validation, and review belong to the matching owner.

Memory/docs disposition also belongs to the matching policy or owner station.

Platform capability selects an execution channel after governance is active.

Platform capability never grants write authority or protected-action authority.

This governance model does not imply equal native subagent capability on every platform.

Subagents, browser paths, CLI paths, MCP paths, isolated workspaces, and text delivery paths are execution channels.

Role and responsibility must be decided first by `team-specialist-registry` and the matching `team-specialist-*` skill.

The chosen role is then mapped to an available channel.

After Team mode is active, Team-Native Core also applies to read-only exploration and architecture blueprints.

It also applies to broad file reads, external research, impact analysis, and validation planning.

This applies whenever those outputs may affect source, workflow, validation, review, memory, release, or governance decisions.

Use `formal-readonly` when no write authority exists.

Use `formal-write` only after scope and authorization state are resolved.

When Team mode is not active, ordinary no-write or read-only work is not constrained by captain/team-board rules.

Formal member startup must use a skill dispatch package, not a verbal role description.

The package records:

- assigned specialist skill;
- loaded skill refs;
- read scope;
- deep read scope;
- captain coordination read scope;
- context visibility;
- handoff ownership;
- station mode;
- unread scope;
- allowed inputs;
- allowed tools;
- forbidden actions;
- output artifact format;
- stop condition;
- startup time;
- first-response deadline;
- last-progress time;
- timeout action;
- status-probe pause/resume state;
- standby reason.

Large-file deep read must go to a bounded member station.

The captain must not absorb, substitute, or deep read large files as the team's evidence source.

Platform capability must be classified as `native`, `adapter`, `conditional`, or `unavailable`.

Codex and Claude use native or plugin subagents when available.

Antigravity / Gemini team stations can only be adapter or conditional routes.

When a conditional route is not proven usable, the station state must be `blocked`, `unverified`, or `closed-with-director-risk`.

Do not degrade that state to a legacy invalid/forbidden `routine direct` path or a routine captain path.

Do not degrade that state to a claim that Team mode was not active.

### Formal Team Skill Sources

Formal team collaboration uses these fixed sources:

- `team-specialist-registry`
- the applicable `team-specialist-*` skill
- `team-role-boundaries`
- `team-change-delivery-artifact`
- `team-memory-docs-delivery-artifact`
- `team-validation-delivery-artifact`
- `team-review-delivery-artifact`
- `team-completion-gate`

When Team mode is already triggered by the workflow entry, formal team skill sources must be loaded for governed work.

This applies to captain-led programming, repair, validation, review, memory, commit, handoff, and skill-forging.

This also applies to governance-impact work.

Do not replace them with "as needed", "when necessary", or captain discretion.

### Captain Trigger Gate

When the Director asks for governed work, that current request triggers captain-led Team mode.

Governed work includes governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, and handoff.

Governed work also includes source, public-contract, or equivalent governed work.

The Director does not need to say `啟動團隊模式` or any fixed phrase.

Requests for a team, team member, subagent, delegation, Team-Native, or equivalent dispatch also trigger Team mode.

Workflow and skill names are route signals.

When the request itself is governed work, Team mode is triggered by the request.

Workflow/skill names do not grant write authority, protected gates, or unscoped dispatch authority.

When Team mode is not active, only pure Q&A, translation, small stable factual answers, or no-impact read-only work may proceed.

Those cases still follow ordinary lifecycle, scope-bound authorization, protected-action gates, and read-before-write rules.

Do not create a team station board or claim Team-Native completion for those non-team cases.

### Task Type And Dispatch Pre-Gate

After Team mode is active, the main agent first determines task type, workflow route, and implementation authorization.

The main agent also determines allowed member roles and forbidden member roles.

The main agent then creates the captain team station board under `team-task-board`.

Subagent channels, browser branches, CLI branches, and main-worktree change delivery must not start before the team board exists.

Isolated change delivery, text change delivery artifacts, and parallel evidence work also must not start before the team board exists.

When the Director explicitly requests subagents, team mode, parallel agents, or a workflow command, dispatch must start immediately.

That request starts the board and dispatch decision.

It does not allow members to start first and backfill the board later.

### Multi-Station And Multi-Member Model

The formal team model decomposes work in this order:

- task board;
- station family;
- formal station;
- substation task;
- member assignment;
- execution channel;
- delivery artifact.

Station families preserve responsibility areas such as requirements, impact, implementation, validation, and review.

They also preserve memory/docs and completion audit responsibility areas.

Formal stations are the unit of authorization and evidence eligibility.

Substation tasks are the smallest packages a single member can own.

Member assignments decide how many members or channels a task needs.

Execution channels let that member work.

Delivery artifacts are the evidence that can be received, reviewed, and synthesized.

Delivery artifacts may also be the change material written by a named station-owned change-delivery route.

They may later be applied by a fallback station-owned change-application gate.

Multiple members do not necessarily mean multiple subagents.

A member can map to a native subagent, project custom agent, browser branch, CLI branch, or MCP read path.

A member can also map to an isolated workspace, text change delivery path, or another governed channel.

The board must preserve:

- member role;
- role instance;
- assigned specialist skill;
- substation task;
- requested channel;
- channel capability;
- channel invocation status;
- delivery artifact type;
- delivery artifact status.

Do not collapse this to "multiple agents" or "captain handled".

### Specialist Assignment Gate

After Team mode is active, the applicable station assigns the specialist skill before selecting the execution channel.

Tool-layer limits constrain channel startup, not specialist assignment.

If execution channels are unavailable, the station remains on the formal dispatch board.

Execution channels include subagents, custom agents, browser, CLI, MCP, isolated workspaces, and text delivery channels.

That station records requested channel, channel capability, channel invocation status, and delivery artifact type.

That station also records delivery artifact status.

Unavailable capability may only be `blocked`, `unverified`, or `closed-with-director-risk`.

Do not remove the station or replace it with captain mainline work while still claiming full team completion.

If a channel has not returned but the station remains valid, the station may be `standby`.

Standby requires:

- a reason;
- the awaited prior-wave input or platform warmup condition;
- first-response deadline;
- timeout action.

Standby is not completion evidence.

A timeout while waiting for a tool, subagent, browser, CLI, MCP, or adapter is an observed timeout.

It is not member failure, cancellation, or artifact rejection.

Before opening a replacement because of timeout, the captain must send a status probe.

If the platform cannot be probed, record why.

A probed member pauses current work and reports stopping point, blocker state, and safe-to-continue state.

The member then waits for the captain to resume the same channel explicitly.

A reported but not resumed channel is `awaiting-resume`.

After resume, the channel may return to `running`, request extension, or become `blocked`.

Without a reply, mark it `unresponsive`, `unverified`, or `blocked`.

Also record the smallest unblock condition.

### Draft And Formal Boards

Draft boards are pre-GO planning only.

They may record candidate stations, candidate members, planned dispatch waves, and assumptions.

They cannot start formal members, produce formal evidence eligibility, or satisfy readiness evidence.

They cannot support full team completion claims.

Use a `formal-readonly` board for read-only or no-write stations.

Use a `formal-write` board for implementation and protected actions only after scope and authorization state are resolved.

Every applicable station in the formal dispatch lifecycle records phase, dispatch wave, and previous-wave input.

Every applicable station also records next-wave start condition and formal evidence eligibility.

### Team-Native Minimum Execution Gate

The canonical captain boundary is the `Captain Boundary Anchor / 隊長邊界錨點`.

That anchor lives in `Shared/policies/team-native-core.md`.

This policy only adds execution-channel mapping.

The main agent keeps Director communication, board maintenance, handoff/ledgering, and blocker routing.

The main agent also keeps authorization question routing, owner-station coordination, and Director-facing synthesis.

Missing station artifacts must be filled by the matching station.

Otherwise, mark them item by item as `blocked`, `unverified`, or `closed-with-director-risk`.

Main-worktree implementation can be performed only by a named station-owned `change-delivery` station when these are all present:

- `formal-write`
- authorization phase `implementation-change-delivery`
- exact file allowlist
- dirty diff read
- forbidden protected actions
- `handoff_ownership: station-owned`

`change-application` is a fallback integration route only for a returned artifact or explicit integration task.

It also covers assigned generated/deployed sync.

Fork or text delivery must be marked `fork-only` or `text-only`.

Fork or text delivery must not claim main-worktree write.

Counter-evidence, impact, validation, review, completion audit, and broad/deep read must use matching bounded paths.

Matching bounded paths include evidence branch, CLI/MCP/browser path, or change delivery path.

If channel limits cause a `direct_exception`, preserve the per-station exception and replacement evidence.

Preserve the non-complete state.

A direct exception is not completion evidence.

### Delegation Gate

After Team mode is active, the main agent creates the captain team station board.

That board is defined by `programming-team-governance` and `team-task-board`.

The main agent then decides the role and execution channel for each applicable station.

Research, testing, debugging, audit, experiment, post-build or post-fix validation, and pre-commit scan are stationized work.

Handoff and skill-forging are also stationized work that must be evaluated.

Stations must not be labeled only as "active", "when needed", or by size.

Each station must map to a real channel or delivery form, such as:

- `evidence branch`
- `browser branch`
- `CLI branch`
- `MCP read/tool path`
- `station-owned main-worktree change delivery`
- `isolated change delivery`
- `text change delivery artifact`
- `station-owned authorized change-application gate`
- `platform-nondelegable protected-action record`
- `blocked`
- `not-applicable`

`direct` can appear only in `direct_exception`.

That record must include evidence owner, role boundary, completion condition, and exception reason.

The Delegation Gate returns only one of these outcomes:

#### Gate result: `direct_exception`

- When to use:
  - Only for tool-only actions that cannot produce independent station evidence.
  - Only for hot-path non-mutating status feedback.
  - Only for non-implementation stations proven to have no independent evidence value.
  - Only for Director-explicit `closed-with-director-risk` risk closure that is not full completion.

- Main-agent obligation:
  - Record a specific exception.
  - Record replacement evidence.
  - Record capability limit.
  - Record residual state.
  - It is not an execution route, mode, channel, or state.

#### Gate result: `browser branch`

- When to use: UI, DOM, screenshot, browser interaction, or visual validation is needed.

- Main-agent obligation:
  - Return only browser evidence, failures, and suggested routing.
  - If main-worktree modification is needed, route back to a named station-owned change-delivery station.
  - Route to station-owned authorized change-application only when a returned artifact, integration task, or sync input exists.

#### Gate result: `CLI branch`

- When to use: Large CLI output, scan, test summary, or log analysis is needed and can be isolated as a report.

- Main-agent obligation: Intermediate reports may be written only under `.agents/logs/`.

  Source must not be modified.

#### Gate result: `MCP read/tool path`

- When to use: Current tool data, cloud status, document lookup, or database read is needed.

- Main-agent obligation: MCP is a tool path, not a delegation target.

  Mutating MCP calls still require scope-bound intent / HITL gate, authorization resolution, and the matching protected gate.

#### Gate result: `evidence branch`

- When to use: Independent read-only investigation remains after browser, CLI, and MCP special paths are excluded.

- Examples include counter-evidence, document inventory, cross-module impact, regression risk, or product/spec research.

- Main-agent obligation:
  - Delegate one or more read-only evidence branches.
  - Receive evidence artifacts.
  - Synthesize state.
  - The mainline may wait for the artifact.
  - Do not degrade it to direct work.

#### Gate result: `station-owned main-worktree change delivery`

- When to use: Main-worktree implementation has `formal-write` and authorization phase `implementation-change-delivery`.

- Required inputs include exact file allowlist, dirty diff read, forbidden protected actions, and `handoff_ownership: station-owned`.

- Main-agent obligation:
  - A named `change-delivery` member station writes the main worktree directly.
  - That station returns a change delivery artifact or ledger entry.
  - That station must not self-review.
  - That station must not mutate memory, git, release, deploy, install, credentials, or external state.

#### Gate result: `isolated change delivery`

- When to use: The implementation member can produce a bounded change delivery artifact only in a governed fork or sandbox.

- It can also use an isolated worktree.

- Main-agent obligation:
  - The isolated station does not write the main worktree.
  - The main agent only receives the artifact.
  - The main agent updates the board.
  - The main agent handles blockers/conflicts.
  - The main agent routes to a named station-owned authorized change-application gate.

#### Gate result: `text change delivery artifact`

- When to use: No governed file isolation is available, but the task can still be sliced clearly and delivered as text changes.

- Main-agent obligation:
  - Allow only text change artifacts and evidence.
  - The main agent only receives the artifact.
  - The main agent updates the board.
  - The main agent routes it to an authorized named station-owned change-application gate.
  - Rewriting or reauthoring is captain substitute-authoring risk.

#### Gate result: `station-owned authorized change-application gate`

- When to use: A returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync exists.

- `formal-write` authorization must also be bound to the `change-application` phase.

- Main-agent obligation:
  - A member station owns fallback integration and may write main-worktree source.
  - The captain only monitors and records the ledger entry.
  - If the platform cannot delegate the physical write, record a platform-nondelegable protected-action record.
  - Also record `direct_exception`.

#### Gate result: `blocked`

- When to use: Required evidence, authority, tool, login state, authorization, or dispatchable board is missing.

- Main-agent obligation:
  - Report the smallest unblock condition.
  - Do not degrade to completion.
  - Do not degrade to legacy invalid/forbidden `routine direct`.
  - Do not degrade to routine captain path.

#### Gate result: `not-applicable`

- When to use: The station is outside this task.

- Main-agent obligation: Report why it is not applicable.

### Dispatch Waves And Formal Evidence Eligibility

Formal dispatch starts one wave at a time.

A wave may open only stations without dependency conflict.

Work that depends on prior station output must wait for a later wave.

Implementation and review of the same deliverable must not be in the same wave.

Validation that depends on a change artifact must not start before the artifact exists.

Do not create the board and dispatch every station at once.

Before each wave starts, the formal board records the previous-wave result.

It also confirms that the next-wave start condition is satisfied.

An evidence artifact has formal evidence eligibility only when the station is on the formal dispatch board.

The station wave must be open.

The reporter must match the assigned role.

The report format must be complete.

No read-only or mutually exclusive role boundary may be crossed.

Material produced during a draft board can only become previous-wave input.

Material produced during a draft board cannot independently satisfy formal readiness evidence.

### Member Lifecycle And Fast Closeout

Subagents, CLI branches, browser branches, MCP evidence, isolated workspaces, and text delivery channels are execution channels only.

A channel conversation may be retained or reused within the same station, role, artifact, and role boundary.

Retention records member state, retention reason, conversation health, reuse count, handoff summary, and closure reason.

A status probe only checks whether the channel is still alive.

A status probe does not change role or station responsibility.

A status probe pauses the channel's current action.

After a member reports stopping point, blocker state, and safe-to-continue judgment, it must wait for explicit captain resume.

When work moves from implementation to review, the original channel must close or hand off.

The original channel must also close or hand off when failed validation moves to repair.

The same rule applies when memory attribution moves to memory write.

The same rule applies when completion audit moves to final decision or second-opinion work.

Do not reuse the same member across that role boundary.

A replacement channel is a new channel generation.

It is not cancellation of the original channel.

The board records:

- original channel ID;
- replacement channel ID;
- replacement reason;
- cancellation state;
- late-result policy;
- late-result window.

If the original channel later returns an artifact, the captain records it and makes a neutral ledger decision such as:

- `logged`
- `included-in-synthesis-ledger`
- `routed-to-owner-station`
- `superseded-by-replacement`
- `out-of-scope`
- `duplicate`
- `conflict-review`
- `blocked`
- `unverified`

Do not discard a late artifact merely because a replacement has returned.

Before closeout, close all opened channels.

Otherwise, mark still-running, unobservable, late-pending, or cancellation-unconfirmed channels as non-complete states.

Allowed non-complete states are `blocked`, `unverified`, or `closed-with-director-risk`.

Formal closeout may be `light`, `standard`, or `release-grade`.

Light closeout is only for docs, deployed-copy sync, yellow drift, or low-risk governance text.

Light closeout still records stations, artifacts, validation, and completion audit.

Multi-file specs, skills, matrices, routines, memory/docs, public contracts, or main-worktree source changes are at least standard.

Commit, tag, release, deployment, install, external state, or credential work is release-grade.

Yellow states must not become infinite repair loops.

The formal board classifies each yellow state for the current round as:

- `fix-this-cycle`
- `residual-accepted`
- `deferred-follow-up`
- `local-customization`
- `informational`

If a yellow state affects completion evidence, formal trace, independent review, validation, or memory attribution, escalate it.

Also escalate it if it affects public contract, deployed sync, or release readiness.

Escalation targets are `blocked`, `unverified`, or Red.

If the same symptom, file area, or operation path still remains after two repair attempts, the next step must change.

Valid next steps are root-cause repair, structural refactor, `blocked`, `unverified`, or `closed-with-director-risk`.

### Role Exclusivity

Members are role-limited specialists, not general assistants.

In the same deliverable, one member may own only one concrete station task.

That member cannot act as requirements, architecture, implementation, testing, review, or completion at the same time.

Requirements members do not implement.

Architecture members do not write production changes directly.

Implementation members do not expand requirements or review their own output.

Testing members do not modify core logic.

Review members do not implement the reviewed result.

Completion members do not write memory, commit, push, release, or deploy.

If role separation cannot be preserved for a deliverable, mark it `closed-with-director-risk`, `unverified`, or `blocked`.

### Mandatory Delegation Assessment Scenarios

1. Programming work enters requirements replay, counter-evidence, impact, short-loop validation, review, or closeout stations.
2. A task has two or more parallel read lines, such as document inventory, cross-module impact, product research, or spec research.
3. A task requires large file reads, search, browser checks, or CLI analysis whose result is decision material for the main agent.
4. The main agent is handling an implementation line while a side path can validate docs, test risk, UI presentation, or compatibility.
5. A subagent task can be bounded clearly and returned in a fixed format.
6. Formal programming workflows have applicable and safely bounded stations.
   - These include counter-evidence, impact, short-loop validation, review, or completion audit stations.
7. An implementation station can be sliced clearly.
   - A platform may provide a governed isolated workspace or text change artifact path.
   - That path can deliver a change artifact without writing the main worktree.

### Fake Team Guardrail

If two or more evidence-oriented stations use `direct_exception`, the team board must not be treated as complete.

Every station must have a station-specific exception, replacement evidence, and a residual state.

Allowed residual states are `closed-with-director-risk`, `unverified`, or `blocked`.

These reasons are not sufficient by themselves:

- small task
- faster
- delegation cost
- unnecessary
- not opening now
- captain already read it

If platform subagents, special branches, or dispatchable boards are unavailable, the station state must be non-complete.

Allowed states are `blocked`, `unverified`, or `closed-with-director-risk`.

That means Director risk closed, not complete.

Do not package missing tools as completed team collaboration.

### Reduction Hard Rules

Reduction can happen only at the substation-task or member-count layer.

Reduction must not remove station families, formal stations, delivery artifact types, role boundaries, or authorization fields.

Reduction must not remove validation, review, or memory/docs responsibility.

Speed, convenience, cost, small task, captain already read it, not opening now, and tool friction are not valid downgrade reasons.

High channel cost is not a valid downgrade reason.

Governance, workflow, hook, validation, memory, release, deployment, install, and protected-state work must not be reduced.

Public-contract work must not be reduced to captain substitute execution because it appears simple.

If only captain substitute work is possible, mark the station `blocked` or `unverified` first.

It may be marked `closed-with-director-risk` only when the Director explicitly accepts that gap for this case.

It must not be claimed as full completion.

### Forbidden Delegation Conditions

Do not delegate, or require the main agent to handle the gate first, when:

1. The task needs main-worktree source writes but lacks station-owned `change-delivery` authority.
   - The missing authority is for `implementation-change-delivery`.
   - It is not a fallback `change-application` with a returned artifact, explicit integration task, or assigned sync.
2. The task needs mutation of memory cards, cloud resources, PRs, issues, version-control state, or deployment state.
3. The task needs credentials, secrets, login state, or private data that cannot be exposed.
4. The task is too ambiguous to bound read scope, tool scope, or report format.
5. The evidence branch duplicates the main agent's exact current work, causing conflict or waste.
6. The station itself is GO interpretation, Director communication, final review state, completion claim, or memory commit.
   - The station itself also includes commit, push, release, deployment, or install.
7. A member would implement and review the same result, or would cross an assigned role boundary.

### Captain Receipt And Synthesis Responsibilities

The main agent is always the single Director-facing owner and state synthesizer:

- The main agent checks evidence branch output.

  The main agent does not accept or apply it verbatim as fact.

- Member artifacts, board fields, trace fields, and handoff fields are internal evidence, not final Director reports.

  Before Director-facing output, the main agent converts them through `Shared/policies/language-governance.md`.

  The result is a Traditional Chinese meaning-first summary.

  Do not make English fields or workflow terms the primary report body.

- The main agent may rewrite the Director-readable summary.

  總監可見主體必須以繁中語義先行；English fields, paths, commands, and canonical tokens may appear only as supporting evidence, location, or precision.

  隊長可摘要、轉譯或重寫呈現文字，但不得改寫證據來源、角色歸屬、驗證結論、審查結論、風險狀態、完成狀態或不確定性。

  The main agent must not rewrite evidence source, role attribution, validation conclusion, or review conclusion.

  The main agent must not rewrite completion state or uncertainty.

  The summary preserves source and non-complete states such as `blocked`, `unverified`, and `standby`.

  The summary also preserves `closed-with-director-risk`.

- When channels are unavailable, unauthorized, or missing artifacts, the main agent must not use broad read.

  The main agent must not use deep read or self-authored substitute work to convert the gap into complete team evidence.

  Preserve station state and state the gap, replacement evidence, and smallest unblock condition.

- The main agent routes findings to the owner station or Director-visible plan/ledger.

  The main agent keeps synthesis ledger, Director-facing synthesis/report, and blocker-routing responsibility.

  Code/docs/tests/memory application decisions belong to the matching owner station or scope-bound authorization.

  They can also belong to the protected gate, review/validation gate, or memory/docs gate.

- If an evidence branch is used for engineering review, route the recovered evidence to a review station.

  That review station maps review lifecycle state through `quality-review-governance`.

- Do not delegate Director communication, GO gates, commit, push, deployment, install, or `memory_commit`.

- Do not delegate external-state mutation.

- Do not let an evidence branch decide the team board, final review state, or completion claim.

  Main-worktree implementation goes to a formal `change-delivery` station.

  Fallback integration goes to a formal `change-application` station.

  If the platform cannot delegate, record a platform-nondelegable protected-action record and `direct_exception`.

- If branch reports conflict, re-check or mark uncertainty explicitly.

### Review-State Boundary

Evidence branches, CLI branches, browser branches, MCP read paths, and text artifacts provide review material only.

They also provide counter-evidence only.

Review lifecycle state must come from a review station under `quality-review-governance`.

Completion/release stations decide readiness.

The main agent performs Director-facing synthesis and blocker routing.

No execution channel may promote its own evidence to final review state, completion state, or release readiness.

### Evidence Branch Read-Only Boundary

Evidence branches may only perform read-only exploration, analysis, validation, and draft recommendations.

Allowed work includes file reads, searches, browser observation, screenshot checks, and test-result analysis.

Allowed work also includes document summaries and risk assessment.

Forbidden work includes writing source, editing memory cards, stage/commit/push, deployment, and package install.

Forbidden work also includes cloud-resource mutation, issue/PR state mutation, or any MCP tool call that mutates external state.

### Isolated Change Delivery Branch Boundary

An isolated change delivery branch may only produce a change delivery artifact inside a governed fork, sandbox, or isolated worktree.

It may also produce a text change artifact.

That branch does not own main-worktree writes, memory-card updates, stage/commit/push, deployment, or package install.

That branch also does not own cloud-resource mutation, issue/PR state mutation, or self-review.

Main-worktree source implementation is a `formal-write` `change-delivery` station.

Main-worktree source implementation defaults to named member ownership.

Fallback `change-application` applies only a returned isolated/text artifact or explicit integration task.

It also applies assigned generated/deployed sync.

If the platform cannot delegate the physical write, record a platform-nondelegable protected-action record.

Also record `direct_exception`.

If the platform has no isolation mechanism and cannot deliver a text change artifact, the implementation station is `blocked`.

Only when the Director explicitly accepts `closed-with-director-risk` for that case may the captain produce substitute content.

That substitute content must remain marked non-complete.

Do not treat lack of isolation as a normal fallback or full-completion evidence.

### Fixed Report Formats

All evidence branches must report with the `team-task-board` evidence delivery artifact format.

This lets the main agent ledger and synthesize quickly:

```text
artifact_type: evidence_delivery
findings:
evidence:
risk:
recommendation:
blocking:
status:
```

All isolated change delivery branches or text change delivery artifacts must report with the `team-task-board` format.

Use the implementation change delivery format:

```text
artifact_type: implementation_change_delivery
changes:
files:
evidence:
risk:
memory_impact:
review_need:
blocking:
status:
```

All source, workflow, governance, documentation, generated-copy, or public-contract changes must produce a memory/docs delivery artifact.

Otherwise they must be marked explicitly as blocked, unverified, or Director-risk-closed but non-complete.

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

### Change Application Authorization

Formal team completion requires:

- an implementation change delivery artifact or main-worktree change ledger entry;
- a memory/docs delivery artifact;
- a review artifact;
- a validation artifact.

A fallback `change-application` ledger entry is needed only when a returned artifact or integration task must be applied.

It is also needed when generated/deployed sync must be applied.

The change artifact must come from an implementation member and include `memory_impact`.

Main-worktree implementation must be performed by an authorized station-owned `change-delivery` station.

It must use the exact allowlist.

Fallback integration must be performed by an authorized station-owned `change-application` gate.

It must stay under the artifact or sync scope.

Platform-nondelegable protected-action records are allowed only when the platform cannot delegate the action.

They must not become captain rewriting.

Captain substitute authoring, rework, self-produced station artifacts, or rewritten member content may be risk-closed.

It may be marked `closed-with-director-risk` only when the Director explicitly risk-closes that case.

They do not satisfy formal team completion.

The memory/docs artifact must include `memory_impact` and `memory_delivery`.

The review artifact must come from a reviewer who did not implement the change.

The validation artifact must come from a test or validation path that did not modify the core implementation.

If any artifact, independent review, or validation is missing, the station can only be `blocked`, `unverified`, or risk-closed.

Risk-closed state is `closed-with-director-risk`.

Do not claim full team completion.

Auditable completion also requires Team-Native trace evidence.

Otherwise the trace gap must be marked `unverified` or `blocked`.

## Platform Translation Blocks

The following blocks are injected into platform core rules by the sync script.

Platform copies must not be edited by hand.

Platform-specific tool names may appear only in these translation blocks or platform-specific workflow/command files.

Shared semantics must not hard-code a single vendor tool name.

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This core marker is generated from `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Codex native subagents are execution channels only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required Codex evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not captain-direct completion.

- Codex subagents must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Codex subagents may mutate only when a scoped protected station explicitly owns that phase.

<!-- SUBAGENT_POLICY:CODEX_END -->

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This core marker is generated from `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Claude subagents are execution channels only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required Claude evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing subagent capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not master-agent direct completion.

- Claude subagents must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Claude subagents may mutate only when a scoped protected station explicitly owns that phase.

<!-- SUBAGENT_POLICY:CLAUDE_END -->

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This core marker is generated from `Shared/policies/subagent-invocation.md`.

Keep the full policy in `Shared/policies/` and the deployed readable copy at `.agents/shared/policies/subagent-invocation.md`.

Do not paste the full playbook into platform core.

- Antigravity / Gemini specialist routes are adapter or conditional execution channels.

  They apply only after Team mode is activated by a governed Director request.

  They also require recorded Team-Native board, station, role, handoff, dispatch wave, and channel state.

- Required evidence and change-delivery reports follow the formats in `programming-team-governance` and `team-task-board`.

  They also follow delivery artifact skills.

- Missing adapter capability is `blocked`, `unverified`, `standby`, `unavailable`, or `closed-with-director-risk`.

  It is not master-agent direct completion.

- Antigravity / Gemini adapters must not mutate source, memory, git, release, deploy, install, credentials, or external state.

- Antigravity / Gemini adapters may mutate only when a scoped protected station explicitly owns that phase.

<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
