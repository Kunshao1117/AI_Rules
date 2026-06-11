---
name: claude-edition-rules
description: >
  Claude Edition 舊規範歷史卡。此卡已降為歸檔索引，不再作為 Claude source owner。 Use when: 需要追溯
  Claude Edition 早期規範與統一部署引擎歷史時。
scopePath: .agents/memory/claude-edition-rules/
last_updated: '2026-06-11T18:15:13+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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
# claude-edition-rules — Deprecated Archive Index

## Current Truth

- This card is deprecated as an active source owner.
- Active Claude framework source ownership now belongs to `_claude_core`.
- Active deployment script ownership now belongs to `_system`.
- Historical Claude rule decisions remain available in the archive volume.

## Active Constraints

- Do not add new source files to this card.
- Do not use this card for stale repair of Claude source changes.
- Preserve the archive for trace-back only.

## Cycle Events

- 01: Demoted the legacy Claude rules card to a schema v2 archive index.

## Archive Index

- archive-001.md — Legacy Claude Edition rules card preserved before deprecation on 2026-06-04.

## 中文摘要

- 這張卡已不再負責 Claude 原始碼歸屬。
- Claude 來源改由 `_claude_core` 負責。
- 部署腳本改由 `_system` 負責。
- 舊決策保留在歸檔卷。

## Tracked Files

- .agents/memory/claude-edition-rules/SKILL.md
- .agents/memory/claude-edition-rules/archive-001.md

## Relations

- _claude_core (active Claude source memory)
- _system (active deployment script memory)

## Applicable Skills

- memory-ops — Use when updating archive metadata.
- memory-arch — Use if this deprecated card is eventually retired.
