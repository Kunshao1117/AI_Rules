---
name: _system
scopePath: .
description: >-
  專案記憶：框架系統層、根文件與部署治理導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-07T05:53:55+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-07T05:53:55+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
cycle_event_count: 8
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

# _system — Repository Governance Memory

## Current Truth
- AI_Rules is the source repository for Antigravity, Claude Edition, and Codex Edition governance.
- Root README and platform README skill counts now describe 62 shared operational skills; Codex deployed skills total 79 from 62 shared skills plus 17 workflow skills, excluding the `_shared` support directory.
- Root `CLAUDE.md` is an ignored live/root file and now aligns Codex Edition to v0.1.3 plus 62 shared operational skills.
- Antigravity source sentinel `Antigravity/.agents/rules/AGENTS.md` and deployed live sentinel `.agents/rules/AGENTS.md` both describe 62 shared operational skills.
- Root documentation frames Team-Native Core as automatically activated by governed user requests or team/delegation dispatch; pure conversation, small stable answers, and no-impact work can stay ordinary/direct.
- Root documentation forbids AI from self-starting Team mode or team work without a current governed user request, including from prior context, source impact, workflow names, prompts, or tool approvals alone.
- Root documentation states the mainline/main agent automatically serves as Director-facing captain in active Team mode and stays within coordination only: station dispatch, board tracking, receipt, status synthesis, blocker routing, Director authorization request routing, and reporting.
- Root documentation treats `03-1` experiment/sandbox prototype requests as governed workflow requests that auto-activate reduced/minimal experiment Team mode without production completion.
- Pure 00 chat stays direct; evidence-bearing chat about files, screenshots, memory, rules, agent behavior, tool output, or governance impact enters formal-readonly with specialist evidence and captain coordination limited to receipt, board, blocker, or authorization needs.
- GO, interface buttons, platform prompts, modes, and workflow commands resolve only to scoped authorization evidence; workflow routes and modes are not standalone authorization.
- Repository-level governance uses delivery-artifact-driven Team-Native workflow: the captain coordinates station dispatch, receives station delivery, updates board state, routes blockers/Director authorization requests, and reports without authoring primary implementation, review, validation, broad-search evidence, memory attribution, or protected-action evidence.
- Root documentation distinguishes station-owned main-worktree `change-delivery` primary, fallback `change-application`, platform route states, manual setup status, captain substitute authoring, and `closed-with-director-risk` from completion.
- Root and platform documentation now describe the dual gates: Director-facing output uses Traditional Chinese meaning-first language governance, and high-change or external facts require grounded evidence before completion claims.
- Root documentation describes shared matrix deployment paths, downstream project-local tools under `.agents/tools/`, and framework-source-only manager commands.
- Root README and CHANGELOG now prepare AI Rules Manager v0.2.0 / `ai-rules-manager-0.2.0.vsix` release documentation, including same-name VSIX asset rerun failure semantics.
- Director-facing output must use Traditional Chinese unless a lower-level artifact explicitly requires another language.
- Root repository work, git status, commit, tag, and push operations use `D:\AI_Rules` as the baseline.
- Source memory lives in `.agents/memory/`; project context lives in `.agents/context/`; root PowerShell implementation ownership moved to `_system.scripts`.

## Active Constraints
- Do not commit, push, tag, publish, install, upgrade, or mutate external state without explicit Director approval.
- Do not edit another repository, including `D:\cartridge_system`, unless the Director explicitly approves cross-repository work.
- Keep root memory concise; move script-specific facts to `_system.scripts` and historical release details to archives.

## Cycle Events
- 22: Recorded root README and CHANGELOG v0.2.0 release-prep documentation, including explicit same-name VSIX asset rerun failure semantics.
- 21: Recorded root documentation dual-gate update for Director-readable output and external grounding evidence before commit/release readiness.
- 20: Corrected root Team mode truth: governed user requests auto-activate Team mode, mainline performs captain coordination only, `03-1` uses reduced experiment boards, and absent current governed requests cannot self-start team work.
- 19: Recorded root documentation skill-count cleanup: README files, ignored live/root `CLAUDE.md`, and Antigravity source/live sentinels now use 62 shared skills; Codex deployed skill count remains 79 (62 shared + 17 workflow, excluding `_shared` support directory).
- 18: Compacted root documentation history into Current Truth after Team-Native, formal-readonly/formal-write, scoped authorization, captain non-authoring, and current skill-count wording became the root documentation baseline.
- 17: Recorded final Team-Native cleanup for remaining Doctor red-light fixes, cross-platform sync, changelog precision, and commit-preflight stale blocker cleanup.
- 16: Recorded the 2026-07-01 Team-Native thin-captain and multi-specialist documentation hardening; root docs and changelog now avoid wording that implies captain authoring, self-review, or blanket GO authority.
- 01-15: Consolidated earlier June 2026 root governance, Team-Native, scoped-authorization, workflow orchestration, and pre-commit documentation events into Current Truth and archives.

## Archive Index
- archive-001.md — Legacy _system card identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.
- archive-003.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:README.md — Root release section now names v0.2.0 and same-name VSIX asset rerun failure semantics.
- source:CHANGELOG.md — AI Rules Manager v0.2.0 release-prep entry records governance readiness, runtime gate hardening, rerun semantics, and memory/docs cleanup alignment.
- source:README.md and CHANGELOG.md rechecked on 2026-07-07 for v0.2.0 release docs and same-name VSIX asset rerun failure semantics.
- source:.agents/memory/_system/archive-003.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified root script ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized script child-card creation.

## Read Contract
- Read this card for repository-level governance, release baseline, and memory/context boundaries.
- Read `_system.scripts` before changing root PowerShell scripts.

## Conflicts and Supersession
- No unresolved root `CLAUDE.md` or Antigravity sentinel skill-count conflict remains after the 2026-07-03 documentation cleanup.

## 中文摘要
- AI_Rules 是三平台治理框架核心庫；README/三平台 README 目前採共用技能 62，Codex 部署技能 79。
- 根 README 與 CHANGELOG 已準備 AI Rules Manager v0.2.0 / `ai-rules-manager-0.2.0.vsix` 發布文件，並明確同名 VSIX asset 補跑會拒絕或失敗。
- 根層 `CLAUDE.md` 是 ignored live/root file，已對齊 Codex v0.1.3 與 62 套共用技能；Antigravity source/live sentinel 也對齊 62 套。
- 按鈕、`GO`、workflow 與 mode 只提供範圍化授權證據，不是授權本身。
- 受治理請求會自動進 Team mode；沒有目前受治理請求時 AI 不能自行啟動團隊工作。
- Team mode 主線只做 Director-facing captain 協調、派工、接收、彙整、阻塞/授權路由與回報；`03-1` sandbox 不等於 production completion。

## Tracked Files
- .gitignore
- README.md
- CHANGELOG.md
- LICENSE

## Relations
- _map (memory navigation index)
- _shared (Shared governance source)
- _codex_core (Codex platform source)
- _claude_core (Claude platform source)
- _ag_core (Antigravity platform source)
- _system.scripts (child card: root PowerShell scripts)
