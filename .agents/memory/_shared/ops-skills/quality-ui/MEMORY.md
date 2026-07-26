---
name: _shared.ops-skills.quality-ui
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 品質閘門、安全可靠性與 UI/UX 標準技能。Use when: task touches this split memory
  scope or its tracked files.
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
cycle_event_count: 13
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

# _shared.ops-skills.quality-ui — Quality and UI Skills Memory

## Current Truth

- Owns Shared quality, intent-alignment, review, security/SRE, UI exploration, and UI/UX skills.
- Quality and review skills provide conditional procedure; terminal review decisions are canonical policy states: `pass`, `pass_with_followups`, or `block`.
- Review is bounded to one consolidated pass and one blocker recheck; Direct work does not require a Team board or independent review unless impact, risk, or topology activates it.
- UI and security claims require surface-appropriate real evidence; mock, fixture, static, or generated-reference evidence remains limited.

## Active Constraints

- Do not turn optional improvements, style preferences, or unrelated issues into completion blockers.
- Do not treat this card as proof that a specific product, UI, or security control passed validation.

## Cycle Events

- 13: Reconciled quality and review skills with bounded decisions, Direct-first completion, and conditional specialist evidence.

## Archive Index

- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base

- source:Shared/skills/ai-dev-quality-gate/SKILL.md
- source:Shared/skills/quality-review-governance/SKILL.md
- source:Shared/skills/intent-alignment-gate/SKILL.md, Shared/skills/security-sre/SKILL.md, and UI skill sources.
- source:Shared/policies/verification-strategy.md — terminal review and verification boundary.

## Read Contract

- Read when changing owned quality, review, security, or UI skill sources.
- Do not use for raw test output or to bypass evidence requirements.

## Conflicts and Supersession

- superseded: skill-local ownership of terminal review disposition or Team artifacts for ordinary Direct work.

## 中文摘要

- Quality/review skill 提供 procedure；完成決定仍由 policy 的三種結果擁有。
- Review 僅一輪加一次 blocker recheck。
- UI 與安全主張要使用對應真實 evidence，mock 或 screenshot 有明確限制。

## Tracked Files

- Shared/skills/ai-dev-quality-gate/SKILL.md
- Shared/skills/intent-alignment-gate/SKILL.md
- Shared/skills/quality-review-governance/SKILL.md
- Shared/skills/security-sre/SKILL.md
- Shared/skills/ui-design-exploration/SKILL.md
- Shared/skills/ui-ux-standards/SKILL.md

## Relations

- _shared.ops-skills (parent card: navigation only)
- _shared.ops-skills.testing (related verification memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
