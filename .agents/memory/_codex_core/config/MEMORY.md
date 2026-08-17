---
name: _codex_core.config
scopePath: Codex/
description: >
  專案記憶：Codex AGENTS.md 與 config.toml。Use when: task touches Codex global or
  project AGENTS.md, or Codex config.toml sources.
last_updated: '2026-08-17T21:12:34+08:00'
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

# _codex_core.config — Module Memory

## Current Truth

- Owns Codex global and project `AGENTS.md` sources, the managed runtime copy, and both `config.toml` files.
- `Codex/.codex/AGENTS.md` remains the always-on surface with Direct-first routing and lazy-load pointers.
- AI_Rules installs no repository-local Team hook configuration by default.

## Active Constraints

- Do not load long procedures into the always-on surface.
- Missing platform/model receipts remain unknown; runtime text must not claim applied configuration without evidence.

## Cycle Events

- 01: Created during the remaining granularity split from `_codex_core.runtime`.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- source:Codex/.codex/AGENTS.md, Codex/.codex/config.toml, Codex/global/config.toml

## Read Contract

- Read when changing owned Codex agents or config files.

## Conflicts and Supersession

- superseded: mixing AGENTS/config ownership into the bootstrap runtime card.

## 中文摘要

- 此卡負責 Codex AGENTS.md 與設定檔。
- 預設不安裝 repository-local Team hook。

## Tracked Files

- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- .codex/AGENTS.md
- Codex/.codex/config.toml

## Relations

- _codex_core (parent card: navigation only)
- _codex_core.runtime (sibling card: bootstrap and VERSION)
- _shared.adapters-workflow (related adapter memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
