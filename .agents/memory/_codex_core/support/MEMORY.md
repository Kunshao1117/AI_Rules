---
name: _codex_core.support
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 工作流技能導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-15T02:54:41+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:50:19+08:00'
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
# _codex_core.support — Codex Support Index Memory

## Current Truth
- This parent card is now a navigation index for Codex workflow skill support files.
- Concrete workflow ownership moved to child cards under `_codex_core.support.*`.
- The parent `_codex_core` card keeps Codex core identity, install, config, and highest-risk workflow entries.

## Active Constraints
- Maintain Traditional Chinese trigger language in Director-facing workflow descriptions.
- Use Relations for child navigation; do not add parent-child entries to dependencies by default.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split Codex support workflow ownership into focused child cards.

## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_codex_core/support/archive-001.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized focused child-card creation.

## Read Contract
- Read this parent card when routing Codex workflow support ownership.
- Read the relevant child card before updating Codex workflow skill files.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡改為 Codex 工作流支援導覽。
- 一般、健檢、提交治理工作流已拆成三張子卡。

## Tracked Files


## Relations
- _codex_core (parent Codex core memory)
- _codex_core.support.workflows-general (child card: general workflows)
- _codex_core.support.workflows-audit (child card: audit workflows)
- _codex_core.support.workflows-release (child card: commit, routine, and skill-forge workflows)
- _shared (shared operational skills)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
