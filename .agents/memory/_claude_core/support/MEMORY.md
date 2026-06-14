---
name: _claude_core.support
scopePath: Claude/.claude/
description: >-
  專案記憶：Claude 支援檔案與指令導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T02:54:25+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:49:33+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 2
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
# _claude_core.support — Claude Support Index Memory

## Current Truth
- This parent card is now a navigation index for Claude support commands, rules, and settings.
- Concrete file ownership moved to child cards under `_claude_core.support.*`.
- The parent `_claude_core` card keeps platform-wide Claude current truth.

## Active Constraints
- Do not treat deprecated `claude-edition-rules` as an active owner.
- Use Relations for child navigation; do not add parent-child entries to dependencies by default.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split Claude support ownership into command and rule child cards.

## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized focused child-card creation.

## Read Contract
- Read this parent card when routing Claude support ownership.
- Read the relevant child card before updating Claude commands, rules, or settings.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡改為 Claude 支援導覽。
- 指令、健檢、發布治理、規則設定已拆成四張子卡。

## Tracked Files


## Relations
- _claude_core (parent Claude core memory)
- _claude_core.support.commands-general (child card: general commands)
- _claude_core.support.commands-audit (child card: audit commands)
- _claude_core.support.commands-release (child card: release, routine, and skill-forge commands)
- _claude_core.support.rules-settings (child card: rules and settings)
- _shared (shared policy and skill source)
- claude-edition-rules (deprecated historical archive)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
