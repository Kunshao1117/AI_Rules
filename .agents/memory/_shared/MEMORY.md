---
name: _shared
scopePath: Shared/
description: >-
  專案記憶：跨平台共用框架來源與治理規則。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-07-07T10:41:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: partial_evidence
last_verified: '2026-07-07T10:35:30+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 4
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

# _shared — Shared Governance Memory
## Current Truth
- Shared owns cross-platform governance sources, language/grounding policy, memory/context governance, audit references, restricted project tools, and parent navigation for child governance cards.
- `_shared.team-native-core` is the concrete owner for Team-Native policy, workflow orchestration/scenarios, platform plan mapping, workflow evidence references, role boundaries, station evidence, and completion contracts.
- Director wording, workflow names, GO/continue, MCP HITL, UI approvals, memory/context writes, and protected phases remain intent signals until authorization resolution binds target, station, file set, command, phase, expiry, and gate.
- Governed Team-Native work is triggered by current user requests for governance, workflow, source, memory/docs, commit, audit, test, build, fix, debug, handoff, public-contract, or delegation work; no-impact conversation can stay direct.
- Language governance owns Director-facing meaning-first output and exact-evidence expression; 09 commit subject/body/summary must likewise use Traditional Chinese meaning-first main text, while grounding governance owns source freshness and no-evidence claim boundaries.
- Memory governance separates source memory from project context; delivery-bundle `memory_docs_handoff` is read-only disposition/attribution routing and staleness repair still requires source comparison, full active card write, and separately authorized `memory_commit`.
- MCP profiles are opt-in snippets only: framework Fresh, Upgrade, Sync, and Audit must not auto-install external MCP servers or overwrite global MCP settings, and mutating MCP tools still need authorization resolution plus the matching protected gate.
- Skill/source-document placement is centralized: shared skills cite policy/reference homes instead of copying long playbooks, and source-document size/split decisions live in `Shared/policies/source-document-size-governance.md`.
- Shared references deploy to `.agents/shared/`, and restricted project-local tools deploy from `Shared/project-tools/`; source/deployed parity is required before closeout.
- Parent cards use `Relations` for navigation when a more specific child card owns concrete tracked files.
## Active Constraints
- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; put card navigation in Relations, and treat cards above 8 tracked files as split candidates.
- Keep Windows PowerShell 5.1-executed project tools UTF-8 BOM encoded when they contain non-ASCII runtime strings.
- Keep source/deployed shared docs content-identical; workflow, skill, matrix, platform adapter entries, plan mapping, evidence references, and team artifacts must cite shared policies and treat workflow names, casual approvals, `GO`, MCP HITL, memory/context write, and other protected phases as scope-bound until authorization resolution binds target, command, phase, expiry, and matching gate.
## Cycle Events
- 53: Reconciled Shared governance memory with language/grounding, MCP opt-in, memory/context, source-document-size, skill placement, workflow-stage delivery-bundle handoff, and 09 commit wording policy updates.
- 52: M4 compacted the parent card and removed parent tracked ownership for workflow orchestration/scenarios; `_shared.team-native-core` remains the specific owner.
- 49-51: Recorded dual-gate language/grounding governance, memory lifecycle separation, and scoped protected phases for memory/topology/context writes.
- 45-48: Recorded Director-facing output synthesis, authorization hardening, memory-ops compression, and channel lifecycle repair.
- 30-44: Earlier Team-Native, workflow, Doctor, route/state, and completion-semantics events remain summarized by current truth and child cards.
## Archive Index
- archive-003.md keeps older cycle events 14-22; archive-001.md / archive-002.md preserve legacy and pre-standardization active snapshots from schema v2 and MEMORY.md migration.
## Evidence Base
- Source evidence: Previous active memory content is preserved in archive-002.md.
- Source evidence: `language-governance`, `grounding-governance`, `workflow-stage-procedures`, `skill-governance`, `mcp-profiles`, memory-ops, memory-arch, project-context, and audit-engine sources verified on 2026-07-07; current `workflow-stage-procedures` diff adds delivery-bundle memory_docs handoff and 09 commit wording rules.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Shared 是跨平台治理與共用技能來源；Team mode 由使用者要求受治理工作或團隊/委派觸發，細節由子卡維護。
- `GO`、`MCP HITL`、介面核准與日常指令都只是意圖訊號；寫入與 protected phase 必須先綁定目標、檔案、命令、階段、期限與 gate。
- `memory_docs_handoff` 只做唯讀 disposition/attribution，不授權記憶寫入；記憶卡寫入、拓樸調整、`GO CONTEXT`、遷移/reindex 與 `memory_commit` 都是受保護階段。
- 語言治理要求隊長對總監輸出先做繁中意義化摘要，不得原樣貼內部交付件或 raw artifact；09 commit subject/body/summary 也須繁中語義先行。
- 父子記憶卡重疊時，具體檔案應歸最具體子卡；導覽父卡可空 `Tracked Files`，但必須用 `Read Contract` 與 `Relations` 指向子卡。
## Tracked Files
- Shared/workflow-stage-procedures.md
- Shared/policies/language-governance.md
- .agents/shared/policies/language-governance.md
- Shared/policies/grounding-governance.md
- .agents/shared/policies/grounding-governance.md
- Shared/policies/source-document-size-governance.md
- .agents/shared/policies/source-document-size-governance.md
- Shared/skill-governance.md
- Shared/mcp-profiles/README.md
- Shared/context/_map/CONTEXT.md
- Shared/skills/_index.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-arch/references/memory-quality-migration-blueprint.md
- Shared/skills/memory-arch/references/topology-rules.md
- Shared/skills/memory-arch/references/maintenance-playbooks.md
- Shared/skills/memory-ops/references/memory-template.md
- Shared/skills/memory-ops/references/memory-lifecycle-procedures.md
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
- _shared.team-native-core owns Team-Native policy, workflow orchestration/scenarios, platform plan mapping, workflow evidence references, and station/completion governance files.
- _shared.ops-skills owns operational skill governance files under `Shared/skills/` that are not assigned to Team-Native Core.
- _system covers deployment and sync engine memory; _codex_core, _claude_core, and _ag_core cover platform adapters.
