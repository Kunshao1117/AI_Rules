# Team-Native Core Policy

此檔定義 AI_Rules 的團隊原生核心。Team-Native Core 是使用者要求受治理工作後的跨平台團隊治理主幹；Team-Native / subagent team mode 由目前 Director 對 governance、workflow、fix、build、debug、test、audit、skill、memory/docs、commit、handoff、source、public-contract 等受治理工作的請求觸發，也可由團隊、隊員、subagent、delegation、Team-Native 或等價派工語意觸發，不是 AI 自行無請求啟動、單一子代理功能、單一工作流、或單一技能。

## Core Contract

Team-Native Core is the highest-priority governance spine after the current
Director request asks for governed work. Governed work includes governance,
workflow, fix, build, debug, test, audit, skill, memory/docs, commit, handoff,
source, public-contract, or equivalent source/governance/evidence-bearing work;
requests for a team, team member, subagent, delegation, or Team-Native also
activate Team mode. The Director does not need to use a fixed phrase such as
"啟動團隊模式". Workflow names, platform modes, approval UI, tool capability,
prior conversation state, or source impact are not independent triggers without
a current governed Director request.

When the Director request is pure conversation, a small stable answer, or work
with no source/governance/evidence effect, Team mode can remain inactive:
captain/team-board limits do not apply and no Captain Team Board is required.
Normal lifecycle, scoped authorization, protected-action gates,
read-before-write, security, and source/deployed sync rules still apply.
Non-team work must not claim Team-Native completion, separated station evidence,
or team review.

When Team mode is active, the valid runtime state is board-first station
assignment, not captain-direct execution. A platform that lacks native subagents
remains in Team-Native mode through adapters, evidence branches,
CLI/MCP/browser channels, station-owned main-worktree change delivery,
isolated/text change delivery, or explicit standby/block states. Missing channel
capability is a station state, not permission for captain-direct work.

When active, Team-Native Core is an execution precondition, not advisory prose.
The next valid runtime state is a Captain Team Board with applicable stations,
handoff packets, and channel states. The captain must not perform broad reading,
impact mapping, implementation, validation, review, memory attribution, commit
preparation, release preparation, or completion claims first and only document
the team route afterward.

The shared workflow sequence is defined by
`Shared/policies/workflow-orchestration.md`. After a governed Director request
activates Team mode, that Team-Native gate is authoritative; workflow
orchestration defines the route -> authorization -> operation_mode ->
board_state -> dispatch wave -> delivery artifact -> closeout order used by
workflow entries and stations.

## Core Boundary And Policy Placement Rule

Team-Native Core owns the governed team safety invariants after activation:
board-first activation, role separation, captain thin-context limits, delivery artifact requirements,
authorization handoff to the authorization policy, and non-complete states for
missing evidence. It must stay short enough to load as a core guard. Long
workflow recipes, board field catalogs, scenario examples, platform-specific
adapter steps, and tool recipes belong in shared policies, workflow matrices,
team skills, or skill `references/` files.

When a rule is needed across workflows but is too detailed for the core, place
the canonical contract in `Shared/policies/` and cite it from platform core or
workflow entries. When a rule is operational and only needed after a skill is
loaded, place it in a shared skill or that skill's references. When a fact is
project-specific, place it in memory. When a stable preference or design DNA is
needed, place it in project context. Core text must not grow by copying those
layers back into always-on instructions.

Condensing Team-Native text is allowed only when executable defenses remain:
required gates, forbidden shortcuts, evidence requirements, blocked/unverified
states, and source/deployed sync obligations must survive the rewrite. Removing
duplicate examples is good; deleting the guard that made a rule enforceable is
not.

## Core Injection Hard Gate

After a governed Director request activates Team mode, core injection rules must
enforce the shortest Team-Native gate before any phase-owning skill, workflow,
platform adapter, captain tool call for broad or evidence-producing work, or
evidence-producing read can soften it. When Team mode is not active, these
captain/team-board gates are not evaluated. Once Team-Native Core applies,
broad file reading,
repository-wide grep, recursive scans, whole-repository file lists, validation,
review, memory/docs attribution, completion audit, source writes, and completion
claims are forbidden until the trace has a Captain Team Board, applicable
stations, a station handoff packet, role identity (`role_id`,
`role_instance_id`, and assigned specialist skill), channel state
(`requested_execution_channel`, `channel_capability`,
`channel_invocation_status`, or an explicit standby/block state), and lifecycle
fields (`station_mode`, `context_visibility`, and `handoff_ownership`).

This gate applies before the captain runs tools for those actions. Tool
availability, fast local commands, workflow route names, or prior conversation
context do not permit the captain to perform repository-wide evidence gathering
first and document the board afterward.

### Captain Minimum Entry / 隊長最小入口

