---
name: _shared.memory-governance.context-migration
scopePath: Shared/
description: >
  專案記憶：專案脈絡協定與記憶遷移工具。Use when: task touches project-context-protocol or Shared
  Memory-Migration tools.
last_updated: '2026-08-17T21:12:47+08:00'
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

# _shared.memory-governance.context-migration — Module Memory

## Current Truth

- Owns project-context-protocol sources and Shared Memory-Migration tools.
- Project context is not source memory and must not sync through `memory_commit`.

## Active Constraints

- Do not write `.agents/context/**` from this card's ownership.

## Cycle Events

- 01: Created during the remaining granularity split from memory-governance.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/project-context-protocol/SKILL.md, Shared/project-tools/Memory-Migration.ps1

## Read Contract

- Read when changing owned context-protocol or migration-tool sources.

## Conflicts and Supersession

- superseded: a single memory-governance card owning ops, arch, and migration files.

## 中文摘要

- 此卡負責專案脈絡協定與記憶遷移工具。
- 脈絡寫入與記憶提交仍是分開的受保護動作。

## Tracked Files

- Shared/skills/project-context-protocol/SKILL.md
- Shared/skills/project-context-protocol/references/context-template.md
- Shared/project-tools/Memory-Migration.ps1
- Shared/project-tools/modules/Memory-Migration.psm1

## Relations

- _shared.memory-governance (parent card: navigation only)
- _shared.context-tools (related context-support memory)
- _system.scripts.runners (related runner copy of Memory-Migration.psm1)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
