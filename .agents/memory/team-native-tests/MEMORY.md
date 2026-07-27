---
name: team-native-tests
scopePath: Tests/TeamNative/
description: >-
  專案記憶：Team-Native PowerShell 契約測試。Use when: task touches Team-Native test
  fixtures, contract coverage, or source/deployment parity assertions.
last_updated: '2026-07-27T08:21:16+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T03:07:18+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 5
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

# team-native-tests — Team-Native Test Memory

## Current Truth

- Owns the Team-Native PowerShell contract test suite listed below.
- `RequirementPrecision.Tests.ps1` protects semantic requirement provenance ownership and is newline-insensitive without reducing the explicit/inferred/unknown/conflict oracle.
- `DeliverySlice.Tests.ps1` protects station boundaries without coupling the contract to legacy lane wording.
- `ManagerSyncProjectRules.Tests.ps1` protects exact deployment, no result-object leakage, and version advancement only after required stages succeed.
- `PlatformCodexFreshUpgrade.Tests.ps1` protects a fresh Codex install without legacy Team hooks, exact-hash managed legacy cleanup, and preservation of a user-modified hook set.
- Stable validation routes include focused RequirementPrecision, DeliverySlice, PlatformCodexFreshUpgrade, PlatformPolicyPreflight, SourceDeploymentParity, and the aggregate Team-Native suite.
- `SourceDeploymentParity.Tests.ps1` also protects centralized beginner-facing reporting rules, source/runtime copy parity, status display labels, and platform-policy pointers.

## Active Constraints

- Tests remain source-owned here; runtime artifacts and one-run fixture output do not enter source memory.
- Failure classification precedes product, test, or checker repair; expectation changes require an independent oracle.

## Cycle Events

- 05: Added Codex fresh/upgrade and managed legacy-hook cleanup contract coverage.
- 06: Added deterministic reporting-policy and source/runtime parity checks without text snapshots.

## Archive Index

- None yet.

## Evidence Base

- source:Tests/TeamNative/RequirementPrecision.Tests.ps1
- source:Tests/TeamNative/DeliverySlice.Tests.ps1
- source:Tests/TeamNative/ManagerSyncProjectRules.Tests.ps1 and Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1
- source:Tests/TeamNative/PlatformPolicyPreflight.Tests.ps1 and Tests/TeamNative/SourceDeploymentParity.Tests.ps1
- source:Scripts/Test-TeamNativeV2.ps1

## Read Contract

- Read when changing Team-Native PowerShell test contracts or their tracked sources.
- Do not use for generated artifacts, raw run output, or a temporary fixture message that does not alter asserted coverage.

## Conflicts and Supersession

- superseded: formatting-coupled requirement assertions, legacy-lane-dependent delivery expectations, and cleanup tests that delete modified hook artifacts.

## 中文摘要

- Team-Native 測試保護 requirement provenance、station boundary 與同步/版本契約。
- `PlatformCodexFreshUpgrade` 保護 fresh install 不部署 legacy hook、exact-hash 受管清理，以及使用者修改整組的保留行為。
- 測試失敗要先分類，不能為綠燈直接改 expectation。
- SourceDeploymentParity 也檢查白話回報規則、狀態顯示與必要副本一致性。

## Tracked Files

- Tests/TeamNative/CaptainDecision.Tests.ps1
- Tests/TeamNative/DeliverySlice.Tests.ps1
- Tests/TeamNative/MemoryClosureBundle.Tests.ps1
- Tests/TeamNative/ModuleBudget.Tests.ps1
- Tests/TeamNative/OversizeInventory.Tests.ps1
- Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1
- Tests/TeamNative/RequirementPrecision.Tests.ps1
- Tests/TeamNative/SourceDeploymentParity.Tests.ps1
- Tests/TeamNative/ManagerSyncProjectRules.Tests.ps1
- Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1
- Tests/TeamNative/PlatformPolicyPreflight.Tests.ps1
- Tests/TeamNative/PowerShell51ProjectSkillsEncoding.Tests.ps1
- Tests/TeamNative/SkillsSync.PolicyFailure.Tests.ps1

## Relations

- _shared.team-native-core.policy-core (related governance memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
