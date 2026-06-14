---
name: _ag_core.support.rules
scopePath: Antigravity/.agents/rules/
description: >-
  專案記憶：Antigravity 支援規則檔。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T02:53:54+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:48:38+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _ag_core.support.rules — Antigravity Rules Memory

## Current Truth
- This child card owns Antigravity support rule files.
- Rule files bridge shared governance into the Antigravity platform packaging area.
- Platform-specific wording must not override shared policy without an explicit source change.

## Active Constraints
- Do not duplicate full shared policy history here.
- Check shared policy drift when editing these support rules.

## Cycle Events
- 01: Split Antigravity rules ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Antigravity 支援規則檔。
- 修改時要比對 Shared 共用政策是否漂移。

## Tracked Files
- Antigravity/.agents/rules/01_cross_lingual_guard.md
- Antigravity/.agents/rules/02_code_quality_security.md
- Antigravity/.agents/rules/05_project_skill_contract.md
- Antigravity/.agents/rules/06_memory_push.md
- Antigravity/.agents/rules/AGENTS.md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared (shared policy source)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
