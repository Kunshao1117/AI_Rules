---
name: _shared.team-native-core.policy-execution.team-trace
scopePath: Shared/policies/references/
description: >
  專案記憶：隊長邊界、交付切片與 trace 欄位。Use when: task touches captain, delivery-slice, or
  team-trace references.
last_updated: '2026-08-17T20:55:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-08-17T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
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

# _shared.team-native-core.policy-execution.team-trace — Module Memory

## Current Truth

- Owns captain-boundary, delivery-slice, team-trace-fields, and invalid-pattern references.
- Formal trace is a conditional delegated/protected route, not an ordinary Direct completion requirement.

## Active Constraints

- A captain may synthesize existing evidence but may not author station-owned completion evidence.

## Cycle Events

- 01: Created during the execution-reference split.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/references/team-native-core-captain-boundary.md, Shared/policies/references/team-trace-fields.md

## Read Contract

- Read when changing owned captain, delivery, or trace references.

## Conflicts and Supersession

- superseded: formal trace for ordinary Direct work.

## 中文摘要

- 此卡負責隊長邊界、交付切片與 trace 欄位。
- 普通 Direct 工作不需要正式 trace。

## Tracked Files

- Shared/policies/references/team-native-core-captain-boundary.md
- Shared/policies/references/team-native-core-delivery-slice.md
- Shared/policies/references/team-trace-fields.md
- Shared/policies/references/team-trace-invalid-patterns.md

## Relations

- _shared.team-native-core.policy-execution (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
