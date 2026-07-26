---
name: _shared.team-native-core.policy-execution
scopePath: Shared/policies/references/
description: >-
  專案記憶：執行、相容性與 workspace bootstrap 參考契約。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-26T17:20:28+08:00'
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

# _shared.team-native-core.policy-execution — Module Memory

## Current Truth

- Owns execution, compatibility, status, source/runtime, and workspace-bootstrap reference contracts listed below.
- Legacy lanes are compatibility aliases only; the canonical decision model is independent topology, impact, and risk.
- Formal trace and deep audit are conditional routes for delegated, protected, release, migration, or explicit audit contexts, not ordinary Direct completion requirements.
- The workspace bootstrap reference resolves existing instructions, module boundaries, path classes, contracts, and commands uniformly for AI_Rules and other repositories.

## Active Constraints

- References support canonical policies and must not become a second policy owner.
- Existing rule files remain observed, overlaid, or explicitly managed; they are never silently overwritten.

## Cycle Events

- 02: Reconciled execution references with three-axis routing and uniquely attributed the workspace bootstrap contract.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/references/workflow-execution-spec-contract.md
- source:Shared/policies/references/workflow-lane-routing.md
- source:Shared/policies/references/workspace-bootstrap-contract.md
- source:Shared/policies/references/source-runtime-surface-map.md and Shared/policies/references/workflow-team-evidence.md

## Read Contract

- Read when changing owned reference contracts or tracing compatibility/runtime relationships.
- Do not use as a substitute for the owning canonical policy.

## Conflicts and Supersession

- superseded: five-lane routing as the main semantic model and formal trace for ordinary Direct work.

## 中文摘要

- Legacy lane 僅做相容 alias；主模型是 topology、impact、risk 三軸。
- formal trace 與 deep audit 都是條件式路徑。
- workspace bootstrap 對 AI_Rules 與其他 repository 使用同一 resolver。

## Tracked Files

- Shared/policies/references/workflow-execution-spec-contract.md
- Shared/policies/references/workflow-lane-routing.md
- Shared/policies/references/workflow-memory-evidence.md
- Shared/policies/references/workflow-orchestration-boundaries.md
- Shared/policies/references/workflow-review-visual-evidence.md
- Shared/policies/references/workflow-team-evidence.md
- Shared/policies/references/authorization-phase-registry.md
- Shared/policies/references/completion-state-machine.md
- Shared/policies/references/exception-registry.md
- Shared/policies/references/hook-event-matrix.md
- Shared/policies/references/platform-copy-map.md
- Shared/policies/references/protected-action-registry.md
- Shared/policies/references/source-runtime-surface-map.md
- Shared/policies/references/status-ontology.md
- Shared/policies/references/cross-thread-handoff-contract.md
- Shared/policies/references/team-native-core-captain-boundary.md
- Shared/policies/references/team-native-core-delivery-slice.md
- Shared/policies/references/team-trace-fields.md
- Shared/policies/references/team-trace-invalid-patterns.md
- Shared/policies/references/workspace-bootstrap-contract.md

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core (related canonical policy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
