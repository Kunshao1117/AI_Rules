---
name: _shared.memory-governance.context-migration
scopePath: Shared/
description: >
  專案記憶：專案脈絡歷史參考與 Memory-Migration 工具。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-08-17T21:12:47+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
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

# _shared.memory-governance.context-migration — Module Memory

## Current Truth

- Owns the preserved project-context-protocol Skill identity/template reference and the existing Shared Memory-Migration tool sources.
- Current Project Context authority and format are owned by project-context-protocol.md and project-context-format.md, not the retired Skill body.
- Project Context remains separate from source Memory; Memory maintenance or memory_commit never authorizes Context persistence.

## Active Constraints

- Do not write `.agents/context/**` from this card's ownership.

## Cycle Events

- 01: Created during the remaining granularity split from memory-governance.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`, `Shared/policies/project-context-protocol.md`, `Shared/policies/references/project-context-format.md`, `Shared/project-tools/Memory-Migration.ps1`, `Shared/project-tools/modules/Memory-Migration.psm1`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
- source:Shared/skills/project-context-protocol/SKILL.md, Shared/project-tools/Memory-Migration.ps1

## Read Contract

- Read when comparing preserved Context identities with current Context policy, or changing Memory-Migration sources.

## Conflicts and Supersession

- superseded: a single memory-governance card owning ops, arch, and migration files.
- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_shared/memory-governance/context-migration/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- 舊context Skill與範本保留歷史對照，Memory-Migration工具來源不變
- 現行脈絡政策與格式有正式owner；Memory工作不授權Context寫入

## Tracked Files

- Shared/policies/references/legacy-skills/project-context-protocol/REFERENCE.md
- Shared/policies/references/legacy-skills/project-context-protocol/references/context-template.md
- Shared/project-tools/Memory-Migration.ps1
- Shared/project-tools/modules/Memory-Migration.psm1

## Relations

- _shared.memory-governance (parent card: navigation only)
- _shared.context-tools (related context-support memory)
- _system.scripts.runners (related runner copy of Memory-Migration.psm1)

## Applicable Skills

- memory-ops — Use current source-only or runtime applicability; this card grants no mutation authority.
