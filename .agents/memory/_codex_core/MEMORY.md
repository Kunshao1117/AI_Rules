---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-08T22:55:46+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T22:45:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
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
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total, and its installer SHA helper accepts blank optional hashes while non-empty values remain 64-hex checked.
- Current Team mode activates only for the current governed Director request; the captain coordinates scope, dispatch, artifact receipt, blocker/protected-gate routing, and Traditional Chinese reporting without backfilling station-owned evidence.
- Source-write eligibility uses station-owned `change-delivery` under `formal-write`, authorization phase `implementation-change-delivery`, exact file allowlist, dirty diff read, and no protected action; `change-application` is only for returned artifacts, explicit integration, or assigned generated/deployed sync.
- Protected actions include memory/project-context mutation, git, release, deploy, install, credentials, destructive filesystem operations, cloud mutation, and external mutation; source-write approval does not authorize them.
- Codex 03-build, 04-fix, and 07-debug workflow skills may route optional `coding-reflection-gate` reflection/retry checks before build-plan or execution_spec; the route does not replace authorization, implementation, validation, review, memory, or completion evidence.
- Active Codex hooks are `SessionStart`, `UserPromptSubmit`, `SubagentStart`, `PreToolUse`, `Stop`, and `SubagentStop`; `hooks.json` uses top-level `hooks`, Windows `commandWindows` uses `pwsh -EncodedCommand`, and UserPromptSubmit injects exact phrase `操作者要求開啟子代理功能，並默認啟動團隊模式` plus state lines `TEAM_NATIVE_ACTIVE=true`, `SUBAGENT_AUTHORIZATION=granted_for_bounded_stations`, `LANE_SELECTION=exclusion_first_negative_contract`, `CAPTAIN_DIRECT_WORK=forbidden_except_named_file_local_probe_or_recorded_exception`, and `NEXT_LEGAL_ACTION=dispatch_matching_station_or_stop_noncomplete`.
- `PreToolUse` denies direct guarded writes or broad reads without station trace; `Stop` uses message/text fallback, strips hook feedback/noise, remains advisory/allow, and adds `COMPLETION_EVIDENCE_WARNING=true` plus `DIRECTOR_FINAL_ACCEPTANCE_REQUIRED=true`.
- `SubagentStart` reminds workers to avoid recursive delegation/protected actions; `SubagentStop` requires summary/status, evidence, risk/blocker, and next-step/handoff fields before closing.
- Source/runtime parity was verified on 2026-07-08 for Codex hook/config pairs, with source/runtime hook hash equality reported for the hook state-machine cycle; validation/review accepted residual risks: trace trust boundary may over-allow, write-like rule may overblock, `Audit.psm1` facade command is absent, and `pwsh` remains a wrapper dependency.

## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning; exact hook/test/resource tokens remain canonical evidence.
- Active-card content must stay under `line_limit: 120`; child cards own support workflow and fixture-specific details.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.

## Cycle Events
- 01: Compacted stale hook-cycle noise and recorded current active hook runtime behavior, source/runtime parity, validation snapshot, review accepted-risk, and protected follow-up boundaries.
- 02: Recorded Director-approved Stop completion-risk policy change: completion-risk Stop findings are advisory-only and no longer hard-block AI completion replies.
- 03: Recorded optional `coding-reflection-gate` reflection/retry routing in Codex 03-build, 04-fix, and 07-debug workflow skills without granting write or protected-action authority.
- 04: Removed stale ghost tracked-file state for deleted `Codex/.codex/hooks.delete` after confirming no current Codex hook source diff.
- 05: Recorded Team-Native hook state-machine update for UserPromptSubmit state injection, PreToolUse guarded-action denial, advisory Stop completion warnings, source/runtime hook parity, and accepted review risks.
- 06: Recorded Codex installer empty SHA regression guard while preserving non-empty 64-hex validation.

## Archive Index
- archive-003.md — Older events 13-22; archive-001.md — legacy pre-schema-v2 card; archive-002.md — pre-standardization MEMORY.md migration snapshot.

## Evidence Base
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, and `.codex/hooks/team-native-gate.ps1`.
- source: `Codex/.codex/config.toml`, `.codex/config.toml`, `Codex/.codex/AGENTS.md`, `Codex/README.md`, `Codex/install.ps1`, and `Codex/global/AGENTS.md`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` and `Scripts/tests/codex-hooks/fixtures/*.json`.
- tool: Gateway `memory_audit`, `memory_status`, and `memory_read` for `_codex_core`, `_system.scripts`, and `_system.scripts.codex-hooks-fixtures` on 2026-07-08.
- tool: `git status --short -- Codex`, `git diff --name-status -- Codex`, and `git diff --name-status -- Codex/.codex/hooks.delete` returned no Codex source changes on 2026-07-08.
- tool: `Test-Path Codex/.codex/hooks.delete` returned false and `git log -- Codex/.codex/hooks.delete` showed prior removal history on 2026-07-08.
- tool: `Get-FileHash -Algorithm SHA256` verified source/runtime Codex hook/config parity on 2026-07-08.
- director: 2026-07-08 protected memory-write instruction supplied UserPromptSubmit state injection, PreToolUse denial scope, advisory Stop warning fields, validation pass summary, review accepted-risk, fixture tracking repair, and no release/deploy/install boundary.
- upstream_artifact:2026-07-08 — Reported optional coding-reflection-gate reflection/retry routing in `Codex/.agents/workflow-skills/03-build-建構/SKILL.md`, `04-fix-修復/SKILL.md`, and `07-debug-除錯/SKILL.md`.

## Read Contract
- Read this card for Codex core governance, hook runtime/config, source/deployed sync, or tracked workflow entries; read `_system.scripts` for hook runner/audit and `_system.scripts.codex-hooks-fixtures` for JSON fixtures.

## Conflicts and Supersession
- superseded: prior Stop block memory is replaced by advisory-only Stop completion-risk behavior; SubagentStop delivery-field hard gate remains separate.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.

## 中文摘要
- Codex 是 OpenAI Codex 平台適配層；目前記錄六個 active hook event、`pwsh -EncodedCommand` wrapper 與 source/runtime parity。
- `UserPromptSubmit` 會注入指定中文句與 Team-Native 狀態行；`PreToolUse` 阻擋缺 station trace 的受管寫入或 broad read；`Stop` 維持 advisory allow 並附 completion warning fields。
- `SubagentStop` 要求摘要、證據、風險與下一步；驗證回報 45 fixtures、2 shell checks、source/runtime hook hash equal，仍有 trace trust boundary、write-like overblock、`Audit.psm1` facade 與 `pwsh` 風險。

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
- _system (root governance and deployment memory); _shared (Shared operational skills); _map (memory navigation index); _codex_core.support (support workflow child card); _system.scripts (hook runner and audit); _system.scripts.codex-hooks-fixtures (fixture ownership)

## Applicable Skills
- memory-ops — Memory update and commit procedure owner; team-memory-docs-delivery-artifact — memory/docs state reporting owner.
