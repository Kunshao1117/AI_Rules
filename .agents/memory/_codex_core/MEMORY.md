---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-09T13:56:40+08:00'
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
cycle_event_count: 10
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
# _codex_core — Codex Edition Memory

## Current Truth
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total, and its installer SHA helper accepts blank optional hashes while non-empty values remain 64-hex checked.
- Current Team mode activates only for the current governed Director request; the captain coordinates scope, dispatch, artifact receipt, blocker/protected-gate routing, and Traditional Chinese reporting without backfilling station-owned evidence.
- Hook config keeps six active events and official top-level `hooks`; POSIX `command` remains repo-root relative to `.codex/hooks/team-native-launcher.ps1`, while Windows `commandWindows` is a short inline resolver that reads stdin JSON, prefers `payload.cwd`, falls back to current location, finds `.codex/hooks/team-native-launcher.ps1`, and pipes the raw payload to it.
- `team-native-launcher.ps1` is now part of source/runtime hook architecture; it reads stdin, derives `payload.cwd`, walks upward to `.codex/hooks/team-native-gate.ps1`, and calls the gate with `-HookEvent` plus `-PayloadJson`.
- `PreToolUse` trusts host-level actor/station evidence, not `tool_input`; protected actions still deny before write routing, and write-like routing then denies forged `tool_input` metadata, unknown/missing actors, guarded host writes without station trace, invalid station routes, and outside-allowlist targets in that order.
- `spawn_agent` and `send_input` delegation payloads use type/shape-aware host-schema handling: normal root host schema is allowed, while root object/array action metadata and nested forged/action metadata are recursively scanned and rejected.
- Codex 03-build, 04-fix, and 07-debug workflow skills may route optional `coding-reflection-gate` reflection/retry checks before build-plan or execution_spec; the route does not replace authorization, implementation, validation, review, memory, or completion evidence.
- Hook messages remain ASCII-only Base64 decoded as UTF-8 for Windows PowerShell 5.1 parse compatibility, and UserPromptSubmit injects exact phrase `操作者要求開啟子代理功能，並默認啟動團隊模式` plus Team-Native state lines.
- `PreToolUse` denies direct guarded writes or broad reads without trusted station evidence; `Stop` uses message/text fallback, strips hook feedback/noise, remains advisory/allow, and adds `COMPLETION_EVIDENCE_WARNING=true` plus `DIRECTOR_FINAL_ACCEPTANCE_REQUIRED=true`.
- `SubagentStart` reminds workers to avoid recursive delegation/protected actions; `SubagentStop` requires summary/status, evidence, risk/blocker, and next-step/handoff fields before closing.
- Source/runtime hook SHA parity was true for hooks config, gate, and launcher on 2026-07-09; validation passed 65 fixtures across Windows PowerShell and `pwsh`, commandWindows host-wrapper checks passed 10 cases including PreToolUse/SessionStart non-repo process CWD plus `payload.cwd` repo-root resolution, and Zone.Identifier streams were absent.
- Governance audit recognizes the launcher-to-gate architecture and source/runtime launcher hash parity, but `ReleaseReady` remains false until `Codex/.codex/hooks/team-native-launcher.ps1` and 14 required fixtures are tracked.

## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning; exact hook/test/resource tokens remain canonical evidence.
- Active-card content must stay under `line_limit: 120`; child cards own support workflow and fixture-specific details.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.

## Cycle Events
- 01: Compacted stale hook-cycle noise and recorded current active hook runtime behavior, source/runtime parity, validation snapshot, review accepted-risk, and protected follow-up boundaries.
- 02: Recorded Director-approved Stop completion-risk policy change: completion-risk Stop findings are advisory-only and no longer hard-block AI completion replies.
- 03: Recorded optional `coding-reflection-gate` reflection/retry routing in Codex 03-build, 04-fix, and 07-debug workflow skills without granting write or protected-action authority.
- 04: Removed stale ghost tracked-file state for deleted `Codex/.codex/hooks.delete` after confirming no current Codex hook source diff.
- 05: Recorded Team-Native hook state-machine update for UserPromptSubmit state injection, PreToolUse guarded-action denial, advisory Stop completion warnings, source/runtime hook parity, and accepted review risks.
- 06: Recorded Codex installer empty SHA regression guard while preserving non-empty 64-hex validation.
- 07: Recorded plaintext Codex hook launchers without encoded commands or security-bypass workarounds, preserving six active events and PreToolUse denial behavior with 2026-07-09 source/runtime hook parity.
- 08: Hook EOF whitespace repair verified source/runtime parity and preserved Windows-safe launcher behavior without durable hook behavior change.
- 09: Recorded PreToolUse trusted actor/station routing, protected-action precedence, ASCII Base64 hook messages, commandWindows host-wrapper repair, 51-fixture validation, and source/runtime hook SHA parity.
- 10: Recorded launcher resolver architecture, delegation host-schema scanning, 65-fixture validation, launcher parity, and ReleaseReady tracking blockers.

