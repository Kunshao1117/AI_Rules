---
name: _shared.memory-governance
scopePath: Shared/skills/
description: >
  專案記憶：Shared 記憶與專案脈絡治理導覽父卡。Use when: task needs navigation to this split memory
  family.
last_updated: '2026-08-17T21:13:34+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T21:20:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-003
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

# _shared.memory-governance — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete source ownership belongs to its child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split ops, arch, and context-migration ownership into child cards.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 mixed memory-governance ownership.

## Evidence Base

- source:Shared/skills/memory-ops/SKILL.md, Shared/skills/memory-arch/SKILL.md

## Read Contract

- Read only to select the child card that owns the concrete source files.

## Conflicts and Supersession

- superseded: a single memory-governance card owning all ops, arch, and migration files.

## 中文摘要

- 此父卡只保留記憶治理導覽。
- 讀寫、拓樸與遷移工具已拆到子卡。

## Tracked Files

## Relations

- _shared (parent card: navigation only)
- _shared.memory-governance.ops (child card: memory-ops procedures)
- _shared.memory-governance.arch (child card: topology and maintenance)
- _shared.memory-governance.context-migration (child card: context protocol and migration tools)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
