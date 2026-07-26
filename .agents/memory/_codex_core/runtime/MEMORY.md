---
name: _codex_core.runtime
scopePath: Codex/
description: >-
  專案記憶：Codex 平台啟動、設定與 runtime hook。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T03:08:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T03:07:18+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 4
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

- Owns Codex bootstrap, configuration, and runtime adapter sources.
- `Codex/.codex/AGENTS.md` is an always-on surface. It retains Director-facing zh-TW, Direct-first routing, delegated positive triggers, read-before-write and dirty-work protection, protected-action and canonical-source pointers, V1 heterogeneous delegation availability, and lazy-load pointers.
- Codex hooks remain a platform capability, but AI_Rules installs no repository-local hook configuration or Team-Native hook scripts by default. Direct/delegated routing remains owned by `Shared/policies/execution-routing.md`.
- The complete Codex adapter and Shared contracts remain canonical under `Shared/policies`; generated markers are pointer-form and are not hand-edited.

## Active Constraints

- Do not load long procedures, test recipes, or audit playbooks into the always-on surface.
- A future hook needs a deterministic tool- or event-bound responsibility, documented payload and output semantics, and an exact matcher. It must not inject Team policy, infer topology from prose, or duplicate authorization policy.
- Missing platform/model receipts remain unknown; runtime text must not claim applied configuration without evidence.

## Cycle Events

- 04: Slimmed the Codex always-on entry and retired unconditional repository-local Team hooks from the default deployment.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Codex/.codex/AGENTS.md, Codex/.codex/config.toml, and Codex/global/config.toml — bounded always-on entry and no forced hook default.
- source:Codex/README.md, Shared/platform-capability-matrix.md, and Shared/policies/adapters/codex-subagent-invocation.md — hook capability, deployment boundary, and canonical adapter.

## Read Contract

- Read when working on owned Codex runtime files.
- Do not use for user-local Codex settings, temporary task evidence, or consumer-project memory.

## Conflicts and Supersession

- superseded: Team-default or long-procedure interpretation of the Codex always-on surface, and unconditional repository-local Team-routing hooks.

## 中文摘要

- Codex hooks 是平台能力，但 AI_Rules 預設不安裝 repository-local Team hook。
- `AGENTS.md` 只保留 Direct-first、delegated 正向觸發、寫入/髒工作保護、受保護動作與 canonical pointer 等必要不變量。
- 未來 hook 必須是精準、deterministic 且綁定正式 payload 的工具或事件守衛；沒有 receipt 不得宣稱已套用。

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/VERSION
- Codex/.gitignore

## Relations

- _codex_core (parent card: navigation only)
- _shared.adapters-workflow (related adapter memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
