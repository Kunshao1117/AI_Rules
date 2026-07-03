---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-03T21:01:17+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-03T20:57:12+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 10
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
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
- Doctor and Deploy Audit now fail closed when the governance audit returns Red findings or a failed result; core policy drift remains Red for hard-policy pairs.
- Repo-managed Codex Hooks and fixtures are removed and rebuild pending; `Measure-CodexHookGovernance` reports all-absent hook artifacts as `RemovedRebuildPending`, `Skipped=True`, `RebuildPending=True`, Red 0, Yellow 0, and Passed True.
- Audit now checks Batch 3 分相授權治理規則：workflow metadata, shared workflow-stage procedures, and governance wording must show `GO` as scope-bound intent, not blanket authorization, with formal-write/protected phases bound through authorization resolution.
- Doctor, Deploy Audit, and manager Doctor entrypoints must not silently pass failed Team-Native hard gates; Red findings and failed audit results are blocking evidence for clean release.
- Audit now checks trusted tool execution envelope and matching receipt semantics for protected operations: trusted issuer, signature, nonce, same envelope id or nonce, allowed receipt decision, matching action/target/scope, invalid-payload fail-closed behavior, self-reported envelope denial, only-envelope/only-receipt denial, mismatched receipt denial, and legacy trace handling that does not treat old traces as current authorization.
- Audit and Skills-Sync now include workflow-orchestration and workflow-orchestration-scenarios as shared governance references, checking workflow-entry coverage, scenario templates, source/deployed drift, Team-Native semantics, and mixed completion/non-completion wording.
- This child card owns root PowerShell deployment, audit, memory migration, skill sync, and platform sync scripts.
- Doctor/Audit enforce Team-Native ordering, scoped authorization fields, role identity, loaded skill refs, handoff packets, trace parameters, delivery artifact IDs, lifecycle fields, closeout lanes, and captain-authoring safety.
- Governance sync and Doctor include authorization-resolution policy, source/deployed drift checks, exact SHA256 comparison for deploy-copy paths, forbidden authorization semantic scans, and downstream `.agents/` shared-reference/project-tool sync.
- Audit now formats Director-facing missing-field and Team Trace diagnostics as Traditional Chinese meaning plus exact machine token, uses Chinese-first Doctor section headings, and keeps machine identifiers unchanged for precision.
- Audit now recognizes captain coordination and authorized change-application wording: `captain_coordination_read_scope` replaces captain verify-read fields, and implementation direct checks look for explicit change-application gates rather than captain integration.
- Audit includes non-Hooks Team-Native channel lifecycle checks: status probes require pause/report plus explicit captain resume, timeouts do not equal failure/cancel/reject, replacement does not equal cancellation, late results need receipt decisions, and pending lifecycle state cannot be reported complete.
- Audit now checks active memory cards with empty `## Tracked Files`: parent/index cards avoid Yellow only when child card directories, `## Relations` child/index wording, and navigation evidence prove concrete file ownership is delegated.
- Audit now distinguishes active Team context from inactive ordinary lifecycle: governed user requests, including `03-1` experiment requests, activate Team mode; without a current governed request, no-write exploration, no-write/no-team, and standby trace findings are not active-Team Red findings.
- Audit checks `03-1` entries for governed-request Team mode activation, reduced/minimal experiment station/board, sandbox scope, discard/promotion conditions, allowed shortcuts, and no production completion claim.
- Audit treats active-Team traces as captain-led: the mainline/main agent is captain, while implementation, review, validation, and memory/docs evidence stay station-owned unless explicitly closed as blocked, unverified, or Director-risk.
- `Invoke-PlatformGovernanceAudit` still runs `Measure-SkillQuality`, now includes TeamTraceEvidence active/inactive semantics, and reports Director-facing output quality plus high-change external grounding coverage before commit readiness.
## Active Constraints
- Do not mutate external repositories or deployment targets without explicit Director approval.
- Keep script behavior aligned with protected memory and project-skill directories.
- Do not use this card as a substitute for reading the current script implementation before edits.
- Treat `Measure-WorkflowMetadata` and `Measure-GovernanceSemantics` Red 0 / Yellow 0 as upstream validation evidence unless the current station reruns those checks.
- Treat absent repo-managed Codex hook artifacts as rebuild pending, not a Red missing-file condition, while the rebuild-pending slot remains current.
- Do not use full Doctor or `Measure-CodexHookGovernance` as completion evidence for non-Hooks lifecycle work while Hooks remain explicitly out of scope.
## Cycle Events
- 58: Recorded Audit dual-gate coverage: Director-facing output quality and high-change external grounding checks are part of platform governance audit results.
- 57: Corrected Audit memory: governed requests, including `03-1`, auto-activate Team mode; absent current governed requests cannot self-start team work; TeamTrace legacy partial text stays non-authorizing evidence.
- 56: Recorded Audit memory-card parent/index ownership check: empty `## Tracked Files` is Yellow unless child card directories, Relations child/index wording, and navigation evidence prove delegated file ownership.
- 55: Recorded non-Hooks Audit lifecycle coverage: parser/import passed, GovernanceSemantics, ProgrammingTeamGovernanceCoverage, TeamNativeCoreSemantics, TeamTraceEvidence, SharedSubagentPolicyDrift, and team-task-board SkillQuality all returned Red 0 / Yellow 0.
- 54: Recorded repo-managed Codex Hooks removal: hook child memory card deleted, parent card owns rebuild-pending state, and Audit.psm1 missing-artifact handling stays RemovedRebuildPending with Red 0 / Yellow 0 / Passed True.
- 53: Recorded Batch 3 Audit semantics coverage for scope-bound GO, phase-specific authorization resolution, formal-write/protected gates, and upstream Measure-WorkflowMetadata plus Measure-GovernanceSemantics Red 0 / Yellow 0 evidence.
- 51: Recorded Audit governance updates for `captain_coordination_read_scope`, authorized change-application gates, and Team Trace protected-action pattern coverage.
- 45-50: Consolidated trusted envelope/receipt, diagnostic-label, payload-guard, source-of-truth policy, and governance fail-closed hardening into Current Truth.
- 39-44: Consolidated historical Codex hook fixture and stability coverage into the rebuild-pending summary after repo-managed hooks were removed.
- 31-38: Consolidated Team-Native trace, operation-mode, workflow orchestration, source/deployed drift, and formal-readonly coverage into Current Truth and archives.
## Archive Index
- archive-002.md — Script governance events 23-30 compacted on 2026-06-30.
- archive-001.md — Older script cycle events 09-21 compacted from the active card.
## Evidence Base
- source: Scripts/modules/Audit.psm1 and related root PowerShell scripts.
- tool: commit preflight identified active-card compaction due on 2026-06-30.
- director: 2026-06-30 GO authorized compaction of the four blocking memory cards.
## Read Contract
- Read this card when changing root PowerShell scripts.
- Read `_system` for repository-level governance and release context before high-risk script changes.
## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責根層 PowerShell 腳本。
- Doctor 會檢查任務板、交付件、完成閘門、任務軌跡、授權解析與 Team-Native 硬閘門。
- repo-managed Codex Hooks 與 fixtures 已移除並待重建；Audit 保留 rebuild-pending slot，不把全數缺檔判成 Red。
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
## Relations
- _system (parent card: repository governance)
- _shared (shared governance source)
- _vscode_extension.release (related manager entrypoint ownership)
