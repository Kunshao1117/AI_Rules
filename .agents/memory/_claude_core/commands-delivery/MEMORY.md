---
name: _claude_core.commands-delivery
scopePath: Claude/.claude/commands/
description: >
  專案記憶：Claude 交付指令。Use when: task touches Claude blueprint, build, fix, debug,
  or handoff commands.
last_updated: '2026-08-17T21:12:32+08:00'
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

# _claude_core.commands-delivery — Module Memory

## Current Truth

- Owns the Claude governed delivery commands listed below.
- Command routes do not grant write or protected-action authority.

## Active Constraints

- Keep user-visible reporting pointers in Shared language governance.

## Cycle Events

- 01: Split install/rules ownership into `_claude_core.runtime` and `_claude_core.core-rules`.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 mixed bootstrap, rules, and command ownership.

## Evidence Base

- source:Claude/.claude/commands/03_build(建構)/SKILL.md

## Read Contract

- Read when working on the owned Claude delivery commands.

## Conflicts and Supersession

- superseded: mixing install and core-rule ownership into this command card.

## 中文摘要

- 此卡負責 Claude 交付指令。
- 安裝入口與核心規則已拆到其他子卡。

## Tracked Files

- Claude/.claude/commands/02_blueprint(架構)/SKILL.md
- Claude/.claude/commands/03_build(建構)/SKILL.md
- Claude/.claude/commands/04_fix(修復)/SKILL.md
- Claude/.claude/commands/07_debug(除錯)/SKILL.md
- Claude/.claude/commands/11_handoff(交接)/SKILL.md

## Relations

- _claude_core (parent card: navigation only)
- _claude_core.runtime (sibling card: install and bootstrap)
- _claude_core.core-rules (sibling card: core rules)
- _claude_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
