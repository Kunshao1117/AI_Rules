---
name: _claude_core.support.commands-audit
scopePath: Claude/.claude/commands/08_audit(健檢)/
description: >-
  專案記憶：Claude 健檢主指令與三階段子指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-04T22:51:20+08:00'
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
cycle_event_count: 7
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
# _claude_core.support.commands-audit — Claude Audit Commands Memory

## Current Truth
- Claude audit command entries and subcommands now reference workflow-orchestration as the shared board/wave/artifact sequence contract.
- Claude audit commands are covered by entrypoint checks for draft/formal board lifecycle, wave-gated evidence, and no post-board all-at-once launch semantics.
- Claude audit commands now inherit team-task-board references through the shared command contract and keep review/validation delivery artifacts role-bound.
- Claude audit commands now load Team-Native governance with task type, dispatch pre-gate, station-owned execution gates, text change delivery, Director authorization path, and `closed-with-director-risk` requirements.
- Claude audit commands load station-owned Team-Native governance with role boundary, isolated change delivery semantics, owner-station evidence, and no-self-review rules for audit evidence stations.
- Claude audit entry and subcommands now load programming-team-governance and report applicability/execution-mode team-station board status for coding-related audit work.
- Claude audit entry and subcommands now require evidence owner, direct exception, completion condition, and all-direct fake-team guard reporting for team-station boards.
- Claude audit entry and subcommands inherit the MCP memory evidence contract and keep audit memory checks read-only.
- This child card owns Claude audit command entries and their three-phase subcommands.
- Audit commands use project-surface detection, evidence status, and blocked/unverified states.
- Audit commands now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Claude-specific subagent, hook, permission, and checkpoint semantics are platform translation details, not memory format differences.
- Claude audit command now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Claude audit entry and subcommands now carry review_state, review lifecycle mapping, and accepted-risk reporting through quality-review-governance.
- Batch 4B updated 08 audit main command and 08-1/08-2/08-3 subcommands to the same scope-bound intent signal, authorization resolution, and protected-action write semantics.
- Claude audit remains evidence and reporting oriented: it does not directly repair source; any write or memory mutation must route through a separately protected phase.

## Active Constraints
- Do not mark missing evidence as passed.
- Do not let Claude-specific hooks or checkpoints leak into Codex or Antigravity memory semantics.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.

## Cycle Events
- 21: Batch 4B recorded audit command semantics for 08 and 08-1/08-2/08-3; audit remains non-repair and writes require a later protected phase.
- 20: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 19: Wave 6B added workflow-orchestration grounding to Claude audit commands and synced affected .claude/skills copies.
- 18-16: Added Team-Native lifecycle coverage, commit-preflight ownership, and specialist registry/artifact terminology.
- 15-12: Compressed Team-Native delegation wording, added formal specialist routing, verified audit coverage, and refreshed team-task-board governance.
- 11-08: Added station-owned execution gates, dispatch gate, role-exclusivity, direct-exception guards, and station reporting.
- 07-01: Added review lifecycle, change intent, MCP memory evidence, output examples, ownership split, depth selection, inventory, and coverage reporting.

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
- 此子卡負責 Claude 健檢主指令與三階段子指令。
- 健檢指令需呈現具名 owner station、review/validation station 與 Director authorization path，不能只標示直做或委派。
- 平台能力是轉譯層，不是記憶格式差異。
- Batch 4B 已完成 08 audit 主命令與 08-1/08-2/08-3 子命令的同類授權語意修補；健檢仍不直接修復，寫入需另走受保護階段。

## Tracked Files
- Claude/.claude/commands/08_audit(健檢)/08-1_infra/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-2_logic/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/08-3_report/SKILL.md
- Claude/.claude/commands/08_audit(健檢)/SKILL.md

## Relations
- _claude_core.support (parent card: Claude support index)
- _shared (shared audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Claude support topology.
- impact-test-strategy — Use when command edits affect multiple entrypoints.
