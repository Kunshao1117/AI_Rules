---
name: _shared.team-native-core.policy-execution.runtime-surface
scopePath: Shared/policies/references/
description: >
  專案記憶：來源／runtime、hook 與 workspace 表面。Use when: task touches source-runtime,
  hook, platform-copy, or bootstrap references.
last_updated: '2026-08-17T20:55:51+08:00'
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

# _shared.team-native-core.policy-execution.runtime-surface — Module Memory

## Current Truth

- Owns source/runtime map, hook-event matrix, platform-copy map, workspace-bootstrap, and cross-thread handoff references.
- Cursor `.cursor/rules/00-core.mdc` and `02-platform-identity.mdc` pair with `Cursor/.cursor/rules/`.
- AI_Rules installs no repository-local Team-routing hooks.

## Active Constraints

- Do not treat observed runtime files as canonical source.

## Cycle Events

- 01: Created during the execution-reference split after Cursor identity surfaces.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/policies/references/source-runtime-surface-map.md, Shared/policies/references/hook-event-matrix.md

## Read Contract

- Read when changing owned runtime-surface references.

## Conflicts and Supersession

- superseded: runtime-active Team hook lifecycle as default state.

## 中文摘要

- 此卡負責來源／runtime、hook 與 workspace 表面。
- Cursor 混倉身分已列入對照；預設不部署 Team hook。

## Tracked Files

- Shared/policies/references/hook-event-matrix.md
- Shared/policies/references/platform-copy-map.md
- Shared/policies/references/source-runtime-surface-map.md
- Shared/policies/references/workspace-bootstrap-contract.md
- Shared/policies/references/cross-thread-handoff-contract.md

## Relations

- _shared.team-native-core.policy-execution (parent card: navigation only)
- _cursor_core.runtime (related Cursor runtime memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
