---
name: _system.scripts.platforms
scopePath: Scripts/
description: |
  專案記憶：部署入口與平台 adapter。Use when: task touches Deploy or Platform-*.psm1.
last_updated: '2026-08-17T20:55:50+08:00'
status: stale
staleness: 10
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
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
<!-- CARTRIDGE_SYSTEM_WARNING_START -->

> [!CAUTION]
> 🟠 **系統強制攔截**：此記憶已過期失真！
> 追蹤檔案異動：`Scripts/modules/Platform-Cursor.psm1`（2026-08-17T21:42:02+08:00）
> AI 嚴禁基於此記憶施工，必須優先閱讀最新原始碼並更新此記憶卡。
> staleness: 10 | threshold: 🟠 顯著過期

<!-- CARTRIDGE_SYSTEM_WARNING_END -->

# _system.scripts.platforms — Module Memory

## Current Truth

- Owns `Deploy.ps1`, skill sync, and the four platform adapter modules.
- Cursor Fresh/Upgrade deploys rules to `.cursor/rules/` and merges skills into `.cursor/skills/`. Global install remains unchanged.
- VERSION updates only after required sync stages succeed.

## Active Constraints

- Do not treat cleanup failure as success.
- Do not Fresh-deploy onto the AI_Rules source repo to create a root `.cursor/` overlay.

## Cycle Events

- 01: Created during the scripts split after Cursor Edition v0.1.0.

## Archive Index

- Parent archive-005.md records the pre-split file list.

## Evidence Base

- source:Scripts/Deploy.ps1, Scripts/modules/Platform-Cursor.psm1, Scripts/modules/Skills-Sync.psm1

## Read Contract

- Read when changing deploy entry or platform adapters.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Deploy 與四平台 adapter。
- Cursor 規則進 `.cursor/rules/`，技能進 `.cursor/skills/`。

## Tracked Files

- Scripts/Deploy.ps1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
- Scripts/modules/Platform-Cursor.psm1
- Scripts/modules/SourceSize-Audit.psm1

## Relations

- _system.scripts (parent card: navigation only)
- _cursor_core.runtime (related Cursor runtime memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
