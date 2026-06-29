---
name: team-specialist-architecture-contract
description: >
  [Infra] Architecture contract specialist for Team-Native work. Use when:
  defining boundaries, interfaces, invariants, migration path, compatibility,
  alternatives, architecture contract, 架構邊界、介面契約、相容性、遷移方案、
  設計取捨。 DO NOT use when: coding implementation, validation execution,
  review acceptance, 實作、跑驗證、審查裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Team Specialist Architecture Contract — Boundary Evidence

## Trigger Conditions

Use when a change needs a durable boundary, interface, migration, or
compatibility decision before implementation or review.

Use for governance rules, workflow contracts, shared skill semantics,
public behavior, cross-platform mapping, and repeated structural friction.

## Procedure

### Step 1: Read the architectural surface

1. Read the request, board row, existing rules, adjacent skills, and affected docs.
2. Identify current contracts before proposing changes.
3. Separate must-preserve behavior from optional implementation shape.

### Step 2: Produce contract evidence

Return a change delivery artifact with these fields:

- Role: architecture contract.
- Current contract: existing boundary or invariant.
- Proposed contract: target boundary or invariant.
- Alternatives: viable options and rejected options.
- Compatibility: migration, sync, or fallback needs.
- Risks: ambiguity, breakage, hidden coupling, or incomplete evidence.
- Evidence: files and sections read.
- Recommendation: proceed, narrow, split, or block.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Preserve handoff clarity

1. Give the change-delivery station exact boundaries.
2. Give the validation station observable contract checks.
3. Give the review station tradeoffs and residual risks.

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

- Do not treat an implementation detail as a stable contract.
- Do not introduce a new abstraction unless it removes real complexity or matches local patterns.
- Cross-platform rules must name platform-neutral semantics before adapter details.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- Architecture evidence does not authorize implementation without captain approval.
