---
name: _claude_core.core-rules
scopePath: Claude/.claude/rules/
description: >
  專案記憶：Claude 核心規則與對齊技能。Use when: task touches Claude core-identity,
  memory-contract, forbidden-vocab, or intent-alignment-gate.
last_updated: '2026-08-17T21:12:31+08:00'
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

# _claude_core.core-rules — Module Memory

## Current Truth

- Owns Claude core-identity, its managed runtime copy, memory-contract, forbidden-vocab, and the intent-alignment-gate skill.
- Support rules and settings remain owned by `_claude_core.support.rules-settings`.

## Active Constraints

- Keep user-visible reporting pointers in Shared language governance.
- Command routes do not grant write or protected-action authority.

## Cycle Events

- 01: Created during the remaining granularity split from commands-delivery.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Claude/.claude/rules/core-identity.md, Claude/.claude/rules/memory-contract.md

## Read Contract

- Read when changing owned Claude core rules.

## Conflicts and Supersession

- superseded: mixing core-rule ownership into the delivery-command card.

## 中文摘要

- 此卡負責 Claude 核心規則與對齊技能。
- 支援規則仍由 `_claude_core.support.rules-settings` 擁有。

## Tracked Files

- Claude/.claude/rules/core-identity.md
- .claude/rules/core-identity.md
- .claude/skills/intent-alignment-gate/SKILL.md
- Claude/.claude/rules/memory-contract.md
- Claude/.claude/rules/forbidden-vocab.md

## Relations

- _claude_core (parent card: navigation only)
- _claude_core.runtime (sibling card: install and bootstrap)
- _claude_core.support.rules-settings (related support-rule memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
