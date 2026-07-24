---
name: team-native-tests
scopePath: Tests/TeamNative/
description: >
  專案記憶：Team-Native PowerShell 契約測試。Use when: task touches Team-Native test
  fixtures, contract coverage, or source/deployment parity assertions.
last_updated: '2026-07-25T00:57:08+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-25T00:54:59+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 3
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

- This root card owns the Team-Native PowerShell contract test suite.
- The suite covers captain decisions, delivery slices, memory-closure bundles, source-size budgets, oversize inventory, requirement precision, and source/deployment parity.
- `Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1` owns the focused Windows PowerShell 5.1 parser/import regression route for Manager import-chain UTF-8 BOM compatibility.
- The Windows PowerShell 5.1 regression now covers nested module-scope `Get-UpgradeReport` self-compare.
- Focused regressions cover project-skill UTF-8 BOM behavior, shared-policy synchronization failures, three-platform policy preflight, Codex Fresh/Upgrade pointer idempotence, and Manager project-sync aggregation.
- Isolated inventory fixtures restore the caller working directory; the default Team-Native runner resolves its suite path from its script location.

## Active Constraints

- Test files are source-owned here; runtime artifacts remain excluded from source memory.
- Test execution, repair, and external effects require their own scoped workflow authority.

## Cycle Events

- 01: Created during the authorized memory organization to own the Team-Native test suite.
- 02: Added ownership for the focused Windows PowerShell 5.1 parser/import compatibility regression test.
- 03: Added policy-preflight, policy-sync failure, Codex pointer, project-sync, and project-skill encoding regressions.

## Archive Index

- None yet.

## Evidence Base

- source:Tests/TeamNative/CaptainDecision.Tests.ps1
- source:Tests/TeamNative/SourceDeploymentParity.Tests.ps1
- source:Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1 — focused Windows PowerShell 5.1 parser/import compatibility regression coverage.
- source:Tests/TeamNative/ManagerSyncProjectRules.Tests.ps1, Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1, Tests/TeamNative/PlatformPolicyPreflight.Tests.ps1, Tests/TeamNative/PowerShell51ProjectSkillsEncoding.Tests.ps1, and Tests/TeamNative/SkillsSync.PolicyFailure.Tests.ps1 — current focused regression coverage.
- tool:memory_status — No existing root memory owner covered this test scope.

## Read Contract

- Read when working on Team-Native PowerShell test contracts or their tracked sources.
- Do not use for generated test artifacts or one-run output.

## Conflicts and Supersession

- None.

## 中文摘要

- 此根卡負責 Team-Native 的 PowerShell 契約測試。
- artifacts 不歸此卡；只追蹤測試原始碼。
- PS 5.1 parser/import 相容性回歸測試由此卡負責。
- 新增 PS 5.1 編碼、同步 fail-closed、三平台預檢、Codex Fresh/Upgrade 與 project-sync 的聚焦回歸；隔離 fixture 會還原呼叫端 CWD。

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

- _shared.team-native-core (related governance memory)

## Applicable Skills

- memory-ops — Update and commit this test-owner card.
- memory-arch — Adjust memory topology only when scope changes.
