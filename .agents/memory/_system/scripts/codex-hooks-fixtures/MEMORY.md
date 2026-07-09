---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating hook fixtures,
  skipped legacy fixtures, or fixture ownership.
last_updated: '2026-07-09T22:48:24+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T22:46:19+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 8
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
- This child card owns every JSON fixture under `Scripts/tests/codex-hooks/fixtures/`; current active behavior is `mandatory-directive-v1`, while legacy/skipped fixture filenames are tracked for ownership only and are not current runtime requirements.
## Active Constraints
- Do not prune legacy/skipped fixture paths from `## Tracked Files` merely because the current runner skips them; untracked source files fail memory attribution.
- Memory commit, git commit, release, deploy, install, credentials, and external mutation remain separate protected phases.
## Cycle Events
- 01-08: Compacted prior fixture lifecycle through `mandatory-directive-v1` and restored full attribution after audit showed 64 unowned legacy/skipped fixture files.
## Archive Index
- None yet.
## Evidence Base
- source/tool: allowlist fixture uses `mandatory-directive-v1`; full fixture run with `-VerifyRuntimeSync` passed on 2026-07-09 with 1 active fixture and 64 skipped legacy fixtures.
- user evidence: pasted unowned-file report on 2026-07-09 listed 64 fixture paths, all belonging to this child card.
## Read Contract
- Read before fixture changes; also read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale deny/block, Stop/Subagent lifecycle, advisory, and reminder-only fixture semantics are replaced by `mandatory-directive-v1`; file ownership is not superseded.
## 中文摘要
- 此子卡歸屬所有 `Scripts/tests/codex-hooks/fixtures/` JSON 夾具；目前有效規格是 `mandatory-directive-v1`，舊 fixture 可是 skipped/legacy，但不能從 `Tracked Files` 移除。
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
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-explicit-write-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-nested-structured-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-send-input-target-object-structured-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-explicit-protected-action.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-fork-context-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-message-object-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-messages-array-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/deny-pretool-spawn-agent-nested-forged-station-trace.json
- Scripts/tests/codex-hooks/fixtures/manifest.json
