# Team Trace Evidence Contract

This file defines the Team-Native Core task trace evidence format. It is a read-only audit target, not an executor.

## Purpose

Static rules can prove that the framework text is present.

They cannot prove that a specific task actually followed the required sequence.

Team trace evidence proves that a specific task followed the required sequence.
`Shared/policies/workflow-orchestration.md` owns that runtime sequence; this file owns only the trace fields and invalid trace patterns.

Shared value catalogs used by this trace:

- Status meanings and route/state separation:
  `Shared/policies/references/status-ontology.md`.
- Completion targets and completion states:
  `Shared/policies/references/completion-state-machine.md`.
- Authorization phases:
  `Shared/policies/references/authorization-phase-registry.md`.
- Protected actions:
  `Shared/policies/references/protected-action-registry.md`.
- Hook event lifecycle:
  `Shared/policies/references/hook-event-matrix.md`.
- Exception records:
  `Shared/policies/references/exception-registry.md`.
- Source/runtime/generated copy roles:
  `Shared/policies/references/platform-copy-map.md`.

The recorded runtime sequence follows `Shared/policies/workflow-orchestration.md`.

Trace evidence also proves that authorization was scope-bound.

Workflow names, interface approval buttons, platform modes, and channel availability are recorded as evidence or context only.

None of them authorizes unbounded writes or protected follow-on phases by itself.

When Team-Native / subagent team mode is active, the trace must show formal station assignment and channel state.

The trace may instead show explicit standby, blocked, unverified, not-applicable, or Director-risk-closed state.

Missing subagent, browser, CLI, MCP, isolation, or text-delivery capability is trace evidence to record.

It is not permission to omit the station or claim captain-direct completion.

When Team mode is inactive for pure conversation, small stable answers, or no-impact read-only work, trace fields are not required.

Inactive Team mode trace fields must not be cited as Team-Native completion evidence.

## Required Location

Task traces must be written under `.agents/logs/team-traces/` when the active workflow permits log output.

Logs are task evidence, not source memory.

Durable source facts still belong in `.agents/memory/` after the memory phase.

## Trace Loading Layers

Team trace has two loading layers.

They change when evidence is loaded and who owns it.

They do not remove any field, hard gate, review, validation, memory, or completion requirement when that evidence is claimed.

#### Captain runtime minimum trace (`隊長執行期最小追蹤`)

- Owner and timing: Captain coordination before broad reads, source writes, validation, or review.
- Owner and timing: Captain coordination before memory/docs attribution, completion audit, or completion claim.
- Required meaning: Only the task, station, role, channel/status, blocker, and reportability needed for coordination.
- Required meaning: Missing station evidence, authorization boundary, and handoff ownership for honest blocked reporting.
- Required meaning: Missing station evidence, authorization boundary, and handoff ownership for honest unverified reporting.
- Required meaning: Missing station evidence, authorization boundary, and handoff ownership for honest risk-closed reporting.

#### Extended audit trace (`延伸稽核追蹤`)

- Owner and timing: Conditionally loaded by the owner station for review, validation, memory/docs, or completion work.
- Owner and timing: Conditionally loaded by the owner station for audit, release, protected-action, or trace-repair work.
- Required meaning: Complete fields, lifecycle state, late returns, replacement channels, and alternate channels.
- Required meaning: Completion checks and detailed trace catalog evidence.


The full field catalog is not a captain entrance prerequisite.

A captain must not be required to read, fill, or preload the complete trace catalog to prove no specialist work was performed.

No-captain-authoring evidence comes from station-owned delivery artifacts, role separation, handoff/channel state.

No-captain-authoring evidence also comes from the owner station's returned evidence.

When a claim depends on the full lifecycle or field catalog, the relevant owner station loads the extended audit trace.

Owner stations include review, validation, memory/docs, completion, audit, release, protected-action, and trace-repair stations.

## Trace Field Catalog

The catalog below remains canonical for task traces in readable Markdown or JSON.

Fields are required when corresponding station, lifecycle, authorization, protected action, review, or validation evidence is claimed.

Fields are also required when memory/docs, release, or completion evidence is claimed.

Captain runtime minimum trace may link or record only the applicable coordination subset.

This lasts until an owner station needs extended audit evidence.

Canonical field names remain English for machine trace stability.

Director-facing summaries follow `Shared/policies/language-governance.md`.

When a field needs display text, use a bridge label such as `站點狀態（station_state）`.

Raw English-only field lists belong only inside machine-readable trace payloads or policy tables.

Raw English-only field lists are not the Director-facing explanation.

Value sets for board, station, channel, lifecycle, and delivery-artifact fields
are owned by `Shared/skills/team-task-board/references/board-field-catalog.md`.
Status meanings and route/state separation are owned by
`Shared/policies/references/status-ontology.md`.

#### `task_id`

- Required content: Stable task identifier or timestamp

