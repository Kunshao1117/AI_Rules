---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-11T21:37:29+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-11T21:34:33+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
cycle_event_count: 2
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
- `Scripts/tests/Validate-WorkflowEightStagePlan.ps1` remains the stable route for Stage 1 through Stage 8 and Director-output semantics; it now also asserts lightweight delivery batching, the five material checkpoint categories, sibling validation/review after delivery, ordered dependent checks, post-terminal memory/docs, the no-redo-delivery rule, and plain-language progress reporting. The accepted run retained 13 Shared source/runtime hash pairs, repository-local Codex parity, and 9 passed with 0 failed.
- Its fixtures fail closed for missing memory/docs and sync evidence, allow source-level protected follow-up only as non-complete, reject captain-substituted completion, reject compliance-led Director output, and reject runtime-only sync.
- `Scripts/modules/Audit/70.DirectorOutputGrounding.ps1` is an internal Audit partial loaded by `Audit.psm1`; `Measure-DirectorOutputContract` is exported through the facade, so the old absent-command/export claim is obsolete.
- The Director-output Audit parses Markdown blocks instead of relying on a loose cross-paragraph regex. Positive and negative cases cover a missing owner, wrong marker order, missing consumer reference, duplicated consumer definition, and unrelated adjacent text; the direct source/runtime owner check returned 0 findings.
- Current supporting validation also passed D0 with 11 passed and 0 failed under `-SkipNpmAudit`, and source-size governance scanned 185 files with 17 yellow and 0 red.
- D0 and hook runner ownership remains unchanged: D0 covers source/runtime governance checks, while Codex hook tests cover the three-event `mandatory-directive-v1` model and Windows wrapper behavior.
- Shared governance reference sync includes `workflow-stage-procedures.md`, and Claude Upgrade includes root `CLAUDE.md` scanning.
## Active Constraints
- Validation fixtures are evidence contracts, not authorization or completion by themselves; missing protected memory or sync evidence remains fail-closed.
- JSON fixtures under `workflow-eight-stage/fixtures/` are tracked here for the integrated route; Codex hook JSON fixture ownership remains in `_system.scripts.codex-hooks-fixtures`.
- Memory repair does not authorize `memory_commit`, reindex, git mutation, release, deploy, install, credentials, or external mutation.
## Cycle Events
- 01: Compacted prior events and recorded 13-pair/Codex parity, eight-stage 9/9, D0 11/11 with npm audit skipped, source-size 185/17/0, structural Director-output Audit coverage, and 0 direct owner findings.
- 02: Added durable validator coverage for lightweight batching, material-only checkpoints, sibling validation/review, dependency ordering, post-terminal memory/docs, no redo-delivery, and plain-language progress reporting; the accepted route remained 9/9.
## Archive Index
- archive-002.md — script governance events 23-30; archive-001.md — older script cycle events 09-21.
## Evidence Base
- source/tool: `Scripts/tests/Validate-WorkflowEightStagePlan.ps1` and its current run — 13 Shared source/runtime hash pairs, repository-local Codex exact parity, and 9 passed / 0 failed.
- source/tool: `Scripts/tests/Validate-WorkflowEightStagePlan.ps1` now asserts the retained lightweight orchestration and reporting semantics; the accepted validation run reported 9 passed / 0 failed and its built-in parity list remains 13 Shared source/runtime pairs plus repository-local Codex parity.
- source/tool: `Scripts/modules/Audit/70.DirectorOutputGrounding.ps1` and its direct test matrix — Markdown-block owner/consumer structure, ordered markers, duplicate detection, unrelated-text allowance, and 0 source/runtime findings.
- tool: `Scripts/tests/Validate-D0Minimal.ps1 -SkipNpmAudit` passed 11/11 with npm audit skipped; `Validate-SourceSizeGovernance.ps1 -NoFail` reported 185 scanned, 17 yellow, and 0 red.
- source: `Scripts/tests/Validate-D0Minimal.ps1`, `Scripts/modules/Skills-Sync.psm1`, and `Scripts/modules/Platform-Claude.psm1` — retained D0, Shared sync, and Claude root-entry coverage.
- source: `Scripts/modules/Audit/50.CodexHookGovernance.ps1` and `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` — retained Codex hook audit/runner behavior.
## Read Contract
- Read this card for root PowerShell, Audit facade, eight-stage/D0/source-size validation, and runner ownership; use the Codex hook fixture child card for hook JSON fixtures.
## Conflicts and Supersession
- superseded: the claim that the Audit facade command/export is absent is replaced by current `Audit.psm1` loading and exporting `Measure-DirectorOutputContract`.
- completed: this cycle's `memory_commit` finished; MCP confirmed `staleness: 0`, `healthy`, and `pendingChanges: []`.
- superseded: temporary verification-target, manifest, recovery, and artifact-ledger validators or fixtures are not part of the retained script route.
## 中文摘要
- `Validate-WorkflowEightStagePlan.ps1` 仍是 Stage 1-8 與總監輸出語意的穩定驗證入口；目前也檢查輕量批次、五類重大中途檢查、交付後平行驗證／審查、相依檢查排序、不得重做交付及白話進度回報。13 組 Shared 配對與 Codex 專案內 parity 維持通過，結果為 9/9；已撤回的重型驗證機制不屬於目前驗證路徑。
- fixture 對缺少 memory/sync、隊長替代、compliance-led output 與 runtime-only sync 採 fail-closed。
- source-level protected follow-up 只能標示為尚未完整完成，不能升級為 process completion。
- `Measure-DirectorOutputContract` 已由 Audit facade 載入並匯出；舊缺失敘述已失效。
- Audit 已改用 Markdown 區塊結構檢查並涵蓋完整正反例，來源與執行副本檢查為 0 findings；D0 為 11/11，檔案大小治理為 185 scanned、17 yellow、0 red。
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
- Scripts/tests/Validate-WorkflowEightStagePlan.ps1
- Scripts/tests/workflow-eight-stage/fixtures/allow-source-level-protected-followup-pending.json
- Scripts/tests/workflow-eight-stage/fixtures/block-captain-substitute-completion.json
- Scripts/tests/workflow-eight-stage/fixtures/block-director-output-compliance-led-complete.json
- Scripts/tests/workflow-eight-stage/fixtures/block-missing-memory-docs-complete.json
- Scripts/tests/workflow-eight-stage/fixtures/block-runtime-only-sync-complete.json
- Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1
## Relations
- _system (parent card: repository governance)
- _shared (shared governance source)
- _system.scripts.codex-hooks-fixtures (child card: Codex hook JSON fixture ownership)
- _codex_core (related card: Codex hook config and gate script)
- _vscode_extension.release (related manager entrypoint ownership)
