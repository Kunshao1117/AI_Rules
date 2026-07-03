---
name: _shared
scopePath: Shared/
description: >-
  專案記憶：跨平台共用框架來源與治理規則。Use when: task touches this card tracked files or governed
  scope.
last_updated: '2026-07-03T21:00:41+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T20:57:12+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 8
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
- Shared owns cross-platform governance sources, operational skills, policy references, workflow matrices, restricted project tools, and source memory contracts; child cards hold narrower team-native and operational-skill details.
- Workflow orchestration, scenarios, and authorization policy keep route, board state, operation mode, dispatch wave, handoff, delivery artifact, route-back, closeout, and source/deployed parity explicit.
- Director wording, workflow names, GO/continue, MCP HITL, UI approvals, memory/context writes, and protected phases are intent signals until authorization resolution binds target, station, file set, command, phase, expiry, and gate.
- Team-Native work is triggered by current user requests for governed work or team/delegation dispatch; pure conversation, small stable Q&A, and no-impact work can stay ordinary/direct.
- Team-Native Core owns team policy, route states, trace evidence, role boundaries, channel state, station-owned `change-delivery`, fallback `change-application`, non-complete states, and completion contracts in `_shared.team-native-core`.
- Language governance owns Director-facing meaning-first output and exact-evidence expression; grounding governance owns external source type, freshness sensitivity, official/primary-source precedence, local-version conflicts, and no-evidence claim boundaries.
- Memory governance separates source memory from project context; staleness repair requires source comparison, full active card write, and separately authorized `memory_commit`, while context writes, migration/reindex, and topology changes use their own protected phases.
- Parent/child memory ownership follows the most specific `scopePath`; navigation-only parent/index cards may keep `## Tracked Files` empty only when `Read Contract` and `Relations` identify child owners.
- Shared references deploy to `.agents/shared/` and restricted project-local tools deploy from `Shared/project-tools/`; source/deployed parity is required before closeout.
- Coding workflow and command entries preserve four formal delivery artifacts and use blocked, unverified, or `closed-with-director-risk` when required evidence is missing.
## Active Constraints
- Do not put platform-specific tool calls in Shared skill bodies unless the section is explicitly an adapter note.
- Do not list directories under Tracked Files; put card navigation in Relations, and treat cards above 8 tracked files as split candidates.
- Keep Windows PowerShell 5.1-executed project tools UTF-8 BOM encoded when they contain non-ASCII runtime strings.
- Keep source/deployed shared docs content-identical; workflow, skill, matrix, platform adapter entries, and team artifacts must cite shared policies, synthesize Director-facing output, and treat workflow names, casual approvals, `GO`, MCP HITL, memory/context write, and other protected phases as scope-bound until authorization resolution binds target, command, phase, expiry, and matching gate.
## Cycle Events
- 51: Recorded the dual-gate governance split: Director output is governed by language-governance, while external grounding and freshness-sensitive facts are governed by grounding-governance with source/deployed parity.
- 50: Recorded shared memory-ops lifecycle split and governed Team mode activation semantics: stale repair reads changed source before rewriting cards, and Team mode is user-requested rather than AI-default.
- 49: Recorded memory-governance authorization hardening across memory-ops, memory-arch, template, and language policy; memory/topology/context writes, static-card commits, and navigation-only ownership now require scoped protected phases.
- 48: Recorded workflow orchestration channel lifecycle repair: pause-and-report probes, explicit captain resume, late-result receipt policy, and non-complete state while resume/cancellation/late-result decisions are pending.
- 47: Recorded memory-ops skill compression with source/deployed parity; wording preserves read/write separation, two-step memory update, protected memory_commit, timestamp format, exact Tracked Files heading, and migration safety.
- 46: Recorded Batch 4A authorization-resolution hardening across Shared governance, memory/context contracts, MCP profiles, and source/deployed pairs; GO and MCP HITL are not blanket authority, and protected phases require bound scope, target, command, phase, expiry, and matching gate.
- 45: Recorded language-governance output gate so captain reports synthesize internal team artifacts into Traditional Chinese meaning-first Director-facing summaries instead of pasting raw artifacts.
- 30-33: Added Team-First handoff packet skill, role-skill relation metadata, workflow orchestration policy/scenarios, deployed references, Doctor coverage, and completion/non-completion semantic separation.
## Archive Index
- archive-003.md keeps older cycle events 14-22; archive-001.md / archive-002.md preserve legacy and pre-standardization active snapshots from schema v2 and MEMORY.md migration.
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
- Shared 是跨平台治理與共用技能來源；Team mode 由使用者要求受治理工作或團隊/委派觸發，細節由子卡維護。
- `GO`、`MCP HITL`、介面核准與日常指令都只是意圖訊號；寫入與 protected phase 必須先綁定目標、檔案、命令、階段、期限與 gate。
- 記憶卡寫入、拓樸調整、`GO CONTEXT`、遷移/reindex 與 `memory_commit` 都是受保護階段；唯讀探索不授權突變。
- 語言治理要求隊長對總監輸出先做繁中意義化摘要，不得原樣貼內部交付件或 raw artifact。
- 父子記憶卡重疊時，具體檔案應歸最具體子卡；導覽父卡可空 `Tracked Files`，但必須用 `Read Contract` 與 `Relations` 指向子卡。
## Tracked Files
- Shared/policies/workflow-orchestration.md
- Shared/workflow-stage-procedures.md
- Shared/policies/language-governance.md
- .agents/shared/policies/language-governance.md
- Shared/policies/grounding-governance.md
- .agents/shared/policies/grounding-governance.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/skill-governance.md
- Shared/mcp-profiles/README.md
- Shared/context/_map/CONTEXT.md
- Shared/skills/_index.md
- Shared/skills/memory-ops/SKILL.md
- Shared/skills/memory-arch/SKILL.md
- Shared/skills/memory-arch/references/memory-quality-migration-blueprint.md
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
- _system (deployment and sync engine memory); _codex_core / _claude_core / _ag_core (platform adapter memory); _shared.ops-skills and _shared.team-native-core (child governance cards)
