---
name: _system.scripts.codex-hooks
scopePath: Scripts/tests/codex-hooks/
description: >-
  專案記憶：Codex hooks 測試 runner 與 Team-Native gate fixtures。Use when: task touches
  Codex hook validation.
last_updated: '2026-07-01T09:38:15+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-01T09:32:41+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-30-001
cycle_event_count: 6
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _system.scripts.codex-hooks — Codex Hook Fixture Memory
## Current Truth
- This child card owns the Codex hook fixture runner and JSON fixtures under `Scripts/tests/codex-hooks/`.
- The fixtures validate Team-Native hook outcomes across 53 cases for prompt hints, read-only allowance, broad-read Captain-Lite context, scoped writes, out-of-scope writes, current payload versus historical transcript separation, same-record protected authorization, multi-protected partial authorization, release/deploy filename false positives, exact write target matching, protected mutation blocks, specialist lifecycle events, live Stop payload coverage, short and mixed completion-claim blocks, non-complete state exceptions, read-only report exceptions, completion artifact gates, and Chinese natural-language scope binding.
- The fixture runner supports inline transcript text, temporary transcript path injection, raw hook input, expected and forbidden regex assertions, temporary transcript cleanup, selectable shell execution, default Windows PowerShell plus PowerShell 7 matrix coverage, and UTF-8 console setup when supported.
- The fixture runner supports `expectedDiagnosticLabels` checks for hook block output labels: governance hard gate, blocked action, reason, missing evidence, allowed next steps, and forbidden next steps.
- Shell resolution is application-only: the runner ignores function/alias shadowing, validates concrete executable paths, warns and skips missing shells in non-strict mode, and blocks missing shells when strict shell coverage is required.
- The structured-payload fixtures cover text-only trace denial, missing role identity, fake transcript board denial, protected authorization scope, and literal Chinese completion claims; the Chinese natural-language binding fixture is now a tracked fixture file.
- Existing tracked fixtures now cover everyday-language prompts (`go` plus Chinese "so what"), natural-language no-scope write denial, post-block retry/tool-switch denial, explicit blocked-state allowance, and read-only commands that mention `Scripts/Deploy.ps1`.
- Protected mutation fixtures now require scope-bound `protected_authorization`, a trusted tool execution envelope, and a matching trusted execution receipt with the same envelope id or nonce, allowed decision, matching action/target/scope, trusted issuer/source, verified or signed signature state, and fresh nonce.
- Existing and newly tracked fixtures cover allow, only-envelope block, only-receipt block, mismatched receipt block, non-allowed decision block, model/self-reported-looking envelope block, and Chinese natural-language prompt binding.
- Hook behavior is coupled to Codex hook source files and Team-Native Core governance; review those cards when fixture expectations change.
## Active Constraints
- Keep fixtures deterministic and offline; fixture names describe allow, block, or context outcomes, and live platform testing is still required when platform hook behavior changes.
## Cycle Events
- 09: Added the Chinese natural-language prompt binding fixture to tracked ownership and updated fixture memory to 53 cases after the runner passed the Windows PowerShell and PowerShell 7 shell matrix.
- 08: Tightened protected mutation fixtures so a scoped authorization must be paired with a trusted tool execution envelope and a matching trusted execution receipt; only-envelope, only-receipt, mismatched receipt, non-allowed decision, and model-filled cases stay blocked.
- 06: Added diagnostic-label fixture assertions plus natural-language prompt, post-block retry denial, blocked-state allowance, and read-only Deploy.ps1 path coverage; fixture runner passed 52 cases across Windows PowerShell and PowerShell 7.
- 05: Hardened shell resolution to require application executable paths, prevent function/alias shadowing, and distinguish non-strict shell skips from strict shell blockers.
- 04: Added shell-matrix and UTF-8 fixture runner coverage, then repurposed tracked fixtures to cover structured-payload requirements, fake transcript distrust, missing role identity, and Chinese completion detection while keeping Red drift under tracked fixture ownership.
## Archive Index
- None.
## Evidence Base
- source:Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1; source:Scripts/tests/codex-hooks/fixtures/*.json; source:Codex/.codex/hooks/team-native-gate.ps1; tool:Codex hook fixture runner; director:2026-06-30 GO Hooks-Usability Closeout.
## Read Contract
- Read this card when changing Codex hook fixture runner, fixture cases, hook live-test expectations, Doctor checks for hook fixtures, `_codex_core` hook source files, or `_shared.team-native-core` semantics.
## Conflicts and Supersession
- None.
## 中文摘要
- 這張子卡負責 Codex hooks 測試 runner 與 fixture；規則改動後要重跑 fixture，必要時做 live platform 測試。
## Tracked Files
- Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1
- Scripts/tests/codex-hooks/fixtures/allow-pretool-protected-git-apply-authorized.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-rg-no-board.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-single-file-no-board.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-readonly-transcript-pollution.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-shell-redirect-authorized.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-specialist-deep-read-formal-readonly.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-with-board.json
- Scripts/tests/codex-hooks/fixtures/allow-pretool-write-authorized.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-active-honest-unverified-report.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-blocked-state.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-full-artifacts.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-honest-unverified-report.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-negated-incomplete-sentence.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-quoted-completion-text.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-quoted-zh-completion-text.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-readonly-search-report.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-zh-key-closed-with-director-risk-state.json
- Scripts/tests/codex-hooks/fixtures/allow-stop-zh-not-complete-state.json
- Scripts/tests/codex-hooks/fixtures/allow-subagent-stop-zh-report.json
- Scripts/tests/codex-hooks/fixtures/allow-user-prompt.json
- Scripts/tests/codex-hooks/fixtures/allow-user-prompt-zh-natural-binding.json
- Scripts/tests/codex-hooks/fixtures/bad-input.json
- Scripts/tests/codex-hooks/fixtures/block-apply-patch-no-board.json
- Scripts/tests/codex-hooks/fixtures/block-bash-write-no-board.json
- Scripts/tests/codex-hooks/fixtures/block-command-fake-board.json
- Scripts/tests/codex-hooks/fixtures/block-fake-role-only.json
- Scripts/tests/codex-hooks/fixtures/block-permission-no-board.json
- Scripts/tests/codex-hooks/fixtures/block-permission-write-tool-no-board.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-current-dangerous-bypass.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-git-apply-no-auth.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-npm-install-no-auth.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-protected-mutation-general-board.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-shell-redirect-no-auth.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-write-draft-board.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-write-out-of-scope.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-write-prefix-target.json
- Scripts/tests/codex-hooks/fixtures/block-pretool-write-transcript-fake-board.json
- Scripts/tests/codex-hooks/fixtures/block-stop-active-short-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-captain-broad-read-full-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-live-last-assistant-short-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-mixed-complete-with-negative-test.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-all-artifacts-fake-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-artifacts.json
- Scripts/tests/codex-hooks/fixtures/block-stop-missing-memory-docs.json
- Scripts/tests/codex-hooks/fixtures/block-stop-negated-unverified-fake-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-readonly-claims-source-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-readonly-plus-source-complete.json
- Scripts/tests/codex-hooks/fixtures/block-stop-short-all-set.json
- Scripts/tests/codex-hooks/fixtures/block-stop-zh-completion.json
- Scripts/tests/codex-hooks/fixtures/block-stop-zh-test-passed-no-artifacts.json
- Scripts/tests/codex-hooks/fixtures/block-trust-bypass.json
- Scripts/tests/codex-hooks/fixtures/context-pretool-captain-broad-read-no-board.json
- Scripts/tests/codex-hooks/fixtures/context-subagent-start.json
