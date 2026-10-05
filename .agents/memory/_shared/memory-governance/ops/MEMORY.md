---
name: _shared.memory-governance.ops
scopePath: Shared/skills/memory-ops/
description: >
  專案記憶：記憶讀寫與生命週期操作。Use when: task touches memory-ops skill or its template,
  lifecycle, or MCP contract references.
last_updated: '2026-08-17T21:12:36+08:00'
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

# _shared.memory-governance.ops — Module Memory

## Current Truth


- Owns the memory-ops Skill and its template, lifecycle and MCP-tool-contract references.
- For an exact project/runtime without evidenced M5 cutover, physical runtime Memory write and commit retain distinct protected phases under the legacy contract; uncertain activation stays frozen.
- After evidenced cutover, necessary same-scope existing-card maintenance and subsequent commit may qualify as local_work only under current Authorization Resolution.
- Explicit Repository Source Reconciliation has its own conjunctive source-only boundary, independent patch review and recoverable history. It cannot call Memory mutation tools, rewrite the derived index or claim runtime activation.

## Active Constraints

- Do not treat read-only listing as mutation authority.

## Cycle Events

- 01: Created during the remaining granularity split from memory-governance.

## Archive Index

- Parent archive-001.md records the pre-split file list.

## Evidence Base

- Source-only comparison: `Shared/skills/memory-ops/SKILL.md`, `Shared/policies/authorization-resolution.md`, `Shared/policies/references/repository-memory-reconciliation.md`.
- Earlier entries below are historical evidence; preserved timestamps do not certify current runtime or index state.

- source:Shared/skills/memory-ops/SKILL.md

## Read Contract

- Read when changing owned memory-ops sources.

## Conflicts and Supersession


- The earlier unqualified phase statement is scoped to frozen runtime/legacy consumers; source-only correction never supplies their receipts.
- Original card and prior claims remain in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/b61b27c2d0a6d65d08ded101d323d62cf06d2098/.agents/memory/_shared/memory-governance/ops/MEMORY.md); existing Cycle Events and archives are preserved.
- Current review is bounded to the cited source semantics and tracking; provider/index/runtime synchronization and unreviewed historical assertions remain unverified.

## 中文摘要


- 此卡負責memory-ops方法與卡片、生命週期、工具契約
- 未證實M5的runtime維持原write／commit分段契約
- 受控來源卡校正需完整證據與獨立審查，不等於Memory工具同步或cutover

## Tracked Files

- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/memory-ops/references/memory-lifecycle-procedures.md
- Shared/skills/memory-ops/references/memory-mcp-tool-contract.md

## Relations

- _shared.memory-governance (parent card: navigation only)
- _shared.memory-governance.arch (sibling card: topology rules)

## Applicable Skills

- memory-ops — Follow current source-only or runtime applicability; this card does not authorize mutation.
