---
name: _ag_core.workflow-delivery
scopePath: Antigravity/
description: >-
  專案記憶：Antigravity 平台入口、核心規則與交付工作流。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-27T20:49:28+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-27T20:47:17+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 2
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


# _ag_core.workflow-delivery — Module Memory

## Current Truth

- Owns Antigravity adapter entrypoints, core rule sources, and delivery workflow files listed below.
- `07_debug` narrows a failure and routes broad uncertainty to Explore or Blueprint; deep audit remains conditional.
- Local writes remain distinct from protected actions such as release, deployment, installation, credential change, or destructive mutation.
- The Antigravity core points to shared language governance for all user-visible reporting instead of defining its own report format.
- Its always-on user-facing rule keeps plain zh-TW and distinct work states, while detailed wording remains in the shared policy.

## Active Constraints

- Keep workflow entries thin and keep protected phases separately authorized.
- Do not treat debugging activity as a Team trigger by itself.

## Cycle Events

- 02: Reconciled `07_debug` with Direct-first routing and conditional deep-audit semantics.
- 03: Reduced the Antigravity core to the shared beginner-facing reporting pointer and kept internal artifacts out of user replies.
- 04: Verified the minimal always-on reporting rule after the non-engineer UX update.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Antigravity/.agents/workflows/07_debug(除錯).md
- source:Shared/policies/execution-routing.md and Shared/policies/verification-strategy.md
- source:Antigravity/.agents/rules/00_core_identity.md and Shared/policies/language-governance.md

## Read Contract

- Read when working on the owned Antigravity source files.
- Do not use for sibling ownership, temporary task state, or historical parent detail.

## Conflicts and Supersession

- superseded: broad audit as the ordinary continuation of debugging.

## 中文摘要

- 此卡負責 Antigravity 平台與交付 workflow。
- Debug 先縮小問題；大範圍不確定性轉向 Explore 或 Blueprint。
- 受保護操作仍須獨立授權。
- Antigravity 對外回覆以 Shared 的初學者白話規則為準。

## Tracked Files

- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md
- Antigravity/.agents/workflows/09-2_commit_execute(授權備份).md

## Relations

- _ag_core (parent card: navigation only)
- _ag_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
