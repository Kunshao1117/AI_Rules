---
name: _shared.ops-skills.skill-governance.delivery-artifacts
scopePath: Shared/skills/
description: >
  專案記憶：Team 交付 artifact 與角色邊界歷史參考。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-08-17T21:12:50+08:00'
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

# _shared.ops-skills.skill-governance.delivery-artifacts — Module Memory

## Current Truth

- Owns the historical Team review, validation, memory-docs, change-delivery and role-boundary reference identities.
- Legacy schemas and role IDs retain their meaning only for applicable frozen consumers. General work uses current bounded Agent assignments and required independence; Team alone does not load old artifact Skills.
- Separately tracked runtime copies remain owned by delivery-runtime; source references do not prove those copies exist or are synchronized.

## Active Constraints

- Do not allow an artifact procedure to redefine verification, terminal review, or completion policy.
- Max depth is 4; deployed copies are a sibling card, not a nested child.

## Cycle Events

- 01: Split deployed copies into `_shared.ops-skills.skill-governance.delivery-runtime`.

## Archive Index

- archive-001.md — Pre-split 2026-08-17 paired source and deployed ownership.

## Evidence Base

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`, `Shared/policies/references/legacy-memory-team-transition.md`, `Shared/policies/references/source-runtime-surface-map.md`, `.agents/memory/_shared/ops-skills/skill-governance/delivery-runtime/MEMORY.md`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
- source:Shared/skills/team-change-delivery-artifact/SKILL.md, Shared/skills/team-role-boundaries/SKILL.md

## Read Contract

- Read when changing owned Team delivery-artifact sources.

## Conflicts and Supersession

- superseded: requiring formal Team artifacts for ordinary Direct work.
- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_shared/ops-skills/skill-governance/delivery-artifacts/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- 舊Team交付與role-boundary來源保留為相容reference
- 一般Team不強制載入舊artifact或站點鏈；runtime副本另列，不推定已同步

## Tracked Files

- Shared/policies/references/legacy-skills/team-review-delivery-artifact/REFERENCE.md
- Shared/policies/references/legacy-skills/team-validation-delivery-artifact/REFERENCE.md
- Shared/policies/references/legacy-skills/team-memory-docs-delivery-artifact/REFERENCE.md
- Shared/policies/references/legacy-skills/team-change-delivery-artifact/REFERENCE.md
- Shared/policies/references/legacy-skills/team-role-boundaries/REFERENCE.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)
- _shared.ops-skills.skill-governance.delivery-runtime (sibling card: deployed copies)

## Applicable Skills

- memory-ops — Use current source-only or runtime applicability; this card grants no mutation authority.
