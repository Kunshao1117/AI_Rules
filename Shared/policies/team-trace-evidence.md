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

Because Team-Native / subagent team mode is default-on for applicable work, a
trace must show either formal station assignment and channel state, or an
explicit standby, blocked, unverified, not-applicable, or Director-risk-closed
state. Missing subagent, browser, CLI, MCP, isolation, or text-delivery
capability is trace evidence to record; it is not permission to omit the station
or claim captain-direct completion.

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
| `implementation_authorization` | no-write, plan-only, GO-write, GO-push, release-authorized, or blocked |
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
| `execution_route` | Actual channel or delivery form; never a status value such as blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk |
| `execution_channel` | Native subagent, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain gate, or authorized change-application gate |
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
| `last_progress_at` | Latest progress evidence timestamp or blocked reason |
| `timeout_action` | standby, replace, blocked, unverified, Director input, or not-applicable |
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
| `integrable_scope` | Exact scope the authorized change-application gate may apply from this delivery artifact; use none when it is evidence-only or blocked |
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
  `delivery_artifact_type`, and `stop_condition`. Missing any of these keeps
  the station blocked or unverified and cannot support a complete Team-Native
  trace.
- `operation_mode: full`, governance-impact implementation, Doctor/Audit rule changes, routine audit rule readiness, and commit/release preparation require Team-Native trace evidence. Missing trace is a blocked Red audit finding, not a Yellow advisory.
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
- No-write or read-only work treated as a reason to skip Team-Native stations when the work can shape source, workflow, validation, review, memory, release, or governance decisions.
- Captain broad-reading large file sets, running duplicate scans, re-checking,
  substitute-validating, substitute-reviewing, or rewriting member output as
  captain evidence while a member station is running, except for blocker,
  board, artifact receipt, conflict, or authorization handling with a direct
  exception and residual state.
- Assigned stations left waiting without standby reason, first-response deadline, timeout action, or smallest unblock condition.
- Tool or subagent unavailability removing an applicable specialist station instead of marking it blocked, unverified, or closed-with-director-risk.
- Team-Native / subagent team mode treated as opt-in instead of default-on for
  applicable coding, workflow, validation, review, memory, commit, release,
  handoff, skill-forge, or governance-impact work.
- `blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, or
  `closed-with-director-risk` placed in `execution_route`, `execution_channel`,
  execution mode, or platform route fields.
- Missing authorization source, target, scope, phase, evidence, expiry, resolution state, or observed platform mode for any trace claiming write, integration, memory, git, release, deployment, install, or external-mutation authority.
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
