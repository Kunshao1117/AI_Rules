---
name: _shared.team-native-core.station-entry
scopePath: Shared/skills/
description: >
  專案記憶：Team board 與派工入口導覽父卡。Use when: task needs navigation to this split
  station-entry memory family.
last_updated: '2026-08-17T21:13:39+08:00'
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

# _shared.team-native-core.station-entry — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete station-entry ownership belongs to its child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split board and packet-delegation ownership into child cards.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 mixed station-entry ownership.

## Evidence Base

- source:Shared/skills/team-task-board/SKILL.md, Shared/skills/delegation-strategy/SKILL.md

## Read Contract

- Read only to select the child card that owns the concrete station-entry files.

## Conflicts and Supersession

- superseded: a single station-entry card owning board, packet, and delegation files.

## 中文摘要

- 此父卡只保留站點入口導覽。
- Board 與派工封包已拆到子卡。

## Tracked Files

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.station-entry.board (child card: board and programming-team)
- _shared.team-native-core.station-entry.packet-delegation (child card: packet and dispatch)
- _shared.team-native-core.policy-core.routing (related routing policy)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
