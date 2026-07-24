---
name: _shared.supabase-postgres
scopePath: Shared/skills/supabase-postgres-best-practices/
description: >-
  專案記憶：Supabase Postgres 大型參考技能來源導覽父卡。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-24T13:40:25+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:41:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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

# _shared.supabase-postgres — Supabase Postgres Reference Index Memory

## Current Truth
- This parent card owns the Supabase Postgres best-practices skill entrypoint and corpus-level template files.
- Topic-specific reference files moved to focused child cards under `_shared.supabase-postgres.*`.
- External Postgres and Supabase guidance must be verified from current official sources before implementation decisions.

## Active Constraints
- Do not summarize the full reference corpus into this parent card.
- Do not add topic reference files back to this parent when a focused child card exists.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split broad Supabase Postgres reference ownership into topic child cards.
- 03: Verified corpus entrypoint and template tracked files exist.
- 04: Reconciled 2026-07-07 Postgres entrypoint dirty source as description wording only; no product-semantic memory change.

## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source diff: 2026-07-07 dirty parent-entrypoint change adds a zh-TW description prefix; parent corpus ownership and Postgres guidance semantics remain unchanged.
- source:.agents/memory/_shared/supabase-postgres/archive-001.md — Previous active card snapshot preserved.
- source:Shared/skills/supabase-postgres-best-practices/SKILL.md and references/_*.md — Parent tracked files exist.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized topic child-card creation.

## Read Contract
- Read this parent card when deciding which Supabase Postgres child card owns a reference topic.
- Read the relevant child card and source reference before editing topic-specific guidance.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡保留 Supabase Postgres 技能入口與模板歸屬。
- 大量參考檔已依主題拆成五張子卡。
- 外部資料使用時仍需查最新官方文件。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/SKILL.md
- Shared/skills/supabase-postgres-best-practices/references/_contributing.md
- Shared/skills/supabase-postgres-best-practices/references/_sections.md
- Shared/skills/supabase-postgres-best-practices/references/_template.md

## Relations
- _shared (parent Shared governance memory)
- _shared.ops-skills.supabase-core (related Supabase core skill card)
- _shared.supabase-postgres.query-indexing (child card: query and indexing references)
- _shared.supabase-postgres.schema-design (child card: schema references)
- _shared.supabase-postgres.security (child card: security references)
- _shared.supabase-postgres.connection-data (child card: connection and data references)
- _shared.supabase-postgres.locking-monitoring (child card: locking and monitoring references)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
- supabase-postgres-best-practices — Use when editing this reference corpus.
