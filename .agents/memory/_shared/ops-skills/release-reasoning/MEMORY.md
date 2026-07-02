---
name: _shared.ops-skills.release-reasoning
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 發布治理、結構化推理與技術堆疊協議技能。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-02T14:02:05+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:45:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _shared.ops-skills.release-reasoning — Release and Reasoning Skills Memory

## Current Truth
- This child card owns Shared plugin release governance, structured reasoning, and tech-stack protocol skills.
- Release decisions and technology recommendations require current evidence when the external ecosystem may have changed.
- The card records ownership, not the latest external platform facts.
- Tech-stack protocol now treats [SUDO] as an override/risk-closure request only; `_system` memory, scoped authorization, Team-Native, validation, review, and protected gates remain active.

## Active Constraints
- Do not skip current official-source verification for high-change stack, release, or platform guidance.
- Keep release playbooks and protocol details in the tracked source files.

## Cycle Events
- 02: Recorded tech-stack protocol hardening so [SUDO] cannot bypass `_system` memory or protected-action gates.
- 01: Split release, reasoning, and tech-stack protocol ownership out of the broad Shared operational skills card.

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
- 此子卡負責發布治理、結構化推理與技術堆疊協議。
- 高變動外部事實仍需即時查證。

## Tracked Files
- Shared/skills/plugin-release-governance/references/vsix-release-playbook.md
- Shared/skills/plugin-release-governance/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/tech-stack-protocol/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
