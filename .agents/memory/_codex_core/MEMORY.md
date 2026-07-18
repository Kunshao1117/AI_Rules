---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-18T11:56:27+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-17T20:08:47+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-10-001
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
- The Codex adapter owns six governed rungs: L1 Luna/medium, L2 Luna/xhigh, L3 Terra/medium, L4 Terra/xhigh, L5 Sol/medium, and L6 Sol/xhigh. Family selection uses the validated `U/E/R/V/B/A/D/C/F` projection, hard floors, and score contract; verifier strength alone never raises family.
- V1 dispatch requires the current callable schema to expose `fork_context`, `model`, `reasoning_effort`, and exactly one supported content carrier from `items` or `message`. `agent_type` is conditional on current-session schema exposure and must never be invented.
- Requested, accepted, and applied execution values are immutable peer layers. Transport IDs or a successful invocation do not prove acceptance or application; missing platform receipts remain `unreported` and `unverified`.
- Named model and effort values stay as `exact:<opaque-value>` in the immutable requested snapshot and lose exactly one `exact:` prefix only when projected into a supported tool payload.
- Model family and effort change wait-policy inputs only. They never change scope, authorization, role, review depth, validation, delivery slices, or protected gates; a status probe pauses the member until an explicit resume.
- `Scripts/Watch-CodexModelV1.ps1` remains a local experimental workaround and cannot establish a formal adapter capability or applied platform value.

## Active Constraints
- The Codex adapter consumes the sole Director-output owner in `Shared/policies/language-governance.md`; it does not restate that order.
- Current source and deployed `AGENTS.md` copies must remain synchronized.
- Every dispatch must use only fields exposed by the current callable schema; unavailable routes preserve the requested snapshot and stop without silent substitution.
- Internal receipt, wait-baseline, and lifecycle fields never enter the platform request payload.

## Cycle Events
- 01: Compacted the active card and recorded the Director-output owner, captain boundary, and Codex source/runtime parity.
- 02: Reverified V1 route conditions, schema exclusivity, no-V2 fallback, fixed member prefix, receipt variance handling, and source/deployed AGENTS parity.
- 03: Clarified that the local watcher is outside the formal V1 adapter contract and cannot imply a platform guarantee.
- 04: Replaced the four-route and mandatory-`agent_type` assumptions with the six-rung selector, current-schema payload gate, three-layer receipts, and model-aware wait contract.

## Archive Index
- archive-003.md — Older events 13-22; archive-001.md / archive-002.md — legacy and migration history.

## Evidence Base

- source/deployed: `Codex/.codex/AGENTS.md` and `.codex/AGENTS.md` — Codex adapter marker, six rungs, current-schema payload contract, and receipt reconciliation.
- source: `Shared/policies/adapters/codex-subagent-invocation.md` and `Shared/policies/references/workflow-execution-spec-contract.md` — selector, evidence provenance, receipt, and wait-policy ownership.
- source: `Scripts/tests/codex-subagents/Invoke-CodexSubagentV1ContractFixtureTests.ps1` and the selector/receipt/lifecycle fixtures — schema, payload, routing, receipt, and lifecycle contract cases.
- source: `Scripts/Watch-CodexModelV1.ps1` — local experimental disclaimer and guarded cache-write implementation; source confirms only script behavior, not platform capability.

## Read Contract

- Read for Codex adapter governance, V1 dispatch contract, source/deployed parity, or related fixtures.

## Conflicts and Supersession

- superseded: any claim that a requested or accepted route proves the platform applied that model or effort.

## 中文摘要

- Codex 現在有 Luna、Terra、Sol 各自搭配 medium 與 xhigh 的六級路由，並依風險、可逆性、驗證強度與推理深度選擇。
- `agent_type` 只有在本次工具結構真的提供時才可傳送；平台未回傳收據時不得猜測實際套用值。
- 模型與推理強度只影響等待時間，不得改變範圍、角色、審查、驗證或授權。
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
