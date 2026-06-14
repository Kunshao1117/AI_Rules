---
name: _shared.ops-skills.supabase-core
scopePath: Shared/skills/
description: >-
  專案記憶：Shared Supabase 核心操作技能與回饋資產。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T02:53:10+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:45:58+08:00'
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
# _shared.ops-skills.supabase-core — Supabase Core Skills Memory

## Current Truth
- This child card owns Shared Supabase operation guidance and the core Supabase skill feedback assets.
- The large Postgres best-practices corpus is owned by `_shared.supabase-postgres`, not this child card.
- Current Supabase product or API facts require official-source grounding before implementation decisions.

## Active Constraints
- Do not mix Supabase core operational guidance with the dedicated Postgres reference corpus.
- Keep external product-version claims out of memory unless verified for the current task.

## Cycle Events
- 01: Split Supabase core skill ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Supabase 核心操作技能與回饋資產。
- 大型 Postgres 參考集仍由專門子卡管理。

## Tracked Files
- Shared/skills/supabase-ops/SKILL.md
- Shared/skills/supabase/assets/feedback-issue-template.md
- Shared/skills/supabase/references/skill-feedback.md
- Shared/skills/supabase/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared.supabase-postgres (related card: Postgres reference corpus)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
