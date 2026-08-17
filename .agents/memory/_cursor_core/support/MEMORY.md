---
name: _cursor_core.support
scopePath: Cursor/.agents/workflow-skills/
description: >
  專案記憶：Cursor 工作流支援導覽父卡。Use when: task needs navigation to remaining Cursor
  workflow skills.
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

# _cursor_core.support — Navigation Memory

## Current Truth

- This parent is navigation-only for remaining Cursor workflow skills and shared gates.
- Highest-risk delivery workflows stay on `_cursor_core.workflows-delivery`.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Created during complete memory organization to mirror Codex support topology.

## Archive Index

- None yet.

## Evidence Base

- source:Cursor/.agents/workflow-skills/00-chat-聊天/SKILL.md

## Read Contract

- Read only to select the child card that owns the remaining workflow files.

## Conflicts and Supersession

- None.

## 中文摘要

- 此父卡導覽 Cursor 其餘工作流與共用閘門。
- 建構／修復等交付入口仍在 workflows-delivery。

## Tracked Files

## Relations

- _cursor_core (parent card: navigation only)
- _cursor_core.support.workflows-general (child card: chat, explore, experiment, condense, test)
- _cursor_core.support.workflows-release (child card: commit, routine, skill-forge, and shared gates)
- _cursor_core.workflows-delivery (sibling delivery workflows)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
