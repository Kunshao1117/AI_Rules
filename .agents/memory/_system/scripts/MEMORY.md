---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-28T11:53:04+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-28T11:51:02+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 16
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
- Governance Doctor rejects team-task-package direct exceptions that rely on allowed-small, tiny known file set, or direct single-step wording.
- Governance Doctor rejects missing patch/review/validation packet triads, unbounded implementation direct modes, stale direct-write workflow phrases, and old direct-exception shortcuts.
- Governance Doctor now checks team-task-package existence, template fields, workflow task-package references, and old long inline team-rule duplication.
- Governance Doctor checks task type, dispatch pre-gate, Captain Minimum Execution Gate, text patch packets, accepted-risk captain substitution, pre-board specialist guards, 05 condense coverage, and captain over-direct semantics for programming-team governance.
- Governance Doctor checks Captain Trigger Gate, Captain Team Board, role boundary, isolated patch, no-self-review, 00/01 automatic routing, experiment boundaries, source/deployed hash drift, and bilingual negative-context wording.
- Codex workflow skill merge includes the `_shared` support directory so deployed workflows can inherit gates.
- Project rule sync and platform deploy scripts copy restricted project-local tools from `Shared/project-tools/` into downstream `.agents/tools/`.
- The source manager memory migration entrypoint delegates to the shared project-tool implementation so source-manager and downstream behavior stay aligned.
- Project rule sync and platform deploy scripts copy the full shared governance reference set into `.agents/shared/`, including matrices, skill governance, subagent policy, and MCP profile snippets.
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
- 16: Extended Audit.psm1 direct-exception regex coverage for allowed-small, tiny-file-set, and direct single-step wording.
- 15: Added Audit.psm1 guards for packet-triad completion, implementation direct bounds, old direct-write phrases, and verified Doctor/Audit green.
- 14: Added team-task-package template governance, refreshed 44/61 skill-count facts, and verified Doctor/Audit green.
- 13: Added Doctor coverage for 05 condense entries, captain minimum execution, text patch packets, and accepted-risk captain substitution.
- 12: Updated Audit.psm1 negative-context checks so prohibition wording about pre-board agents and captain over-direct ownership is not misreported as allowed behavior.
- 11: Extended Audit.psm1 programming-team coverage for task type, dispatch pre-gate, and captain minimum-execution semantics.
- 10: Extended Audit.psm1 programming-team coverage for captain-led routing and role-exclusivity semantics.
- 09: Extended Audit.psm1 programming-team coverage for team-first evidence defaults, direct exceptions, all-direct guards, review governance, and browser branch boundaries.
- 08: Added programming-team-governance coverage, negative semantic checks, experiment minimum-governance checks, and deployed hash drift checks to Audit.psm1.

## Archive Index
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
