---
name: _shared.ops-skills.skill-governance
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 委派策略與技能工廠治理技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-04T22:52:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T21:24:30+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 5
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
# _shared.ops-skills.skill-governance — Skill Governance Memory
## Current Truth
- This card owns operational skill governance files under `Shared/skills/` that are not assigned to `_shared.team-native-core`, plus active deployed root skill copies when those copies are project inputs.
- Team-Native Core files, programming-team governance, team-task-board, delegation-strategy root, and dispatch-gate ownership live in `_shared.team-native-core`; this card keeps delivery-artifact, role-boundary, skill-factory, and delegation CLI reference ownership.
- Delivery artifact and role-boundary skills require current structured station evidence, scoped authorization fields, role/channel evidence, source/deployed sync evidence, and non-complete outcomes when required evidence is missing.
- Change delivery artifacts distinguish station-owned main-worktree `change-delivery` from isolated/text fallback artifacts and fallback `change-application`; main-worktree writes need station ownership, exact file scope, dirty-diff evidence, and no self-review.
- Memory/docs artifacts remain read-only attribution evidence unless a separate protected owner station has scoped memory-write authorization; memory commit, compaction, context cards, and mutating MCP tools need separate protected gates.
- Role-boundary governance requires operation mode, ten registered role IDs, `role_instance_id`, `exclusive_task_scope`, specialist deep-read evidence, captain coordination read scope, and unread-scope reporting.
- Handoff packets are scoped to one substation task, one role, one concrete task, one output format, and one stop condition; vague multi-role delegation is invalid.
- Skill creation and delegation rules must stay compatible with Codex native skill loading and cross-platform governance; framework-source skill forging requires an explicit AI_Rules source root.
- Skill governance routes language choices through shared language governance and external grounding/freshness choices through shared grounding governance.
- Team task-board long catalogs live in reference files; pause/resume, replacement, late-result, channel closeout, and SkillQuality-safe references stay in the governing skills.
## Active Constraints
- Do not duplicate full skill templates in memory or copy platform core language paragraphs as the only language source; use tracked references and shared language governance for skill formatting, delegation, triggers, handoffs, and generated docs.

## Cycle Events
- 38: M4 compacted the active card while preserving delivery-artifact, role-boundary, skill-factory, deployed-copy, and delegation CLI reference ownership.
- 36-37: Recorded skill-governance dual-gate placement, team skill split, role-boundary update, and `change-delivery` primary / `change-application` fallback semantics.
- 33-35: Recorded lifecycle hardening for pause probes, explicit resume, late-result receipt, channel closeout, Director-facing synthesis, and captain receipt boundaries.
- 29-32: Recorded workflow slimming, source/deployed parity, language-policy citation, delivery-artifact authorization fields, and Team-Native cleanup.
- 21-28: Recorded role-boundary, handoff, delivery-adjacent skill, ten-role, station-family, and delegation evidence hardening.
## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source/deployed parity: 2026-07-04 SHA256 checks matched tracked team delivery/role-boundary skills and `skill-factory` against `.agents/skills/` deployed copies.
- source:Shared/skills/team-*-delivery-artifact/SKILL.md and Shared/skills/team-role-boundaries/SKILL.md — Verified artifact schema, role separation, station evidence, no-repair/no-self-review boundaries, and Director-facing synthesis boundary.
- source:Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md — Verified evidence branch prompt language with canonical English internal fields and zh-TW Director-facing output.
- source:Shared/policies/language-governance.md and Shared/policies/grounding-governance.md — Verified language-layer and external-grounding routing.
- tool/director: memory_audit granularity advisory and 2026-06-15 GO SPLIT authorization.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此卡負責未歸入 Team-Native Core 的 delivery artifact、role-boundary、skill-factory、deployed skill copy 與 delegation CLI reference 記憶。
- 交付件與角色邊界技能必須有範圍式授權、角色/通道證據、source/deployed sync 與缺證據時的非完成狀態。
- `team-task-board` 長模板已拆到 references；暫停探針、明確恢復、晚回接收與通道收束仍是技能治理重點。
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