The captain minimum entry is only the thin intake layer required to decide
whether the current request activates Team mode, create or reuse the first
station path, dispatch bounded work, refuse captain substitute labor, report
missing station evidence as `blocked`, `unverified`, or
`closed-with-director-risk`, and provide final Traditional Chinese synthesis
from returned evidence.

Complete board field catalogs, handoff packet field lists, trace ledgers,
review records, validation records, memory/docs records, and completion-audit
fields are not prerequisites for that first captain entry. They load
conditionally when the matching station, write/read action, review, validation,
memory/docs, protected action, or completion phase begins, and each phase must
satisfy its own gate before producing evidence or a completion claim.

This minimum entry does not relax any invariant for source writes, protected
actions, validation, independent review, memory/docs attribution, delivery
artifacts, source/deployed sync, or completion. If a later phase needs evidence
that is absent, the captain reports the missing evidence state instead of doing
the station's work or claiming completion.

### Captain Boundary Anchor / 隊長邊界錨點

This is the canonical captain-boundary anchor for team skills and subagent
policy: the captain coordinates intake, board state, handoffs, blocker routing,
station-output ledgering, and Director-facing synthesis only. Broad/deep reads,
implementation, validation, review, memory/docs attribution, protected
execution, and completion evidence belong to owner stations.

Missing station evidence remains `blocked`, `unverified`, or
`closed-with-director-risk`; `direct_exception` and platform-nondelegable
records are explicit risk or coordination records, not execution routes,
station evidence, or completion proof. Main-worktree writes require
station-owned `change-delivery` with resolved `formal-write` authorization,
exact allowlist, dirty-diff read, forbidden protected actions, and
`handoff_ownership: station-owned`; fallback `change-application` is only for a
returned artifact, explicit integration task, or assigned generated/deployed
sync. Protected follow-on phases require their own scope-bound authorization.

If any gate element is missing, the station or task can only be `blocked`,
`unverified`, or `closed-with-director-risk`. The captain must not absorb the
work into mainline direct execution and still claim Team-Native mode, full team
completion, or complete evidence.

Root-cause guard: if a platform cannot open a specialist channel, that is a
station state to report (`standby`, `blocked`, `unverified`,
`not-authorized`, or `unavailable`), not permission for silent captain-direct
work. The captain must keep the station blocked, unverified, standby,
not-authorized, or unavailable unless the board names the missing route,
replacement evidence, residual risk, and smallest unblock condition; even then,
captain-direct continuation is a recorded direct exception, not proof that team
mode was off.

Team-Native Core applies when the Director asks for governed work. When active,
it covers source, workflow, fix, build, debug, test, audit, validation, review,
memory/docs, commit, release, deployment, install, project governance, generated
copies, public contracts, broad file inspection, external research, and impact
analysis that can shape later source, workflow, validation, review, memory,
release, or governance work.

When Team mode is not active, pure conversation, small stable answers, and
no-impact read-only work proceed under the normal workflow, authorization,
protected-gate, and read-before-write rules without captain/team-board
restrictions. If the Director later requests governed work or team mode, create
the board before team evidence, specialist work, or team completion claims
begin.

The required delivery sequence is fixed: Director instruction -> captain intake -> translation -> board creation -> specialist station assignment -> station handoff packet -> execution-channel decision -> specialist startup attempt, standby, or blocked/unverified channel state -> specialist work -> returned change delivery artifacts / evidence delivery artifacts -> captain logs received station output in the synthesis ledger and updates the board -> independent validation, review, and memory/docs stations -> completion audit -> report.

The captain remains the only Director-facing owner, but the captain is an
orchestration and summarization role, not the default worker. The captain turns
Director requests into station tasks, coordinates dispatch, handoff, channels,
blockers, permission questions, board state, the synthesis ledger, and
Director-facing reporting. Authorization decisions, validation, review,
memory/docs attribution, quality disposition, protected-action execution, and
completion audit evidence stay with their governing policy or owner station.
The captain must not call `apply_patch`, shell writes, editor tools, or any
other source-writing tool and label that captain-authored diff as change
delivery. All separable requirement replay, counter-evidence, impact mapping,
implementation change delivery, memory delivery, validation, review, and
completion audit work belongs to team stations.

Workflow and skill names are route hints. They are not write authorization and
do not by themselves replace the team board or authorize pre-board dispatch.
When the Director request itself is governed work, Team mode is triggered by
that request even if no fixed Team-mode phrase is used. Director requests for
subagents, team members, delegation, or Team-Native also activate the team
route.

Natural-language Director instructions are first-class route and intent signals,
but they are not magic words. The authorization-resolution record binds everyday
phrases such as "continue", "fix that first", "go back and repair this", "so
what now?", or `GO`, plus interface approvals and permission buttons, to the
current visible plan, station, blocker, diff, command, file set, scope, phase,
expiry, or protected action. The captain may surface the current visible scope
and route unresolved questions, but does not become the authorization
interpreter. If the current target, phase, scope, or expiry cannot be resolved,
the station remains plan-only, no-write, blocked, or unverified. The captain
must not force the Director to use artificial channel words when the visible
context is enough, and must not infer hidden write, hidden cleanup, later-phase,
or protected-state authority when the visible context is not enough.

