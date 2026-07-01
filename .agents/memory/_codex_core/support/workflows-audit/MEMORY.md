---
name: _codex_core.support.workflows-audit
scopePath: Codex/.agents/workflow-skills/
description: >-
  專案記憶：Codex 健檢主工作流與三階段子工作流技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-01T18:26:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-01T18:20:23+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 21
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
# _codex_core.support.workflows-audit — Codex Audit Workflow Memory

## Current Truth
- Codex audit workflow entries and subflows now reference workflow-orchestration as the shared board/wave/artifact sequence contract.
- Codex audit workflows now load `team-station-handoff-packet` and treat audit evidence, inventories, broad reads, validation planning, and review evidence as `formal-readonly` stations unless a separate GO-backed `formal-write` repair route exists.
- Codex audit workflows now require formal team routing before broad evidence, coverage, validation planning, review evidence, or completion claims; missing evidence cannot be reported as green.
- Codex audit workflows now inherit Programming Team Board entry requirements and are covered by Audit.psm1 checks for formal dispatch and wave-gated evidence semantics.
- Codex audit workflows now inherit team-task-board references through the shared workflow entry contract and keep review/validation delivery artifacts role-bound.
- Codex audit workflows now load captain governance with task type, dispatch pre-gate, Captain Minimum Execution Gate, text change delivery, and `closed-with-director-risk` requirements.
- Codex audit workflows load captain-led governance with role boundary, isolated change delivery semantics, and no-self-review rules for audit evidence stations.
- Codex audit entry and subflows now load programming-team-governance and report applicability/execution-mode team-station board status for coding-related audit work.
- Codex audit entry and subflows now require evidence owner, direct exception, completion condition, and all-direct fake-team guard reporting for team-station boards.
- Codex audit entry and subflows inherit the MCP memory evidence contract and keep audit memory checks read-only.
- This child card owns Codex audit workflow skills and three audit subphase skills.
- Audit workflows use project-surface detection, platform capability snapshots, evidence status, and report routing.
- Audit workflows now support quick, standard, deep, and forensic depth modes with feature, endpoint, command, job, interface, data-flow, performance, and risk inventories.
- Codex subagents remain evidence branches only when explicitly enabled by Director or workflow gate.
- Codex audit workflow now inventories change intent, patch-stack risk, visual detail evidence, and real-information priority when applicable.
- Codex audit entry and report subflows now carry review_state, review lifecycle mapping, and accepted-risk reporting through quality-review-governance.

## Active Constraints
- Do not mark missing evidence as green or complete.
- Do not let audit subflows write source files or memory unless the governing workflow is in an approved write phase.
- Do not claim full coverage from sampled evidence; Phase 3 must report coverage denominators and sampling limits.

## Cycle Events
- 21: Recorded audit workflow hardening so read-only evidence, broad reads, validation planning, and review evidence require formal team routing before coverage or completion claims.
- 20: Wave 6B added workflow-orchestration grounding to Codex audit workflow entries and synced deployed .agents/skills copies.
- 19: Wave 6A updated Codex audit workflow entries with Team-Native mode, role split, board trigger, handoff packet, and specialist lifecycle rules.
- 18: Updated Codex audit workflows for Team-First formal-readonly evidence routing, handoff packet refs, standby state, and deep-read/verify-read fields.
- 17: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 16: Synced Codex audit workflows with Team-Native specialist registry and change delivery artifact terminology.
- 15: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 14: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
- 13: Verified Codex audit workflow entry coverage under the new formal dispatch and wave-gated evidence checks.
- 12: Added team-task-board template governance, refreshed 50/67 skill-count facts, and verified Doctor/Audit green.
- 11: Updated Codex audit workflow memory for captain minimum execution and text change delivery artifact governance.
- 10: Updated Codex audit workflows for the new captain dispatch gate.
- 09: Aligned Codex audit workflows with captain-led team board fields and role-exclusivity guards.
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
- 健檢入口需呈現團隊證據負責與全主線例外，不能只標示直做或委派。
- 缺證據不能當通過；子代理只作明確允許的證據分支。

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
