---
name: _shared.team-native-core.policy-execution
scopePath: Shared/policies/references/
description: >
  專案記憶：Team-Native 執行、phase 與狀態參考。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-24T13:54:43+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-24T13:54:12+08:00'
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

# _shared.team-native-core.policy-execution — Module Memory

## Current Truth

- Owns Team-Native execution, lifecycle, authorization-phase, protection, and status references.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Team roles, authorization, validation, review, memory closure, and completion remain separate responsibilities.
- Parent/child navigation is not a staleness dependency.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/references/workflow-execution-spec-contract.md
- source:Shared/policies/references/cross-thread-handoff-contract.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- Team-Native 執行、phase 與狀態參考。
- 具體檔案歸屬已由父卡移入此子卡。

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

## Relations

- _shared.team-native-core (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