Before any station edits a file with existing worktree changes, the trace must
show that the current diff and target section were read. If the requested change
touches an already modified section, the station must merge or rewrite that
section in place while preserving still-valid semantics. It must not create a
duplicate policy block, append a bypass paragraph, stack a new patch layer,
invent a sidecar file, or overwrite another change to avoid integration. A new
section is allowed only for a genuinely independent concept with no reasonable
existing section. If the current diff conflicts with the authorized task, the
station is blocked, unverified, or needs a narrower Director decision.

## Operation Mode Rule

Every Team-Native board records `operation_mode` before selecting board
template, board state, closeout lane, or station set.

```text
operation_mode -> board_template -> board_state -> closeout_lane -> station set
```

| Operation mode | Use when | Completion boundary |
|---|---|---|
| `daily` | Routine inspection, lightweight evidence, low-risk documentation alignment, generated-copy checks, or bounded governance drift with no source, workflow, skill, audit-rule, release, deployment, install, external-state, or protected mutation impact. | Reduced Team-Native evidence may close daily work only. It still requires a Captain board, `role_id`, handoff packet, trace evidence, `operation_mode_reason`, and explicit blocked/unverified states. It cannot claim full team completion unless the task itself does not require full station separation. |
| `full` | Implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, high-risk external state, or any work that changes source, workflow, memory/docs obligations, public contracts, generated copies, or completion semantics. | Full completion requires separated change delivery, validation, review, memory/docs, completion evidence, role identity evidence, and required trace evidence. |

`daily` is a reduced Team-Native mode, not a no-team shortcut. A `daily` board
that discovers full-only impact must promote to `full`, stop as blocked, or
return unverified evidence with the smallest promotion path. Missing
`operation_mode` is incomplete trace evidence; a trace that claims `complete`
without `operation_mode` is invalid.

## Team Topology And Reduction Rule

Team-Native work decomposes in this order: Captain Team Board -> station family
-> formal station -> sub-station task -> member allocation -> execution channel
-> delivery artifact. A station family groups related work such as scope,
implementation, validation, review, memory/docs, or completion. A formal
station is the authorized unit. A sub-station task is the smallest bounded
piece that one member can perform without crossing role boundaries. Member
allocation decides how many people or channels are assigned to that bounded
task. Execution channels are only routes for assigned members; they do not
create roles, authorization, or completion evidence by themselves.

Multiple members does not mean multiple subagents. A member can be a native
subagent, project custom agent, browser branch, CLI branch, MCP read path,
station-owned main-worktree change delivery route, isolated workspace, text
change delivery path, or other governed channel. The board records the member
role, role instance, assigned specialist skill,
sub-station task, channel request, channel capability, channel invocation
status, delivery artifact type, and delivery artifact status.

Reduction is allowed only at the sub-station task or member-count layer after
the formal station family remains visible. The captain may merge adjacent
sub-station tasks only when role exclusivity, delivery artifact ownership,
review independence, validation independence, and memory/docs attribution remain
intact. Speed, convenience, cost, small task size, lack of preference, or "the
captain already saw it" are not valid reduction reasons. Governance, workflow,
hook, validation, memory, release, deployment, install, protected-state, or
public-contract work must not be reduced into routine captain-direct work.

## Governed Team Activation Rule

When the Director asks for governed work or for Team-Native / subagent team
mode, the captain must create or reuse a team board before doing broad
context-heavy work or any team-scoped station work. The minimum activation is a
board row for each applicable station, a selected specialist skill, and an
attempted execution channel or an explicit standby/block record.

Board states are:

| Board state | Allowed work | Write authority |
|---|---|---|
| `draft` | Pre-GO planning, candidate stations, assumptions, and scope shaping | No write authority and no formal specialist evidence |
| `formal-readonly` | Read-only exploration, counter-evidence, impact mapping, document or file deep-read, external research, validation planning, review evidence, and standby specialist preparation | No source, memory, git, release, deployment, install, or external-state writes |
| `formal-write` | Resolved-scope station-owned main-worktree implementation change delivery, isolated/text change delivery, authorized change application, validation, review, memory/docs delivery, completion audit, and protected follow-on gates | Only the scoped target, phase, station, files, commands, or tool calls resolved by authorization |

The captain must not treat `formal-readonly` as weaker than team mode. It is
the formal team state for no-write work. If no execution channel can be opened,
the station is recorded as `blocked`, `unverified`, or `standby` with a smallest
unblock condition. The captain must not absorb the station into main-thread
direct work unless the board records a direct exception, replacement evidence,
residual risk, and non-complete or risk-closed state.

### Route And State Separation

