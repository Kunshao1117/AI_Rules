---
name: _ag_core.support
description: >
  Antigravity 補充規則與工作流子卡。追蹤 Antigravity 平台其餘 rules、workflow helper、
  audit、commit、routine、handoff 與 project support files。Use when: 修改 Antigravity
  輔助規則或非核心工作流入口時。
scopePath: Antigravity/.agents/
last_updated: '2026-06-14T16:01:25+08:00'
status: stable
staleness: 0
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
# _ag_core.support — Antigravity Support Memory

## Current Truth

- This child card owns Antigravity support rules and workflow entries not kept in the parent core card.
- The parent card keeps platform-wide current truth; this card keeps file ownership and local constraints.
- Antigravity workflow helpers remain governed by the same planning, completion, memory, and security gates.
- Changes here usually require checking shared policy drift and deployment injection behavior.
- Antigravity build and test support workflows now use design-to-build contracts and interface-surface evidence.
- Antigravity build and test support workflows now output governance depth summaries and evidence levels without duplicating the shared matrix.
- Antigravity support workflows now require [REAL EXECUTION] planning and fail or block missing real evidence for behavior-dependent work.
- Antigravity support workflows now require operator-tool search, transient retry, and equivalent real-path alternatives before accepting a blocked real verification result.
- Antigravity audit workflows now use full-spectrum project-surface profiling, capability snapshots, evidence packets, traffic-light gates, and log-only intermediate evidence.
- Antigravity support workflows now carry the workflow grounding contract for chat, explore, build plan, experiment, test, commit, routine, handoff, and skill-forge entries.

## Active Constraints

- Do not duplicate parent-level Antigravity decisions here.
- Keep support workflow history out of the main card; archive or compact if this card grows.
- If a support workflow becomes heavily edited, split it into a deeper child card.

## Cycle Events

- 01: Created child ownership card for Antigravity support rules and remaining workflows.
- 02: Updated Antigravity build and test support workflows for the governance flow redesign.
- 03: Added governance depth summary and evidence-level handling to Antigravity support workflows.
- 04: Added real execution planning, test, and audit gap handling to Antigravity support workflows.
- 05: Added operator-path discovery, retry, and equivalent fallback requirements to Antigravity build, fix, test, and audit workflows.
- 06: Refactored Antigravity audit entry and three audit phases into the full-spectrum evidence workflow with visual/browser adapter rules.
- 07: Added shared workflow grounding matrix references to Antigravity support workflow entries and kept them before workflow execution bodies.

## Archive Index

- None.

## 中文摘要

- 這張子卡承接 Antigravity 補充規則與其餘工作流歸屬。
- 主卡保留平台核心事實；子卡只處理支援範圍。
- 後續若單一工作流變大，再拆更深子卡。
- 建構與測試入口只輸出分級摘要，不重貼共用矩陣。
- 支援工作流已補真實驗證路徑與缺證據失敗判定。
- 支援工作流已要求阻塞前先搜尋操作者工具、重試或評估等價路徑。
- 健檢入口與三階段已改為證據包、燈號、未驗證/阻塞與只寫日誌的流程。
- 支援工作流已補外部依據、最低證據狀態、平台採證差異與下一流程路由。

## Tracked Files

- Antigravity/.agents/rules/01_cross_lingual_guard.md
- Antigravity/.agents/rules/02_code_quality_security.md
- Antigravity/.agents/rules/05_project_skill_contract.md
- Antigravity/.agents/rules/06_memory_push.md
- Antigravity/.agents/rules/AGENTS.md
- Antigravity/.agents/VERSION
- Antigravity/.agents/workflows/_completion_gate.md
- Antigravity/.agents/workflows/_security_footer.md
- Antigravity/.agents/workflows/00_chat(討論).md
- Antigravity/.agents/workflows/01_explore(搜索).md
- Antigravity/.agents/workflows/03_build(建構計畫).md
- Antigravity/.agents/workflows/03-1_experiment(實驗).md
- Antigravity/.agents/workflows/06_test(測試).md
- Antigravity/.agents/workflows/08_audit(健檢).md
- Antigravity/.agents/workflows/08-1_audit_infra(基礎盤點).md
- Antigravity/.agents/workflows/08-2_audit_logic(深度邏輯).md
- Antigravity/.agents/workflows/08-3_audit_report(健檢總結).md
- Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md
- Antigravity/.agents/workflows/09-2_commit_execute(授權備份).md
- Antigravity/.agents/workflows/10_routine(巡檢).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md
- Antigravity/.gitignore
- Antigravity/.vscode/settings.json

## Relations

- _ag_core (parent Antigravity core memory)
- _shared (shared policy and skill source)
- _system (root deployment and governance memory)

## Applicable Skills

- memory-ops — Use when updating this child card.
- impact-test-strategy — Use when support workflow edits affect multiple entrypoints.
- memory-arch — Use when this child needs deeper splits.
