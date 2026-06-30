---
name: _system.scripts.codex-hooks
scopePath: Scripts/tests/codex-hooks/
description: >-
  專案記憶：Codex hooks 測試 runner 與 Team-Native gate fixtures。Use when: task touches
  Codex hook validation.
last_updated: '2026-06-30T16:00:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-30T15:13:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-30-001
cycle_event_count: 3
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
- The fixtures validate Team-Native hook outcomes across 52 cases for prompt hints, read-only allowance, broad-read Captain-Lite context, scoped writes, out-of-scope writes, current payload versus historical transcript separation, same-record protected authorization, multi-protected partial authorization, release/deploy filename false positives, exact write target matching, protected mutation blocks, specialist lifecycle events, live Stop payload coverage, short and mixed completion-claim blocks, non-complete state exceptions, read-only report exceptions, and completion artifact gates.
- The fixture runner supports inline transcript text, temporary transcript path injection, raw hook input, expected and forbidden regex assertions, and temporary transcript cleanup.
- Hook behavior is coupled to Codex hook source files and Team-Native Core governance; review those cards when fixture expectations change.
## Active Constraints
- Keep fixtures deterministic and offline; they must not require real git mutation, memory mutation, deployment, release, network calls, or credentials.
- Fixture names describe allow, block, or context outcomes; live platform testing is still required when platform hook behavior changes.
## Cycle Events
- 03: Added 11 Stop hook fixtures for live last_assistant_message payloads, active Stop continuation blocking, short all-set completion claims, mixed completion claims with negated tests or read-only text, negated incomplete sentences, Chinese quoted completion text, read-only search reports, Chinese-key English non-complete states, and Chinese test-passed blocking; fixture runner passed 52 cases.
- 02: Hooks Stability Implementation finalized 41 fixtures for current payload evidence separation, transcript pollution, same-record protected authorization, multi-protected partial authorization, release/deploy filename false positives, exact write target matching, and completion claim boundaries; final hook/config hash parity, fixture runner, Doctor, review, and validation passed with a nonblocking deploy.patch dedicated-fixture gap.
- 01: Created fixture ownership for the Hooks-Usability closeout after Codex hook tests became versioned governance assets.
## Archive Index
- None yet.
## Evidence Base
- source:Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 — fixture runner.
- source:Scripts/tests/codex-hooks/fixtures/*.json — allow, block, and context fixtures.
- source:Codex/.codex/hooks/team-native-gate.ps1; tool:Codex hook fixture runner; director:2026-06-30 GO Hooks-Usability Closeout.
## Read Contract
- Read this card when changing Codex hook fixture runner, fixture cases, hook live-test expectations, or Doctor checks for hook fixtures.
- Also read `_codex_core` for hook source files and `_shared.team-native-core` for Team-Native semantics.
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
## Relations
- _system.scripts (parent), _codex_core (hook source), _shared.team-native-core (semantics)
## Applicable Skills
- memory-ops for fixture ownership and stale state; memory-arch if fixture groups split.
