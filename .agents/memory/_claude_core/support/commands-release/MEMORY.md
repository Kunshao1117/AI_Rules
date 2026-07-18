---
name: _claude_core.support.commands-release
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 紀錄、巡檢與技能鍛造指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-18T12:00:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:51:27+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 9
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
- Claude commit, routine, and skill-forge commands now reference workflow-orchestration before completion or protected closeout work.
- Release command descriptions are normalized for Chinese meaning-first route text while preserving exact `Use when` and `DO NOT use when` tokens.
- `09_commit`, `10_routine`, and `12_skill_forge` now use YAML block-list `required_skills` in current dirty source.
- Missing memory evidence and result evidence now use canonical English states: `sufficient`, `partial`, `unverified`, `blocked`, and `not-applicable`.
- Workflow entries keep `Workflow Entry Slimming Guard`, `Phase Order`, and `Completion Boundary` as slim references to shared governance.
- Claude commit commands treat Director `GO` as a route or intent signal only; it becomes usable authority only after authorization resolution binds the current visible plan, station, file set, command, phase, expiry, and required protected-action gate.
- Claude commit commands route memory/git/release operations through explicit owner stations or platform-nondelegable protected-action records while requiring formal dispatch board fields and separated delivery artifact evidence before completion claims.
- Claude commit command treats review, validation, and completion as separated evidence roles; memory-docs, version-control, push, and release-completion mutations require the matching owner station or Director authorization path.
- Claude commit, routine, and skill-forge commands now use the MCP Memory Evidence Matrix for preflight, read-only routine, and skill attribution evidence.
- This child card owns Claude commit, routine, and skill-forge command entries.
- Commit commands separate changelog/source write, memory mutation, git commit, push, tag, release, deployment, and install into distinct protected phases; changelog/source write and git commit need separate scope-bound intent signals plus authorization resolution.
- `10_routine` and Manager Check are Git-only: report worktree, HEAD, tracking branch, and origin sync/ahead/behind/diverged/unconfirmable state; no MCP, memory, source, health, review, or validation inspection occurs.

## Active Constraints
- Do not treat `GO` as blanket authorization for changelog/source write, memory mutation, git commit, push, tag, release, deployment, install, credentials, or external state.
- Do not widen routine beyond its Git-only report.
- Keep git, memory, release, deployment, install, credential, and external-state mutations in separated protected phases.

## Cycle Events
- 23: Refreshed current dirty source: release command descriptions, canonical evidence states, YAML block-list `required_skills`, slim entry headings, and separated protected closeout phases.
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
- source:Claude/.claude/commands/09_commit(紀錄)/SKILL.md, 10_routine(巡檢)/SKILL.md, and 12_skill_forge(技能鍛造)/SKILL.md.
- tool:`git diff -- Claude/.claude/commands/...` and `rg` reviewed release command descriptions, evidence states, headings, and `required_skills` shapes on 2026-07-07.
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
- 目前 dirty source 已把 09/10/12 descriptions 改成中文語義先行，並把 `required_skills` 改為 YAML block list。
- 證據狀態使用 canonical English；缺少記憶證據是 `unverified` 或 `blocked`。
- `GO` 仍只是授權解析後的 scope-bound intent signal，不是 changelog/source、memory、git、release、deploy、install 或 external state 的一次性授權。
- `10_routine` 與 Manager Check 僅回報 Git 工作樹、HEAD、追蹤分支與 origin 同步狀態。

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
