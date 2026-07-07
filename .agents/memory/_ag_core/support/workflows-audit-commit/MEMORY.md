---
name: _ag_core.support.workflows-audit-commit
scopePath: Antigravity/.agents/workflows/
description: >-
  專案記憶：Antigravity 健檢與提交工作流。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-07T10:40:51+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T10:35:30+08:00'
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

# _ag_core.support.workflows-audit-commit — Antigravity Audit and Commit Workflow Memory

## Current Truth
- This child card owns Antigravity audit, audit subphase, and commit execution workflow entries.
- Audit and commit workflow descriptions now start with Chinese meaning and keep English exact tokens for trigger precision.
- `08_audit` owns full-spectrum audit routing; `08-1`, `08-2`, and `08-3` are phase-specific infra, logic, and report entries and must not substitute for the full audit entry when full coverage is needed.
- Audit workflows preserve evidence status, project-surface routing, coverage denominators, sampling limits, visual/browser evidence, performance checks, and risk inventory boundaries.
- `09-1_commit_scan` is pre-commit scan and governed backup readiness; it does not fix stale memory, missing validation/review/sync, or untracked blockers by itself.
- `09-2_commit_execute` applies only after scan and current protected-phase authorization for commit, push, tag, or release synchronization.
- Commit message subject/body and commit summaries must use Traditional Chinese meaning-first main text; this wording rule does not authorize commit, push, tag, release, deployment, memory commit, or other protected mutation.
- Commit execution treats Director `GO` as a scope-bound intent signal only after authorization resolution binds visible plan, station, file set, command, phase, expiry, and required protected-action gate.
- Changelog/source write, memory mutation, git commit, push, tag, release, deployment, install, and external-state mutation remain separate protected phases.
- Missing memory evidence in audit/commit entries is expressed as 未驗證 (`unverified`) or 阻塞 (`blocked`) through the MCP Memory Evidence Matrix.
- Audit and commit entries must not copy full Team-Native policy, board schemas, completion checklists, Director-facing language policy, or stage playbooks.
- Missing evidence must not be reported as green or `complete`; use `blocked`, `unverified`, or `closed-with-director-risk` when evidence is absent or risk-accepted.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not claim full coverage from sampled evidence; report coverage denominators and sampling limits.
- Do not treat `GO` as blanket authorization; every changelog/source write, memory mutation, git commit, push, tag, release, deployment, or install phase needs its own resolved scope-bound authority.

## Cycle Events
- 26: Recorded 09 commit subject/body/summary Traditional Chinese meaning-first wording governance without granting git, release, deploy, memory-commit, or other protected mutation authority.
- 25: Repaired stale warning state against 2026-07-07 audit/commit workflow dirty source for description normalization, missing memory evidence wording, commit protected-phase routing, and thin workflow-entry boundaries.
- 24: Recorded the 2026-07-03 audit/commit workflow authorization-semantics repair; commit scan routes stale memory, missing validation/review/sync, and untracked blockers to owner workflows, and affected source/deployed workflow pairs were included in the 18/18 parity verification.
- 23: Recorded Batch 3b scope-bound GO semantics for Antigravity commit execute; upstream six-file Measure-GovernanceSemantics evidence reported Red 0 / Yellow 0 and was not rerun in this memory phase.
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21-18: Added workflow-orchestration grounding, Team-Native lifecycle coverage, commit-preflight ownership, and specialist registry/artifact terminology.
- 17-14: Compressed station/delegation governance, added formal specialist routing, verified audit/commit coverage, and tightened protected-action completion handling.
- 13-08: Added team-task-board governance, station-scoped execution wording, dispatch gates, mutation ownership, direct-exception guards, and station reporting.
- 03-07: Added audit/commit grounding, output labels, MCP memory evidence, change-intent/visual-evidence, and review-state coverage.
- 01-02: Split Antigravity audit/commit workflow ownership and added depth selection, inventory, visual evidence, and coverage reporting.

## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Antigravity/.agents/workflows/08_audit(健檢).md, `08-1_audit_infra(基礎盤點).md`, `08-2_audit_logic(深度邏輯).md`, `08-3_audit_report(健檢總結).md`, `09-1_commit_scan(紀錄掃描).md`, and `09-2_commit_execute(授權備份).md` — Dirty source verified on 2026-07-07.
- source:Antigravity/.agents/workflows/09-1_commit_scan(紀錄掃描).md and `09-2_commit_execute(授權備份).md` — Dirty diff adds Traditional Chinese meaning-first commit wording and explicit no-protected-mutation authority.
- tool:`git diff -- Antigravity/.agents/workflows` and `rg` over audit/commit workflow terms reviewed before writing on 2026-07-07.
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
- Dirty source 已把 08/09 workflow description 改成繁中語義先行，並保留必要英文觸發 token。
- `09-1_commit_scan` 只做提交前掃描與治理備份準備，不自行修 stale memory、missing validation/review/sync 或 untracked blockers。
- `09-2_commit_execute` 只在掃描後且當前 protected phase 授權解析完成時執行 commit/push/tag/release 同步。
- 09 commit subject/body/summary 必須以繁中語義作為主體；此規則不授權 commit、push、tag、release、deploy、memory_commit 或其他 protected mutation。
- `GO` 不是一次授權 changelog/source write、memory、git、push、tag、release、deploy 或 install。
- Missing memory evidence 與缺少交付證據必須標記 `unverified`、`blocked` 或 `closed-with-director-risk`，不能宣稱 complete。

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
