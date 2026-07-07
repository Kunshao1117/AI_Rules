---
name: _codex_core.support.workflows-release
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 提交、巡檢與技能鍛造工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-07T22:46:31+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T20:50:00+08:00'
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
# _codex_core.support.workflows-release — Codex Release and Governance Workflow Memory

## Current Truth
- Commit, routine, and skill-forge workflow descriptions now start with Traditional Chinese semantic labels and keep English trigger terms in parentheses for commit prep, changelog, health check, skill forge, and reusable methodology routing.
- `09`, `10`, and `12` remain thin route entries: they select workflow rows, apply the platform adapter, and never grant source write, memory, git, release, deployment, install, credential, or external-state authority.
- Required References load on demand: captain entry starts from route/evidence/minimum Team-Native gates; completion, protected closeout, language, grounding, platform, stage, station, review, validation, and memory references load only when needed.
- The Workflow Entry Slimming Guard requires workflow entries to own only route selection, minimum load gates, evidence-matrix row, and platform adapter reference; dirty target files require current diff review and integration into existing sections.
- `09` is commit-prep/change-summary routing, not unfinished implementation or git-status-only work; memory-write, memory index/staleness sync, git commit/push, tag/release, deploy, install, and external mutation are distinct protected phases.
- `09` commit message subject/body and commit summaries must use Traditional Chinese meaning-first main text; this wording rule does not authorize git commit or any protected follow-on phase.
- `10` stays automation-safe only while read-only; routine inspection cannot repair or write files without a separately resolved formal-write or protected owner station.
- `12` covers reusable skill/methodology creation and does not apply to discussion-only or description-only edits without a write scope.
- Release-side evidence still requires team-task-board inheritance, role-bound delivery artifacts, review/validation separation, memory/docs disposition, source/deployed parity when relevant, and honest blocked/unverified/risk-closed states.

## Active Constraints
- Do not perform source write, changelog/source write, memory mutation, memory index/staleness sync, git commit/push, tag/release, deployment, install, credential, or external mutation without explicit protected-phase authorization.
- Do not collapse memory write into `memory_commit`; active-card edits, index/staleness sync, git operations, and release/deploy/install operations each need their own protected gate.
- Keep release workflow entries thin; durable release and closeout procedure belongs in Shared skills or workflow-stage references.

## Cycle Events
- 04: Recorded `09` commit subject/body/summary Traditional Chinese meaning-first wording governance while preserving separate authorization for git and protected follow-on phases.
- 03: Updated release workflow memory for Chinese-first descriptions, thin-entry wrapping, on-demand references, and dirty-diff slimming guard semantics.
- 02: Preserved split protected-phase rules for commit prep, routine read-only inspection, skill forge, memory, git, release, deploy, install, and external mutation.
- 01: Removed stale warning text after current release workflow file content and targeted diffs were reviewed.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.
- Earlier active cycle details were compacted into Current Truth on 2026-07-07 to keep this card within line limits.

## Evidence Base
- source: `Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md`, `10-routine-巡檢/SKILL.md`, and `12-skill-forge-技能鍛造/SKILL.md`.
- source: `Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md` — Dirty diff adds Traditional Chinese meaning-first commit wording and explicit no protected follow-on authorization.
- tool: targeted `git diff` and `rg` output reviewed on 2026-07-07 for release description, thin-entry, on-demand reference, and dirty-diff changes.
- director: 2026-07-07 station C instruction limited memory writes to `_codex_core` cards and excluded already-committed hook behavior.

## Read Contract
- Read this card when changing owned Codex release, routine, or skill-forge workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- superseded: stale warning blocks and older English-first release workflow description facts were replaced by current dirty-source evidence.

## 中文摘要
- 提交、巡檢與技能鍛造 workflow description 已改為繁中語義先行。
- 這些入口仍是 thin route，不授權 source write、memory、git、release、deploy、install 或外部變更。
- `09` commit subject/body/summary 必須繁中語義先行，且不授權 git commit 或任何 protected follow-on phase。
- `GO`、工作流名稱與工具確認只是路由或範圍訊號；各 protected phase 需要各自授權。
- 例行巡檢保持唯讀；記憶寫入與 `memory_commit` 不可合併。

## Tracked Files
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared.ops-skills.release-reasoning (related release and skill governance memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
