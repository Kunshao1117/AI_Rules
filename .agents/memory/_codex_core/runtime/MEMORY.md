---
name: _codex_core.runtime
scopePath: Codex/
description: >-
  專案記憶：Codex 平台啟動、設定與 runtime hook。Use when: task touches this split memory
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
cycle_id: 2026-07-24-001
cycle_event_count: 3
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

- Owns Codex bootstrap, configuration, hook, and runtime adapter sources.
- `Codex/.codex/AGENTS.md` is an always-on surface: it keeps Direct-first routing, delegated-only Team activation, protected-action boundaries, and a generated adapter pointer.
- The complete Codex adapter and Shared contracts remain canonical under `Shared/policies`; generated markers are pointer-form and are not hand-edited.

## Active Constraints

- Do not load long procedures, test recipes, or audit playbooks into the always-on surface.
- Missing platform/model receipts remain unknown; runtime text must not claim applied configuration without evidence.

## Cycle Events

- 03: Reconciled the Codex always-on contract with Direct-first routing and delegated-only Team activation.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Codex/.codex/AGENTS.md — always-on routing and generated adapter pointer.
- source:Shared/policies/execution-routing.md and Shared/policies/adapters/codex-subagent-invocation.md — canonical routing and adapter boundary.

## Read Contract

- Read when working on owned Codex runtime files.
- Do not use for user-local Codex settings, temporary task evidence, or consumer-project memory.

## Conflicts and Supersession

- superseded: Team-default or long-procedure interpretation of the Codex always-on surface.

## 中文摘要

- Codex runtime 採 Direct-first，只有 delegated topology 才進入 Team。
- `AGENTS.md` 保留必要不變量與 generated pointer，不承載長程序。
- 沒有 receipt 時不得宣稱已套用 model 或 tool 設定。

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks/team-native-gate.ps1
- Codex/.codex/hooks/team-native-launcher.ps1
- Codex/.codex/VERSION
- Codex/.gitignore

## Relations

- _codex_core (parent card: navigation only)
- _shared.adapters-workflow (related adapter memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
