---
name: _codex_core.support.workflows-release
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 提交、巡檢與技能鍛造工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-28T11:33:19+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T11:28:20+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 12
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
# _codex_core.support.workflows-release — Codex Release and Governance Workflow Memory

## Current Truth
- Codex commit workflow treats specialists as evidence-only for review, validation, and completion packets; memory, git, push, and release remain captain-only mutations.
- Codex commit and release workflows now inherit team-task-package references through the shared workflow entry contract while keeping git, memory, and release ownership on the captain path.
- Codex commit, routine, and skill-forge workflows now require task type, dispatch pre-gate, Captain Minimum Execution Gate, text patch packets, and accepted-risk captain substitution before specialist work.
- Codex commit, routine, and skill-forge workflows keep git, memory, and release mutations on the captain while evidence stations use role-bound team branches.
- Codex commit, routine, and skill-forge workflows now load programming-team-governance with applicability/execution-mode station reporting while keeping git, memory, and release mutations on the main thread.
- Codex commit, routine, handoff, and skill-forge workflows now require evidence owner, direct exception, completion condition, and all-direct fake-team guards while keeping git, memory, and release mutations on the main thread.
- Codex commit, routine, and skill-forge workflows now use the MCP Memory Evidence Matrix for preflight, read-only routine, and skill attribution evidence.
- This child card owns Codex commit, routine, and skill-forge workflow skills.
- Commit workflow must verify memory state and git scope before external git state changes.
- Routine workflow stays automation-safe only while read-only.
- Codex commit and routine workflows now check review-state blockers, accepted-risk items, unverified high-risk validation, and review governance coverage before green-lighting release or routine conclusions.

## Active Constraints
- Do not commit, push, tag, or release without explicit Director approval.
- Do not let automation-safe routine inspection perform writes.

## Cycle Events
- 12: Tightened Codex commit workflow around evidence-only specialists, captain-only git/memory/release actions, and packet-triad completion.
- 11: Added team-task-package template governance, refreshed 44/61 skill-count facts, and verified Doctor/Audit green.
- 10: Updated Codex release-side workflow memory for captain minimum execution and text patch packet governance.
- 9: Updated Codex release-side workflows for the new captain dispatch gate.
- 08: Aligned Codex release-side workflows with captain-led evidence stations and mutation ownership.
- 07: Hardened Codex release-side workflow boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 06: Hardened Codex commit, routine, and skill-forge team-station reporting with applicability/execution-mode fields.
- 05: Added review-state preflight and review governance coverage to Codex commit and routine workflows.
- 04: Added MCP memory evidence contract references to Codex commit, routine, and skill-forge workflows.
- 03: Updated Codex release and skill-forge workflow boundaries for downstream project use.
- 02: Aligned release Codex workflow grounding paths to deployed .agents/shared governance references.
- 01: Split Codex release and governance workflow ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_codex_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Codex workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Codex 提交、巡檢與技能鍛造工作流。
- 提交、巡檢、交接與技能鍛造入口需保留團隊證據站點，但外部狀態仍由主線裁決。
- 提交、推送與發布仍需要明確授權。

## Tracked Files
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared.ops-skills.release-reasoning (related release and skill governance memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
