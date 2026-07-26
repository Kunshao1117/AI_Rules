---
name: _shared.ops-skills.testing
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 測試、瀏覽器、效能、無障礙與回歸策略技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-26T17:20:27+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
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

# _shared.ops-skills.testing — Testing and Evidence Memory

## Current Truth

- Owns Shared testing, browser evidence, accessibility, performance, Trunk, and regression strategy skills.
- Verification begins with the lowest-cost sufficient evidence: static checks, deterministic parity, existing targeted tests, smoke or real-tool observation, then focused regression or broader suites when warranted.
- Permanent tests require a stable observable contract, independent oracle, material recurrence risk, insufficient existing evidence, and acceptable maintenance cost.
- Existing local non-destructive targeted tests are ordinary evidence; side-effectful, external, or unknown tests are classified before execution.

## Active Constraints

- Classify failure as product, test/checker, environment/tool, requirement ambiguity, or intentional migration before repair.
- Do not preserve raw test output, mock-only proof, retry masking, or one-off probes as durable memory.

## Cycle Events

- 02: Reconciled testing skills with minimum-sufficient verification, independent-oracle admission, and bounded repair rules.

## Archive Index

- archive-001.md — Compacted pre-2026-07-24 cycle events and detailed evidence notes.

## Evidence Base

- source:Shared/skills/impact-test-strategy/SKILL.md
- source:Shared/skills/test-automation-strategy/SKILL.md
- source:Shared/skills/test-patterns/SKILL.md
- source:Shared/policies/verification-strategy.md

## Read Contract

- Read for owned testing, browser, accessibility, performance, Trunk, or regression strategy work.
- Do not use for raw output or to claim a real integration path that has not been observed.

## Conflicts and Supersession

- superseded: treating Verify as test creation or executing every existing test through a protected gate.

## 中文摘要

- 驗證由最低成本且足夠的 evidence 開始。
- 新永久測試需要 stable contract 與 independent oracle。
- 安全既有 targeted test 是一般 evidence；其他測試先分級。

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
- _shared.team-native-core.policy-evidence (related evidence matrix)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
