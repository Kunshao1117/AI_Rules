---
name: _cursor_core.support.workflows-general
scopePath: Cursor/.agents/workflow-skills/
description: >
  專案記憶：Cursor 一般工作流技能。Use when: task touches chat, explore, experiment,
  condense, or test workflow skills.
last_updated: '2026-08-17T20:56:14+08:00'
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

# _cursor_core.support.workflows-general — Module Memory

## Current Truth

- Owns Cursor chat, explore, experiment, condense, and test workflow skills.

## Active Constraints

- Keep `platforms: ["cursor"]`. These entries remain route selectors.

## Cycle Events

- 01: Created during the Cursor workflow split.

## Archive Index

- None yet.

## Evidence Base

- source:Cursor/.agents/workflow-skills/01-explore-探索/SKILL.md, Cursor/.agents/workflow-skills/05-condense-濃縮/SKILL.md

## Read Contract

- Read when changing owned general Cursor workflow skills.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Cursor 聊天、探索、實驗、濃縮與測試工作流。

## Tracked Files

- Cursor/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Cursor/.agents/workflow-skills/01-explore-探索/SKILL.md
- Cursor/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Cursor/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Cursor/.agents/workflow-skills/06-test-測試/SKILL.md

## Relations

- _cursor_core.support (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
