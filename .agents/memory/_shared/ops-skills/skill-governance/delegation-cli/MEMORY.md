---
name: _shared.ops-skills.skill-governance.delegation-cli
scopePath: Shared/skills/delegation-strategy/
description: >
  專案記憶：CLI 委派歷史相容參考。
  Use when: task touches these owned source or historical reference identities.
last_updated: '2026-07-24T16:46:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
last_verified: '2026-07-24T13:50:00+08:00'
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

# _shared.ops-skills.skill-governance.delegation-cli — Module Memory

## Current Truth

- Owns the retained historical CLI capability matrix, delegation SOP and prompt-skeleton references from delegation-strategy.
- These are non-invocable compatibility documents. Generic AI CLI workers remain inactive; a historical command recipe or matrix is not current availability or execution authority.

## Active Constraints

- Keep source/deployed ownership paired where both surfaces are tracked.
- Parent/child navigation is not a staleness dependency.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- Current source comparison: `Shared/policies/references/legacy-skill-migration.md`, `Shared/policies/references/legacy-skill-migration.json`, `Shared/policies/agent-governance.md`, `Shared/policies/execution-routing.md`.
- Earlier entries below retain historical evidence only; preserved timestamps do not certify current runtime or index state.
- source:Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- source:Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- Retired source identities are preserved at the exact current reference paths; those bodies do not reactivate Skills or general Team machinery.
- Original content remains in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/098609bedac92bbe17776e4263d32c7383fe917d/.agents/memory/_shared/ops-skills/skill-governance/delegation-cli/MEMORY.md); Cycle Events and existing archives are preserved.
- This source-only comparison does not certify ignored runtime/editor paths or provider/index synchronization.

## 中文摘要

- 保留CLI capability、SOP與prompt-skeleton歷史參考
- generic AI CLI不因讀到舊文件而重新啟用，也不從舊表推定工具可用

## Tracked Files

- Shared/policies/references/legacy-skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/policies/references/legacy-skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/policies/references/legacy-skills/delegation-strategy/references/cli-prompt-skeleton.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)

## Applicable Skills

- memory-ops — Use current source-only or runtime applicability; this card grants no mutation authority.
- memory-arch — Adjust split topology or archive volumes.
