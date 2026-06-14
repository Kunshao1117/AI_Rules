# Migration Archive - _system

- Created: 2026-06-15T02:21:28+08:00
- Reason: Preserve pre-standardization active memory content before MEMORY.md quality migration.
- Scope: Active main card content only; existing archive volumes were not rewritten.

--- preserved active card ---

---
name: _system
description: >
  全域系統設定與框架工作模式記憶卡。保存 AI_Rules 根層目前有效治理事實。 Use when:
  修改根層文件、部署腳本、提交規則、發布治理或跨平台全域契約時。
scopePath: .
last_updated: '2026-06-14T16:18:30+08:00'
status: stale
staleness: 30
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 11
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
- Root documentation now describes design-to-build contracts, autonomous governance depth, functional modularity, and interface adaptation evidence as framework-wide governance semantics.
- Root documentation now defines cross-project real execution evidence as a framework-wide completion requirement.
- Root documentation and platform capability governance now define operator-path verification retention: search available operation tools, retry transient failures, and use equivalent real-path alternatives before blocked validation is accepted.
- Root documentation now defines full-spectrum evidence-based health audit semantics: project-surface detection, platform capability snapshots, dynamic audit modules, intermediate audit logs, and no green status without evidence.
- Root documentation now describes all-workflow external grounding: 00-12 workflows share external best-practice anchors, minimum evidence states, platform differences, and route-back rules.

## Active Constraints

- Do not commit, push, tag, publish, install, upgrade, or mutate external state without explicit Director approval.
- Do not edit another repository, including `D:\cartridge_system`, unless the Director explicitly approves cross-repository work.
- Keep root memory concise; move historical release and workflow details into archive volumes.
- This card still needs a later child-card split for deployment scripts if script ownership grows further.

## Cycle Events

- 01: Compacted legacy system memory into schema v2 and archived historical detail.
- 02: Split oversized legacy archive into two bounded archive volumes.
- 03: Aligned root documentation with flat archive files and advisory granularity.
- 04: Documented design-to-build, functional modularity, and interface adaptation governance.
- 05: Documented autonomous governance depth as a shared framework decision.
- 06: Documented the cross-project real execution evidence contract in root and platform docs.
- 07: Documented operator-path discovery, transient retry, and equivalent real-path fallback as framework-wide verification requirements.
- 08: Added changelog coverage for the real verification and operator-path governance update.
- 09: Documented the full-spectrum evidence-based health audit architecture and log-only evidence boundary in root README.
- 10: Documented the all-workflow external grounding matrix in root README and connected it to platform capability translation.
- 11: Added changelog coverage for the evidence audit and all-workflow grounding release cycle.

## Archive Index

- archive-001.md — Legacy _system card identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.

## 中文摘要

- AI_Rules 是三平台治理框架核心庫。
- 根層 Git 與發布操作以 `D:\AI_Rules` 為基準。
- 記憶卡已改採新版壓縮模型。
- 跨 repo 修改必須先取得明確授權。
- 根層文件已說明 8 檔是建議門檻，非硬阻擋。
- AI 自治分級以不確定就升級為預設。
- 跨專案驗證必須保留操作者工具搜尋、重試與等價真實路徑。
- 跨專案真實驗證契約已寫入根層文件。
- 全光譜健檢會先判定專案型態與平台能力，證據不足只能標記未驗證或阻塞。
- 00 到 12 工作流現在以共用矩陣承接外部最佳實務、最低證據與路由規則。

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
