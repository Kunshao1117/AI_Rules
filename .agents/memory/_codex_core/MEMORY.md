---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-03T22:25:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-03T22:23:45+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 22
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
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md` for project rules; 62 shared skills plus 17 workflow skills from `Codex/.agents/workflow-skills/` merge into `.agents/skills/` for a 79-skill deployed total.
- Codex bootstrap now uses Codex-specific initialization signals, not `.agents/` alone; `Codex/install.ps1` validates branch/ref, fixed GitHub ZIP source, target/receipt paths, optional ZIP SHA256, receipt, and fail-closed download/deploy flow.
- Codex governed user requests automatically activate Team mode, including governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, handoff, source, public-contract, or team/subagent/delegation dispatch.
- Without a current governed user request, AI must not self-start Team mode or team work from prior context, workflow names, source impact, platform tools, permission prompts, or tool approvals alone.
- In active Team mode, the Codex mainline automatically serves as captain and must stay within captain authority: communication, authorization resolution, board ownership, dispatch, supervision, delivery receipt, state synthesis, blockers/protected gates, and reporting.
- `03-1` experiment requests are governed workflow requests that auto-activate reduced/minimal experiment Team mode; sandbox writes remain experiment-only and cannot claim production completion.
- Codex core states source writes are not captain-default work: main-worktree implementation defaults to named station-owned `change-delivery` with `implementation-change-delivery`, exact allowlist, dirty diff read, and no protected actions.
- In active Codex Team mode, boards, role-exclusive stations, handoff packets, channel state, `station_mode`, `context_visibility`, `handoff_ownership`, and separated delivery artifacts are required before full completion.
- The captain pre-action gate covers broad read, repository-wide grep, recursive scan, whole-repository file inventory, validation, review, memory/docs attribution, completion audit, source write, and completion claim; small probes are limited to explicitly named files.
- Repo-managed Codex Hooks are removed and rebuild pending; hook scripts, hook config markers, and project hook scripts are not active tracked source truth in this card until a future rebuild is explicitly authorized.
- Codex protected write, protected mutation, and completion evidence requirements remain governance facts, but repo-managed hook enforcement code is not currently active source truth while the rebuild-pending state is in effect.
- Codex README now describes subagent routing as Codex native subagents or project custom agents, not a fixed `.codex/agents/*.toml` source path.
- Codex documentation and core rules use `closed-with-director-risk` for Director-closed non-complete cases and must not present missing specialist delivery as full team completion.
- Codex 07 Debug and 11 Handoff entries stay thin: they load shared references, treat commands/buttons/natural-language as routing signals, and allow formal-write only after scope-bound intent signal, authorization resolution, explicit phase/file/command binding, and required protected gate.
- Director-facing Codex output must stay Traditional Chinese and follow the Director-readable output contract; high-change or external claims must use grounding-governance evidence before completion.
- The captain owns Director-facing accountability, delivery receipt, board/status synthesis, blocker and authorization handling, protected memory/git/release gates, final review-state decisions, and final reporting; captain source-write, review, validation, broad-search, or memory/docs attribution replacement cannot support complete.
- Codex entry governance now summarizes thin-captain limits, no captain substitute authoring, the Team-Native object topology, multi-specialist separation from native subagents, and hard station-reduction rules.
- Codex completion-claim hooks require structured delivery artifact evidence for implementation, memory/docs, review, and validation; text-only artifact naming is blocked.
- Codex core keeps bootstrap and Director-facing Traditional Chinese mandates, while complete language-layer and external-grounding classification come from shared policies.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, and keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- Codex workflow entries must cite the deployed shared language policy before applying workflow-specific output, handoff, memory-language, or change-description rules.
- Codex workflow skill totals exclude the `_shared` support directory because it has no `SKILL.md`.
- Do not restore or track repo-managed Codex hook files until a scoped rebuild is authorized.
## Cycle Events
- 58: Hardened Codex bootstrap and installer trust boundaries: initialization now depends on Codex-specific signals, and installer downloads record receipt/hash/source evidence with optional SHA256 verification.
- 57: Recorded Codex dual-gate update: core and README cite Director-readable output and external grounding evidence before completion or commit readiness.
- 56: Corrected Team mode truth: governed user requests auto-activate Team mode, Codex mainline serves as captain, and absent current governed requests cannot self-start team work.
- 52-55: Consolidated Codex skill-count correction, native/project agent wording, repo-managed Hooks rebuild-pending state, thin 07/11 route entries, scope-bound formal-write gates, and station-owned source-write governance.
- 51: Superseded previous Codex renamed-hook marker memory after repo-managed hook removal; hook source tracking is now rebuild pending.
- 50: Recorded Codex coordination-boundary hardening: hooks and docs now use `captain_coordination_read_scope`, captain receipt/status synthesis, and authorized change-application gates instead of captain integration evidence.
- 49: Compacted active Codex core memory after commit preflight reported the active-card line limit, without changing current governance facts.
- 48: Removed direct Chinese regex literals from Codex hook reference-line detection, preserved source/deployed hook parity, and validated 58 hook fixtures across powershell.exe and pwsh.exe plus Doctor.
- 47: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 46: Recorded Codex language-governance grounding across core rules and selected workflow entries with deployed policy citation.
- 45: Recorded non-hook Codex core hardening that requires Team mode evidence for governed user-request work and forbids captain substitute authoring from supporting full completion.
- 44: Recorded final Team-Native cleanup for remaining Doctor red-light fixes, cross-platform core-rule sync, and commit-preflight stale blocker cleanup.
- 43: Updated Codex core memory after entry-governance and hook hardening: thin-captain rules, Team-Native object topology, multi-specialist/subagent separation, structured completion evidence, and clearer hook diagnostics are now current.
- 42: Updated Codex core memory after Team-Native authorization binding hardening: captain wording now means protected integration of recovered artifacts, hooks require current structured evidence plus trusted envelope/receipt records for protected mutations, and natural-language prompts stay bound to the visible target.
- 41: Tightened Codex protected mutation hooks so trusted envelope and trusted execution receipt evidence must match by identity or nonce and by action, target, scope, decision, and authorization before protected operations can proceed.
- 39: Added Codex hook diagnostic block reasons, natural-language prompt binding, post-block retry denial, Deploy.ps1 read-only false-positive coverage, fixture diagnostic-label assertions, and Doctor green validation.
- 38: Hardened Codex Team-Native hook authorization around structured current payload fields, transcript distrust, role/channel evidence, protected writes, and Windows-safe Chinese completion detection; source/deployed hook parity was preserved.
- 37: Stop hook repair added Codex live last-assistant-message coverage, short generic and mixed completion-claim blocking, active Stop continuation blocking, negated incomplete/read-only report exceptions, Chinese-key non-complete state handling, explicit memory/docs wording in the Stop block reason, and 52 passing hook fixtures; source/deployed hook hash parity verified.
- 36: Hooks Stability Implementation accepted with source/deployed hook and config hash parity, 41 fixture cases, Doctor Red 0 / Yellow 0, same-record protected authorization, per-action protected authorization coverage, exact write target matching, and a nonblocking deploy.patch dedicated-fixture gap.
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
- Codex 技能數量 current truth 是 62 套共用技能 + 17 套工作流技能 = 79；`_shared` 支援目錄不計入技能數。
- Codex 的 GO、工具提示與技能名稱只會變成有範圍的授權證據；子代理語彙是 native subagents 或專案自訂代理，不承諾固定 `.codex/agents/*.toml` 路徑。
- Codex 受治理使用者請求會自動啟動 Team mode；主線擔任隊長但只做協調、派工、接收、彙整與受保護閘門處理。
- `03-1` 會自動進入 reduced/minimal experiment Team mode；sandbox writes 不等於 production completion。
- 主工作區實作 primary 是具名 station-owned `change-delivery`；`change-application` 只作 returned artifact / integration / sync fallback。
- Codex 總監輸出需繁中語義先行；高變動或外部事實要走 external grounding evidence gate。
## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/VERSION
- Codex/.gitignore
- Codex/.agents/workflow-skills/02-blueprint-架構/SKILL.md
- Codex/.agents/workflow-skills/03-build-建構/SKILL.md
- Codex/.agents/workflow-skills/04-fix-修復/SKILL.md
- Codex/.agents/workflow-skills/07-debug-除錯/SKILL.md
- Codex/.agents/workflow-skills/11-handoff-交接/SKILL.md
- .agents/memory/_codex_core/archive-001.md
## Relations
- _system (root governance and deployment memory); _shared (Shared operational skills); _map (memory navigation index); _codex_core.support (support workflow child card)
