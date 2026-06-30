# Team-Native Core Policy

此檔定義 AI_Rules 的團隊原生核心。Team-Native Core 是跨平台治理主幹，不是單一子代理功能、單一工作流、或單一技能。

## Core Contract

Team-Native Core is the highest-priority governance spine for team work. Route
hints, platform modes, approval UI, tool capability, and prior conversation state
must be interpreted through Team-Native Core before source, workflow,
validation, review, memory, commit, release, deployment, install, project
governance, generated-copy, or public-contract work proceeds.

Team-Native Core is an execution precondition, not advisory prose. When it
applies, the next valid runtime state is a Captain Team Board with applicable
stations, handoff packets, and channel states. The captain must not perform
broad reading, impact mapping, implementation, validation, review, memory
attribution, commit preparation, release preparation, or completion claims first
and only document the team route afterward.

The shared workflow sequence is defined by
`Shared/policies/workflow-orchestration.md`. Team-Native Core remains the hard
gate; workflow orchestration defines the route -> authorization ->
operation_mode -> board_state -> dispatch wave -> delivery artifact -> closeout
order used by workflow entries and stations.

## Core Injection Hard Gate

Core injection rules must enforce the shortest Team-Native gate before any
skill, workflow, or platform adapter can soften it. Once Team-Native Core
applies, broad file reading, validation, review, memory/docs attribution,
completion audit, and completion claims may start only after the trace has a
Captain Team Board, applicable stations, a station handoff packet, role identity
(`role_id`, `role_instance_id`, and assigned specialist skill), and channel
state (`requested_execution_channel`, `channel_capability`,
`channel_invocation_status`, or an explicit standby/block state).

If any gate element is missing, the station or task can only be `blocked`,
`unverified`, or `closed-with-director-risk`. The captain must not absorb the
work into mainline direct execution and still claim Team-Native mode, full team
completion, or complete evidence.

Root-cause guard: if a platform cannot open a specialist channel, that is a
station state to report (`standby`, `blocked`, `unverified`,
`not-authorized`, or `unavailable`), not permission for silent captain-direct
work. The captain may continue direct work only after the board names the
missing route, replacement evidence, residual risk, and smallest unblock
condition.

Team-Native Core applies when a task touches source, workflow, validation, review, memory, commit, release, deployment, install, project governance, generated copies, or public contracts.

Team-Native Core also applies to read-only exploration, blueprinting, broad file
inspection, external research, or impact analysis when the result can shape
later source, workflow, validation, review, memory, release, or governance work.
No-write status limits the allowed actions; it does not cancel team-mode
station assignment.

Chat-originated requests are not exempt. 00 direct chat remains available only
for pure conversation and lightweight answers that do not require external
evidence and will not shape later governance. If a chat request touches files,
screenshots, memory/context cards, rules/workflows/policies, agent/subagent
behavior, evidence checks, source/tool output, or later governance impact, it
must enter `formal-readonly` team mode: the specialist performs bounded reading
or checking, returns citations, missing scope, risk, blocker status, and
evidence status reporting, and the captain only verification-reads returned
evidence and integrates the conclusion. 證據型對話不得停留在直答模式；若隊員通道無法開啟，必須先回報 standby、blocked、unverified、unavailable 或 not-authorized。

The required delivery sequence is fixed: Director instruction -> captain intake -> translation -> board creation -> specialist station assignment -> station handoff packet -> execution-channel decision -> specialist startup attempt, standby, or blocked/unverified channel state -> specialist work -> captain verification-read -> recovered change delivery artifacts / evidence delivery artifacts -> independent validation and review -> captain integration -> completion audit -> report.

The captain remains the only Director-facing owner, but the captain is not the default worker and must not author specialist implementation, review, validation, or memory attribution when a delivery artifact can be produced. The captain owns routing, authorization, supervision, protected integration of recovered delivery artifacts, protected memory/git/release/deploy/install gates, review-state decision, and final acceptance. All separable requirement replay, counter-evidence, impact mapping, implementation change delivery, memory delivery, validation, review, and completion audit work belongs to team stations.

Explicit workflow names and Director requests for subagents are route hints. They do not replace the team board and do not authorize pre-board dispatch.

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

## Team-First Activation Rule

When Team-Native Core applies, the captain must attempt team activation before
doing broad context-heavy work. The minimum activation is a board row for each
applicable station, a selected specialist skill, and an attempted execution
channel or an explicit standby/block record.

Board states are:

| Board state | Allowed work | Write authority |
|---|---|---|
| `draft` | Pre-GO planning, candidate stations, assumptions, and scope shaping | No write authority and no formal specialist evidence |
| `formal-readonly` | Read-only exploration, counter-evidence, impact mapping, document or file deep-read, external research, validation planning, review evidence, and standby specialist preparation | No source, memory, git, release, deployment, install, or external-state writes |
| `formal-write` | GO-backed implementation change delivery, captain integration, validation, review, memory/docs delivery, completion audit, and protected follow-on gates | Only the scoped target, phase, station, files, commands, or tool calls resolved by authorization |

