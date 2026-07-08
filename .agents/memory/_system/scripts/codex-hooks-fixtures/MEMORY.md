---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-08T10:19:01+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T10:11:35+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
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
# _system.scripts.codex-hooks-fixtures — Codex Hook Fixture Memory
## Current Truth
- This child card owns Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`; canonical fixture behavior lives in the runner, live fixtures, manifest, and Codex hook source/deployed pair.
- Fixture expectations cover Session/UserPrompt/SubagentStart/SubagentStop/Stop/PreToolUse paths, allow/advisory/deny/block cases, cmd and nested cmd repo-inventory denial, Stop feedback/noise handling, `<hook_prompt>` echo handling, and legacy Stop `message` fallback.
- Allow/advisory fixtures emit no `permissionDecision`; deny outputs include decision and reason, while Stop completion-risk cases are advisory allow outputs with `systemMessage` and no `decision: block`.
- Approved repair state has 45 fixture JSON files plus `manifest.json`; manifest/catalog both register 45 required fixtures, and historical `block-stop-*` names now carry advisory canonical decisions.
- Approved validation evidence reports 45 fixture(s), 2 shell(s), source/runtime sync, and staged hook governance audit passed; `pwsh` remains a residual wrapper dependency risk.
- The parent `_system.scripts` card owns the fixture runner, Audit integration, and hook source/deployed pair; this child card owns only JSON fixture cases.
## Active Constraints
- Memory is only the ownership pointer; runner/manifest or live tracked fixture inventory computes current counts, with expectation evidence from the hook gate pair and fixture runner.
- Concrete fixture attribution resides in `## Tracked Files`; protected `memory_commit` is later metadata sync, and git staging/commit remains a separate protected phase.
## Cycle Events
- 01: Compacted stale fixture-cycle noise and attributed 43 active hook fixtures plus manifest, including four advisory `allow-stop-*` fixtures and two cmd-pipe deny fixtures.
- 02: Recorded two Stop advisory fixtures for hook-prompt echo and positive final-success wording, bringing active fixture coverage to 45 JSON cases.
## Archive Index
- None yet.
## Evidence Base
- source: `Scripts/tests/codex-hooks/fixtures/*.json` and `Scripts/tests/codex-hooks/fixtures/manifest.json`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` — fixture runner contract and host-wrapper checks.
- source: `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, `Codex/.codex/hooks.json`, and `.codex/hooks.json`.
- tool: `Measure-CodexHookGovernance` reported Red 0, Yellow 0, and untracked required fixtures 0 on 2026-07-08.
- director: 2026-07-08 protected memory-write instruction supplied 45-fixture validation, runtime sync evidence, manifest/catalog mirror repair, residual broader-dirty-worktree risk, and `pwsh` runtime risk.
## Read Contract
- Read this card before Codex hook JSON fixture changes; read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale Stop block expectations and 39/41/43 fixture-count assumptions are replaced by the approved 45-fixture manifest/catalog repair.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬，不提供永久權威 fixture 數量。
- 本次歸屬 45 個 fixture JSON 與 `manifest.json`；manifest/catalog 均以 45 required fixtures 為準。
- Stop 完成風險 fixture 現在是 advisory allow；兩個 cmd-pipe fixture 仍是 deny。
- 前站驗證回報 45 fixtures、2 shell 通過，且 `Invoke-CodexHookFixtureTests.ps1 -VerifyRuntimeSync` 已驗證 runtime sync。
- `pwsh` 仍是 wrapper residual runtime dependency。
## Tracked Files
- Scripts/tests/codex-hooks/fixtures/advisory-bad-input-smoke.json
- Scripts/tests/codex-hooks/fixtures/advisory-pretool-write-no-board.json
- Scripts/tests/codex-hooks/fixtures/advisory-session-start-startup-reminder.json
- Scripts/tests/codex-hooks/fixtures/advisory-subagent-start-boundaries.json
- Scripts/tests/codex-hooks/fixtures/advisory-user-prompt-submit-conditional-subagents.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-exe-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-git-ls-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-single-file-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-default-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-explorer-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-missing-type-advisory.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-rg-files-outer-agent-unknown-type-advisory.json
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
## Relations
- _system.scripts (parent runner/script governance); _codex_core (hook config/gate script); _shared.team-native-core (Team-Native governance)
## Applicable Skills
- memory-ops — fixture attribution/staleness repair/memory commit; memory-arch — fixture ownership splits or topology changes.
