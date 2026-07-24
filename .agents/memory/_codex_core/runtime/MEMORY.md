---
name: _codex_core.runtime
scopePath: Codex/
description: >
  專案記憶：Codex 平台啟動、設定與 runtime hook。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-25T00:57:11+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-25T00:54:59+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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
# _codex_core.runtime — Module Memory

## Current Truth

- Owns Codex bootstrap, configuration, hook, and runtime adapter sources.
- `Codex/.codex/AGENTS.md` contains a generated pointer to the Codex shared adapter; the full adapter and referenced Shared contracts remain canonical under `Shared/policies` and deployed `.agents/shared/` sources.

## Active Constraints

- Current callable schema and protected-tool boundaries remain source-governed.
- The generated policy marker must remain pointer-form and must not be hand-edited or expanded with the full adapter policy.

## Cycle Events

- 01: Created during the 2026-07-24 authorized memory split after current-source verification.
- 02: Recorded the generated Codex shared-adapter pointer contract and canonical-policy boundary.

## Archive Index

- Parent archive records the pre-split parent ownership history.

## Evidence Base

- source:Codex/VERSION
- source:Codex/.gitignore
- source:Codex/.codex/AGENTS.md and Shared/policies/adapters/codex-subagent-invocation.md — generated pointer and canonical adapter boundary.
- tool:memory_status — Existing owner scope verified before split.

## Read Contract

- Read when working on the owned source files.
- Do not use this card for sibling ownership or historical parent detail.

## Conflicts and Supersession

- None.

## 中文摘要

- Codex 平台啟動、設定與 runtime hook。
- 具體檔案歸屬已由父卡移入此子卡。
- 現行來源優先於本卡摘要。
- `AGENTS.md` 只保留 generated shared adapter pointer；完整 adapter 仍以 Shared canonical policy 為準。

## Tracked Files

- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks/team-native-gate.ps1
- Codex/.codex/hooks/team-native-launcher.ps1
- Codex/.codex/VERSION
- Codex/.gitignore

## Relations

- _codex_core (parent card: navigation only)
- _codex_core.support (sibling support index)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust split topology or archive volumes.
