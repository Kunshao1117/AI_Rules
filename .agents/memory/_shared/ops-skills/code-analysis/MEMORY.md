---
name: _shared.ops-skills.code-analysis
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 程式掃描、診斷與品質操作技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-02T14:01:52+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-21T11:15:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 2
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _shared.ops-skills.code-analysis — Code Analysis Skills Memory

## Current Truth
- This child card owns Shared code scanning, diagnosis, and code-quality operational skills.
- The parent `_shared.ops-skills` card is now a navigation card for operational-skill families.
- Detailed command recipes and report templates remain in the tracked skill references, not in memory.
- Code-quality now routes simple-versus-complex implementation choices to quality-review-governance and treats speculative abstraction or line-count-only splitting as a quality regression.
- Code-quality now treats [SUDO] as an override/risk-closure request only and treats 03-1 experiment output as prototype-quality, not production-ready completion evidence.

## Active Constraints
- Keep scan command recipes in source reference files; this card stores ownership and current constraints only.
- Do not mark findings as verified unless the relevant source or tool output has been checked in the current task.

## Cycle Events
- 03: Recorded code-quality hardening so [SUDO] never skips gates and 03-1 experiment work cannot support production-ready or complete claims.
- 02: Added minimum-sufficient-complexity alignment to code-quality through quality-review-governance.
- 01: Split code analysis ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Shared 程式掃描、診斷與品質技能。
- 父卡只保留導覽，不再直接追蹤這批檔案。

## Tracked Files
- Shared/skills/code-audit/references/scan-report-template.md
- Shared/skills/code-audit/references/scan-task-prompt.md
- Shared/skills/code-audit/references/tool-command-reference.md
- Shared/skills/code-audit/SKILL.md
- Shared/skills/code-diagnosis/references/diagnosis-report-template.md
- Shared/skills/code-diagnosis/references/diagnosis-task-prompt.md
- Shared/skills/code-diagnosis/SKILL.md
- Shared/skills/code-quality/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
