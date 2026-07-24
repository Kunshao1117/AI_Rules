---
name: _shared.ops-skills.testing
scopePath: Shared/skills/
description: >
  專案記憶：Shared 測試、瀏覽器、效能、無障礙與回歸策略技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-24T16:19:47+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:44:00+08:00'
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

# _shared.ops-skills.testing — Testing and Evidence Memory

## Current Truth

- This card owns Shared testing, browser evidence, accessibility, performance, test automation, test patterns, Trunk, and regression strategy skills.
- Browser and visual evidence are station-owned; captured output proves only capture-time visible state.
- Mocks and fixtures prove scoped logic or contracts, not real runtime, persistence, external-service, or operator-workflow claims.
- Tests are opt-in and must be bound to the current acceptance or an explicitly authorized minimal exception.
- Performance and Trunk mutations remain separate protected phases.

## Active Constraints

- Prefer real-information evidence; label mock or fallback evidence and its residual risk.
- A failed check creates a change requirement only; repair returns to its authorized change owner.
- Do not retain one-time test output as permanent memory.

## Cycle Events

- 01: Compacted prior testing/evidence history after re-verifying source ownership and proof boundaries.

## Archive Index

- archive-001.md — Compacted pre-2026-07-24 cycle events and detailed evidence notes.

## Evidence Base

- source:Shared/skills/browser-testing/SKILL.md
- source:Shared/skills/test-automation-strategy/SKILL.md
- source:Shared/skills/test-patterns/SKILL.md
- source:Shared/skills/performance-audit/SKILL.md
- source:Shared/skills/trunk-ops/SKILL.md

## Read Contract

- Read for owned testing, browser, accessibility, performance, Trunk, or regression strategy work.
- Do not use for raw test output or to claim a real execution path that has not been evidenced.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Shared 測試、瀏覽器、效能、無障礙與回歸策略。
- 截圖與 mock 僅能證明有限狀態；真實行為需對應真實或等效路徑。
- 測試與其受保護後續操作都必須有明確範圍。

## Tracked Files

- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md
- Shared/skills/test-patterns/SKILL.md
- Shared/skills/trunk-ops/SKILL.md

## Relations

- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust card topology or archives.
