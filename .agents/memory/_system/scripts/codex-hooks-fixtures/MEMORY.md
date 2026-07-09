---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-09T21:50:37+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T21:45:55+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 7
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
- This child card owns Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`; canonical behavior lives in runner/manifest/source-deployed hooks, and the current active fixture model is `mandatory-directive-v1`.
- The retained apply_patch allowlist filename now carries `latestModel: mandatory-directive-v1`, `scenarioCode: pretool-apply-patch-mandatory-directive`, `category: directive`, `expectedOutcomeKind: directive-context`, and stale marker exclusions for old reminder/advisory output.
## Active Constraints
- Memory is only the ownership pointer; runner/manifest computes current counts, concrete attribution resides in `## Tracked Files`, protected `memory_commit` is later metadata sync, and git staging/commit remains separate.
- Do not treat skipped legacy fixture filenames as current runtime requirements; current active assertions are the manifest, runner, and retained allowlist fixture.
## Cycle Events
- 01-05: Compacted stale fixture-cycle noise, attributed 51 fixture JSON files plus manifest, recorded UserPromptSubmit/PreToolUse/Stop/SubagentStop/apply_patch coverage, and attributed 14 spawn_agent/send_input PreToolUse fixtures with 65-fixture two-shell validation, 10 commandWindows cases, launcher parity, and ReleaseReady tracking blockers.
- 06: Recorded the immediately prior context-only fixture model, now superseded by event 07.
- 07: Updated fixture memory to `mandatory-directive-v1`: retained allowlist fixture expects directive context, non-ignorable user/operator Team-Native markers, and absence of stale reminder/advisory markers.
## Archive Index
- None yet.
## Evidence Base
- source/tool: `Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json` keeps the old filename but now uses `latestModel: mandatory-directive-v1`, `category: directive`, `expectedOutcomeKind: directive-context`, and `expectedAbsentRegex` covering old reminder/advisory markers.
- tool: full fixture run with `-VerifyRuntimeSync` passed on 2026-07-09: source/deployed sync, 6 directive fallback cases, 12 `commandWindows` host-wrapper cases, and 1 active fixture with 64 skipped legacy fixtures.
## Read Contract
- Read before fixture changes; also read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale deny/block, `Stop`, `SubagentStart`, `SubagentStop`, advisory, and reminder-only fixture expectations are replaced by the three-event `mandatory-directive-v1` model.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬；最新穩定模型是 `mandatory-directive-v1`，fixture 期待強制規範上下文、不可忽略標記與使用者/操作者 Team-Native 要求。
- 舊的 deny/block、advisory、reminder-only 與 `Stop`/`Subagent*` 夾具只能作為歷史或跳過項目，不是目前有效規格。
## Tracked Files
- Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json
- Scripts/tests/codex-hooks/fixtures/manifest.json