Execution route fields may name only an actual channel or delivery form: native
subagent, project custom agent, adapter, browser evidence, command evidence, MCP
read, external research, station-owned main-worktree change delivery, isolated
change delivery, text change delivery artifact, platform-nondelegable
protected-action record, or station-owned authorized change-application gate.
`blocked`,
`unverified`, `standby`, `not-authorized`, `unavailable`, and
`closed-with-director-risk` are station, evidence, authorization, or completion
states only. They must not be stored as `execution_route`, `execution_channel`,
platform route, or execution mode. `direct` is also not an execution route or
station state; record it only as a `direct_exception` / `direct_exceptions`
entry with station-specific reason, replacement evidence, and residual state.

When a route cannot run, keep the attempted or requested route visible and move
the failure to `station_state`, `evidence_state`, `authorization_resolution_state`,
or `completion_state`. A missing or unavailable route never becomes routine
captain work, and it never supports a complete claim.

## Skill Handoff Packet Rule

Specialist identity is not a narrative label. Every formal station must receive
a skill handoff packet that names the operation mode, assigned role, role
instance, assigned specialist skill, loaded skill references, task row, read
scope, forbidden actions, output artifact format, startup threshold, and stop
condition. The handoff packet may be produced from
`team-station-handoff-packet` or an equivalent platform adapter, but it must be
visible in the board or delivery trace.

The packet must include these fields when applicable: `operation_mode`,
`operation_mode_reason`, `role_id`, `role_instance_id`,
`exclusive_task_scope`, `loaded_skill_refs`, `handoff_packet_id`,
`station_mode`, `context_visibility`, `handoff_ownership`,
`deep_read_scope`, `captain_coordination_read_scope`, `unread_scope`,
`startup_started_at`, `first_response_deadline`, `last_progress_at`,
`heartbeat_state`, `status_probe_state`, `soft_timeout_at`,
`hard_timeout_at`, `status_probe_resume_state`, `status_probe_resume_sent_at`,
`late_result_policy`, `cancellation_state`, `timeout_action`, and
`standby_reason`.

## Deep-Read And Captain Context Rule

Large or numerous files must not be fully loaded by the captain when a
bounded specialist deep-read station can inspect them first. The required split
is:

1. Specialist deep-read: read the assigned files or references, summarize
   evidence, unresolved scope, and exact citations.
2. Captain coordination read: inspect only the minimum snippets needed to
   receive the artifact, maintain the board, resolve blocker/authorization
   conflicts, or decide which station should handle a disputed claim.
3. Unread scope: list any relevant file, section, document, or external source
   not read by either party.

If no specialist route can deep-read the whole scope, keep the station
`blocked` or `unverified` with the smallest unblock condition. Director risk
closure may only record `closed-with-director-risk` for the named gap; a captain
direct read is coordination/direct-exception risk evidence only and must not be
treated as owner evidence for implementation, validation, review, memory/docs,
or completion.

While a member station is running, the captain must not perform context-expanding
parallel reads, duplicate scans, re-checks, substitute validation, substitute
review, memory/docs attribution, or rewrite member findings as captain-owned
evidence. Allowed captain actions during member work are limited to unblocking
the station, maintaining the board, receiving returned artifacts, and resolving
conflicts or authorization scope. Any broader captain context work is a direct
exception and cannot support full Team-Native completion.

### Captain-Lite Reading Model

Hooks and workflow adapters must separate reading from completion evidence:

- Micro-read: bounded single-file reads, named-file status checks, named-file
  hashes, small diff inspection, and narrow searches against explicitly named
  files are limited to route/location probes without a complete board. They do
  not authorize writes and do not become completion evidence by themselves.
  Micro-read explicitly excludes repository-wide grep, `git grep` or `rg`
  against the repository root, recursive `Get-Content`, recursive
  `Get-ChildItem` used as a file inventory, `rg --files`, `git ls-files`, and
  whole-repository file lists.
- Station-owned repository-scale evidence read: repository-wide file lists,
  recursive scans, broad grep, or large file sweeps require a formal-readonly
  board, assigned specialist deep-read station, handoff packet, role identity,
  assigned specialist skill, channel state, and lifecycle fields before the
  station-owned read starts and before the captain may ledger returned evidence.
  The captain's repository-scale role is limited to coordination/ledgering of
  returned artifacts and narrow cited-snippet checks. If a platform surfaces
  broad context before that trace exists, it is only non-authorizing route
  context until a qualified station returns evidence or a `direct_exception`
  record with residual state is recorded.
- Captain hard budget: the captain may perform only micro-read and coordination
  read by default. Coordination read is limited to receiving returned artifacts,
  checking cited snippets, maintaining the board, resolving blockers, and
  routing scope or authorization questions to the current policy or owner
  station. It must not become repository-wide grep,
  recursive reading, validation, review, memory/docs attribution, or completion
  evidence.
