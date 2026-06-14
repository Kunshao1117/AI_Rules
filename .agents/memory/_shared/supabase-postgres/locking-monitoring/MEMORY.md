---
name: _shared.supabase-postgres.locking-monitoring
scopePath: Shared/skills/supabase-postgres-best-practices/references/
description: >-
  專案記憶：Supabase Postgres 鎖定、交易與監控參考主題。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T02:53:45+08:00'
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
# _shared.supabase-postgres.locking-monitoring — Locking and Monitoring References Memory

## Current Truth
- This child card owns transaction locking and monitoring reference files.
- The tracked files cover advisory locks, deadlock prevention, short transactions, SKIP LOCKED, EXPLAIN, pg_stat_statements, and vacuum/analyze.
- Operational monitoring conclusions require target-environment evidence.

## Active Constraints
- Do not treat reference ownership as live observability evidence.
- Keep current monitoring output in reports or logs unless it becomes a stable project invariant.

## Cycle Events
- 01: Split locking and monitoring references out of the Supabase Postgres parent card.

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
- 此子卡負責鎖定、交易與監控參考檔。
- 監控結論必須來自目標環境證據。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/references/lock-advisory.md
- Shared/skills/supabase-postgres-best-practices/references/lock-deadlock-prevention.md
- Shared/skills/supabase-postgres-best-practices/references/lock-short-transactions.md
- Shared/skills/supabase-postgres-best-practices/references/lock-skip-locked.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-explain-analyze.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-pg-stat-statements.md
- Shared/skills/supabase-postgres-best-practices/references/monitor-vacuum-analyze.md

## Relations
- _shared.supabase-postgres (parent card: reference corpus index)
- _shared.ops-skills.mcp-ops (related operational evidence tools)

## Applicable Skills
- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when editing this reference topic.
- tech-stack-protocol — Use when current external grounding is required.
