---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-09T21:50:33+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T21:45:55+08:00'
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
# _codex_core — Codex Edition Memory
## Current Truth
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total, and its installer SHA helper accepts blank optional hashes while non-empty values remain 64-hex checked.
- Current Team mode activates only for the current governed Director request; the captain coordinates scope, dispatch, artifact receipt, blocker/protected-gate routing, and Traditional Chinese reporting without backfilling station-owned evidence.
- Codex README installed-surface documentation treats shared governance references as the explicit Shared allowlist plus `Shared/policies/` and `Shared/mcp-profiles/`; project tools and context templates are documented as separate deployed surfaces.
- The Codex source `.codex/AGENTS.md` shared subagent marker is kept normalized with the deployed runtime `.codex/AGENTS.md` marker; D0 validation asserts the marker blocks match.
- Hook config keeps only three directive-injection events, `SessionStart`, `UserPromptSubmit`, and `PreToolUse`, and delegates through `team-native-launcher.ps1`; Windows `commandWindows` preserves stdin, resolves repo root from `payload.cwd` or process CWD, and passes fallback stdin through `AI_RULES_HOOK_STDIN`.
- Active hook output is `mandatory-directive-v1`: injected text says the user/operator requires captain-led Team-Native routing even when Codex platform or model layers expose general tool capability; `DIRECTIVE_AUTHORITY=user_operator_team_native_requirement`, `NON_IGNORABLE_DIRECTIVE=true`, and `PRETOOL_GUARD=mandatory_directive` are canonical context markers.
- Codex 03-build, 04-fix, and 07-debug workflow skills may route optional `coding-reflection-gate` reflection/retry checks before build-plan or execution_spec; the route does not replace authorization, implementation, validation, review, memory, or completion evidence.
- Hook messages remain ASCII-only Base64 decoded as UTF-8; `SubagentStart`, `SubagentStop`, and `Stop` are outside the active Codex hook event set for this model.
- Governance audit/test source recognizes the three-event mandatory directive model; `Scripts/modules/Audit/50.CodexHookGovernance.ps1`, `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, and the retained allowlist fixture are synchronized to `mandatory-directive-v1`.
## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning; exact hook/test/resource tokens remain canonical evidence.
- Active-card content must stay under `line_limit: 120`; child cards own support workflow and fixture-specific details.
- Do not reintroduce active hook wording such as `提醒`, `reminder`, `advisory`, `NO_DENY_OR_BLOCK`, `REMINDER_ONLY`, `只提示`, or `不阻擋`.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.

## Cycle Events
- 01-10: Compacted prior Codex hook, workflow-skill, installer, Stop, commandWindows, launcher, and source/runtime parity events; still-valid facts remain in Current Truth and Evidence Base.
- 11: Recorded Codex README Installed Surfaces repair and source/runtime shared subagent marker parity guard in D0 validation.
- 12: Replaced active hook memory with the three-event reminder-only model, now superseded by event 13.
- 13: Updated Codex hook memory to `mandatory-directive-v1`: the three active events inject non-ignorable user/operator Team-Native requirements, Codex platform capability cannot override that requirement, and old reminder/advisory wording is excluded from active output.

## Archive Index
- archive-003.md — Older events 13-22; archive-001.md — legacy pre-schema-v2 card; archive-002.md — pre-standardization MEMORY.md migration snapshot.

## Evidence Base
- source: `Codex/README.md` Installed Surfaces table and `Codex/.codex/AGENTS.md` shared subagent marker verified from current diff on 2026-07-09.
- tool: `Scripts/tests/Validate-D0Minimal.ps1 -SkipNpmAudit` validated Codex source/runtime shared subagent marker parity on 2026-07-09.
- source: `Codex/.codex/hooks.json` and `.codex/hooks.json` current content on 2026-07-09 keeps only `SessionStart`, `UserPromptSubmit`, and `PreToolUse` directive events.
- source: `Codex/.codex/hooks/team-native-gate.ps1`, `.codex/hooks/team-native-gate.ps1`, `Codex/.codex/hooks/team-native-launcher.ps1`, and `.codex/hooks/team-native-launcher.ps1` current diff on 2026-07-09 implements mandatory directive output with `NON_IGNORABLE_DIRECTIVE=true`.
- source: `Codex/.codex/config.toml`, `.codex/config.toml`, `Codex/.codex/AGENTS.md`, `Codex/README.md`, `Codex/install.ps1`, and `Codex/global/AGENTS.md`.
- source: `Scripts/modules/Audit/50.CodexHookGovernance.ps1`, `Scripts/tests/codex-hooks/Invoke-CodexHookFixtureTests.ps1`, and `Scripts/tests/codex-hooks/fixtures/allow-pretool-apply-patch-change-delivery-allowlist.json` current content on 2026-07-09 enforces `mandatory-directive-v1`, commandWindows wrapper checks, directive fallback contracts, and absence of old reminder-only markers.
- tool: full fixture run with `-VerifyRuntimeSync` passed on 2026-07-09: source/deployed sync, 6 directive fallback cases, 12 `commandWindows` host-wrapper cases, and 1 active fixture with 64 skipped legacy fixtures.
- tool: `Measure-CodexHookGovernance` passed on 2026-07-09 with `ReleaseReady=True`, `RedCount=0`, `YellowCount=0`, and no findings.
- tool: `Get-FileHash -Algorithm SHA256` verified hooks config, gate, and launcher source/runtime hash parity on 2026-07-09.
- upstream_artifact:2026-07-08 — Reported optional coding-reflection-gate reflection/retry routing in `Codex/.agents/workflow-skills/03-build-建構/SKILL.md`, `04-fix-修復/SKILL.md`, and `07-debug-除錯/SKILL.md`.
- tool: 2026-07-09 team tool smoke confirmed subagent `apply_patch` create/delete of `.tmp/hooks-live-reminder-subagent-write.txt` and readonly `rg --files .codex Codex/.codex` both succeeded without hook blocking.

## Read Contract
- Read this card for Codex core governance, hook runtime/config, source/deployed sync, or tracked workflow entries; read `_system.scripts` for hook runner/audit and `_system.scripts.codex-hooks-fixtures` for JSON fixtures.

## Conflicts and Supersession
- superseded: prior six-event, `Stop`/`SubagentStop`, deny/block, advisory, and reminder-only memory is replaced by the three-event `mandatory-directive-v1` model.
- pending-review: user-global deployment remains hash-mismatched to `Codex/global/AGENTS.md`; report global parity as pending until a governed sync applies it.
- pending-follow-up: memory metadata sync remains pending until the parent opens the separate protected `memory_commit` phase.

## 中文摘要
- Codex README 的 Installed Surfaces 已把 Shared 治理參考、project tools、context templates 拆開描述。
- Codex source `.codex/AGENTS.md` 的 shared subagent marker 已與 runtime `.codex/AGENTS.md` 做 normalized parity guard。
- Codex hook 目前只保留 `SessionStart`、`UserPromptSubmit`、`PreToolUse` 三項強制規範注入事件。
- 注入內容明確標示使用者/操作者要求優先；即使 Codex 平台或模型層提供一般工具能力，也不能覆蓋 Team-Native 隊長分工要求。
- 目前模型是 `mandatory-directive-v1`，核心標記包含 `DIRECTIVE_AUTHORITY=user_operator_team_native_requirement`、`NON_IGNORABLE_DIRECTIVE=true`、`PRETOOL_GUARD=mandatory_directive`。

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
