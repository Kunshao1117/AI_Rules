---
name: team-native-tests
scopePath: Tests/TeamNative/
description: >
  專案記憶：Team-Native 測試導覽父卡。Use when: task needs navigation to this split test
  memory family.
last_updated: '2026-08-17T20:56:43+08:00'
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

# team-native-tests — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete test ownership belongs to its child cards.
- Failure classification precedes product, test, or checker repair.
- `logs/` runtime artifacts are generated evidence, not source memory.

## Active Constraints

- Do not add concrete tracked files back to this parent.
- Expectation changes require an independent oracle.

## Cycle Events

- 01: Split test ownership into platform-deploy, parity-ux, contract, and compat child cards.

## Archive Index

- archive-002.md — Pre-split 2026-08-17 test ownership.
- archive-001.md — Pre-2026-08-17 cycle events and long-form coverage notes.

## Evidence Base

- source:Tests/TeamNative/PlatformCursorFreshUpgrade.Tests.ps1

## Read Contract

- Read only to select the child card that owns the concrete test files.

## Conflicts and Supersession

- superseded: a single tests card owning the full Team-Native suite.

## 中文摘要

- 此父卡只保留測試導覽。
- `logs/` 不是來源記憶。測試失敗要先分類。

## Tracked Files

## Relations

- team-native-tests.platform-deploy (child card: platform Fresh/Upgrade and sync tests)
- team-native-tests.parity-ux (child card: source/runtime parity and UX tests)
- team-native-tests.contract (child card: requirement, delivery, and credential-boundary tests)
- team-native-tests.compat (child card: size, encoding, and parser tests)
- _shared.team-native-core.policy-core (related governance memory)
- _cursor_core.runtime (related Cursor runtime memory)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
