---
name: _shared.ops-skills.testing.strategy
scopePath: Shared/skills/
description: >
  專案記憶：測試策略、瀏覽器、效能、無障礙與回歸。Use when: task touches a11y, browser, impact-test,
  performance, test-automation, or trunk-ops skills.
last_updated: '2026-08-17T21:12:51+08:00'
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

# _shared.ops-skills.testing.strategy — Module Memory

## Current Truth

- Owns Shared accessibility, browser, impact/regression, performance, automation-strategy, and Trunk testing skills.
- Verification begins with the lowest-cost sufficient evidence.
- Permanent tests require a stable observable contract and an independent oracle.

## Active Constraints

- Classify failure before repair. Do not preserve raw test output as durable memory.

## Cycle Events

- 01: Created during the remaining granularity split from testing.

## Archive Index

- Parent archive-002.md records the pre-split file list.

## Evidence Base

- source:Shared/skills/impact-test-strategy/SKILL.md, Shared/skills/test-automation-strategy/SKILL.md

## Read Contract

- Read for owned testing-strategy work. Do not use for unit-test templates.

## Conflicts and Supersession

- superseded: treating Verify as test creation or executing every existing test through a protected gate.

## 中文摘要

- 此卡負責測試策略、瀏覽器、效能、無障礙與回歸。
- 單元測試模板歸 patterns 子卡。

## Tracked Files

- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/trunk-ops/SKILL.md

## Relations

- _shared.ops-skills.testing (parent card: navigation only)
- _shared.ops-skills.testing.patterns (sibling card: unit-test templates)
- _shared.team-native-core.policy-core.verification-runtime (related verification policy)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
