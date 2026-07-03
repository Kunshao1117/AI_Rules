---
name: _shared.supabase-postgres.security
scopePath: Shared/skills/supabase-postgres-best-practices/references/
description: >-
  專案記憶：Supabase Postgres 權限與 RLS 安全參考主題。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-03T13:22:13+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T13:05:08+08:00'
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
# _shared.supabase-postgres.security — Security References Memory

## Current Truth
- This child card owns Supabase Postgres privilege and row-level security reference files.
- Security guidance is high-change and must be verified before being treated as current advice.
- This card records ownership and evidence status, not an approval that a project is secure.

## Active Constraints
- Do not mark security behavior verified without current source or runtime evidence.
- Keep security facts scoped to the tracked references unless the target project has been inspected.

## Cycle Events
- 01: Split security references out of the Supabase Postgres parent card.
- 02: Verified all security tracked reference files exist.

## Archive Index
- Parent archive remains at .agents/memory/_shared/supabase-postgres/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/supabase-postgres/archive-001.md — Previous parent-card content preserved during migration.
- source:Shared/skills/supabase-postgres-best-practices/references/security-*.md — Listed tracked files exist.
- tool:memory_audit — Granularity advisory identified this reference corpus as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing the owned Supabase Postgres reference topic.
- Do not use memory as current Postgres or Supabase documentation; verify official sources when behavior may have changed.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責權限與 RLS 安全參考檔。
- 安全建議屬高變動資訊，使用時必須重新查證。

## Tracked Files
- Shared/skills/supabase-postgres-best-practices/references/security-privileges.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-basics.md
- Shared/skills/supabase-postgres-best-practices/references/security-rls-performance.md

## Relations
- _shared.supabase-postgres (parent card: reference corpus index)
- _shared.ops-skills.quality-ui (related security and quality standards)

## Applicable Skills
- memory-ops — Use when updating this child card.
- supabase-postgres-best-practices — Use when editing this reference topic.
- tech-stack-protocol — Use when current external grounding is required.