#### `task_type`

- Required content: canonical workflow task type from
  `Shared/policies/references/workflow-team-evidence.md`.

#### `workflow_route`

- Required content: Workflow or semantic route used as a route hint

#### `execution_spec_id`

- Required content: Machine-readable `execution_spec` consumed by executable station/tool work.
- Required content: Blocked, unverified, or not-applicable reason.

#### `execution_spec_state`

- Required content: execution-spec state from
  `Shared/policies/references/workflow-execution-spec-contract.md`.
- Required content: Human flowcharts do not satisfy this field.

#### `dormant_readiness_hook_state`

- Required content: readiness state from the hook lifecycle and status catalogs.
- Required content: This field proves startup readiness did not authorize work by itself.

#### `captain_pre_action_guard_state`

- Required content: pre-action guard state from the board/status catalogs.
- Required content: This field applies before captain broad reads, source writes, validation, review, memory/docs, or completion evidence.

#### `operation_mode`

- Required content: operation mode governed by `Shared/policies/team-native-core.md`

#### `operation_mode_reason`

- Required content: Why daily mode is allowed, or why full mode is required

#### `board_state`

- Required content: board state from `team-task-board` and the board field catalog.
- Required content: Legacy `formal` must be narrowed before the trace can support completion.

#### `implementation_authorization`

- Required content: implementation authorization state from authorization resolution and status catalogs.

#### `go_evidence`

- Required content: Prompt, workflow authorization, or blocked state

#### `authorization_source`

- Required content: Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source.

#### `authorization_target`

- Required content: Exact target of the authorization, such as file allowlist, station, protected action, or external resource.

#### `authorization_scope`

- Required content: Concrete allowed operation boundary, including files, directories, generated copies, or memory cards.
- Required content: Concrete allowed operation boundary, including commands, release actions, or none.

#### `authorization_phase`

- Required content: canonical value from
  `Shared/policies/references/authorization-phase-registry.md`, or blocked/unverified reason.

#### `authorization_evidence`

- Required content: Prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason.

#### `authorization_expiry`

- Required content: Current turn, current dispatch wave, named file set, named command, or named protected action.
- Required content: Explicit revocation or blocked/unverified expiry.

#### `authorization_resolution_state`

- Required content: authorization resolution state from
  `Shared/policies/authorization-resolution.md` and status catalogs.

#### `platform_mode_observed`

- Required content: Observed platform mode or capability context, recorded only as context and never as authorization.

#### `specialist_role_source`

- Required content: `team-specialist-registry` entry and matching `team-specialist-*` skill, or blocked/unverified reason.

#### `specialist_skill`

- Required content: Exact specialist child skill selected from the registry, or blocked/unverified reason

#### `role_id`

- Required content: One of the registered ten specialist roles, such as `intent-requirements`, `change-delivery`, or `review`.
  Record a blocked or unverified reason when no valid role exists.

#### `role_instance_id`

- Required content: Unique role instance for this task trace.
- Required content: A role instance must not hold multiple `role_id` values in the same task.

#### `exclusive_task_scope`

- Required content: Usually `task`.
  This proves the specialist role instance is exclusive within the current task trace, or records the blocked/unverified reason.

#### `loaded_skill_refs`

- Required content: Skill refs or paths passed to the specialist instead of narrative-only identity

#### `handoff_packet_id`

- Required content: Required for every formal station: station handoff packet ID.
- Required content: Blocked or unverified reason when the station cannot be dispatched.

#### `domain_label`

- Required content: Domain label used for the station, such as governance, platform capability, testing, memory, documentation, architecture, or external information.

#### `requested_execution_channel`

- Required content: Requested channel before capability evaluation

#### `channel_capability`

- Required content: channel capability value from the board field catalog and platform capability matrix.

#### `channel_invocation_status`

- Required content: invocation status from the board field catalog and status catalogs.

#### `channel_run_id`

- Required content: Unique identifier for one concrete execution-channel attempt, including subagent, adapter, CLI, browser, MCP, change-delivery, isolated/text artifact, or change-application.

#### `channel_generation`

- Required content: Original or replacement generation number for the same station and role instance

#### `replaces_channel_run_id`

- Required content: Prior channel run replaced by this run, or not-applicable

#### `replacement_reason`

- Required content: Why a replacement channel was opened, such as unresponsive, hard-timeout, role-boundary, stale context, blocked route, or not-applicable.

#### `execution_route`

- Required content: Actual channel or delivery form.
- Required content: Never a status value such as blocked, unverified, standby, unavailable, not-authorized, or closed-with-director-risk.

#### `execution_channel`

- Required content: Execution channel or delivery form, including subagent, tool/MCP, CLI/browser evidence, external research, change delivery/application, isolated/text delivery, or platform-nondelegable protected-action record.

#### `tool_execution_envelope`

