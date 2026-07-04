---
name: _claude_core.support.commands-general
scopePath: Claude/.claude/commands/
description: >-
  專案記憶：Claude 一般討論、探索、實驗、濃縮與測試指令。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-04T22:51:23+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: 2026-07-03T10:59:34.000Z
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
# _claude_core.support.commands-general — Claude General Commands Memory
## Current Truth
- Claude general command entries now reference workflow-orchestration before evidence-bearing work, station work, write paths, or completion.
- Claude general commands automatically enter Team mode for governed user requests; command names alone do not self-start team work without a current governed request.
- In active Claude Team mode, the mainline carries only the captain coordination role: coordination, dispatch, board/channel/blocker coordination, station artifact receipt, status synthesis, and Director-facing reporting; protected actions stay with owner stations, platform-nondelegable protected-action records, or memory-docs/release-completion stations.
- Claude experiment and general commands now explicitly load team-task-board and use template references instead of duplicating full team rules inline.
- Claude `03-1` is a governed workflow: requests for `03-1`, experiment, sandbox prototype, spike, or dirty-code prototype automatically activate Team mode.
- Claude `03-1` uses a reduced/minimal experiment station/board that records sandbox scope, allowed change scope, discard condition, promotion condition, and allowed shortcuts; sandbox writes do not equal production completion.
- Claude experiment and test commands now load programming-team-governance and require applicability/execution-mode Programming Team Boards for coding-related validation and completion stations.
- Claude experiment and test commands now require evidence owner, direct exception, completion condition, and all-direct fake-team guards in Programming Team Boards.
- Claude condense command now uses the MCP memory evidence contract to separate source memory from project context evidence.
- This child card owns Claude shared command gates and general command entries.
- General commands must stay aligned with shared workflow semantics and Claude permission behavior.
- Claude 00 chat is direct only for pure conversation with no external evidence dependency; Team mode starts from a current governed request or dispatch request, not from command names alone.
- Claude command names and natural-language approvals are route intent plus scope-bound evidence only; write authority requires the matching formal write station, with authorization resolution binding the visible scope and protected phase.
- Claude experiment command wording now describes sandbox direct execution as an isolated experiment lane, not captain mainline substitute authoring or a routine direct route for production work.
- Test commands must select evidence by interface surface rather than assuming browser-only proof.
- Claude test command now requires visual detail-observation notes and real-information-first evidence before fallback fake data.
- Batch 4B updated 00/01/03-1/05/06 formal-write semantics so writes require authorization resolution bound to the visible plan, file set, owner station, command, phase, expiry, and required protected-action path.
## Active Constraints
- Do not transfer main-agent responsibility to subagents.
- Do not write source or memory from read-only command flows without the appropriate gate.
## Cycle Events
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
- `03-1` 是受治理 workflow；使用者要求 experiment/sandbox prototype 會自動啟動 Team mode 並使用 reduced/minimal experiment station/board，且不作 production completion claim。
- Team mode 主線只做 coordination、dispatch、board/channel/blocker coordination、station artifact receipt、status synthesis 與 Director-facing reporting；protected actions 另走 owner station 或 protected-action path。
- 測試指令要依介面型態選擇證據；Batch 4B 已把 00/01/03-1/05/06 formal-write 語意收斂為先經授權解析。

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
