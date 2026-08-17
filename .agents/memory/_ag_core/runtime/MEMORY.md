---
name: _ag_core.runtime
scopePath: Antigravity/
description: >
  專案記憶：Antigravity 安裝、版號與全局入口。Use when: task touches Antigravity install,
  VERSION, README, or global GEMINI.md.
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

# _ag_core.runtime — Module Memory

## Current Truth

- Owns Antigravity install, README, VERSION, and global GEMINI bootstrap sources.
- Runtime copies under `.agents/` remain observed, not canonical.

## Active Constraints

- Do not treat this card as owner of rules or workflows.

## Cycle Events

- 01: Created during the remaining granularity split from workflow-delivery.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Antigravity/install.ps1, Antigravity/VERSION, Antigravity/global/GEMINI.md

## Read Contract

- Read when changing owned Antigravity bootstrap files.

## Conflicts and Supersession

- superseded: mixing install/bootstrap ownership into the delivery-workflow card.

## 中文摘要

- 此卡負責 Antigravity 安裝、版號與全局入口。
- 規則與工作流歸其他子卡。

## Tracked Files

- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md

## Relations

- _ag_core (parent card: navigation only)
- _ag_core.core-rules (sibling card: always-on and core rules)
- _ag_core.workflow-delivery (sibling card: delivery workflows)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
