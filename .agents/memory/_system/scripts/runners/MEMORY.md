---
name: _system.scripts.runners
scopePath: Scripts/
description: >
  專案記憶：審計、測試、監視與記憶遷移 runner。Use when: task touches Audit, Test, Watch, or
  Memory-Migration scripts.
last_updated: '2026-08-17T20:55:50+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
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

# _system.scripts.runners — Module Memory

## Current Truth

- Owns source-size audit, Team-Native test runner, Codex model watcher, and memory-migration module.

## Active Constraints

- Dry-run is the default for memory migration. Apply requires explicit flags.
- Ordinary verification must not mutate install or upgrade targets.

## Cycle Events

- 01: Created during the scripts split.

## Archive Index

- Parent archive-005.md records the pre-split file list.

## Evidence Base

- source:Scripts/Test-TeamNativeV2.ps1, Scripts/modules/Memory-Migration.psm1, Scripts/Audit-SourceSize.ps1

## Read Contract

- Read when changing audit, test, watch, or migration runners.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責審計、測試、監視與記憶遷移 runner。
- 記憶遷移預設 dry-run，套用需要明確旗標。

## Tracked Files

- Scripts/Audit-SourceSize.ps1
- Scripts/Test-TeamNativeV2.ps1
- Scripts/Watch-CodexModelV1.ps1
- Scripts/modules/Memory-Migration.psm1

## Relations

- _system.scripts (parent card: navigation only)
- team-native-tests (related contract tests)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
