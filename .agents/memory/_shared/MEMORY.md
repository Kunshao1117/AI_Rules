---
name: _shared
scopePath: Shared/
description: >-
  專案記憶：跨平台共用框架來源與治理規則。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-07-01T09:37:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-01T09:32:41+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 12
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
- Shared owns cross-platform governance sources, operational skills, policy references, project tools, workflow matrices, and source memory contracts.
- Workflow orchestration and scenarios define the route, authorization, operation mode, board state, dispatch wave, handoff, delivery artifact, route-back, and closeout sequence.
- Workflow orchestration now treats source/deployed sync as a formal governance rule: direction, evidence, and parity must be known when framework source files have deployed copies.
- Narrow pre-board read-only probes are allowed only for orientation; broad reads, recursive scans, validation, review, memory/docs attribution, writes, and completion claims require the formal Team-Native sequence.
- Team-Native Core governance lives in `_shared.team-native-core`, which owns team policy, route states, trace evidence, and full completion contracts.
- Shared skill governance supports role metadata, station handoff references, task-board templates, delivery artifacts, and reference splitting for large skills.
- Captain Trigger Gate and Captain Team Board route explicit workflows plus natural-language coding intent into the default team collaboration model.
- Memory MCP tool contract separates read-only evidence, mutating memory gates, Gateway execution, project-local migration tools, and source memory from project context.
- Shared governance references deploy to `.agents/shared/`; restricted project-local tools deploy from `Shared/project-tools/`.
- Shared policies keep vendor-neutral evidence-branch semantics: specialists provide evidence, while the captain owns final review-state and protected action decisions.
- Coding workflow and command entries preserve four formal delivery artifacts and use `closed-with-director-risk` for non-complete risk closure.
- Shared authorization and Team-Native policies bind everyday Director language to the current visible target and require hook-blocked actions to stop as blocked or unverified instead of retrying through alternate tools.
- Shared workflow orchestration treats source/deployed parity as part of closeout evidence and requires state labels to stay separate from execution routes.
## Active Constraints
- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; put card navigation in Relations, and treat cards above 8 tracked files as split candidates.
- Keep Windows PowerShell 5.1-executed project tools UTF-8 BOM encoded when they contain non-ASCII runtime strings.
## Cycle Events
- 37: Updated Shared memory for Team-Native authorization binding, source/deployed parity, and post-hook-block stop behavior across shared policies, workflow orchestration, and deployed governance references.
- 36: Added shared natural-language authorization binding and hook-block stop rules, then synced deployed shared policy copies with hash parity.
- 35: Added source/deployed sync parity to workflow orchestration and trace evidence, refreshed shared subagent policy marker blocks, and kept state labels out of execution-route fields.
- 34: Added hook-guided Captain-Lite read scenario and narrow pre-board read allowance while preserving formal-readonly evidence and protected authorization gates.
- 33: Wave 6C added workflow orchestration scenarios, task-board scenario templates, deployed references, Doctor coverage, and completion/non-completion semantic separation.
- 32: Wave 6B added the shared workflow orchestration policy to Shared governance, deployed references, workflow entries, and Doctor coverage.
- 31: Added Wave 1 skill relation metadata contract for Team-Native role skills; actual specialist skill rewriting remains a later wave.
- 30: Added Team-First handoff packet skill to the shared skill index and updated skill governance for reference splitting plus station handoff references.
- 29: Updated source/deployed skill governance contract for four formal delivery artifacts, memory/docs delivery fields, and non-complete `closed-with-director-risk` semantics.
- 28: Updated Shared skill index for direct-renamed team task board and delivery artifact skills, plus assignment/channel separation semantics.
- 27: Recorded Team-Native specialist registry, change delivery artifact semantics, 61 shared skills, and source/deployed sync.
- 26: Split Team-Native Core policy, trace evidence, route semantics, and team completion ownership into `_shared.team-native-core`.
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
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
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
