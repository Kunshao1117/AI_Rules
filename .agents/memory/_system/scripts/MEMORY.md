---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-18T12:00:22+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-17T20:28:23+08:00'
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
- `Scripts/Watch-CodexModelV1.ps1` remains experimental and replaces all exact V2 cache markers in its isolated fixture contract; it cannot prove platform capability or applied execution.
## Active Constraints
- Removed test or audit artifacts must not be cited as validation, runtime-capability, or completion evidence.
- PowerShell compatibility claims must name the shell actually executed; a `pwsh` pass does not prove Windows PowerShell 5.1 compatibility.
- Memory writes and `memory_commit` remain separate protected operations.
## Cycle Events
- 01: Compacted prior script history and recorded adapter-specific sync, separated R2 fixtures, and explicit PowerShell-version evidence boundaries.
## Archive Index
- archive-003.md — Pre-R2 watcher, hook, and script-validation history compacted on 2026-07-17.
- archive-002.md — script governance events 23-30; archive-001.md — older events 09-21.
## Evidence Base
- source: `Scripts/Deploy.ps1` and `Scripts/modules/Skills-Sync.psm1` — adapter-specific generated-marker synchronization.
- source/tool: current diff and exact-path checks — obsolete `Scripts/tests`, Audit module files, and hook fixtures are deleted; remaining empty directories carry no executable behavior.
## Read Contract
- Read for root PowerShell, audit/validation scripts, and the separate hook or V1 runner contracts.
## Conflicts and Supersession
- superseded: audit/fixture-test sources as current script functionality or as proof of runtime capability/applied model state.
## 中文摘要
- 部署腳本現在依平台讀取各自的 adapter，不再從共用政策擷取三種平台片段。
- 測試已拆成白話回報、檔案責任、V1 結構、模型選擇、收據、生命週期與 watcher 等獨立責任。
- `pwsh` 通過不代表 Windows PowerShell 5.1 通過；回報時必須說明實際使用哪個版本。
- watcher 仍是本機實驗工具，不能用來證明平台真的套用了某個模型。
## Tracked Files
- Scripts/Deploy.ps1
- Scripts/Watch-CodexModelV1.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Memory-Migration.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
## Relations
- _system (parent governance); _shared (Shared policy); _codex_core (adapter contract).
## Applicable Skills
- memory-ops — authorized source-memory update and separate commit procedure.
