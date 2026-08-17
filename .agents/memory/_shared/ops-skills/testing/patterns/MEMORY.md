---
name: _shared.ops-skills.testing.patterns
scopePath: Shared/skills/test-patterns/
description: >
  專案記憶：單元測試與 API 契約測試模板。Use when: task touches test-patterns skill or its API,
  hook, or utility templates.
last_updated: '2026-08-17T21:12:52+08:00'
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

# _shared.ops-skills.testing.patterns — Module Memory

## Current Truth

- Owns the test-patterns skill and its API, hook, and utility templates.
- Templates scaffold unit and contract tests; they do not authorize creating permanent tests without an independent oracle.

## Active Constraints

- Do not treat templates as proof that a real integration path exists.

## Cycle Events

- 01: Created during the remaining granularity split from testing.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/test-patterns/SKILL.md

## Read Contract

- Read when changing owned test-pattern sources.

## Conflicts and Supersession

- superseded: mixing unit-test templates into the broader testing-strategy card.

## 中文摘要

- 此卡負責單元測試與 API 契約測試模板。
- 瀏覽器、效能與回歸策略歸 strategy 子卡。

## Tracked Files

- Shared/skills/test-patterns/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md

## Relations

- _shared.ops-skills.testing (parent card: navigation only)
- _shared.ops-skills.testing.strategy (sibling card: testing strategy)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
