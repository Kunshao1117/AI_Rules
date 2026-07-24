---
name: _shared.ops-skills.code-analysis
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 程式掃描、診斷與品質操作技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-24T13:40:04+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:40:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 5
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


# _shared.ops-skills.code-analysis — Code Analysis Skills Memory

## Current Truth
- This child card owns Shared code scanning, broad diagnosis, and code-quality operational skills.
- Tracked skill descriptions now start with Traditional Chinese task meaning, while internal artifact keys remain canonical English.
- Code-audit owns deterministic CLI or Gateway-backed scans only when current acceptance directly requires that evidence and no lower-cost evidence is sufficient; Git-only `/10_routine` must not invoke it.
- Code-diagnosis owns broad 3+ module or 15+ file fault diagnosis; its CLI report is preliminary evidence and still needs captain review.
- Code-quality cites the canonical source responsibility contract: one responsibility by default, a second only with strong coupling and independent review, and a mandatory operator-resolved split before a third responsibility is written. Line count alone still does not justify fragmentation.

## Active Constraints
- Keep scan commands, report templates, and diagnosis prompts in tracked source references; this card stores ownership and durable routing constraints only.
- Do not mark scan, diagnosis, or quality findings as verified unless current source, command output, or accepted evidence was checked in the current task.
- Do not run test-of-test or check-of-check work, and do not repair tests or checkers merely to make their own evidence pass.

## Cycle Events
- 04: Retired the removed semantic audit engine and narrowed code-audit to explicitly accepted direct scan evidence outside Git-only routine reporting.
- 05: Refreshed code-quality ownership after responsibility counting moved to the canonical source-size policy.
- 03: Recorded code-quality hardening so [SUDO] never skips gates and 03-1 experiment work cannot support production-ready or complete claims.
- 02: Added minimum-sufficient-complexity alignment to code-quality through quality-review-governance.
- 01: Split code analysis ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:Shared/skills/code-audit/SKILL.md and references — Verified the explicit non-routine scan boundary, Gateway execution boundary, current workspace requirement, and Git-only `/10_routine` exclusion.
- source:Shared/skills/code-diagnosis/SKILL.md and references — Verified broad-diagnosis trigger boundary and preliminary CLI diagnosis report contract.
- source:Shared/skills/code-quality/SKILL.md and Shared/policies/source-document-size-governance.md — Verified responsibility declaration, independent second-responsibility review, third-responsibility split gate, and anti-fragmentation constraints.
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Shared 程式掃描、診斷與品質技能；已移除的語義健檢引擎不再屬於現行能力。
- 這批 dirty source 已改成繁中 meaning-first 觸發語意，內部報告欄位仍保留 canonical English。
- 只有驗收直接需要且沒有更低成本證據時才執行程式掃描；Git-only `/10_routine` 不得呼叫掃描技能。
- code-quality 現在引用唯一的責任治理來源：預設一責任、第二責任需強耦合審查、第三責任必須先拆檔並詢問操作者。
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
