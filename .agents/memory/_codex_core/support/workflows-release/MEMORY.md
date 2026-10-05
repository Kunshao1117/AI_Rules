---
name: _codex_core.support.workflows-release
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 提交、巡檢與技能鍛造工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-24T13:40:03+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: pending_review
last_verified: '2026-07-24T13:40:00+08:00'
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

- Owns Codex commit, Git-only routine and skill-forge workflow entries, whose descriptions use Traditional Chinese task meaning and exact route terms.
- Workflow entries select sequence and reference shared policies; they do not themselves grant source, Memory, Git, release, deployment, install, credential or external authority.
- 09 is commit preparation and change summary rather than unfinished implementation or Git-status-only work. Necessary source work uses current local_work scope; explicit Git and protected follow-ups remain separate.
- 09 commit subject/body and summaries use Traditional Chinese meaning-first text while retaining necessary technical tokens.
- 10 is Git-only: worktree, HEAD, tracking branch and origin relation; it does not inspect Memory, MCP, source content, health, review or validation.
- 12 covers reusable Skill creation; discussion-only and description-only edits do not select it.
- General work uses current completion, verification and review policies without mandatory board inheritance or a fixed station chain. Required duty separation and source-version freshness remain; frozen consumers keep their applicable compatibility contracts.
- Read current dirty sections before integration. Source edits do not authorize runtime sync; report projection pending when it has not been authorized and verified.

## Active Constraints

- Do not infer Git, Memory provider, release, deployment, install, credential or external authority from workflow routing.
- Classify actual effects with Authorization Resolution; applicable frozen Memory receipts remain separate from source-only reconciliation.
- Keep durable procedures in Shared policies, workflows and references rather than duplicating them in platform entries.

## Cycle Events
- 04: Recorded `09` commit subject/body/summary Traditional Chinese meaning-first wording governance while preserving separate authorization for git and protected follow-on phases.
- 03: Updated release workflow memory for Chinese-first descriptions, thin-entry wrapping, on-demand references, and dirty-diff slimming guard semantics.
- 02: Preserved split protected-phase rules for commit prep, routine read-only inspection, skill forge, memory, git, release, deploy, install, and external mutation.
- 01: Removed stale warning text after current release workflow file content and targeted diffs were reviewed.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.
- Earlier active cycle details were compacted into Current Truth on 2026-07-07 to keep this card within line limits.

## Evidence Base

- Source-only comparison: `Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md`, `Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md`, `Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md`, `Shared/policies/agent-governance.md`, `Shared/policies/authorization-resolution.md`, `Shared/policies/completion-policy.md`.
- Earlier entries below are historical evidence; preserved timestamps do not certify current runtime or index state.
- source: `Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md`, `10-routine-巡檢/SKILL.md`, and `12-skill-forge-技能鍛造/SKILL.md`.
- source: `Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md` — Dirty diff adds Traditional Chinese meaning-first commit wording and explicit no protected follow-on authorization.
- tool: targeted `git diff` and `rg` output reviewed on 2026-07-07 for release description, thin-entry, on-demand reference, and dirty-diff changes.
- director: 2026-07-07 station C instruction limited memory writes to `_codex_core` cards and excluded already-committed hook behavior.

## Read Contract
- Read this card when changing owned Codex release, routine, or skill-forge workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession

- Universal station/board and per-source-edit protected-phase wording is historical compatibility only.
- Original card and prior claims remain in the [immutable pre-image](https://github.com/Kunshao1117/AI_Rules/blob/b61b27c2d0a6d65d08ded101d323d62cf06d2098/.agents/memory/_codex_core/support/workflows-release/MEMORY.md); existing Cycle Events and archives are preserved.
- Current review is bounded to the cited source semantics and tracking; provider/index/runtime synchronization and unreviewed historical assertions remain unverified.

## 中文摘要

- 此卡負責 Codex 提交、Git-only巡檢與技能鍛造入口
- 09 準備提交且採繁中摘要；實際Git及受保護動作需各自範圍
- 一般工作無強制board或固定站點鏈；保留必要獨立審查與版本新鮮度
- 來源更動不等於已同步runtime或Memory索引

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
