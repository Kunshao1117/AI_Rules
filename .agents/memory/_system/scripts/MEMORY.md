---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-15T13:22:29+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-15T13:21:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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
- Codex workflow skill merge includes the `_shared` support directory so deployed workflows can inherit gates.
- Project rule sync and platform deploy scripts copy restricted project-local tools from `Shared/project-tools/` into downstream `.agents/tools/`.
- The source manager memory migration entrypoint delegates to the shared project-tool implementation so source-manager and downstream behavior stay aligned.
- Project rule sync and platform deploy scripts copy the full shared governance reference set into `.agents/shared/`, including matrices, skill governance, subagent policy, and MCP profile snippets.
- Project rule sync and platform deploy scripts copy shared governance reference files into `.agents/shared/` for target projects.
- This child card owns root PowerShell deployment, audit, memory migration, skill sync, and platform sync scripts.
- The root `_system` card keeps repository identity, documentation, license, and top-level governance truth.
- Public PowerShell entrypoints must preserve UTF-8 compatibility for Windows PowerShell 5.1.

## Active Constraints
- Do not mutate external repositories or deployment targets without explicit Director approval.
- Keep script behavior aligned with protected memory and project-skill directories.
- Do not use this card as a substitute for reading the current script implementation before edits.

## Cycle Events
- 04: Added project-local tool sync and shared memory migration implementation wiring for downstream projects.
- 03: Expanded sync scripts to deploy full shared governance references, Codex workflow support files, and downstream sync coverage checks.
- 02: Added shared governance reference sync to deployment and project-rule sync scripts.
- 01: Split root script ownership out of the repository governance parent card.

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

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting root script ownership.
- plugin-release-governance — Use when release behavior changes.
