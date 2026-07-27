---
name: _shared.ops-skills.skill-governance.delivery-artifacts
scopePath: Shared/skills/
description: >-
  專案記憶：團隊交付 artifact 與角色邊界。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-27T08:21:16+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 2
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: ready
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---


# _shared.ops-skills.skill-governance.delivery-artifacts — Module Memory

## Current Truth

- Owns Team delivery-artifact contracts and their deployed copies.
- Team change, validation, review, role-boundary, and memory/docs artifacts load only when execution topology is delegated.
- Ordinary Direct completion does not require formal Team artifacts, but it uses the same beginner-facing response boundary as delegated work and does not expose raw delivery fields.

## Active Constraints

- Keep source/deployed ownership paired where both are tracked.
- Do not allow an artifact procedure to redefine verification, terminal review, or completion policy.

## Cycle Events

- 02: Reconciled delivery artifacts with delegated-only activation and concise Direct outcomes.
- 03: Confirmed delivery, review, and validation artifacts remain internal while all user-visible summaries use the shared beginner-facing rule.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skills/team-change-delivery-artifact/SKILL.md
- source:Shared/skills/team-validation-delivery-artifact/SKILL.md
- source:Shared/skills/team-review-delivery-artifact/SKILL.md and Shared/skills/team-role-boundaries/SKILL.md
- source:Shared/policies/execution-routing.md and Shared/policies/verification-strategy.md

## Read Contract

- Read when changing owned Team delivery-artifact contracts.
- Do not use for ordinary Direct completion or as protected-action authorization.

## Conflicts and Supersession

- superseded: requiring formal Team artifacts for ordinary Direct work.

## 中文摘要

- Team artifact 只在 delegated topology 下需要。
- Direct 不需 Team artifact，但對外一樣先用白話說明結果、影響、注意事項與下一步。
- Artifact skill 不重複擁有 verification、review 或 completion policy。

## Tracked Files

- Shared/skills/team-review-delivery-artifact/SKILL.md
- Shared/skills/team-validation-delivery-artifact/SKILL.md
- Shared/skills/team-memory-docs-delivery-artifact/SKILL.md
- Shared/skills/team-change-delivery-artifact/SKILL.md
- Shared/skills/team-role-boundaries/SKILL.md
- .agents/skills/team-review-delivery-artifact/SKILL.md
- .agents/skills/team-validation-delivery-artifact/SKILL.md
- .agents/skills/team-memory-docs-delivery-artifact/SKILL.md
- .agents/skills/team-change-delivery-artifact/SKILL.md
- .agents/skills/team-role-boundaries/SKILL.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
