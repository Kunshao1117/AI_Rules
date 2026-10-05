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
verification_status: pending_review
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


- Owns execution-routing, authorization-resolution, task-capability-assessment, implementation-stability and the repository-source reconciliation evidence method.
- `execution-routing` owns execution_mode (direct, assisted, team) and change_impact. Authorization Resolution independently owns authorization_class (observe, local_work, protected); legacy execution_topology is frozen compatibility only.
- Repository Source Reconciliation is a narrowly authorized and independently reviewed existing-source-card boundary. It does not activate M5, call Memory mutation tools or synchronize a runtime index.

## Active Constraints

- Direct local writes never authorize protected actions.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- Source-only comparison: `Shared/policies/execution-routing.md`, `Shared/policies/authorization-resolution.md`, `Shared/policies/references/repository-memory-reconciliation.md`.
- Earlier entries below are historical evidence; preserved timestamps do not certify current runtime or index state.

- source:Shared/policies/execution-routing.md, Shared/policies/authorization-resolution.md

## Read Contract

- Read when changing owned routing or authorization policies.

## Conflicts and Supersession


- The old execution_topology/action_risk ownership statement applies only to historical compatibility semantics.
- Original card and prior claims remain in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/b61b27c2d0a6d65d08ded101d323d62cf06d2098/.agents/memory/_shared/team-native-core/policy-core/routing/MEMORY.md); existing Cycle Events and archives are preserved.
- Current review is bounded to the cited source semantics and tracking; provider/index/runtime synchronization and unreviewed historical assertions remain unverified.

## 中文摘要


- 此卡負責執行路由、授權、能力與穩定度
- Direct／Assisted／Team 與 observe／local_work／protected 分別由路由與授權政策決定
- 受控來源卡校正不等於 runtime cutover 或索引同步

## Tracked Files

- Shared/policies/authorization-resolution.md
- Shared/policies/references/repository-memory-reconciliation.md
- Shared/policies/execution-routing.md
- Shared/policies/implementation-stability.md
- Shared/policies/task-capability-assessment.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.team-native-core.policy-core.orchestration (sibling card: Team orchestration)

## Applicable Skills

- memory-ops — Follow current source-only or runtime applicability; this card does not authorize mutation.
