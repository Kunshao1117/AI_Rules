---
name: _ag_core.support.workflows-operations
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 測試、巡檢、交接與技能鍛造工作流。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T14:19:31+08:00'
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

# _ag_core.support.workflows-operations — Antigravity Operations Workflow Memory

## Current Truth
- Antigravity routine, handoff, and skill-forge workflows now use the MCP Memory Evidence Matrix for read-only governance and skill attribution evidence.
- This child card owns Antigravity testing, routine, handoff, and skill-forge workflow entries.
- Operational workflows must keep evidence requirements matched to Antigravity browser and visual artifact capabilities.
- Routine inspection remains read-only unless a later Director gate approves writes.

## Active Constraints
- Do not claim real behavior verification without captured operation evidence or an explicit blocked state.
- Keep handoff and routine workflows from mutating source or memory without the appropriate gate.

## Cycle Events
- 04: Added MCP memory evidence contract references to Antigravity routine, handoff, and skill-forge workflows.
- 03: Updated Antigravity operation workflow output examples and routine downstream scan scope.
- 02: Aligned operational workflow grounding paths to deployed .agents/shared governance references.
- 01: Split Antigravity operational workflow ownership out of the support parent card.

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
- 此子卡負責 Antigravity 測試、巡檢、交接與技能鍛造入口。
- 行為驗證需有真實操作證據或明確阻塞。

## Tracked Files
- Antigravity/.agents/workflows/06_test(測試).md
- Antigravity/.agents/workflows/10_routine(巡檢).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared.ops-skills.testing (related testing strategy memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
