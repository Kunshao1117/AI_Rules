# Team Trace Evidence Contract

此檔定義 Team-Native Core 的任務軌跡證據格式。它是唯讀稽核目標，不是執行器。

## Purpose

Static rules can prove that the framework text is present. They cannot prove that a specific task actually followed the required sequence: Director instruction -> captain intake -> translation -> board creation -> specialist station assignment -> execution-channel decision -> specialist work or blocked/unverified channel state -> captain supervision -> returned change delivery artifacts / evidence delivery artifacts -> captain receipt and board update -> independent validation and review -> completion audit -> report. Team trace evidence fills that gap.

`Shared/policies/workflow-orchestration.md` owns the runtime sequence that this
trace records: route -> authorization -> operation_mode -> board -> dispatch
wave -> handoff packet -> channel state -> delivery artifact -> completion.

Trace evidence also proves that authorization was scope-bound. Workflow names,
interface approval buttons, platform modes, and channel availability are recorded
as evidence or context only; none of them authorizes unbounded writes or
protected follow-on phases by itself.

When Team-Native / subagent team mode is active because the Director asked for
governed work or team dispatch, a trace must show formal station assignment and
channel state, or an explicit standby, blocked, unverified, not-applicable, or
Director-risk-closed state. Missing subagent, browser, CLI, MCP, isolation, or
text-delivery capability is trace evidence to record; it is not permission to
omit the station or claim captain-direct completion. When Team mode is not
active because the request is pure conversation, a small stable answer, or
no-impact read-only work, captain/team-board trace fields are not required and
must not be cited as Team-Native completion evidence.

## Required Location

Task traces must be written under `.agents/logs/team-traces/` when the active workflow permits log output. Logs are task evidence, not source memory. Durable source facts still belong in `.agents/memory/` after the memory phase.

## Minimal Trace Fields

Each task trace must contain these fields in readable Markdown or JSON:

Canonical field names remain English for machine trace stability. Director-facing
summaries and reports must show the Traditional Chinese meaning first and keep
the canonical field in parentheses, such as `站點狀態（station_state）`.
Raw English-only field lists are acceptable only inside machine-readable trace
payloads or policy tables, not as the Director-facing explanation.

