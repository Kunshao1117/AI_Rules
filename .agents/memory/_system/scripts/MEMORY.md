---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-08T17:41:40+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T17:39:43+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 3
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
# _system.scripts — Repository Script Governance Memory
## Current Truth
- This card is a source/status pointer for root PowerShell deployment, split Audit module scripts, audit tests, memory migration, skill sync, platform sync, D0 validation, source-size validation, and Codex hook fixture runner ownership.
- Canonical behavior and runtime rules live in tracked `Scripts/**` source files plus referenced Shared policies/skills; this card is not runtime authority by itself.
- `Scripts/tests/Validate-D0Minimal.ps1` is the D0 minimal validation route for parse/import, extension JSON/runtime gates, package-lock parsing, release workflow, installer hardening, and scriptRunner guards.
- Doctor, Deploy Audit, and manager Doctor fail closed on governance-audit Red findings, failed audit results, Team-Native hard-gate failures, and hard-policy source/deployed drift.
- Repo-managed Codex hooks and fixtures are under the Codex hook source/deployed pair and `Scripts/tests/codex-hooks/`; the runner validates active event coverage, official payload fields, Windows/POSIX host wrappers, fixture expectations, optional source/deployed hash parity, and git tracking.
- `Invoke-CodexHookFixtureTests.ps1` now verifies Stop completion-risk cases are advisory allow outputs with `systemMessage`, and validates `commandWindows` through both `cmd` and `pwsh` hosts when available.
- Windows PowerShell 5.1 compatibility for hook governance scripts requires UTF-8 BOM for CJK literals; the fixture runner uses `ProcessStartInfo.ArgumentList` when available and falls back to quoted `Arguments` plus local relative-path resolution when .NET APIs are missing.
- Audit checks authorization semantics, trusted tool envelope/receipt validity, formal-write/protected gates, trace non-authorization, workflow references, scenario templates, Team-Native semantics, mixed completion wording, and source/deployed drift.
- Ownership status: Codex hook governance catalog/audit sources and config merge helpers are present; section-aware config merge preserves existing `max_threads`, adds project default 8/global default 6 only when missing, fixes `features` false values, omits `max_depth`, and skips all `.codex/*` writes when the upgrade gate is declined.
- Approved validation evidence reports parser compatibility and hook fixture suites passed under Windows PowerShell 5.1 and PowerShell 7 with 45 fixtures, 10 `commandWindows` host-wrapper cases, source/runtime sync verified, and manager `-WhatIf` load paths passing.
## Active Constraints
- Verify current script behavior from source, runner output, Gateway evidence, and git diff; this card is only ownership and status memory.
- Treat hook diagnostics and deny decisions as tool-guard evidence only; authorization, memory, git, release, deploy, install, and completion gates remain separate protected phases.
- Full Doctor and `Measure-CodexHookGovernance` are non-completion evidence for non-Hooks lifecycle work.
- JSON fixture ownership belongs to `_system.scripts.codex-hooks-fixtures`; this parent card owns runner, audit integration, and script-side behavior.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.
- `pwsh` remains a residual runtime dependency risk for hook wrappers.
## Cycle Events
- 01: Compacted stale script-cycle noise and recorded section-aware Codex config sync, upgrade skip gate repair, 43-fixture validation, runtime sync verification, and hook governance release-ready state.
- 02: Recorded Stop completion-risk runner change from hard block expectations to advisory allow expectations across fixture harness and governance audit checks.
- 03: Recorded Windows PowerShell 5.1 parser/runtime compatibility repair for hook governance scripts: UTF-8 BOM on CJK-bearing scripts, ProcessStartInfo argument fallback, and local relative-path fallback.
## Archive Index
- archive-002.md — Script governance events 23-30 compacted on 2026-06-30.
- archive-001.md — Older script cycle events 09-21 compacted from the active card.
## Evidence Base
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` — fixture runner and commandWindows host-wrapper contract.
- source: `Scripts/modules/Audit/50.CodexHookGovernance.ps1`, `Scripts/modules/Audit/CodexHookGovernance.catalog.json`, and `Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1`.
- source: `Scripts/tests/Validate-D0Minimal.ps1`, `Scripts/tests/Validate-SourceSizeGovernance.ps1`, and `Scripts/modules/Audit/*.ps1`.
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, and Codex hook fixtures.
- tool: Gateway `memory_audit`, `memory_status`, and `memory_read` on 2026-07-08.
- tool: `git diff` and `git status --short` for script runner, fixture manifest, hook/config source, and authorized memory files reviewed on 2026-07-08.
- tool: `Measure-CodexHookGovernance` reported `Passed=true`, `ReleaseReady=true`, Red 0, Yellow 0, and untracked required fixtures 0 on 2026-07-08.
- tool: validation station on 2026-07-08 verified Windows PowerShell 5.1 and PowerShell 7 parser checks, 45 hook fixtures, 10 `commandWindows` host-wrapper cases, source/runtime sync, and manager `-WhatIf` load paths.
- director: 2026-07-08 protected memory-write instruction supplied 45-fixture validation, runtime sync evidence, manifest/catalog mirror repair, residual broader-dirty-worktree risk, and `pwsh` runtime risk.
## Read Contract
- Read this card for root PowerShell script changes, Codex hook runner changes, audit integration changes, or D0/source-size validation script changes.
- Read `_system.scripts.codex-hooks-fixtures` for Codex hook JSON fixture additions, deletions, edits, and tracking.
## Conflicts and Supersession
- superseded: older runner memory that only described reminder/deny behavior is replaced by active-event, official-payload, host-wrapper, and Stop/SubagentStop validation coverage.
- pending-follow-up: broader dirty-worktree risk and any git staging/commit remain outside this memory-write phase.
## 中文摘要
- 此子卡負責根層 PowerShell 腳本、Audit 模組拆分腳本、D0/source-size 驗證與 Codex hook runner。
- runner 現在檢查 Stop 完成風險 advisory allow、`cmd`/`pwsh` commandWindows wrapper、官方 payload 欄位與 fixture 預期；Windows PowerShell 5.1 相容性需保留 UTF-8 BOM 與 fallback helper。
- 前站驗證回報 Windows PowerShell 5.1 / PowerShell 7 的 parser、45 fixtures、10 個 `commandWindows` host-wrapper cases 與 manager `-WhatIf` 載入路徑皆通過。
- JSON fixtures 歸屬在 child card；本卡只記錄 runner 與 script-side 行為。
- 不授權 `memory_commit`、git、release、deploy、install 或外部變更。
## Tracked Files
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1
- Scripts/modules/Audit/00.Common.ps1
- Scripts/modules/Audit/10.LegacyScans.ps1
- Scripts/modules/Audit/20.SkillQuality.ps1
- Scripts/modules/Audit/30.WorkflowPlatform.ps1
- Scripts/modules/Audit/40.PolicySemantics.ps1
- Scripts/modules/Audit/50.CodexHookGovernance.ps1
- Scripts/modules/Audit/CodexHookGovernance.catalog.json
- Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1
- Scripts/modules/Audit/60.ProgrammingTeamGovernance.ps1
- Scripts/modules/Audit/70.DirectorOutputGrounding.ps1
- Scripts/modules/Audit/80.ProjectStores.ps1
- Scripts/modules/Audit/90.TeamNativeCore.ps1
- Scripts/modules/Audit/91.TeamTraceEvidence.ps1
- Scripts/modules/Audit/99.PlatformGovernanceAudit.ps1
- Scripts/modules/Memory-Migration.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
- Scripts/tests/Validate-D0Minimal.ps1
- Scripts/tests/Validate-SourceSizeGovernance.ps1
- Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1
## Relations
- _system (parent card: repository governance)
- _shared (shared governance source)
- _system.scripts.codex-hooks-fixtures (child card: Codex hook JSON fixture ownership)
- _codex_core (related card: Codex hook config and gate script)
- _vscode_extension.release (related manager entrypoint ownership)
