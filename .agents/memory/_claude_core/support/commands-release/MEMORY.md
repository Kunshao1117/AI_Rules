---
name: _claude_core.support.commands-release
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 紀錄、巡檢與技能鍛造指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-04T22:51:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: 2026-07-02T20:26:23.000Z
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 8
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
# _claude_core.support.commands-release — Claude Release and Governance Commands Memory

## Current Truth
- Claude commit, routine, handoff, and skill-forge commands now reference workflow-orchestration before completion or protected closeout work.
- Claude commit commands treat Director `GO` as a route or intent signal only; it becomes usable authority only after authorization resolution binds the current visible plan, station, file set, command, phase, expiry, and required protected-action gate.
- Claude commit commands route memory/git/release operations through explicit owner stations or platform-nondelegable protected-action records while requiring formal dispatch board fields and separated delivery artifact evidence before completion claims.
- Claude commit command treats review, validation, and completion as separated evidence roles; memory-docs, version-control, push, and release-completion mutations require the matching owner station or Director authorization path.
- Claude commit and release commands now inherit team-task-board references through the shared command contract while keeping git, memory, and release ownership on owner-station or protected-action authorization paths.
- Claude commit, routine, handoff, and skill-forge commands now require task type, dispatch pre-gate, Team-Native startup gate, text change delivery, and `closed-with-director-risk` before specialist work.
- Claude commit, routine, and skill-forge commands route git, memory, and release mutations to owner stations while evidence stations use role-bound team branches.
- Claude commit, routine, and skill-forge commands now load programming-team-governance with applicability/execution-mode station reporting while routing git, memory, and release mutations through owner stations or platform-nondelegable protected-action records.
- Claude commit, routine, handoff, and skill-forge commands now require evidence owner, direct exception, completion condition, and all-direct fake-team guards while routing git, memory, and release mutations through owner stations or platform-nondelegable protected-action records.
- Claude commit, routine, and skill-forge commands now use the MCP Memory Evidence Matrix for preflight, read-only routine, and skill attribution evidence.
- This child card owns Claude commit, routine, and skill-forge command entries.
- Commit commands separate changelog/source write, memory mutation, git commit, push, tag, release, deployment, and install into distinct protected phases; changelog/source write and git commit need separate scope-bound intent signals plus authorization resolution.
- Routine checks are read-only unless a later gate authorizes writes.
- Claude commit and routine commands now check review-state blockers, accepted-risk items, unverified high-risk validation, and review governance coverage before release or routine conclusions.
- Batch 4B updated 10 routine and 12 skill-forge command metadata/route summaries to the same scope-bound intent signal, authorization resolution, and protected-action semantics.
- `09_commit(紀錄)` was verified during Batch 4B only; its existing dirty diff is classified as a Batch 3B prior change, not a Batch 4B-owned repair event.

## Active Constraints
- Do not treat `GO` as blanket authorization for changelog/source write, memory mutation, git commit, push, tag, release, deployment, install, credentials, or external state.
- Do not let routine inspection mutate source or memory without a phase-specific scope-bound write gate.

## Cycle Events
- 22: Batch 4B recorded 10/12 command semantics and verified 09_commit as a Batch 3B prior change; no new Batch 4B-owned 09 repair event was added.
- 21: Recorded Batch 3b scope-bound GO semantics for Claude commit; upstream six-file Measure-GovernanceSemantics evidence reported Red 0 / Yellow 0 and was not rerun in this memory phase.
- 20: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 19: Wave 6B added workflow-orchestration grounding to Claude release/closeout commands and synced affected .claude/skills copies.
- 18-16: Added Team-Native lifecycle coverage, commit-preflight ownership, and specialist registry/artifact terminology.
- 15-12: Compressed legacy coordination wording, added formal specialist routing, release-completion owner-station gates, and protected git/memory/release handling.
- 11-08: Added team-task-board governance, Team-Native minimum execution, dispatch gate, and role-bound owner-station mutation paths.
- 07-01: Added direct-exception guards, station reporting, review governance, MCP memory evidence, downstream boundaries, grounding paths, and child-card split.

## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.
- upstream:2026-07-02 Batch 3b — Antigravity/Claude six-file governance semantics validation reported Measure-GovernanceSemantics Red 0 / Yellow 0; this memory phase did not rerun it.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Claude 紀錄、巡檢與技能鍛造指令。
- Claude commit 中的 `GO` 只是在授權解析後綁定目前可見計畫、站點、檔案、命令、階段、期限與 protected-action gate 的意圖訊號。
- changelog/source write、memory、git commit、push、tag、release、deploy、install 與 external state 不能由單一 `GO` 一次授權。
- Batch 4B 已完成 10/12 的同類授權語意修補；`09_commit(紀錄)` 本批只核對，既有 dirty diff 歸為 Batch 3B prior change。

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
