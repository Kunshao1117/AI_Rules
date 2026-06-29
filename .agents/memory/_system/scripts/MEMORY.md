---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-29T09:41:05+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-29T07:10:01+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 30
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
- Governance Doctor now checks scoped authorization fields across Team-Native policies, task board, specialist outputs, delivery artifact contracts, role boundaries, completion gate, and task traces.
- Governance sync and Doctor now include the authorization-resolution policy, scoped authorization trace fields, core-rule order checks, deployed-copy drift checks, and forbidden authorization semantic scans.
- Shared skill and shared governance sync now supports exact SHA256 comparison for deploy-copy paths, so Deploy Sync can clear the same raw-hash drift that Doctor reports.
- Framework file comparison no longer trusts matching timestamps as proof of equality; timestamp-equal drift must still pass content or exact-hash comparison.
- Governance Doctor now enforces draft/formal board lifecycle, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, and no post-board all-at-once semantics on shared governance and three-platform workflow entries.
- Governance Doctor now checks specialist lifecycle fields, closeout lane, Yellow classification/resolution, repair loop count, and deployment drift closure so Yellow findings cannot become infinite repair loops.
- Governance Doctor now includes Team-Native Core semantic checks and optional strict Team-Native trace validation.
- Governance Doctor now validates direct-renamed team task board and delivery artifact semantics, including assigned specialist skill, domain label, requested execution channel, channel capability, channel invocation status, delivery artifact type, and delivery artifact status.
- Governance Doctor now treats `closed-with-director-risk` as non-complete Director risk closure, while old accepted-risk/packet wording remains legacy detection only.
- The platform governance audit entrypoint explicitly declares RequireTeamTrace and TeamTraceRoot, so strict trace enforcement does not rely on outer script variables.
- Governance Doctor rejects team-task-board direct exceptions that rely on allowed-small, tiny known file set, or direct single-step wording.
- Governance Doctor rejects missing implementation change delivery, memory/docs delivery, review delivery, and validation delivery artifact requirements, unbounded implementation direct modes, stale direct-write workflow phrases, and old direct-exception shortcuts.
- Governance Doctor now checks team-task-board existence, template fields, workflow task-board references, and old long inline team-rule duplication.
- Governance Doctor checks task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, `closed-with-director-risk`, pre-board specialist guards, 05 condense coverage, and captain over-direct semantics for programming-team governance.
- Governance Doctor checks Captain Trigger Gate, Captain Team Board, role boundary, isolated change delivery, no-self-review, 00/01 automatic routing, experiment boundaries, source/deployed hash drift, and bilingual negative-context wording.
- Codex workflow skill merge includes the `_shared` support directory so deployed workflows can inherit gates.
- Project rule sync and platform deploy scripts copy restricted project-local tools from `Shared/project-tools/` into downstream `.agents/tools/`.
- The source manager memory migration entrypoint delegates to the shared project-tool implementation so source-manager and downstream behavior stay aligned.
- Project rule sync and platform deploy scripts copy the full shared governance reference set into `.agents/shared/`, including matrices, skill governance, subagent policy, and MCP profile snippets.
- Manager and deploy audit entrypoints can pass RequireTeamTrace and TeamTraceRoot into platform governance audit.
- This child card owns root PowerShell deployment, audit, memory migration, skill sync, and platform sync scripts.
- Governance Doctor covers review governance, programming-team governance, station state guards, delegation order guards, experiment minimum-board checks, direct exceptions, fake-team guards, review evidence boundaries, browser branch downgrade guards, and three-platform entrypoint coverage.
- Skill quality scanning now normalizes line endings before estimating token length so managed cache checkouts and source checkouts report consistent results.
- Project skill backfill safely migrates physical discovery skill directories or exact/safe routing stubs before rebuilding discovery links.
- The root `_system` card keeps repository identity, documentation, license, and top-level governance truth.
- Public PowerShell entrypoints must preserve UTF-8 compatibility for Windows PowerShell 5.1.
## Active Constraints
- Do not mutate external repositories or deployment targets without explicit Director approval.
- Keep script behavior aligned with protected memory and project-skill directories.
- Do not use this card as a substitute for reading the current script implementation before edits.

## Cycle Events
- 30: Added authorization-resolution shared reference sync plus Doctor checks for authorization fields, core priority order, delivery artifact contracts, task-board completeness, source/deployed policy drift, and forbidden mode/workflow/button authorization semantics.
- 29: Fixed Deploy Sync false-negative drift detection by adding exact-hash comparison for shared skill and shared governance copy paths; source/deployed hashes now match after sync.
- 28: Added Doctor checks for specialist lifecycle fields, fast closeout lanes, Yellow classification/resolution, repair loop limits, and deployed-copy drift closure; Doctor and Deploy Audit returned red 0 / yellow 0.
- 27: Re-saved Audit module as UTF-8 BOM to clear Windows PowerShell parser failure; no audit logic changed, parser diagnostics are zero.
- 26: Added relation checks for `closed-with-director-risk`, missing delivery artifacts, self-review, early review/validation, all-at-once dispatch, and source/deployed Team-Native drift.
- 25: Hardened Audit.psm1 around direct-renamed delivery artifacts and assignment/channel trace fields; old patch wording remains only as legacy detection.
- 24: Fixed Team-Native legacy-wording conflict, synchronized policy marker checks, and verified Doctor/Audit green with strict trace.
- 23: Updated script memory for Team-Native specialist fields, change delivery artifact checks, and strict trace validation.
- 22: Declared strict Team-Native trace parameters on the platform governance audit entrypoint and verified Doctor/Audit green.

## Archive Index
- archive-001.md — Older script cycle events 09-21 compacted from the active card.
- Parent archives remain at .agents/memory/_system/archive-001.md through archive-003.md.

## Evidence Base
- source:.agents/memory/_system/archive-003.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified root script ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized script child-card creation.

## Read Contract
- Read this card when changing root PowerShell scripts.
- Read `_system` for repository-level governance and release context before high-risk script changes.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責根層 PowerShell 腳本。
- Doctor 現在會檢查任務板、交付件、完成閘門與任務軌跡的範圍式授權欄位。
- Doctor 與同步工具現在會檢查授權解析政策、核心順序、授權欄位與禁止授權誤讀語句。
- Doctor 已能抓出假團隊、缺主線直做例外、審查證據降級與瀏覽器分支靜默降級。
- 根層父卡保留專案身份、文件與授權。
- 腳本修改前仍必須讀取實際來源。

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
