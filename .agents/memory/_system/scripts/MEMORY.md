---
name: _system.scripts
scopePath: Scripts/
description: >
  專案記憶：根層 PowerShell 腳本導覽父卡。Use when: task needs navigation to this split memory
  family.
last_updated: '2026-08-17T20:56:41+08:00'
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

# _system.scripts — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete script ownership belongs to its child cards.
- Root PowerShell still covers deploy, platform adapters, Core modules, Manager, and runners.

## Active Constraints

- Do not add concrete tracked files back to this parent.
- Do not perform real install, upgrade, or target mutation for ordinary verification.

## Cycle Events

- 01: Split script ownership into platforms, core, manager, and runner child cards.

## Archive Index

- archive-005.md — Pre-split 2026-08-17 script ownership after Cursor attribution.
- archive-004.md — Pre-2026-08-17 cycle events after Cursor attribution.
- archive-003.md — Pre-R2 watcher, hook, and script-validation history.

## Evidence Base

- source:Scripts/Deploy.ps1, Scripts/modules/Platform-Cursor.psm1, Scripts/modules/Core.psm1

## Read Contract

- Read only to select the child card that owns the concrete script files.

## Conflicts and Supersession

- superseded: a single scripts card owning all root PowerShell files.

## 中文摘要

- 此父卡只保留腳本導覽。
- 平台部署、Core、Manager 與 runner 已拆到子卡。

## Tracked Files

## Relations

- _system (parent governance)
- _system.scripts.platforms (child card: Deploy and platform adapters)
- _system.scripts.core (child card: Core modules)
- _system.scripts.manager (child card: Manager modules)
- _system.scripts.runners (child card: audit, test, watch, and migration runners)
- _cursor_core.runtime (related Cursor runtime memory)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
