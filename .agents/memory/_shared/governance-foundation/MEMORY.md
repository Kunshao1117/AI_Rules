---
name: _shared.governance-foundation
scopePath: Shared/
description: >
  專案記憶：Shared 語言、接地、尺寸與治理基礎。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-24T16:46:24+08:00'
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

# _shared.governance-foundation — Module Memory

## Current Truth

- Owns Shared governance foundation, language, grounding, size, and skill-governance sources.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Parent/child navigation is a relation, not a staleness dependency.
- Keep current procedure detail in the tracked source files.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/workflow-stage-procedures.md
- source:Shared/skill-governance.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- Shared 語言、接地、尺寸與治理基礎。
- 具體檔案歸屬已由父卡移入此子卡。

## Tracked Files

- Shared/workflow-stage-procedures.md
- Shared/policies/language-governance.md
- .agents/shared/policies/language-governance.md
- Shared/policies/grounding-governance.md
- .agents/shared/policies/grounding-governance.md
- Shared/policies/source-document-size-governance.md
- .agents/shared/policies/source-document-size-governance.md
- Shared/skill-governance.md

## Relations

- _shared (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
