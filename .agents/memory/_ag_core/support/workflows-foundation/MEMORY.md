---
name: _ag_core.support.workflows-foundation
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 基礎工作流與共享閘門。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-26T17:20:25+08:00'
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
cycle_event_count: 11
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

# _ag_core.support.workflows-foundation — Antigravity Foundation Workflow Memory

## Current Truth

- Owns Antigravity foundation workflow entries and shared workflow gates.
- `01_explore` gathers bounded evidence and routes to the next applicable workflow; deep audit is entered only through explicit `verification-strategy` positive triggers.
- Foundation workflow entries remain thin routes and must not duplicate Team policy, board schema, completion procedure, or detailed platform playbooks.
- The generic `execution-routing` policy makes Direct first-class for ordinary work; Team-only controls load only when topology resolves to delegated.

## Active Constraints

- Workflow names and ordinary engineering verbs are not Team activation signals.
- Preserve meaning-first zh-TW entry text and exact machine tokens.
- Do not treat a verification failure as automatic deep-audit authority.

## Cycle Events

- 11: Reconciled the foundation workflow ownership with merged Direct-first routing and conditional deep-audit semantics.

## Archive Index

- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base

- source:Antigravity/.agents/workflows/01_explore(搜索).md — Direct-first routing and positive deep-audit trigger.
- source:Shared/policies/execution-routing.md and Shared/policies/verification-strategy.md — canonical routing and audit boundaries.
- source:.agents/memory/_ag_core/support/archive-001.md — historical support-card detail.

## Read Contract

- Read this card when changing the owned Antigravity foundation workflows or shared gates.
- Do not use it for temporary task notes, Team-only procedures, or platform runtime receipts.

## Conflicts and Supersession

- superseded: the former broad Team-default interpretation for ordinary foundation workflow work.

## 中文摘要

- 此卡負責 Antigravity 基礎 workflow 與共享閘門。
- 普通工作可走 Direct；只有 delegated topology 才載入 Team 控制。
- `01_explore` 的 deep audit 僅由明確正向條件觸發。

## Tracked Files

- Antigravity/.agents/workflows/_completion_gate.md
- Antigravity/.agents/workflows/_security_footer.md
- Antigravity/.agents/workflows/00_chat(討論).md
- Antigravity/.agents/workflows/01_explore(搜索).md
- Antigravity/.agents/workflows/03_build(建構計畫).md
- Antigravity/.agents/workflows/03-1_experiment(實驗).md

## Relations

- _ag_core.support (parent card: navigation only)
- _shared.team-native-core.policy-core (related routing contract)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
