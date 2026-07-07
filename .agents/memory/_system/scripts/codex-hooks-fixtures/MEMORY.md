---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-07T10:41:21+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-07T10:35:30+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-05-001
cycle_event_count: 3
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

# _system.scripts.codex-hooks-fixtures — Codex Hook Fixture Memory
## Current Truth
- This child card owns the 23 git-tracked Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`.
- Commit `da7435e4` added the Codex hook fixture runner and the current fixture set.
- Fixture expectations include 3 advisory allow-reminder cases, 8 allow-reminder outer-agent or single-file cases, and 12 deny cases; the startup reminder regex now covers governed-work station division plus necessary subagent/teammate dispatch wording.
- The runner treats allow/advisory fixtures as no `permissionDecision` output, while deny/block fixtures must emit `hookSpecificOutput.permissionDecision` and a reason.
- The parent `_system.scripts` card owns the fixture runner, Audit integration, and hook source/deployed pair; this child card owns only JSON fixture cases.
## Active Constraints
- Do not restore stale 47-fixture ownership; current concrete ownership is the 23 JSON files listed below.
- Keep fixture expectations aligned with `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, and `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`.
- Add or remove concrete fixture paths here before completion when JSON fixtures change.
- Git staging/commit for this memory card is a separate protected phase and is not authorized by memory content repair.
## Cycle Events
- 03: Recorded startup reminder fixture regex coverage for the new governed-work hook reminder semantics: station division and necessary subagent/teammate dispatch.
- 02: Reconciled stale fixture ownership to the committed 23-fixture set and removed the generated staleness warning.
- 01: Created child ownership card after directory-level tracking left Codex hook JSON fixtures unowned.
## Archive Index
- None yet.
## Evidence Base
- source: Scripts/tests/codex-hooks/fixtures/*.json — Current fixture cases and expected decisions, including startup reminder regex coverage for governed-work station/subagent dispatch semantics.
- source: Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 — Fixture runner contract.
- source: Codex/.codex/hooks/team-native-gate.ps1 and .codex/hooks/team-native-gate.ps1 — Hook behavior source/deployed pair.
- tool: git show --stat da7435e4 — Committed runner plus 23 fixture files.
- tool: git ls-files -- Scripts/tests/codex-hooks/fixtures — 23 tracked fixture files verified on 2026-07-07.
## Read Contract
- Read this card before adding, deleting, or changing Codex hook JSON fixtures.
- Read `_system.scripts` for runner, Audit ownership, and hook source/deployed parity before changing executable script behavior.
## Conflicts and Supersession
- Supersedes stale 47-fixture advisory-only ownership wording.
## 中文摘要
- 此子卡專門歸屬目前 23 個 Codex hooks JSON fixtures。
- fixtures 同時涵蓋 allow/reminder 與 deny 路徑，不再是舊的 47 件 advisory-only 清單。
- startup reminder fixture regex 已覆蓋「治理要求已明確要求站點分工」與「必要的子代理/隊員派工」語意。
- 新增或刪除 fixture 時，要同步此卡的 `Tracked Files`。
## Tracked Files
- Scripts/tests/codex-hooks/fixtures/advisory-bad-input-smoke.json
- Scripts/tests/codex-hooks/fixtures/advisory-pretool-write-no-board.json
- Scripts/tests/codex-hooks/fixtures/advisory-session-start-startup-reminder.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-exe-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-single-file-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-default-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-explorer-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-missing-type-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-unknown-type-advisory.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-exe-ls-files.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-cached.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-chained.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-redirection.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-append-redirection.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-chained.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-extra-arg.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-tool-input-forged-station.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files.json
## Relations
- _system.scripts (parent card: runner and script governance)
- _codex_core (related card: Codex hook config and gate script)
- _shared.team-native-core (related card: Team-Native governance)
## Applicable Skills
- memory-ops — Use for fixture attribution, staleness repair, and memory commit.
- memory-arch — Use for fixture ownership splits or topology changes.
