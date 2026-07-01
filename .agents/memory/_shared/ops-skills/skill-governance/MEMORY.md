---
name: _shared.ops-skills.skill-governance
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 委派策略與技能工廠治理技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-01T22:33:09+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-01T22:31:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 14
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _shared.ops-skills.skill-governance — Skill Governance Memory

## Current Truth
- Team board, handoff, role-boundary, completion, specialist change-delivery, and change-artifact skills now use route/state separation and source/deployed sync fields instead of treating blocked states as execution modes.
- Delivery artifact skills now require current structured station evidence; transcript text, previous assistant claims, and model-filled trust records cannot substitute for role, channel, authorization, or source/deployed evidence.
- Role-boundary and delivery artifact skills now carry Team-First read-scope separation: specialist deep-read evidence, captain verify-read state, unread scope, and non-complete outcomes for missing route evidence.
- Role-boundary governance now requires operation mode, ten registered role IDs, `role_instance_id`, and `exclusive_task_scope` evidence before accepting specialist artifacts.
- Team-Native Core files moved to `_shared.team-native-core`; this card now keeps skill-factory governance plus remaining delegation reference ownership.
- Shared skill forging is framework-source only unless the Director explicitly supplies the AI_Rules source root; downstream projects default to project-derived skills.
- The compatibility-named implementation delivery skill now uses change delivery artifact semantics; the old primary delivery wording is no longer the governing model.
- Delivery artifact boundary skills now require scoped authorization fields before change, memory/docs, validation, review, or role-boundary acceptance can support completion.
- Change, memory/docs, review, validation, and role-boundary artifacts now require scoped authorization and current station evidence; blocked artifacts cannot mutate memory or substitute for completion.
- Delegation strategy, programming-team governance, and team-task-board are now tracked by `_shared.team-native-core` and were verified below the shared-skill quality token gate in this refactor.
- Skill creation and delegation rules must stay compatible with Codex native skill loading and cross-platform governance.
- This child card tracks source skill files and their deployed root skill copies when those deployed copies are active project inputs.
- Team task-board, handoff packet, role-boundary, and specialist registry templates now model station families, formal stations, substation tasks, specialist assignments, execution channels, and delivery artifacts as separate objects.
- Handoff packets are scoped to one substation task, one role, one concrete task, one output format, and one stop condition; vague multi-role delegation is invalid.
- Role-boundary and registry templates now make captain deep-read substitution, captain repair of specialist work, self-review, self-validation, and memory-attribution replacement non-complete outcomes.
- Skill governance and skill factory rules now route instruction, interface, bridge, trigger, handoff, memory, and generated-document language choices through the shared language governance policy.

## Active Constraints
- Do not duplicate full skill templates in memory; use tracked references as the source of truth for skill formatting and delegation procedures.
- Do not copy platform core language paragraphs as the only language source for skill creation, skill updates, trigger text, handoffs, or generated documentation.

## Cycle Events
- 32: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 31: Added skill-governance memory for shared language-policy citation across skill factory and deployed skill language decisions.
- 30: Recorded delivery-artifact hardening so change, memory/docs, review, validation, and role-boundary artifacts require scoped authorization and cannot mutate memory or substitute for completion when blocked.
- 29: Recorded final Team-Native cleanup for remaining Doctor red-light fixes, cross-platform skill sync, and commit-preflight stale blocker cleanup.
- 28: Updated team skill templates for station-family topology, one-substation-task handoff packets, multi-specialist defaults, and hard captain non-authoring boundaries.
- 27: Updated skill-governance memory after Team-Native skill hardening: delivery artifact skills separate route from state, require current station evidence, and record source/deployed sync instead of allowing blocked states or transcript text to stand in for authority.
- 26: Updated team board, handoff, role-boundary, completion, specialist change-delivery, and change-artifact skills for execution-route fields, station/evidence states, captain deep-read limits, and source/deployed sync evidence.
- 25: Expanded role-boundary governance from legacy role groups to the ten registered role IDs and added security/reliability handoff support.
- 24: Added Wave 1 role-boundary checkpoint for operation mode, role identity, task-scope exclusivity, and same-task role-instance separation.
- 23: Updated role-boundary and delivery-adjacent skill governance for Team-First handoff packets, deep-read/verify-read separation, and no silent captain substitution.
- 22: Added scoped authorization fields to change, memory/docs, validation, review, and role-boundary delivery artifact contracts; synced deployed skill copies.
- 21: Reconfirmed commit-preflight ownership after Team-Native closeout; no source ownership change required.
- 20: Recorded that the three compressed team-governance skills moved under `_shared.team-native-core` ownership and passed the quality token gate.
- 19: Retired stale deployed hared path references and recorded change delivery artifact semantics for implementation delivery.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責委派策略與技能工廠治理。
- 交付件邊界技能現在要求範圍式授權欄位，缺欄位不能支撐完成。
- 角色邊界現在也要檢查 daily/full 模式、角色編號、角色實例與任務內互斥範圍。
- 委派策略已從可選分支改為團隊證據站點優先。

## Tracked Files
- Shared/skills/team-review-delivery-artifact/SKILL.md
- Shared/skills/team-validation-delivery-artifact/SKILL.md
- Shared/skills/team-memory-docs-delivery-artifact/SKILL.md
- Shared/skills/team-change-delivery-artifact/SKILL.md
- Shared/skills/team-role-boundaries/SKILL.md
- .agents/skills/team-review-delivery-artifact/SKILL.md
- .agents/skills/team-validation-delivery-artifact/SKILL.md
- .agents/skills/team-memory-docs-delivery-artifact/SKILL.md
- .agents/skills/team-change-delivery-artifact/SKILL.md
- .agents/skills/team-role-boundaries/SKILL.md
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/skill-factory/SKILL.md
- .agents/skills/skill-factory/SKILL.md

## Relations
- _shared.ops-skills (parent card), _shared (Shared governance parent), and _shared.team-native-core (Team-Native Core governance and station files)

## Applicable Skills
- memory-ops for updates; memory-arch for child-card topology changes.
