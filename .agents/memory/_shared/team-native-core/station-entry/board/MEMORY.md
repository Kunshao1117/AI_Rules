---
name: _shared.team-native-core.station-entry.board
scopePath: Shared/skills/team-task-board/
description: >
  專案記憶：編程團隊治理與 Team board。Use when: task touches programming-team-governance or
  team-task-board sources.
last_updated: '2026-08-17T21:12:59+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
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

# _shared.team-native-core.station-entry.board — Module Memory

## Current Truth

- Owns programming-team governance and Team board sources, including field catalogs and delivery templates.
- Board activation requires delegated topology from `execution-routing`.

## Active Constraints

- Fix, build, debug, test, and multi-file work are not Team triggers by themselves.

## Cycle Events

- 01: Created during the remaining granularity split from station-entry.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/programming-team-governance/SKILL.md, Shared/skills/team-task-board/SKILL.md

## Read Contract

- Read when changing owned board or programming-team sources.

## Conflicts and Supersession

- superseded: generic engineering activity as sufficient Team activation.

## 中文摘要

- 此卡負責編程團隊治理與 Team board。
- 派工封包與委派策略歸 packet-delegation 子卡。

## Tracked Files

- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/team-task-board/references/board-field-catalog.md
- Shared/skills/team-task-board/references/board-templates-and-delivery.md
- Shared/skills/team-task-board/references/board-field-channel-and-receipts.md
- Shared/skills/team-task-board/references/board-field-slice-and-roles.md

## Relations

- _shared.team-native-core.station-entry (parent card: navigation only)
- _shared.team-native-core.station-entry.packet-delegation (sibling card: packet and dispatch)
- _shared.team-native-core.policy-core.routing (related routing policy)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
