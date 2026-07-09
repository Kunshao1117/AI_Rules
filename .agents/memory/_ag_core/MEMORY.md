---
name: _ag_core
scopePath: Antigravity/
description: >-
  專案記憶：Antigravity 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-09T16:59:40+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-09T16:56:58+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-30-001
cycle_event_count: 10
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
# _ag_core — Antigravity Memory

## Current Truth
- Antigravity is the Gemini-facing adapter for AI_Rules and uses `.agents/rules/`, `.agents/workflows/`, and `.agents/skills/`.
- Current Antigravity rule source requires Director-facing output to start from Traditional Chinese plain meaning; exact technical identifiers are supporting evidence only.
- Governed Antigravity requests activate Team mode; workflow names, source impact, platform tools, permission prompts, and prior state do not activate Team mode without a current governed user request.
- In active Team mode, the mainline is the Director-facing captain and is limited to coordination, dispatch, board maintenance, delivery receipt, status synthesis, blocker routing, authorization routing, and reporting.
- Authorization Resolution scope-binding precedes lifecycle; workflow buttons, IDE confirmations, GO, and tool confirmations are scoped evidence only for the current visible plan, station, command, file set, diff, phase, or blocker.
- Broad reads, validation, review, memory/docs attribution, source writes, completion audits, and completion claims require board, station, role, channel, `station_mode`, `context_visibility`, and `handoff_ownership` evidence.
- Main-worktree implementation uses station-owned `change-delivery`; `change-application` is fallback for returned artifacts, explicit integration, or generated/deployed sync. Full completion requires implementation, memory/docs, review, validation, and trace evidence.
- Memory mutation, git, release, deploy, install, credentials, destructive filesystem actions, MCP mutation, cloud mutation, and external-state changes each require their own protected gate and scope; `[SUDO]` records risk/override intent only.
- Antigravity workflow entries now use meaning-first Chinese descriptions, normalize missing memory evidence as `unverified` or `blocked`, and keep shared completion/security gates as thin references to shared skills and policies.
- Antigravity README and global GEMINI bootstrap text now use expanded PowerShell/CMD install examples, zero-touch checks, upgrade prompts, and post-deployment notices while preserving protected memory/project-skill boundaries.
- Antigravity README installed-surface documentation treats shared governance references as the explicit Shared allowlist plus `Shared/policies/` and `Shared/mcp-profiles/`; project tools and context templates are documented as separate deployed surfaces.
- `Antigravity/install.ps1` validates branch refs, HTTPS source host/path, target/download receipt paths, optional ZIP SHA256, and extracted child paths; its SHA helper accepts blank optional hashes while non-empty values remain 64-hex checked.
## Active Constraints
- Do not duplicate root system ownership in this card.
- Keep Antigravity-specific bootstrap, workflow, and platform facts here; keep shared operational details in Shared skills and policies.
- Do not track `.agents/memory/_map` or `.agents/memory/_system` source copies here.
- Split workflow child cards before adding another broad Antigravity workflow cycle.
- Antigravity workflows and skills must cite the shared language and grounding policies instead of treating core identity language text as the sole source.
- Remote bootstrap examples must preserve host/path validation, optional hash checks, receipt evidence, and safe temp cleanup.
- Keep this active card below `line_limit: 120`; compact before adding broad workflow-cycle detail.
## Cycle Events
- 10: Recorded Installed Surfaces wording repair for shared governance references, project tools, and context templates.
- 9: Recorded Antigravity installer empty SHA regression guard while preserving non-empty 64-hex validation.
- 8: Repaired stale warning state against 2026-07-07 Antigravity dirty source for Chinese-first rules, Team-Native authorization/protected gates, memory/MCP/[SUDO] boundaries, workflow descriptions, and README/GEMINI bootstrap wording.
- 7: Compacted active card on 2026-07-04, preserving captain limits, source/deployed parity, language layering, and installer trust-boundary facts.
- 6: Recorded dual-gate output and grounding updates across core and README before completion or commit readiness.
- 5: Corrected Team mode truth and captain boundary: governed requests activate Team mode; captain coordination cannot substitute for owner-station delivery.
- 4: Recorded README skill total as 62 and workflow authorization-semantics repair with 18/18 source/deployed workflow parity.
- 3: Consolidated workflow slimming, shared policy citations, risk-closure limits, memory/MCP/security gates, and read-before-write guard.
- 2: Regenerated shared subagent policy and workflow-orchestration grounding for Team-Native route/state hardening.
- 1: Compacted the previous Team-Native governance cycle into archive-004 after commit preflight reported line and cycle-event limits.
## Archive Index
- archive-004.md — Team-Native hard-gate cycle events 19-30 compacted on 2026-06-30.
- archive-003.md — Older cycle events 10-18 compacted from the active card.
- archive-002.md — Pre-standardization active card snapshot created during MEMORY.md migration.
- archive-001.md — Legacy _ag_core card preserved before schema v2 compaction on 2026-06-04.
## Evidence Base
- source: `Antigravity/README.md` Installed Surfaces table verified from current diff on 2026-07-09.
- tool: `cartridge-system__memory_status` reported `_ag_core` content complete with stale warning before this repair on 2026-07-09.
- source: Antigravity dirty source under `.agents/rules/`, `.agents/workflows/`, `README.md`, and `global/GEMINI.md` verified on 2026-07-07.
- source: `Antigravity/install.ps1` and preserved archives.
- tool: `git status --short -- Antigravity` and `git diff --stat -- Antigravity` reviewed 33 dirty Antigravity files before writing.
- tool: active-card measurement reported 116 lines before M2 compaction; `git diff/status` reviewed this card before writing.
- director: 2026-07-04 M2 scope authorized compaction of `_ag_core`, `_claude_core`, and `_codex_core` only.
## Read Contract
- Read this card when the task touches Antigravity tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Antigravity 是 Gemini 平台適配層。
- 目前 dirty source 已把總監輸出調整為繁中語義先行，並加強 Team-Native、授權解析與 protected gate 邊界。
- README 的 Installed Surfaces 現在把 Shared 治理參考、project tools、context templates 拆開描述。
- 記憶、MCP、`[SUDO]`、工作流 description、missing memory evidence 與完成/安全 gate 的 durable truth 已更新。
## Tracked Files
- Antigravity/install.ps1
- Antigravity/README.md
- Antigravity/VERSION
- Antigravity/global/GEMINI.md
- Antigravity/.agents/rules/00_core_identity.md
- Antigravity/.agents/rules/03_memory_skill_contract.md
- Antigravity/.agents/rules/04_forbidden_vocab.md
- Antigravity/.agents/rules/07_mcp_guardrails.md
- Antigravity/.agents/workflows/02_blueprint(架構).md
- Antigravity/.agents/workflows/03-2_build_execute(建構執行).md
- Antigravity/.agents/workflows/04-1_fix_plan(修復計畫).md
- Antigravity/.agents/workflows/04-2_fix_execute(修復執行).md
- Antigravity/.agents/workflows/05_condense(濃縮).md
- Antigravity/.agents/workflows/07_debug(除錯).md
- .agents/memory/_ag_core/archive-001.md
## Relations
- _system (root governance and deployment memory)
- _shared (Shared skills injected into Antigravity)
- _map (memory navigation index)
- _ag_core.support (child card for support rules and remaining workflows)

## Applicable Skills
- memory-ops — Use when updating this card.
- team-memory-docs-delivery-artifact — Use when source changes require memory/docs attribution.
