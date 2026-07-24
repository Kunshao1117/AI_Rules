---
name: _ag_core.support.workflows-foundation
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 基礎與討論建構工作流。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-24T13:40:00+08:00'
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

# _ag_core.support.workflows-foundation — Antigravity Foundation Workflow Memory

## Current Truth
- This child card owns Antigravity shared gates and foundation workflows for chat, exploration, build, and experiment work.
- Foundation workflow descriptions now start with Chinese meaning and keep English exact tokens for trigger precision.
- `00_chat` stays direct only for pure conversation without external evidence; files, screenshots, memory/context cards, rules, policies, agent behavior, source/tool output, or governance-impact questions route to Team-Native formal-readonly.
- `01_explore` defines research questions, gathers evidence, challenges assumptions, and then routes to architecture, experiment, build, or audit.
- `03_build` covers governed build implementation and design-to-build contracts; `03-1` covers governed disposable sandbox experiments with reduced/minimal experiment boards.
- `03-1` sandbox writes must record sandbox scope, discard condition, promotion condition, and allowed shortcuts; discard, promotion, and production promotion still require scope-bound authorization.
- Foundation entries reference workflow-orchestration before broad reads, station work, validation, review, memory/docs, write paths, completion, or source/deployed parity claims.
- Missing memory evidence in foundation entries is expressed as 未驗證 (`unverified`) or 阻塞 (`blocked`) through the MCP Memory Evidence Matrix.
- `_completion_gate.md` is a thin shared completion reference; missing change delivery, memory/docs, validation, review, sync, authorization, or trace evidence is not `complete`.
- `_security_footer.md` keeps `[SUDO]` as override/risk-closure request only and preserves role, scoped authorization, Team-Native, validation, review, protected gates, and completion boundaries.
- Foundation workflow entries must not copy full Team-Native policy, board schemas, completion checklists, Director-facing language policy, or stage playbooks.

## Active Constraints
- Do not mix visual evidence requirements into pure discussion workflows.
- Keep shared gate fragments aligned with platform governance.
- Keep workflow descriptions meaning-first and concise; durable governance remains in shared policies, shared skills, and workflow-stage procedures.

## Cycle Events
- 28: Repaired stale warning state against 2026-07-07 foundation workflow dirty source for description normalization, missing memory evidence wording, shared completion gate, and shared security/[SUDO] boundaries.
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
- source:Antigravity/.agents/workflows/00_chat(討論).md, `01_explore(搜索).md`, `03_build(建構計畫).md`, `03-1_experiment(實驗).md`, `_completion_gate.md`, and `_security_footer.md` — Dirty source verified on 2026-07-07.
- tool:`git diff -- Antigravity/.agents/workflows` and `rg` over workflow description/memory/completion/security terms reviewed before writing on 2026-07-07.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責 Antigravity 基礎工作流與共享閘門。
- Dirty source 已把基礎 workflow description 改成繁中語義先行，並保留必要英文觸發 token。
- `00_chat` 僅限無外部證據依賴的純對話；涉及檔案、記憶、規則、工具輸出或治理影響時升級 formal-readonly。
- `03-1` 仍是受治理沙盒實驗；sandbox writes 不等於 production completion，promotion 仍需 scope-bound authorization。
- Missing memory evidence 現在明確寫成 `unverified` 或 `blocked`。
- `_completion_gate` 與 `_security_footer` 保持 thin reference，`[SUDO]` 不跳過 role、authorization、Team-Native、validation、review 或 protected gates。
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
