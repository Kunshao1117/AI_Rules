---
name: _codex_core.support.workflows-audit
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 健檢主工作流與三階段子工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-07T22:46:24+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-07-001
cycle_event_count: 3
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

# _codex_core.support.workflows-audit — Codex Audit Workflow Memory

## Current Truth
- Audit workflow descriptions now start with Traditional Chinese semantic labels and keep English trigger terms in parentheses: full audit, infra scan, deep audit, evidence gaps, audit report, and health report.
- `08-audit`, `08-1`, `08-2`, and `08-3` remain thin route entries that select workflow row `08`, apply the platform adapter, and never authorize write, memory, git, release, deploy, install, credential, or external-state mutation.
- Required References load on demand: captain entry starts from route/evidence/minimum Team-Native gates, while language, grounding, platform, stage, station, validation, review, memory, completion, and protected references load only when needed.
- The Workflow Entry Slimming Guard owns route selection, workflow-specific phase order, minimum load gates, evidence-matrix row, and platform adapter reference only; dirty target files require current diff review and in-section integration.
- Audit evidence, inventories, broad reads, validation planning, review evidence, and completion claims require formal team routing, handoff packet, station-owned evidence, and honest blocked/unverified/risk-closed states for missing evidence.
- Audit repair, source writes, memory writes, `memory_commit`, git, release, deploy, install, credential, cloud, and external mutation remain separately authorized protected phases.
- Audit reports must not mark missing evidence as green, infer full coverage from samples, or let review/validation findings become repair authority.

## Active Constraints
- Do not claim full coverage without denominators, sampling limits, and evidence status.
- Keep audit subflows read-only unless the governing workflow opens a resolved formal-write or protected owner station.
- Keep audit workflow entries thin; durable audit procedure belongs in Shared policies, Shared skills, or workflow-stage references.

## Cycle Events
- 03: Updated audit workflow memory for Chinese-first descriptions, thin-entry wrapping, on-demand references, and dirty-diff slimming guard semantics.
- 02: Preserved formal-readonly audit evidence routing, coverage honesty, review/validation separation, and protected repair follow-up rules.
- 01: Removed stale warning text after current audit workflow file content and targeted diffs were reviewed.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.
- Earlier active cycle details were compacted into Current Truth on 2026-07-07 to keep this card within line limits.

## Evidence Base
- source: `Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md`.
- source: `Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md`, `08-2-logic-深度邏輯/SKILL.md`, and `08-3-report-健檢總結/SKILL.md`.
- tool: targeted `git diff` and `rg` output reviewed on 2026-07-07 for audit description, thin-entry, on-demand reference, and dirty-diff changes.
- director: 2026-07-07 station C instruction limited memory writes to `_codex_core` cards and excluded already-committed hook behavior.

## Read Contract
- Read this card when changing owned Codex audit workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- superseded: stale warning blocks and older English-first audit description facts were replaced by current dirty-source evidence.

## 中文摘要
- 健檢 workflow description 已改為繁中語義先行，英文 trigger 留在括號中。
- 健檢入口與三階段子流程仍是 thin route，不授權寫入、記憶、git、release、deploy 或外部變更。
- 健檢證據、盤點、廣泛讀取、review/validation 與完成宣稱都需要正式站點證據。
- 缺證據不能當綠燈；修復與記憶寫入是後續分離 protected phase。

## Tracked Files
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared (shared audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
