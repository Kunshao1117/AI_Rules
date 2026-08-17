---
name: _cursor_core
scopePath: Cursor/
description: >
  專案記憶：Cursor 平台核心導覽父卡。Use when: task needs navigation to this split memory
  family.
last_updated: '2026-08-17T20:56:44+08:00'
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
cycle_id: 2026-08-17-001
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

# _cursor_core — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete source ownership belongs to its child cards.
- Cursor Edition v0.1.0 is the fourth peer platform. Shared governance stays canonical in `Shared/`.

## Active Constraints

- Do not add concrete tracked files back to this parent.
- Do not treat other platform cores as this session's bootstrap.

## Cycle Events

- 02: Added support-child navigation after splitting remaining workflow skills.
- 01: Created the Cursor Edition memory family after v0.1.0 source delivery and mixed-repo identity.

## Archive Index

- None yet.

## Evidence Base

- source:Cursor/VERSION, Cursor/README.md, Cursor/.cursor/rules/02-platform-identity.mdc

## Read Contract

- Read only to select the child card that owns the concrete source files.

## Conflicts and Supersession

- None.

## 中文摘要

- 此父卡只保留導覽關係。
- Cursor Edition 是第四個對等平台；具體檔案歸屬以子卡為準。

## Tracked Files

## Relations

- _cursor_core.runtime (child card: rules, install, and runtime identity)
- _cursor_core.workflows-delivery (child card: blueprint, build, fix, debug, handoff)
- _cursor_core.support (child card: remaining workflow navigation)
- _shared.adapters-workflow (related adapter memory)
- _map (root navigation index)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
