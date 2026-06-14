---
name: _ag_core.support
scopePath: Antigravity/.agents/
description: >-
  專案記憶：Antigravity 支援檔案與工作流導覽父卡。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-06-15T02:54:08+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:48:38+08:00'
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
# _ag_core.support — Antigravity Support Index Memory

## Current Truth
- This parent card is now a navigation index for Antigravity support files.
- Rules and workflow families moved to focused child cards under `_ag_core.support.*`.
- The parent `_ag_core` card keeps platform-wide Antigravity current truth.

## Active Constraints
- Do not duplicate parent-level Antigravity decisions here.
- Use Relations for child navigation; do not add parent-child entries to dependencies by default.

## Cycle Events
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Split Antigravity support ownership into rule and workflow child cards.

## Archive Index
- archive-001.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified broad tracked-file ownership.
- director:2026-06-15 — GO SPLIT authorized focused child-card creation.

## Read Contract
- Read this parent card when routing Antigravity support ownership.
- Read the relevant child card before updating support rules or workflows.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- 此父卡改為 Antigravity 支援導覽。
- 規則與工作流檔案已拆到四張子卡。

## Tracked Files
- Antigravity/.agents/VERSION
- Antigravity/.gitignore
- Antigravity/.vscode/settings.json

## Relations
- _ag_core (parent Antigravity core memory)
- _ag_core.support.rules (child card: support rules)
- _ag_core.support.workflows-foundation (child card: foundation workflows)
- _ag_core.support.workflows-operations (child card: operational workflows)
- _ag_core.support.workflows-audit-commit (child card: audit and commit workflows)
- _shared (shared policy and skill source)

## Applicable Skills
- memory-ops — Use when updating this parent card.
- memory-arch — Use when adding or changing child-card topology.