- Required content: Structured carrier passed to a tool layer.
- Required content: Blocked or unverified reason when no envelope is available.

#### `tool_execution_envelope_trust`

- Required content: trusted, untrusted, blocked, unverified, or not-applicable.

#### `tool_envelope_issuer`

- Required content: Trusted issuer identity, or blocked/unverified reason.

#### `tool_envelope_signature`

- Required content: Signature or verification reference, or blocked/unverified reason.

#### `tool_envelope_nonce`

- Required content: Fresh nonce or replay-protection reference, or blocked/unverified reason.

#### `execution_receipt`

- Required content: Tool-layer receipt naming envelope or nonce, action, decision, reason, or resulting state.
- Required content: Delivery artifact status.

#### `execution_receipt_decision`

- Required content: tool receipt decision from the execution envelope/status catalogs.

#### `station_state`

- Required content: station state from the board field catalog.
- Status meanings come from `Shared/policies/references/status-ontology.md`.

#### `evidence_state`

- Required content: evidence state from the board field catalog.
- Status meanings come from `Shared/policies/references/status-ontology.md`.

#### `station_lifecycle_state`

- Required content: lifecycle state from the board field catalog.

#### `station_mode`

- Required content: station mode from the board field catalog.

#### `handoff_ownership`

- Required content: handoff ownership value from the board field catalog.

#### `context_visibility`

- Required content: context visibility value from the board field catalog.

#### `retention_reason`

- Required content: Why the same specialist channel may continue, or why retention is not allowed

#### `conversation_health`

- Required content: conversation health value from the board/status catalogs

#### `reuse_count`

- Required content: Number of times the same specialist channel was reused for the same role and delivery artifact.

#### `handoff_summary`

- Required content: Required when a station is retained across a long conversation or replaced

#### `closure_reason`

- Required content: Completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable.

#### `deep_read_scope`

- Required content: Files, docs, logs, or external sources assigned to specialist deep-read

#### `external_grounding_required`

- Required content: true, false, or unknown.
- Required content: Whether external facts or freshness can affect this station's conclusion.

#### `external_research_question`

- Required content: Narrow sourceable question requested from the `external-research` station, or not-applicable

#### `external_research_artifact_id`

- Required content: Returned research artifact ID, pending, blocked, unverified, or not-applicable

#### `external_grounding_state`

- Required content: grounding value governed by `grounding-governance.md`
  with status meaning from `Shared/policies/references/status-ontology.md`.

#### `source_tier`

- Required content: source tier value from grounding governance, or not-applicable/unknown.

#### `source_date_or_version`

- Required content: Source date, release, standard revision, API/package/local version, or not-applicable

#### `missing_external_evidence`

- Required content: Missing source, version match, access, conflict resolution, date, local-version comparison, or none.

#### `captain_coordination_read_scope`

- Required content: Narrow coordination read scope for station-output ledgering or board maintenance.
  Also covers blocker handling, conflict resolution, or scope-question routing; it is not validation, review, memory/docs attribution, or completion evidence.

#### `unread_scope`

- Required content: Relevant scope not read by the specialist or captain

#### `startup_started_at`

- Required content: Local timestamp when the station channel was requested

#### `first_response_deadline`

- Required content: Expected first useful response or heartbeat deadline

#### `first_response_at`

- Required content: Local timestamp when the first useful response or heartbeat arrived, or not-returned

#### `last_progress_at`

- Required content: Latest progress evidence timestamp or blocked reason

#### `heartbeat_state`

- Required content: heartbeat state from the board/status catalogs

#### `status_probe_state`

- Required content: status-probe state from the board/status catalogs.

#### `status_probe_sent_at`

- Required content: Local timestamp when the captain asked the channel for status after uncertainty or timeout, or not-applicable.

#### `status_probe_response_at`

- Required content: Local timestamp when the channel responded to the status probe, or not-returned

#### `status_probe_pause_report`

- Required content: Specialist report after a status probe, including stop point, blocker state, and safe-to-continue judgment, or not-applicable.

#### `status_probe_resume_state`

- Required content: resume state from the board/status catalogs.
- Required content: No-probe cases are represented by `status_probe_state`.

#### `status_probe_resume_sent_at`

- Required content: Local timestamp when the captain explicitly sent resume to the probed channel, or not-returned.

#### `soft_timeout_at`

- Required content: Local timestamp for the monitoring timeout that triggers a status probe or standby decision

#### `hard_timeout_at`

- Required content: Local timestamp after which the station may close, cancel, replace, or remain non-complete with residual risk.

#### `timeout_action`

- Required content: timeout action from the board/status catalogs

#### `late_result_policy`

- Required content: late-result policy from the board/status catalogs.

#### `late_result_window`

- Required content: Time or condition under which a late artifact from the original channel must still be received.

#### `cancellation_state`

- Required content: cancellation state from the board/status catalogs.

#### `returned_at`

