---
name: _shared.memory-governance
scopePath: Shared/skills/
description: >
  專案記憶：Shared 記憶與專案脈絡治理工具。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-24T16:46:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:49:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _shared.memory-governance — Module Memory

## Current Truth

- Owns source-memory, topology, project-context, and migration governance sources.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Parent/child navigation is a relation, not a staleness dependency.
- Keep current procedure detail in the tracked source files.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skills/memory-ops/SKILL.md
- source:Shared/project-tools/modules/Memory-Migration.psm1
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- Shared 記憶與專案脈絡治理工具。
- 具體檔案歸屬已由父卡移入此子卡。

## Tracked Files

- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-arch/references/memory-quality-migration-blueprint.md
- Shared/skills/memory-arch/references/topology-rules.md
- Shared/skills/memory-arch/references/maintenance-playbooks.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/memory-ops/references/memory-lifecycle-procedures.md
- Shared/skills/memory-ops/references/memory-mcp-tool-contract.md
- Shared/skills/project-context-protocol/SKILL.md
- Shared/skills/project-context-protocol/references/context-template.md
- Shared/project-tools/Memory-Migration.ps1
- Shared/project-tools/modules/Memory-Migration.psm1

## Relations

- _shared (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
