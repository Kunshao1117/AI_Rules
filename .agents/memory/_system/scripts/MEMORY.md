---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-09T17:01:09+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T16:56:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 9
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
- Repo-managed Codex hooks/fixtures are under the hook source/deployed pair and `Scripts/tests/codex-hooks/`; the runner validates active event coverage, official payload fields, Windows/POSIX host wrappers, fixture expectations, optional source/deployed hash parity including launcher, git tracking, Stop advisory allow outputs, and `commandWindows` through `cmd`/`pwsh` when available.
- Windows PowerShell 5.1 compatibility keeps hook messages ASCII-only via Base64 decoded as UTF-8; `Invoke-CodexHookFixtureTests.ps1` preserves `cmd.exe /d /s /c <commandWindows>` command-string semantics, its PowerShell wrapper launches `cmd`, and commandWindows coverage includes PreToolUse/SessionStart non-repo process CWD plus `payload.cwd` repo-root resolver cases.
- Audit checks authorization semantics, trusted tool envelope/receipt validity, formal-write/protected gates, trace non-authorization, workflow references/scenarios, Team-Native semantics, mixed completion wording, hook state-machine governance, manifest/catalog sync, launcher-to-gate delegation, source/deployed drift, and tracking readiness.
- Current validation evidence reports 10 host-wrapper cases passed, Windows PowerShell and `pwsh` fixture runners each passed 65 fixtures, source/runtime hooks/gate/launcher SHA parity was true, Zone.Identifier streams were absent, and hook governance returns `ReleaseReady=false` until the source launcher plus 14 required fixtures are tracked.
## Active Constraints
- Verify script behavior from source, runner output, Gateway evidence, and git diff; hook diagnostics/deny decisions are tool-guard evidence only, while authorization, memory, git, release, deploy, install, and completion gates remain separate protected phases.
- Full Doctor and `Measure-CodexHookGovernance` are non-completion evidence for non-Hooks lifecycle work.
- JSON fixture ownership belongs to `_system.scripts.codex-hooks-fixtures`; this parent card owns runner/audit/script-side behavior, and memory repair does not authorize `memory_commit`, reindex, git, release, deploy, install, credentials, or external mutation.
- Accepted residual risks: transcript/text trace trust boundary may over-allow, write-like rule may overblock some non-source writes, `Audit.psm1` facade command is absent, and `pwsh` remains a hook-wrapper dependency.
## Cycle Events
- 09: Recorded shared governance reference coverage repair for `workflow-stage-procedures.md`, Claude root `CLAUDE.md` Upgrade scanning, and D0 guards for sync/audit/marker parity.
- 01-04: Compacted stale script-cycle noise; recorded config sync/upgrade skip repair, Stop advisory runner change, Windows PowerShell 5.1 compatibility repair, hook state-machine audit/fixture sync, source/runtime hash parity, 45-fixture validation, and accepted residual risks.
- 05: Repaired Measure-SkillQuality Windows PowerShell 5.x fallback to import the split Audit facade via resolved path, run pwsh with -NoProfile, resolve default Shared\skills from repo root, and fail fast on missing facade/default root.
- 06: Recorded ApplyDefault/Full audit profiles, D0 installer SHA sentinel, and accepted validation summary.
- 07: Recorded ASCII Base64 hook messages, commandWindows cmd-string host-wrapper preservation, 10 host-wrapper cases, 51-fixture two-shell validation, source/runtime hook SHA parity, and protected-action precedence.
- 08: Recorded launcher-aware runner/audit coverage, 65-fixture two-shell validation, 10 commandWindows cases, source/runtime launcher parity, and ReleaseReady tracking blockers.
## Archive Index
- archive-002.md — script governance events 23-30; archive-001.md — older script cycle events 09-21.
## Evidence Base
- source: `Scripts/modules/Skills-Sync.psm1`, `Scripts/modules/Audit/00.Common.ps1`, `Scripts/modules/Platform-Claude.psm1`, and `Scripts/tests/Validate-D0Minimal.ps1` current diff on 2026-07-09.
- tool: `cartridge-system__memory_status` reported `_system.scripts` content complete with stale warning before this repair on 2026-07-09.
- tool: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Scripts\tests\Validate-D0Minimal.ps1 -SkipNpmAudit` reported Passed 11, Failed 0 on 2026-07-09.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, `Scripts/modules/Audit/50.CodexHookGovernance.ps1`, `Scripts/modules/Audit/CodexHookGovernance.catalog.json`, and `Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1`.
- source: `Scripts/tests/Validate-D0Minimal.ps1`, `Scripts/tests/Validate-SourceSizeGovernance.ps1`, and `Scripts/modules/Audit/*.ps1`.
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, and Codex hook fixtures.
- tool: Gateway `memory_audit`, `memory_status`, and `memory_read` on 2026-07-08.
- tool: `git diff` and `git status --short` for script runner, fixture manifest, hook/config source, and authorized memory files reviewed on 2026-07-08.
- tool: `Measure-CodexHookGovernance` reported `Passed=True`, `ReleaseReady=True`, `RedCount=0`, `YellowCount=0`, and untracked required fixtures 0 on 2026-07-08.
- tool: validation station on 2026-07-08 verified Windows PowerShell and `pwsh` fixture runners at 45 passed each, parser checks, `commandWindows` host-wrapper cases, source/runtime hook hash equality, manager `-WhatIf` load paths, D0 10/10, ApplyDefault real run with full semantic table skipped, installer helper empty-string/abc behavior, and accepted review.
- director: 2026-07-08 protected memory-write instruction supplied 45-fixture validation, runtime sync evidence, manifest/catalog mirror repair, residual broader-dirty-worktree risk, and `pwsh` runtime risk.
- director: 2026-07-08 protected memory-write handoff reported validated `Scripts/modules/Audit/20.SkillQuality.ps1` fallback repair for Windows PowerShell 5.x facade import, `pwsh -NoProfile`, repo-root default skills, and fail-fast missing path handling.
- director: 2026-07-09 protected memory-write instruction supplied ASCII Base64 hook messages, commandWindows host-wrapper repair, 10 host-wrapper cases, 51-fixture two-shell validation, protected-action precedence, and source/runtime hook SHA parity.
- tool: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 -RequireAllShells -VerifyRuntimeSync` reported source/deployed sync verified, commandWindows host-wrapper checks passed 10 cases, 65 fixtures passed across 2 shells, and fixture tracking was 51 tracked/14 untracked on 2026-07-09.
- tool: `Measure-CodexHookGovernance` reported `Status=Checked`, `ReleaseReady=False`, `RedCount=1`, `YellowCount=14`, and `UntrackedRequiredFixtureCount=14` on 2026-07-09.
## Read Contract
- Read this card for root PowerShell, Codex hook runner, audit integration, D0/source-size validation script changes; read `_system.scripts.codex-hooks-fixtures` for JSON fixture changes/tracking.
## Conflicts and Supersession
- superseded: older runner memory that only described reminder/deny behavior is replaced by active-event, official-payload, host-wrapper, and Stop/SubagentStop validation coverage.
- pending-follow-up: hook-runner/audit behavior changes remain owned by the separate hooks lane; release/deploy/install remain outside this sync repair.
## 中文摘要
- Shared governance reference sync/audit 清單已補 `workflow-stage-procedures.md`，D0 會檢查 runtime `.agents/shared` 引用都有 source、sync 與 audit 覆蓋。
- Claude Upgrade 現在掃 root `CLAUDE.md`，D0 也加入 sentinel。
- 此子卡負責根層 PowerShell 腳本、Audit 模組、D0/source-size 驗證與 Codex hook runner；runner 現在也檢查 launcher source/runtime parity、commandWindows resolver 與 65 個 fixtures。
- 本機驗證回報 host-wrapper 10 cases、Windows PowerShell 與 `pwsh` fixture runners 各 65 passed、source/runtime hooks/gate/launcher SHA parity true、Zone.Identifier absent；Audit 仍標記 `ReleaseReady=false`，直到 source launcher 與 14 required fixtures 被追蹤。
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
