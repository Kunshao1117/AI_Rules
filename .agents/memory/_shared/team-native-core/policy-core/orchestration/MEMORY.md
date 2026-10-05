---
name: _shared.team-native-core.policy-core.orchestration
scopePath: Shared/policies/
description: >
  專案記憶：Team-Native 編排、子代理與計畫對應。Use when: task touches team-native-core,
  team-trace-evidence, subagent-invocation, workflow-orchestration, or
  platform-plan-mapping.
last_updated: '2026-08-17T21:12:56+08:00'
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

# _shared.team-native-core.policy-core.orchestration — Module Memory

## Current Truth


- Owns Team-native-core, team-trace-evidence, subagent-invocation, workflow-orchestration, orchestration scenarios, and platform-plan-mapping.
- Current execution_mode distinguishes Direct, Assisted and Team. Helper-only use defaults to Assisted unless an evidenced Team trigger applies. Cursor is a peer platform; adapters do not redefine core governance.
- Main owns general work and may implement while a distinct reviewer/verifier supplies required independent judgment. Results are bound to the reviewed source revision.
- Legacy captain, station, board and fixed-chain bodies are compatibility-only for applicable frozen consumers; they are not general Team prerequisites.

## Active Constraints


- Implementation ownership cannot be relabeled as independent review/verification by changing tools or windows.
- Keep frozen consumer fields and receipts in their original semantics; a vNext assignment does not manufacture them.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- Source-only comparison: `Shared/policies/execution-routing.md`, `Shared/policies/agent-governance.md`, `Shared/policies/team-native-core.md`, `Shared/policies/platform-plan-mapping.md`.
- Earlier entries below are historical evidence; preserved timestamps do not certify current runtime or index state.

- source:Shared/policies/team-native-core.md, Shared/policies/workflow-orchestration.md, Shared/policies/platform-plan-mapping.md

## Read Contract

- Read when changing owned Team orchestration policies.

## Conflicts and Supersession


- Delegated-topology-only activation and captain-only/no-implementation claims are legacy compatibility, not general-work rules.
- Original card and prior claims remain in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/b61b27c2d0a6d65d08ded101d323d62cf06d2098/.agents/memory/_shared/team-native-core/policy-core/orchestration/MEMORY.md); existing Cycle Events and archives are preserved.
- Current review is bounded to the cited source semantics and tracking; provider/index/runtime synchronization and unreviewed historical assertions remain unverified.

## 中文摘要


- 此卡負責Team編排、子代理與計畫對應
- Helper-only預設Assisted；Team需正向觸發條件
- Main可實作，但必要獨立審查須由非作者負責；舊站點鏈僅適用frozen consumer

## Tracked Files

- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.team-native-core.policy-core.routing (sibling card: routing and authorization)
- _cursor_core (related Cursor platform memory)

## Applicable Skills

- memory-ops — Follow current source-only or runtime applicability; this card does not authorize mutation.
