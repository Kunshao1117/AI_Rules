---
name: _shared.team-native-core.policy-execution
scopePath: Shared/policies/references/
description: |
  專案記憶：執行參考契約導覽父卡。Use when: task needs navigation to this split memory family.
last_updated: '2026-08-17T20:56:42+08:00'
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

# _shared.team-native-core.policy-execution — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete reference-contract ownership belongs to its child cards.
- References support canonical policies and must not become a second policy owner.

## Active Constraints

- Do not add concrete tracked files back to this parent.
- Existing rule files remain observed or explicitly managed; they are never silently overwritten.

## Cycle Events

- 01: Split execution references into workflow, runtime-surface, auth-status, and team-trace child cards.

## Archive Index

- archive-002.md — Pre-split 2026-08-17 reference ownership.
- archive-001.md — Pre-2026-08-17 cycle events.

## Evidence Base

- source:Shared/policies/references/source-runtime-surface-map.md

## Read Contract

- Read only to select the child card that owns the concrete reference files.

## Conflicts and Supersession

- superseded: a single execution card owning all reference contracts.

## 中文摘要

- 此父卡只保留執行參考導覽。
- 工作流、runtime 表面、授權狀態與 team-trace 已拆到子卡。

## Tracked Files

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-execution.workflow-refs (child card: workflow reference contracts)
- _shared.team-native-core.policy-execution.runtime-surface (child card: source/runtime and hook surfaces)
- _shared.team-native-core.policy-execution.auth-status (child card: authorization and status machines)
- _shared.team-native-core.policy-execution.team-trace (child card: captain, delivery, and trace fields)
- _shared.team-native-core.policy-core (related canonical policy memory)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
