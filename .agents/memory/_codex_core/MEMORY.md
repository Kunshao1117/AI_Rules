---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-05T13:28:22+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-05T13:25:32+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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

# _codex_core — Codex Edition Memory
## Current Truth
- Codex Edition is the OpenAI Codex adapter for AI_Rules governance, using `.codex/AGENTS.md` for project rules; 62 shared skills plus 17 workflow skills from `Codex/.agents/workflow-skills/` merge into `.agents/skills/` for a 79-skill deployed total.
- Codex bootstrap now uses Codex-specific initialization signals, not `.agents/` alone; `Codex/install.ps1` validates branch/ref, fixed GitHub ZIP source, target/receipt paths, optional ZIP SHA256, receipt, and fail-closed download/deploy flow.
- Governed Codex requests activate Team mode; without a current governed request, AI must not self-start team work from prior context, workflow names, source impact, platform tools, permission prompts, or tool approvals alone.
- In active Team mode, the Codex mainline is the Director-facing captain and is limited to coordination, dispatch, board maintenance, delivery receipt, status synthesis, blocker routing, authorization routing, and reporting.
- Codex source writes are not captain-default work: main-worktree implementation uses station-owned `change-delivery`; `change-application` is fallback for returned artifacts, explicit integration, or generated/deployed sync.
- Completion, broad reads, validation, review, memory/docs attribution, source writes, and completion claims require board, role-exclusive stations, handoff packets, channel state, `station_mode`, `context_visibility`, `handoff_ownership`, and separated delivery artifacts.
- Captain pre-action gates allow only explicitly named-file probes; broad/read-validation-review-memory evidence must come from station-owned or specialist evidence, not `captain-owned evidence`.
- Repo-managed Codex Hooks are removed and rebuild pending; hook scripts, hook config markers, and project hook scripts are not active tracked source truth in this card until a future rebuild is explicitly authorized.
- Codex README now describes subagent routing as Codex native subagents or project custom agents, not a fixed `.codex/agents/*.toml` source path.
- Codex documentation and core rules use `closed-with-director-risk` for Director-closed non-complete cases and must not present missing specialist delivery as full team completion.
- Codex 07 Debug and 11 Handoff entries stay thin, loading shared references and allowing formal-write only after owner-station scope binding, explicit phase/file/command binding, and protected-action authorization.
- Codex workflow entries now use on-demand Required References: captain entry starts from the workflow row, route summary, workflow evidence row, orchestration order, and Team-Native minimum entry, while language, grounding, platform, stage, write, review, validation, memory, completion, and station details load only when that decision or station opens.
- Codex entry governance summarizes thin-captain limits, no captain substitute authoring, Team-Native object topology, multi-specialist separation from native subagents, and station-reduction rules.
- Codex core and global bootstrap keep Director-facing output in Traditional Chinese; internal source docs, policies, references, skills, schemas, and code keep local convention and prefer concise English unless explicitly Director-facing.
- Current source/deployed parity is verified for `Codex/.codex/AGENTS.md` to `.codex/AGENTS.md`, and for `Codex/global/AGENTS.md` to the user-global `.codex/AGENTS.md`.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, and keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- Codex workflow entries must cite the deployed shared language policy before applying workflow-specific output, handoff, memory-language, or change-description rules.
- Codex workflow skill totals exclude the `_shared` support directory because it has no `SKILL.md`.
- Do not restore or track repo-managed Codex hook files until a scoped rebuild is authorized.
- Keep this active card below `line_limit: 120`; compact before adding broad hook/workflow-cycle detail.
- After Codex framework source changes, verify source/deployed parity or report it as pending before final completion.
## Cycle Events
- 10: Updated Codex workflow-entry truth for on-demand Required References and source/deployed block parity after the 2026-07-05 captain-context reduction.
- 9: Compacted active card on 2026-07-04, preserving bootstrap, captain limits, source/deployed parity, language layering, and hook rebuild-pending facts.
- 8: Hardened Codex bootstrap and installer trust boundaries: Codex-specific initialization, receipt/hash/source evidence, and optional SHA256 verification.
- 7: Recorded dual-gate output and grounding updates across core and README before completion or commit readiness.
- 6: Corrected Team mode truth and captain boundary: governed requests activate Team mode; captain coordination cannot substitute for owner-station delivery.
- 5: Consolidated skill-count correction, native/project agent wording, hook rebuild-pending state, thin 07/11 entries, formal-write gates, and station-owned source-write governance.
- 4: Recorded coordination-boundary hardening with `captain_coordination_read_scope`, receipt/status synthesis, and authorized change-application gates.
- 3: Consolidated workflow slimming, language-governance grounding, shared policy citations, source/deployed parity, and Team-Native evidence gates.
- 2: Preserved hook-era validation history only as archived context; repo-managed hook enforcement is not active source truth until rebuilt.
- 1: Hooks Stability Implementation and later hook repairs remain historical archive facts, not current tracked source truth.
## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- source: `Codex/.codex/AGENTS.md`, `.codex/AGENTS.md`, `Codex/global/AGENTS.md`, and user-global `.codex/AGENTS.md`.
- source: `.agents/shared/policies/language-governance.md` for Director-facing zh-TW and internal English-led artifact layering.
- tool: `Get-FileHash -Algorithm SHA256` verified Codex core source/deployed parity and global bootstrap parity on 2026-07-04.
- tool: active-card measurement reported 128 lines before M2 compaction; `git diff/status` was reviewed before writing.
- tool: 2026-07-05 validation verified 17 Codex workflow source/deployed Required References blocks match after on-demand loading sync.
- director: 2026-07-04 M2 scope authorized compaction of `_ag_core`, `_claude_core`, and `_codex_core` only.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Codex 是 OpenAI Codex 平台適配層。
- Codex 技能數量 current truth 是 62 套共用技能 + 17 套工作流技能 = 79；`_shared` 支援目錄不計入技能數。
- Codex 受治理請求會啟動 Team mode；主線只做 Director-facing captain 協調與授權路由。
- Codex 工作流入口已改為按需載入 references，隊長入口不再預讀完整治理鏈。
- Native subagents/project custom agents、hook rebuild-pending、station-owned source write 與 parity 事實已保留。
- 總監可見輸出維持繁中；內部文件、狀態值、指令與程式識別保持本地慣例。
- 本卡已依最新 source 修復 stale 狀態；仍需另行 `memory_commit` 同步索引。
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

## Applicable Skills
- memory-ops — Update and commit this card.
- team-memory-docs-delivery-artifact — Report memory/docs state.
