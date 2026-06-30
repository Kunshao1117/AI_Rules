---
name: _system
scopePath: .
description: >-
  專案記憶：框架系統層、根文件與部署治理導覽父卡。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-06-30T13:39:01+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-29T13:50:50+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
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

# _system — Repository Governance Memory

## Current Truth
- AI_Rules is the source repository for Antigravity, Claude Edition, and Codex Edition governance.
- Root documentation and changelog now frame Team-Native Core as a pre-execution state machine for coding, architecture, broad-read, validation, review, memory, commit, release, and governance-impact work.
- Pure 00 chat stays direct, while evidence-bearing chat about files, screenshots, memory, rules, agent behavior, tool output, or governance impact enters formal-readonly with specialist evidence and captain verify-read.
- GO, interface buttons, platform prompts, modes, and workflow commands resolve only to scoped authorization evidence; workflow routes and modes are not standalone authorization.
- Repository-level governance uses delivery-artifact-driven Team-Native workflow: the captain boards, dispatches, supervises, integrates returned artifacts, decides, and reports without authoring primary implementation, review, validation, or memory attribution.
- Root documentation distinguishes platform route states from manual setup status, protected integration from captain substitute authoring, and `closed-with-director-risk` from completion.
- Root README platform counts currently describe 61 shared operational skills and 78 Codex deployed skills.
- Changelog includes the 2026-06-29 scoped authorization and pre-commit governance entries plus the 2026-06-30 workflow orchestration and Codex hook stability entries.
- Root documentation describes shared matrix deployment paths, downstream project-local tools under `.agents/tools/`, and framework-source-only manager commands.
- Director-facing output must use Traditional Chinese unless a lower-level artifact explicitly requires another language.
- Root repository work, git status, commit, tag, and push operations use `D:\AI_Rules` as the baseline.
- Source memory lives in `.agents/memory/`; project context lives in `.agents/context/`; root PowerShell implementation ownership moved to `_system.scripts`.

## Active Constraints
- Do not commit, push, tag, publish, install, upgrade, or mutate external state without explicit Director approval.
- Do not edit another repository, including `D:\cartridge_system`, unless the Director explicitly approves cross-repository work.
- Keep root memory concise; move script-specific facts to `_system.scripts` and historical release details to archives.

## Cycle Events
- 13: Recorded the 2026-06-30 Codex hook stability changelog entry and cleared the CHANGELOG staleness warning after reading the current entry.
- 12: Recorded the 2026-06-30 Team-Native workflow orchestration changelog entry and cleared the CHANGELOG staleness warning after reading the current entry.
- 11: Documented the 00 evidence-bearing chat boundary in root README: pure chat remains direct, but evidence-dependent discussion uses Team-Native formal-readonly stations to reduce captain context pollution and preserve looped evidence.
- 10: Documented Team-First runtime-state semantics, formal-readonly/formal-write split, station handoff packets, standby, unavailable-channel reporting, and deep-read/verify-read boundaries in root README.
- 09: Recorded the 2026-06-29 Team-Native scoped authorization refactor changelog entry and cleared the CHANGELOG staleness warning after reading the current entry.
- 08: Documented scoped authorization resolution, interface-button evidence limits, workflow route-only semantics, and Team-Native priority in root README.
- 07: Recorded the 2026-06-29 pre-commit governance convergence changelog entry after exact-hash sync and memory-health checks passed.
- 06: Recorded the second Team-Native refactor as delivery-artifact-driven across root docs, changelog, team routes, and captain non-authoring boundaries.
- 05: Updated root documentation and changelog to use `closed-with-director-risk` and delivery artifacts for Team-Native second refactor.
- 04: Removed residual captain-substitution wording from root and platform README text.
- 03: Documented Team-Native specialist registry, change delivery artifact terminology, 61 shared skills, and 78 Codex deployed skills.
- 02: Clarified root README route wording so native, adapter, conditional, unavailable, and manual setup status are not conflated.
- 01: Consolidated June 2026 repository governance documentation history into Current Truth after Team-Native Core documentation and trace-audit support landed.

## Archive Index
- archive-001.md — Legacy _system card identity and decisions through D39.
- archive-002.md — Continued legacy decisions, module lessons, and documentation history.
- archive-003.md: Pre-standardization active card snapshot created during MEMORY.md migration.

## Evidence Base
- source:.agents/memory/_system/archive-003.md — Previous active card snapshot preserved.
- tool:memory_audit — Granularity advisory identified root script ownership as a split candidate.
- director:2026-06-15 — GO SPLIT authorized script child-card creation.

## Read Contract
- Read this card for repository-level governance, release baseline, and memory/context boundaries.
- Read `_system.scripts` before changing root PowerShell scripts.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; contradictions found later must be indexed here.

## 中文摘要
- AI_Rules 是三平台治理框架核心庫。
- 根層文件已明定按鈕與 GO 只能作為有範圍的授權證據，工作流與模式不是授權本身。
- 根層文件已把編程流程改成團隊協作優先，而不是主線單人處理加可選委派。
- 根層文件已把 00 證據型對話納入團隊 formal-readonly；純聊天才維持直接回覆。
- 根層 Git 與發布操作以 `D:\AI_Rules` 為基準。
- PowerShell 腳本已拆到 `_system.scripts` 子卡。

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
