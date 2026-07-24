---
name: _shared.ops-skills.supabase-core
scopePath: Shared/skills/
description: >-
  專案記憶：Shared Supabase 核心操作技能與回饋資產。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-24T13:40:24+08:00'
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

# _shared.ops-skills.supabase-core — Supabase Core Skills Memory

## Current Truth
- This child card owns Shared Supabase operation guidance and the core Supabase skill feedback assets.
- The large Postgres best-practices corpus is owned by `_shared.supabase-postgres`, not this child card.
- Current Supabase product or API facts require official-source grounding before implementation decisions.
- Supabase mutation and external-state operations require scope-bound Director intent, authorization resolution, the matching protected gate, and separate MCP HITL evidence when applicable.

## Active Constraints
- Do not mix Supabase core operational guidance with the dedicated Postgres reference corpus.
- Keep external product-version claims out of memory unless verified for the current task.
- Do not treat GO or MCP HITL alone as authorization for Supabase mutation or external-state changes.

## Cycle Events
- 04: Reconciled 2026-07-07 Supabase core dirty source as wording and wrapping only; no product-semantic memory change.
- 03: Verified Batch 4A quality metadata against tracked Supabase core skill content and source/deployed hash parity.
- 02: Recorded Batch 4A Supabase ops mutation-gate alignment with scope-bound authorization resolution and separate MCP HITL evidence.
- 01: Split Supabase core skill ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source diff: 2026-07-07 dirty core changes add zh-TW description prefixes and wrap prose in Supabase skill files; no product/API semantic change found.
- source/deployed parity: 2026-07-03 SHA256 checks matched all four tracked Supabase core files against `.agents/skills/` deployed copies.
- source content: tracked Supabase skills separate core guidance from Postgres best practices, require current documentation grounding for Supabase product facts, and keep mutation/external-state actions behind scope-bound authorization and MCP HITL where applicable.
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
