---
name: team-specialist-intent-requirements
description: >
  [Infra] Intent and requirements specialist for Team-Native work. Use when:
  restating goal, non-goals, constraints, acceptance criteria, contradictions,
  ambiguity, requirement replay, 需求回放、意圖對齊、非目標、驗收條件。
  DO NOT use when: implementation, architecture decision ownership, final review,
  validation, 設計裁決、實作、驗證、最終審查。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Team Specialist Intent Requirements — Requirement Replay

## Trigger Conditions

Use when a station needs the Director request replayed into a bounded work
contract before planning, implementation, review, or validation.

Use for ambiguity, scope conflict, hidden acceptance criteria, and mismatch
between the request and available evidence.

## Procedure

### Step 1: Read the request surface

1. Read the Director request, approved plan, current board row, and any named constraints.
2. Read only the files or memory cards needed to confirm terms and acceptance criteria.
3. Separate explicit requirements from assumptions.

### Step 2: Produce requirement evidence

Return a change delivery artifact with these fields:

- Role: intent requirements.
- Goal: the requested outcome in one or two sentences.
- Non-goals: actions explicitly excluded or outside the station.
- Constraints: file scope, write limits, language, platform, evidence, or timing.
- Acceptance criteria: observable conditions for success.
- Ambiguities: missing facts or conflicting instructions.
- Recommendation: proceed, ask captain to clarify, or mark blocked.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Stop at requirement boundaries

1. Do not design the solution.
2. Do not implement.
3. Do not decide review acceptance.
4. Do not expand scope beyond the Director request.

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
- `closeout_lane`: light, standard, release-grade, or not-applicable.
- `yellow_classification`: fix-this-cycle, residual-accepted, deferred-follow-up, local-customization, informational, or not-applicable.
- `yellow_resolution_state`: fixed, deferred, accepted-residual, escalated-blocked, escalated-red, or not-applicable.
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.
- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Treat the newest Director instruction as controlling when instructions conflict.
- Mark inferred requirements as assumptions.
- Do not turn a preferred implementation approach into a requirement.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- Requirement evidence informs the captain; it is not final authorization.
