---
name: _ag_core.support.workflows-audit-commit
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 健檢與提交工作流。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-28T11:33:44+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T11:28:20+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 14
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _ag_core.support.workflows-audit-commit — Antigravity Audit and Commit Workflow Memory

## Current Truth
- Antigravity commit execution treats specialists as evidence-only for review, validation, and completion packets; memory, git, push, and release remain captain-only mutations.
- Antigravity audit and commit workflows now inherit team-task-package references through the shared workflow entry contract while keeping git, memory, and release ownership on the captain path.
- Antigravity audit and commit workflows now require task type, dispatch pre-gate, Captain Minimum Execution Gate, text patch packets, and accepted-risk captain substitution before specialist work.
- Antigravity audit and commit workflows load captain-led governance with role boundary, isolated patch semantics, and no-self-review rules for audit and release-prep stations.
- Antigravity audit and commit workflows now load programming-team-governance and report applicability/execution-mode team-station board status for coding-related audit or release-prep work.
- Antigravity audit and commit workflows now require evidence owner, direct exception, completion condition, and all-direct fake-team guard reporting for team-station boards.
- Antigravity audit, audit subflows, and commit scan workflows now use the MCP Memory Evidence Matrix while preserving read-only audit boundaries.
- This child card owns Antigravity audit, audit subphase, and commit execution workflow entries.
- Audit workflows use evidence status and project-surface routing rather than a fixed scan checklist.
- Audit workflows now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Commit workflows must not bypass Director gates for git state changes.
- Antigravity audit workflow now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Antigravity audit and commit scan workflows now carry review_state, review lifecycle mapping, accepted-risk reporting, and review-state preflight through quality-review-governance.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.
- Do not commit, push, tag, or release without explicit Director approval.

## Cycle Events
- 14: Tightened Antigravity commit execution around evidence-only specialists, captain-only git/memory/release actions, and packet-triad completion.
- 13: Added team-task-package template governance, refreshed 44/61 skill-count facts, and verified Doctor/Audit green.
- 12: Updated Antigravity audit and commit workflow memory for captain minimum execution and text patch packet governance.
- 11: Updated Antigravity audit and commit workflows for the new captain dispatch gate.
- 10: Aligned Antigravity audit and commit workflows with captain-led team board fields and mutation ownership.
- 09: Hardened Antigravity audit and commit boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 08: Hardened Antigravity audit and commit team-station reporting with applicability/execution-mode fields and synced deployed workflow copies.
- 07: Added review lifecycle mapping and review-state preflight to Antigravity audit and commit scan workflows.
- 06: Added change intent, patch-stack, visual detail, and real-information evidence fields to the Antigravity audit entry.
- 05: Added MCP memory evidence contract references to Antigravity audit and commit scan workflows.
- 04: Updated Antigravity audit and commit workflow output examples with deployed reference labels.
- 03: Aligned audit and commit workflow grounding paths to deployed .agents/shared governance references.
- 01: Split Antigravity audit and commit workflow ownership out of the support parent card.
- 02: Updated Antigravity audit entry and subphases for depth selection, inventory construction, visual evidence mapping, and coverage reporting.

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
- 此子卡負責 Antigravity 健檢與提交相關工作流。
- 健檢與提交入口需呈現團隊證據負責與全主線例外，不能只標示直做或委派。
- 此子卡負責 Antigravity 健檢與提交相關工作流。
- 缺證據不能當通過；Git 外部狀態仍需總監授權。

## Tracked Files
- Antigravity/.agents/workflows/08_audit(健檢).md
- Antigravity/.agents/workflows/08-1_audit_infra(基礎盤點).md
- Antigravity/.agents/workflows/08-2_audit_logic(深度邏輯).md
- Antigravity/.agents/workflows/08-3_audit_report(健檢總結).md
- Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md
- Antigravity/.agents/workflows/09-2_commit_execute(授權備份).md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared (shared workflow matrix and audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
