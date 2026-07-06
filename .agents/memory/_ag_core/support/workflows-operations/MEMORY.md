---
name: _ag_core.support.workflows-operations
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 測試、巡檢、交接與技能鍛造工作流。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-07T05:51:07+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:51:07+08:00'
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

# _ag_core.support.workflows-operations — Antigravity Operations Workflow Memory

## Current Truth
- This child card owns Antigravity testing, routine, handoff, and skill-forge workflow entries.
- Operational workflow descriptions now start with Chinese meaning and keep English exact tokens for trigger precision.
- `06_test` covers validation and testing evidence; evidence levels do not authorize repair by themselves.
- `10_routine` remains automation-safe read-only health inspection for skills, document counts, memory staleness, and MCP settings; direct repair or file writes route back to owner workflows.
- `11_handoff` covers handoff and continuation prompts and must not be used while implementation or commit work is still active.
- `12_skill_forge` covers Shared/project/Codex skill creation and reusable-method extraction; no-write skill discussion or description-only edits use a narrower route.
- Operational entries reference workflow-orchestration before broad reads, station work, validation, review, memory/docs, completion, or any write path.
- Missing memory evidence in operational entries is expressed as 未驗證 (`unverified`) or 阻塞 (`blocked`) through the MCP Memory Evidence Matrix.
- Source writes, memory mutation, project-context mutation, git, release, deployment, install, credential, and external-state phases require authorization resolution and protected gates.
- Operational entries must not copy full Team-Native policy, board schemas, completion checklists, Director-facing language policy, or stage playbooks.
- Full team completion still requires separated change delivery, memory/docs, review, validation, and completion evidence, or an explicit accepted-risk state.

## Active Constraints
- Do not claim real behavior verification without captured operation evidence or an explicit blocked state.
- Keep handoff, routine, and skill-forge workflows from mutating source, memory, project context, git, release, deployment, install, credentials, or external state without a phase-specific scope-bound gate.

## Cycle Events
- 24: Repaired stale warning state against 2026-07-07 operations workflow dirty source for description normalization, missing memory evidence wording, read-only routine boundaries, and protected action routing.
- 23: Recorded the 2026-07-03 operations workflow authorization-semantics repair; routine stays read-only, write proposals route to owner workflows, and affected source/deployed workflow pairs were included in the 18/18 parity verification.
- 22: Recorded Batch 3b scope-bound GO semantics for Antigravity skill forge; upstream six-file Measure-GovernanceSemantics evidence reported Red 0 / Yellow 0 and was not rerun in this memory phase.
- 21: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 20: Updated Antigravity operations workflow memory after scope-bound authorization hardening; test and other evidence workflows cannot self-authorize repairs and must route source changes back to formal write/change-delivery stations.
- 19-16: Added workflow-orchestration grounding, Team-Native lifecycle coverage, commit-preflight ownership, and specialist registry/artifact terminology.
- 15-12: Compressed legacy coordination wording, added formal specialist routing and dispatch fields, and refreshed team-task-board governance.
- 11-08: Added Team-Native minimum execution, dispatch gate, role-bound evidence stations, direct-exception guards, and station reporting.
- 07-01: Added routine review coverage, test evidence details, MCP memory evidence references, output examples, grounding paths, and child-card split.

## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Antigravity/.agents/workflows/06_test(測試).md, `10_routine(巡檢).md`, `11_handoff(交接).md`, and `12_skill_forge(技能鍛造).md` — Dirty source verified on 2026-07-07.
- tool:`git diff -- Antigravity/.agents/workflows` and `rg` over operations workflow terms reviewed before writing on 2026-07-07.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.
- upstream:2026-07-02 Batch 3b — Antigravity/Claude six-file governance semantics validation reported Measure-GovernanceSemantics Red 0 / Yellow 0; this memory phase did not rerun it.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Antigravity 測試、巡檢、交接與技能鍛造入口。
- Dirty source 已把操作 workflow description 改成繁中語義先行，並保留必要英文觸發 token。
- `10_routine` 保持唯讀；需要直接修復或寫入時要轉回 owner workflow。
- `11_handoff` 不用於仍在實作或需要提交的狀態。
- `12_skill_forge` 用於實際技能鍛造與可重用方法萃取；純討論或 description-only edit 走較窄路由。
- Missing memory evidence 現在明確寫成 `unverified` 或 `blocked`；受保護動作仍需 phase-specific scope-bound gate。

## Tracked Files
- Antigravity/.agents/workflows/06_test(測試).md
- Antigravity/.agents/workflows/10_routine(巡檢).md
- Antigravity/.agents/workflows/11_handoff(交接).md
- Antigravity/.agents/workflows/12_skill_forge(技能鍛造).md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared.ops-skills.testing (related testing strategy memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
