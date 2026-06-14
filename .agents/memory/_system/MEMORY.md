---
name: _system
scopePath: .
description: >-
  專案記憶：框架系統層、根文件與部署治理導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T03:31:57+08:00'
status: stale
staleness: 10
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: partial_evidence
last_verified: '2026-06-15T03:28:12+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
<!-- CARTRIDGE_SYSTEM_WARNING_START -->

> [!CAUTION]
> 🟠 **系統強制攔截**：此記憶已過期失真！
> 追蹤檔案異動：`CHANGELOG.md`（2026-06-15T04:57:18+08:00）
> AI 嚴禁基於此記憶施工，必須優先閱讀最新原始碼並更新此記憶卡。
> staleness: 10 | threshold: 🟠 顯著過期

<!-- CARTRIDGE_SYSTEM_WARNING_END -->
# _system — Repository Governance Memory

## Current Truth
- AI_Rules is the source repository for Antigravity, Claude Edition, and Codex Edition governance.
- Director-facing output must use Traditional Chinese unless a lower-level artifact explicitly requires another language.
- Root repository work, git status, commit, tag, and push operations use `D:\AI_Rules` as the baseline.
- The shared source memory store is `.agents/memory/`; project context is `.agents/context/`.
- The PowerShell deployment implementation moved to child card `_system.scripts` for file ownership.
- Root documentation describes 08 as a deep evidence audit with depth modes, inventories, coverage denominators, and log-only intermediate evidence.

## Active Constraints
- Do not commit, push, tag, publish, install, upgrade, or mutate external state without explicit Director approval.
- Do not edit another repository, including `D:\cartridge_system`, unless the Director explicitly approves cross-repository work.
- Keep root memory concise; move script-specific facts to `_system.scripts` and historical release details to archives.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split root PowerShell script ownership into `_system.scripts`.
- 03: Recorded changelog summary for the memory main-file migration and split commit.
- 04: Updated root documentation for the deep evidence audit model and inventory log artifact.

## Archive Index
- archive-001.md — Legacy _system card identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.
- archive-003.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_system/archive-003.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified root script ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized script child-card creation.

## Read Contract
- Read this card for repository-level governance, release baseline, and memory/context boundaries.
- Read `_system.scripts` before changing root PowerShell scripts.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- AI_Rules 是三平台治理框架核心庫。
- 根層 Git 與發布操作以 `D:\AI_Rules` 為基準。
- PowerShell 腳本已拆到 `_system.scripts` 子卡。

## Tracked Files
- .gitignore
- README.md
- CHANGELOG.md
- LICENSE

## Relations
- _map (memory navigation index)
- _shared (Shared governance source)
- _codex_core (Codex platform source)
- _claude_core (Claude platform source)
- _ag_core (Antigravity platform source)
- _system.scripts (child card: root PowerShell scripts)

## Applicable Skills
- memory-ops — Use when updating this card.
- memory-arch — Use when adding or changing child-card topology.
- plugin-release-governance — Use when VSIX, tag, or GitHub Release behavior changes.
