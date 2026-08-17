---
name: _system.scripts.manager
scopePath: Scripts/modules/
description: |
  專案記憶：AI Rules Manager PowerShell 模組。Use when: task touches Manager.*.psm1.
last_updated: '2026-08-17T20:55:50+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-08-17T20:50:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-08-17-002
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

# _system.scripts.manager — Module Memory

## Current Truth

- Owns Manager command, config, deployment, and project-sync modules.
- Project sync resolves each platform adapter in preflight and applied sync. VERSION advances only after required stages succeed.

## Active Constraints

- Auto selection must use each installed platform's own adapter. A declined managed update must not report success.

## Cycle Events

- 01: Created during the scripts split.

## Archive Index

- Parent archive-005.md records the pre-split file list.

## Evidence Base

- source:Scripts/modules/Manager.ProjectSync.psm1, Scripts/modules/Manager.Commands.psm1

## Read Contract

- Read when changing Manager PowerShell modules.

## Conflicts and Supersession

- superseded: writing VERSION before required sync success.

## 中文摘要

- 此卡負責 Manager 模組。
- 各平台 adapter 分開預檢與寫入；拒絕更新不得報成功。

## Tracked Files

- Scripts/modules/Manager.Commands.psm1
- Scripts/modules/Manager.Config.psm1
- Scripts/modules/Manager.Deployment.psm1
- Scripts/modules/Manager.ProjectSync.psm1

## Relations

- _system.scripts (parent card: navigation only)
- _vscode_extension (related VS Code manager memory)

## Applicable Skills

- memory-ops — Update this card through separate protected write and commit phases.
