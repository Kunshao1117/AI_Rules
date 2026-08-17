---
name: _codex_core.runtime
scopePath: Codex/
description: >
  專案記憶：Codex 安裝、版號與 gitignore。Use when: task touches Codex VERSION, README,
  install.ps1, .codex/VERSION, or Codex/.gitignore.
last_updated: '2026-08-17T21:12:35+08:00'
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

# _codex_core.runtime — Module Memory

## Current Truth

- Owns Codex install, README, VERSION, `.codex/VERSION`, and Codex `.gitignore`.
- AGENTS.md and config.toml now belong to `_codex_core.config`.

## Active Constraints

- Do not treat this card as owner of always-on AGENTS or config sources.

## Cycle Events

- 01: Split AGENTS.md and config.toml ownership into `_codex_core.config`.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 mixed bootstrap and config ownership.

## Evidence Base

- source:Codex/install.ps1, Codex/VERSION, Codex/.gitignore

## Read Contract

- Read when working on owned Codex bootstrap files.

## Conflicts and Supersession

- superseded: mixing AGENTS/config ownership into this bootstrap card.

## 中文摘要

- 此卡負責 Codex 安裝、版號與 gitignore。
- AGENTS.md 與設定檔已拆到 `_codex_core.config`。

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/.codex/VERSION
- Codex/.gitignore

## Relations

- _codex_core (parent card: navigation only)
- _codex_core.config (sibling card: AGENTS.md and config.toml)
- _shared.adapters-workflow (related adapter memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