- Thin captain context is a hard cap, not a style preference. The captain's
  default context actions are micro-read, delivery artifact format checks,
  logging returned station output in the synthesis ledger, board updates,
  blocker handling, and scope-question routing. The captain must not use
  coordination read
  as a reason to deep-read entire files, reconstruct missing specialist work, or
  fill implementation, review, validation, or memory/docs gaps.
- Specialist deep-read: broad reads become qualified evidence only when the
  trace names `deep_read_scope`, handoff packet, `role_id`,
  `role_instance_id`, assigned specialist skill, requested execution channel,
  channel capability, and channel invocation status.
- Protected mutation: git, memory commit, release, deploy, install, destructive
  file operations, package publication, or external-state mutation require a
  protected authorization record for the current phase, target, scope, and
  closure state. A general formal-write board is not enough.

Authorization is resolved by `authorization-resolution.md` before any write,
change application, memory, git, release, deployment, install, MCP mutation,
or external-state mutation. Workflow names are route hints only, not
authorization. Interface approval buttons may be recorded as authorization
evidence for the exact displayed target, scope, phase, and expiry, but they do
not authorize unbounded writes or later protected phases. Platform mode is
capability context only and is not authorization.

If authorization source, target, scope, phase, evidence, expiry, or resolution
state is missing or inconsistent, the affected station is `no-write`,
`unverified`, or `blocked`; it must not proceed through direct captain work or
channel availability alone.

Specialist role authority comes from `team-specialist-registry` and the matching
`team-specialist-*` specialist skill. The ten specialist `role_id` values are
`intent-requirements`, `scope-impact`, `external-research`,
`architecture-contract`, `change-delivery`, `validation`, `review`,
`security-reliability`, `memory-docs`, and `release-completion`. Subagents,
browsers, CLI routes, MCP reads, main-worktree change delivery routes, isolated
workspaces, and text-only routes are execution channels for those specialist
stations; they are not role definitions and do not own governance decisions.

Specialist station assignment is not conditional on channel availability after
Team mode is active. Every applicable active-Team station must be
assigned to a specialist skill before channel selection. If the requested
channel cannot be invoked, the station remains on the board with `blocked`,
`unverified`, or `closed-with-director-risk`; it must not disappear and must not
become routine captain work.

Stations may be kept in `standby` when the specialist is assigned and the packet
is ready but the dispatch wave has not opened, the platform channel is warming
up, or the station is waiting for previous-wave input. Standby is a formal
lifecycle state, not a substitute for returned evidence.

## Station-First Rule

After Team mode activation by a governed Director request, before any specialist, subagent execution
channel, browser branch, CLI branch, MCP read evidence, main-worktree
change-delivery branch, isolated change-delivery branch, text change-delivery
artifact, validation, review, completion audit, commit preparation, or release
preparation starts, the captain must create the Captain Team Board from
`programming-team-governance` and `team-task-board`.

Pre-GO work uses a draft board. A draft board can structure planning and assumptions, but it cannot start formal specialists, satisfy validation/review/completion evidence, or support a full-team completion claim.

After GO, the captain must create or promote a formal dispatch board before
formal station work starts. Every applicable station records the canonical
station and trace fields defined by `team-task-board` and
`team-trace-evidence`. Core minimums are operation mode, board state, dispatch
wave, formal evidence eligibility, specialist role source, role identity,
authorization resolution, channel state, delivery artifact status, role
boundary, completion condition, and any direct exception. The full field catalog
must not be duplicated in core policy text.

The formal board opens only the current dispatch wave. Review, validation, memory/docs delivery, and completion stations that depend on a change must not start until the required change delivery artifact is returned or explicitly marked blocked, unverified, or closed-with-director-risk. A formal board is invalid when it launches all waves at once.

Each delivery ledger entry records the canonical delivery trace fields defined
by `team-task-board` and `team-trace-evidence`. Core minimums are delivery
artifact ID, author role, role identity, source input, integrable scope,
authorization resolution, review state, validation state, memory/docs state,
captain authoring state, dispatch wave, previous-wave input, and next-wave
condition. Detailed field catalogs stay in the referenced board and trace
sources instead of being repeated here.

The board must keep the topology explicit when work is split or reduced:
station family, formal station, sub-station task, member allocation, execution
channel, and returned delivery artifact are separate fields. Collapsing member
count does not collapse station families. A one-member station can still be
valid; a no-station captain shortcut is not valid for Team-Native completion.

## Tool Execution Envelope Rule

Tool layers may receive a `tool_execution_envelope` only as a structured carrier
for the current Team-Native board, station, handoff packet, role, channel
capability, authorization scope, and delivery status. The envelope is not a new
authorization source. It must mirror the current formal trace instead of
expanding it.

