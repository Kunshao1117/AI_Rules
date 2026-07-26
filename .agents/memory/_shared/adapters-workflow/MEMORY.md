---
name: _shared.adapters-workflow
scopePath: Shared/policies/adapters/
description: >-
  專案記憶：跨平台 adapter 與 workflow 轉譯。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-26T17:20:26+08:00'
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
cycle_event_count: 2
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

# _shared.adapters-workflow — Module Memory

## Current Truth

- Owns the listed platform subagent invocation and thread-handoff adapters.
- Adapters translate syntax, paths, invocation surfaces, runtime locations, and observable platform capability only; they do not redefine core governance.
- Direct execution never activates Team subagents by itself. Delegated behavior begins only after the canonical routing condition resolves delegated topology.
- Requested, accepted, and applied execution states remain distinct; an absent platform receipt is unknown, not proof of application.

## Active Constraints

- Preserve the canonical-to-adapter-to-runtime direction; do not make runtime a source of truth.
- Do not weaken protected-action, verification, review, or completion semantics in an adapter.

## Cycle Events

- 02: Reconciled all platform invocation adapters with Direct-first routing, delegated-only subagent activation, and receipt honesty.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/adapters/antigravity-subagent-invocation.md
- source:Shared/policies/adapters/claude-subagent-invocation.md
- source:Shared/policies/adapters/codex-subagent-invocation.md
- source:Shared/policies/execution-routing.md and Shared/policies/task-capability-assessment.md

## Read Contract

- Read when working on the owned platform adapter sources.
- Do not use for platform capability claims not supported by an observable receipt.

## Conflicts and Supersession

- superseded: adapter-local Team-default routing or fabricated applied-configuration claims.

## 中文摘要

- Adapter 只轉譯平台表面，不重新定義治理。
- Direct 不會自行啟動 subagent；只有 delegated topology 才會。
- requested、accepted、applied receipt 必須分開；缺 receipt 即為 unknown。

## Tracked Files

- Shared/policies/adapters/antigravity-subagent-invocation.md
- Shared/policies/adapters/claude-subagent-invocation.md
- Shared/policies/adapters/codex-subagent-invocation.md
- Shared/policies/adapters/codex-thread-handoff.md

## Relations

- _shared (parent card: navigation only)
- _codex_core.runtime (related Codex runtime memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
