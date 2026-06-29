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
  relations:
    role_id: scope-impact
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - impact-test-strategy
      - memory-ops
    embedded_artifacts:
      - impact-map-artifact
    artifact_contracts:
      - evidence-delivery-artifact
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
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

Return an evidence artifact with these fields:

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

## Trace And Handoff Contract

Every output inherits shared Team-Native trace rules instead of duplicating the
field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the output contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Do not widen the change because adjacent cleanup is visible.
- Generated or deployed copies are impact surfaces even when not writable by this station.
- Memory ownership is an attribution surface, not permission to edit memory.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- The captain decides final scope and integration.
