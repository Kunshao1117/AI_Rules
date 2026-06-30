---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-06-30T13:07:11+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-06-30T00:58:07+08:00'
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

# _codex_core — Codex Edition Memory

## Current Truth
- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework, using `.codex/AGENTS.md` for project governance and `.agents/skills/` for live skills.
- Codex source workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`.
- Codex source and deployed rules put Team-Native Core and Authorization Resolution before lifecycle, workflow names, GO text, sandbox prompts, and tool approvals.
- Team-Native Codex work requires captain-led boards, role-exclusive stations, handoff packets, channel state, protected captain integration, and separated change, memory/docs, review, and validation artifacts before full completion.
- Evidence-bearing chat, broad reads, validation, review, memory/docs attribution, commit/release preparation, and completion audit route through formal-readonly or formal-write; pure chat and tiny orientation stay direct only while non-mutating.
- Codex project-level hooks provide Team-Native guardrails for micro-read allowance, broad-read Captain-Lite hints, scoped write target matching, protected mutation authorization, and completion-claim artifact checks.
- Hooks Stability guards separate current payload evidence from historical transcript text, require same-record protected authorization, require every detected protected action to have complete authorization, avoid release/deploy false positives from filenames, enforce exact normalized write-target matching, and gate completion claims on delivery artifacts or explicit non-complete state.
- Codex documentation and core rules use `closed-with-director-risk` for Director-closed non-complete cases and must not present missing specialist delivery as full team completion.
- Codex workflow entries load shared workflow orchestration, platform matrices, specialist role skills, team task-board templates, change delivery artifacts, and MCP memory evidence contracts before relying on evidence.
- Director-facing Codex output must stay Traditional Chinese and follow the Director-readable output contract.
- The captain owns main-worktree writes, gates, memory, git, release, and final acceptance; specialists and hooks provide evidence or guardrails, not final authority.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- This card still needs a later child-card split if all workflow skills become actively edited again.
## Cycle Events
- 36: Hooks Stability Implementation accepted with source/deployed hook and config hash parity, 41 fixture cases, Doctor Red 0 / Yellow 0, same-record protected authorization, per-action protected authorization coverage, exact write target matching, and a nonblocking deploy.patch dedicated-fixture gap.
- 35: Added Codex project-level hook source and Team-Native gate behavior for Captain-Lite reads, scoped writes, protected mutations, and completion artifact checks.
- 34: Wave 6B added workflow-orchestration grounding to Codex workflow entries and source/deployed drift checks.
- 33: Wave 6A updated all 17 Codex workflow entries with operation_mode, daily/full modes, direct/formal-readonly/formal-write boundaries, board triggers, and specialist lifecycle semantics; deployed workflow skill hashes were verified in sync.
- 32: Synced Codex core source and live rules with the core-injection Team-Native hard gate before broad reading, validation, review, memory/docs attribution, completion audit, or completion claims.
- 31: Updated Codex README to state that 00 evidence-bearing chat enters Team-Native formal-readonly, while pure chat remains direct; this aligns Codex docs with the rebuilt 00 workflow boundary.
- 30: Synchronized Codex source/deployed core rules and README for Team-Native lifecycle, scoped authorization before Lifecycle, route-only workflow semantics, fast closeout wording, Team-First formal-readonly, handoff packets, standby or unavailable-channel reporting, and deep-read/verify-read boundaries; Doctor returned red 0 / yellow 0.
- 29: Synced Codex source/deployed Team-Native wording to `closed-with-director-risk`, keeping protected integration distinct from captain substitute authoring.
- 28: Removed residual captain-substitution wording from Codex README and deployed workflow skill copies.
- 27: Synced Codex source/deployed policy marker blocks with `closed-with-director-risk` wording.
- 26: Synced Codex source and deployed workflow skills with Team-Native specialist registry and change delivery artifact terminology.
- 25: Synced Codex source and deployed core rules with Team-Native Core route-state policy.
## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
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
- Codex 是 OpenAI Codex 平台適配層。
- Codex 的 GO、工具提示與技能名稱現在只會變成有範圍的授權證據，不是無範圍寫入。
- 工作流來源在 Codex 目錄，live 技能在 `.agents/skills/`。
- Codex 編程工作流已改為團隊協作優先，主線保留寫檔與裁決責任。
- Codex 00 證據型對話也會進 formal-readonly；純聊天才維持直接回覆。
- 記憶讀取已對齊新版欄位。
- 根層 README 不再由本卡追蹤。
## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.json
- Codex/.codex/hooks/team-native-gate.ps1
- .codex/hooks.json
- .codex/hooks/team-native-gate.ps1
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md
## Relations
- _system (root governance and deployment memory)
- _shared (Shared operational skills)
- _map (memory navigation index)
- _codex_core.support (child card for support workflow skills)