| Field | Required content |
|---|---|
| `task_id` | Stable task identifier or timestamp |
| `task_type` | discussion, exploration, blueprint, build-plan, implementation, fix-debug, validation-audit, commit-release, or handoff-skill |
| `workflow_route` | Workflow or semantic route used as a route hint |
| `operation_mode` | `daily` for reduced routine Team-Native work, or `full` for complete Team-Native work |
| `operation_mode_reason` | Why daily mode is allowed, or why full mode is required |
| `board_state` | draft or formal |
| `implementation_authorization` | no-write, plan-only, scope-resolved-write, scope-resolved-push, release-authorized, or blocked |
| `go_evidence` | Prompt, workflow authorization, or blocked state |
| `authorization_source` | Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source |
| `authorization_target` | Exact target of the authorization, such as file allowlist, station, protected action, or external resource |
| `authorization_scope` | Concrete allowed operation boundary, including files, directories, generated copies, memory cards, commands, release actions, or none |
| `authorization_phase` | plan-only, implementation-change-delivery, change-application, validation, review, memory-docs, memory-commit, git, release, deployment, install, external-mutation, or blocked |
| `authorization_evidence` | Prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason |
| `authorization_expiry` | Current turn, current dispatch wave, named file set, named command, named protected action, explicit revocation, or blocked/unverified expiry |
| `authorization_resolution_state` | authorized, no-write, scope-mismatch, phase-mismatch, expired, unverified, blocked, or revoked |
| `platform_mode_observed` | Observed platform mode or capability context, recorded only as context and never as authorization |
| `specialist_role_source` | `team-specialist-registry` entry and matching `team-specialist-*` skill, or blocked/unverified reason |
| `specialist_skill` | Exact specialist child skill selected from the registry, or blocked/unverified reason |
| `role_id` | One of the registered ten specialist roles, such as `intent-requirements`, `change-delivery`, `review`, or blocked/unverified reason |
| `role_instance_id` | Unique role instance for this task trace; a role instance must not hold multiple `role_id` values in the same task |
| `exclusive_task_scope` | Usually `task`, proving the specialist role instance is exclusive within the current task trace or blocked/unverified reason |
| `loaded_skill_refs` | Skill refs or paths passed to the specialist instead of narrative-only identity |
| `handoff_packet_id` | Required for every formal station: station handoff packet ID, or blocked/unverified reason when the station cannot be dispatched |
| `domain_label` | Domain label used for the station, such as governance rules, platform capability, testing automation, memory governance, documentation, architecture quality, or external information |
| `requested_execution_channel` | Requested channel before capability evaluation |
| `channel_capability` | available, conditional, unavailable, or unverified |
| `channel_invocation_status` | not-started, requested, running, returned, unavailable, blocked, or not-authorized |
| `channel_run_id` | Unique identifier for one concrete execution-channel attempt, including native subagent, adapter, CLI, browser, MCP read, station-owned main-worktree change delivery, isolated workspace, text artifact, or change-application gate |
| `channel_generation` | Original or replacement generation number for the same station and role instance |
| `replaces_channel_run_id` | Prior channel run replaced by this run, or not-applicable |
| `replacement_reason` | Why a replacement channel was opened, such as unresponsive, hard-timeout, role-boundary, stale context, blocked route, or not-applicable |
| `execution_route` | Actual channel or delivery form; never a status value such as blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk |
| `execution_channel` | Native subagent, project custom agent, tool/MCP, command evidence, browser evidence, external research, station-owned main-worktree change delivery, isolated change delivery, text change delivery, station-owned authorized change-application gate, or protected captain gate |
| `tool_execution_envelope` | Structured carrier passed to a tool layer, or blocked/unverified reason when no envelope is available. |
| `tool_execution_envelope_trust` | trusted, untrusted, blocked, unverified, or not-applicable. |
| `tool_envelope_issuer` | Trusted issuer identity, or blocked/unverified reason. |
| `tool_envelope_signature` | Signature or verification reference, or blocked/unverified reason. |
| `tool_envelope_nonce` | Fresh nonce or replay-protection reference, or blocked/unverified reason. |
| `execution_receipt` | Tool-layer receipt naming envelope or nonce, action, decision, reason, resulting state, and delivery artifact status. |
| `execution_receipt_decision` | allowed, blocked, unverified, not-authorized, or not-applicable. |
| `station_state` | assigned, standby, running, returned, blocked, unverified, closed-with-director-risk, or not-applicable |
| `evidence_state` | pending, returned, accepted, rejected, blocked, unverified, closed-with-director-risk, or not-applicable |
| `station_lifecycle_state` | assigned, standby, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable |
| `station_mode` | Station posture: `read-only`, `change-delivery`, `change-application`, `validation`, `review`, `memory-docs`, `completion`, `protected-gate`, or `not-applicable` |
| `handoff_ownership` | Current handoff owner: `station-owned`, `captain-owned-gate`, `returned-to-captain`, `reassigned`, `blocked`, `unverified`, or `not-applicable` |
| `context_visibility` | Scope visibility: `specialist-deep-read`, `captain-coordination-only`, `shared-visible`, `unread`, or `not-applicable` |
| `retention_reason` | Why the same specialist channel may continue, or why retention is not allowed |
| `conversation_health` | clear, needs-handoff, stale, over-budget, role-conflict, or blocked |
| `reuse_count` | Number of times the same specialist channel was reused for the same role and delivery artifact |
| `handoff_summary` | Required when a station is retained across a long conversation or replaced |
| `closure_reason` | Completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable |
| `deep_read_scope` | Files, docs, logs, or external sources assigned to specialist deep-read |
| `captain_coordination_read_scope` | Narrow coordination read scope for artifact receipt, board maintenance, blocker handling, conflict resolution, or authorization boundaries; it is not validation, review, memory/docs attribution, or completion evidence |
| `unread_scope` | Relevant scope not read by the specialist or captain |
| `startup_started_at` | Local timestamp when the station channel was requested |
| `first_response_deadline` | Expected first useful response or heartbeat deadline |
| `first_response_at` | Local timestamp when the first useful response or heartbeat arrived, or not-returned |
| `last_progress_at` | Latest progress evidence timestamp or blocked reason |
| `heartbeat_state` | not-required, pending, received, overdue, unavailable, or not-applicable |
| `status_probe_state` | not-sent, sent, paused-reported, responded-paused, awaiting-resume, responded-extension-requested, responded-blocked, unresponsive, unavailable, or not-applicable |
| `status_probe_sent_at` | Local timestamp when the captain asked the channel for status after uncertainty or timeout, or not-applicable |
| `status_probe_response_at` | Local timestamp when the channel responded to the status probe, or not-returned |
| `status_probe_pause_report` | Specialist report after a status probe: current stop point, blocker state, and whether continuing is safe, or not-applicable |
| `status_probe_resume_state` | not-required, awaiting-captain-resume, resume-sent, resumed, blocked, unavailable, or not-applicable |
| `status_probe_resume_sent_at` | Local timestamp when the captain explicitly sent resume to the probed channel, or not-returned |
| `soft_timeout_at` | Local timestamp for the monitoring timeout that triggers a status probe or standby decision |
| `hard_timeout_at` | Local timestamp after which the station may close, cancel, replace, or remain non-complete with residual risk |
| `timeout_action` | standby, replace, blocked, unverified, Director input, or not-applicable |
| `late_result_policy` | receive-and-compare, accept-until-hard-timeout, ignore-after-cancelled, blocked, unverified, or not-applicable |
| `late_result_window` | Time or condition under which a late artifact from the original channel must still be received |
| `cancellation_state` | not-requested, requested, acknowledged, ignored, unavailable, or not-applicable |
| `returned_at` | Local timestamp when a delivery artifact was returned, or not-returned |
| `return_timing` | on-time, late, not-returned, or not-applicable |
| `receipt_decision` | accepted, integrated, superseded-by-replacement, rejected-scope, duplicate, conflict-review, blocked, unverified, or not-applicable |
| `receipt_decision_reason` | Why the returned or late artifact was accepted, superseded, rejected, marked duplicate, or routed to conflict review |
| `conflict_with_artifact_id` | Artifact ID that conflicts with this returned artifact, or not-applicable |
| `final_channel_closure_reason` | Completed delivery, superseded, cancelled, hard-timeout, role conflict, blocked, unverified, Director risk close, or not-applicable |
| `standby_reason` | Why an assigned station is waiting for dispatch wave, prior input, channel warmup, or external unblock |
| `closeout_lane` | light, standard, release-grade, or not-applicable |
| `yellow_classification` | fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable |
| `yellow_resolution_state` | fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable |
| `repair_loop_count` | Number of attempts for the same symptom family, file region, or operator path |
| `delivery_artifact` | Intent, scope, architecture, change, validation, review, memory, documentation, completion, or evidence delivery artifact |
| `delivery_artifact_id` | Stable identifier for the recovered or missing delivery artifact |
| `delivery_artifact_status` | pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable |
| `author_role` | Registered specialist role that authored the delivery artifact, or blocked/unverified reason |
| `source_input` | Prior delivery artifact, approved plan, file scope, trace entry, or blocked input used by this station |
| `integrable_scope` | Exact scope the station-owned authorized change-application gate may apply from this delivery artifact; use none when it is evidence-only or blocked |
| `review_state` | not-started, pending, accepted, fix-required, blocked, unverified, accepted-risk, or not-applicable. accepted-risk is a review lifecycle judgment only; it is not a Team-Native station status, delivery artifact status, or completion status |
| `validation_state` | not-started, pending, passed, failed, blocked, unverified, or not-applicable |
| `memory_docs_state` | not-started, memory_delivery, blocked, unverified, closed-with-director-risk, or not-applicable |
| `captain_authored` | false, blocked, unverified, or closed-with-director-risk statement; true cannot support full completion |
| `no_captain_authoring` | true/blocked/unverified/closed-with-director-risk statement proving the captain did not author specialist implementation, review, validation, or memory attribution work |
| `stations` | Station list with applicability, execution mode, execution channel, owner, role boundary, direct exception, and completion condition |
| `waves` | Dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility |
| `delivery_artifacts` | Change delivery, memory/docs delivery, review, validation, evidence delivery, and completion artifact status |
| `direct_exceptions` | Station-specific direct exception, replacement evidence, and residual state |
| `role_separation` | Evidence that implementation and review did not share the same role |
| `captain_artifact_receipt_risk` | Legacy-risk field; use only to record not-applicable or a non-complete blocked/unverified risk when old captain artifact-application wording appears in a trace |
| `captain_context_burden` | none, coordination-only, or direct-exception; records whether the captain avoided parallel reads, duplicate scans, re-checks, substitute validation/review, memory/docs attribution, and rewriting member findings as captain-owned evidence |
| `captain_substitute_authoring` | blocked by default; closed-with-director-risk only with case-specific Director approval and no full-team-completion claim |
| `completion_state` | complete, closed-with-director-risk, blocked, unverified, or not-applicable |
| `risk_close_evidence` | Current, explicit, scope-bound Director risk close evidence when `closed-with-director-risk` is used. |
| `residual_risk` | Remaining blocked, unverified, or closed-with-director-risk items |
| `source_deployed_pair` | Source file and deployed copy pair when a generated/runtime copy is affected |
| `sync_direction` | source-to-deployed, deployed-to-source-backfill, not-applicable, blocked, or unverified |
| `sync_evidence` | Hash, content parity, diff summary, or blocked/unverified reason for the pair |

