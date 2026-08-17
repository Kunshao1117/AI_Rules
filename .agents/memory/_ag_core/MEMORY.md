---
name: _ag_core
scopePath: .
description: >
  專案記憶：Antigravity 平台核心導覽父卡。Use when: task needs navigation to this split memory
  family.
last_updated: '2026-08-17T21:13:30+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:46:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _ag_core — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete source ownership belongs to its child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 02: Added runtime and core-rules children after splitting workflow-delivery.
- 01: Split concrete ownership into child cards and retained navigation only.

## Archive Index

- .agents/memory/_ag_core/archive-005.md — Pre-split parent ownership history.

## Evidence Base

- tool:memory_status — Parent owner scope was verified before the split.

## Read Contract

- Read only to select the child card that owns the concrete source files.

## Conflicts and Supersession

- None.

## 中文摘要

- 此父卡只保留導覽關係。
- 具體檔案歸屬以子卡為準。

## Tracked Files

## Relations

- _ag_core.runtime (child card: install, VERSION, and global entry)
- _ag_core.core-rules (child card: always-on and core rules)
- _ag_core.workflow-delivery (child card: delivery workflows)
- _ag_core.support (child card: support-file navigation)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
