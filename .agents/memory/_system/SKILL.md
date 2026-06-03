---
name: _system
description: >
  全域系統設定與框架工作模式記憶卡。保存 AI_Rules 根層目前有效治理事實。 Use when:
  修改根層文件、部署腳本、提交規則、發布治理或跨平台全域契約時。
scopePath: .
last_updated: '2026-06-04T04:17:43+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _system — Repository Governance Memory

## Current Truth

- AI_Rules is the source repository for Antigravity, Claude Edition, and Codex Edition governance.
- Director-facing output must use Traditional Chinese unless a lower-level artifact explicitly requires another language.
- Root repository work, git status, commit, tag, and push operations use `D:\AI_Rules` as the baseline.
- The shared source memory store is `.agents/memory/`; project context is `.agents/context/`.
- Memory schema v2 separates current truth, active constraints, cycle events, archive index, and Chinese summary.
- Root documentation describes memory granularity as advisory by file count and hard by size, line, event, and archive limits.
- The PowerShell deployment engine is the shared implementation path for Fresh, Upgrade, Audit, Global, and project sync flows.
- Public Windows PowerShell entrypoints must preserve UTF-8 compatibility for Windows PowerShell 5.1.
- VSIX publishing is governed separately from Codex, Claude, and Antigravity framework versioning.

## Active Constraints

- Do not commit, push, tag, publish, install, upgrade, or mutate external state without explicit Director approval.
- Do not edit another repository, including `D:\cartridge_system`, unless the Director explicitly approves cross-repository work.
- Keep root memory concise; move historical release and workflow details into archive volumes.
- This card still needs a later child-card split for deployment scripts if script ownership grows further.

## Cycle Events

- 01: Compacted legacy system memory into schema v2 and archived historical detail.
- 02: Split oversized legacy archive into two bounded archive volumes.
- 03: Aligned root documentation with flat archive files and advisory granularity.

## Archive Index

- archive-001.md — Legacy _system card identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.

## 中文摘要

- AI_Rules 是三平台治理框架核心庫。
- 根層 Git 與發布操作以 `D:\AI_Rules` 為基準。
- 記憶卡已改採新版壓縮模型。
- 跨 repo 修改必須先取得明確授權。
- 根層文件已說明 8 檔是建議門檻，非硬阻擋。

## Tracked Files

- .gitignore
- README.md
- CHANGELOG.md
- LICENSE
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
- .agents/memory/_system/archive-001.md
- .agents/memory/_system/archive-002.md

## Relations

- _map (memory navigation index)
- _shared (Shared governance source)
- _codex_core (Codex platform source)
- _claude_core (Claude platform source)
- _ag_core (Antigravity platform source)
- _vscode_extension (VS Code manager and VSIX release memory)

## Applicable Skills

- memory-ops — Use when updating this card.
- memory-arch — Use when splitting deployment script ownership into child cards.
- plugin-release-governance — Use when VSIX, tag, or GitHub Release behavior changes.
