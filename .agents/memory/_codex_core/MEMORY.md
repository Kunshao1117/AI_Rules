---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-13T17:20:20+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-13T16:48:52+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
cycle_event_count: 3
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

- The Codex V1 adapter governs `fast` → Luna/`medium`, `balanced` → Terra/`medium`, and `deep` → Sol/`medium`; Sol/`xhigh` is allowed only after a reliable scoped failure or irreversible critical decision with explicitly resolved effort.
- V1 dispatch requires `agent_type`, `fork_context`, `items`, `model`, and `reasoning_effort`; `items` and `message` are exclusive, and `prompt` is prohibited. Named overrides use `fork_context: false`.
- If `multi_agent_v1__spawn_agent` is unavailable, emit `V1_NOT_AVAILABLE` and stop without a V2 fallback. `role_id` is resolved to `agent_type` separately from model selection.
- Requested, accepted, and applied values are separate. Without a receipt, applied model and effort are `unreported` and application state is `unverified`.
- The member prompt begins with the fixed three role-boundary sentences. `Scripts/Watch-CodexModelV1.ps1` is a local experimental workaround, not a formal Codex adapter capability or platform guarantee; the formal V1 adapter contract must not depend on the watcher or a volatile cache format.

## Active Constraints

- The Codex adapter consumes the sole Director-output owner in `Shared/policies/language-governance.md`; it does not restate that order.
- Current source and deployed `AGENTS.md` copies must remain synchronized.
- A watcher or its local cache behavior is supporting script evidence only and cannot establish a platform-applied model or capability.

## Cycle Events

- 01: Compacted the active card and recorded the Director-output owner, captain boundary, and Codex source/runtime parity.
- 02: Reverified V1 route conditions, schema exclusivity, no-V2 fallback, fixed member prefix, receipt variance handling, and source/deployed AGENTS parity.
- 03: Clarified that the local watcher is outside the formal V1 adapter contract and cannot imply a platform guarantee.

## Archive Index

- archive-003.md — Older events 13-22; archive-001.md / archive-002.md — legacy and migration history.

## Evidence Base

- source/deployed: `Codex/.codex/AGENTS.md` and `.codex/AGENTS.md` — identical V1 adapter contract, route mapping, no-V2 fallback, fixed prompt prefix, and receipt reconciliation.
- source: `Scripts/tests/codex-subagents/Invoke-CodexSubagentV1ContractFixtureTests.ps1` — four routes, schema cases, prefix assertion, receipt variance, and adapter exclusion of `Watch-CodexModelV1.ps1`.
- source: `Scripts/Watch-CodexModelV1.ps1` — local experimental disclaimer and guarded cache-write implementation; source confirms only script behavior, not platform capability.

## Read Contract

- Read for Codex adapter governance, V1 dispatch contract, source/deployed parity, or related fixtures.

## Conflicts and Supersession

- superseded: any claim that a requested or accepted route proves the platform applied that model or effort.

## 中文摘要

- Codex V1 僅有四條受管路線；Sol/`xhigh` 必須同時符合受限失敗或不可逆關鍵決策，以及已明確解析的推理強度。
- V1 不可用時輸出 `V1_NOT_AVAILABLE` 並停止，不得回退 V2；平台未回傳收據時不得猜測實際套用值。
- `Watch-CodexModelV1.ps1` 是本機實驗性 workaround，正式 V1 adapter 不得依賴它或把快取格式當平台保證。

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
- .codex/AGENTS.md

## Relations

- _system (root governance); _shared (Shared policy); _system.scripts (runner ownership).

## Applicable Skills

- memory-ops — authorized source-memory update and separate commit procedure.
