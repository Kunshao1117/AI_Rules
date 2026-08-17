---
name: _claude_core.runtime
scopePath: Claude/
description: >
  專案記憶：Claude 安裝、版號與 CLAUDE.md 入口。Use when: task touches Claude install,
  VERSION, README, or CLAUDE.md bootstrap files.
last_updated: '2026-08-17T21:12:30+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T21:20:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-003
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

# _claude_core.runtime — Module Memory

## Current Truth

- Owns Claude install, README, VERSION, global CLAUDE.md, and project CLAUDE.md bootstrap sources.
- Runtime copies under `.claude/` remain observed, not canonical.

## Active Constraints

- Do not treat this card as owner of commands or core rules.

## Cycle Events

- 01: Created during the remaining granularity split from commands-delivery.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Claude/install.ps1, Claude/VERSION, Claude/.claude/CLAUDE.md

## Read Contract

- Read when changing owned Claude bootstrap files.

## Conflicts and Supersession

- superseded: mixing install/bootstrap ownership into the delivery-command card.

## 中文摘要

- 此卡負責 Claude 安裝、版號與 CLAUDE.md 入口。
- 規則與指令歸其他子卡。

## Tracked Files

- Claude/install.ps1
- Claude/README.md
- Claude/VERSION
- Claude/global/CLAUDE.md
- Claude/.claude/CLAUDE.md

## Relations

- _claude_core (parent card: navigation only)
- _claude_core.core-rules (sibling card: core rules)
- _claude_core.commands-delivery (sibling card: delivery commands)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
