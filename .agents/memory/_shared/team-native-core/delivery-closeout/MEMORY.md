---
name: _shared.team-native-core.delivery-closeout
scopePath: Shared/skills/team-completion-gate/
description: >
  專案記憶：Team-Native 完成證據歷史相容參考。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-07-27T08:21:16+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: pending_review
last_verified: '2026-07-24T13:52:00+08:00'
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

# _shared.team-native-core.delivery-closeout — Module Memory

## Current Truth

- Owns the historical team-completion-gate and completion-evidence-contract reference identities.
- Their source-level/process-complete and legacy evidence fields retain original meaning for applicable frozen Memory or legacy release consumers; they are not general-work completion requirements.
- Current completion-policy owns general task status; language-governance owns the user-facing wording while preserving truthful evidence limits.

## Active Constraints

- Preserve original phase, role and receipt separation for applicable frozen consumers; current general role independence follows Agent Governance.
- Parent/child navigation is not a staleness dependency.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.
- 02: Kept Team closeout evidence internal and centralized beginner-facing completion wording in language governance.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`, `Shared/policies/completion-policy.md`, `Shared/policies/language-governance.md`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
- source:Shared/skills/team-completion-gate/SKILL.md
- source:Shared/skills/team-completion-gate/references/completion-evidence-contract.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_shared/team-native-core/delivery-closeout/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- completion gate與evidence contract保留歷史相容身分
- 一般完成狀態依現行completion policy，舊Memory/release消費者保留原契約

## Tracked Files

- Shared/policies/references/legacy-skills/team-completion-gate/REFERENCE.md
- Shared/policies/references/legacy-skills/team-completion-gate/references/completion-evidence-contract.md

## Relations

- _shared.team-native-core (parent card: navigation only)

## Applicable Skills

- memory-ops — Use current source-only or runtime applicability; this card grants no mutation authority.
- memory-arch — Adjust split topology or archive volumes.
