---
name: _shared.supabase-postgres.schema-design
scopePath: Shared/skills/supabase-postgres-best-practices/references/
description: >-
  專案記憶：Supabase Postgres 結構設計參考主題。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-06-15T02:53:35+08:00'
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
# _shared.supabase-postgres.schema-design — Schema Design References Memory

## Current Truth
- This child card owns schema design, constraints, key, partitioning, and identifier reference files.
- Reference content remains in the tracked Markdown files.
- Schema recommendations must be grounded before applying them to a target project.

## Active Constraints
- Do not infer active project schema policy from this card alone.
- Use tracked reference files and current official docs for implementation-specific decisions.

## Cycle Events
- 01: Split schema design references out of the Supabase Postgres parent card.

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
- 此子卡負責資料表結構設計參考檔。
- 專案實作時要再依當前官方文件與實際資料庫確認。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/references/schema-constraints.md
- Shared/skills/supabase-postgres-best-practices/references/schema-data-types.md
- Shared/skills/supabase-postgres-best-practices/references/schema-foreign-key-indexes.md
- Shared/skills/supabase-postgres-best-practices/references/schema-lowercase-identifiers.md
- Shared/skills/supabase-postgres-best-practices/references/schema-partitioning.md
- Shared/skills/supabase-postgres-best-practices/references/schema-primary-keys.md

## Relations
- _shared.supabase-postgres (parent card: reference corpus index)

## Applicable Skills
- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when editing this reference topic.
- tech-stack-protocol — Use when current external grounding is required.
