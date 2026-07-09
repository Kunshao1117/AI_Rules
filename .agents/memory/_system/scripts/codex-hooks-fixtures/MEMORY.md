---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-09T20:56:00+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T20:49:07+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 6
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
- This child card owns Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`; canonical behavior lives in runner/manifest/source-deployed hooks, and latest fixture semantics cover only `SessionStart`, `UserPromptSubmit`, and `PreToolUse` reminders with no `permissionDecision` or deny/block outcome; the retained apply_patch allowlist filename now carries `latestModel: reminder-only-v1`.
## Active Constraints
- Memory is only the ownership pointer; runner/manifest computes current counts, concrete attribution resides in `## Tracked Files`, protected `memory_commit` is later metadata sync, and git staging/commit remains separate.
## Cycle Events
- 01-05: Compacted stale fixture-cycle noise, attributed 51 fixture JSON files plus manifest, recorded UserPromptSubmit/PreToolUse/Stop/SubagentStop/apply_patch coverage, and attributed 14 spawn_agent/send_input PreToolUse fixtures with 65-fixture two-shell validation, 10 commandWindows cases, launcher parity, and ReleaseReady tracking blockers.
- 06: Replaced latest fixture memory with `reminder-only-v1`: the retained apply_patch allowlist fixture is advisory-only, expects no `permissionDecision`, and records the three-event model while terminal/subagent lifecycle fixtures are no longer current governance hooks.
## Archive Index
- None yet.
## Evidence Base
- source/tool: `Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json` keeps the old filename with `latestModel: reminder-only-v1`, `category: advisory`, and `expectedAbsentRegex: permissionDecision`; fixture files, manifest, runner, audit catalog, and Director-supplied team smoke evidence support the current model.
## Read Contract
- Read before fixture changes; also read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale deny/block, `Stop`, `SubagentStart`, and `SubagentStop` fixture expectations are replaced by the three-event reminder-only model.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬；最新穩定模型只看 `SessionStart`、`UserPromptSubmit`、`PreToolUse` 三項提醒，且 `PreToolUse` fixture 不期待 `permissionDecision`、不做 deny/block；allowlist 檔名保留但內容已是 `reminder-only-v1`。
## Tracked Files
- Scripts/tests/codex-hooks/fixtures/advisory-bad-input-smoke.json
- Scripts/tests/codex-hooks/fixtures/advisory-pretool-write-no-board.json
- Scripts/tests/codex-hooks/fixtures/advisory-session-start-startup-reminder.json
- Scripts/tests/codex-hooks/fixtures/advisory-subagent-start-boundaries.json
- Scripts/tests/codex-hooks/fixtures/advisory-user-prompt-submit-conditional-subagents.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-exe-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-single-file-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-default-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-explorer-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-missing-type-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-unknown-type-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-send-input-host-schema-readonly.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-send-input-readonly-safety-denylist.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-spawn-agent-host-schema-readonly.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-spawn-agent-readonly-safety-denylist.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-spawn-agent-text-mentions-governance-metadata.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-spawn-agent-write-like-text-governance-metadata.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-blocked-state.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-complete-no-blockers.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-direct-exception-no-complete.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-fixture-path-reference.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-hook-feedback-echo-noncomplete.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-hook-prompt-feedback-echo-noncomplete.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-negated-long-complete-claim.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-non-complete-wording.json
- Scripts/tests/codex-hooks/fixtures/allow-subagent-stop-complete-delivery-fields.json
- Scripts/tests/codex-hooks/fixtures/block-stop-captain-broad-read-full-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-legacy-message-fallback.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-artifacts-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-memory-docs.json
- Scripts/tests/codex-hooks/fixtures/block-stop-mixed-blocked-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-positive-final-success.json
- Scripts/tests/codex-hooks/fixtures/block-stop-zh-completion.json
- Scripts/tests/codex-hooks/fixtures/block-subagent-stop-missing-delivery-fields.json
- Scripts/tests/codex-hooks/fixtures/context-pretool-captain-broad-read-no-board.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-apply-patch-captain-actor.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-apply-patch-change-delivery-outside-allowlist.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-apply-patch-change-delivery-protected-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-apply-patch-tool-input-forged-station.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-apply-patch-unknown-actor.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-explicit-write-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-nested-structured-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-target-object-structured-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-explicit-protected-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-fork-context-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-message-object-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-messages-array-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-nested-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-exe-ls-files.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-nested-cmd-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-cached.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-chained.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files-outer-agent-redirection.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-git-ls-files.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-cmd-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-append-redirection.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-chained.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-extra-arg.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-outer-agent-pipe.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files-tool-input-forged-station.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-rg-files.json
- Scripts/tests/codex-hooks/fixtures/manifest.json
