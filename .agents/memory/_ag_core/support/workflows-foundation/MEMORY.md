---
name: _ag_core.support.workflows-foundation
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 基礎與討論建構工作流。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-04T22:51:10+08:00'
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
# _ag_core.support.workflows-foundation — Antigravity Foundation Workflow Memory

## Current Truth
- Antigravity foundation workflow entries now reference workflow-orchestration before evidence-bearing work, station work, write paths, or completion.
- Antigravity foundation workflows automatically enter Team mode for governed user requests; workflow names alone do not self-start team work without a current governed request.
- In active Antigravity Team mode, the mainline carries only the captain coordination role: coordination, dispatch, board/channel/blocker coordination, station artifact receipt, status synthesis, and Director-facing reporting; protected actions stay with owner stations or the protected-action authorization path.
- Antigravity build planning now says later execution performs authorized change application and memory filing, not unbounded physical direct writing.
- Antigravity build/fix planning and execution now require workflow-orchestration grounding, a scope-bound intent signal resolved by authorization resolution, and formal write stations before any source or generated-copy change; captain direct authoring cannot replace missing change delivery.
- Antigravity experiment and foundation workflows now explicitly load team-task-board and use template references instead of duplicating full team rules inline.
- Antigravity `03-1` is a governed workflow: requests for `03-1`, experiment, sandbox prototype, spike, or dirty-code prototype automatically activate Team mode.
- Antigravity `03-1` uses a reduced/minimal experiment station/board that records sandbox scope, allowed change scope, discard condition, promotion condition, and allowed shortcuts; sandbox writes do not equal production completion.
- Antigravity build planning and foundation coding workflows now load programming-team-governance and require applicability/execution-mode Programming Team Boards before coding-related work proceeds.
- Antigravity build, experiment, and foundation workflows now require evidence owner, direct exception, completion condition, and all-direct fake-team guards in Programming Team Boards.
- Antigravity build workflow now uses the MCP Memory Evidence Matrix for memory-state evidence and project-local migration routing.
- This child card owns Antigravity shared gates and foundation workflows for chat, exploration, build, and experiment work.
- These workflow files translate shared semantics into Antigravity-facing workflow entries.
- Antigravity 00 chat is direct only for pure conversation with no external evidence dependency; files, screenshots, memory cards, rules, agent behavior, tool output, or governance-impact questions enter Team-Native formal-readonly and require returned evidence plus captain verify-read.
- Build and experiment boundaries must remain distinct.
- Antigravity build planning now requires change intent classification, patch-stack risk, and real-information visual evidence requirements in validation plans.
- Antigravity build planning now requires the shared intent alignment gate, including blueprint adoption status, requirement-to-task trace, acceptance matrix, and drift audit rules.
- Antigravity build planning now requires quality-review-governance when review triggers apply, including review state and minimum sufficient complexity.

## Active Constraints
- Do not mix visual evidence requirements into pure discussion workflows.
- Keep shared gate fragments aligned with platform governance.

## Cycle Events
- 27: Corrected `03-1` truth: governed experiment requests auto-activate Team mode, use reduced/minimal experiment boards, and keep sandbox writes separate from production completion.
- 26: Recorded the 2026-07-03 foundation workflow authorization-semantics repair; scope-bound intent signals require authorization resolution and the affected source/deployed workflow pairs were included in the 18/18 parity verification.
- 25: Recorded Antigravity shared security footer hardening so [SUDO] records override/risk-closure only and cannot override role, Team-Native, validation/review, protected-action requirements, or complete claims.
- 24: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 23: Updated Antigravity foundation workflow memory after authorization binding hardening; scope-bound intent signals require authorization resolution, build/fix execution must route through formal write stations, and captain integration cannot substitute for missing change delivery.
- 22-20: Added workflow-orchestration grounding, formal-readonly/formal-write routing, specialist lifecycle rules, and pure-chat versus evidence-bearing chat boundaries.
- 19-16: Reconfirmed commit-preflight ownership, synced Team-Native terminology, compressed delegation wording, and added formal specialist routing with memory/review/validation artifacts.
- 15-08: Added formal dispatch fields, patch-packet completion handoff, team-task-board governance, Team-Native minimum execution, experiment governance, direct-exception guards, and station reporting.
- 03-07: Added foundation output, MCP memory evidence, change-intent/visual-evidence, intent-alignment, and review-state coverage.
## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責 Antigravity 基礎工作流與共享閘門。
- Antigravity 00 pure chat stays direct；需要檔案、截圖、記憶、規則、工具輸出或治理證據時升級 formal-readonly。
- `03-1` experiment/sandbox prototype 會啟動 reduced/minimal Team mode，且 sandbox writes 不等於 production completion。
- Team mode 主線只做協調、派工、接收、彙整與回報；protected actions 由 owner station 或 protected-action authorization path 處理。
- promotion 仍需 scope-bound authorization、formal-write、change-delivery、validation/review 與 memory/docs gates。
## Tracked Files
- Antigravity/.agents/workflows/_completion_gate.md
- Antigravity/.agents/workflows/_security_footer.md
- Antigravity/.agents/workflows/00_chat(討論).md
- Antigravity/.agents/workflows/01_explore(搜索).md
- Antigravity/.agents/workflows/03_build(建構計畫).md
- Antigravity/.agents/workflows/03-1_experiment(實驗).md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared (shared workflow semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
