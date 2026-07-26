---
name: _shared.ops-skills.code-analysis
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 程式掃描、診斷與品質操作技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-27T00:02:51+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 6
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

- Owns Shared code-audit, code-diagnosis, and code-quality operational skills and their listed references.
- `code-audit` is conditional: use it for explicit deep audit or concrete high-risk evidence, not as an automatic continuation of ordinary verification failure.
- `code-diagnosis` supports broad fault investigation but its output is preliminary evidence, not a final completion decision.
- `code-quality` consumes the canonical responsibility-first size contract and does not create a separate split policy.

## Active Constraints

- Keep scan commands and report formats in source references; this card stores durable ownership and routing only.
- Do not repair tests or checkers merely to make their own evidence pass.

## Cycle Events

- 06: Reconciled code-analysis skills with conditional deep-audit routing and the canonical responsibility-first size owner.

## Archive Index

- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base

- source:Shared/skills/code-audit/SKILL.md
- source:Shared/skills/code-diagnosis/SKILL.md
- source:Shared/skills/code-quality/SKILL.md and Shared/policies/source-document-size-governance.md

## Read Contract

- Read when changing owned code-analysis skills or their direct references.
- Do not use as proof that a specific repository scan has passed.

## Conflicts and Supersession

- superseded: generic verification failure as sufficient code-audit trigger.

## 中文摘要

- Code audit 只在 explicit deep audit 或具體高風險證據下啟動。
- Code diagnosis 是初步證據，不能自行宣告完成。
- Code quality 使用唯一的 responsibility-first size owner。

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

- _shared.ops-skills (parent card: navigation only)
- _shared.governance-foundation (related size governance)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
