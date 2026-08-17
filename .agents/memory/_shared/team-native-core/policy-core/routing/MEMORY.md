---
name: _shared.team-native-core.policy-core.routing
scopePath: Shared/policies/
description: >
  專案記憶：執行路由、授權、能力與穩定度政策。Use when: task touches execution-routing,
  authorization-resolution, task-capability-assessment, or
  implementation-stability.
last_updated: '2026-08-17T21:12:54+08:00'
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

# _shared.team-native-core.policy-core.routing — Module Memory

## Current Truth

- Owns execution-routing, authorization-resolution, task-capability-assessment, and implementation-stability.
- `execution-routing` uniquely owns `execution_topology`, `change_impact`, and `action_risk`; ordinary work is Direct-first.

## Active Constraints

- Direct local writes never authorize protected actions.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/execution-routing.md, Shared/policies/authorization-resolution.md

## Read Contract

- Read when changing owned routing or authorization policies.

## Conflicts and Supersession

- superseded: Team-default ordinary routing.

## 中文摘要

- 此卡負責執行路由、授權、能力與穩定度。
- 需求、編排與驗證歸其他子卡。

## Tracked Files

- Shared/policies/authorization-resolution.md
- Shared/policies/execution-routing.md
- Shared/policies/implementation-stability.md
- Shared/policies/task-capability-assessment.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.team-native-core.policy-core.orchestration (sibling card: Team orchestration)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
