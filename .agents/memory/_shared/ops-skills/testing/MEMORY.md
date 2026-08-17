---
name: _shared.ops-skills.testing
scopePath: Shared/skills/
description: >
  專案記憶：Shared 測試技能導覽父卡。Use when: task needs navigation to this split testing
  memory family.
last_updated: '2026-08-17T21:13:35+08:00'
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

# _shared.ops-skills.testing — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete testing-skill ownership belongs to its child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split strategy and pattern ownership into child cards.

## Archive Index

- archive-002.md — Pre-split 2026-08-17 mixed testing ownership.
- archive-001.md — Compacted pre-2026-07-24 cycle events and detailed evidence notes.

## Evidence Base

- source:Shared/skills/impact-test-strategy/SKILL.md, Shared/skills/test-patterns/SKILL.md

## Read Contract

- Read only to select the child card that owns the concrete testing files.

## Conflicts and Supersession

- superseded: a single testing card owning strategy skills and unit-test templates.

## 中文摘要

- 此父卡只保留測試技能導覽。
- 策略與模板已拆到子卡。

## Tracked Files

## Relations

- _shared.ops-skills (parent card: operational-skill family index)
- _shared.ops-skills.testing.strategy (child card: strategy, browser, and evidence skills)
- _shared.ops-skills.testing.patterns (child card: unit-test templates)
- _shared.team-native-core.policy-core.verification-runtime (related verification policy)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
