---
name: _shared.ops-skills.skill-governance.delivery-artifacts
scopePath: Shared/skills/
description: >
  專案記憶：團隊交付 artifact 來源技能。Use when: task touches team review, validation,
  memory-docs, change-delivery, or role-boundary artifact sources.
last_updated: '2026-08-17T21:12:50+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T21:20:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-003
cycle_event_count: 1
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

- Owns canonical Team delivery-artifact and role-boundary skills.
- Deployed `.agents/skills/` copies belong to `_shared.ops-skills.skill-governance.delivery-runtime`.
- Team artifacts load only when execution topology is delegated.

## Active Constraints

- Do not allow an artifact procedure to redefine verification, terminal review, or completion policy.
- Max depth is 4; deployed copies are a sibling card, not a nested child.

## Cycle Events

- 01: Split deployed copies into `_shared.ops-skills.skill-governance.delivery-runtime`.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 paired source and deployed ownership.

## Evidence Base

- source:Shared/skills/team-change-delivery-artifact/SKILL.md, Shared/skills/team-role-boundaries/SKILL.md

## Read Contract

- Read when changing owned Team delivery-artifact sources.

## Conflicts and Supersession

- superseded: requiring formal Team artifacts for ordinary Direct work.

## 中文摘要

- 此卡負責團隊交付 artifact 來源技能。
- 部署副本已拆到 delivery-runtime。

## Tracked Files

- Shared/skills/team-review-delivery-artifact/SKILL.md
- Shared/skills/team-validation-delivery-artifact/SKILL.md
- Shared/skills/team-memory-docs-delivery-artifact/SKILL.md
- Shared/skills/team-change-delivery-artifact/SKILL.md
- Shared/skills/team-role-boundaries/SKILL.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)
- _shared.ops-skills.skill-governance.delivery-runtime (sibling card: deployed copies)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
