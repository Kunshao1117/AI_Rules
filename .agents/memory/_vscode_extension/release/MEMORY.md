---
name: _vscode_extension.release
scopePath: Extensions/vscode-ai-rules-manager/
description: >-
  專案記憶：VS Code 管理器外掛封裝、資源、發布與後端入口。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-03T13:41:56+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-01T09:32:41+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 11
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
# _vscode_extension.release — VS Code Extension Release Memory

## Current Truth
- AI Rules Manager v0.1.19 packages Doctor token stability, project skill discovery repair, shared skill margin, and updated release documentation.
- The manager backend reports and applies shared governance reference deployment during project rule synchronization.
- The manager backend Doctor description now reports Codex repo-managed hooks removal or rebuild-pending state and Captain-Lite reading model coverage.
- The manager backend Doctor now exits nonzero when governance audit returns Red findings or a failed result, so Audit/Doctor cannot silently pass failed Team-Native hard gates.
- Manager entrypoint changes in this cycle are governance fail-closed behavior only; they do not imply a VSIX version bump, tag, release, install, or publication without a separate Director gate.
- The manager backend forwards optional Team-Native trace requirements into governance Doctor.
- This child card owns VS Code extension package metadata, lockfile, README, resources, release workflow, and manager backend entrypoint.
- VSIX release assets are produced through GitHub Release tags and the release workflow.
- Lockfile-only transitive dev dependency security patches do not change extension behavior or product version by default.

## Active Constraints
- Keep extension versioning separate from Codex, Claude, and Antigravity framework versions.
- Do not bump the extension version for lockfile-only transitive security fixes.
- Do not silently publish or install VSIX packages.

## Cycle Events
- 11: Recorded manager Doctor wording after repo-managed Codex Hooks removal: Doctor reports hook removal or rebuild-pending state, without authorizing VSIX version bump, tag, release, install, or publication.
- 10: Recorded manager-entrypoint fail-closed alignment with root Doctor and Deploy Audit; no VSIX version bump, tag, release, install, or publication was authorized by this memory update.
- 09: Hardened the manager backend Doctor path to fail closed on failed governance audit results, aligning VS Code manager entrypoint behavior with root Doctor and Deploy Audit.
- 08: Updated Doctor description to include Codex project-level hook governance and Captain-Lite read checks.
- 07: Added RequireTeamTrace and TeamTraceRoot forwarding to the manager backend Doctor path.
- 06: Bumped AI Rules Manager to v0.1.19 for Doctor token stability and project skill discovery repair.
- 05: Bumped AI Rules Manager to v0.1.18 for Doctor review-governance coverage and release notes.
- 04: Bumped AI Rules Manager to v0.1.17 for project-local tool sync coverage and release notes.
- 03: Bumped AI Rules Manager to v0.1.16 and packaged the VSIX with sync coverage and memory migration entries.
- 02: Project sync backend now reports and applies shared governance reference files for plugin-driven sync.
- 01: Split VS Code extension release and packaging ownership out of the extension parent card.

## Archive Index
- Parent archives remain at .agents/memory/_vscode_extension/archive-001.md and archive-002.md.

## Evidence Base
- source:.agents/memory/_vscode_extension/archive-002.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified extension ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized release child-card creation.

## Read Contract
- Read this card when changing extension package, release workflow, resources, or manager backend entrypoint.
- Read `_vscode_extension.runtime` before changing behavior implemented in TypeScript runtime files.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 VS Code 外掛封裝、資源、發布流程與管理器入口。
- 管理器 Doctor 文案已改為回報 Codex hooks 移除或待重建狀態；這不是發布新版 VSIX 的授權。
- 版本與 VSIX 發布仍需明確治理。

## Tracked Files
- Extensions/vscode-ai-rules-manager/package.json
- Extensions/vscode-ai-rules-manager/package-lock.json
- Extensions/vscode-ai-rules-manager/README.md
- Extensions/vscode-ai-rules-manager/resources/ai-rules.svg
- Extensions/vscode-ai-rules-manager/resources/icon.png
- .github/workflows/release-vsix.yml
- Scripts/AI-RulesManager.ps1

## Relations
- _vscode_extension (parent card: extension package index)
- _vscode_extension.runtime (related runtime source ownership)
- _vscode_extension.auxiliary (related packaging support files)
- _system.scripts (related script governance)

## Applicable Skills
- memory-ops — Use when updating this child card.
- plugin-release-governance — Use for VSIX, tag, release, asset, or update reminder changes.
- security-sre — Use for workspace trust boundary changes.
