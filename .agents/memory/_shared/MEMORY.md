---
name: _shared
scopePath: Shared/
description: >-
  專案記憶：跨平台共用框架來源與治理規則。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-06-29T19:54:46+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-29T19:50:59+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 9
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

# _shared — Shared Governance Memory

## Current Truth
- Shared skill governance now lists `team-station-handoff-packet` and documents that large skills may split stable subinstructions into references, with station packets passing only the concrete skill refs needed by a specialist.
- Shared skill governance now defines optional `metadata.relations` for role skills: `role_id`, role layer, parent skill, support skills, embedded artifacts, artifact contracts, and trace contracts.
- Team-Native Core governance moved to child card `_shared.team-native-core`, which owns shared team policy, platform route states, team trace evidence, and team completion contracts.
- Shared team governance now uses direct-renamed task-board and delivery-artifact skill names; specialist assignment is mandatory before execution-channel availability is evaluated.
- Captain Trigger Gate and Captain Team Board route explicit workflows plus natural-language coding intent into the default team collaboration model; Shared now owns 61 operational skills.
- Memory MCP tool contract defines project-local migration tools, read-only MCP evidence, mutating memory gates, and Gateway execution rules for workflows.
- Shared governance references deployed to `.agents/shared/` include platform/workflow matrices, skill governance, subagent policy, MCP opt-in snippets, and 61 operational skills.
- `Shared/project-tools/` is the source for restricted project-local tools deployed to downstream `.agents/tools/`; Traditional Chinese PowerShell tools use UTF-8 BOM for Windows PowerShell 5.1.
- Memory governance now uses schema v2 with Current Truth, Active Constraints, Cycle Events, Archive Index, and 中文摘要.
- Project context lives in `.agents/context/`, is not source memory, and uses separate approval.
- Shared subagent policy is vendor-neutral; evidence branches provide review evidence but do not own final review lifecycle status.
- Workflow matrix governs programming team routing, audit depth, visual evidence, intent alignment, review lifecycle, and minimum sufficient complexity.
- Skill governance requires coding workflow/command entries to preserve four formal delivery artifacts; memory/docs delivery artifacts include `memory_impact` and `memory_delivery`, and non-complete risk closure remains `closed-with-director-risk`, not completion.
## Active Constraints
- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; put card navigation in Relations, and treat cards above 8 tracked files as split candidates.
- Keep Windows PowerShell 5.1-executed project tools UTF-8 BOM encoded when they contain non-ASCII runtime strings.
## Cycle Events
- 31: Added Wave 1 skill relation metadata contract for Team-Native role skills; actual specialist skill rewriting remains a later wave.
- 30: Added Team-First handoff packet skill to the shared skill index and updated skill governance for reference splitting plus station handoff references.
- 29: Updated source/deployed skill governance contract for four formal delivery artifacts, memory/docs delivery fields, and non-complete `closed-with-director-risk` semantics.
- 28: Updated Shared skill index for direct-renamed team task board and delivery artifact skills, plus assignment/channel separation semantics.
- 27: Recorded Team-Native specialist registry, change delivery artifact semantics, 61 shared skills, and source/deployed sync.
- 26: Split Team-Native Core policy, trace evidence, route semantics, and team completion ownership into `_shared.team-native-core`.
- 25: Verified final Doctor/Audit green after four-delivery-artifact Doctor checks, compressed captain skills, and deployed skill sync.
- 24: Compressed captain/main delegation skills, updated Doctor four-delivery-artifact checks, and resynced source/deployed policy markers.
- 23: Added formal team specialist routing with implementation change delivery, memory delivery, review, and validation artifacts; refreshed 50/67 skill facts after source/deployed sync.
## Archive Index
- archive-003.md — Older cycle events 14-22 compacted from the active card.
- archive-001.md — Legacy _shared card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- Source evidence: Previous active memory content is preserved in archive-002.md.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Shared 是 61 套共用技能與政策的唯一來源。
- 技能治理總規格已加入角色技能關係 metadata；十角色技能本體尚未在 Wave 1 改寫。
- 編程治理已改為團隊協作優先，證據型站點不能無理由全部退回主線直做。
- 記憶治理使用新版主卡加歸檔模型，專案脈絡與原始碼記憶分層管理。
- 超過 8 個追蹤檔是拆卡建議，不是自動阻擋。
## Tracked Files
- Shared/skill-governance.md
- Shared/mcp-profiles/README.md
- Shared/context/_map/CONTEXT.md
- Shared/skills/_index.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-arch/references/memory-quality-migration-blueprint.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/memory-ops/references/memory-mcp-tool-contract.md
- Shared/skills/project-context-protocol/SKILL.md
- Shared/skills/project-context-protocol/references/context-template.md
- Shared/skills/audit-engine/SKILL.md
- Shared/skills/audit-engine/references/audit-depth-matrix.md
- Shared/skills/audit-engine/references/audit-inventory-contracts.md
- Shared/skills/audit-engine/references/surface-audit-recipes.md
- Shared/skills/audit-engine/references/project-surface-matrix.md
- Shared/skills/audit-engine/references/evidence-packet.md
- Shared/skills/audit-engine/references/report-gates.md
- Shared/project-tools/Memory-Migration.ps1
- Shared/project-tools/modules/Memory-Migration.psm1
- .agents/memory/_shared/archive-001.md
## Relations
- _system (deployment and sync engine memory)
- _codex_core (Codex platform adapter memory)
- _claude_core (Claude platform adapter memory)
- _ag_core (Antigravity platform adapter memory)
- _shared.ops-skills (child card for general operational skills)
- _shared.team-native-core (child card for Team-Native Core governance)
## Applicable Skills
- memory-ops — Use when updating this card.
- memory-arch — Use for Shared child-card splitting.
