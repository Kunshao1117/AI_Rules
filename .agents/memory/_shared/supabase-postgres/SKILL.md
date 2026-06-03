---
name: _shared.supabase-postgres
description: >
  Shared Supabase Postgres best-practices 子卡。追蹤 Supabase Postgres 技能與大量
  references。Use when: 修改 Supabase Postgres 效能、安全、schema、query、lock、 monitoring
  或 connection best-practice references 時。
scopePath: Shared/skills/supabase-postgres-best-practices/
last_updated: '2026-06-04T03:57:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _shared.supabase-postgres — Supabase Postgres Memory

## Current Truth

- This child card owns the Supabase Postgres best-practices skill and its reference corpus.
- The reference set is large enough to stay out of the general Shared skills child card.
- Changes should preserve source-of-truth alignment with Supabase-maintained guidance when current verification is required.
- This card tracks ownership only; detailed best-practice content remains in the skill references.

## Active Constraints

- Do not summarize the full reference corpus into this memory card.
- Keep external knowledge freshness checks in the skill workflow, not in memory history.
- Split deeper by topic only if the reference corpus grows beyond card limits.

## Cycle Events

- 01: Created dedicated child ownership card for Supabase Postgres best-practices references.

## Archive Index

- None.

## 中文摘要

- 這張子卡專門承接 Supabase Postgres 大型參考集。
- 實際技術內容保留在技能與參考檔，不貼進記憶卡。
- 需要最新資料時仍要查官方來源。

## Tracked Files

- Shared/skills/supabase-postgres-best-practices/references/_contributing.md
- Shared/skills/supabase-postgres-best-practices/references/_sections.md
- Shared/skills/supabase-postgres-best-practices/references/_template.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-full-text-search.md
- Shared/skills/supabase-postgres-best-practices/references/advanced-jsonb-indexing.md
- Shared/skills/supabase-postgres-best-practices/references/conn-idle-timeout.md
- Shared/skills/supabase-postgres-best-practices/references/conn-limits.md
- Shared/skills/supabase-postgres-best-practices/references/conn-pooling.md
- Shared/skills/supabase-postgres-best-practices/references/conn-prepared-statements.md
- Shared/skills/supabase-postgres-best-practices/references/data-batch-inserts.md
- Shared/skills/supabase-postgres-best-practices/references/data-n-plus-one.md
- Shared/skills/supabase-postgres-best-practices/references/data-pagination.md
- Shared/skills/supabase-postgres-best-practices/references/data-upsert.md
- Shared/skills/supabase-postgres-best-practices/references/lock-advisory.md
- Shared/skills/supabase-postgres-best-practices/references/lock-deadlock-prevention.md
- Shared/skills/supabase-postgres-best-practices/references/lock-short-transactions.md
- Shared/skills/supabase-postgres-best-practices/references/lock-skip-locked.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-explain-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-pg-stat-statements.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-vacuum-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/query-composite-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-covering-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-index-types.md
- Shared/skills/supabase-postgres-best-practices/references/query-missing-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/query-partial-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-constraints.md
- Shared/skills/supabase-postgres-best-practices/references/schema-data-types.md
- Shared/skills/supabase-postgres-best-practices/references/schema-foreign-key-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-lowercase-identifiers.md
- Shared/skills/supabase-postgres-best-practices/references/schema-partitioning.md
- Shared/skills/supabase-postgres-best-practices/references/schema-primary-keys.md
- Shared/skills/supabase-postgres-best-practices/references/security-privileges.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-basics.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-performance.md
- Shared/skills/supabase-postgres-best-practices/SKILL.md

## Relations

- _shared (parent Shared governance memory)
- _shared.ops-skills (general Shared operational skills)

## Applicable Skills

- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when changing this reference family.
- tech-stack-protocol — Use when current external version grounding is needed.
