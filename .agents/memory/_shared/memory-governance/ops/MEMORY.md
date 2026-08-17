---
name: _shared.memory-governance.ops
scopePath: Shared/skills/memory-ops/
description: >
  專案記憶：記憶讀寫與生命週期操作。Use when: task touches memory-ops skill or its template,
  lifecycle, or MCP contract references.
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

# _shared.memory-governance.ops — Module Memory

## Current Truth

- Owns the memory-ops skill and its template, lifecycle, and MCP-tool-contract references.
- Protected memory-write and memory-commit remain separate phases.

## Active Constraints

- Do not treat read-only listing as mutation authority.

## Cycle Events

- 01: Created during the remaining granularity split from memory-governance.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/memory-ops/SKILL.md

## Read Contract

- Read when changing owned memory-ops sources.

## Conflicts and Supersession

- superseded: a single memory-governance card owning ops, arch, and migration files.

## 中文摘要

- 此卡負責記憶讀寫與生命週期操作。
- 拓樸與遷移工具歸其他子卡。

## Tracked Files

- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/memory-ops/references/memory-lifecycle-procedures.md
- Shared/skills/memory-ops/references/memory-mcp-tool-contract.md

## Relations

- _shared.memory-governance (parent card: navigation only)
- _shared.memory-governance.arch (sibling card: topology rules)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
