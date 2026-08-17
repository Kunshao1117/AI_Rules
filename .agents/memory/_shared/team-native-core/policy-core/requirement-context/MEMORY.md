---
name: _shared.team-native-core.policy-core.requirement-context
scopePath: Shared/policies/
description: >
  專案記憶：需求精度與專案脈絡解析政策。Use when: task touches requirement-precision, its schema,
  or project-context-resolution.
last_updated: '2026-08-17T21:12:55+08:00'
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

# _shared.team-native-core.policy-core.requirement-context — Module Memory

## Current Truth

- Owns requirement-precision, its schema, and project-context-resolution.
- Product goals stay with the user; AI chooses implementation methods only inside authorized scope.

## Active Constraints

- Advice or risk findings never authorize expansion.

## Cycle Events

- 01: Created during the remaining granularity split from policy-core.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/requirement-precision.md, Shared/policies/project-context-resolution.md

## Read Contract

- Read when changing owned requirement or context-resolution policies.

## Conflicts and Supersession

- superseded: mixing requirement/context ownership into a single 17-file policy-core card.

## 中文摘要

- 此卡負責需求精度與專案脈絡解析。
- 路由與編排歸其他子卡。

## Tracked Files

- Shared/policies/project-context-resolution.md
- Shared/policies/requirement-precision.md
- Shared/policies/references/requirement-precision-schema.md

## Relations

- _shared.team-native-core.policy-core (parent card: navigation only)
- _shared.memory-governance.context-migration (related context protocol)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
