---
name: _shared.ops-skills.skill-governance.registry-sync
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 技能登錄與部署同步。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-27T20:49:30+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T20:47:17+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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


# _shared.ops-skills.skill-governance.registry-sync — Module Memory

## Current Truth

- Owns the Shared skill registry and deployed registry mirror.
- The registry defines positive triggers, negative boundaries, and canonical responsibility; it is an index and does not copy skill bodies.
- Generic verification routes to `verification-strategy`; specialist skills remain conditional and detailed procedures remain lazy-loaded.

## Active Constraints

- Keep source/deployed ownership paired where both surfaces are tracked.
- Do not let registry labels make ordinary coding work a Team trigger.

## Cycle Events

- 02: Reconciled registry routing with the canonical verification owner and delegated-only Team artifacts.
- 03: Removed retired reflection-skill entries and retained canonical routing to the existing intent and retry controls.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skills/_index.md
- source:Shared/skill-governance.md and Shared/policies/verification-strategy.md
- source:Shared/skills/_index.md and Shared/skills/intent-alignment-gate/SKILL.md

## Read Contract

- Read when changing the Shared skill registry or its deployed mirror.
- Do not use as a substitute for the loaded skill or canonical policy.

## Conflicts and Supersession

- superseded: multiple generic quality/test/review skills concurrently owning ordinary verification.

## 中文摘要

- Registry 只做路由與邊界，不複製 skill body。
- Generic verification 指向唯一 `verification-strategy` owner。
- Team artifact skill 只在 delegated 下被載入。

## Tracked Files

- Shared/skills/_index.md
- .agents/skills/_index.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
