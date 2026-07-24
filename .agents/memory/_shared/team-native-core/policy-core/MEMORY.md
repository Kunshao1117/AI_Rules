---
name: _shared.team-native-core.policy-core
scopePath: Shared/policies/
description: >
  專案記憶：Team-Native 核心政策與 adapter 入口。Use when: task touches this split memory
  scope or its tracked files.
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

# _shared.team-native-core.policy-core — Module Memory

## Current Truth

- Owns Team-Native core, authorization, workflow, trace, and subagent-entry policies.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Team roles, authorization, validation, review, memory closure, and completion remain separate responsibilities.
- Parent/child navigation is not a staleness dependency.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/authorization-resolution.md
- source:.agents/shared/policies/subagent-invocation.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- Team-Native 核心政策與 adapter 入口。
- 具體檔案歸屬已由父卡移入此子卡。

## Tracked Files

- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/policies/platform-plan-mapping.md
- .agents/shared/policies/subagent-invocation.md

- Shared/policies/requirement-precision.md
- Shared/policies/references/requirement-precision-schema.md

## Relations

- _shared.team-native-core (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
