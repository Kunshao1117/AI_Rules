---
name: _codex_core.support.workflows-general
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 一般討論、探索、實驗、濃縮與測試工作流技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-11T21:11:29+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:51:26+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-07-001
cycle_event_count: 4
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
# _codex_core.support.workflows-general — Codex General Workflow Memory

## Current Truth
- General workflow descriptions now start with Traditional Chinese semantic labels, then keep English `Use when` / `DO NOT use when` terms in parentheses for trigger precision.
- `00`, `01`, `03-1`, `05`, and `06` remain thin Codex route entries: they select a workflow row, apply the platform adapter, and never grant write, memory, git, release, deployment, install, credential, or external-state authority.
- Required References stay on-demand: captain entry loads the workflow row, route summary, evidence matrix row, workflow orchestration order, and minimum Team-Native gate; phase/station details load only when opened.
- The Workflow Entry Slimming Guard is the entry boundary: entries own route selection and minimum gates only, put durable procedure in Shared sources, verify source/deployed pairs, and read/integrate dirty diffs instead of appending duplicate rule blocks.
- `00` stays direct only for pure conversation; file, screenshot, memory, rule, tool-output, agent-behavior, source, or governance-impact questions route through read-only/authorization handling and formal evidence when Team mode is active.
- `03-1` is governed experiment work: experiment/sandbox/spike/prototype requests activate Team mode, use a reduced/minimal experiment board, record sandbox boundary, and never claim production completion or promotion without a new scoped phase.
- `05` separates source memory and project context; memory writes and `memory_commit` are separate protected phases, and context persistence needs its own authorization.
- Shared `_completion_gate.md` is a thin reference only; missing change delivery, memory/docs, validation, review, sync, authorization, or trace evidence reports blocked/unverified/risk-closed states, not complete.
- Shared `_security_footer.md` is localized with Chinese-first headings and role gates; `[SUDO]` is only an override/risk-closure request and cannot bypass role limits, Team-Native gates, validation, review, protected gates, or completion honesty.

## Active Constraints
- Treat workflow names, skill triggers, workflow buttons, approval prompts, and `GO` as route or scope-bound intent signals only.
- Do not write source or memory from read-only flows; formal-write and protected phases require resolved scope, station, file set, command, phase, expiry, and gate.
- Keep general workflow entries below thin-entry boundaries; add durable rule detail to Shared policies, Shared skills, or workflow-stage references.

## Cycle Events
- 04: Updated general workflow memory for Chinese-first descriptions, thin-entry wrapping, on-demand references, slimming guard wording, and dirty-diff integration.
- 03: Recorded `03-1` experiment semantics as governed sandbox work with reduced/minimal boards and no production completion claim.
- 02: Recorded shared completion gate as a thin reference and security footer as Chinese-localized role/protected-action gate text.
- 01: Removed stale warning text after current file content and targeted workflow diffs were reviewed.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.
- Earlier active cycle details were compacted into Current Truth on 2026-07-07 to keep this card within line limits.

## Evidence Base
- source: `Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md`, `01-explore-探索/SKILL.md`, `03-1-experiment-實驗/SKILL.md`, `05-condense-濃縮/SKILL.md`, and `06-test-測試/SKILL.md`.
- source: `Codex/.agents/workflow-skills/_shared/_completion_gate.md` and `_shared/_security_footer.md`.
- tool: targeted `git diff` and `rg` output reviewed on 2026-07-07 for description, thin-entry, dirty-diff, completion, and security footer changes.
- director: 2026-07-07 station C instruction limited memory writes to `_codex_core` cards and excluded already-committed hook behavior.

## Read Contract
- Read this card when changing owned Codex general workflow files or shared workflow gate snippets.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- superseded: stale warning blocks and older English-first workflow description facts were replaced by current dirty-source evidence.

## 中文摘要
- 一般 workflow description 已改為繁中語義先行，英文 trigger 留在括號中輔助精準匹配。
- 入口維持 thin route：只選 workflow row、平台 adapter 與最低載入，不授權寫入或 protected action。
- Slimming Guard 要求讀 dirty diff，將仍有效要求併入既有段落，避免重複 rule block。
- `03-1` 是受治理 sandbox/experiment，不等於 production complete。
- `_security_footer.md` 已中文化並保留 `[SUDO]` 不可繞過授權、Team-Native、驗證、審查與 protected gate 的規則。

## Tracked Files
- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared (shared workflow semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
