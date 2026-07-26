---
name: _codex_core.support.workflows-general
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 一般工作流技能。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-27T00:02:49+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-26T16:36:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-07-001
cycle_event_count: 5
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

- Owns the listed Codex general workflow skill entries and shared workflow gates.
- `06 Verify` is a thin verification route; it can collect Direct evidence without a Team board, station, handoff, formal trace, or independent reviewer.
- Delegated artifacts load only when `execution-routing` resolves delegated topology.
- Workflow routes never grant source-write, memory, Git, release, deployment, install, credential, or external-state authority.

## Active Constraints

- Keep entries thin and load detailed policy or procedure only when needed.
- Preserve exact workflow identifiers while keeping Director-facing wording meaning-first zh-TW.

## Cycle Events

- 05: Reconciled Codex general workflow ownership with canonical Verify and Direct-first evidence collection.

## Archive Index

- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.

## Evidence Base

- source:Codex/.agents/workflow-skills/06-test-測試/SKILL.md — canonical Verify compatibility entry.
- source:Shared/policies/execution-routing.md and Shared/policies/verification-strategy.md — routing and evidence ownership.

## Read Contract

- Read when changing owned Codex general workflow entries or shared gate snippets.
- Do not use for temporary test output, Team-only artifact procedure, or protected-action authority.

## Conflicts and Supersession

- superseded: interpreting ordinary `06` verification as Team-default or test creation.

## 中文摘要

- Codex `06 Verify` 可直接蒐集一般驗證證據，不需 Team artifact。
- delegated topology 成立後才載入 station、handoff 與 formal trace。
- workflow route 不授權任何寫入或 protected action。

## Tracked Files

- Codex/.agents/workflow-skills/_shared/_completion_gate.md
- Codex/.agents/workflow-skills/_shared/_security_footer.md
- Codex/.agents/workflow-skills/00-chat-聊天/SKILL.md
- Codex/.agents/workflow-skills/01-explore-探索/SKILL.md
- Codex/.agents/workflow-skills/03-1-experiment-實驗/SKILL.md
- Codex/.agents/workflow-skills/05-condense-濃縮/SKILL.md
- Codex/.agents/workflow-skills/06-test-測試/SKILL.md

## Relations

- _codex_core.support (parent card: navigation only)
- _shared.ops-skills.testing (related verification memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