A tool execution envelope used for write-capable or protected mutation work
must include the current board and station identifiers, `handoff_packet_id`,
`role_id`, `role_instance_id`, assigned specialist skill,
`requested_execution_channel`, `channel_capability`,
`channel_invocation_status`, authorization source, authorization target,
authorization scope, authorization phase, authorization evidence,
authorization expiry, authorization resolution state, delivery artifact ID,
delivery artifact type, delivery artifact status, trusted issuer, signature,
nonce, and issued-at evidence.

A trusted envelope is one verified by the tool layer as coming from a trusted
issuer, with a valid signature and fresh nonce. Model-filled envelopes,
assistant-authored JSON, transcript text, or text-only `team_native_trace`
payloads are untrusted unless the platform verifies the trusted issuer,
signature, and nonce. Untrusted envelopes can explain context, but they cannot
authorize source writes, change application, memory, git, release,
deployment, install, MCP mutation, or external-state mutation.

Each tool action returns an `execution_receipt` that names the envelope or
nonce, requested action, allow/block decision, reason, resulting state, and
delivery artifact status. A receipt records execution evidence; it cannot
retroactively authorize a missing phase.

Invalid payload fail-closed rule: malformed payloads, missing envelopes, missing
trusted issuer, missing signature, missing nonce, stale nonce, scope mismatch,
or absent execution receipt keep write-capable and protected actions blocked or
unverified. After a block, any retry, channel switch, transcript substitution,
or alternate-tool attempt is a post-block bypass hard block unless current
scope-bound evidence or Director risk close evidence is supplied.

## Specialist Lifecycle Rule

Specialist stations are not disposable one-message helpers. A specialist channel
may be retained only when the same `role_id`, `role_instance_id`, station,
delivery artifact, wave, and role boundary remain the same. In the same task
trace or Captain Team Board, one specialist channel or role instance must not
hold more than one `role_id`. Reusing the same specialist channel is forbidden
when the role changes, the station crosses from implementation to review,
validation failure turns into implementation, memory/docs attribution turns into
protected memory mutation, completion audit turns into final closeout authority, or a
second independent opinion is required.

Every formal station records the specialist lifecycle state: `assigned`, `retained`, `reused`, `handoff-required`, `closed`, `replaced`, or `blocked`. The board also records retention reason, conversation health, reuse count, handoff summary, role-boundary check, and closure reason.

Channel wait timeouts are observability signals, not delivery failure,
cancellation, or rejection. Before a captain replaces a slow specialist
channel, the trace must show a status probe or an explicit reason the probe
cannot be sent. When a specialist receives a status probe, the specialist must
pause the current action, report where work stopped, whether it is blocked, and
whether it is safe to continue, then wait. The specialist may resume only after
the captain sends an explicit resume message for that channel. A channel that
responds to the probe is non-terminal and remains
`status_probe_resume_state: awaiting-resume` until the explicit captain resume
message changes `status_probe_resume_state` to `resume-sent` and then
`resumed`, `blocked`, or `unavailable`. Ongoing work after resume is recorded
in `station_state: running`; an extension request is recorded in
`status_probe_state: responded-extension-requested`. A channel that does not
respond is unresponsive or unobservable; it is not treated as failed unless a
hard timeout, explicit cancellation, or returned failure artifact exists.

Replacement does not cancel the original channel. The board must record the new
channel generation, replacement reason, whether the original channel was
cancelled, and the late-result policy. `ignore-after-cancelled` is valid only
when cancellation is acknowledged and the late-result window closes with no
artifact returned. If the original channel later returns an artifact, the
captain logs it, compares it with any replacement artifact, and records
`returned_at`, `return_timing`, `receipt_decision`, and
`receipt_decision_reason` as a neutral ledger decision such as logged,
included-in-synthesis-ledger, routed-to-owner-station,
superseded-by-replacement, duplicate, conflict-review, blocked, or unverified.
Completion claims require every opened channel to have a terminal closure,
late-result disposition, or visible non-complete residual state.

Every applicable formal station records `station_mode`, `context_visibility`,
and `handoff_ownership`. These fields decide whether a station is only
read-only, owns change delivery, is under a protected gate, has specialist
deep-read evidence, or has returned output for captain ledgering. Missing fields
keep the station blocked or unverified and cannot support `complete`.

Lifecycle decisions are soft-budgeted inside a single role instead of
hard-closing every channel. If the same `role_id` and delivery artifact can
continue with clear context, the station may be retained. If the captain or
specialist must reconstruct too much prior context, the station becomes
`handoff-required`. If the handoff summary is insufficient, the station is
`replaced`. If a role boundary or `role_id` would be crossed, the old station is
`closed` and a new independent role instance is opened in a later eligible wave.

## Fast Closeout Rule

Closeout is risk-tiered so Team-Native Core stays rigorous without mechanical all-agent relaunches.

