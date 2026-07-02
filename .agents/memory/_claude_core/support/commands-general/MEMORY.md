---
name: _claude_core.support.commands-general
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 一般討論、探索、實驗、濃縮與測試指令。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-02T14:01:04+08:00'
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
cycle_event_count: 22
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
# _claude_core.support.commands-general — Claude General Commands Memory

## Current Truth
- Claude general command entries now reference workflow-orchestration before evidence-bearing work, station work, write paths, or completion.
- Claude general and experiment commands now record draft/formal board semantics, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, and no post-board all-at-once launch.
- Claude experiment and general commands now explicitly load team-task-board and use template references instead of duplicating full team rules inline.
- Claude chat, explore, experiment, condense, and test commands now route coding intent through task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` rules.
- Claude chat and explore now route coding intent into captain-led mode, and experiment uses a minimum Captain Team Board with role boundary and isolated change delivery conditions.
- Claude experiment and test commands now load programming-team-governance and require applicability/execution-mode Programming Team Boards for coding-related validation and completion stations.
- Claude experiment and test commands now require evidence owner, direct exception, completion condition, and all-direct fake-team guards in Programming Team Boards.
- Claude condense command now uses the MCP memory evidence contract to separate source memory from project context evidence.
- This child card owns Claude shared command gates and general command entries.
- General commands must stay aligned with shared workflow semantics and Claude permission behavior.
- Claude 00 chat is direct only for pure conversation with no external evidence dependency; files, screenshots, memory cards, rules, agent behavior, tool output, or governance-impact questions enter Team-Native formal-readonly and require returned evidence plus captain verify-read.
- Claude command names and natural-language approvals are route intent plus scope-bound evidence only; write authority requires the matching formal write station and GO-backed scope.
- Claude experiment command wording now describes sandbox direct execution as an isolated experiment lane, not captain mainline substitute authoring or a routine direct route for production work.
- Test commands must select evidence by interface surface rather than assuming browser-only proof.
- Claude test command now requires visual detail-observation notes and real-information-first evidence before fallback fake data.

## Active Constraints
- Do not transfer main-agent responsibility to subagents.
- Do not write source or memory from read-only command flows without the appropriate gate.

## Cycle Events
- 23: Recorded Claude command security footer hardening so [SUDO] cannot bypass role limits, scoped authorization, Team-Native, validation, review, protected gates, or complete claims.
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21: Updated Claude experiment command wording so sandbox direct execution is explicitly an experiment lane, not captain mainline substitute authoring.
- 20: Updated Claude general command memory after scope-bound authorization hardening; command names and casual approval language no longer imply blanket write authority, and read-only/test flows must route fixes to formal write stations.
- 19: Wave 6B added workflow-orchestration grounding to Claude general commands and synced affected .claude/skills copies.
- 18: Wave 6A updated Claude chat, explore, blueprint, experiment, condense, test, and debug command entries with daily/full mode boundaries, pure-conversation/direct limits, formal-readonly/formal-write routing, and specialist lifecycle rules.
- 17: Rebuilt the Claude 00 chat command boundary so pure chat stays direct, while evidence-bearing discussion promotes to Team-Native formal-readonly with read scope, evidence status, and captain verify-read before the final answer.
- 16: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 15: Synced Claude general commands with Team-Native specialist registry and change delivery artifact terminology.
- 14: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 13: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 12: Updated Claude general/experiment commands for minimum formal dispatch fields and verified entrypoint coverage.
- 11: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 10: Added Claude condense team-board coverage and updated general command memory for captain minimum execution and text change delivery artifacts.
- 9: Updated Claude general commands for the new captain dispatch gate.
- 08: Upgraded Claude 00/01/03-1 general commands for automatic captain trigger and experiment minimum governance.
- 07: Hardened Claude experiment and test command boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 06: Added applicability/execution-mode Programming Team Board reporting to Claude experiment and test commands and synced deployed command copies.
- 05: Added detail observation and real-information priority to the Claude test command evidence branch.
- 04: Added MCP memory evidence contract reference to the Claude condense command.
- 03: Updated Claude general command output examples with source-only labels.
- 02: Aligned general Claude command grounding paths to deployed .agents/shared governance references.
- 01: Split Claude general command ownership out of the support parent card.

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
- 此子卡負責 Claude 一般指令與共用閘門。
- Claude 00 指令現在只讓純聊天直接回覆；需要檔案、截圖、記憶、規則、工具輸出或治理證據時要升級 formal-readonly。
- 實驗與測試指令需宣告最小團隊站點與主線直做例外。
- 測試指令要依介面型態選擇證據。

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
