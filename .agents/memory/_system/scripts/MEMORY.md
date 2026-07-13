---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-13T22:56:40+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-07-13T22:52:03+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
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
# _system.scripts — Repository Script Governance Memory
## Current Truth
- This card covers root PowerShell deployment, audit modules, memory migration, skill/platform sync, validation, and runner ownership; tracked source remains runtime authority.
- The hook fixture runner defaults to `pwsh`; an alternate shell is explicit through `-Shell`, unavailable shells are skipped unless `-RequireAllShells` is set. Windows PowerShell 5.1 is therefore opt-in and best-effort, not a default guarantee.
- The V1 subagent contract runner is static source-contract evidence only: it owns six simplified watcher cases for the experimental boundary, exact pattern/replacement/count behavior, multi-match replacement, and zero-match preservation.
- Hook observations are fixture evidence, not runtime guarantees. The hook fixture runner and V1 subagent contract runner are distinct surfaces.
- `Scripts/Watch-CodexModelV1.ps1` is a local experimental workaround, not a formal Codex adapter capability or platform guarantee. It performs whole-file regex replacement for all exact `multi_agent_version: v2` matches, reports the match count, and leaves zero-match content unchanged; the prior exact-one and guarded byte-local safeguards were intentionally removed by Director decision.

## Active Constraints
- Validation fixtures are evidence contracts, not authorization or completion evidence.
- Memory updates require a separate authorized `memory_commit`; this card does not claim that commit has run. Actual cache/runtime behavior was not executed in this delivery and remains unverified.

## Cycle Events
- 01: Compacted prior script-governance events and retained source/runtime validation ownership.
- 02: Recorded lightweight workflow validation, protected follow-up limits, and structural Director-output audit coverage.
- 03: Reverified pwsh-default hook fixtures, explicit alternate-shell handling, and the separate V1 adapter-contract runner.
- 04: Replaced the watcher’s exact-one guarded byte-local contract with the Director-approved all-match whole-file regex behavior and six static watcher cases.

## Archive Index
- archive-002.md — script governance events 23-30; archive-001.md — older events 09-21.

## Evidence Base
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` — default shell selection, explicit shell override, fixture handling, and hook-runner scope.
- source: `Scripts/tests/codex-subagents/Invoke-CodexSubagentV1ContractFixtureTests.ps1` — six static watcher cases cover the experimental boundary, exact pattern/replacement/count behavior, multi-match replacement, and zero-match preservation; never runs the watcher or a user cache.
- source: `Scripts/Watch-CodexModelV1.ps1` — all-match whole-file regex replacement, match-count reporting, zero-match preservation, and non-guarantee boundary.
- director: 2026-07-13 — intentionally remove the prior exact-one and guarded byte-local watcher safeguards.

## Read Contract

- Read for root PowerShell, audit/validation scripts, and the separate hook or V1 runner contracts.

## Conflicts and Supersession

- superseded: treating fixture observations as runtime capability guarantees or merging hook and V1 runner responsibilities.
- superseded: exact-one guarded byte-local watcher writes and their attempt/verification state classification.

## 中文摘要

- hook fixture 預設使用 `pwsh`；Windows PowerShell 5.1 必須明確指定，且僅屬盡力支援，不是預設保證。
- hook 與 V1 subagent runner 是不同測試面；兩者輸出都不能推論為平台執行期保證。
- watcher 是本機實驗性 workaround；目前會對所有精確 `multi_agent_version: v2` 做整檔 regex 取代並回報數量，零匹配保持不變，先前 exact-one 與 guarded byte-local 防線已依總監決定移除。
- fixture 僅持有六個簡化 watcher 靜態契約案例；本次未執行 actual cache/runtime，相關行為仍未驗證。

## Tracked Files

- Scripts/Deploy.ps1
- Scripts/Watch-CodexModelV1.ps1
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
- Scripts/tests/Validate-WorkflowEightStagePlan.ps1
- Scripts/tests/workflow-eight-stage/fixtures/allow-source-level-protected-followup-pending.json
- Scripts/tests/workflow-eight-stage/fixtures/block-captain-substitute-completion.json
- Scripts/tests/workflow-eight-stage/fixtures/block-director-output-compliance-led-complete.json
- Scripts/tests/workflow-eight-stage/fixtures/block-missing-memory-docs-complete.json
- Scripts/tests/workflow-eight-stage/fixtures/block-runtime-only-sync-complete.json
- Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1
- Scripts/tests/codex-subagents/Invoke-CodexSubagentV1ContractFixtureTests.ps1

## Relations

- _system (parent governance); _shared (Shared policy); _codex_core (adapter contract).

## Applicable Skills

- memory-ops — authorized source-memory update and separate commit procedure.
