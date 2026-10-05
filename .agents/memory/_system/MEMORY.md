---
name: _system
scopePath: .
description: >
  專案記憶：框架系統層、根文件與部署治理導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-08-17T22:07:11+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T21:20:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
cycle_event_count: 5
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



# _system — Repository Governance Memory

## Current Truth

- AI_Rules is the source repository for Antigravity, Claude Edition, Codex Edition, and Cursor Edition.
- This card is a concise root source/status pointer; current source files and Shared policies remain runtime authority.
- Root README and CHANGELOG record Cursor Edition v0.1.0. Root `.gitignore` ignores repo-root `/.cursor/` runtime and `/logs/` generated evidence; it does not ignore `Cursor/.cursor/` source.
- Root PowerShell source ownership belongs to `_system.scripts`.

## Active Constraints

- Source memory and project context are separate stores.
- Root governance, Git, releases, installs, deployments, and external changes need their respective scoped authority.

## Cycle Events

- 07: Noted that credential-boundary parity tests use a temporary deployed copy.
- 03: Verified the non-engineer README and user-visible status boundary without claiming model-wide compliance.
- 04: Recorded Cursor Edition as the fourth peer platform in root docs and gitignore.
- 05: Ignored repo-root `/logs/` after deleting generated credential-boundary evidence.
- 06: Recorded Cursor Edition v0.1.0 changelog with 13 workflow entries and memory-card split notes.

## Archive Index

- archive-001.md — Legacy _system identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.
- archive-003.md — Pre-standardization active-card snapshot.
- archive-004.md — Compacted pre-2026-07-24 root governance detail.

## Evidence Base

- source:README.md, CHANGELOG.md, .gitignore

## Read Contract

- Read for repository-level ownership, release baseline, and memory/context boundaries.
- Read `_system.scripts` before changing root PowerShell scripts.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡只保留根層治理與版本基線，不是 runtime 規則來源。
- 現有四個對等平台：Antigravity、Claude、Codex、Cursor。
- 根 PowerShell 由 `_system.scripts` 專責。

## Tracked Files

- .gitignore
- README.md
- CHANGELOG.md
- LICENSE

## Relations

- _map (memory navigation index)
- _shared (Shared governance source)
- _codex_core (Codex platform source)
- _claude_core (Claude platform source)
- _ag_core (Antigravity platform source)
- _cursor_core (Cursor platform source)
- _system.scripts (child card: root PowerShell script navigation)

## Applicable Skills

- memory-ops — Update and commit this root navigation card.
- memory-arch — Use for parent/child topology or archive decisions.
