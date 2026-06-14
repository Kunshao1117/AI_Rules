# Migration Archive - _codex_core/support

- Created: 2026-06-15T02:21:28+08:00
- Reason: Preserve pre-standardization active memory content before MEMORY.md quality migration.
- Scope: Active main card content only; existing archive volumes were not rewritten.

--- preserved active card ---

---
name: _codex_core.support
description: >
  Codex Edition 補充工作流子卡。追蹤 Codex workflow support gates、chat、explore、
  experiment、test、audit、commit、routine 與 skill-forge entries。Use when: 修改 Codex
  非核心 workflow skill 或 shared gate 時。
scopePath: Codex/.agents/workflow-skills/
last_updated: '2026-06-14T16:01:44+08:00'
status: stale
staleness: 20
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
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

# _codex_core.support — Codex Support Memory

## Current Truth

- This child card owns Codex workflow skills outside the parent core set.
- Codex workflow support gates remain shared fragments and must stay aligned with platform governance.
- Audit subskills and automation-safe routine behavior must remain covered by memory ownership.
- The parent card keeps Codex core identity, install, config, and the highest-risk workflow entries.
- Codex test workflow now selects evidence by interface surface, including browser, desktop GUI, plugin panel, terminal, and mixed surfaces.
- Codex test workflow now records evidence level as minimum, enhanced, or exemption and keeps evidence matched to the selected surface.
- Codex test and audit support workflows now treat missing real execution evidence as failed or blocked validation for behavior-dependent work.
- Codex test and audit support workflows now require operator-tool discovery, retry/readiness checks, and equivalent real-path alternatives before marking real verification blocked.
- Codex audit workflows now use full-spectrum project-surface profiling, capability snapshots, evidence packets, traffic-light gates, and log-only intermediate evidence.
- Codex support workflow skills now carry the workflow grounding contract for chat, explore, experiment, condense, test, commit, routine, and skill-forge entries.

## Active Constraints

- Do not duplicate parent Codex platform truth here.
- Keep support workflow details concise and split if audit or commit workflows grow.
- Maintain Traditional Chinese trigger language in Director-facing workflow descriptions.

## Cycle Events

- 01: Created child ownership card for Codex support workflow skills.
- 02: Updated Codex test workflow for interface adaptation evidence.
- 03: Added evidence-level handling to the Codex test workflow.
- 04: Added real execution evidence and audit gap handling to Codex support workflows.
- 05: Added operator-tool discovery, retry, and equivalent fallback requirements to Codex test and audit support workflows.
- 06: Refactored Codex audit entry and three audit phases into the full-spectrum evidence workflow with Codex skill/subagent/sandbox adapter rules.
- 07: Added shared workflow grounding matrix references to Codex support workflow skills and synced the live skill copies.

## Archive Index

- None.

## 中文摘要

- 這張子卡承接 Codex 其餘 workflow skill 歸屬。
- 主卡保留 Codex 核心設定與高風險入口。
- 健檢、提交、巡檢與技能鍛造等入口都納入追蹤。
- 測試入口依治理深度選擇證據等級。
- 測試與健檢入口已納入真實執行證據缺口。
- 測試與健檢會追查缺少工具搜尋、重試或等價路徑的驗證聲稱。
- 健檢入口與三階段已改為證據包、燈號、未驗證/阻塞與只寫日誌的流程。
- 支援工作流已補外部依據、最低證據狀態、平台採證差異與下一流程路由，live 技能已同步。

## Tracked Files

- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Relations

- _codex_core (parent Codex core memory)
- _shared (shared operational skills)
- _system (root Codex governance bridge)

## Applicable Skills

- memory-ops — Use when updating this child card.
- impact-test-strategy — Use when workflow edits affect multiple Codex entrypoints.
- memory-arch — Use when this child needs deeper splits.
