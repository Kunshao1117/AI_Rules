---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-07T05:53:55+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-07T05:53:55+08:00'
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

# _system.scripts — Repository Script Governance Memory
## Current Truth
- This child card owns root PowerShell deployment, audit, memory migration, skill sync, platform sync, and D0 minimal validation scripts.
- `Scripts/tests/Validate-D0Minimal.ps1` is the D0 minimal validation route for source sentinels covering PowerShell parse/import, extension JSON/runtime gates, package-lock parsing, release workflow, installer hardening, and scriptRunner guards.
- `Read-PackageLockSummary` feeds the inline Node parser through stdin and reads the package-lock path from `process.argv[2]`, matching `node - <path>` invocation semantics.
- Doctor, Deploy Audit, and manager Doctor fail closed on governance-audit Red findings, failed audit results, and Team-Native hard-gate failures; core policy drift remains Red for hard-policy pairs.
- Repo-managed Codex Hooks and fixtures are committed under the Codex hook source/deployed pair and `Scripts/tests/codex-hooks/`; the runner validates hook config/script presence, commandWindows host-wrapper cases, fixture expectations, optional source/deployed hash parity, and git tracking.
- Audit checks scope-bound Batch 3 authorization semantics, trusted tool envelope/receipt validity, formal-write/protected gates, and legacy trace non-authorization.
- Audit and Skills-Sync cover workflow-orchestration shared references, source/deployed drift, scenario templates, Team-Native semantics, and mixed completion wording.
- Doctor/Audit enforce Team-Native trace fields, role identity, loaded skills, handoff packets, delivery artifacts, lifecycle fields, closeout lanes, captain-authoring safety, and active-Team captain-led station ownership.
- Governance sync and Doctor include authorization-resolution policy, exact SHA256 deploy-copy drift checks, forbidden authorization semantic scans, and downstream `.agents/` shared-reference/project-tool sync.
- Audit reports Director-facing diagnostics in Traditional Chinese with exact machine tokens, and includes output-quality plus high-change external-grounding coverage before commit readiness.
- Audit distinguishes active Team context from inactive ordinary lifecycle, covers `03-1` reduced/minimal experiment boards, and checks non-Hooks channel lifecycle plus empty parent/index `## Tracked Files` delegation evidence.
## Active Constraints
- Do not mutate external repositories or deployment targets without explicit Director approval.
- Keep script behavior aligned with protected memory and project-skill directories.
- Do not use this card as a substitute for reading the current script implementation before edits.
- Treat `Measure-WorkflowMetadata` and `Measure-GovernanceSemantics` Red 0 / Yellow 0 as upstream validation evidence unless the current station reruns those checks.
- Treat hook diagnostics and deny decisions as tool-guard evidence only; authorization, memory, git, release, deploy, install, and completion gates remain separate protected phases.
- Do not use full Doctor or `Measure-CodexHookGovernance` as completion evidence for non-Hooks lifecycle work.
- Treat D0 minimal validation as source-side sentinel evidence; deployed parity still requires the governed sync/parity route.
## Cycle Events
- 60: Recorded D0 package-lock Node stdin/argv fix and current Codex hook runner ownership, with JSON fixtures delegated to the child card.
- 59: Updated Audit hook governance for reminder and deny paths: SessionStart/outer-agent/single-file cases may allow with reminders, while direct unstationed repo-inventory scans deny; Doctor still checks source/deployed parity and git tracking.
- 58: Recorded Audit dual-gate coverage: Director-facing output quality and high-change external grounding checks are part of platform governance audit results.
- 57: Corrected Audit memory: governed requests, including `03-1`, auto-activate Team mode; absent current governed requests cannot self-start team work; TeamTrace legacy partial text stays non-authorizing evidence.
- 56: Recorded Audit memory-card parent/index ownership check: empty `## Tracked Files` is Yellow unless child card directories, Relations child/index wording, and navigation evidence prove delegated file ownership.
- 55: Recorded non-Hooks Audit lifecycle coverage: parser/import passed, GovernanceSemantics, ProgrammingTeamGovernanceCoverage, TeamNativeCoreSemantics, TeamTraceEvidence, SharedSubagentPolicyDrift, and team-task-board SkillQuality all returned Red 0 / Yellow 0.
- 53: Recorded Batch 3 Audit semantics coverage for scope-bound GO, phase-specific authorization resolution, formal-write/protected gates, and upstream Measure-WorkflowMetadata plus Measure-GovernanceSemantics Red 0 / Yellow 0 evidence.
- 51: Recorded Audit governance updates for `captain_coordination_read_scope`, authorized change-application gates, and Team Trace protected-action pattern coverage.
- 45-50: Consolidated trusted envelope/receipt, diagnostic-label, payload-guard, source-of-truth policy, and governance fail-closed hardening into Current Truth.
- 31-38: Consolidated Team-Native trace, operation-mode, workflow orchestration, source/deployed drift, and formal-readonly coverage into Current Truth and archives.
## Archive Index
- archive-002.md — Script governance events 23-30 compacted on 2026-06-30.
- archive-001.md — Older script cycle events 09-21 compacted from the active card.
## Evidence Base
- source: Scripts/modules/Audit.psm1 and related root PowerShell scripts.
- source: Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 and codex hook fixtures for current reminder/deny behavior.
- source: Scripts/tests/Validate-D0Minimal.ps1 — D0 minimal validation checks and sentinel scope.
- source: Scripts/tests/Validate-D0Minimal.ps1 — `Read-PackageLockSummary` uses stdin-fed Node script with `process.argv[2]`.
- tool: commit preflight identified active-card compaction due on 2026-06-30.
- director: 2026-06-30 GO authorized compaction of the four blocking memory cards.
## Read Contract
- Read this card when changing root PowerShell scripts.
- Read `_system.scripts.codex-hooks-fixtures` when changing Codex hook JSON fixtures.
- Read `_system` for repository-level governance and release context before high-risk script changes.
## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責根層 PowerShell 腳本。
- Doctor 會檢查任務板、交付件、完成閘門、任務軌跡、授權解析與 Team-Native 硬閘門。
- repo-managed Codex Hooks 與 fixture runner 已提交；父卡負責 runner/腳本治理，JSON fixtures 由 child card 具體歸屬。
- Audit 另有非 Hooks 隊員通道生命週期檢查：探針必須暫停回報並等待恢復，晚回需要接收決策；本批未處理 Hooks。
- Audit 會檢查父索引記憶卡空 `Tracked Files`：只有具備子卡目錄、關係段落與導覽證據時才不是黃燈。
- Audit 現在把受治理請求與 `03-1` 實驗請求視為 Team mode 啟動來源；未有目前受治理請求時，AI 不能自行啟動團隊工作。
- active Team trace 中主線自動擔任隊長，但不能把隊長代工當成站點交付。
- Audit 會檢查 `03-1` 是否具備 reduced/minimal experiment board、sandbox scope、discard/promotion condition、allowed shortcuts 與不得宣稱 production completion。
- Audit 現在也回報總監可讀輸出品質與高變動外部接地查證覆蓋，提交前缺 gate 會被攔出。
## Tracked Files
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1
- Scripts/modules/Memory-Migration.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
- Scripts/tests/Validate-D0Minimal.ps1
- Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1
## Relations
- _system (parent card: repository governance)
- _shared (shared governance source)
- _system.scripts.codex-hooks-fixtures (child card: Codex hook JSON fixture ownership)
- _vscode_extension.release (related manager entrypoint ownership)
