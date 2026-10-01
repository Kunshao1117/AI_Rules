# Compatibility reference — team-specialist-scope-impact

This is an archived document, not an invocable Skill or active governance owner.
Old frontmatter, triggers and station rules below are historical compatibility
data for existing frozen consumers only. General work uses `Shared/policies/references/task-assignment-methods.md#scope-and-impact-mapping`.
Resolve old IDs and paths through `Shared/policies/references/legacy-skill-migration.md`.

<!-- ARCHIVED_SKILL_BODY_START -->
---
name: team-specialist-scope-impact
description: >
  範圍影響分析專家站點（Infra）：Scope and impact specialist for Team-Native work. Use when: 盤點
  affected files、workflows、skills、memory cards、docs、generated copies、
  dependencies、regression surface、impact analysis、影響面、範圍盤點、回歸面、記憶文件影響。
  DO NOT use when: 實作、收尾裁決、提交發布（implementing changes,
  release/completion station decisions, release mutation）。
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

General Agent roles and bounded assignments are owned by
`Shared/agents/_registry.md` and `Shared/policies/agent-governance.md`.
Model intent belongs to `Shared/policies/model-profile-routing.md`;
the platform owns worker lifecycle. This retained Skill/reference is not a
formal vNext Agent definition or a general Team prerequisite.

## Legacy compatibility boundary

The delimited body below is legacy, compatibility-only, and not required for
general vNext work, including Team. Its original paths, anchors and meanings
remain available to frozen Memory consumers. Do not derive Memory records,
authority or completion from a vNext assignment. Do not load this body merely
because execution mode is Team.

<!-- LEGACY_TEAM_COMPATIBILITY_START -->

# Team Specialist Scope Impact — Impact Map

## Trigger Conditions

當 board 或 owner station 在 scoped routing、integration、validation、review
或 completion-readiness evidence 前需要 bounded impact map 時使用。

適用於 source files、workflow entries、Shared skills、deployed copies、
memory ownership、documentation surfaces 與 regression risk。

## Procedure

### Step 1: Define the scope baseline

1. Read the board row, allowed file list, and changed-file list when available.
2. Search only the relevant source tree for references, generated copies, and matching skill or workflow entries.
3. Identify whether memory or docs require a separate delivery station.

### Step 2: Map impact

Return an evidence artifact with these fields:

- Role: scope impact.
- In-scope files: concrete files or directories the station is authorized to touch or inspect.
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

Every returned artifact inherits shared Team-Native trace rules instead of
duplicating the field list inside this role skill.

1. Receive `operation_mode`, `operation_mode_reason`, `role_id`,
   `role_instance_id`, and `exclusive_task_scope` from the station handoff
   packet.
2. Verify `role_id` matches this skill's `metadata.relations.role_id` before
   producing an artifact.
3. Include the authorization, channel, lifecycle, delivery, and blocker fields
   required by `team-trace-evidence` and `team-station-handoff-packet`.
4. Use only this skill's `metadata.relations.artifact_contracts` and
   `metadata.relations.trace_contracts` as the artifact contract source.
5. If the handoff packet is missing role identity fields, return blocked or
   unverified evidence instead of inventing defaults.

## Gotchas

- Do not widen the change because adjacent cleanup is visible.
- Generated or deployed copies are impact surfaces even when not writable by this station.
- Memory ownership is an attribution surface, not permission to edit memory.

## Constraints

- Read-only station.
- No source, memory, git, release, deployment, install, or external-state mutation.
- Final scope and change-application routing stay with the current owner
  station or scoped Director authorization path; the captain coordinates and
  reports.

<!-- LEGACY_TEAM_COMPATIBILITY_END -->
