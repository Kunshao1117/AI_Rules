---
name: _shared.ops-skills.mcp-ops
scopePath: Shared/skills/
description: >-
  專案記憶：Shared MCP 與外部服務操作食譜技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-06-15T02:53:07+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-06-15T02:44:59+08:00'
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
# _shared.ops-skills.mcp-ops — MCP Operations Skills Memory

## Current Truth
- This child card owns Shared MCP and external-service operation recipe skills.
- Gateway discovery and real downstream execution must stay separated by governance rules.
- Mutating external service calls require the appropriate human gate and current credential availability.

## Active Constraints
- Do not treat tool discovery as permission to mutate external systems.
- Keep provider-specific operational details in the tracked skill files.

## Cycle Events
- 01: Split MCP and external service operation ownership out of the broad Shared operational skills card.

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
- 此子卡負責 MCP 與外部服務操作食譜。
- 工具探索不等於外部狀態變更授權。

## Tracked Files
- Shared/skills/cloudflare-ops/SKILL.md
- Shared/skills/context7-docs/SKILL.md
- Shared/skills/excel-ops/SKILL.md
- Shared/skills/github-ops/SKILL.md
- Shared/skills/maps-assist/SKILL.md
- Shared/skills/pr-review-ops/SKILL.md
- Shared/skills/sentry-ops/SKILL.md
- Shared/skills/stitch-design/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
