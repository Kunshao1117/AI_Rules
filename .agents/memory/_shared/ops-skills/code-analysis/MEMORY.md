---
name: _shared.ops-skills.code-analysis
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 程式掃描、診斷與品質操作技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-07T05:52:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:52:39+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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
- This child card owns Shared code scanning, broad diagnosis, code-quality, and audit-engine operational skills.
- Tracked skill descriptions now start with Traditional Chinese task meaning, while internal artifact keys remain canonical English.
- Code-audit owns deterministic CLI or Gateway-backed scans; Gateway discovery is schema evidence only, and real downstream MCP calls must go through `gateway__call_tool` with the current workspace.
- Code-diagnosis owns broad 3+ module or 15+ file fault diagnosis; its CLI report is preliminary evidence and still needs captain review.
- Audit-engine is the /08 semantic audit engine only; it classifies depth, project surface, inventory denominator, evidence packets, traffic lights, and coverage without running tools or writing memory.
- Audit-engine treats screenshot-only visual evidence, fake-data visual evidence, sampled checks, and synthetic evidence as partial or unverified when real behavior is in scope.
- Code-quality routes simple-versus-complex implementation choices to `quality-review-governance`, rejects speculative abstraction and line-count-only splitting, and keeps [SUDO] or 03-1 output from supporting `complete`.

## Active Constraints
- Keep scan commands, report templates, diagnosis prompts, and audit matrices in tracked source references; this card stores ownership and durable routing constraints only.
- Do not mark scan, diagnosis, quality, or audit findings as verified unless current source, command output, or accepted evidence was checked in the current task.
- In /08 audit, use audit-engine semantics instead of re-running code-audit relationship/API/dead-code/key-function/data-layer checks locally.

## Cycle Events
- 04: Repaired stale dirty-source memory for code-audit, code-diagnosis, code-quality, and audit-engine trigger language, evidence, and routing boundaries.
- 03: Recorded code-quality hardening so [SUDO] never skips gates and 03-1 experiment work cannot support production-ready or complete claims.
- 02: Added minimum-sufficient-complexity alignment to code-quality through quality-review-governance.
- 01: Split code analysis ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:Shared/skills/code-audit/SKILL.md and references — Verified zh-TW trigger wording, Gateway execution boundary, scan report meaning-first labels, and current workspace requirement.
- source:Shared/skills/code-diagnosis/SKILL.md and references — Verified broad-diagnosis trigger boundary and preliminary CLI diagnosis report contract.
- source:Shared/skills/code-quality/SKILL.md — Verified [SUDO], 03-1 prototype-only, minimum-sufficient-complexity, and anti-fragmentation constraints.
- source:Shared/skills/audit-engine/SKILL.md and references — Verified /08-only semantic engine boundary, inventory denominator, real-evidence, visual/fake-data, and memory-write boundaries.
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Shared 程式掃描、診斷、品質與健檢語義引擎技能。
- 這批 dirty source 已改成繁中 meaning-first 觸發語意，內部報告欄位仍保留 canonical English。
- 真實工具執行、Gateway MCP 呼叫與 /08 audit 語義判定不能互相取代。
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
- Shared/skills/audit-engine/SKILL.md
- Shared/skills/audit-engine/references/audit-inventory-contracts.md
- Shared/skills/audit-engine/references/project-surface-matrix.md
- Shared/skills/audit-engine/references/surface-audit-recipes.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
