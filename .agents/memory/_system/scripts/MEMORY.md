---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-24T18:27:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:41:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-17-001
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


# _system.scripts — Repository Script Governance Memory
## Current Truth
- This card owns the remaining root PowerShell install, upgrade/deployment, synchronization, platform-adapter, memory-migration, and Watch-CodexModelV1 scripts; tracked source remains runtime authority.
- Deployment now reads one dedicated subagent adapter per platform and injects only that platform's generated marker.
- The former `Scripts/tests`, Doctor/Audit/Resolver, Audit engine, and fixture-test sources are removed; empty residual directories are not active functionality.
- PowerShell changes preserve Windows PowerShell 5.1 compatibility.
- Manager import-chain modules containing non-ASCII text must use UTF-8 BOM for Windows PowerShell 5.1 import compatibility: Core.Cleanup, Core.Gitignore, Core.Infrastructure, Core.Reporting, Core.Upgrade, and Manager.Commands.
- `Scripts/Watch-CodexModelV1.ps1` remains experimental and replaces all exact V2 cache markers in its isolated fixture contract; it cannot prove platform capability or applied execution.
## Active Constraints
- Removed test or audit artifacts must not be cited as validation, runtime-capability, or completion evidence.
- PowerShell compatibility claims must name the shell actually executed; a `pwsh` pass does not prove Windows PowerShell 5.1 compatibility.
- Validate this encoding boundary with `Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1` under Windows PowerShell 5.1; it covers parser targets and the `Manager.Commands` import route.
- Memory writes and `memory_commit` remain separate protected operations.
## Cycle Events
- 01: Compacted prior script history and recorded adapter-specific sync, separated R2 fixtures, and explicit PowerShell-version evidence boundaries.
- 02: Recorded the UTF-8 BOM requirement for non-ASCII Manager import-chain modules and its focused Windows PowerShell 5.1 validation route.
## Archive Index
- archive-003.md — Pre-R2 watcher, hook, and script-validation history compacted on 2026-07-17.
- archive-002.md — script governance events 23-30; archive-001.md — older events 09-21.
## Evidence Base
- source: `Scripts/Deploy.ps1` and `Scripts/modules/Skills-Sync.psm1` — adapter-specific generated-marker synchronization.
- source/tool: current diff and exact-path checks — obsolete `Scripts/tests`, Audit module files, and hook fixtures are deleted; remaining empty directories carry no executable behavior.
- source/validation: six Manager import-chain modules and `Tests/TeamNative/PowerShell51ParserCompatibility.Tests.ps1` — UTF-8 BOM compatibility rule and focused Windows PowerShell 5.1 regression route.
## Read Contract
- Read for root PowerShell, audit/validation scripts, and the separate hook or V1 runner contracts.
## Conflicts and Supersession
- superseded: audit/fixture-test sources as current script functionality or as proof of runtime capability/applied model state.
## 中文摘要
- 部署腳本現在依平台讀取各自的 adapter，不再從共用政策擷取三種平台片段。
- 測試已拆成白話回報、檔案責任、V1 結構、模型選擇、收據、生命週期與 watcher 等獨立責任。
- `pwsh` 通過不代表 Windows PowerShell 5.1 通過；回報時必須說明實際使用哪個版本。
- watcher 仍是本機實驗工具，不能用來證明平台真的套用了某個模型。
- 含非 ASCII 文字的 Manager 匯入鏈模組要使用 UTF-8 BOM，並以專用 PS 5.1 測試驗證。
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
- Scripts/modules/SourceSize-Audit.psm1
## Relations
- _system (parent governance); _shared (Shared policy); _codex_core (adapter contract).
## Applicable Skills
- memory-ops — authorized source-memory update and separate commit procedure.
