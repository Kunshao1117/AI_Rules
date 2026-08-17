---
name: _cursor_core.support.workflows-release
scopePath: Cursor/.agents/workflow-skills/
description: >
  專案記憶：Cursor 提交、巡檢、技能鍛造與共用閘門。Use when: task touches commit, routine,
  skill-forge, or shared workflow gates.
last_updated: '2026-08-17T20:56:15+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
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

# _cursor_core.support.workflows-release — Module Memory

## Current Truth

- Owns Cursor commit, routine, and skill-forge workflow skills, plus shared completion and security gates.
- Shared gates are support files, not public workflow entries.

## Active Constraints

- Keep `platforms: ["cursor"]` on workflow skills. Shared gates do not grant protected authority.

## Cycle Events

- 01: Created during the Cursor workflow split.

## Archive Index

- None yet.

## Evidence Base

- source:Cursor/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md, Cursor/.agents/workflow-skills/_shared/_completion_gate.md

## Read Contract

- Read when changing owned Cursor release workflows or shared gates.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Cursor 提交、巡檢、技能鍛造與共用閘門。
- 共用閘門不是公開工作流入口。

## Tracked Files

- Cursor/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Cursor/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Cursor/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md
- Cursor/.agents/workflow-skills/_shared/_completion_gate.md
- Cursor/.agents/workflow-skills/_shared/_security_footer.md

## Relations

- _cursor_core.support (parent card: navigation only)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