- Required content: Local timestamp when a delivery artifact was returned, or not-returned

#### `return_timing`

- Required content: return timing from the board/status catalogs

#### `receipt_decision`

- Required content: receipt decision from the board/status catalogs.

#### `receipt_decision_reason`

- Required content: Why the returned or late artifact was logged, routed, superseded, marked out of scope, marked duplicate, or routed to conflict review.

#### `conflict_with_artifact_id`

- Required content: Artifact ID that conflicts with this returned artifact, or not-applicable

#### `final_channel_closure_reason`

- Required content: final channel closure reason from the board/status catalogs.

#### `standby_reason`

- Required content: Why an assigned station is waiting for dispatch wave, prior input, channel warmup, or external unblock.

#### `closeout_lane`

- Required content: closeout lane from the completion and board catalogs

#### `yellow_classification`

- Required content: yellow classification from the board/status catalogs.

#### `yellow_resolution_state`

- Required content: yellow resolution state from the board/status catalogs

#### `repair_loop_count`

- Required content: Number of attempts for the same symptom family, file region, or operator path

#### `delivery_artifact`

- Required content: delivery artifact family from `team-task-board` and the matching delivery artifact skill.

#### `delivery_artifact_id`

- Required content: Stable identifier for the recovered or missing delivery artifact

#### `delivery_artifact_status`

- Required content: delivery artifact status from the board/status catalogs.

#### `author_role`

- Required content: Registered specialist role that authored the delivery artifact, or blocked/unverified reason

#### `source_input`

- Required content: Prior delivery artifact, approved plan, file scope, trace entry, or blocked input used by this station.

#### `integrable_scope`

- Required content: Exact scope the station-owned authorized change-application gate may apply from this delivery artifact.
- Required content: Use none when it is evidence-only or blocked.

#### `review_state`

- Required content: review lifecycle state from quality review governance.
- Required content: accepted-risk is a review lifecycle judgment only.
- Required content: It is not a Team-Native station status, delivery artifact status, or completion status.

#### `validation_state`

- Required content: validation state from the board/status catalogs.

#### `memory_docs_state`

- Required content: memory/docs state from the memory/docs delivery artifact and status catalogs.

#### `captain_authored`

- Required content: false, blocked, unverified, or closed-with-director-risk statement.
- Required content: true cannot support full completion.

#### `no_captain_authoring`

- Required content: true/blocked/unverified/closed-with-director-risk statement.
  This proves the captain did not author specialist implementation, review, validation, or memory attribution work.

#### `stations`

- Required content: Station list with applicability, execution route/channel, owner, role boundary, direct exception, and completion condition.

#### `waves`

- Required content: Dispatch wave, previous-wave input, next-wave start condition, and formal evidence eligibility.

#### `delivery_artifacts`

- Required content: Change delivery, memory/docs delivery, review, validation, evidence delivery, and completion artifact status.

#### `direct_exceptions`

- Required content: Station-specific direct exception, replacement evidence, and residual state.
- Required content: `direct` is not a station state, execution route, execution channel, platform route, or execution mode.

#### `role_separation`

- Required content: Evidence that implementation and review did not share the same role

#### `captain_artifact_receipt_risk`

- Required content: Legacy-risk field.
  Use only to record not-applicable or non-complete blocked/unverified risk for old captain artifact-receipt wording.
  New traces use neutral synthesis-ledger language.

#### `captain_context_burden`

- Required content: none, coordination-only, or direct-exception.
  This records whether the captain avoided parallel reads, duplicate scans, substitute validation/review, memory/docs attribution, and member-finding rewrites.

#### `captain_substitute_authoring`

- Required content: blocked by default; `closed-with-director-risk` only with case-specific Director approval and no full-team-completion claim.

#### `completion_state`

- Required content: value governed by
  `Shared/policies/references/completion-state-machine.md`.

#### `risk_close_evidence`

- Required content: Current, explicit, scope-bound Director risk close evidence when `closed-with-director-risk` is used.

#### `residual_risk`

- Required content: Remaining blocked, unverified, or closed-with-director-risk items

#### `source_deployed_pair`

- Required content: Source/runtime or source/generated pair when a copy role from
  `Shared/policies/references/platform-copy-map.md` is affected.

#### `sync_direction`

- Required content: canonical sync direction from
  `Shared/policies/references/platform-copy-map.md`.

#### `sync_evidence`

- Required content: Hash, content parity, diff summary, or blocked/unverified reason for the pair


## Hard Gate Requirements

