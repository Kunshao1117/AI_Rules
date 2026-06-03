---
name: _codex_core.support
description: >
  Codex Edition 補充工作流子卡。追蹤 Codex workflow support gates、chat、explore、
  experiment、test、audit、commit、routine 與 skill-forge entries。Use when: 修改 Codex
  非核心 workflow skill 或 shared gate 時。
scopePath: Codex/.agents/workflow-skills/
last_updated: '2026-06-04T03:56:49+08:00'
status: stable
staleness: 0
memory_schema_version: 2
content_language: en
human_language: zh-TW
cycle_id: 2026-06-04-001
cycle_event_count: 1
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

## Active Constraints

- Do not duplicate parent Codex platform truth here.
- Keep support workflow details concise and split if audit or commit workflows grow.
- Maintain Traditional Chinese trigger language in Director-facing workflow descriptions.

## Cycle Events

- 01: Created child ownership card for Codex support workflow skills.

## Archive Index

- None.

## 中文摘要

- 這張子卡承接 Codex 其餘 workflow skill 歸屬。
- 主卡保留 Codex 核心設定與高風險入口。
- 健檢、提交、巡檢與技能鍛造等入口都納入追蹤。

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
