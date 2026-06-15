---
name: _claude_core.support.commands-audit
scopePath: Claude/.claude/commands/08_audit(健檢)/
description: >-
  專案記憶：Claude 健檢主指令與三階段子指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T14:18:27+08:00'
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
cycle_event_count: 4
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

# _claude_core.support.commands-audit — Claude Audit Commands Memory

## Current Truth
- Claude audit entry and subcommands inherit the MCP memory evidence contract and keep audit memory checks read-only.
- This child card owns Claude audit command entries and their three-phase subcommands.
- Audit commands use project-surface detection, evidence status, and blocked/unverified states.
- Audit commands now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Claude-specific subagent, hook, permission, and checkpoint semantics are platform translation details, not memory format differences.

## Active Constraints
- Do not mark missing evidence as passed.
- Do not let Claude-specific hooks or checkpoints leak into Codex or Antigravity memory semantics.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.

## Cycle Events
- 04: Added MCP memory evidence contract references to Claude audit entry and subcommands.
- 03: Updated Claude audit command output examples with deployed shared reference labels.
- 01: Split Claude audit command ownership out of the support parent card.
- 02: Updated Claude audit entry and subcommands for depth selection, inventory construction, evidence-linked coverage, and coverage reporting.

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
- 此子卡負責 Claude 健檢主指令與三階段子指令。
- 平台能力是轉譯層，不是記憶格式差異。

## Tracked Files
- Claude/.claude/commands/08_audit(健檢)/08-1_infra/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-2_logic/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-3_report/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared (shared audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
