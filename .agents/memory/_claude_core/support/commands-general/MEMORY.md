---
name: _claude_core.support.commands-general
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 一般討論、探索、實驗、濃縮與測試指令。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-06-15T11:55:00+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-15T11:55:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 3
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _claude_core.support.commands-general — Claude General Commands Memory

## Current Truth
- This child card owns Claude shared command gates and general command entries.
- General commands must stay aligned with shared workflow semantics and Claude permission behavior.
- Test commands must select evidence by interface surface rather than assuming browser-only proof.

## Active Constraints
- Do not transfer main-agent responsibility to subagents.
- Do not write source or memory from read-only command flows without the appropriate gate.

## Cycle Events
- 03: Updated Claude general command output examples with source-only labels.
- 02: Aligned general Claude command grounding paths to deployed .agents/shared governance references.
- 01: Split Claude general command ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Claude 一般指令與共用閘門。
- 測試指令要依介面型態選擇證據。

## Tracked Files
- Claude/.claude/commands/_shared/_completion_gate.md
- Claude/.claude/commands/_shared/_security_footer.md
- Claude/.claude/commands/00_chat(討論)/SKILL.md
- Claude/.claude/commands/01_explore(搜索)/SKILL.md
- Claude/.claude/commands/03-1_experiment(實驗)/SKILL.md
- Claude/.claude/commands/05_condense（濃縮）/SKILL.md
- Claude/.claude/commands/06_test(測試)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared (shared workflow semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