The captain must not treat `formal-readonly` as weaker than team mode. It is
the formal team state for no-write work. If no execution channel can be opened,
the station is recorded as `blocked`, `unverified`, or `standby` with a smallest
unblock condition. The captain reports the unavailable route before absorbing
the station into main-thread direct work.

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
`deep_read_scope`, `captain_verify_read_scope`, `unread_scope`,
`startup_started_at`, `first_response_deadline`, `last_progress_at`,
`timeout_action`, and `standby_reason`.

## Deep-Read And Captain Verify Rule

Large or numerous files must not be fully loaded by the captain when a
bounded specialist deep-read station can inspect them first. The required split
is:

1. Specialist deep-read: read the assigned files or references, summarize
   evidence, unresolved scope, and exact citations.
2. Captain verify-read: inspect the highest-risk snippets, changed regions, or
   disputed claims before integration or final acceptance.
3. Unread scope: list any relevant file, section, document, or external source
   not read by either party.

If the captain must deep-read the whole scope directly because no channel can
open, the station records a direct exception and the completion state cannot
claim full team separation unless the Director closes that named risk.

### Captain-Lite Reading Model

Hooks and workflow adapters must separate reading from completion evidence:

- Micro-read: bounded single-file reads, narrow searches, status checks, hashes,
  and small diff inspection are limited to read-only probes without a complete
  board. They do not authorize writes and do not become completion evidence by
  themselves.
- Captain broad-read: repository-wide file lists, recursive scans, broad grep,
  or large file sweeps are permitted only as read-only context recovery. The
  captain must route the result to a formal-readonly specialist deep-read
  station or record a direct exception before making completion claims.
- Specialist deep-read: broad reads become qualified evidence only when the
  trace names `deep_read_scope`, handoff packet, `role_id`,
  `role_instance_id`, assigned specialist skill, requested execution channel,
  channel capability, and channel invocation status.
- Protected mutation: git, memory commit, release, deploy, install, destructive
  file operations, package publication, or external-state mutation require a
  protected authorization record for the current phase, target, scope, and
  closure state. A general formal-write board is not enough.

Authorization is resolved by `authorization-resolution.md` before any write,
protected integration, memory, git, release, deployment, install, MCP mutation,
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
browsers, CLI routes, MCP reads, isolated workspaces, and text-only routes are
execution channels for those specialist stations; they are not role definitions
and do not own governance decisions.

Specialist station assignment is not conditional on channel availability. Once Team-Native Core applies, every applicable station must be assigned to a specialist skill before channel selection. If the requested channel cannot be invoked, the station remains on the board with `blocked`, `unverified`, or `closed-with-director-risk`; it must not disappear and must not become routine captain work.

Stations may be kept in `standby` when the specialist is assigned and the packet
is ready but the dispatch wave has not opened, the platform channel is warming
up, or the station is waiting for previous-wave input. Standby is a formal
lifecycle state, not a substitute for returned evidence.

## Station-First Rule

Before any specialist, subagent execution channel, browser branch, CLI branch, MCP direct evidence, isolated change-delivery branch, text change-delivery artifact, validation, review, completion audit, commit preparation, or release preparation starts, the captain must create the Captain Team Board from `programming-team-governance` and `team-task-board`.

Pre-GO work uses a draft board. A draft board can structure planning and assumptions, but it cannot start formal specialists, satisfy validation/review/completion evidence, or support a full-team completion claim.

After GO, the captain must create or promote a formal dispatch board before formal station work starts. Every applicable station records operation mode, operation mode reason, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, evidence owner, specialist role source, assigned specialist skill, `role_id`, `role_instance_id`, `exclusive_task_scope`, domain label, authorization source, authorization target, authorization scope, authorization phase, authorization evidence, authorization expiry, authorization resolution state, observed platform mode, requested execution channel, channel capability, channel invocation status, execution channel, delivery artifact type, delivery artifact status, role boundary, completion condition, and any direct exception.

The formal board opens only the current dispatch wave. Review, validation, memory/docs delivery, and completion stations that depend on a change must not start until the required change delivery artifact is returned or explicitly marked blocked, unverified, or closed-with-director-risk. A formal board is invalid when it launches all waves at once.

Each delivery ledger entry records delivery artifact ID, author role, `role_id`,
`role_instance_id`, source input, integrable scope, authorization source,
authorization target, authorization scope, authorization phase, authorization
evidence, authorization expiry, authorization resolution state, observed
platform mode, review state, validation state, memory/docs state, whether the
captain authored specialist content, dispatch wave, previous-wave input, and
next-wave condition. These fields make relationship checks auditable instead of
relying on narrative claims.

## Specialist Lifecycle Rule

