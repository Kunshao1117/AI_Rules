---
name: team-specialist-scope-impact
description: >
  [Infra] Scope and impact specialist for Team-Native work. Use when: mapping
  affected files, workflows, skills, memory cards, docs, generated copies,
  dependencies, regression surface, impact analysis, 影響面、範圍盤點、回歸面、
  記憶文件影響。 DO NOT use when: implementing changes, final acceptance,
  release mutation, 實作、最終驗收、提交發布。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: guided
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
---

# Team Specialist Scope Impact — Impact Map

## Trigger Conditions

Use when the captain needs a bounded impact map before approving,
integrating, validating, reviewing, or completing a change.

Use for source files, workflow entries, Shared skills, deployed copies,
memory ownership, documentation surfaces, and regression risk.

## Procedure

### Step 1: Define the scope baseline

1. Read the board row, allowed file list, and changed-file list when available.
2. Search only the relevant source tree for references, generated copies, and matching skill or workflow entries.
3. Identify whether memory or docs may need a separate delivery station.

### Step 2: Map impact

Return a change delivery artifact with these fields:

- Role: scope impact.
- In-scope files: concrete files or directories the station may touch or inspect.
- Out-of-scope files: known exclusions and protected areas.
- Dependency surface: callers, references, copied files, generated files, docs, and memory ownership.
- Regression surface: workflows, tests, commands, UI paths, or governance checks likely affected.
- Evidence: commands or files read.
- Recommendation: minimal safe scope and validation route.
- Blocker status: blocked, unverified, closed-with-director-risk, or not-applicable.

### Step 3: Name residual uncertainty

1. Mark missing searches or unreadable paths as unverified.
2. Mark unavailable required evidence as blocked.
3. Avoid broad refactor recommendations unless evidence shows repeated or cross-module impact.

## Team-Native Trace Fields

Every specialist output must include these fields so the captain can prove role separation and execution routing:

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
- `repair_loop_count`: number of attempts for the same symptom family, file region, or operator path.- `no_captain_authoring`: true, blocked, unverified, or closed-with-director-risk with reason.
## Gotchas

- Do not widen the change because adjacent cleanup is visible.
- Generated or deployed copies are impact surfaces even when not writable by this station.
- Memory ownership is an attribution surface, not permission to edit memory.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- The captain decides final scope and integration.
