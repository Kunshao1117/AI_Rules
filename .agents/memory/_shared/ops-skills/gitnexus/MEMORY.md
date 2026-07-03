---
name: _shared.ops-skills.gitnexus
scopePath: Shared/skills/
description: >-
  專案記憶：Shared GitNexus 索引、探索、除錯與影響分析技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-03T13:21:52+08:00'
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
# _shared.ops-skills.gitnexus — GitNexus Skills Memory

## Current Truth
- This child card owns Shared GitNexus CLI and repository graph workflow skills.
- GitNexus skills are optional assistance paths and do not replace direct source inspection.
- Repository indexing outputs are task evidence, not permanent memory by default.

## Active Constraints
- Do not claim repository graph facts as current unless the index or source files were checked in the current task.
- Keep GitNexus-specific procedures in the tracked skill files.

## Cycle Events
- 01: Split GitNexus skill ownership out of the broad Shared operational skills card.
- 02: Verified all GitNexus tracked skill files exist.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- source:Shared/skills/gitnexus-*/SKILL.md — Listed GitNexus tracked skill files exist in the current workspace.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 GitNexus 相關技能。
- 索引輸出是任務證據，不預設寫入永久記憶。

## Tracked Files
- Shared/skills/gitnexus-cli/SKILL.md
- Shared/skills/gitnexus-debugging/SKILL.md
- Shared/skills/gitnexus-exploring/SKILL.md
- Shared/skills/gitnexus-guide/SKILL.md
- Shared/skills/gitnexus-impact-analysis/SKILL.md
- Shared/skills/gitnexus-refactoring/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
