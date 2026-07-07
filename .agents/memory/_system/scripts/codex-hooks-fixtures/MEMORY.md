---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-07T22:47:03+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T20:50:00+08:00'
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
- This child card is a source/status pointer for Codex hook JSON fixture ownership under `Scripts/tests/codex-hooks/fixtures/`; it is not a runtime governance rule source.
- Canonical fixture behavior lives in `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, the live fixture files, and the Codex hook source/deployed pair.
- Commit `da7435e4` added the Codex hook fixture runner and a then-current fixture set.
- Fixture expectations include advisory allow-reminder cases, allow-reminder outer-agent or single-file cases, and deny cases; compute current counts from the runner/manifest or live tracked fixture files at validation time.
- The runner treats allow/advisory fixtures as no `permissionDecision` output, while deny/block fixture output includes `hookSpecificOutput.permissionDecision` and a reason.
- The parent `_system.scripts` card owns the fixture runner, Audit integration, and hook source/deployed pair; this child card owns only JSON fixture cases.
- Ownership status: new Codex hook fixture sources and `manifest.json` are present under `Scripts/tests/codex-hooks/fixtures/`; cartridge metadata sync is handled through protected `memory_commit`.
## Active Constraints
- Stale numeric ownership claims are superseded; memory is only the ownership pointer, and the runner/manifest or live tracked fixture inventory computes the current case inventory size.
- Fixture expectation evidence is sourced from `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, and `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`.
- Concrete fixture attribution resides in `## Tracked Files`; protected `memory_commit` is the metadata synchronization step for this repair.
- Git staging/commit for this memory card is a separate protected phase and is not authorized by memory content repair.
## Cycle Events
- 03: Recorded startup reminder fixture regex coverage for the new governed-work hook reminder semantics: station division and necessary subagent/teammate dispatch.
- 02: Reconciled stale fixture ownership to the committed fixture set and removed the generated staleness warning.
- 01: Created child ownership card after directory-level tracking left Codex hook JSON fixtures unowned.
## Archive Index
- None yet.
## Evidence Base
- source: Scripts/tests/codex-hooks/fixtures/*.json — Current fixture cases and expected decisions, including startup reminder regex coverage for governed-work station/subagent dispatch semantics.
- source: Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 — Fixture runner contract.
- source: Codex/.codex/hooks/team-native-gate.ps1 and .codex/hooks/team-native-gate.ps1 — Hook behavior source/deployed pair.
- tool: git show --stat da7435e4 — Committed runner plus then-current fixture files.
- tool: runner/manifest or `git ls-files -- Scripts/tests/codex-hooks/fixtures` — Compute the current tracked case inventory at validation time; memory text is not the authority for numeric inventory claims.
## Read Contract
- This card is the pre-change ownership context for Codex hook JSON fixture additions, deletions, and edits.
- `_system.scripts` is the runner, Audit ownership, and hook source/deployed parity context for executable script behavior.
## Conflicts and Supersession
- Supersedes stale advisory-only ownership wording and any memory-stored numeric inventory claim.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬指標，不提供權威 fixture 數量。
- fixtures 同時涵蓋 allow/reminder 與 deny 路徑；實際數量由 runner/manifest 或 live tracked files 即時計算。
- startup reminder fixture regex 已覆蓋「治理要求已明確要求站點分工」與「必要的子代理/隊員派工」語意。
- fixture 新增/刪除的歸屬狀態以本卡 `Tracked Files` 與後續 protected `memory_commit` 為準。
## Tracked Files
- Scripts/tests/codex-hooks/fixtures/advisory-bad-input-smoke.json
- Scripts/tests/codex-hooks/fixtures/advisory-pretool-write-no-board.json
- Scripts/tests/codex-hooks/fixtures/advisory-session-start-startup-reminder.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-blocked-state.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-complete-no-blockers.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-direct-exception-no-complete.json
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
- Scripts/tests/codex-hooks/fixtures/block-stop-captain-broad-read-full-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-artifacts-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-memory-docs.json
- Scripts/tests/codex-hooks/fixtures/block-stop-mixed-blocked-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-zh-completion.json
- Scripts/tests/codex-hooks/fixtures/context-pretool-captain-broad-read-no-board.json
- Scripts/tests/codex-hooks/fixtures/manifest.json
## Relations
- _system.scripts (parent card: runner and script governance)
- _codex_core (related card: Codex hook config and gate script)
- _shared.team-native-core (related card: Team-Native governance)
## Applicable Skills
- memory-ops — Use for fixture attribution, staleness repair, and memory commit.
- memory-arch — Use for fixture ownership splits or topology changes.
