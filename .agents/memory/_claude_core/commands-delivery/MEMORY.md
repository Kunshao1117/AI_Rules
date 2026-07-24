---
name: _claude_core.commands-delivery
scopePath: Claude/.claude/
description: >
  專案記憶：Claude 平台核心、規則與交付指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-24T16:46:23+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:46:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

- Owns the Claude adapter bootstrap, core rules, and governed delivery commands.

## Active Constraints

- Command routes do not grant write or protected-action authority.

## Cycle Events

- 01: Created during the 2026-07-24 authorized memory split after current-source verification.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Claude/install.ps1
- source:Claude/.claude/commands/11_handoff(交接)/SKILL.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or historical parent detail.

## Conflicts and Supersession

- None.

## 中文摘要

- Claude 平台核心、規則與交付指令。
- 具體檔案歸屬已由父卡移入此子卡。
- 現行來源優先於本卡摘要。

## Tracked Files

- Claude/install.ps1
- Claude/README.md
- Claude/VERSION
- Claude/global/CLAUDE.md
- Claude/.claude/CLAUDE.md
- Claude/.claude/rules/core-identity.md
- Claude/.claude/rules/memory-contract.md
- Claude/.claude/rules/forbidden-vocab.md
- Claude/.claude/commands/02_blueprint(架構)/SKILL.md
- Claude/.claude/commands/03_build(建構)/SKILL.md
- Claude/.claude/commands/04_fix(修復)/SKILL.md
- Claude/.claude/commands/07_debug(除錯)/SKILL.md
- Claude/.claude/commands/11_handoff(交接)/SKILL.md

## Relations

- _claude_core (parent card: navigation only)
- _claude_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
