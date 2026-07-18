---
name: _shared.ops-skills.mcp-ops
scopePath: Shared/skills/
description: >-
  專案記憶：Shared MCP 與外部服務操作食譜技能。Use when: task touches this split memory scope or
  its tracked files.
last_updated: '2026-07-18T12:45:26+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-08T13:06:03+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 6
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
- Tracked MCP skill descriptions now start with Traditional Chinese task meaning, with MCP server names and tool identifiers preserved as exact tokens.
- External-service state mutation, writes, deploys, pushes, deletes, resets, resolve actions, and credential-sensitive actions require scope-bound Director intent, authorization resolution, the matching protected gate, current target scope, and credential availability.
- `[MCP HITL GATE]` is an additional execution gate only; it does not replace authorization resolution or authorize another protected phase.
- Tool schema discovery, documentation lookup, and listed tool names are not proof that a downstream MCP call ran and are not permission to mutate.
- Context7 provides latest documentation snapshots for explicitly routed work; it no longer has an `/08_audit` workflow trigger, and project-locked versions plus local source remain the implementation boundary.
- Maps and Context7 are read-oriented evidence paths; Stitch design output is direction material, and real rendered UI remains completion-readiness evidence.
- PR review operations start from an explicit PR request or an accepted build/fix finding, not an audit workflow; [SUDO] cannot approve, merge, skip CI, or bypass security checks.

## Active Constraints
- Do not treat tool discovery as permission to mutate external systems.
- Treat MCP HITL as an additional execution gate only; it does not replace authorization resolution or the matching protected gate.
- Label missing latest/current external evidence honestly; do not claim verified MCP or service behavior from tool discovery alone.
- Do not store unverified external/API/version facts from Context7 in memory; record local source governance facts or accepted external-research artifact status instead.
- Keep provider-specific operational details in the tracked skill files.
- Re-read external design/service state after out-of-band edits before using it as current evidence.

## Cycle Events
- 06: Aligned Context7 and PR-review routing after removal of `/08_audit`; external docs and PR evidence still require their explicit routes and gates.
- 05: Repaired stale MCP ops memory for zh-TW trigger wording, tool-discovery limits, MCP HITL boundaries, and external mutation protected phases.
- 04: Verified Batch 4A quality metadata against tracked MCP operation skill content and source/deployed hash parity.
- 03: Recorded Batch 4A MCP ops hardening so external-service mutation requires scope-bound Director intent, authorization resolution, matching protected gate, and MCP HITL only as an additional execution gate.
- 02: Recorded PR-review operation hardening so [SUDO] cannot approve, merge, skip checks, or authorize external mutation.
- 01: Split MCP and external service operation ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- upstream_artifact:memory-docs-artifact-hp-tgdl-memory-docs-20260708 plus validation va-hp-tgdl-revalidation-20260708-01 and review ra-hp-tgdl-review-delta-20260708-01 — accepted TGDL MCP/context7 grounding facts for this memory update.
- source:Shared/skills/cloudflare-ops/SKILL.md, Shared/skills/excel-ops/SKILL.md, Shared/skills/github-ops/SKILL.md, Shared/skills/pr-review-ops/SKILL.md, Shared/skills/sentry-ops/SKILL.md, Shared/skills/stitch-design/SKILL.md — Verified shared HITL, authorization, protected external mutation, and tool-discovery boundaries.
- source:Shared/skills/context7-docs/SKILL.md — Verified live-doc lookup, required parameters, local version compatibility caveat, and removal of the `/08_audit` trigger.
- source:Shared/skills/maps-assist/SKILL.md — Verified instruction-first Google Maps documentation route and read-only documentation boundary.
- source:Shared/policies/grounding-governance.md — External grounding source ranking remains the governing reference for live service and documentation claims.
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
- MCP HITL 只是額外執行閘門，不替代 scope-bound authorization 或 protected phase。
- Context7 與 PR review 不再由 08 健檢觸發；仍須由明確研究、PR、建構或修復路由取得證據。

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
