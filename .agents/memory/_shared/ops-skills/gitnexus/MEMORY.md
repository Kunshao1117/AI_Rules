---
name: _shared.ops-skills.gitnexus
scopePath: Shared/skills/
description: >-
  專案記憶：Shared GitNexus 索引、探索、除錯與影響分析技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-07T05:52:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:52:39+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 3
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

# _shared.ops-skills.gitnexus — GitNexus Skills Memory

## Current Truth
- This child card owns Shared GitNexus CLI and repository graph workflow skills.
- GitNexus skill descriptions now start with Traditional Chinese task meaning for repo indexing, debugging, exploration, impact analysis, refactoring, and guide lookups.
- GitNexus remains an optional assistance path; graph, wiki, and query results do not replace direct source inspection or current local diffs.
- Read `gitnexus://repo/{name}/context` before relying on graph answers; if the context reports stale index, refresh with `npx gitnexus analyze` before using the result as current evidence.
- `gitnexus-cli` owns analyze/status/clean/wiki/list commands; exploration, debugging, impact, and refactoring skills own their narrower query routes.
- Impact analysis and safe refactoring use graph dependency and blast-radius evidence before edits, but source writes still require the normal change-delivery route.
- Repository indexing outputs are task evidence, not permanent memory by default.

## Active Constraints
- Do not claim repository graph facts as current unless the index or source files were checked in the current task.
- Keep GitNexus-specific procedures in the tracked skill files.
- Do not treat wiki generation, public gist publication, or index cleanup as authorized by a read-only graph lookup.

## Cycle Events
- 03: Repaired stale GitNexus memory for zh-TW trigger language, index freshness, optional-assistance, and routing boundaries.
- 02: Verified all GitNexus tracked skill files exist.
- 01: Split GitNexus skill ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- source:Shared/skills/gitnexus-cli/SKILL.md — Verified analyze/status/clean/wiki/list trigger wording and stale-index handling.
- source:Shared/skills/gitnexus-debugging/SKILL.md, Shared/skills/gitnexus-exploring/SKILL.md, Shared/skills/gitnexus-impact-analysis/SKILL.md, Shared/skills/gitnexus-refactoring/SKILL.md — Verified distinct routing for bug tracing, codebase exploration, blast-radius analysis, and safe refactoring.
- source:Shared/skills/gitnexus-guide/SKILL.md — Verified guide route for tool list, MCP resources, schema, query syntax, and workflow reference.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 GitNexus 相關技能。
- GitNexus 技能已改成繁中觸發語意，並區分索引、探索、除錯、影響分析與安全重構路由。
- 索引輸出是任務證據，不預設寫入永久記憶。
- 索引若過期，需先更新或改回直接讀取 source，不能把舊圖譜當成 current truth。

## Tracked Files
- Shared/skills/gitnexus-cli/SKILL.md
- Shared/skills/gitnexus-debugging/SKILL.md
- Shared/skills/gitnexus-exploring/SKILL.md
- Shared/skills/gitnexus-guide/SKILL.md
- Shared/skills/gitnexus-impact-analysis/SKILL.md
- Shared/skills/gitnexus-refactoring/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
