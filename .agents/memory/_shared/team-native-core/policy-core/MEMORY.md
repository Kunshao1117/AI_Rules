---
name: _shared.team-native-core.policy-core
scopePath: Shared/policies/
description: >
  專案記憶：Progressive Assurance 核心政策導覽父卡。Use when: task needs navigation to this
  split policy-core memory family.
last_updated: '2026-08-17T21:13:38+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
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

# _shared.team-native-core.policy-core — Navigation Memory

## Current Truth

- This parent is navigation-only. Concrete policy ownership belongs to its child cards.

## Active Constraints

- Do not add concrete tracked files back to this parent.

## Cycle Events

- 01: Split routing, requirement-context, orchestration, and verification-runtime ownership into child cards.

## Archive Index

- archive-002.md — Pre-split 2026-08-17 mixed policy-core ownership.
- archive-001.md — Pre-2026-08-17 cycle events.

## Evidence Base

- source:Shared/policies/execution-routing.md, Shared/policies/team-native-core.md

## Read Contract

- Read only to select the child card that owns the concrete policy files.

## Conflicts and Supersession

- superseded: a single policy-core card owning all canonical policies and runtime copies.

## 中文摘要

- 此父卡只保留核心政策導覽。
- 路由、需求、編排與驗證已拆到子卡。

## Tracked Files

## Relations

- _shared.team-native-core (parent card: navigation only)
- _shared.team-native-core.policy-core.routing (child card: routing and authorization)
- _shared.team-native-core.policy-core.requirement-context (child card: requirement and context)
- _shared.team-native-core.policy-core.orchestration (child card: Team orchestration)
- _shared.team-native-core.policy-core.verification-runtime (child card: verification and runtime copies)
- _shared.team-native-core.policy-execution (related reference-contract memory)
- _shared.team-native-core.policy-evidence (related evidence matrix memory)
- _cursor_core (related Cursor platform memory)

## Applicable Skills

- memory-ops — Update and commit this navigation card.
- memory-arch — Adjust child topology or archive volumes.
