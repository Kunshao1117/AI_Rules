---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-07T10:55:12+08:00'
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
cycle_id: 2026-07-07-001
cycle_event_count: 6
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

# _codex_core — Codex Edition Memory

## Current Truth
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total.
- Current core rules make Team mode active only for the current governed Director request; workflow names, tools, approvals, prior state, or source impact alone are route signals, not activation.
- Active Team mode requires Captain Team Board, applicable station, station handoff packet, role identity, assigned specialist skill, channel state, `station_mode`, `context_visibility`, and `handoff_ownership` before broad reads, validation, review, memory/docs attribution, completion audit, source writes, or completion claims.
- The Codex mainline is Director-facing captain only: it coordinates scope, dispatch, artifact receipt, status synthesis, blocker/protected-gate routing, and reporting; it must not backfill missing station evidence or claim captain-owned broad-read, implementation, review, validation, memory/docs, or completion evidence.
- Main-worktree source writes require station-owned `change-delivery` under `formal-write`, authorization phase `implementation-change-delivery`, exact file allowlist, dirty diff read, and no protected action; `change-application` is only for returned artifacts, explicit integration, or assigned generated/deployed sync.
- Director text, `GO`, workflow commands, UI approvals, permission prompts, and tool confirmations are usable authority only after authorization resolution binds the visible plan, station, file set, command, diff, phase, expiry, blocker, and any required protected gate.
- Protected actions include memory/project-context mutation, git, release, deploy, install, credentials, destructive filesystem operations, cloud mutation, and external mutation; source-write approval does not authorize them.
- Codex hook startup/pre-tool reminders now state that, for governed work, the hook reminder satisfies the station-delegation and necessary subagent/teammate dispatch request precondition only; board, station, role, handoff, and channel state are still required and no protected action is authorized.
- Director-facing output starts with Traditional Chinese meaning; high-change or external facts, dates, APIs, versions, constraints, and risk assumptions must be grounded in current files, tool output, official docs, or primary sources.
- Source/deployed sync remains mandatory: `Codex/.codex/AGENTS.md` is source of truth and currently hashes equal to project `.codex/AGENTS.md`; `Codex/global/AGENTS.md` does not hash-match `C:\Users\homeb\.codex\AGENTS.md` and global sync is pending.
- This update reflects current dirty `Codex/**` AGENTS/README/global/workflow source state and current Codex hook reminder wording under the Director-authorized memory-write scope.

## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, and keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- Do not add long playbooks, field catalogs, or duplicated workflow procedure detail to Codex core files; route detail to Shared policies, Shared skills, or workflow references.
- Before source writes, produce a bounded plan, bind write authority to the visible scope, read current file content/status/diff, and integrate dirty target sections in place.
- Codex workflow entries must stay thin, cite deployed shared language/grounding policy when needed, and preserve source/deployed parity before completion claims.
- Keep this active card below `line_limit: 120`; use child workflow cards for workflow-entry detail.

## Cycle Events
- 06: Recorded Codex hook reminder semantics for governed work: hook injection satisfies the delegation-request precondition only, requires station handoff before work, and does not authorize protected actions.
- 05: Repaired ownership for Codex hook config and Team-Native hook script in `## Tracked Files`.
- 04: Updated core memory for dirty Codex AGENTS/README/global changes: Team-Native startup, authorization resolution, captain boundary, protected actions, output/grounding, and source/deployed sync.
- 03: Recorded current workflow-entry dirty-source semantics for Chinese-first descriptions, thin route entries, dirty-diff integration, `execution_spec`, and protected follow-up closeout.
- 02: Repaired active-card line count and removed stale warning text after reading current file content, target diffs, and Codex source diffs.
- 01: Excluded already-committed `Codex/.codex/hooks*` behavior from this dirty-source memory cycle per Director station C scope.

## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md — Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source: `Codex/.codex/AGENTS.md`, `Codex/README.md`, `Codex/global/AGENTS.md`, and `.codex/AGENTS.md` dirty/current content.
- source: `Codex/.codex/hooks/team-native-gate.ps1` — Current decoded reminder text verified for governed-work station delegation and necessary subagent/teammate dispatch semantics.
- source: `Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md`, `03-build-建構/SKILL.md`, `04-fix-修復/SKILL.md`, `07-debug-除錯/SKILL.md`, and `11-handoff-交接/SKILL.md`.
- tool: `git status --short -- Codex .agents/memory/_codex_core` and targeted `git diff` reviewed on 2026-07-07.
- tool: `Get-FileHash -Algorithm SHA256` verified `Codex/.codex/AGENTS.md` equals `.codex/AGENTS.md`; `Codex/global/AGENTS.md` differs from `C:\Users\homeb\.codex\AGENTS.md`.
- director: 2026-07-07 ownership repair instruction assigned `Codex/.codex/hooks.json` and `Codex/.codex/hooks/team-native-gate.ps1` to `_codex_core`.
- director: 2026-07-07 protected memory-write instruction explicitly requested recording current Codex hook reminder semantics without protected action authority.

## Read Contract
- Read this card when the task touches Codex core governance, framework source/deployed sync, or the tracked core workflow entries below.
- Do not use archived hook-cycle facts as current dirty-source evidence without reading the current source and Director scope.

## Conflicts and Supersession
- superseded: prior station C hook-exclusion wording is replaced only for this Director-authorized memory-write update; current hook reminder wording is now recorded from source evidence.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.

## 中文摘要
- Codex 是 OpenAI Codex 平台適配層，技能數量為 62 shared + 17 workflow = 79。
- 受治理請求才啟動 Team mode；隊長只能協調與回收站點交付，不能補寫站點證據。
- 寫入、記憶、git、release、deploy、install、credentials 與外部變更都需要各自範圍化授權。
- 總監可見輸出以繁中語義先行；高變動與外部事實必須以目前檔案、工具或主要來源接地。
- 專案 `.codex/AGENTS.md` 已與 source hash 一致；使用者全域 AGENTS 尚未同步。
- 本輪已記錄目前 Codex hook reminder：governed work 下視為站點分工與必要子代理/隊員派工的請求前提，但不授權 protected actions。

## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks/team-native-gate.ps1
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md

## Relations
- _system (root governance and deployment memory); _shared (Shared operational skills); _map (memory navigation index); _codex_core.support (support workflow child card)

## Applicable Skills
- memory-ops — Update and commit this card; team-memory-docs-delivery-artifact — Report memory/docs state.
