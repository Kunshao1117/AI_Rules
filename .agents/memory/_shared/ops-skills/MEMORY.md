---
name: _shared.ops-skills
scopePath: Shared/skills/
description: >-
  專案記憶：跨平台共用操作型技能來源導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T02:53:24+08:00'
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
# _shared.ops-skills — Shared Operational Skills Index Memory

## Current Truth
- This parent card is now a navigation index for Shared operational skill families.
- Concrete file ownership moved to child cards under `_shared.ops-skills.*`.
- The parent `_shared` card keeps shared governance, memory model, context protocol, and high-level policy truth.

## Active Constraints
- Do not add broad tracked-file ownership back to this parent when a child card can own the files.
- Use Relations for child navigation; do not add parent-child entries to dependencies by default.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split broad operational skill ownership into focused child cards.

## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized focused child-card creation.

## Read Contract
- Read this parent card when deciding which Shared operational child card owns a file family.
- Read the relevant child card before updating owned Shared operational skill files.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡改為 Shared 操作型技能導覽。
- 實際檔案歸屬已拆到多張子卡。
- 父子關係只做導覽，不預設傳播過期。

## Tracked Files


## Relations
- _shared (parent Shared governance memory)
- _shared.ops-skills.code-analysis (child card: code scanning and diagnosis)
- _shared.ops-skills.testing (child card: testing and evidence strategy)
- _shared.ops-skills.quality-ui (child card: quality, security, and UI/UX standards)
- _shared.ops-skills.mcp-ops (child card: MCP and external service operations)
- _shared.ops-skills.supabase-core (child card: Supabase core operations)
- _shared.ops-skills.gitnexus (child card: GitNexus workflows)
- _shared.ops-skills.skill-governance (child card: delegation and skill factory)
- _shared.ops-skills.release-reasoning (child card: release, reasoning, and stack protocol)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
