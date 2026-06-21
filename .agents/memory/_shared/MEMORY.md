---
name: _shared
scopePath: Shared/
description: >-
  專案記憶：跨平台共用框架來源與治理規則。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-06-21T11:28:19+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-21T11:28:19+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 13
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
- Memory MCP tool contract defines project-local migration tools, read-only MCP evidence, mutating memory gates, and Gateway execution rules for workflows.
- Shared governance references deployed to `.agents/shared/` include platform/workflow matrices, skill governance, subagent policy, and MCP opt-in snippets.
- `Shared/project-tools/` is the source for restricted project-local tools deployed to downstream `.agents/tools/`; Traditional Chinese PowerShell tools use UTF-8 BOM for Windows PowerShell 5.1.
- Memory migration guidance requires downstream agents to use the project-local tool before falling back to the framework source manager or extension.
- `Shared/` is the single source for 42 operational skills and cross-platform governance assets deployed into Antigravity, Claude, and Codex.
- Memory governance now uses schema v2 with Current Truth, Active Constraints, Cycle Events, Archive Index, and 中文摘要.
- Memory cards must avoid unbounded repair logs; split warnings are advisory unless hard limits, mixed ownership, or maintenance difficulty require a split.
- Project context lives in `.agents/context/`, is not source memory, and uses separate approval.
- Shared subagent policy is vendor-neutral; platform-specific tool wording belongs in platform adapters.
- Audit engine now defines depth modes, inventory denominators, surface recipes, coverage states, and evidence gates for deep 08 audits.
- Workflow matrix now defines change intent classification and visual evidence governance for patch, repair, refinement, refactor, detail observation, and real-information priority.
- Workflow matrix now defines intent alignment governance for requirement playback, neutral challenge, decision trace, requirement trace, and drift audit in 02/03 workflows.
- Workflow matrix now defines review lifecycle governance for review purpose, review state, accepted risk, blockers, evidence branches, and minimum sufficient complexity.
- Shared subagent policy states that evidence branches provide review evidence but do not own final review lifecycle status.
- Memory operations guidance stays below the Shared skill quality size limit with safety margin while preserving memory commit, migration, and heading-accuracy governance.
## Active Constraints
- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; the memory audit tool expects readable files.
- Parent or child card navigation belongs in Relations, not frontmatter dependencies.
- Treat cards above 8 tracked files as split candidates, not automatic blockers.
- Keep Windows PowerShell 5.1-executed project tools UTF-8 BOM encoded when they contain non-ASCII runtime strings.
## Cycle Events
- 13: Compressed memory-ops with extra token margin after managed cache CRLF checkout exposed line-ending-sensitive estimates.
- 12: Added engineering review governance to the workflow matrix, skill routing index, and shared subagent review-state boundary; shared skill count is 42.
- 11: Added intent alignment governance to the shared workflow matrix and skill routing index.
- 10: Compressed memory-ops wording under the Shared skill quality token limit without changing memory governance semantics.
- 09: Added change intent and visual evidence governance to the shared workflow matrix and skill routing index.
- 08: Added MCP memory tool contract and workflow-matrix evidence requirements for 03/04/05/08/09/10/11/12.
- 07: Preserved Traditional Chinese memory migration tool output by storing project-local PowerShell tools with UTF-8 BOM for Windows PowerShell 5.1 compatibility.
- 06: Added Shared project-local memory migration tool source and downstream-first migration guidance.
- 05: Expanded shared governance deployment to include skill-governance, subagent policy, and MCP opt-in references.
- 04: Declared shared matrices as source-authored assets deployed to .agents/shared for target projects.
- 01: Migrated active main file to MEMORY.md and added content-quality metadata.
- 02: Moved testing strategy ownership from the Shared parent card to the focused testing child card.
- 03: Added deep evidence audit semantics: depth matrix, inventory contracts, surface recipes, coverage gates, and platform translation notes.
## Archive Index
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
- Shared 是 42 套共用技能與政策的唯一來源。
- 記憶治理已改成新版主卡加歸檔模型。
- 專案脈絡與原始碼記憶分層管理。
- 超過 8 個追蹤檔是拆卡建議，不是自動阻擋。
## Tracked Files
- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md
- Shared/skill-governance.md
- Shared/policies/subagent-invocation.md
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
## Applicable Skills
- memory-ops — Use when updating this card.
- memory-arch — Use for Shared child-card splitting.
