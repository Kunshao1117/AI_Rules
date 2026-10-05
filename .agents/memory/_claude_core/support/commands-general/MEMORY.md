---
name: _claude_core.support.commands-general
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 一般討論、探索、實驗、濃縮與測試指令。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-24T13:40:01+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
last_verified: '2026-07-24T13:40:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 10
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

# _claude_core.support.commands-general — Claude General Commands Memory
## Current Truth

- This child card owns Claude general command entries and their shared command snippets.
- Workflow names select phase sequence and do not grant authority. Execution Routing selects Direct, Assisted or Team; a helper alone does not require Team.
- Claude 03-1 is an experiment workflow, not a Team trigger. Sandbox scope, discard and promotion conditions remain required; experiment output is not production completion.
- Claude 00 permits bounded conversation and observe evidence gathering; tools or files alone do not mandate Team.
- Necessary bounded source work inside the current user-authorized concrete scope is local_work, subject to exclusions and protected effects. Explicit local Git and protected follow-ups retain their own scope; formal-write stations are frozen compatibility only.
- Required-skills metadata is entry-specific: 00 has an empty list, 03-1 has an empty block value, and 05/06 have inline method lists. Do not infer a command-wide conversion or load legacy Memory artifacts for ordinary work.
- Test commands select evidence by the actual interface surface, using current Verification, Review and Completion policies.

## Active Constraints

- Main remains accountable for the result and required evidence.
- Do not treat a workflow invocation as unrestricted source, Memory, Context, Git or external authority.
- Inspect each command's current metadata; historical syntax is not a current load contract.

## Cycle Events
- 26: Refreshed current dirty source: general command descriptions, canonical evidence states, slim entry headings, shared snippet formatting, and partial YAML-list conversion status.
- 25: Corrected Claude `03-1` truth: governed experiment requests auto-activate Team mode, use reduced/minimal experiment boards, and keep sandbox writes separate from production completion.
- 24: Batch 4B recorded general command formal-write semantics for 00/01/03-1/05/06: scope-bound intent signal, authorization resolution, and owner-station protected-action path now precede write authority.
- 23: Recorded Claude command security footer hardening so [SUDO] cannot bypass role limits, scoped authorization, Team-Native, validation, review, protected-action requirements, or complete claims.
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21-19: Clarified sandbox direct execution as isolated experiment work, hardened scope-bound authorization, and added workflow-orchestration grounding.
- 18-15: Added Team-Native lifecycle coverage, pure-chat boundaries, commit-preflight ownership, and specialist registry/artifact terminology.
- 14-10: Compressed delegation wording, added formal specialist routing, dispatch fields, team-task-board governance, condense board coverage, and station-owned/text delivery terminology.
- 09-06: Added dispatch gate, experiment governance, direct-exception guards, and Programming Team Board reporting.
- 05-01: Added test evidence details, MCP memory evidence, output examples, grounding paths, and child-card split.
## Archive Index
- Parent archive remains at .agents/memory/_claude_core/support/archive-001.md.
## Evidence Base

- Source-only comparison: `Claude/.claude/commands/00_chat(討論)/SKILL.md`, `Claude/.claude/commands/03-1_experiment(實驗)/SKILL.md`, `Claude/.claude/commands/05_condense（濃縮）/SKILL.md`, `Claude/.claude/commands/06_test(測試)/SKILL.md`, `Shared/policies/authorization-resolution.md`, `Shared/policies/execution-routing.md`.
- Earlier entries below are historical evidence; preserved timestamps do not certify current runtime or index state.
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Claude/.claude/commands/00_chat(討論)/SKILL.md, 01_explore(搜索), 03-1_experiment(實驗), 05_condense（濃縮）, 06_test(測試), and `_shared` snippets.
- tool:`git diff -- Claude/.claude/commands/...` and `rg` reviewed descriptions, evidence states, headings, and `required_skills` shapes on 2026-07-07.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession

- Experiment-auto-Team, evidence-use-auto-Team, universal formal-write station and obsolete required-skills conversion statements are superseded.
- Original card and prior claims remain in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/b61b27c2d0a6d65d08ded101d323d62cf06d2098/.agents/memory/_claude_core/support/commands-general/MEMORY.md); existing Cycle Events and archives are preserved.
- Current review is bounded to the cited source semantics and tracking; provider/index/runtime synchronization and unreviewed historical assertions remain unverified.

## 中文摘要

- 此卡負責 Claude 一般命令與共用片段
- 實驗名稱不強制 Team；sandbox、discard 與 promotion 範圍仍須明確
- 一般工作依當前具體授權；Git 與受保護動作另有邊界
- required_skills 必須逐入口確認，不宣稱已全數轉換

## Tracked Files
- Claude/.claude/commands/_shared/_completion_gate.md
- Claude/.claude/commands/_shared/_security_footer.md
- Claude/.claude/commands/00_chat(討論)/SKILL.md
- Claude/.claude/commands/01_explore(搜索)/SKILL.md
- Claude/.claude/commands/03-1_experiment(實驗)/SKILL.md
- Claude/.claude/commands/05_condense（濃縮）/SKILL.md
- Claude/.claude/commands/06_test(測試)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared (shared workflow semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
