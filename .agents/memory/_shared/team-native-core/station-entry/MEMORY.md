---
name: _shared.team-native-core.station-entry
scopePath: Shared/skills/
description: >-
  專案記憶：Team board、派工與 station entry。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T00:02:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
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

# _shared.team-native-core.station-entry — Module Memory

## Current Truth

- Owns programming-team governance, Team board, station handoff, and delegation entry sources.
- Board, station, handoff, role separation, and Team delivery artifacts activate only when `execution-routing` resolves delegated topology.
- Explicit delegation, independent parallel streams, necessary separation of duties, unresolved context after narrowing, or a formal platform/process requirement can activate delegated topology.
- Fix, build, debug, test, source or policy edits, repository analysis, multi-file work, multi-step work, and subagent availability are non-triggers by themselves.

## Active Constraints

- Preserve full Team role boundaries when delegated mode is active.
- Do not turn station entry skills into a generic Direct workflow requirement.

## Cycle Events

- 02: Reconciled Team station-entry skills with delegated-only activation and explicit non-trigger boundaries.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skills/programming-team-governance/SKILL.md
- source:Shared/skills/team-task-board/SKILL.md
- source:Shared/skills/delegation-strategy/SKILL.md
- source:Shared/policies/execution-routing.md

## Read Contract

- Read when changing owned Team entry or delegation sources.
- Do not use for ordinary Direct work that has not resolved delegated topology.

## Conflicts and Supersession

- superseded: generic engineering activity as sufficient Team activation.

## 中文摘要

- Team board、station 與 handoff 僅在 delegated topology 下啟動。
- 多檔、多步、build、debug、test 或 source edit 本身不是 Team trigger。
- delegated 後既有的角色邊界仍完整保留。

## Tracked Files

- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/team-task-board/references/board-field-catalog.md
- Shared/skills/team-task-board/references/board-templates-and-delivery.md
- Shared/skills/team-station-handoff-packet/SKILL.md
- Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md
- Shared/skills/team-station-handoff-packet/references/packet-schema-and-routing.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/delegation-strategy/references/team-dispatch-gates.md
- .agents/skills/delegation-strategy/SKILL.md
- Shared/skills/team-task-board/references/board-field-channel-and-receipts.md
- Shared/skills/team-task-board/references/board-field-slice-and-roles.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related routing policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
