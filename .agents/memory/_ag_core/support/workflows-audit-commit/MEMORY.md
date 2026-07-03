---
name: _ag_core.support.workflows-audit-commit
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 健檢與提交工作流。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-03T13:40:34+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T05:44:38+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 20
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
- Antigravity audit, commit, routine, handoff, and skill-forge workflow entries now reference workflow-orchestration before completion or protected closeout work.
- Antigravity audit and commit workflows are covered by entrypoint checks for formal dispatch board lifecycle, wave-gated evidence, and captain-owned memory/git/release state.
- Antigravity commit execution treats Director `GO` as a scope-bound intent signal only after authorization resolution binds the visible plan, station, file set, command, phase, expiry, and required protected gate.
- Antigravity commit execution separates changelog/source write, memory mutation, git commit, push, tag, release, deployment, and install into distinct protected phases; one intent signal cannot authorize them all.
- Antigravity commit execution treats specialists as evidence-only for review, validation, and completion delivery artifacts; memory, git, push, tag, release, deployment, and install remain protected mutations after separate authorization resolution.
- Antigravity audit and commit workflows now inherit team-task-board references through the shared workflow entry contract while keeping git, memory, and release ownership on the captain path.
- Antigravity audit and commit workflows now require task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` before specialist work.
- Antigravity audit, audit subflows, and commit scan workflows now use the MCP Memory Evidence Matrix while preserving read-only audit boundaries.
- This child card owns Antigravity audit, audit subphase, and commit execution workflow entries.
- Audit workflows use evidence status and project-surface routing rather than a fixed scan checklist.
- Audit workflows now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Commit workflows must not bypass scope-bound authorization resolution for changelog/source write, memory mutation, git, release, deployment, install, or external-state phases.
- Antigravity commit scan routes stale memory, missing validation, missing review, missing sync, and untracked blockers back to owner workflows instead of treating scan as the fixer.
- Antigravity audit workflow now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Antigravity audit and commit scan workflows now carry review_state, review lifecycle mapping, accepted-risk reporting, and review-state preflight through quality-review-governance.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.
- Do not treat `GO` as blanket authorization; every changelog/source write, memory mutation, git commit, push, tag, release, deployment, or install phase needs its own resolved scope-bound authority.

## Cycle Events
- 24: Recorded the 2026-07-03 audit/commit workflow authorization-semantics repair; commit scan routes stale memory, missing validation/review/sync, and untracked blockers to owner workflows, and affected source/deployed workflow pairs were included in the 18/18 parity verification.
- 23: Recorded Batch 3b scope-bound GO semantics for Antigravity commit execute; upstream six-file Measure-GovernanceSemantics evidence reported Red 0 / Yellow 0 and was not rerun in this memory phase.
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21: Wave 6B added workflow-orchestration grounding to Antigravity audit/commit/closeout workflow entries.
- 20: Wave 6A updated Antigravity audit, commit, routine, handoff, and skill-forge workflow entries with Team-Native mode, role split, board trigger, and specialist lifecycle rules.
- 19: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 18: Synced Antigravity audit and commit workflows with Team-Native specialist registry and change delivery artifact terminology.
- 17: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 16: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 15: Verified Antigravity audit/commit workflow coverage under formal dispatch and wave-gated evidence checks.
- 14: Tightened Antigravity commit execution around evidence-only specialists, captain-only git/memory/release actions, and four-delivery-artifact completion.
- 13: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 12: Updated Antigravity audit and commit workflow memory for captain minimum execution and text change delivery artifact governance.
- 11: Updated Antigravity audit and commit workflows for the new captain dispatch gate.
- 10: Aligned Antigravity audit and commit workflows with captain-led team board fields and mutation ownership.
- 09: Hardened Antigravity audit and commit boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 08: Hardened Antigravity audit and commit team-station reporting with applicability/execution-mode fields and synced deployed workflow copies.
- 03-07: Added audit/commit grounding, output labels, MCP memory evidence, change-intent/visual-evidence, and review-state coverage.
- 01: Split Antigravity audit and commit workflow ownership out of the support parent card.
- 02: Updated Antigravity audit entry and subphases for depth selection, inventory construction, visual evidence mapping, and coverage reporting.

## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.
- upstream:2026-07-02 Batch 3b — Antigravity/Claude six-file governance semantics validation reported Measure-GovernanceSemantics Red 0 / Yellow 0; this memory phase did not rerun it.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Antigravity 健檢與提交相關工作流。
- 提交執行中的 `GO` 只是綁定目前可見範圍的意圖訊號，不是一次授權 changelog/source write、memory、git、push、tag、release、deploy 或 install。
- `09-1_commit_scan` 會把 stale memory、missing validation/review/sync 與 untracked blockers 轉回 owner workflow；本批 source/deployed workflow pair 已納入 18/18 一致性驗證。
- 健檢與提交入口需呈現團隊證據負責與全主線例外；缺證據不能當通過。

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