Specialist stations are not disposable one-message helpers. A specialist channel
may be retained only when the same `role_id`, `role_instance_id`, station,
delivery artifact, wave, and role boundary remain the same. In the same task
trace or Captain Team Board, one specialist channel or role instance must not
hold more than one `role_id`. Reusing the same specialist channel is forbidden
when the role changes, the station crosses from implementation to review,
validation failure turns into implementation, memory/docs attribution turns into
protected memory mutation, completion audit turns into final acceptance, or a
second independent opinion is required.

Every formal station records the specialist lifecycle state: `assigned`, `retained`, `reused`, `handoff-required`, `closed`, `replaced`, or `blocked`. The board also records retention reason, conversation health, reuse count, handoff summary, role-boundary check, and closure reason.

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
mode. A light lane may use fewer stations only when the board records why review
or memory/docs is not applicable, or records the missing station as blocked,
unverified, or closed-with-director-risk. Any source, workflow, governance,
generated-copy, memory, or public-contract write promotes the lane to at least
`standard` and normally requires `operation_mode: full` unless the board records
a concrete non-full reason and does not claim full team completion.

## Yellow Signal Rule

Yellow findings are classified before repair loops start. Valid Yellow classifications are `fix-this-cycle`, `residual-accepted`, `deferred-follow-up`, `local-customization`, and `informational`. A Yellow finding that affects the current completion claim, required Team-Native trace, independent review, validation, memory/docs attribution, public contract, deployment sync, or release readiness must be escalated to blocked, unverified, or Red instead of being treated as harmless Yellow.

The same Yellow finding must not create an unbounded repair loop. After two attempts on the same symptom family, file region, or operator path, the next action must be root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk. Validation and review stations report failures; they do not repair the core change they are validating or reviewing.

## Strict State Machine

Team-Native Core keeps these states because they preserve completion honesty:

| State | Allowed use | Required evidence |
|---|---|---|
| `direct` | Protected captain work only: Director communication, GO interpretation, main-worktree integration of returned delivery artifacts, protected memory/git/release/deploy/install gates, review-state decision, final acceptance, hot-path non-mutating validation, or no independent evidence value after scope reduction | Station name, direct exception, replacement evidence, and residual state |
| `text change delivery artifact` | No governed isolated workspace is available, but the implementation task is bounded, diffable, and safe to deliver as a text change delivery artifact | File scope, proposed edits, evidence, risk, memory impact, review need, blocker status |
| `closed-with-director-risk` | The Director closes the task with a named risk even though required team separation or delivery artifacts are missing | Director risk decision, missing artifact or separation, non-complete label, and residual limitation |
| `unverified` | Evidence is required but currently absent or incomplete | Missing evidence, attempted route or reason not attempted, and smallest verification path |
| `blocked` | A required tool, permission, credential, isolation boundary, delivery artifact, or scope-bound authorization is unavailable | Blocking condition and smallest unblock requirement |
| `not-applicable` | The station does not belong to the task | Concrete non-applicability reason |

`direct`, `closed-with-director-risk`, and `text change delivery artifact` are not non-team shortcuts. They are formal station states or delivery forms with stricter evidence requirements. Review lifecycle risk states do not become Team-Native station, missing-artifact, completion, or capability states. Diff output may be used only as an implementation representation; the governance object is the change delivery artifact. `closed-with-director-risk` is never `complete`.

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

Captain protected integration means integrating returned, qualified delivery artifacts into the main worktree and remains normal captain work; it can support `complete` when implementation, memory/docs, review, validation, completion, and trace evidence are all present. Captain substitute authoring means the captain creates specialist content because no qualified change delivery route exists; it starts as blocked, may be closed-with-director-risk only when the Director explicitly accepts that exact case, and must not be described as full team completion.

If any required delivery artifact or independent review is missing, the task can only finish as blocked, unverified, or closed-with-director-risk. It must not be described as full team completion.

Protected follow-on phases require their own authorization resolution. A
returned implementation change delivery artifact does not authorize captain
integration, memory writes, memory commit, git, release, deployment, install, or
external mutation. Each protected phase must record scope-bound authorization or
remain blocked/unverified.

## Platform Adapter Contract

Team-Native Core is platform-neutral. Platforms may differ in native capability:

- Codex maps stations to native subagents, project custom agents, browser/terminal/MCP evidence, isolated workspaces, or text change delivery artifacts when available.
- Claude maps stations to built-in/custom/plugin subagents, description-driven delegation, hooks/checkpoints, command evidence, isolated workspaces, or text change delivery artifacts when available.
- Antigravity / Gemini maps stations through Gemini/Antigravity adapters, browser-capable agents, CLI evidence, plugin adapters, or text change delivery artifacts when available.

Missing platform capability is not normal direct work. It is blocked, unverified, or closed-with-director-risk with evidence.

## MCP Boundary

MCP tools are evidence or protected-action tools invoked by the captain path. MCP servers are not team members. Mutating MCP tools remain behind GO and HITL gates.

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
