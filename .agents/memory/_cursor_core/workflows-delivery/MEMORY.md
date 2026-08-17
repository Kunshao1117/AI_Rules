---
name: _cursor_core.workflows-delivery
scopePath: Cursor/.agents/workflow-skills/
description: >
  專案記憶：Cursor 交付工作流技能。Use when: task touches Cursor blueprint, build, fix,
  debug, or handoff workflow skills.
last_updated: '2026-08-17T20:56:16+08:00'
status: stable
staleness: 0
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

# _cursor_core.workflows-delivery — Module Memory

## Current Truth

- Owns Cursor blueprint, build, fix, debug, and handoff workflow skills.
- Deploy copies those entries into `.cursor/skills/`. Cursor does not use slash commands.

## Active Constraints

- Keep `platforms: ["cursor"]`. Workflow entries never grant protected authority.

## Cycle Events

- 01: Split remaining Cursor workflow skills into support child cards.

## Archive Index

- None yet. Pre-split ownership moved to `_cursor_core.support`.

## Evidence Base

- source:Cursor/.agents/workflow-skills/03-build-建構/SKILL.md, Cursor/.agents/workflow-skills/04-fix-修復/SKILL.md

## Read Contract

- Read when changing owned Cursor delivery workflow skills.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Cursor 藍圖、建構、修復、除錯與交接工作流。
- 部署到 `.cursor/skills/`，不是斜線指令。

## Tracked Files

- Cursor/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Cursor/.agents/workflow-skills/03-build-建構/SKILL.md
- Cursor/.agents/workflow-skills/04-fix-修復/SKILL.md
- Cursor/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Cursor/.agents/workflow-skills/11-handoff-交接/SKILL.md

## Relations

- _cursor_core (parent card: navigation only)
- _cursor_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