- Formal stations must carry `handoff_packet_id`; a narrative-only handoff is not enough.
- Formal station startup is complete only when handoff evidence includes the required startup payload.
- The startup payload includes `handoff_packet_id`, `role_id`, `role_instance_id`, and `assigned_specialist_skill`.
- The startup payload includes `read_scope`, `allowed_tools`, and `forbidden_actions`.
- The startup payload includes `requested_execution_channel`, `channel_capability`, and `channel_invocation_status`.
- An explicit blocked/unverified reason may stand in for unavailable channel state.
- The startup payload includes `station_mode`, `context_visibility`, and `handoff_ownership`.
- The startup payload includes `delivery_artifact_type` and `stop_condition`.
- Missing any startup payload field keeps the station blocked or unverified.
- A missing startup payload cannot support a complete Team-Native trace.
- A wait timeout or missing first response is not failure evidence by itself.
- Before opening a replacement due to slow or unknown progress, the trace must record `status_probe_state` and `status_probe_sent_at`.
- Before opening a replacement due to slow or unknown progress, the trace must record the status probe response.
- If status probing is unavailable, the trace must record why it is unavailable.
- Missing probe evidence keeps the original channel unverified, not failed.
- A status probe pauses the probed specialist channel.
- A responding specialist must record `status_probe_pause_report` with the current stop point, blocker state, and safe-to-continue judgment.
- The specialist then waits for `status_probe_resume_state: resume-sent` and `status_probe_resume_sent_at` before resuming.
- After resume, ongoing work is recorded in `station_state: running`.
- An extension request is recorded in `status_probe_state: responded-extension-requested`.
- Work performed after a probe response without explicit captain resume evidence is not valid specialist delivery evidence.
- Replacement does not cancel the replaced channel.
- Any replacement must record `channel_generation`, `replaces_channel_run_id`, and `replacement_reason`.
- Any replacement must also record `late_result_policy` and `cancellation_state`.
- Otherwise the station cannot support `complete`.
- Late returned artifacts must be logged into the trace with `returned_at` and `return_timing`.
- Late returned artifacts must be logged into the trace with `receipt_decision` and `receipt_decision_reason`.
- `ignore-after-cancelled` is valid only when cancellation is acknowledged.
- The late-result window must also close with no artifact returned.
- Once an artifact returns, ignoring it blocks completion.
- Late-result values use the board catalog.
- `late-result-pending` means no ledger decision exists yet.
- Terminal ledger decisions are `logged`, `included-in-synthesis-ledger`, `routed-to-owner-station`, or `superseded-by-replacement`.
- Terminal ledger decisions are `out-of-scope`, `duplicate`, `conflict-review`, `blocked`, or `unverified`.
- A completion claim must show every opened channel has a terminal `final_channel_closure_reason`.
- A completion claim may instead show terminal late-result ledger disposition.
- A completion claim may instead show honest blocked/unverified/closed-with-director-risk residual state.
- Any completion claim missing `station_mode`, `context_visibility`, or `handoff_ownership` for an applicable formal station is invalid.
- In active Team mode, `operation_mode: full` requires Team-Native trace evidence.
- Governance-impact implementation requires Team-Native trace evidence.
- Doctor/Audit rule changes require Team-Native trace evidence.
- Routine audit rule readiness requires Team-Native trace evidence.
- Commit/release preparation requires Team-Native trace evidence.
- Missing trace is a blocked Red audit finding, not a Yellow advisory.
- Trace records or a clearly labeled evidence appendix must preserve parseable `stations` and `delivery_artifacts`.
- Trace records or a clearly labeled evidence appendix must preserve parseable `role_instance_id`.
- Trace records or a clearly labeled evidence appendix must preserve parseable `delivery_artifact_id` and `direct_exceptions`.
- The Director-facing completion body follows `Shared/policies/language-governance.md`.
- These values may close as blocked, unverified, closed-with-director-risk, or not-applicable.
- These values may close that way only when the trace is not claiming full completion.
- `completion_state` values and closeout targets are governed by
  `Shared/policies/references/completion-state-machine.md`.
- `completed`, `done`, `accepted-risk`, and other informal states must not pass as completion evidence.
- Two or more evidence-oriented stations marked direct require station-specific `direct_exceptions`.
- Two or more evidence-oriented stations marked direct require replacement evidence and residual state.
- Without those fields, the trace is invalid for formal acceptance.
- `execution_route` and `execution_channel` must not contain state values.
- Missing route capability belongs in `station_state`, `evidence_state`, `authorization_resolution_state`, or `completion_state`.
- `direct` belongs only in `direct_exception` / `direct_exceptions`.
- `direct` is not a canonical route, channel, board state, station state, or completion state.
- Exception record meanings are governed by
  `Shared/policies/references/exception-registry.md`.
