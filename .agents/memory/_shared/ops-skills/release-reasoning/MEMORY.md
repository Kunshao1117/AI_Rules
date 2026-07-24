---
name: _shared.ops-skills.release-reasoning
scopePath: Shared/skills/
description: >
  專案記憶：Shared 發布治理、結構化推理與技術堆疊協議技能。Use when: task touches this split memory scope
  or its tracked files.
last_updated: '2026-07-24T16:19:46+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:42:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-07-24-001
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

# _shared.ops-skills.release-reasoning — Release and Reasoning Memory

## Current Truth

- This card owns Shared plugin-release governance, structured reasoning, and technology-stack protocol skills.
- coding-reflection-gate and design-reflection-gate are read-only route gates; neither grants write or protected-action authority.
- Plugin release, dependency/config, install, MCP-config, system-memory, and memory-commit changes remain separately scoped protected phases.
- Structured reasoning is reserved for complex, multi-option work and must invoke its real MCP tool when selected.

## Active Constraints

- Verify high-change stack, release, and platform guidance from current primary sources before treating it as current.
- A GO, SUDO, preflight override, or fix ID never combines protected phases; any override is single-use and exact-file scoped.
- Keep procedural release and technology detail in the tracked source skills.

## Cycle Events

- 01: Compacted prior release/reasoning history after re-verifying current source ownership and protected-phase boundaries.

## Archive Index

- archive-001.md — Compacted pre-2026-07-24 cycle events and split-era detail.

## Evidence Base

- source:Shared/skills/coding-reflection-gate/SKILL.md
- source:Shared/skills/design-reflection-gate/SKILL.md
- source:Shared/skills/plugin-release-governance/SKILL.md
- source:Shared/skills/structured-reasoning/SKILL.md
- source:Shared/skills/tech-stack-protocol/SKILL.md

## Read Contract

- Read for release-governance, structured-reasoning, or technology-stack protocol work in the tracked scope.
- Do not use for transient release output, raw preflight logs, or unverified external version claims.

## Conflicts and Supersession

- None.

## 中文摘要

- 此卡負責 Shared 發布治理、結構化推理與技術堆疊協議。
- 發布與系統變更均為逐 phase 的受保護操作。
- 高變動外部事實必須重新查證。

## Tracked Files

- Shared/skills/coding-reflection-gate/SKILL.md
- Shared/skills/design-reflection-gate/SKILL.md
- Shared/skills/plugin-release-governance/references/vsix-release-playbook.md
- Shared/skills/plugin-release-governance/SKILL.md
- Shared/skills/structured-reasoning/SKILL.md
- Shared/skills/tech-stack-protocol/SKILL.md

## Relations

- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills

- memory-ops — Update and commit this child card.
- memory-arch — Adjust card topology or archives.
