---
name: _shared.supabase-postgres.query-indexing
scopePath: Shared/skills/supabase-postgres-best-practices/references/
description: >-
  專案記憶：Supabase Postgres 查詢與索引參考主題。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T02:53:31+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:47:43+08:00'
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
# _shared.supabase-postgres.query-indexing — Query and Indexing References Memory

## Current Truth
- This child card owns query planning, index selection, and advanced indexing reference files.
- Reference content remains in the tracked Markdown files.
- Current database guidance must be verified against current Supabase/Postgres sources when used for implementation decisions.

## Active Constraints
- Do not summarize the reference corpus into memory.
- Keep this card focused on ownership, evidence, and routing.

## Cycle Events
- 01: Split query and indexing references out of the Supabase Postgres parent card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/supabase-postgres/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/supabase-postgres/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this reference corpus as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing the owned Supabase Postgres reference topic.
- Do not use memory as current Postgres or Supabase documentation; verify official sources when behavior may have changed.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責查詢與索引參考檔。
- 實際技術內容留在參考檔，使用時仍需查最新官方資料。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/references/advanced-full-text-search.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-jsonb-indexing.md
- Shared/skills/supabase-postgres-best-practices/references/query-composite-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-covering-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-index-types.md
- Shared/skills/supabase-postgres-best-practices/references/query-missing-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-partial-indexes.md

## Relations
- _shared.supabase-postgres (parent card: reference corpus index)
- _shared.ops-skills.supabase-core (related Supabase core skill card)

## Applicable Skills
- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when editing this reference topic.
- tech-stack-protocol — Use when current external grounding is required.
