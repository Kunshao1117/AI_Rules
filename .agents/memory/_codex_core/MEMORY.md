---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-09T17:01:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T16:56:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-08-001
cycle_event_count: 11
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
- Codex README installed-surface documentation treats shared governance references as the explicit Shared allowlist plus `Shared/policies/` and `Shared/mcp-profiles/`; project tools and context templates are documented as separate deployed surfaces.
- The Codex source `.codex/AGENTS.md` shared subagent marker is kept normalized with the deployed runtime `.codex/AGENTS.md` marker; D0 validation asserts the marker blocks match.
- Hook config keeps six active events and delegates through `team-native-launcher.ps1`; Windows `commandWindows` resolves repo root from `payload.cwd` when host process CWD is outside the repo.
- `PreToolUse` trusts host-level actor/station evidence, denies protected actions before write routing, and rejects forged delegation/action metadata in `spawn_agent` and `send_input`.
- Codex 03-build, 04-fix, and 07-debug workflow skills may route optional `coding-reflection-gate` reflection/retry checks before build-plan or execution_spec; the route does not replace authorization, implementation, validation, review, memory, or completion evidence.
- Hook messages remain ASCII-only Base64 decoded as UTF-8; `Stop` is advisory/allow with completion warning fields, while `SubagentStop` still requires delivery summary/status/evidence/risk/handoff fields.
- Source/runtime hook SHA parity was true for hooks config, gate, and launcher on 2026-07-09; validation passed 65 fixtures across Windows PowerShell and `pwsh`, commandWindows host-wrapper checks passed 10 cases including PreToolUse/SessionStart non-repo process CWD plus `payload.cwd` repo-root resolution, and Zone.Identifier streams were absent.
- Governance audit recognizes the launcher-to-gate architecture and source/runtime launcher hash parity, but `ReleaseReady` remains false until `Codex/.codex/hooks/team-native-launcher.ps1` and 14 required fixtures are tracked.
## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning; exact hook/test/resource tokens remain canonical evidence.
- Active-card content must stay under `line_limit: 120`; child cards own support workflow and fixture-specific details.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.

## Cycle Events
- 11: Recorded Codex README Installed Surfaces repair and source/runtime shared subagent marker parity guard in D0 validation.
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
- source: `Codex/README.md` Installed Surfaces table and `Codex/.codex/AGENTS.md` shared subagent marker verified from current diff on 2026-07-09.
- tool: `cartridge-system__memory_status` reported `_codex_core` content complete with stale warning before this repair on 2026-07-09.
- tool: `Scripts/tests/Validate-D0Minimal.ps1 -SkipNpmAudit` validated Codex source/runtime shared subagent marker parity on 2026-07-09.
- source: `Codex/.codex/hooks.json`, `.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, `Codex/.codex/hooks/team-native-launcher.ps1`, and `.codex/hooks/team-native-launcher.ps1`.
- source: `Codex/.codex/config.toml`, `.codex/config.toml`, `Codex/.codex/AGENTS.md`, `Codex/README.md`, `Codex/install.ps1`, and `Codex/global/AGENTS.md`.
- source: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1` and `Scripts/tests/codex-hooks/fixtures/*.json`.
- tool: `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1 -RequireAllShells -VerifyRuntimeSync` reported source/deployed sync verified, 65 fixtures x 2 shells passed, 10 commandWindows host-wrapper cases passed, and 51 tracked/14 untracked fixtures on 2026-07-09.
- tool: `Measure-CodexHookGovernance` reported `Status=Checked`, `ReleaseReady=False`, `RedCount=1`, `YellowCount=14`, and `UntrackedRequiredFixtureCount=14` on 2026-07-09.
- tool: `Get-FileHash -Algorithm SHA256` and Zone.Identifier checks verified hooks config, gate, and launcher source/runtime hash parity with no Zone.Identifier streams on 2026-07-09.
- upstream_artifact:2026-07-08 — Reported optional coding-reflection-gate reflection/retry routing in `Codex/.agents/workflow-skills/03-build-建構/SKILL.md`, `04-fix-修復/SKILL.md`, and `07-debug-除錯/SKILL.md`.
- director: 2026-07-09 protected memory-write instruction supplied host-level actor/station PreToolUse routing, protected-action precedence, ASCII Base64 hook messages, commandWindows host-wrapper semantics, 51-fixture validation, source/runtime hook SHA parity, and no memory_commit authority.

## Read Contract
- Read this card for Codex core governance, hook runtime/config, source/deployed sync, or tracked workflow entries; read `_system.scripts` for hook runner/audit and `_system.scripts.codex-hooks-fixtures` for JSON fixtures.

## Conflicts and Supersession
- superseded: prior Stop block memory is replaced by advisory-only Stop completion-risk behavior; SubagentStop delivery-field hard gate remains separate.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.
- pending-follow-up: current hook-runtime facts remain based on the separate hook validation lane; this sync repair only records README and `AGENTS.md` marker parity facts.

## 中文摘要
- Codex README 的 Installed Surfaces 已把 Shared 治理參考、project tools、context templates 拆開描述。
- Codex source `.codex/AGENTS.md` 的 shared subagent marker 已與 runtime `.codex/AGENTS.md` 做 normalized parity guard。
- Codex hook 現在以 `team-native-launcher.ps1` 作為 source/runtime launcher；Windows inline resolver 會讀 stdin JSON，用 `payload.cwd` 或目前位置尋找 launcher，再由 launcher 轉交 gate。
- hook 行為另案持續；本輪同步修復只記錄 README 與 `AGENTS.md` marker parity。

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
