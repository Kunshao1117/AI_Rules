---
name: _ag_core.support.workflows-operations
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 驗證、巡檢、交接與技能鍛造工作流。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T00:02:49+08:00'
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
cycle_id: 2026-06-15-001
cycle_event_count: 10
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

# _ag_core.support.workflows-operations — Antigravity Operations Workflow Memory

## Current Truth

- Owns Antigravity operational workflow entries for verification, routine inspection, handoff, and skill work.
- `06 Verify` is canonical; `06 Test` remains a compatibility entry and does not require creating a test.
- Existing local non-destructive targeted tests are ordinary verification evidence; side-effectful or external tests require separate risk classification.
- Routine remains Git-only, and handoff does not replace active implementation or protected commit work.
- Deep audit is conditional on explicit request or concrete high-risk evidence, not an automatic response to an ordinary failure.

## Active Constraints

- Select the lowest-cost evidence that adequately proves acceptance.
- Failure classification precedes repair; no workflow self-authorizes source repair or protected action.

## Cycle Events

- 10: Reconciled operational workflows with canonical Verify, bounded audit activation, and ordinary Direct verification evidence.

## Archive Index

- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base

- source:Antigravity/.agents/workflows/06_test(測試).md — canonical Verify compatibility route.
- source:Shared/policies/verification-strategy.md — evidence ladder, test admission, and audit boundary.
- source:.agents/memory/_ag_core/support/archive-001.md — historical support-card detail.

## Read Contract

- Read this card when changing the owned operational Antigravity workflows.
- Do not use it as a record of one-run test output or as protected-action authority.

## Conflicts and Supersession

- superseded: treating `06_test` as a test-creation requirement or ordinary validation failure as automatic audit activation.

## 中文摘要

- `06 Verify` 是 canonical，`06 Test` 僅保留相容入口。
- 安全的既有 targeted test 是一般 evidence；高副作用或外部測試另行分級。
- 一般失敗不會自動進入 deep audit。

## Tracked Files

- Antigravity/.agents/workflows/06_test(測試).md
- Antigravity/.agents/workflows/10_routine(巡檢).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md

## Relations

- _ag_core.support (parent card: navigation only)
- _shared.ops-skills.testing (related testing strategy memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
