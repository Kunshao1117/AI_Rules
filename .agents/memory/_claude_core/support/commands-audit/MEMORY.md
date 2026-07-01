---
name: _claude_core.support.commands-audit
scopePath: Claude/.claude/commands/08_audit(健檢)/
description: >-
  專案記憶：Claude 健檢主指令與三階段子指令。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-01T22:32:27+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-01T22:31:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 19
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: active
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
- Claude audit commands now load captain governance with task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` requirements.
- Claude audit commands load captain-led governance with role boundary, isolated change delivery semantics, and no-self-review rules for audit evidence stations.
- Claude audit entry and subcommands now load programming-team-governance and report applicability/execution-mode team-station board status for coding-related audit work.
- Claude audit entry and subcommands now require evidence owner, direct exception, completion condition, and all-direct fake-team guard reporting for team-station boards.
- Claude audit entry and subcommands inherit the MCP memory evidence contract and keep audit memory checks read-only.
- This child card owns Claude audit command entries and their three-phase subcommands.
- Audit commands use project-surface detection, evidence status, and blocked/unverified states.
- Audit commands now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Claude-specific subagent, hook, permission, and checkpoint semantics are platform translation details, not memory format differences.
- Claude audit command now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Claude audit entry and subcommands now carry review_state, review lifecycle mapping, and accepted-risk reporting through quality-review-governance.

## Active Constraints
- Do not mark missing evidence as passed.
- Do not let Claude-specific hooks or checkpoints leak into Codex or Antigravity memory semantics.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.

## Cycle Events
- 20: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 19: Wave 6B added workflow-orchestration grounding to Claude audit commands and synced affected .claude/skills copies.

- 18: Wave 6A updated Claude audit command entries with Team-Native mode, role split, board trigger, handoff packet, and specialist lifecycle rules.
- 17: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 16: Synced Claude audit commands with Team-Native specialist registry and change delivery artifact terminology.
- 15: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 14: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 13: Verified Claude audit command coverage under the new formal dispatch and wave-gated evidence checks.
- 12: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 11: Updated Claude audit command memory for captain minimum execution and text change delivery artifact governance.
- 10: Updated Claude audit commands for the new captain dispatch gate.
- 09: Aligned Claude audit commands with captain-led team board fields and role-exclusivity guards.
- 08: Hardened Claude audit boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 07: Hardened Claude audit team-station reporting with applicability/execution-mode fields and synced deployed command copies.
- 06: Added review lifecycle mapping and review_state output to Claude audit entry and subcommands.
- 05: Added change intent, patch-stack, visual detail, and real-information evidence fields to the Claude audit entry.
- 04: Added MCP memory evidence contract references to Claude audit entry and subcommands.
- 03: Updated Claude audit command output examples with deployed shared reference labels.
- 01: Split Claude audit command ownership out of the support parent card.
- 02: Updated Claude audit entry and subcommands for depth selection, inventory construction, evidence-linked coverage, and coverage reporting.

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
- 健檢指令需呈現團隊證據負責與全主線例外，不能只標示直做或委派。
- 平台能力是轉譯層，不是記憶格式差異。

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
