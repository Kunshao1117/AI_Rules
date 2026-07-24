---
name: _shared
scopePath: Shared/
description: >
  專案記憶：Shared 治理與工具導覽父卡。Use when: task needs navigation to this split memory
  family.
last_updated: '2026-07-24T16:19:46+08:00'
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

# _shared — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete source ownership belongs to child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split concrete ownership into child cards and retained navigation only.

## Archive Index

- archive-004.md — Pre-split parent ownership history.

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

- _shared.governance-foundation (child card: language, grounding, size, and governance foundations)
- _shared.adapters-workflow (child card: platform adapter sources)
- _shared.memory-governance (child card: memory, context, and migration governance)
- _shared.context-tools (child card: context and tool support)
- _shared.team-native-core (child card: Team-Native contracts)
- _shared.ops-skills (child card: operational-skill navigation)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