## Hard Gate Requirements

- Formal stations must carry `handoff_packet_id`; a narrative-only handoff is not enough.
- Formal station startup is complete only when the handoff packet or
  board-linked handoff evidence includes `handoff_packet_id`, `role_id`,
  `role_instance_id`, `assigned_specialist_skill`, `read_scope`,
  `allowed_tools`, `forbidden_actions`, channel state
  (`requested_execution_channel`, `channel_capability`, and
  `channel_invocation_status`, or an explicit blocked/unverified reason),
  `station_mode`, `context_visibility`, `handoff_ownership`,
  `delivery_artifact_type`, and `stop_condition`. Missing any of these keeps
  the station blocked or unverified and cannot support a complete Team-Native
  trace.
- A wait timeout or missing first response is not failure evidence by itself.
  Before opening a replacement due to slow or unknown progress, the trace must
  record `status_probe_state`, `status_probe_sent_at`, and the response or the
  reason status probing is unavailable. Missing probe evidence keeps the
  original channel unverified, not failed.
- A status probe pauses the probed specialist channel. A responding specialist
  must record `status_probe_pause_report` with the current stop point, blocker
  state, and safe-to-continue judgment, then wait for
  `status_probe_resume_state: resume-sent` and `status_probe_resume_sent_at`
  before resuming. Work performed after a probe response without explicit
  captain resume evidence is not valid specialist delivery evidence.
