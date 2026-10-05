---
name: _claude_core.core-rules
scopePath: Claude/.claude/rules/
description: >
  專案記憶：Claude 核心來源規則與歷史詞彙/對齊參考。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-08-17T21:12:31+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
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

# _claude_core.core-rules — Module Memory

## Current Truth

- Owns Claude core-identity and memory-contract source rules and retains their separately identified managed-runtime tracking.
- forbidden-vocab is preserved as a historical reference, not an active always-on language gate; current user-facing wording belongs to language-governance.
- The ignored .claude/skills/intent-alignment-gate/SKILL.md entry is a historical runtime projection identity; Git absence does not establish its installed presence, deletion or activation.
- Support rules and settings retain their existing sibling owner.

## Active Constraints

- Keep user-visible reporting pointers in Shared language governance.
- Command routes do not grant write or protected-action authority.

## Cycle Events

- 01: Created during the remaining granularity split from commands-delivery.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`, `Claude/.claude/rules/core-identity.md`, `Claude/.claude/rules/memory-contract.md`, `Shared/policies/language-governance.md`, `Shared/policies/references/claude-legacy-rules/forbidden-vocab.md`, `Shared/policies/references/source-runtime-surface-map.md`, `Tests/TeamNative/Phase5C2SemanticLoad.Tests.ps1`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
- source:Claude/.claude/rules/core-identity.md, Claude/.claude/rules/memory-contract.md

## Read Contract

- Read when reviewing owned Claude source rules or the historical vocabulary/intent identities.

## Conflicts and Supersession

- superseded: mixing core-rule ownership into the delivery-command card.
- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_claude_core/core-rules/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- 核心身分與Memory入口仍為來源規則；舊詞彙規則已轉為歷史reference
- 忽略的intent-alignment runtime路徑不能由Git快照判定是否仍安裝

## Tracked Files

- Claude/.claude/rules/core-identity.md
- .claude/rules/core-identity.md
- .claude/skills/intent-alignment-gate/SKILL.md
- Claude/.claude/rules/memory-contract.md
- Shared/policies/references/claude-legacy-rules/forbidden-vocab.md

## Relations

- _claude_core (parent card: navigation only)
- _claude_core.runtime (sibling card: install and bootstrap)
- _claude_core.support.rules-settings (related support-rule memory)

## Applicable Skills

- memory-ops — Use current source-only or runtime applicability; this card grants no mutation authority.
