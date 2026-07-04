---
name: _codex_core.support.workflows-audit
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 健檢主工作流與三階段子工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-04T22:51:34+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T22:29:18+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 22
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

# _codex_core.support.workflows-audit — Codex Audit Workflow Memory

## Current Truth
- Audit entries and subflows reference workflow-orchestration as the shared board/wave/artifact contract.
- Audit workflow names, skill triggers, workflow buttons, approval prompts, and `GO` are route or scope-bound intent signals only and do not grant write, memory, git, release, deployment, install, credential, or external-state authority.
- Audit evidence, inventories, broad reads, validation planning, and review evidence load `team-station-handoff-packet` and run as `formal-readonly` unless a separately authorized `formal-write` repair route resolves scope.
- Formal team routing is required before broad evidence, coverage, validation planning, review evidence, or completion claims; missing evidence cannot be reported as green.
- Team-Native trace records operation mode, board state, station set, dispatch wave, handoff packet, station mode, context visibility, handoff ownership, channel state, artifact states, and authorization resolution for writes or protected phases.
- Audit workflows inherit programming-team-governance and team-task-board requirements; Audit.psm1 checks formal dispatch and wave-gated evidence semantics.
- Review and validation delivery artifacts stay role-bound; audit stations follow task type, dispatch pre-gate, station-owned/text change delivery, Director authorization path, `closed-with-director-risk`, isolated delivery, and no-self-review rules.
- Audit entries and subflows report applicability/execution-mode, evidence owner, direct exception, completion condition, and all-direct fake-team guard fields.
- Audit memory checks use the MCP memory evidence contract read-only; audit repair, memory-card write, and `memory_commit` remain separate protected phases.
- This child card owns Codex audit workflow skills and three audit subphase skills covering project-surface detection, platform capability snapshots, quick/standard/deep/forensic inventories, evidence status, report routing, subagent evidence branches, change intent, patch-stack, visual detail, real-information priority, `review_state`, and accepted-risk reporting.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not let audit subflows write source files or memory unless the governing workflow is in an approved write phase.
- Do not claim full coverage from sampled evidence; Phase 3 must report coverage denominators and sampling limits.
- Review and validation findings are evidence outputs, not repair authority; failed audit evidence routes to a separate formal-write or protected owner station.

## Cycle Events
- 22: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 21: Recorded audit workflow hardening so read-only evidence, broad reads, validation planning, and review evidence require formal team routing before coverage or completion claims.
- 20: Wave 6B added workflow-orchestration grounding to Codex audit workflow entries and synced deployed .agents/skills copies.
- 19: Wave 6A updated Codex audit workflow entries with Team-Native mode, role split, board trigger, handoff packet, and specialist lifecycle rules.
- 18: Updated Codex audit workflows for Team-First formal-readonly evidence routing, handoff packet refs, standby state, and deep-read/verify-read fields.
- 17: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 16: Synced Codex audit workflows with Team-Native specialist registry and change delivery artifact terminology.
- 15: Compressed Team-Native delegation skill wording, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 14: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 13: Verified Codex audit workflow entry coverage under the new formal dispatch and wave-gated evidence checks.
- 12: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 11: Updated Codex audit workflow memory for station-owned execution gates and text change delivery artifact governance.
- 10: Updated Codex audit workflows for the Team-Native dispatch gate.
- 09: Aligned Codex audit workflows with Team-Native board fields and role-exclusivity guards.
- 08: Hardened Codex audit boards with evidence-owner, direct-exception, completion-condition, and all-direct guard fields.
- 07: Hardened Codex audit team-station reporting with applicability/execution-mode fields and synced deployed skill copies.
- 06: Added review lifecycle mapping and review_state output to Codex audit entry and subflows.
- 05: Added change intent, patch-stack, visual detail, and real-information evidence fields to the Codex audit entry.
- 04: Added MCP memory evidence contract references to Codex audit entry and subflows.
- 03: Updated Codex audit workflow output examples to label framework source paths and use deployed shared references.
- 01: Split Codex audit workflow ownership out of the support parent card.
- 02: Updated Codex audit entry and three subphases for depth selection, inventory construction, evidence-linked coverage, and coverage reporting.

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
- 此子卡負責 Codex 健檢主工作流與三階段子工作流。
- 健檢入口需呈現具名 owner station、review/validation station 與 Director authorization path，不能只標示直做或委派。
- 缺證據不能當通過；子代理只作明確允許的證據分支。
- 記憶寫入與 `memory_commit` 是分離 protected phase。

## Tracked Files
- Codex/.agents/workflow-skills/08-1-infra-基礎盤點/SKILL.md
- Codex/.agents/workflow-skills/08-2-logic-深度邏輯/SKILL.md
- Codex/.agents/workflow-skills/08-3-report-健檢總結/SKILL.md
- Codex/.agents/workflow-skills/08-audit-健檢/SKILL.md

## Relations
- _codex_core.support (parent card: Codex support index)
- _shared (shared audit semantics)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Codex support topology.
- impact-test-strategy — Use when workflow edits affect multiple entrypoints.
