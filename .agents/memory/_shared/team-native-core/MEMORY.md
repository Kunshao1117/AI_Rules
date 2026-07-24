---
name: _shared.team-native-core
scopePath: Shared/
description: >
  專案記憶：Team-Native 治理與站點交付導覽父卡。Use when: task needs navigation to the split
  Team-Native memory family.
last_updated: '2026-07-24T16:19:47+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-24T13:52:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _shared.team-native-core — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete source ownership belongs to child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split Team-Native contracts into focused child cards and retained navigation only.

## Archive Index

- archive-004.md — Pre-split parent ownership history.

## Evidence Base

- tool:memory_status — Parent owner scope was verified before the split.

## Read Contract

- Read only to select the child card that owns the concrete source files.

## Conflicts and Supersession

- None.

## 中文摘要

- 此父卡只保留 Team-Native 導覽關係。
- 具體檔案歸屬以子卡為準。

## Tracked Files

## Relations

- _shared.team-native-core.policy-core (child card: core policies and adapter entry)
- _shared.team-native-core.policy-execution (child card: execution, phase, and status references)
- _shared.team-native-core.policy-evidence (child card: capability and workflow evidence matrices)
- _shared.team-native-core.station-entry (child card: board, packet, and dispatch entry)
- _shared.team-native-core.delivery-closeout (child card: completion evidence and closeout)
- _shared.team-native-core.specialists-analysis (child card: analysis specialist contracts)
- _shared.team-native-core.specialists-delivery (child card: delivery specialist contracts)
- _shared.team-native-core.memory-closure (child card: protected memory closure contracts)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
