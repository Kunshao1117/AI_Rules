---
name: _ag_core.core-rules
scopePath: Antigravity/.agents/rules/
description: >
  專案記憶：Antigravity 核心規則與 runtime 副本。Use when: task touches Antigravity
  00/03/04/07 core rules or the managed runtime copy of 00_core_identity.
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

# _ag_core.core-rules — Module Memory

## Current Truth

- Owns Antigravity always-on identity, memory/skill contract, forbidden-vocab, MCP guardrails, and the managed runtime copy of `00_core_identity.md`.
- Support rules 01/02/05/06 and `AGENTS.md` remain owned by `_ag_core.support.rules`.

## Active Constraints

- Keep user-visible reporting pointers in Shared language governance.
- Do not treat debugging or rule edits as Team triggers by themselves.

## Cycle Events

- 01: Created during the remaining granularity split from workflow-delivery.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Antigravity/.agents/rules/00_core_identity.md, Antigravity/.agents/rules/07_mcp_guardrails.md

## Read Contract

- Read when changing owned Antigravity core rules.

## Conflicts and Supersession

- superseded: mixing core-rule ownership into the delivery-workflow card.

## 中文摘要

- 此卡負責 Antigravity 核心規則與 runtime 副本。
- 支援規則仍由 `_ag_core.support.rules` 擁有。

## Tracked Files

- Antigravity/.agents/rules/00_core_identity.md
- .agents/rules/00_core_identity.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/07_mcp_guardrails.md

## Relations

- _ag_core (parent card: navigation only)
- _ag_core.runtime (sibling card: install and bootstrap)
- _ag_core.support.rules (related support-rule memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
