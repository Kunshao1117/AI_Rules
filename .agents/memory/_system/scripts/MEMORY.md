---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T20:51:16+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T20:47:17+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-17-001
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

# _system.scripts — Repository Script Governance Memory

## Current Truth

- Owns root PowerShell deployment, synchronization, platform-adapter, migration, and Team-Native runner sources listed below.
- `Manager.ProjectSync` resolves each platform adapter in preflight and applied sync, and advances a target `VERSION` only after every required stage succeeds.
- `Remove-CodexManagedLegacyTeamNativeHooks` retires legacy Codex Team hook artifacts only when the complete known hash-owned set matches. Its dry-run emits planned removal or user-modified preservation; any modified artifact preserves the full set for manual action.
- Codex fresh install deploys no legacy Team hook artifacts, and Codex upgrade/project sync wires the managed cleanup into its confirmed update path without treating cleanup failure as success.
- Antigravity and Claude preflight failure or a declined managed update returns without writing `VERSION` and does not report success.
- `Manager.Commands` removes command-entry result-object leakage without swallowing real errors.
- PowerShell compatibility evidence names the executed shell, and the Team-Native runner classifies only known fail-closed Pester fixture records while surfacing every unexpected PowerShell error record.

## Active Constraints

- Do not perform real install, upgrade, or target mutation for ordinary verification.
- Managed Codex cleanup must not remove filename-matching user-owned, global, plugin, or modified hook artifacts.
- Preserve UTF-8 BOM requirements for tracked non-ASCII Windows PowerShell 5.1 import-chain modules.

## Cycle Events

- 05: Added exact-hash Codex legacy Team-hook cleanup with fresh-install, upgrade, and user-modification safety.
- 06: Corrected Antigravity and Claude project-sync adapter paths and verified Auto selection across all installed platforms.
- 07: Preserved strict unexpected-error handling in the Team-Native runner after the governance CI adopted its verified `pwsh` host.

## Archive Index

- archive-003.md — Pre-R2 watcher, hook, and script-validation history compacted on 2026-07-17.
- archive-002.md — script governance events 23-30; archive-001.md — older events 09-21.

## Evidence Base

- source:Scripts/modules/Platform-Codex.psm1, Scripts/modules/Manager.ProjectSync.psm1, Scripts/modules/Manager.Config.psm1, Scripts/Deploy.ps1, and Tests/TeamNative/PlatformCodexFreshUpgrade.Tests.ps1 — Codex deployment plus fresh-install and managed/user-modified cleanup contract.
- source:Scripts/modules/Manager.Commands.psm1, Scripts/modules/Platform-Antigravity.psm1, and Scripts/modules/Platform-Claude.psm1 — existing version and command handling contracts.
- source:Scripts/Test-TeamNativeV2.ps1 and .github/workflows/governance.yml — test-runner error handling and CI host.

## Read Contract

- Read for owned root PowerShell, synchronization, and platform-adapter behavior.
- Do not use for temporary fixture noise, runtime receipts, or unexecuted compatibility claims.

## Conflicts and Supersession

- superseded: writing `VERSION` before required sync success, treating declined update as successful mutation, or deleting hook artifacts solely by filename.

## 中文摘要

- `VERSION` 只會在必要同步階段全數成功後更新。
- Codex legacy Team hook 只在完整 exact-hash 受管集合吻合時清理；使用者修改任一檔案就保留整組並要求手動處理。
- fresh install 不部署 legacy hook；upgrade/project sync 不得把 cleanup 失敗包裝成成功。
- 三平台 project sync 預檢與寫入都使用各自 adapter，不會將共用政策檔當成平台區塊來源。

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
