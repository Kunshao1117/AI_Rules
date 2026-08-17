---
name: _cursor_core.runtime
scopePath: Cursor/
description: >
  專案記憶：Cursor 平台規則、安裝與混倉身分。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-08-17T18:56:59+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T18:55:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-001
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

# _cursor_core.runtime — Module Memory

## Current Truth

- Owns Cursor Edition bootstrap, version, README, and always-on rules.
- Deployed rules live in `.cursor/rules/`; skills and workflow entries live in `.cursor/skills/`. Shared governance and memory stay in `.agents/shared/` and `.agents/memory/`.
- `02-platform-identity.mdc` owns mixed-repo session identity: other platform files are source templates, not bootstrap, install prompts, or a Claude sub-agent write ban.
- AI_Rules installs no global Cursor bootstrapper, VS Code manager sync, or repository-local Team-routing hooks. Cursor Task types remain transport only.

## Active Constraints

- Do not Fresh-deploy onto this source repo to create a root `.cursor/` overlay.
- Do not emit another platform's `GO INSTALL` or `GO UPGRADE` unless the Director named that platform.
- Editing another platform's source does not switch session identity.

## Cycle Events

- 01: Recorded Cursor Edition v0.1.0 runtime surfaces and mixed-repo identity.

## Archive Index

- None yet.

## Evidence Base

- source:Cursor/.cursor/rules/00-core.mdc, Cursor/.cursor/rules/01-lazy-load.mdc, Cursor/.cursor/rules/02-platform-identity.mdc
- source:Cursor/install.ps1, Cursor/README.md, Cursor/VERSION
- source:Shared/policies/adapters/cursor-subagent-invocation.md

## Read Contract

- Read when working on owned Cursor runtime files.
- Do not use for user-local Cursor MCP settings or consumer-project memory.

## Conflicts and Supersession

- superseded: treating Claude/Codex/Antigravity cores as this Cursor session's bootstrap.

## 中文摘要

- Cursor 規則在 `.cursor/rules/`，技能與工作流在 `.cursor/skills/`。
- 混倉時仍是 Cursor Edition；另外三平台檔案只當來源模板。
- 預設不安裝全域啟動器、VS Code 管理器或 Team hook。

## Tracked Files

- Cursor/VERSION
- Cursor/README.md
- Cursor/install.ps1
- Cursor/.gitignore
- Cursor/.cursor/VERSION
- Cursor/.cursor/rules/00-core.mdc
- Cursor/.cursor/rules/01-lazy-load.mdc
- Cursor/.cursor/rules/02-platform-identity.mdc

## Relations

- _cursor_core (parent card: navigation only)
- _shared.adapters-workflow (related adapter memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
