---
name: _shared.memory-governance.arch
scopePath: Shared/skills/memory-arch/
description: >
  專案記憶：記憶拓樸、品質遷移與維護劇本。Use when: task touches memory-arch skill, topology rules,
  quality migration, or maintenance playbooks.
last_updated: '2026-08-17T21:12:36+08:00'
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

# _shared.memory-governance.arch — Module Memory

## Current Truth

- Owns the memory-arch skill and its topology, quality-migration, and maintenance-playbook references.
- Target remains at most 8 tracked files per concrete owner; parent/child links stay in Relations.

## Active Constraints

- Maximum depth is 4. Do not nest children under an already depth-4 card.

## Cycle Events

- 01: Created during the remaining granularity split from memory-governance.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/memory-arch/SKILL.md, Shared/skills/memory-arch/references/topology-rules.md

## Read Contract

- Read when changing owned memory-arch sources.

## Conflicts and Supersession

- superseded: a single memory-governance card owning ops, arch, and migration files.

## 中文摘要

- 此卡負責記憶拓樸、品質遷移與維護劇本。
- 讀寫操作與遷移工具歸其他子卡。

## Tracked Files

- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-arch/references/memory-quality-migration-blueprint.md
- Shared/skills/memory-arch/references/topology-rules.md
- Shared/skills/memory-arch/references/maintenance-playbooks.md

## Relations

- _shared.memory-governance (parent card: navigation only)
- _shared.memory-governance.ops (sibling card: memory-ops procedures)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
