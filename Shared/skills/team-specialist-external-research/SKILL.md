---
name: team-specialist-external-research
description: >
  [Infra] External research specialist for Team-Native work. Use when: current
  official docs, vendor APIs, package behavior, platform rules, security
  guidance, pricing, laws, or external facts may affect a decision; external
  research, 官方文件、外部查證、API 新鮮度、安全指引。 DO NOT use when:
  local files already answer the question, source mutation, final acceptance,
  本地證據足夠、改檔、最終裁決。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: none
  tool_scope: ["web:read", "mcp:read", "filesystem:read"]
---

# Team Specialist External Research — Fresh Evidence

## Trigger Conditions

Use when a decision depends on high-change or uncertain external information:
framework APIs, platform rules, package versions, security guidance, pricing,
laws, status, vendor docs, or recent behavior.

Use only after local files are insufficient or likely stale.

## Procedure

### Step 1: Set the research anchor

1. Identify the exact project version, package version, platform, API, date, or policy question.
2. Prefer official docs, primary sources, release notes, specifications, and vendor status pages.
3. Use secondary sources only to discover primary sources or when primary sources are unavailable.

### Step 2: Return source-grounded evidence

Return a change delivery artifact with these fields:

- Role: external research.
- Question: exact decision being researched.
- Sources: official or primary sources with dates when available.
- Findings: current facts relevant to the station.
- Applicability: how the finding maps to the local project.
- Uncertainty: stale, missing, conflicting, or version-mismatched evidence.
- Recommendation: proceed, narrow, verify locally, or block.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Keep research separate from implementation

1. Do not edit source files.
2. Do not install packages.
3. Do not mutate external systems.
4. Hand off decisions to the captain or architecture station.

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

- Current local source overrides memory and internal model knowledge.
- Official source for the wrong version is partial evidence, not full proof.
- External recommendations still need local compatibility checks.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, credential, issue, pull request, cloud, or external-state mutation.
- External research supports decisions; it does not authorize completion.
