---
name: _shared.ops-skills.skill-governance.delegation-cli
scopePath: Shared/skills/delegation-strategy/
description: >
  專案記憶：委派 CLI 能力與操作參考。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-24T16:46:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
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

- Owns delegation CLI capability, SOP, and prompt-skeleton references.
- This child owns the listed concrete source files after the 2026-07-24 split.

## Active Constraints

- Keep source/deployed ownership paired where both surfaces are tracked.
- Parent/child navigation is not a staleness dependency.

## Cycle Events

- 01: Created during the authorized memory split after current-source verification.

## Archive Index

- Parent archive preserves the pre-split ownership history.

## Evidence Base

- source:Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- source:Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or parent history.

## Conflicts and Supersession

- None.

## 中文摘要

- 委派 CLI 能力與操作參考。
- 具體檔案歸屬已由父卡移入此子卡。

## Tracked Files

- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md

## Relations

- _shared.ops-skills.skill-governance (parent card: navigation only)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
