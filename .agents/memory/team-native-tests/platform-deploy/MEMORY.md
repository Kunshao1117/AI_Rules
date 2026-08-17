---
name: team-native-tests.platform-deploy
scopePath: Tests/TeamNative/
description: >
  專案記憶：平台 Fresh／Upgrade 與同步測試。Use when: task touches platform deploy test
  contracts.
last_updated: '2026-08-17T20:56:09+08:00'
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

# team-native-tests.platform-deploy — Module Memory

## Current Truth

- Owns Codex and Cursor Fresh/Upgrade tests, policy preflight, Manager Auto-sync, Claude public sync entry, and Skills-Sync policy-failure coverage.
- Cursor Fresh deploys `02-platform-identity.mdc` and does not install `hooks.json`.

## Active Constraints

- Tests remain source-owned here; one-run fixture output does not enter source memory.

## Cycle Events

- 01: Created during the tests split after Cursor Edition coverage.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Tests/TeamNative/PlatformCursorFreshUpgrade.Tests.ps1, Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1

## Read Contract

- Read when changing owned platform deploy tests.

## Conflicts and Supersession

- superseded: cleanup tests that delete modified hook artifacts.

## 中文摘要

- 此卡負責各平台 Fresh／Upgrade 與同步契約。
- Cursor 會部署身分規則，且不安裝 hooks。

## Tracked Files

- Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1
- Tests/TeamNative/PlatformCursorFreshUpgrade.Tests.ps1
- Tests/TeamNative/PlatformPolicyPreflight.Tests.ps1
- Tests/TeamNative/ManagerSyncProjectRules.Tests.ps1
- Tests/TeamNative/ClaudeDeploySyncEntry.Tests.ps1
- Tests/TeamNative/SkillsSync.PolicyFailure.Tests.ps1

## Relations

- team-native-tests (parent card: navigation only)
- _system.scripts.platforms (related deploy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
