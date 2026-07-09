---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-09T21:50:35+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T21:45:55+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 11
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
- Shared governance reference sync and audit coverage include `workflow-stage-procedures.md`; D0 validates Shared runtime references have source files plus Skills-Sync and audit-helper coverage.
- Claude Upgrade scans root `CLAUDE.md` in addition to `commands/` and `rules/`, and D0 validates this root-entry scan sentinel.
- `Scripts/tests/Validate-D0Minimal.ps1` is the D0 route for parse/import, extension JSON/runtime gates, package-lock parsing, release workflow, installer hardening including installer SHA regression sentinels, and scriptRunner guards; Doctor/Deploy Audit/manager Doctor fail closed on governance Red findings, failed audits, Team-Native hard-gate failures, and hard-policy source/deployed drift.
- Repo-managed Codex hooks/fixtures are under the hook source/deployed pair and `Scripts/tests/codex-hooks/`; the runner now validates only three mandatory directive events, official payload fields, Windows/POSIX host wrappers, directive fallback output contracts, fixture expectations, optional source/deployed hash parity including launcher, git tracking, and `commandWindows` through `cmd`/`pwsh` when available.
- Windows PowerShell 5.1 compatibility keeps hook messages ASCII-only via Base64 decoded as UTF-8; `Invoke-CodexHookFixtureTests.ps1` preserves `cmd.exe /d /s /c <commandWindows>` semantics, verifies empty stderr, checks empty-stdin wrappers, and rejects `PreToolUse` outputs that emit `permissionDecision` or `permissionDecisionReason`.
- Audit checks three-event `mandatory-directive-v1` governance for `SessionStart`, `UserPromptSubmit`, and `PreToolUse`, including non-ignorable directive markers, fallback output contracts, manifest/catalog sync, launcher-to-gate delegation, source/deployed drift, and the retained allowlist fixture.
- Current source evidence shows `Scripts/modules/Audit/50.CodexHookGovernance.ps1`, `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, and `Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json` synchronized to the mandatory directive model.
## Active Constraints
- Verify script behavior from source, runner output, Gateway evidence, and git diff; hook output is mandatory Team-Native directive context and still does not replace authorization, memory, git, release, deploy, install, or completion evidence.
- Full Doctor and `Measure-CodexHookGovernance` are non-completion evidence for non-Hooks lifecycle work.
- JSON fixture ownership belongs to `_system.scripts.codex-hooks-fixtures`; this parent card owns runner/audit/script-side behavior, and memory repair does not authorize `memory_commit`, reindex, git, release, deploy, install, credentials, or external mutation.
- Do not reintroduce active hook wording such as `提醒`, `reminder`, `advisory`, `NO_DENY_OR_BLOCK`, `REMINDER_ONLY`, `只提示`, or `不阻擋`.
- Accepted residual risks: transcript/text trace trust boundary may over-allow, write-like rule may overblock some non-source writes, `Audit.psm1` facade command is absent, and `pwsh` remains a hook-wrapper dependency.
## Cycle Events
- 09: Recorded shared governance reference coverage repair for `workflow-stage-procedures.md`, Claude root `CLAUDE.md` Upgrade scanning, and D0 guards for sync/audit/marker parity.
- 01-04: Compacted stale script-cycle noise; recorded config sync/upgrade skip repair, Stop advisory runner change, Windows PowerShell 5.1 compatibility repair, hook state-machine audit/fixture sync, source/runtime hash parity, 45-fixture validation, and accepted residual risks.
- 05-08: Compacted Measure-SkillQuality repair, audit profiles, installer SHA sentinel, ASCII Base64 hook messages, commandWindows preservation, runner/audit launcher coverage, source/runtime hook parity, and ReleaseReady tracking blockers.
- 10: Replaced script-side hook memory with the synchronized three-event reminder-only model, now superseded by event 11.
- 11: Updated runner/audit memory to `mandatory-directive-v1`: directive fallback checks require non-ignorable user/operator Team-Native context, old reminder/advisory markers are absent, and `commandWindows` host-wrapper coverage remains 12 cases.
## Archive Index
- archive-002.md — script governance events 23-30; archive-001.md — older script cycle events 09-21.
## Evidence Base
- source: `Scripts/modules/Skills-Sync.psm1`, `Scripts/modules/Audit/00.Common.ps1`, `Scripts/modules/Platform-Claude.psm1`, and `Scripts/tests/Validate-D0Minimal.ps1` current diff on 2026-07-09.
- tool: `cartridge-system__memory_status` reported `_system.scripts` content complete with stale warning before this repair on 2026-07-09.
- tool: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Scripts\tests\Validate-D0Minimal.ps1 -SkipNpmAudit` reported Passed 11, Failed 0 on 2026-07-09.
- source: `Scripts/modules/Audit/50.CodexHookGovernance.ps1` current content on 2026-07-09 declares `SessionStart`, `UserPromptSubmit`, and `PreToolUse` as mandatory directive events, checks directive markers, and recognizes `mandatory-directive-v1`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` current content on 2026-07-09 supports only three directive events, checks empty stderr/stdin wrappers, validates fallback directive output, and fails stale output markers.
- source: `Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json`, `Scripts/modules/Audit/CodexHookGovernance.catalog.json`, and `Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1`.
- source: `Scripts/tests/Validate-D0Minimal.ps1`, `Scripts/tests/Validate-SourceSizeGovernance.ps1`, and `Scripts/modules/Audit/*.ps1`.
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, and Codex hook fixtures.
- tool: full fixture run with `-VerifyRuntimeSync` passed on 2026-07-09: source/deployed sync, 6 directive fallback cases, 12 `commandWindows` host-wrapper cases, and 1 active fixture with 64 skipped legacy fixtures.
- tool: `Measure-CodexHookGovernance` passed on 2026-07-09 with `ReleaseReady=True`, `RedCount=0`, `YellowCount=0`, and no findings.
- tool: `git diff` and `git status --short` for script runner, fixture manifest, hook/config source, and authorized memory files reviewed on 2026-07-08.
- tool: `Measure-CodexHookGovernance` reported `Passed=True`, `ReleaseReady=True`, `RedCount=0`, `YellowCount=0`, and untracked required fixtures 0 on 2026-07-08.
- tool: validation station on 2026-07-08 verified Windows PowerShell and `pwsh` fixture runners at 45 passed each, parser checks, `commandWindows` host-wrapper cases, source/runtime hook hash equality, manager `-WhatIf` load paths, D0 10/10, ApplyDefault real run with full semantic table skipped, installer helper empty-string/abc behavior, and accepted review.
- director: 2026-07-08 protected memory-write instruction supplied 45-fixture validation, runtime sync evidence, manifest/catalog mirror repair, residual broader-dirty-worktree risk, and `pwsh` runtime risk.
- director: 2026-07-08 protected memory-write handoff reported validated `Scripts/modules/Audit/20.SkillQuality.ps1` fallback repair for Windows PowerShell 5.x facade import, `pwsh -NoProfile`, repo-root default skills, and fail-fast missing path handling.
- director: 2026-07-09 protected memory-write instruction supplied ASCII Base64 hook messages, commandWindows host-wrapper repair, 10 host-wrapper cases, 51-fixture two-shell validation, protected-action precedence, and source/runtime hook SHA parity.
- director/tool: 2026-07-09 team smoke reported subagent `apply_patch` create/delete and readonly `rg --files .codex Codex/.codex` both succeeded without hook blocking.
## Read Contract
- Read this card for root PowerShell, Codex hook runner, audit integration, D0/source-size validation script changes; read `_system.scripts.codex-hooks-fixtures` for JSON fixture changes/tracking.
## Conflicts and Supersession
- superseded: older runner memory that described deny/block, terminal `Stop`/`SubagentStop`, six-event hook governance, advisory, or reminder-only output is replaced by the three-event `mandatory-directive-v1` model.
- pending-follow-up: memory metadata sync remains pending until the parent opens the separate protected `memory_commit` phase; release/deploy/install remain outside this memory write.
## 中文摘要
- Shared governance reference sync/audit 清單已補 `workflow-stage-procedures.md`，D0 會檢查 runtime `.agents/shared` 引用都有 source、sync 與 audit 覆蓋。
- Claude Upgrade 現在掃 root `CLAUDE.md`，D0 也加入 sentinel。
- 此子卡負責根層 PowerShell 腳本、Audit 模組、D0/source-size 驗證與 Codex hook runner；hook runner/audit 現在以 `SessionStart`、`UserPromptSubmit`、`PreToolUse` 三項強制規範注入為準。
- `PreToolUse` 測試模型檢查 `mandatory-directive-v1`、不可忽略標記與使用者/操作者 Team-Native 要求，不再使用提醒式字句。
- JSON fixtures 歸屬在 child card；本卡只記錄 runner、Audit 與 script-side 行為，且不授權 `memory_commit`、git、release、deploy、install 或外部變更。
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
