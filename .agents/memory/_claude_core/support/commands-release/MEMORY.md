---
name: _claude_core.support.commands-release
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 紀錄、巡檢與技能鍛造指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T08:05:49+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T08:08:00+08:00'
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
# _claude_core.support.commands-release — Claude Release and Governance Commands Memory

## Current Truth
- This child card owns Claude commit, routine, and skill-forge command entries.
- Commit commands must respect Director gates for git and external state changes.
- Routine checks are read-only unless a later gate authorizes writes.

## Active Constraints
- Do not commit, push, tag, or release without explicit Director approval.
- Do not let routine inspection mutate source or memory without a write gate.

## Cycle Events
- 02: Aligned release Claude command grounding paths to deployed .agents/shared governance references.
- 01: Split Claude release and governance command ownership out of the support parent card.

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
- 此子卡負責 Claude 紀錄、巡檢與技能鍛造指令。
- 提交與發布仍必須有明確授權。

## Tracked Files
- Claude/.claude/commands/09_commit(紀錄)/SKILL.md
- Claude/.claude/commands/10_routine(巡檢)/SKILL.md
- Claude/.claude/commands/12_skill_forge(技能鍛造)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared.ops-skills.release-reasoning (related release and skill governance memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
