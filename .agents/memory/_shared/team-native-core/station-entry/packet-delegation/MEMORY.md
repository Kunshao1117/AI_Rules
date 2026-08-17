---
name: _shared.team-native-core.station-entry.packet-delegation
scopePath: Shared/skills/
description: >
  專案記憶：站點派工封包與委派策略。Use when: task touches team-station-handoff-packet or
  delegation-strategy sources.
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

# _shared.team-native-core.station-entry.packet-delegation — Module Memory

## Current Truth

- Owns station handoff-packet sources, delegation-strategy sources, and the deployed delegation-strategy copy.
- Delivery slices keep responsibility slots fixed, but activate only stations needed by the claims being made.

## Active Constraints

- Preserve full Team role boundaries when delegated mode is active.

## Cycle Events

- 01: Created during the remaining granularity split from station-entry.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/team-station-handoff-packet/SKILL.md, Shared/skills/delegation-strategy/SKILL.md

## Read Contract

- Read when changing owned packet or delegation sources.

## Conflicts and Supersession

- superseded: generic engineering activity as sufficient Team activation.

## 中文摘要

- 此卡負責站點派工封包與委派策略。
- Team board 歸 board 子卡。

## Tracked Files

- Shared/skills/team-station-handoff-packet/SKILL.md
- Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md
- Shared/skills/team-station-handoff-packet/references/packet-schema-and-routing.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/team-dispatch-gates.md
- .agents/skills/delegation-strategy/SKILL.md

## Relations

- _shared.team-native-core.station-entry (parent card: navigation only)
- _shared.team-native-core.station-entry.board (sibling card: board and programming-team)
- _shared.team-native-core.policy-core.routing (related routing policy)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
