---
name: _shared.ops-skills.skill-governance.delivery-runtime
scopePath: .agents/skills/
description: >
  專案記憶：團隊交付 artifact 的部署副本。Use when: task touches deployed
  team-*-delivery-artifact or team-role-boundaries skills under .agents/skills/.
last_updated: '2026-08-17T21:12:49+08:00'
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

# _shared.ops-skills.skill-governance.delivery-runtime — Module Memory

## Current Truth

- Owns the deployed `.agents/skills/` copies of Team delivery-artifact and role-boundary skills.
- Canonical source remains `_shared.ops-skills.skill-governance.delivery-artifacts`.

## Active Constraints

- Do not treat deployed copies as canonical source.
- Max depth is 4; this card is a sibling, not a child of delivery-artifacts.

## Cycle Events

- 01: Created during the remaining granularity split from delivery-artifacts.

## Archive Index

- Sibling archive-001.md records the pre-split paired file list.

## Evidence Base

- source:.agents/skills/team-change-delivery-artifact/SKILL.md

## Read Contract

- Read when changing owned deployed delivery-artifact copies.

## Conflicts and Supersession

- superseded: pairing all source and deployed artifact files on one card.

## 中文摘要

- 此卡負責團隊交付 artifact 的部署副本。
- 來源技能仍由 delivery-artifacts 擁有。

## Tracked Files

- .agents/skills/team-review-delivery-artifact/SKILL.md
- .agents/skills/team-validation-delivery-artifact/SKILL.md
- .agents/skills/team-memory-docs-delivery-artifact/SKILL.md
- .agents/skills/team-change-delivery-artifact/SKILL.md
- .agents/skills/team-role-boundaries/SKILL.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)
- _shared.ops-skills.skill-governance.delivery-artifacts (sibling card: canonical artifact sources)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
