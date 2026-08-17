---
name: team-native-tests.compat
scopePath: Tests/TeamNative/
description: >
  專案記憶：尺寸、編碼與解析器相容測試。Use when: task touches module-budget, oversize, or
  PowerShell 5.1 tests.
last_updated: '2026-08-17T20:56:13+08:00'
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

# team-native-tests.compat — Module Memory

## Current Truth

- Owns module-budget, oversize-inventory, PowerShell 5.1 parser, and project-skills encoding tests.

## Active Constraints

- Compatibility evidence must name the executed shell.

## Cycle Events

- 01: Created during the tests split.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1, Tests/TeamNative/ModuleBudget.Tests.ps1

## Read Contract

- Read when changing owned compatibility tests.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責模組預算、超限清冊與 PowerShell 5.1 相容測試。

## Tracked Files

- Tests/TeamNative/ModuleBudget.Tests.ps1
- Tests/TeamNative/OversizeInventory.Tests.ps1
- Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1
- Tests/TeamNative/PowerShell51ProjectSkillsEncoding.Tests.ps1

## Relations

- team-native-tests (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
