---
name: _system.scripts.codex-hooks-fixtures
scopePath: Scripts/tests/codex-hooks/fixtures/
description: >-
  專案記憶：Codex Team-Native hooks JSON 測試夾具。Use when: updating Codex hook fixtures,
  reminder/deny expectations, or fixture ownership.
last_updated: '2026-07-09T08:27:12+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T08:19:05+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 4
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
- This child card owns Codex hook JSON fixtures under `Scripts/tests/codex-hooks/fixtures/`; canonical fixture behavior lives in the runner, live fixtures, manifest, and Codex hook source/deployed pair, while the parent `_system.scripts` owns runner/Audit/source-deployed behavior.
- `UserPromptSubmit` fixtures expect exact phrase `操作者要求開啟子代理功能，並默認啟動團隊模式` plus Team-Native state lines; `PreToolUse` fixtures route write-like actions by trusted host-level actor/station evidence, deny captain/unknown/forged `tool_input` station claims, and run protected-action checks before write routing; Stop completion-risk fixtures are advisory allow outputs with warning fields and no `decision: block`.
- Approved repair/validation state has 51 fixture JSON files plus `manifest.json`; manifest/catalog both register 51 required fixtures, six apply_patch change-delivery fixtures cover allowlist allow/deny, captain and unknown actor denial, forged station denial, and protected-action precedence, while 51 fixtures x 2 shells, 10 host-wrapper cases, and source/runtime hook SHA parity passed.
## Active Constraints
- Memory is only the ownership pointer; runner/manifest or live tracked inventory computes current counts, concrete attribution resides in `## Tracked Files`, protected `memory_commit` is later metadata sync, and git staging/commit remains separate.
## Cycle Events
- 01-03: Compacted stale fixture-cycle noise, attributed 43 active fixtures plus manifest, recorded two Stop advisory fixtures to reach 45 JSON cases, and updated UserPromptSubmit/PreToolUse/Stop expected decisions for the Team-Native hook state machine.
- 04: Attributed six apply_patch change-delivery PreToolUse fixtures and recorded 51-fixture two-shell validation, 10 host-wrapper cases, protected-action precedence, forged station denial, and source/runtime hook SHA parity.
## Archive Index
- None yet.
## Evidence Base
- source: `Scripts/tests/codex-hooks/fixtures/*.json`, `Scripts/tests/codex-hooks/fixtures/manifest.json`, and `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`.
- source: `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, `Codex/.codex/hooks.json`, and `.codex/hooks.json`.
- tool: `Measure-CodexHookGovernance` reported Red 0, Yellow 0, and untracked required fixtures 0 on 2026-07-08.
- director: 2026-07-08 protected memory-write instruction supplied UserPromptSubmit state-line expectations, PreToolUse guarded-action denial, advisory Stop warning fields, 45-fixture validation, runtime sync evidence, manifest/catalog mirror repair, accepted residual risks, and no git/push authority.
- director: 2026-07-09 protected memory-write instruction supplied six new apply_patch fixture attributions, 51-fixture two-shell validation, 10 host-wrapper cases, protected-action precedence, forged station denial, and source/runtime hook SHA parity.
## Read Contract
- Read this card before Codex hook JSON fixture changes; read `_system.scripts` for runner/Audit behavior and `_codex_core` for hook config/gate behavior.
## Conflicts and Supersession
- superseded: stale Stop block expectations, pre-state-machine UserPrompt/PreToolUse assumptions, and 39/41/43/45 fixture-count assumptions are replaced by the approved 51-fixture manifest/catalog repair.
## 中文摘要
- 此子卡只做 Codex hooks JSON fixture 歸屬；本次歸屬 51 個 fixture JSON 與 `manifest.json`，manifest/catalog 均以 51 required fixtures 為準。
- UserPromptSubmit fixture 現要求指定中文句與 Team-Native 狀態行；PreToolUse 依 host-level actor/station evidence 判斷 write-like routing，拒絕 captain/unknown/forged station 與 protected action。
- Stop 完成風險 fixture 現在是 advisory allow，附 `COMPLETION_EVIDENCE_WARNING=true` 與 `DIRECTOR_FINAL_ACCEPTANCE_REQUIRED=true`；前站驗證回報 host-wrapper 10 cases、Windows PowerShell 與 `pwsh` fixture runners 各 51 passed、source/runtime hook SHA parity true。
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
- Scripts/tests/codex-hooks/fixtures/manifest.json
## Relations
- _system.scripts (parent runner/script governance); _codex_core (hook config/gate script); _shared.team-native-core (Team-Native governance)
## Applicable Skills
- memory-ops — fixture attribution/staleness repair/memory commit; memory-arch — fixture ownership splits or topology changes.
