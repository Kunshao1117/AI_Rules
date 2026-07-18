---
name: _vscode_extension.release
scopePath: Extensions/vscode-ai-rules-manager/
description: >-
  專案記憶：VS Code 管理器外掛封裝、資源、發布與後端入口。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-18T12:45:32+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T22:45:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-18-001
cycle_event_count: 1
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

# _vscode_extension.release — VS Code Extension Release Memory

## Current Truth
- AI Rules Manager v0.2.0 release prep updates the extension manifest and lockfile to version `0.2.0`, and the documented VSIX asset name is `ai-rules-manager-0.2.0.vsix`.
- The v0.2.0 release notes describe Team-Native release readiness, runtime gate hardening, release rerun semantics, memory/docs cleanup alignment, and package/docs readiness.
- Extension packaging uses `@vscode/vsce` `^3.9.2`; the VSIX release workflow uses Node 24, satisfying the `@vscode/vsce` 3.x Node `>=20` packaging requirement, and package audit currently reports total 0.
- The VSIX release workflow validates release refs before checkout and accepts only explicit tags shaped like `vX.Y.Z`.
- Release documentation states that an existing same-name VSIX asset causes the workflow to reject or fail; reruns require a new version/tag or manual asset deletion first.
- D0 minimal validation requires package `verify:runtime` to inspect compiled `out/extension.js` and `out/scriptRunner.js` runtime sentinels, with `vscode:prepublish` running compile before runtime verification; VSIX release assets still come from GitHub Release tags and the release workflow.
- Manager Check and Plan report only the source repository Git snapshot and alignment state; Apply aligns the repository and reports Git state without a governance scan or source-content inspection.
- Retained manager actions cover source alignment, user/project rule sync, orphan cleanup, gitignore handling, and governed memory migration; release, installation, and publication remain separate protected phases.
- Manager entrypoint changes in this cycle preserve Codex config operator settings through section-aware merge for `multi_agent`, `hooks`, and `max_threads`, do not add `max_depth`, and do not imply a VSIX version bump, tag, release, install, or publication without a separate Director gate.
- This child card owns VS Code extension package metadata, lockfile, README, resources, release workflow, and manager backend entrypoint.
- Lockfile-only transitive dev dependency security patches do not change extension behavior or product version by default.

## Active Constraints
- Keep extension versioning separate from Codex, Claude, and Antigravity framework versions.
- Do not bump the extension version for lockfile-only transitive security fixes.
- Do not silently publish or install VSIX packages.
- Do not treat D0 minimal validation as a VSIX version bump, tag, release, install, or deployed parity completion.
- Do not describe release reruns as overwriting same-name VSIX assets; current docs require rejection/failure unless the asset is removed or a new version/tag is used.

## Cycle Events
- 01: Consolidated current v0.2.0 release facts and aligned manager ownership after source status became Git-only and the former governance-check actions were removed.

## Archive Index
- Parent archives remain at .agents/memory/_vscode_extension/archive-001.md and archive-002.md.

## Evidence Base
- source:Extensions/vscode-ai-rules-manager/package.json — Extension manifest version is `0.2.0`.
- source:Extensions/vscode-ai-rules-manager/package-lock.json — Root package lock version is `0.2.0`.
- source:Extensions/vscode-ai-rules-manager/README.md — Extension release docs name tag `v0.2.0`, `ai-rules-manager-0.2.0.vsix`, and same-name asset rerun failure semantics.
- source:CHANGELOG.md — AI Rules Manager v0.2.0 release notes describe Team-Native readiness, runtime gate hardening, rerun semantics, and memory/docs cleanup alignment.
- source:.agents/memory/_vscode_extension/archive-002.md — Previous active card snapshot preserved.
- source:Scripts/AI-RulesManager.ps1 and extension manifest/README — Verified Git-only Check/Plan/Apply behavior and the retained sync, cleanup, gitignore, and memory-migration actions.
- tool:memory_audit — Granularity advisory identified extension ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized release child-card creation.

## Read Contract
- Read this card when changing extension package, release workflow, resources, or manager backend entrypoint.
- Read `_vscode_extension.runtime` before changing behavior implemented in TypeScript runtime files.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 VS Code 外掛封裝、資源、發布流程與管理器入口。
- AI Rules Manager 發布準備已更新到 v0.2.0，manifest/lockfile 版本為 `0.2.0`，文件中的 VSIX asset 為 `ai-rules-manager-0.2.0.vsix`。
- VSIX 封裝工具已升級到 `@vscode/vsce` 3.9.2；發布 workflow 使用 Node 24，npm audit 目前為 0。
- release tag 需符合 `vX.Y.Z` 才會 checkout。
- 同名 VSIX asset 已存在時，補跑會拒絕或失敗；需改新版本/tag 或先人工刪除舊 asset。
- 管理器入口目前會保留 Codex config 的操作者 `max_threads` 設定，且不加入 `max_depth`；這不是發布新版 VSIX 的授權。
- D0 minimal 只提供封裝/發布檢查證據；版本與 VSIX 發布仍需明確治理。
- 管理器 Check/Plan/Apply 現在只處理 Git 狀態與來源對齊；治理健檢與同步完整性入口已移除。

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