| Closeout lane | Use when | Minimum stations |
|---|---|---|
| `light` | Documentation, generated-copy sync, Yellow drift, or low-risk governance wording with no release or external-state mutation | scope/impact, change delivery or sync delivery, validation, completion audit |
| `standard` | Multi-file policies, skills, matrices, audit rules, workflow semantics, or memory/docs impact | scope/impact, change delivery, memory/docs, validation, independent review, completion audit |
| `release-grade` | Commit, tag, release, deployment, install, external state, credentials, or public operator readiness | standard lane plus release completion and security/reliability |

Fast closeout never lowers the completion bar and does not replace
`operation_mode`. It only reduces unnecessary station churn inside the selected
mode. A light lane uses fewer stations only when the board records why review
or memory/docs is not applicable, or records the missing station as blocked,
unverified, or closed-with-director-risk. Any source, workflow, governance,
generated-copy, memory, or public-contract write promotes the lane to at least
`standard` and normally requires `operation_mode: full` unless the board records
a concrete non-full reason and does not claim full team completion.

## Yellow Signal Rule

Yellow findings are classified before repair loops start. Valid Yellow classifications are `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, and `informational`. A Yellow finding that affects the current completion claim, required Team-Native trace, independent review, validation, memory/docs attribution, public contract, deployment sync, or release readiness must be escalated to blocked, unverified, or Red instead of being treated as harmless Yellow.

The same Yellow finding must not create an unbounded repair loop. After two attempts on the same symptom family, file region, or operator path, the next action must be root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk. Validation and review stations report failures; they do not repair the core change they are validating or reviewing.

## Strict State Machine And Delivery Semantics

Team-Native Core keeps these states, exception records, and delivery forms
because they preserve completion honesty:

| Marker or state | Allowed use | Required evidence |
|---|---|---|
| `direct_exception` (`direct` only as legacy shorthand inside that field) | Captain coordination work only: request intake, station-task translation, board maintenance, dispatch, handoff and channel coordination, neutral station-output ledgering, blocker/permission routing, final Director-facing reporting, hot-path non-mutating status checks with no independent evidence value, or no independent evidence value after scope reduction. It never includes authorization decisions, protected-action execution, captain source authoring, repository-wide evidence work, implementation, review, validation, memory/docs attribution, quality disposition, or completion evidence. | Station name, direct exception reason, replacement evidence, and residual state |
| `main-worktree change delivery` | A named change-delivery station directly edits the main worktree under `formal-write` scope | Station-owned handoff, authorization phase `implementation-change-delivery`, exact file allowlist, dirty-diff read, forbidden protected actions, change ledger entry, memory impact, review need |
| `text change delivery artifact` | No governed isolated workspace is available, but the implementation task is bounded, diffable, and safe to deliver as a text change delivery artifact | File scope, proposed edits, evidence, risk, memory impact, review need, blocker status |
| `closed-with-director-risk` | The Director closes the task with a named risk even though required team separation or delivery artifacts are missing | Director risk decision, missing artifact or separation, non-complete label, and residual limitation |
| `unverified` | Evidence is required but currently absent or incomplete | Missing evidence, attempted route or reason not attempted, and smallest verification path |
| `blocked` | A required tool, permission, credential, isolation boundary, delivery artifact, or scope-bound authorization is unavailable | Blocking condition and smallest unblock requirement |
| `not-applicable` | The station does not belong to the task | Concrete non-applicability reason |

`direct_exception`, `closed-with-director-risk`, `main-worktree change
delivery`, and `text change delivery artifact` are not non-team shortcuts. They
are exception records, formal station states, or delivery forms with stricter
evidence requirements. Review lifecycle risk states do not become Team-Native
station, missing-artifact, completion, or capability states. Diff output may be
used only as an implementation representation; the governance object is the
change delivery artifact. `closed-with-director-risk` is never `complete`.

State labels are not fallback routes. If a template, trace, hook payload,
handoff packet, or report places `blocked`, `unverified`, `standby`,
`not-authorized`, `unavailable`, `closed-with-director-risk`, or `direct` into an
execution route field, the station is invalid until the route field is corrected
and the state is moved into a state field.

## Completion Rule

Full team completion requires:

1. Implementation change delivery artifact with memory impact.
2. Memory/docs delivery artifact with memory impact and memory delivery status.
3. Independent review delivery artifact from a reviewer who did not author the implementation.
4. Validation delivery artifact from a route that did not repair the implementation.
5. Completion audit covering scope, sync, docs, memory, drift, and residual risk.

`operation_mode: daily` can close daily work only within its reduced scope. It
must not be reported as full team completion for full-only work. `operation_mode:
full` is required for bottom-layer refactor, cross-file governance changes,
specialist skill rewrites, Doctor/Audit rule changes, release preparation, or
protected external-state readiness.

Station-owned main-worktree change delivery is the primary implementation path
when `formal-write` authorization binds the named change-delivery station,
authorization phase `implementation-change-delivery`, exact file allowlist,
dirty-diff read, forbidden protected actions, and
`handoff_ownership: station-owned`. The station writes the main worktree
directly and returns a change delivery artifact or ledger entry with memory impact;
review and validation inspect the resulting diff and do not re-apply it. If the
platform can only return a forked workspace or text artifact, the artifact must
be marked `fork-only` or `text-only`, must not be reported as applied to the
main worktree, and cannot support a main-worktree worker-write claim.

Change application is a fallback integration route, not the normal
implementation hop. Use a station-owned authorized change-application station
only to apply a returned isolated/text artifact, perform an explicitly scoped
integration task, or sync an assigned generated/deployed copy. A
platform-nondelegable protected-action record is allowed only when the platform
cannot delegate the physical write or protected tool call, and it only records
the scoped action without rewriting the returned artifact. The captain may log
station output, maintain the board, handle conflicts, and report status, but
must not turn station-output ledgering into
implementation, review, validation, or memory/docs evidence. Captain substitute
authoring means the captain creates specialist content because no qualified
change delivery route exists; it starts as blocked, may be
closed-with-director-risk only when the Director explicitly accepts that exact
case, and must not be described as full team completion.

Review and validation remain independent. They inspect the actual main-worktree
diff after main-worktree change delivery or after fallback integration. If only
a forked or text artifact exists, review and validation must say the artifact is
not applied and cannot validate applied source.

Rewriting, reauthoring, refactoring beyond the returned artifact, filling
missing implementation, adding unreturned review conclusions, inventing
validation evidence, or adding memory/docs attribution are captain substitute
authoring. These actions cannot support `complete`, even when the final text or
diff looks correct. They require a blocked, unverified, or
closed-with-director-risk record unless a qualified station returns the missing
delivery artifact.

If any required delivery artifact or independent review is missing, the task can only finish as blocked, unverified, or closed-with-director-risk. It must not be described as full team completion.

Protected follow-on phases require their own authorization resolution. A
returned implementation change delivery artifact or main-worktree change
delivery ledger entry does not authorize change application, memory writes,
memory commit, git, release, deployment, install, or external mutation.
Each protected phase must record scope-bound authorization or remain
blocked/unverified.

When a hook or platform guard blocks an action, the block is governance
evidence. The next valid captain response is to stop that action, report
blocked, unverified, or closed-with-director-risk with the missing structured
fields, and wait for scope-bound evidence or Director risk closure. The captain
must not retry through another tool, switch channels, use transcript text as
authorization, or claim progress as if the blocked station continued.

`closed-with-director-risk` requires current, explicit, scope-bound Director
risk close evidence. The evidence must name the residual risk, risk-closed scope,
and the missing artifact, validation, review, memory/docs, receipt, trusted
envelope, or authorization condition. It is never `complete` and never upgrades
an untrusted tool execution envelope into protected mutation authority.

## Platform Adapter Contract

Team-Native Core is platform-neutral. Platform differences do not activate Team
mode without a governed Director request and do not widen captain authority.
Once Team mode is active, platform capability only chooses a station channel or
a blocked/unverified state:

- Codex maps stations to native subagents, project custom agents, browser/terminal/MCP evidence, station-owned main-worktree change delivery, isolated workspaces, or text change delivery artifacts; unavailable channels become standby, blocked, or unverified station states.
- Claude maps stations to built-in/custom/plugin subagents, description-driven delegation, hooks/checkpoints, command evidence, station-owned main-worktree change delivery, isolated workspaces, or text change delivery artifacts; unavailable channels become standby, blocked, or unverified station states.
- Antigravity / Gemini maps stations through Gemini/Antigravity adapters, browser-capable agents, CLI evidence, plugin adapters, station-owned main-worktree change delivery, or text change delivery artifacts; unavailable channels become standby, blocked, or unverified station states.

Missing platform capability in active Team mode is not normal direct work. It is
blocked, unverified, or closed-with-director-risk with evidence.

## MCP Boundary

MCP tools are evidence or protected-action tools invoked by the captain path.
MCP servers are not team members. Mutating MCP tools require a scope-bound
intent signal, authorization resolution, the matching protected gate, and HITL
evidence when the platform requires it.

## Trace Requirement

Team-Native Core needs two kinds of verification:

1. Static governance checks: policy, skill, workflow, matrix, and documentation semantics.
2. Execution trace checks: a task-level board/delivery trace showing operation
mode, operation mode reason, draft/formal board state, dispatch waves,
previous-wave input, next-wave conditions, authorization
source/target/scope/phase/evidence/expiry/resolution state, observed platform
mode, specialist role source, `role_id`, `role_instance_id`,
`exclusive_task_scope`, delivery artifact IDs, author roles, source inputs,
integrable scopes, delivery artifact classes, review/validation/memory-docs
states, captain authoring state, role boundaries, direct exceptions, and
completion state.

When execution trace evidence is required and absent, validation is unverified or blocked.
