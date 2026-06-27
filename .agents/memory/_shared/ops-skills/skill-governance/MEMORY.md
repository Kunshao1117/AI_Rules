---
name: _shared.ops-skills.skill-governance
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 委派策略與技能工廠治理技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-28T01:23:46+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-28T01:23:46+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 7
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
- Programming team governance and delegation strategy now use captain trigger, role dispatch, isolated patch boundary, role exclusivity, and no-self-review rules instead of optional delegation.
- Shared skill forging is framework-source only unless the Director explicitly supplies the AI_Rules source root; downstream projects default to project-derived skills.
- This child card owns Shared delegation strategy and skill-factory governance files.
- Skill creation and delegation rules must stay compatible with Codex native skill loading and cross-platform governance.
- Delegation strategy now checks main-thread, direct, blocked, browser/UI, CLI, and MCP-specific routes before any general read-only evidence branch.
- Programming team governance defines fixed coding stations with separate Applicability and Execution mode fields; a station cannot complete as merely active or applicable.
- Programming team governance now treats evidence-oriented stations as team-first branches and requires concrete direct exceptions when an applicable evidence station stays on the main thread.
- Parent and child card relations are navigation only unless a real staleness dependency is documented.

## Active Constraints
- Do not duplicate full skill templates in memory.
- Use the tracked references as the source of truth for skill formatting and delegation procedures.

## Cycle Events
- 07: Re-verified programming-team-governance after deployment audit compression and kept captain-led governance truth current.
- 06: Upgraded programming-team-governance and delegation-strategy to captain-led routing with isolated patch and strict role separation.
- 05: Added team-first evidence station defaults, direct-exception contracts, and fake-team guards to programming-team-governance and delegation-strategy.
- 04: Hardened programming-team-governance station state model and delegation order so applicability is separate from execution mode and special routes precede general evidence branches.
- 03: Added review-evidence boundary to delegation strategy so evidence branches cannot become final quality approval.
- 02: Clarified downstream project boundaries for delegation policy, memory migration, and Shared skill forging.
- 01: Split skill governance ownership out of the broad Shared operational skills card.

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
- 委派策略已從可選分支改為團隊證據站點優先。
- 技能模板與長規則仍保留在來源參考檔。

## Tracked Files
- Shared/skills/delegation-strategy/references/cli-capability-matrix.md
- Shared/skills/delegation-strategy/references/cli-delegation-sop.md
- Shared/skills/delegation-strategy/references/cli-prompt-skeleton.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/skill-factory/references/skill-quality-checklist.md
- Shared/skills/skill-factory/references/skill-style-guide.md
- Shared/skills/skill-factory/references/skill-template.md
- Shared/skills/skill-factory/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