- Replacement does not cancel the replaced channel. Any replacement must record
  `channel_generation`, `replaces_channel_run_id`, `replacement_reason`,
  `late_result_policy`, and `cancellation_state`; otherwise the station cannot
  support `complete`.
- Late returned artifacts must be received into the trace with `returned_at`,
  `return_timing`, `receipt_decision`, and `receipt_decision_reason`. Ignoring a
  late artifact without cancellation or hard-timeout evidence blocks completion.
- A completion claim must show every opened channel has a terminal
  `final_channel_closure_reason`, accepted late-result disposition, or an
  honest blocked/unverified/closed-with-director-risk residual state.
- Any completion claim missing `station_mode`, `context_visibility`, or
  `handoff_ownership` for an applicable formal station is invalid.
- In active Team mode, `operation_mode: full`, governance-impact
  implementation, Doctor/Audit rule changes, routine audit rule readiness, and
  commit/release preparation require Team-Native trace evidence. Missing trace
  is a blocked Red audit finding, not a Yellow advisory.
- A completion claim must expose parseable `stations`, `delivery_artifacts`, `role_instance_id`, `delivery_artifact_id`, and `direct_exceptions`. The values may close as blocked, unverified, closed-with-director-risk, or not-applicable only when the trace is not claiming full completion.
- `completion_state` is limited to `complete`, `closed-with-director-risk`, `blocked`, `unverified`, or `not-applicable`. `completed`, `done`, `accepted-risk`, and other informal states must not pass as completion evidence.
- Two or more evidence-oriented stations marked direct require station-specific `direct_exceptions`, replacement evidence, and residual state. Without them, the trace is invalid for formal acceptance.
- `execution_route` and `execution_channel` must not contain state values.
  Missing route capability belongs in `station_state`, `evidence_state`,
  `authorization_resolution_state`, or `completion_state`.
- Write-capable or protected mutation traces must include a trusted
  `tool_execution_envelope`, trusted issuer, signature, nonce, and matching
  `execution_receipt`; missing or untrusted envelope evidence keeps the action
  blocked or unverified.
