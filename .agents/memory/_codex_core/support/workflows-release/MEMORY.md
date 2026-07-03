---
name: _codex_core.support.workflows-release
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 提交、巡檢與技能鍛造工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-03T13:41:18+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T06:11:22+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 24
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: active
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---

# _codex_core.support.workflows-release — Codex Release and Governance Workflow Memory

## Current Truth
- Codex commit, routine, handoff, and skill-forge workflow entries now reference workflow-orchestration before completion or protected closeout work.
- Codex 09 source/deployed workflow entries are verified in parity at SHA256 `A0B502D10796A918845AAEACBAB498F76B2F1662B9200271BCCBD4E096BAC8DC`.
- Codex release-side workflow metadata treats `GO` and workflow names as route or scope-bound intent signals only; source write, changelog/source write, memory mutation, git commit/push, tag/release, deployment, install, and external mutation are separate protected phases requiring authorization resolution and the matching protected gate.
- Codex commit, routine, handoff, and skill-forge workflows now load `team-station-handoff-packet`; commit scans, release readiness evidence, routine inspection, skill-source analysis, review, validation, and memory/docs attribution start as `formal-readonly` until protected captain-owned mutation is separately authorized.
- Codex release-side workflows require formal team evidence for commit, routine, handoff, and skill-forge conclusions; protected memory, version-control, and release mutations remain captain-owned and separately scoped.
- Codex commit and release workflows keep memory/git/release operations captain-owned while requiring formal board fields, delivery artifact separation, and wave-gated evidence before completion claims.
- Codex commit workflow treats specialists as evidence-only for review, validation, and completion delivery artifacts; memory, git, push, and release remain captain-only mutations.
- Codex commit and release workflows now inherit team-task-board references through the shared workflow entry contract while keeping git, memory, and release ownership on the captain path.
- Codex commit, routine, and skill-forge workflows now require task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` before specialist work.
- Codex commit, routine, and skill-forge workflows keep git, memory, and release mutations on the captain while evidence stations use role-bound team branches.
- Codex commit, routine, and skill-forge workflows now load programming-team-governance with applicability/execution-mode station reporting while keeping git, memory, and release mutations on the main thread.
- Codex commit, routine, handoff, and skill-forge workflows now require evidence owner, direct exception, completion condition, and all-direct fake-team guards while keeping git, memory, and release mutations on the main thread.
- Codex commit, routine, and skill-forge workflows now use the MCP Memory Evidence Matrix for preflight, read-only routine, and skill attribution evidence.
- This child card owns Codex commit, routine, and skill-forge workflow skills.
- Commit workflow must verify memory state and git scope before external git state changes.
- Routine workflow stays automation-safe only while read-only.
- Codex commit and routine workflows now check review-state blockers, accepted-risk items, unverified high-risk validation, and review governance coverage before green-lighting release or routine conclusions.

## Active Constraints
- Do not perform source write, changelog/source write, memory mutation, git commit/push, tag/release, deployment, install, or external mutation without explicit protected-phase authorization resolved to the current scope.
- Do not let automation-safe routine inspection perform writes.

## Cycle Events
- 24: Recorded Codex 09 source/deployed parity at SHA256 `A0B502D10796A918845AAEACBAB498F76B2F1662B9200271BCCBD4E096BAC8DC` and the split protected-phase rule for source, changelog, memory, git, release, deploy, install, and external mutation work.
- 23: Recorded Batch 3 release closeout authorization-resolution rule: `GO` is a scope-bound intent signal; usable authorization must bind the visible plan, station, file set, command, phase, expiry, and required protected gate before formal-write or external mutation, and memory-commit, commit, push, tag, release, and deploy remain separate protected phases.
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21: Recorded release-side workflow hardening so commit, routine, handoff, and skill-forge evidence uses formal team routing while protected mutations stay captain-owned.
- 20: Wave 6B added workflow-orchestration grounding to Codex release/closeout workflow entries and synced deployed .agents/skills copies.
- 19: Wave 6A updated Codex build, fix, commit, routine, handoff, and skill-forge workflow entries with Team-Native operation mode, board trigger, role identity, handoff packet, and specialist lifecycle coverage.
- 18: Updated Codex release-side workflows for Team-First formal-readonly evidence routing, handoff packet refs, standby state, and protected formal-write gates.
- 17: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 16: Synced Codex release-side workflows with Team-Native specialist registry and change delivery artifact terminology.
- 15: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 14: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 13: Updated Codex release workflow memory for formal dispatch board fields and protected captain-owned release gates.
- 12: Tightened Codex commit workflow around evidence-only specialists, captain-only git/memory/release actions, and four-delivery-artifact completion.
- 11: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 10: Updated Codex release-side workflow memory for captain minimum execution and text change delivery artifact governance.
- 9: Updated Codex release-side workflows for the new captain dispatch gate.
- 08: Aligned Codex release-side workflows with captain-led evidence stations and mutation ownership.
- 07: Hardened Codex release-side workflow boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 06: Hardened Codex commit, routine, and skill-forge team-station reporting with applicability/execution-mode fields.
- 05: Added review-state preflight and review governance coverage to Codex commit and routine workflows.
- 04: Added MCP memory evidence contract references to Codex commit, routine, and skill-forge workflows.
- 03: Updated Codex release and skill-forge workflow boundaries for downstream project use.
- 02: Aligned release Codex workflow grounding paths to deployed .agents/shared governance references.
- 01: Split Codex release and governance workflow ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_codex_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_codex_core/support/archive-001.md — Previous support-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Codex workflow files.
- Read `_codex_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Codex 提交、巡檢與技能鍛造工作流。
- 提交、巡檢、交接與技能鍛造入口需保留團隊證據站點，但外部狀態仍由主線裁決。
- Codex 09 source/deployed 成對檔案已以 SHA256 `A0B502D10796A918845AAEACBAB498F76B2F1662B9200271BCCBD4E096BAC8DC` 驗證一致。
- `GO` 不等於 blanket authorization；source write、changelog/source write、memory mutation、git commit/push、tag/release、deployment、install 與 external mutation 都是分離 protected phase，必須完成範圍解析與對應 gate 後才可執行。

## Tracked Files
- Codex/.agents/workflow-skills/09-commit-紀錄總結/SKILL.md
- Codex/.agents/workflow-skills/10-routine-巡檢/SKILL.md
- Codex/.agents/workflow-skills/12-skill-forge-技能鍛造/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared.ops-skills.release-reasoning (related release and skill governance memory)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
