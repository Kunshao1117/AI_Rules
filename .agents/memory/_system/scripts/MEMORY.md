---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-07T22:47:00+08:00'
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
cycle_id: 2026-06-15-001
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
- This memory card is a source/status pointer for script ownership and validation context; it is not a runtime governance rule source.
- Canonical behavior and runtime rules live in tracked `Scripts/**` source files plus referenced Shared policies/skills; this card owns root PowerShell deployment, split Audit module scripts, audit tests, memory migration, skill sync, platform sync, and D0/source-size validation scripts.
- `Scripts/tests/Validate-D0Minimal.ps1` is the D0 minimal validation route for parse/import, extension JSON/runtime gates, package-lock parsing, release workflow, installer hardening, and scriptRunner guards; `Read-PackageLockSummary` feeds Node through stdin and reads `process.argv[2]`.
- Doctor, Deploy Audit, and manager Doctor fail closed on governance-audit Red findings, failed audit results, Team-Native hard-gate failures, and hard-policy source/deployed drift.
- Repo-managed Codex Hooks and fixtures are under the Codex hook source/deployed pair and `Scripts/tests/codex-hooks/`; the runner validates hook config/script presence, commandWindows host-wrapper cases, fixture expectations, optional source/deployed hash parity, and git tracking.
- Audit checks authorization semantics, trusted tool envelope/receipt validity, formal-write/protected gates, trace non-authorization, workflow references, scenario templates, Team-Native semantics, mixed completion wording, and source/deployed drift.
- Doctor/Audit enforce Team-Native trace fields, role identity, loaded skills, handoff packets, delivery artifacts, lifecycle fields, closeout lanes, captain-authoring safety, active-Team captain-led station ownership, and downstream `.agents/` shared-reference/project-tool sync.
- Audit reports Director-facing diagnostics in Traditional Chinese with exact machine tokens, output-quality coverage, high-change external-grounding coverage, active/inactive Team context separation, `03-1` reduced/minimal experiment boards, non-Hooks channel lifecycle, and empty parent/index `## Tracked Files` delegation evidence.
- Ownership status: new Codex hook governance catalog sources are present at `Scripts/modules/Audit/CodexHookGovernance.catalog.json` and `Scripts/modules/Audit/CodexHookGovernance/Catalog.ps1`; cartridge metadata sync is handled through protected `memory_commit`.
## Active Constraints
- Do not use this card as runtime authority for current governance behavior; verify current behavior from the canonical script and policy sources.
- External repository and deployment target mutations are protected states with explicit Director approval evidence.
- Script behavior alignment target includes protected memory and project-skill directories.
- Current script implementation is the source context for edits; this card is not a substitute source.
- Treat `Measure-WorkflowMetadata` and `Measure-GovernanceSemantics` Red 0 / Yellow 0 as upstream validation evidence unless the current station reruns those checks.
- Treat hook diagnostics and deny decisions as tool-guard evidence only; authorization, memory, git, release, deploy, install, and completion gates remain separate protected phases.
- Full Doctor and `Measure-CodexHookGovernance` are non-completion evidence for non-Hooks lifecycle work.
- Treat D0 minimal validation as source-side sentinel evidence; deployed parity still requires the governed sync/parity route.
## Cycle Events
- 61: Repaired ownership for source-size governance validation and split Audit module scripts in `## Tracked Files`.
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
- source: Scripts/tests/Validate-SourceSizeGovernance.ps1 and Scripts/modules/Audit/*.ps1 — source-size and split Audit ownership scope.
- source: Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 and codex hook fixtures for current reminder/deny behavior.
- source: Scripts/tests/Validate-D0Minimal.ps1 — D0 minimal validation checks and sentinel scope.
- source: Scripts/tests/Validate-D0Minimal.ps1 — `Read-PackageLockSummary` uses stdin-fed Node script with `process.argv[2]`.
- tool: commit preflight identified active-card compaction due on 2026-06-30.
- director: 2026-06-30 GO authorized compaction of the four blocking memory cards.
## Read Contract
- This card is read context for root PowerShell script changes; `_system.scripts.codex-hooks-fixtures` is read context for Codex hook JSON fixture changes.
- `_system` is repository-level governance and release context for high-risk script changes.
## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責根層 PowerShell 腳本、Audit 模組拆分腳本與 D0/source-size 驗證腳本。
- Doctor/Audit 檢查任務板、交付件、完成閘門、授權解析、Team-Native trace 與 hard gates。
- repo-managed Codex Hooks runner 由本卡治理；JSON fixtures 由 child card 歸屬。
- Audit 覆蓋父索引卡 ownership、`03-1` 實驗板、非 Hooks 通道生命週期、總監輸出品質與外部接地查證。
- active Team trace 中主線自動擔任隊長，但不能把隊長代工當成站點交付。
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
- _vscode_extension.release (related manager entrypoint ownership)
