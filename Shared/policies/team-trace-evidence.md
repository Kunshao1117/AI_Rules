# Team Trace Evidence Contract

此檔定義 Team-Native Core 的任務軌跡證據格式。它是唯讀稽核目標，不是執行器。

## Purpose

Static rules can prove that the framework text is present. They cannot prove that a specific task actually followed the required sequence: Director instruction -> captain intake -> translation -> board creation -> specialist station assignment -> execution-channel decision -> specialist work or blocked/unverified channel state -> captain supervision -> recovered change delivery artifacts / evidence delivery artifacts -> independent validation and review -> captain integration -> completion audit -> report. Team trace evidence fills that gap.

## Recommended Location

Task traces should be written under `.agents/logs/team-traces/` when the active workflow permits log output. Logs are task evidence, not source memory. Durable source facts still belong in `.agents/memory/` after the memory phase.

## Minimal Trace Fields

Each task trace should contain these fields in readable Markdown or JSON:

| Field | Required content |
|---|---|
| `task_id` | Stable task identifier or timestamp |
| `task_type` | discussion, exploration, blueprint, build-plan, implementation, fix-debug, validation-audit, commit-release, or handoff-skill |
| `workflow_route` | Workflow or semantic route used as a route hint |
| `board_state` | draft or formal |
| `implementation_authorization` | no-write, plan-only, GO-write, GO-push, release-authorized, or blocked |
| `go_evidence` | Prompt, workflow authorization, or blocked state |
| `specialist_role_source` | `team-specialist-registry` entry and matching `team-specialist-*` skill, or blocked/unverified reason |
| `specialist_skill` | Exact specialist child skill selected from the registry, or blocked/unverified reason |
| `domain_label` | Domain label used for the station, such as governance rules, platform capability, testing automation, memory governance, documentation, architecture quality, or external information |
| `requested_execution_channel` | Requested channel before capability evaluation |
| `channel_capability` | available, conditional, unavailable, or unverified |
| `channel_invocation_status` | not-started, requested, running, returned, unavailable, blocked, or not-authorized |
| `execution_channel` | Native subagent, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain channel, or blocked |
| `station_lifecycle_state` | assigned, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable |
| `retention_reason` | Why the same specialist channel may continue, or why retention is not allowed |
| `conversation_health` | clear, needs-handoff, stale, over-budget, role-conflict, or blocked |
| `reuse_count` | Number of times the same specialist channel was reused for the same role and delivery artifact |
| `handoff_summary` | Required when a station is retained across a long conversation or replaced |
| `closure_reason` | Completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable |
| `closeout_lane` | light, standard, release-grade, or not-applicable |
| `yellow_classification` | fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable |
| `yellow_resolution_state` | fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable |
| `repair_loop_count` | Number of attempts for the same symptom family, file region, or operator path |
| `delivery_artifact` | Intent, scope, architecture, change, validation, review, memory, documentation, completion, or evidence delivery artifact |
| `delivery_artifact_id` | Stable identifier for the recovered or missing delivery artifact |
| `delivery_artifact_status` | pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable |
| `author_role` | Registered specialist role that authored the delivery artifact, or blocked/unverified reason |
| `source_input` | Prior delivery artifact, approved plan, file scope, trace entry, or blocked input used by this station |
| `integrable_scope` | Exact scope the captain may integrate from this delivery artifact; use none when it is evidence-only or blocked |
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
| `captain_protected_integration` | Integration of returned qualified delivery artifacts, or not-applicable |
| `captain_substitute_authoring` | blocked by default; closed-with-director-risk only with case-specific Director approval and no full-team-completion claim |
| `completion_state` | complete, closed-with-director-risk, blocked, or unverified |
| `residual_risk` | Remaining blocked, unverified, or closed-with-director-risk items |

## Audit Semantics

The trace audit is read-only. It should classify evidence as:

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
- Captain substitute authoring recorded as protected integration.
- Missing independent review described as complete instead of blocked, unverified, or closed-with-director-risk.
- Subagent, browser, CLI, or MCP route described as the specialist role instead of the execution channel for a registered specialist.
- Missing channel capability or channel invocation status for an applicable station.
- Tool or subagent unavailability removing an applicable specialist station instead of marking it blocked, unverified, or closed-with-director-risk.
- Retaining a specialist channel while crossing from implementation to review, validation repair, protected memory mutation, final acceptance, or another role-exclusive station.
- Replacing or closing a specialist channel without a closure reason when the task claims formal completion.
- Treating light closeout as permission to skip required change delivery, validation, review, memory/docs, or completion evidence.
- Leaving Yellow findings unclassified when they are part of the current completion or closeout claim.
- Running more than two repair attempts for the same Yellow or validation symptom without escalation to root-cause repair, structural refactor, blocked, unverified, or closed-with-director-risk.

## Memory Boundary

Trace files are task evidence. Do not copy raw traces into source memory. Source memory may record stable validation routes, durable governance facts, or a short cycle event after the source change lands.
