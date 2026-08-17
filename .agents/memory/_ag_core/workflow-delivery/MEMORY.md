---
name: _ag_core.workflow-delivery
scopePath: Antigravity/.agents/workflows/
description: >
  專案記憶：Antigravity 交付工作流。Use when: task touches Antigravity blueprint,
  build-execute, fix, condense, debug, or commit workflows.
last_updated: '2026-08-17T21:12:30+08:00'
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

# _ag_core.workflow-delivery — Module Memory

## Current Truth

- Owns Antigravity delivery workflow files listed below.
- `07_debug` narrows a failure and routes broad uncertainty to Explore or Blueprint.

## Active Constraints

- Keep workflow entries thin and keep protected phases separately authorized.
- Do not treat debugging activity as a Team trigger by itself.

## Cycle Events

- 01: Split install/rules ownership into `_ag_core.runtime` and `_ag_core.core-rules`.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 mixed bootstrap, rules, and workflow ownership.

## Evidence Base

- source:Antigravity/.agents/workflows/07_debug(除錯).md

## Read Contract

- Read when working on the owned Antigravity workflow files.

## Conflicts and Supersession

- superseded: mixing install and core-rule ownership into this workflow card.

## 中文摘要

- 此卡負責 Antigravity 交付工作流。
- 安裝入口與核心規則已拆到其他子卡。

## Tracked Files

- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md
- Antigravity/.agents/workflows/09-2_commit_execute(授權備份).md

## Relations

- _ag_core (parent card: navigation only)
- _ag_core.runtime (sibling card: install and bootstrap)
- _ag_core.core-rules (sibling card: core rules)
- _ag_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
