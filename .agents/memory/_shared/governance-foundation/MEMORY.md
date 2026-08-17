---
name: _shared.governance-foundation
scopePath: Shared/
description: >-
  專案記憶：Shared 語言、接地、尺寸與治理基礎。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-08-17T18:57:10+08:00'
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

# _shared.governance-foundation — Module Memory

## Current Truth

- Owns Shared language, grounding, document-size, workflow-stage, and skill-governance foundations.
- Skill governance records Cursor entry shapes: `.cursor/rules/*.mdc` for instruction load and `.cursor/skills/` for both workflow and operational skills.
- User-visible reports default to beginner-friendly zh-TW for Direct and delegated work.

## Active Constraints

- No repository-identity branch may create separate internal and consumer policy semantics.
- Preserve exact external text and avoid mass comment translation.

## Cycle Events

- 04: Extended the same single language policy to VS Code product surfaces without creating a parallel reporting policy.
- 05: Defined passed and failed verification wording separately from commit, release, and deployment states.
- 06: Recorded Cursor skill-governance entry shapes after Cursor Edition v0.1.0.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skill-governance.md
- source:Shared/policies/language-governance.md

## Read Contract

- Read when changing owned Shared governance foundations.

## Conflicts and Supersession

- superseded: captain-only Director language handling and line-count-only splitting rules.

## 中文摘要

- Cursor 技能入口是 `.cursor/skills/`，規則入口是 `.cursor/rules/*.mdc`。
- Direct 與 Team 都用同一套初學者可讀的繁中回覆。

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
- _shared.team-native-core.policy-core (related canonical policy memory)
- _cursor_core (related Cursor platform memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
