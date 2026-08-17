---
name: _shared.team-native-core.policy-execution.workflow-refs
scopePath: Shared/policies/references/
description: |
  專案記憶：工作流執行參考契約。Use when: task touches workflow-* reference contracts.
last_updated: '2026-08-17T20:55:50+08:00'
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

# _shared.team-native-core.policy-execution.workflow-refs — Module Memory

## Current Truth

- Owns workflow execution-spec, lane routing, memory-evidence, orchestration-boundary, review-visual, and team-evidence references, plus the managed runtime copy of the execution spec.

## Active Constraints

- These references support canonical orchestration policy and must not replace it.

## Cycle Events

- 01: Created during the execution-reference split.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/references/workflow-execution-spec-contract.md, Shared/policies/references/workflow-memory-evidence.md

## Read Contract

- Read when changing owned workflow reference contracts.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責工作流執行與證據參考契約。
- 不能取代 canonical orchestration 政策。

## Tracked Files

- Shared/policies/references/workflow-execution-spec-contract.md
- .agents/shared/policies/references/workflow-execution-spec-contract.md
- Shared/policies/references/workflow-lane-routing.md
- Shared/policies/references/workflow-memory-evidence.md
- Shared/policies/references/workflow-orchestration-boundaries.md
- Shared/policies/references/workflow-review-visual-evidence.md
- Shared/policies/references/workflow-team-evidence.md

## Relations

- _shared.team-native-core.policy-execution (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