- Write-capable or protected mutation traces must include a trusted `tool_execution_envelope`.
- Write-capable or protected mutation traces must include trusted issuer, signature, nonce, and matching `execution_receipt`.
- Missing or untrusted envelope evidence keeps the action blocked or unverified.
- Dormant readiness hook evidence may prove no-write readiness only.
- Dormant readiness hook evidence does not activate Team mode.
- Dormant readiness hook evidence does not authorize station work.
- Dormant readiness hook evidence does not replace board/station trace without a current governed Director request.
- A captain pre-action guard reminder or would-block risk is governance evidence only.
- It may map to blocked, unverified, or closed-with-director-risk state in the captain report.
- It cannot become owner station evidence or completion evidence.
- It does not itself stop execution.
- An `execution_receipt_decision` of blocked or not-authorized must keep the affected action blocked or unverified.
- It cannot be counted as progress, validation, review, memory/docs attribution, or completion proof.
- Main-worktree source writes through implementation change delivery must record `station_mode: change-delivery`.
- Main-worktree source writes through implementation change delivery must record `handoff_ownership: station-owned`.
- Main-worktree source writes through implementation change delivery must record authorization phase `implementation-change-delivery`.
- Main-worktree source writes through implementation change delivery must record exact file allowlist.
- Main-worktree source writes through implementation change delivery must record dirty-diff read evidence.
- Main-worktree source writes through implementation change delivery must record forbidden protected actions.
- Fallback change-application must record `station_mode: change-application` and `handoff_ownership: station-owned`.
- Fallback change-application must record authorization phase `change-application`, exact file allowlist, and dirty-diff read evidence.
- Fallback change-application must record a source input that is a returned isolated/text artifact.
- Fallback change-application must record a source input that is an explicit integration task or assigned generated/deployed sync.
- A platform-nondelegable protected-action record for the same write requires evidence.
- The evidence must show that the platform cannot delegate the physical write or protected tool call.
- Invalid payload fail-closed evidence is required when a malformed or unverifiable tool payload is part of the trace.
- A trace must not recover authority from model-filled envelope text, historical transcript text, or a text-only trace.
- `closed-with-director-risk` requires `risk_close_evidence` that is current, explicit, and scope-bound. It remains non-complete.
- Pending lifecycle values such as `awaiting-resume`, `cancellation-pending`, and `late-result-pending` are non-terminal.
- A trace that still contains them cannot support `completion_state: complete`.
- A later terminal closure or neutral ledger decision must also be recorded.
- Source/deployed changes require `source_deployed_pair`, `sync_direction`, and `sync_evidence`; missing parity blocks completion.
- Executable station or tool work that depends on workflow instructions has a required trace field.
- It must record a machine-readable `execution_spec_id` with `execution_spec_state: resolved`.
- Otherwise, keep the affected work blocked or unverified.
- Flowcharts, diagrams, checklists, and UI plan mirrors are human navigation only.
- They cannot satisfy execution-spec evidence.
- When `external_grounding_required` is true, completion-affecting claims must record `external_research_question`.
- When `external_grounding_required` is true, completion-affecting claims must record `external_grounding_state`.
- When `external_grounding_required` is true, completion-affecting claims must record `source_tier`.
- When `external_grounding_required` is true, completion-affecting claims must record `source_date_or_version`.
- When `external_grounding_required` is true, completion-affecting claims must record `missing_external_evidence`.
- `requested`, `partial`, `no-evidence`, `conflicted`, `blocked`, or `unverified` states must be preserved as gaps.
- External grounding gaps must not be upgraded to verified evidence.

## Audit Semantics

The trace audit is read-only. It must classify evidence as:

| Result | Meaning |
|---|---|
| `passed` | Required trace exists and contains board, wave, delivery artifact, role, channel, and completion evidence |
| `unverified` | Trace is absent or incomplete but the task can still be discussed honestly |
| `blocked` | Trace is required for completion, commit, release, or formal closeout but is absent |
| `not-applicable` | The task is pure discussion or another non-team-triggering answer |

## Invalid Trace Patterns

These patterns must not pass:

