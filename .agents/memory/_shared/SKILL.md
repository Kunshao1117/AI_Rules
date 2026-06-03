---
name: _shared
description: >
  Shared 共用治理資產記憶卡。追蹤跨平台共用政策、記憶模型、操作型技能來源與脈絡模板。 Use when: 修改 Shared/
  下的共用技能、政策、記憶治理或脈絡模板時。
scopePath: Shared/
last_updated: '2026-06-04T04:23:01+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _shared — Shared Governance Memory

## Current Truth

- Shared/ is the single source for 40 operational skills and cross-platform governance assets.
- Shared skills are deployed into Antigravity, Claude, and Codex by the shared sync engine.
- Memory governance now uses schema v2 with Current Truth, Active Constraints, Cycle Events, Archive Index, and 中文摘要.
- Memory cards must avoid unbounded repair logs and must compact or archive historical detail.
- File-count split warnings are advisory unless hard limits, mixed ownership, or maintenance difficulty require a split.
- Archive volumes use flat `archive-###.md` files rather than nested archive directories.
- Project context lives in `.agents/context/` and is not source memory.
- Shared subagent policy is vendor-neutral; platform-specific tool wording belongs in platform adapters.
- UI quality, testing, audit, and project-context skills are shared operational guidance, not platform-only rules.

## Active Constraints

- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; the memory audit tool expects readable files.
- Parent or child card navigation belongs in Relations, not frontmatter dependencies.
- Treat cards above 8 tracked files as split candidates, not automatic blockers.
- This parent card still needs phase-2 child cards for large skill families.

## Cycle Events

- 01: Compacted Shared memory into schema v2 and archived the legacy long-form card.
- 02: Aligned granularity and archive naming rules with advisory split semantics.

## Archive Index

- archive-001.md — Legacy _shared card preserved before schema v2 compaction on 2026-06-04.

## 中文摘要

- Shared 是 40 套共用技能與政策的唯一來源。
- 記憶治理已改成新版主卡加歸檔模型。
- 專案脈絡與原始碼記憶分層管理。
- 超過 8 個追蹤檔是拆卡建議，不是自動阻擋。
- 歸檔卷採平面檔名，避免目錄污染索引。

## Tracked Files

- Shared/platform-capability-matrix.md
- Shared/skill-governance.md
- Shared/policies/subagent-invocation.md
- Shared/mcp-profiles/README.md
- Shared/context/_map/CONTEXT.md
- Shared/skills/_index.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/project-context-protocol/SKILL.md
- Shared/skills/audit-engine/SKILL.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/test-patterns/SKILL.md
- .agents/memory/_shared/archive-001.md

## Relations

- _system (deployment and sync engine memory)
- _codex_core (Codex platform adapter memory)
- _claude_core (Claude platform adapter memory)
- _ag_core (Antigravity platform adapter memory)
- _shared.ops-skills (child card for general operational skills)
- _shared.supabase-postgres (child card for Supabase Postgres reference corpus)

## Applicable Skills

- memory-ops — Use when updating this card.
- memory-arch — Use for phase-2 Shared child-card splitting.
- skill-factory — Use when adding or reshaping Shared skills.