- Main-worktree source writes through implementation change delivery must record
  `station_mode: change-delivery`, `handoff_ownership: station-owned`,
  authorization phase `implementation-change-delivery`, exact file allowlist,
  dirty-diff read evidence, and forbidden protected actions. Fallback
  change-application must record `station_mode: change-application`,
  `handoff_ownership: station-owned`, authorization phase
  `change-application`, exact file allowlist, dirty-diff read evidence, and a
  source input that is a returned isolated/text artifact, explicit integration
  task, or assigned generated/deployed sync. A protected captain gate for the
  same write requires evidence that the platform cannot delegate the physical
  write or protected tool call.
- Invalid payload fail-closed evidence is required when a malformed or
  unverifiable tool payload is part of the trace. A trace must not recover
  authority from model-filled envelope text, historical transcript text, or a
  text-only trace.
- `closed-with-director-risk` requires `risk_close_evidence` that is current,
  explicit, and scope-bound. It remains non-complete.
- Source/deployed changes require `source_deployed_pair`, `sync_direction`, and
  `sync_evidence`; missing parity blocks completion.

## Audit Semantics

The trace audit is read-only. It must classify evidence as:

| Result | Meaning |
|---|---|
| `passed` | Required trace exists and contains board, wave, delivery artifact, role, channel, and completion evidence |
| `unverified` | Trace is absent or incomplete but the task can still be discussed honestly |
| `blocked` | Trace is required for completion, commit, release, or acceptance but is absent |
| `not-applicable` | The task is pure discussion or another non-team-triggering answer |

## Invalid Trace Patterns

These patterns must not pass:

- Formal completion without change delivery, memory/docs delivery, review, and validation delivery artifact states.
- Draft-board evidence counted as formal acceptance.
- Implementation and review owned by the same role in any trace claiming `complete`.
- Review or validation started before the required change delivery artifact exists, except when the station is explicitly auditing a blocked/unverified missing-artifact state.
- Two or more evidence-oriented stations marked direct without station-specific exception, replacement evidence, and residual state.
- Missing previous-wave input or next-wave start condition on a formal board.
- Captain substitute authoring described as full team completion.
- Captain substitute authoring recorded as change delivery, validation, review,
  memory/docs evidence, or completion evidence.
- Missing independent review described as complete instead of blocked, unverified, or closed-with-director-risk.
- Subagent, browser, CLI, or MCP route described as the specialist role instead of the execution channel for a registered specialist.
- Missing channel capability or channel invocation status for an applicable station.
- Missing loaded skill refs or handoff packet for a formal specialist station.
- Missing `handoff_packet_id` on any formal station.
- Missing `station_mode`, `context_visibility`, or `handoff_ownership` on an
  applicable formal station.
- A completion claim that relies on captain coordination read while
  `context_visibility` does not show specialist deep-read, shared-visible
  evidence, or an accepted non-complete risk state.
- Reusing a role instance after `handoff_ownership` changes across station owner
  classes.
- Main-worktree source changes made by a member station without either
  `station_mode: change-delivery`, `handoff_ownership: station-owned`, exact
  file allowlist, dirty-diff read, and `implementation-change-delivery`
  authorization, or a fallback `station_mode: change-application` path with
  returned-artifact/integration/sync input and `change-application`
  authorization.
- Protected captain gate used for source change while a station-owned
  change-delivery or fallback change-application route is available.
- Formal specialist station dispatched without the startup-complete handoff
  payload for role identity, assigned skill, read scope, tool permissions and
  prohibitions, channel state, delivery artifact type, and stop condition, then
  counted as complete trace evidence.
- Missing Team-Native trace evidence for `operation_mode: full`, governance-impact
  implementation, Doctor/Audit rule changes, routine audit rule readiness, or
  commit/release preparation.
- `completion_state` outside `complete`, `closed-with-director-risk`,
  `blocked`, `unverified`, or `not-applicable`.
- A non-complete `completion_state` paired with a completion claim.
- A completion claim without parseable `stations`, `delivery_artifacts`,
  `role_instance_id`, `delivery_artifact_id`, and `direct_exceptions`.
- Missing `operation_mode` or `operation_mode_reason` in a trace that claims
  completion.
- `operation_mode: daily` used for bottom-layer refactor, cross-file governance
  changes, specialist skill rewrites, Doctor/Audit rule changes, commit/release
  preparation, deployment/install/external-state readiness, or any other
  full-only work.
- `operation_mode: daily` described as full team completion without proving the
  task itself did not require full station separation.