- Formal completion without change delivery, memory/docs delivery, review, and validation delivery artifact states.
- Draft-board evidence counted as formal evidence.
- Implementation and review owned by the same role in any trace claiming `complete`.
- Review or validation started before the required change delivery artifact exists.
- Exception: the station is explicitly auditing a blocked/unverified missing-artifact state.
- Two or more evidence-oriented stations marked direct without station-specific exception, replacement evidence, and residual state.
- Missing previous-wave input or next-wave start condition on a formal board.
- Captain substitute authoring described as full team completion.
- Captain substitute authoring recorded as change delivery, validation, review, memory/docs evidence, or completion evidence.
- Missing independent review described as complete instead of blocked, unverified, or closed-with-director-risk.
- Subagent, browser, CLI, or MCP route described as the specialist role instead of the execution channel for a registered specialist.
- Missing channel capability or channel invocation status for an applicable station.
- Missing loaded skill refs or handoff packet for a formal specialist station.
- Missing `handoff_packet_id` on any formal station.
- Missing `station_mode`, `context_visibility`, or `handoff_ownership` on an applicable formal station.
- A completion claim must not rely on captain coordination read without accepted `context_visibility` evidence.
- Accepted `context_visibility` evidence includes specialist deep-read evidence.
- Accepted `context_visibility` evidence includes shared-visible evidence.
- Accepted `context_visibility` evidence includes a scope-bound non-complete risk-closed state.
- Reusing a role instance after `handoff_ownership` changes across station owner classes.
- Main-worktree source changes made by a member station without required change-delivery evidence.
- Required evidence includes `station_mode: change-delivery` and `handoff_ownership: station-owned`.
- Required evidence includes exact file allowlist and dirty-diff read.
- Required evidence includes `implementation-change-delivery` authorization.
- The alternative is a fallback `station_mode: change-application` path.
- That path requires returned-artifact/integration/sync input and `change-application` authorization.
- Platform-nondelegable protected-action record used for source change.
- This is invalid while a station-owned change-delivery or fallback change-application route is available.
- Formal specialist station dispatched without the startup-complete handoff payload.
- Missing startup payload includes role identity, assigned skill, read scope, tool permissions, and prohibitions.
- Missing startup payload includes channel state, delivery artifact type, and stop condition.
- Missing startup payload cannot be counted as complete trace evidence.
- Missing Team-Native trace evidence for `operation_mode: full`.
- Missing Team-Native trace evidence for governance-impact implementation.
- Missing Team-Native trace evidence for Doctor/Audit rule changes.
- Missing Team-Native trace evidence for routine audit rule readiness.
- Missing Team-Native trace evidence for commit/release preparation.
- A `completion_state` value that is not defined by
  `Shared/policies/references/completion-state-machine.md`.
- A non-complete `completion_state` paired with a completion claim.
- A completion claim is invalid when its trace or evidence appendix lacks parseable `stations`.
- A completion claim is invalid when its trace or evidence appendix lacks parseable `delivery_artifacts`.
- A completion claim is invalid when its trace or evidence appendix lacks parseable `role_instance_id`.
- A completion claim is invalid when its trace or evidence appendix lacks parseable `delivery_artifact_id`.
- A completion claim is invalid when its trace or evidence appendix lacks parseable `direct_exceptions`.
- Missing `operation_mode` or `operation_mode_reason` in a trace that claims completion.
- Treating a flowchart, diagram, checklist, screenshot, or visual plan mirror as the AI execution spec.
- Treating a flowchart, diagram, checklist, screenshot, or visual plan mirror as station handoff or authorization record.
- Treating a flowchart, diagram, checklist, screenshot, or visual plan mirror as validation, review, or completion evidence.
- Executable station or tool work without a resolved `execution_spec` when the work depends on workflow instructions.
- An equivalent formal station handoff packet can satisfy this requirement.
- Missing external grounding fields when current external facts can affect the claimed conclusion.
- Missing external grounding fields when third-party documentation or release/version freshness can affect the claimed conclusion.
- Missing external grounding fields when security, compliance, cost, deployment, or release readiness can affect the claimed conclusion.
- Downstream stations must not treat `requested`, `partial`, `no-evidence`, or `conflicted` as sufficient grounding evidence.
- Downstream stations must not treat `blocked` or `unverified` as sufficient grounding evidence.
- `operation_mode: daily` used for bottom-layer refactor, cross-file governance changes, or specialist skill rewrites.
- `operation_mode: daily` used for Doctor/Audit rule changes or commit/release preparation.
- `operation_mode: daily` used for deployment/install/external-state readiness or any other full-only work.
- `operation_mode: daily` described as full team completion without proving the task itself did not require full station separation.
- `operation_mode: full` missing separated change delivery, validation, or review evidence.
- `operation_mode: full` missing memory/docs, completion evidence, role identity evidence, or required trace evidence.
- Reusing the same `role_instance_id` or specialist channel across multiple `role_id` values in the same task trace.
- In active Team mode, no-write or read-only work must not skip Team-Native stations.
- This applies when work can shape source, workflow, validation, review, memory, release, or governance decisions.
- Station-owned repository-scale evidence read is required for large file sets, duplicate scans, or re-checking.
- Station-owned repository-scale evidence read is required for validation or review substitute risks.
- Station-owned repository-scale evidence read is required for memory/docs attribution.
- Station-owned repository-scale evidence read is required for member-output evidence expansion while a member station is running.
- Captain coordination may only cover blocker handling, board maintenance, or station-output ledgering.
- Captain coordination may only cover conflict handling or scope-question routing.
- Any direct exception remains non-complete residual risk.
- Any direct exception cannot become owner evidence, validation or review evidence, memory/docs attribution, or completion evidence.
- Assigned stations left waiting without standby reason, first-response deadline, timeout action, or smallest unblock condition.
- Treating a `wait_agent`, CLI, browser, MCP, adapter, or platform wait timeout as specialist failure.
- Treating a wait timeout as cancellation, rejection, or absence without required evidence.
- Required evidence includes a status probe, hard timeout, explicit cancellation, or returned failure artifact.
- Continuing a probed specialist channel after it reports status without recording the pause report.
- The trace must also record an explicit captain resume message for that channel.
- Replacing a slow channel without `channel_generation`, `replaces_channel_run_id`, or `replacement_reason`.
- Missing `late_result_policy` or `cancellation_state` has the same effect.
- Ignoring a late returned artifact from an original channel instead of recording `returned_at` and `return_timing`.
- Ignoring a late returned artifact instead of recording a neutral ledger decision.
- Ignoring a late returned artifact instead of recording duplicate/superseded judgment or conflict review route.
- Claiming completion while any opened channel remains running, unknown, unresponsive, or late-result-pending.
- Claiming completion without a terminal closure or visible non-complete residual state.
- Tool or subagent unavailability removing an applicable specialist station.
- Tool or subagent unavailability must instead mark the station blocked, unverified, or closed-with-director-risk.
- Team-Native / subagent team mode treated as AI-initiated default-on.
- Team-Native / subagent team mode requires a current governed Director request.
- Current governed Director requests include coding, workflow, validation, review, memory, commit, release, and handoff work.
- Current governed Director requests include skill-forge or governance-impact work.
- Missing `dormant_readiness_hook_state` when a startup hook is used.
- Treating dormant readiness as active Team mode without a current governed Director request.
- Treating dormant readiness as station evidence or authorization without a current governed Director request.
- Bypassing the captain pre-action guard before captain broad reads or source writes.
- Bypassing the captain pre-action guard before validation, review, memory/docs attribution, completion audit, or completion evidence.
- Counting a captain pre-action guard reminder or would-block risk as station-owned evidence.
- Counting a captain pre-action guard reminder or would-block risk as validation, review, memory/docs attribution, or completion proof.
- `blocked`, `unverified`, `standby`, `not-authorized`, `unavailable`, or `closed-with-director-risk` placed in `execution_route`.
- Those state values must not be placed in `execution_channel`, execution mode, or platform route fields.
- Route/state separation is governed by
  `Shared/policies/references/status-ontology.md`.
