---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T00:02:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-17-001
cycle_event_count: 4
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

# _system.scripts — Repository Script Governance Memory

## Current Truth

- Owns root PowerShell deployment, synchronization, platform-adapter, migration, and Team-Native runner sources listed below.
- `Manager.ProjectSync` advances a target `VERSION` only after every required synchronization stage succeeds.
- Antigravity and Claude preflight failure or a declined managed update returns without writing `VERSION` and does not report success.
- `Manager.Commands` removes command-entry result-object leakage without swallowing real errors.
- PowerShell compatibility evidence must name the executed shell; a `pwsh` pass alone does not prove Windows PowerShell 5.1 compatibility.

## Active Constraints

- Do not perform real install, upgrade, or target mutation for ordinary verification.
- Preserve UTF-8 BOM requirements for tracked non-ASCII Windows PowerShell 5.1 import-chain modules.

## Cycle Events

- 04: Reconciled project-sync version safety, platform preflight/decline behavior, and command-result error handling with the merged source contract.

## Archive Index

- archive-003.md — Pre-R2 watcher, hook, and script-validation history compacted on 2026-07-17.
- archive-002.md — script governance events 23-30; archive-001.md — older events 09-21.

## Evidence Base

- source:Scripts/modules/Manager.Commands.psm1
- source:Scripts/modules/Manager.ProjectSync.psm1
- source:Scripts/modules/Platform-Antigravity.psm1 and Scripts/modules/Platform-Claude.psm1
- source:Tests/TeamNative/ManagerSyncProjectRules.Tests.ps1 and Tests/TeamNative/PlatformPolicyPreflight.Tests.ps1

## Read Contract

- Read for owned root PowerShell, synchronization, and platform-adapter behavior.
- Do not use for temporary fixture noise, runtime receipts, or unexecuted compatibility claims.

## Conflicts and Supersession

- superseded: writing `VERSION` before required sync success, or treating declined update as successful mutation.

## 中文摘要

- required stage 全數成功後才可更新 `VERSION`。
- Antigravity/Claude 的 preflight failure 或使用者拒絕 update 都不寫入 `VERSION`。
- `Manager.Commands` 不再洩漏 result object，也不吞掉真實錯誤。

## Tracked Files

- Scripts/Deploy.ps1
- Scripts/Watch-CodexModelV1.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Memory-Migration.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
- Scripts/Audit-SourceSize.ps1
- Scripts/Test-TeamNativeV2.ps1
- Scripts/modules/Core.Cleanup.psm1
- Scripts/modules/Core.Comparison.psm1
- Scripts/modules/Core.Gitignore.psm1
- Scripts/modules/Core.Infrastructure.psm1
- Scripts/modules/Core.ProjectSkills.psm1
- Scripts/modules/Core.Reporting.psm1
- Scripts/modules/Core.Upgrade.psm1
- Scripts/modules/Manager.Commands.psm1
- Scripts/modules/Manager.Config.psm1
- Scripts/modules/Manager.Deployment.psm1
- Scripts/modules/Manager.ProjectSync.psm1
- Scripts/modules/SourceSize-Audit.psm1

## Relations

- _system (parent governance)
- _shared.adapters-workflow (related adapter contract)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
