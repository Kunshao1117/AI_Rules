---
name: team-native-tests.parity-ux
scopePath: Tests/TeamNative/
description: >
  專案記憶：來源／runtime 對等與非工程師 UX 測試。Use when: task touches parity or UX test
  contracts.
last_updated: '2026-08-17T20:56:11+08:00'
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

# team-native-tests.parity-ux — Module Memory

## Current Truth

- Owns source/runtime parity, non-engineer UX, retired-reflection, and context-governance-migration tests.

## Active Constraints

- Do not assume ignored runtime files exist in a clean clone.

## Cycle Events

- 01: Created during the tests split.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Tests/TeamNative/SourceDeploymentParity.Tests.ps1, Tests/TeamNative/NonEngineerUx.Tests.ps1

## Read Contract

- Read when changing owned parity or UX tests.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責來源／runtime 對等、白話 UX、退休技能與脈絡遷移測試。

## Tracked Files

- Tests/TeamNative/SourceDeploymentParity.Tests.ps1
- Tests/TeamNative/NonEngineerUx.Tests.ps1
- Tests/TeamNative/RetiredReflectionSkills.Tests.ps1
- Tests/TeamNative/ContextGovernanceMigration.Tests.ps1

## Relations

- team-native-tests (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
