---
name: team-native-tests.contract
scopePath: Tests/TeamNative/
description: >
  專案記憶：需求、交付與憑證邊界契約測試。Use when: task touches requirement, delivery, or
  credential-boundary tests.
last_updated: '2026-08-17T22:07:11+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T22:00:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
cycle_event_count: 2
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



# team-native-tests.contract — Module Memory

## Current Truth

- Owns requirement-precision, delivery-slice, memory-closure-bundle, captain-decision, and credential-boundary tests.
- Credential-boundary source/runtime parity is verified through a temporary deployed copy, not the gitignored mother-repo `.agents/shared/` tree.

## Active Constraints

- Do not treat `logs/` artifacts as source memory.

## Cycle Events

- 02: Moved credential-boundary source/runtime parity onto a temporary Sync-SharedGovernanceReferences copy.
- 01: Created during the tests split and attributed CredentialBoundary.Tests.ps1.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Tests/TeamNative/CredentialBoundary.Tests.ps1, Tests/TeamNative/RequirementPrecision.Tests.ps1

## Read Contract

- Read when changing owned contract tests.

## Conflicts and Supersession

- superseded: formatting-coupled requirement assertions.

## 中文摘要

- 此卡負責需求、交付、記憶收尾與憑證邊界測試。
- 憑證邊界日誌不算來源記憶。

## Tracked Files

- Tests/TeamNative/CaptainDecision.Tests.ps1
- Tests/TeamNative/DeliverySlice.Tests.ps1
- Tests/TeamNative/MemoryClosureBundle.Tests.ps1
- Tests/TeamNative/RequirementPrecision.Tests.ps1
- Tests/TeamNative/CredentialBoundary.Tests.ps1

## Relations

- team-native-tests (parent card: navigation only)
- _shared.team-native-core.memory-closure (related credential-boundary contract)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