## Archive Index
- archive-003.md — Older events 13-22; archive-001.md — legacy pre-schema-v2 card; archive-002.md — pre-standardization MEMORY.md migration snapshot.

## Evidence Base
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, `Codex/.codex/hooks/team-native-launcher.ps1`, and `.codex/hooks/team-native-launcher.ps1`.
- source: `Codex/.codex/config.toml`, `.codex/config.toml`, `Codex/.codex/AGENTS.md`, `Codex/README.md`, `Codex/install.ps1`, and `Codex/global/AGENTS.md`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` and `Scripts/tests/codex-hooks/fixtures/*.json`.
- tool: Gateway `memory_audit`, `memory_status`, and `memory_read` for `_codex_core`, `_system.scripts`, and `_system.scripts.codex-hooks-fixtures` on 2026-07-08.
- tool: `git status --short -- Codex`, `git diff --name-status -- Codex`, and `git diff --name-status -- Codex/.codex/hooks.delete` returned no Codex source changes on 2026-07-08.
- tool: `Test-Path Codex/.codex/hooks.delete` returned false and `git log -- Codex/.codex/hooks.delete` showed prior removal history on 2026-07-08.
- tool: `Get-FileHash -Algorithm SHA256` verified source/runtime Codex hook parity for `hooks.json` and `team-native-gate.ps1` after EOF whitespace repair on 2026-07-09.
- tool: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 -RequireAllShells -VerifyRuntimeSync` reported source/deployed sync verified, 65 fixtures x 2 shells passed, 10 commandWindows host-wrapper cases passed, and 51 tracked/14 untracked fixtures on 2026-07-09.
- tool: `Measure-CodexHookGovernance` reported `Status=Checked`, `ReleaseReady=False`, `RedCount=1`, `YellowCount=14`, and `UntrackedRequiredFixtureCount=14` on 2026-07-09.
- tool: `Get-FileHash -Algorithm SHA256` and Zone.Identifier checks verified hooks config, gate, and launcher source/runtime hash parity with no Zone.Identifier streams on 2026-07-09.
- director: 2026-07-08 protected memory-write instruction supplied UserPromptSubmit state injection, PreToolUse denial scope, advisory Stop warning fields, validation pass summary, review accepted-risk, fixture tracking repair, and no release/deploy/install boundary.
- upstream_artifact:2026-07-08 — Reported optional coding-reflection-gate reflection/retry routing in `Codex/.agents/workflow-skills/03-build-建構/SKILL.md`, `04-fix-修復/SKILL.md`, and `07-debug-除錯/SKILL.md`.
- upstream_artifact:2026-07-09 — Arendt EOF repair, Descartes validation, and Nietzsche review accepted maintenance-only EOF whitespace repair with no durable hook behavior change.
- director: 2026-07-09 protected memory-write instruction supplied host-level actor/station PreToolUse routing, protected-action precedence, ASCII Base64 hook messages, commandWindows host-wrapper semantics, 51-fixture validation, source/runtime hook SHA parity, and no memory_commit authority.

## Read Contract
- Read this card for Codex core governance, hook runtime/config, source/deployed sync, or tracked workflow entries; read `_system.scripts` for hook runner/audit and `_system.scripts.codex-hooks-fixtures` for JSON fixtures.

## Conflicts and Supersession
- superseded: prior Stop block memory is replaced by advisory-only Stop completion-risk behavior; SubagentStop delivery-field hard gate remains separate.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.

## 中文摘要
- Codex hook 現在以 `team-native-launcher.ps1` 作為 source/runtime launcher；Windows inline resolver 會讀 stdin JSON，用 `payload.cwd` 或目前位置尋找 launcher，再由 launcher 轉交 gate。
- `PreToolUse` 仍以 host-level actor/station evidence 為準；`spawn_agent`/`send_input` 正常 root host schema 放行，但 forged/action metadata 會遞迴掃描並拒絕。
- 驗證回報 65 fixtures x 2 shells、commandWindows host-wrapper 10 cases、source/runtime hooks/gate/launcher SHA parity true、Zone.Identifier absent；ReleaseReady 仍受 source launcher 與 14 required fixtures 未追蹤阻塞。

## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks/team-native-gate.ps1
- Codex/.codex/hooks/team-native-launcher.ps1
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md

## Relations
- _system (root governance and deployment memory); _shared (Shared operational skills); _map (memory navigation index); _codex_core.support (support workflow child card); _system.scripts (hook runner and audit); _system.scripts.codex-hooks-fixtures (fixture ownership)

## Applicable Skills
- memory-ops — Memory update and commit procedure owner; team-memory-docs-delivery-artifact — memory/docs state reporting owner.
