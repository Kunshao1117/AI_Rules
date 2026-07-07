---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-08T05:07:36+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T05:06:01+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 1
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
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total.
- Current Team mode activates only for the current governed Director request; the captain coordinates scope, dispatch, artifact receipt, blocker/protected-gate routing, and Traditional Chinese reporting without backfilling station-owned evidence.
- Source-write eligibility uses station-owned `change-delivery` under `formal-write`, authorization phase `implementation-change-delivery`, exact file allowlist, dirty diff read, and no protected action; `change-application` is only for returned artifacts, explicit integration, or assigned generated/deployed sync.
- Protected actions include memory/project-context mutation, git, release, deploy, install, credentials, destructive filesystem operations, cloud mutation, and external mutation; source-write approval does not authorize them.
- Active Codex hooks are `SessionStart`, `UserPromptSubmit`, `SubagentStart`, `PreToolUse`, `Stop`, and `SubagentStop`; `hooks.json` uses the official top-level `hooks` object and Windows `commandWindows` uses `pwsh -EncodedCommand` to avoid BackgroundJob/non-JSON stdout.
- Hook runtime now emits `AI_RULES_HOOK_EVENT` markers for `SessionStart` and `UserPromptSubmit`; `PreToolUse` inspects `command`, `cmd`, `script`, and nested tool input command fields before denying repo inventory commands such as `rg --files` and `git ls-files`.
- `Stop` reads `last_assistant_message` with `message`/`text` fallback, strips hook-feedback and fixture-path noise before classifying completion claims, and block output is minimal top-level JSON with only `decision` and `reason`.
- `SubagentStart` reminds workers to avoid recursive delegation and protected actions; `SubagentStop` requires summary/status, evidence, risk/blocker, and next-step/handoff fields before closing.
- Source/runtime parity was verified on 2026-07-08 for `Codex/.codex/hooks.json`, `.codex/hooks.json`, both `team-native-gate.ps1` copies, and both Codex `.codex/config.toml` copies; user-global `AGENTS.md` parity remains a separate pending sync risk.
- Validation and review evidence accepted wrapper semantics with residual `pwsh` dependency risk; fixture suite and hook governance audit are release-ready with 43 tracked fixtures.

## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning; exact hook/test/resource tokens remain canonical evidence.
- Active-card content must stay under `line_limit: 120`; child cards own support workflow and fixture-specific details.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.

## Cycle Events
- 01: Compacted stale hook-cycle noise and recorded current active hook runtime behavior, source/runtime parity, validation snapshot, review accepted-risk, and protected follow-up boundaries.

## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md — Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, and `.codex/hooks/team-native-gate.ps1`.
- source: `Codex/.codex/config.toml`, `.codex/config.toml`, `Codex/.codex/AGENTS.md`, `Codex/README.md`, and `Codex/global/AGENTS.md`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` and `Scripts/tests/codex-hooks/fixtures/*.json`.
- tool: Gateway `memory_audit`, `memory_status`, and `memory_read` for `_codex_core`, `_system.scripts`, and `_system.scripts.codex-hooks-fixtures` on 2026-07-08.
- tool: `git diff` and `git status --short` for the authorized memory files plus Codex hook/config and fixture sources reviewed on 2026-07-08.
- tool: `Get-FileHash -Algorithm SHA256` verified source/runtime Codex hook/config parity on 2026-07-08.
- director: 2026-07-08 protected memory-write instruction supplied validation pass summary, review accepted-risk, fixture tracking repair, and no release/deploy/install boundary.

## Read Contract
- Read this card when work touches Codex core governance, Codex hook runtime/config, framework source/deployed sync, or the tracked core workflow entries below.
- Read `_system.scripts` for hook runner and audit behavior, and `_system.scripts.codex-hooks-fixtures` for JSON fixture ownership.

## Conflicts and Supersession
- superseded: prior reminder-only hook memory is replaced by current six-event hook runtime behavior and Stop/SubagentStop guards.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.

## 中文摘要
- Codex 是 OpenAI Codex 平台適配層；目前記錄的是六個 active hook event 與 source/runtime parity。
- `commandWindows` 改用 `pwsh -EncodedCommand`，避免 Windows wrapper 產生非 JSON stdout。
- `PreToolUse` 會檢查巢狀 `cmd`/`command` 並阻擋 repo inventory；`Stop` block 僅輸出 `decision` 與 `reason`。
- `SubagentStop` 要求摘要、證據、風險與下一步；不授權 protected actions。
- 驗證已由前站回報通過；wrapper 語意接受且 43 fixtures 已納入追蹤，仍有 `pwsh` runtime 依賴風險。

## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks.delete
- Codex/.codex/hooks/team-native-gate.ps1
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