- Missing authorization source, target, scope, phase, evidence, expiry, resolution state, or observed platform mode.
- This applies to any trace claiming write, change-delivery, change-application, memory, git, release, or deployment authority.
- This applies to any trace claiming install or external-mutation authority.
- Treating a workflow name as authorization instead of a route hint.
- Treating natural-language words such as `GO`, "continue", "fix this", or "so what now?" as write authorization.
- Treating natural-language words such as "do that" as protected-action authorization.
- Natural-language intent is insufficient when the current visible target, scope, phase, and expiry cannot be bound.
- Treating an interface approval button as authorization beyond the displayed target, scope, phase, and expiry.
- Treating platform mode, sandbox state, local shell access, or channel availability as authorization.
- Reusing implementation authorization as change application, memory, git, release, deployment, install, or external-mutation authorization.
- Continuing after authorization expiry, scope mismatch, or phase mismatch without a new scope-bound authorization record.
- Hiding a hook advisory would-block risk by retrying with another tool or switching channels.
- Hiding a hook advisory would-block risk by using historical transcript text as substitute trace evidence.
- Substitute trace evidence includes board, station, role, channel, target, scope, phase, expiry, or authorization evidence.
- Treating a `tool_execution_envelope` or `execution_receipt` as a new authorization source.
- It is only a carrier and receipt for existing scope-bound authorization.
- Treating a blocked or not-authorized `execution_receipt` as allowed progress or completion evidence.
- Treating a model-filled, untrusted, unsigned, missing nonce, stale nonce, or unknown issuer envelope as authorization.
- This applies to protected mutation.
- Missing trusted issuer, signature, nonce, or execution receipt on a write-capable or protected mutation trace.
- Invalid payload not fail-closed for write-capable or protected mutation work.
- `closed-with-director-risk` without current, explicit, scope-bound `risk_close_evidence`.
- Post-advisory bypass evidence missing after a would-block risk is followed by a retry, alternate tool, or channel switch.
- Post-advisory bypass evidence missing after transcript substitution is attempted.
- Retaining a specialist channel while crossing from implementation to review, validation repair, or protected memory mutation.
- Retaining a specialist channel while crossing to final closeout authority or another role-exclusive station.
- Replacing or closing a specialist channel without a closure reason when the task claims formal completion.
- Treating light closeout as permission to skip required change delivery, validation, review, memory/docs, or completion evidence.
- Leaving Yellow findings unclassified when they are part of the current completion or closeout claim.
- Running more than two repair attempts for the same Yellow or validation symptom without escalation.
- Escalation options include root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Memory Boundary

Trace files are task evidence.

Do not copy raw traces into source memory.

Source memory may record stable validation routes, durable governance facts, or a short cycle event after the source change lands.
