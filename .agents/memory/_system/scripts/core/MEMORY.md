---
name: _system.scripts.core
scopePath: Scripts/modules/
description: |
  專案記憶：部署 Core 模組。Use when: task touches Scripts/modules/Core*.psm1.
last_updated: '2026-08-17T20:55:50+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
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

# _system.scripts.core — Module Memory

## Current Truth

- Owns the Core.* PowerShell modules used by Fresh, Upgrade, gitignore, reporting, and project-skills sync.

## Active Constraints

- Preserve UTF-8 BOM for tracked PS 5.1 import-chain modules.

## Cycle Events

- 01: Created during the scripts split.

## Archive Index

- Parent archive-005.md records the pre-split file list.

## Evidence Base

- source:Scripts/modules/Core.psm1, Scripts/modules/Core.Upgrade.psm1

## Read Contract

- Read when changing Core deployment helpers.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Core 部署輔助模組。
- PS 5.1 匯入鏈需保留 UTF-8 BOM。

## Tracked Files

- Scripts/modules/Core.psm1
- Scripts/modules/Core.Cleanup.psm1
- Scripts/modules/Core.Comparison.psm1
- Scripts/modules/Core.Gitignore.psm1
- Scripts/modules/Core.Infrastructure.psm1
- Scripts/modules/Core.ProjectSkills.psm1
- Scripts/modules/Core.Reporting.psm1
- Scripts/modules/Core.Upgrade.psm1

## Relations

- _system.scripts (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
