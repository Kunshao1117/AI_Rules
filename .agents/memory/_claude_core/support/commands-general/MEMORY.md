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
verification_status: verified
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
- This child card owns Claude shared command gates and general command entries.
- General command descriptions are normalized for Chinese meaning-first trigger text while preserving exact `Use when` and `DO NOT use when` tokens for routing.
- Missing memory evidence and result evidence now use canonical English states: `sufficient`, `partial`, `unverified`, `blocked`, and `not-applicable`.
- Workflow entries keep `Workflow Entry Slimming Guard`, `Phase Order`, and `Completion Boundary` as slim references to shared governance instead of embedded playbooks.
- Claude `03-1` remains a governed experiment route: sandbox requests activate Team mode, use reduced/minimal experiment station or board, and cannot claim production completion without promotion authorization.
- `03-1` currently uses YAML block-list `required_skills`; `05_condense` and `06_test` still show inline lists in current dirty source, so check source before making group-wide YAML-list claims.
- Shared completion and security snippets were slimmed and normalized with explicit code fences, `->` arrows, and Director-readable Chinese-first labels.
- Claude 00 chat is direct only for pure conversation with no external evidence dependency; Team mode starts from a current governed request or dispatch request, not from command names alone.
- Claude command names and natural-language approvals are route intent plus scope-bound evidence only; write authority requires the matching formal write station, with authorization resolution binding the visible scope and protected phase.
- Test commands must select evidence by interface surface rather than assuming browser-only proof.
## Active Constraints
- Do not transfer main-agent responsibility to subagents.
- Do not write source or memory from read-only command flows without the appropriate gate.
- Do not present the entire general command set as YAML-list converted until `05_condense` and `06_test` are converted or explicitly exempted.
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
- source:.agents/memory/_claude_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Claude/.claude/commands/00_chat(討論)/SKILL.md, 01_explore(搜索), 03-1_experiment(實驗), 05_condense（濃縮）, 06_test(測試), and `_shared` snippets.
- tool:`git diff -- Claude/.claude/commands/...` and `rg` reviewed descriptions, evidence states, headings, and `required_skills` shapes on 2026-07-07.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Claude support files.
- Read `_claude_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責 Claude 一般指令與共用閘門。
- 目前 dirty source 已把一般指令 description 改成中文語義先行，並把證據狀態改成 canonical English。
- `03-1` 已用 YAML block-list `required_skills`；`05`、`06` 仍需看 source，不能概括為全組已轉。
- 共用 completion/security snippet 已瘦身並正規化 heading、fence、arrow 與中文標籤。
- `03-1` 仍是受治理實驗路由，不等於 production complete。

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
