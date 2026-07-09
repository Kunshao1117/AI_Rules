---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-09T14:16:54+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T13:43:35+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
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
# _system.scripts.codex-hooks-fixtures — Codex Hook Fixture Memory
## Current Truth
- This child card owns Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`; canonical behavior lives in the runner, live fixtures, manifest, Codex hook source/deployed pair, and manifest/catalog 65 required fixture registration including 14 `spawn_agent`/`send_input` host-schema, safety-denylist, explicit action, and forged station/action metadata fixtures, while `_system.scripts` owns runner/Audit/source-deployed behavior.
- `UserPromptSubmit` fixtures expect exact phrase `操作者要求開啟子代理功能，並默認啟動團隊模式` plus Team-Native state lines; `PreToolUse` fixtures route by trusted host-level actor/station evidence, allow normal root delegation host schema, recursively deny root object/array or nested forged/action metadata, and Stop completion-risk fixtures remain advisory allow outputs.
## Active Constraints
- Memory is only the ownership pointer; runner/manifest computes current counts, concrete attribution resides in `## Tracked Files`, protected `memory_commit` is later metadata sync, and git staging/commit remains separate.
## Cycle Events
- 01-05: Compacted stale fixture-cycle noise, attributed 51 fixture JSON files plus manifest, recorded UserPromptSubmit/PreToolUse/Stop/SubagentStop/apply_patch coverage, and attributed 14 spawn_agent/send_input PreToolUse fixtures with 65-fixture two-shell validation, 10 commandWindows cases, launcher parity, and ReleaseReady tracking blockers.
## Archive Index
- None yet.
## Evidence Base
- source: `Scripts/tests/codex-hooks/fixtures/*.json`, `Scripts/tests/codex-hooks/fixtures/manifest.json`, `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, `Scripts/modules/Audit/CodexHookGovernance.catalog.json`, hook gate/config files, and launcher source/runtime pair.
- tool/director: 2026-07-09 fixture runner passed 65 fixtures x 2 shells and 10 commandWindows cases; Audit reported `ReleaseReady=false`, `RedCount=1`, `YellowCount=14`, `UntrackedRequiredFixtureCount=14`; Director supplied 14 new delegation fixture attributions, launcher parity, Zone.Identifier absence, and no git/push authority.
## Read Contract
- Read before fixture changes; also read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale Stop block expectations, pre-state-machine assumptions, and 39/41/43/45/51 fixture-count assumptions are replaced by approved 65-fixture manifest/catalog repair.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬；目前歸屬 65 個 fixture JSON 與 `manifest.json`，manifest/catalog 均以 65 required fixtures 為準，新增 14 個 `spawn_agent`/`send_input` fixture，覆蓋 root host schema 放行、root/nested forged/action metadata 拒絕、explicit write/protected action 拒絕；驗證回報 65 fixtures x 2 shells、host-wrapper 10 cases、launcher parity true。
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
