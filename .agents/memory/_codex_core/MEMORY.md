---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-11T21:11:23+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-10T18:30:45+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
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
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md`; Codex deploys 62 shared skills plus 17 workflow skills for a 79-skill deployed total, and its installer SHA helper accepts blank optional hashes while non-empty values remain 64-hex checked.
- Current Team mode activates only for the current governed Director request; the captain coordinates scope, dispatch, artifact receipt, blocker/protected-gate routing, and Traditional Chinese reporting without backfilling station-owned evidence.
- The complete Director-facing action order is owned only by `Shared/policies/language-governance.md`, heading `Captain Integration And Director Output Gate`; Codex core consumes that owner and does not define or restate the order.
- Captain synthesis may translate and summarize delivery artifacts, but it cannot substitute for station-owned implementation, validation, review, memory/docs attribution, or completion evidence.
- Codex README installed-surface documentation treats shared governance references as the explicit Shared allowlist plus `Shared/policies/` and `Shared/mcp-profiles/`; project tools and context templates are documented as separate deployed surfaces.
- The Codex source `.codex/AGENTS.md` shared subagent marker is kept normalized with the deployed runtime `.codex/AGENTS.md` marker; D0 validation asserts the marker blocks match.
- Hook config keeps only three directive-injection events, `SessionStart`, `UserPromptSubmit`, and `PreToolUse`, and delegates through `team-native-launcher.ps1`; Windows `commandWindows` preserves stdin, resolves repo root from `payload.cwd` or process CWD, and passes fallback stdin through `AI_RULES_HOOK_STDIN`.
- Active hook output is `mandatory-directive-v1`: injected text says the user/operator requires captain-led Team-Native routing even when Codex platform or model layers expose general tool capability; `DIRECTIVE_AUTHORITY=user_operator_team_native_requirement`, `NON_IGNORABLE_DIRECTIVE=true`, and `PRETOOL_GUARD=mandatory_directive` are canonical context markers.
- Repository-local `Codex/.codex/AGENTS.md` and `.codex/AGENTS.md` reached exact source/runtime parity after governed synchronization.
## Active Constraints
- Verify current behavior from Codex source, deployed runtime copies, tests, and Gateway memory evidence; this card is not runtime authority by itself.
- Director-facing text starts with Traditional Chinese meaning and consumes the sole action-order owner in `Shared/policies/language-governance.md`; exact hook/test/resource tokens remain canonical evidence.
- Requested model/profile values do not prove platform application; the current startup applied-values receipt remains an `unverified trace variance` and must not be promoted to confirmed state.
- Memory content repair does not authorize `memory_commit`, memory reindex, git staging/commit, release, deploy, install, credentials, or external mutation.
## Cycle Events
- 01: Compacted the active card, recorded the sole Director-output owner and captain boundary, and corrected parity evidence to the repository-local Codex source/runtime pair.
## Archive Index
- archive-003.md — Older events 13-22; archive-001.md — legacy pre-schema-v2 card; archive-002.md — pre-standardization MEMORY.md migration snapshot.
## Evidence Base
- source: `Codex/.codex/AGENTS.md` — reference to the sole Director-output owner, captain boundary, completion evidence, lifecycle, and tracked Codex governance.
- source: `Codex/README.md`, `Codex/install.ps1`, `Codex/global/AGENTS.md`, and `Codex/.codex/config.toml` — installed surfaces, bootstrap, and platform configuration.
- filesystem: repository-local `Codex/.codex/AGENTS.md` and `.codex/AGENTS.md` were verified at exact parity after synchronization on 2026-07-10.
- source: `Codex/.codex/hooks.json`, `Codex/.codex/hooks/team-native-gate.ps1`, and `Codex/.codex/hooks/team-native-launcher.ps1` — current three-event mandatory directive model.
- tool: prior D0 and Codex hook governance evidence remains supporting history; current source overrides stale tool summaries.
## Read Contract
- Read this card for Codex core governance, hook runtime/config, source/deployed sync, or tracked workflow entries; read `_system.scripts` for hook runner/audit and `_system.scripts.codex-hooks-fixtures` for JSON fixtures.
## Conflicts and Supersession
- superseded: the prior Codex-core restatement of the complete Director-facing order is replaced by a reference to the sole owner in `Shared/policies/language-governance.md`.
- superseded: prior six-event, `Stop`/`SubagentStop`, deny/block, advisory, and reminder-only memory is replaced by the three-event `mandatory-directive-v1` model.
- completed: this cycle's `memory_commit` finished; MCP confirmed `staleness: 0`, `healthy`, and `pendingChanges: []`.
## 中文摘要
- 完整的總監輸出順序只由 `Shared/policies/language-governance.md` 的 `Captain Integration And Director Output Gate` 定義；Codex core 僅引用，不再重述。
- 專案內 `Codex/.codex/AGENTS.md` 與 `.codex/AGENTS.md` 已達 exact parity；不再使用無法在專案內驗證的使用者全域雜湊。
- 隊長可統整交付件，但不能替代實作、驗證、審查、記憶文件或完成證據。
- Codex hook 仍採三事件 `mandatory-directive-v1`，本輪未修改 hook 範圍。
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
