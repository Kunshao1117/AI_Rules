---
name: team-specialist-registry
description: >
  [Infra] Team specialist role registry for captain-led Team-Native work.
  Use when: route a station to a specialist role, choose intent requirements,
  scope impact, architecture contract, change delivery, validation, review,
  security reliability, memory docs, release completion, or external research;
  專家角色、隊員路由、站點派工、變更交付件。 DO NOT use when: pure discussion,
  final captain acceptance, memory writes, git or release mutation, 純討論、
  隊長最終裁決、記憶提交、提交發布。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Team Specialist Registry — Role Router

## Trigger Conditions

Use after the captain has a Team-Native board and needs a station-specific
specialist role.

Use this registry to choose exactly one primary specialist for one station.
Use the chosen child skill for the station procedure and output format.

Before starting the station, create a handoff packet with
`team-station-handoff-packet` or an equivalent platform adapter. The packet
must include the assigned specialist skill, loaded skill refs, read scope,
forbidden actions, output format, startup threshold, standby reason when
applicable, and timeout action.

## Procedure

### Step 1: Apply routing gate

```text
[TEAM SPECIALIST ROUTING GATE]
Board exists?
├── NO -> HALT and ask the captain to create or promote the board.
├── YES -> Continue.
Station has one concrete task?
├── NO -> HALT and split the station.
├── YES -> Continue.
Director prompt contains [SUDO]?
├── YES -> Record override, keep protected-state boundaries, and continue only inside the assigned station.
└── NO -> Continue.
```

### Step 2: Select the specialist

| Station need | Load skill | Change delivery artifact focus |
|---|---|---|
| Goal, non-goal, acceptance, ambiguity | `team-specialist-intent-requirements` | Requirement replay and exclusions |
| File, workflow, memory, docs, compatibility surface | `team-specialist-scope-impact` | Impact map and blast radius |
| Boundary, interface, migration, architectural contract | `team-specialist-architecture-contract` | Architecture decision evidence |
| Assigned file edits in a governed fork or text-only delivery | `team-specialist-change-delivery` | Implemented or proposed change delivery artifact |
| Non-mutating command, browser, MCP, or manual evidence | `team-specialist-validation` | Validation state and remaining gaps |
| Independent requirement fit and regression review | `team-specialist-review` | Review state and findings |
| Secret, abuse, reliability, observability, rollback risk | `team-specialist-security-reliability` | Risk classification and safeguards |
| Memory, docs, index, handoff, generated-copy attribution | `team-specialist-memory-docs` | Memory and documentation delivery status |
| Completion, release readiness, residual risk, final delivery artifact check | `team-specialist-release-completion` | Completion readiness evidence |
| Official docs, current external facts, vendor or API research | `team-specialist-external-research` | Source-grounded research evidence |

### Step 3: Preserve role boundaries

1. Assign one specialist to one station only.
2. Do not let the change-delivery specialist review the same deliverable.
3. Keep memory mutation, git mutation, release mutation, deployment, install, and final acceptance on the captain path.
4. Return blocked, unverified, or closed-with-director-risk when the required role cannot be separated.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

- `authorization_source`: Director prompt, captain board row, interface approval event, prior approved plan, or blocked/unverified source.
- `authorization_target`: exact target such as file allowlist, station, protected action, command, tool, or external resource.
- `authorization_scope`: concrete allowed operation boundary, including files, directories, generated copies, memory cards, commands, protected actions, or none.
- `authorization_phase`: plan-only, implementation-change-delivery, captain-integration, validation, review, memory-docs, memory-commit, git, release, deployment, install, external-mutation, or blocked.
- `authorization_evidence`: prompt excerpt, board row, approval UI event, command confirmation, or missing evidence reason.
- `authorization_expiry`: current turn, current dispatch wave, named file set, named command, named protected action, explicit revocation, or blocked.
- `authorization_resolution_state`: authorized, no-write, scope-mismatch, phase-mismatch, expired, unverified, blocked, or revoked.
- `platform_mode_observed`: observed platform mode or capability context, recorded only as context and never as authorization.
- `specialist_skill`: the exact specialist skill producing the artifact.
- `loaded_skill_refs`: the skill refs or paths handed to the specialist.
- `handoff_packet_id`: the station handoff packet identifier.
- `domain_label`: the domain label used for this station.
- `requested_execution_channel`: the requested channel before capability evaluation.
- `channel_capability`: available, conditional, unavailable, or unverified.
- `channel_invocation_status`: not-started, requested, running, returned, unavailable, blocked, or not-authorized.
- `execution_channel`: native platform channel, project custom agent, tool/MCP, command evidence, browser evidence, external research, isolated change delivery, text change delivery, protected captain channel, or blocked.
- `delivery_artifact`: intent, scope, architecture, change, validation, review, security, memory, documentation, completion, external research, or evidence artifact.
- `delivery_artifact_status`: pending, returned, integrated, blocked, unverified, closed-with-director-risk, or not-applicable.
- `station_lifecycle_state`: assigned, retained, reused, handoff-required, closed, replaced, blocked, or not-applicable.
- `retention_reason`: why the same specialist channel may continue, or why retention is not allowed.
- `conversation_health`: clear, needs-handoff, stale, over-budget, role-conflict, or blocked.
- `reuse_count`: number of same-role reuse decisions for this station and delivery artifact.
- `handoff_summary`: required when context is long, stale, or the station is replaced.
- `closure_reason`: completed delivery, context stale, role conflict, independent opinion required, blocked, or not-applicable.
- `deep_read_scope`: files, docs, logs, or external sources assigned for specialist deep-read.
- `captain_verify_read_scope`: the reduced scope the captain must verify before integration or acceptance.
- `unread_scope`: relevant scope not read by the specialist or captain.
- `startup_started_at`: local timestamp when the channel was requested.
- `first_response_deadline`: expected first useful response or heartbeat.
- `last_progress_at`: latest progress evidence.
- `timeout_action`: standby, replace, blocked, unverified, or Director input.
- `standby_reason`: why an assigned station is waiting instead of returning evidence.
- `closeout_lane`: light, standard, release-grade, or not-applicable.
- `yellow_classification`: fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable.
- `yellow_resolution_state`: fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable.
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.
- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Do not route by broad title alone. Match the station need and forbidden actions.
- Do not collapse validation and review into one role when the deliverable changed.
- Do not treat this registry as permission to start a specialist before the board exists.

## Constraints

- This registry is read-only.
- This registry does not replace the Team-Native board, GO gate, memory gate, review-state decision, or captain final acceptance.
- Child skills must return a change delivery artifact or an evidence artifact, not a protected-state mutation.
