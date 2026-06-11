---
name: _map
description: |
  框架記憶導航索引卡。只保留 Layer 1 主卡名稱、有效範圍與讀取路徑。 Use when: 對話啟動需要先判斷應讀取哪張記憶卡時。
scopePath: .agents/memory/
last_updated: '2026-06-11T18:15:07+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 2
cycle_event_limit: 30
size_limit_bytes: 8192
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
# _map — Memory Navigation Index

## Current Truth

- This card is a root memory index only.
- Startup readers use it to choose the next active Layer 1 card.
- It does not store historical decisions or implementation detail.
- Child cards are discovered through each parent card's Relations section.

## Active Constraints

- Keep this card under 8 KB.
- Do not add detailed history here.
- Update the module table when Layer 1 memory cards are added, deprecated, or renamed.

## Cycle Events

- 01: Upgraded the navigation index to schema v2 and archived the legacy body.
- 02: Cleared stale self-warning after confirming no pending tracked file changes.

## Archive Index

- archive-001.md — Legacy _map card preserved before schema v2 compaction on 2026-06-04.

## 中文摘要

- 這張卡只做導航索引。
- 不再承載歷史決策或長篇說明。
- 新增或移除主卡時才更新表格。

## Module Index

| Module | Current scope |
|---|---|
| _system | Repository-wide governance, root docs, deployment scripts, and release rules. |
| _shared | Shared governance assets and operational skills under Shared/. |
| _codex_core | Codex Edition framework source under Codex/. |
| _claude_core | Claude Edition framework source under Claude/. |
| _ag_core | Antigravity framework source under Antigravity/. |
| _vscode_extension | VS Code extension source, release workflow, and manager bridge. |
| claude-edition-rules | Deprecated historical card for legacy Claude rule decisions. |

## Tracked Files

- .agents/memory/_map/SKILL.md
- .agents/memory/_map/archive-001.md

## Relations

- _system (root governance memory)
- _shared (shared skill and policy memory)
- _codex_core (Codex platform memory)
- _claude_core (Claude platform memory)
- _ag_core (Antigravity platform memory)
- _vscode_extension (VS Code extension memory)
- claude-edition-rules (deprecated historical archive)

## Applicable Skills

- memory-ops — Use when updating this card.
- memory-arch — Use when changing memory topology.