- `operation_mode: full` missing separated change delivery, validation, review,
  memory/docs, completion evidence, role identity evidence, or required trace
  evidence.
- Reusing the same `role_instance_id` or specialist channel across multiple
  `role_id` values in the same task trace.
- In active Team mode, no-write or read-only work treated as a reason to skip
  Team-Native stations when the work can shape source, workflow, validation,
  review, memory, release, or governance decisions.
- Captain repository-scale reading large file sets, running duplicate scans, re-checking,
  substitute-validating, substitute-reviewing, or rewriting member output as
  captain evidence while a member station is running, except for blocker,
  board, artifact receipt, conflict, or authorization handling with a direct
  exception and residual state.
- Assigned stations left waiting without standby reason, first-response deadline, timeout action, or smallest unblock condition.
- Treating a `wait_agent`, CLI, browser, MCP, adapter, or platform wait timeout
  as specialist failure, cancellation, rejection, or absence without a status
  probe, hard timeout, explicit cancellation, or returned failure artifact.
- Continuing a probed specialist channel after it reports status without
  recording the pause report and an explicit captain resume message for that
  channel.
- Replacing a slow channel without `channel_generation`,
  `replaces_channel_run_id`, `replacement_reason`, `late_result_policy`, and
  `cancellation_state`.
- Ignoring a late returned artifact from an original channel instead of
  recording a receipt decision, duplicate/superseded judgment, or conflict
  review route.
- Claiming completion while any opened channel remains running, unknown,
  unresponsive, or late-result-pending without a terminal closure or visible
  non-complete residual state.
- Tool or subagent unavailability removing an applicable specialist station instead of marking it blocked, unverified, or closed-with-director-risk.
- Team-Native / subagent team mode treated as AI-initiated default-on without a
  current governed Director request for coding, workflow, validation, review,
  memory, commit, release, handoff, skill-forge, or governance-impact work.
- `blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, or
  `closed-with-director-risk` placed in `execution_route`, `execution_channel`,
  execution mode, or platform route fields.
- Missing authorization source, target, scope, phase, evidence, expiry, resolution state, or observed platform mode for any trace claiming write, change-delivery, change-application, memory, git, release, deployment, install, or external-mutation authority.
- Treating a workflow name as authorization instead of a route hint.
- Treating natural-language words such as `GO`, "continue", "fix this",
  "so what now?", or "do that" as write or protected-action authorization when
  the current visible target, scope, phase, and expiry cannot be bound.
- Treating an interface approval button as authorization beyond the displayed target, scope, phase, and expiry.
- Treating platform mode, sandbox state, local shell access, or channel availability as authorization.
- Reusing implementation authorization as change application, memory, git, release, deployment, install, or external-mutation authorization.
- Continuing after authorization expiry, scope mismatch, or phase mismatch without a new scope-bound authorization record.
- Continuing after a hook or platform guard block by retrying with another tool,
  switching channels, or using historical transcript text as substitute board,
  station, role, channel, target, scope, phase, expiry, or authorization
  evidence.
- Treating a `tool_execution_envelope` or `execution_receipt` as a new
  authorization source instead of a carrier and receipt for existing
  scope-bound authorization.
- Treating a model-filled, untrusted, unsigned, missing nonce, stale nonce, or
  unknown issuer envelope as authorization for protected mutation.
- Missing trusted issuer, signature, nonce, or execution receipt on a
  write-capable or protected mutation trace.
- Invalid payload not fail-closed for write-capable or protected mutation work.
- `closed-with-director-risk` without current, explicit, scope-bound
  `risk_close_evidence`.
- Post-block bypass hard block missing after a blocked action is followed by a
  retry, alternate tool, channel switch, or transcript substitution attempt.
- Retaining a specialist channel while crossing from implementation to review, validation repair, protected memory mutation, final acceptance, or another role-exclusive station.
- Replacing or closing a specialist channel without a closure reason when the task claims formal completion.
- Treating light closeout as permission to skip required change delivery, validation, review, memory/docs, or completion evidence.
- Leaving Yellow findings unclassified when they are part of the current completion or closeout claim.
- Running more than two repair attempts for the same Yellow or validation symptom without escalation to root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Memory Boundary

Trace files are task evidence. Do not copy raw traces into source memory. Source memory may record stable validation routes, durable governance facts, or a short cycle event after the source change lands.
