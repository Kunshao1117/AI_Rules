---
name: _claude_core.support.commands-release
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 紀錄、巡檢與技能鍛造指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-29T07:04:27+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T21:54:14+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 17
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
# _claude_core.support.commands-release — Claude Release and Governance Commands Memory

## Current Truth
- Claude commit commands keep memory/git/release operations Master-Agent-owned while requiring formal dispatch board fields and separated delivery artifact evidence before completion claims.
- Claude commit command treats specialists as evidence-only for review, validation, and completion delivery artifacts; memory, git, push, and release remain captain-only mutations.
- Claude commit and release commands now inherit team-task-board references through the shared command contract while keeping git, memory, and release ownership on the captain path.
- Claude commit, routine, handoff, and skill-forge commands now require task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` before specialist work.
- Claude commit, routine, and skill-forge commands keep git, memory, and release mutations on the captain while evidence stations use role-bound team branches.
- Claude commit, routine, and skill-forge commands now load programming-team-governance with applicability/execution-mode station reporting while keeping git, memory, and release mutations on the main thread.
- Claude commit, routine, handoff, and skill-forge commands now require evidence owner, direct exception, completion condition, and all-direct fake-team guards while keeping git, memory, and release mutations on the main thread.
- Claude commit, routine, and skill-forge commands now use the MCP Memory Evidence Matrix for preflight, read-only routine, and skill attribution evidence.
- This child card owns Claude commit, routine, and skill-forge command entries.
- Commit commands must respect Director gates for git and external state changes.
- Routine checks are read-only unless a later gate authorizes writes.
- Claude commit and routine commands now check review-state blockers, accepted-risk items, unverified high-risk validation, and review governance coverage before release or routine conclusions.

## Active Constraints
- Do not commit, push, tag, or release without explicit Director approval.
- Do not let routine inspection mutate source or memory without a write gate.

## Cycle Events
- 17: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 16: Synced Claude release-side commands with Team-Native specialist registry and change delivery artifact terminology.
- 15: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 14: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 13: Updated Claude release command memory for formal dispatch board fields and protected Master-Agent release gates.
- 12: Tightened Claude commit command around evidence-only specialists, captain-only git/memory/release actions, and four-delivery-artifact completion.
- 11: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 10: Updated Claude release-side command memory for captain minimum execution and text change delivery artifact governance.
- 9: Updated Claude release-side commands for the new captain dispatch gate.
- 08: Aligned Claude release-side commands with captain-led evidence stations and mutation ownership.
- 07: Hardened Claude release-side command boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 06: Hardened Claude commit, routine, and skill-forge team-station reporting with applicability/execution-mode fields.
- 05: Added review-state preflight and review governance coverage to Claude commit and routine commands.
- 04: Added MCP memory evidence contract references to Claude commit, routine, and skill-forge commands.
- 03: Updated Claude release and skill-forge command boundaries for downstream project use.
- 02: Aligned release Claude command grounding paths to deployed .agents/shared governance references.
- 01: Split Claude release and governance command ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Claude 紀錄、巡檢與技能鍛造指令。
- 提交、巡檢、交接與技能鍛造指令需保留團隊證據站點，但外部狀態仍由主線裁決。
- 提交與發布仍必須有明確授權。

## Tracked Files
- Claude/.claude/commands/09_commit(紀錄)/SKILL.md
- Claude/.claude/commands/10_routine(巡檢)/SKILL.md
- Claude/.claude/commands/12_skill_forge(技能鍛造)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared.ops-skills.release-reasoning (related release and skill governance memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
