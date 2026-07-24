---
name: _shared.adapters-workflow
scopePath: Shared/policies/adapters/
description: >
  專案記憶：跨平台 adapter 與 workflow 交接。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-24T13:52:40+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:49:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _shared.adapters-workflow — Module Memory

## Current Truth

- Owns platform subagent invocation and Codex thread-handoff adapters.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Parent/child navigation is a relation, not a staleness dependency.
- Keep current procedure detail in the tracked source files.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/policies/adapters/antigravity-subagent-invocation.md
- source:Shared/policies/adapters/codex-thread-handoff.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- 跨平台 adapter 與 workflow 交接。
- 具體檔案歸屬已由父卡移入此子卡。

## Tracked Files

- Shared/policies/adapters/antigravity-subagent-invocation.md
- Shared/policies/adapters/claude-subagent-invocation.md
- Shared/policies/adapters/codex-subagent-invocation.md
- Shared/policies/adapters/codex-thread-handoff.md

## Relations

- _shared (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.

