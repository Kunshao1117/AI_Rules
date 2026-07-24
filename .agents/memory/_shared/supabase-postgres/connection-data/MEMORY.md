---
name: _shared.supabase-postgres.connection-data
scopePath: Shared/skills/supabase-postgres-best-practices/references/
description: >-
  專案記憶：Supabase Postgres 連線與資料操作參考主題。Use when: task touches this split memory
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

# _shared.supabase-postgres.connection-data — Connection and Data References Memory

## Current Truth
- This child card owns connection management and data operation reference files.
- The tracked files cover pooling, limits, prepared statements, batching, pagination, upserts, and N+1 risks.
- Runtime database behavior must be verified on the target project when needed.

## Active Constraints
- Do not present reference ownership as proof of target database performance.
- Keep runtime evidence in reports unless it becomes a stable validation route.

## Cycle Events
- 01: Split connection and data operation references out of the Supabase Postgres parent card.
- 02: Verified all connection and data tracked reference files exist.

## Archive Index
- Parent archive remains at .agents/memory/_shared/supabase-postgres/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/supabase-postgres/archive-001.md — Previous parent-card content preserved during migration.
- source:Shared/skills/supabase-postgres-best-practices/references/conn-*.md and data-*.md — Listed tracked files exist.
- tool:memory_audit — Granularity advisory identified this reference corpus as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing the owned Supabase Postgres reference topic.
- Do not use memory as current Postgres or Supabase documentation; verify official sources when behavior may have changed.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責連線管理與資料操作參考檔。
- 實際效能或行為需在目標專案驗證。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/references/conn-idle-timeout.md
- Shared/skills/supabase-postgres-best-practices/references/conn-limits.md
- Shared/skills/supabase-postgres-best-practices/references/conn-pooling.md
- Shared/skills/supabase-postgres-best-practices/references/conn-prepared-statements.md
- Shared/skills/supabase-postgres-best-practices/references/data-batch-inserts.md
- Shared/skills/supabase-postgres-best-practices/references/data-n-plus-one.md
- Shared/skills/supabase-postgres-best-practices/references/data-pagination.md
- Shared/skills/supabase-postgres-best-practices/references/data-upsert.md

## Relations
- _shared.supabase-postgres (parent card: reference corpus index)

## Applicable Skills
- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when editing this reference topic.
- tech-stack-protocol — Use when current external grounding is required.
