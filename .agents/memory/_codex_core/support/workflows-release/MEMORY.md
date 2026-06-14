---
name: _codex_core.support.workflows-release
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 提交、巡檢與技能鍛造工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-15T02:54:37+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:50:19+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _codex_core.support.workflows-release — Codex Release and Governance Workflow Memory

## Current Truth
- This child card owns Codex commit, routine, and skill-forge workflow skills.
- Commit workflow must verify memory state and git scope before external git state changes.
- Routine workflow stays automation-safe only while read-only.

## Active Constraints
- Do not commit, push, tag, or release without explicit Director approval.
- Do not let automation-safe routine inspection perform writes.

## Cycle Events
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
