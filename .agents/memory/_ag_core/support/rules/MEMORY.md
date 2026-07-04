---
name: _ag_core.support.rules
scopePath: Antigravity/.agents/rules/
description: >-
  專案記憶：Antigravity 支援規則檔。Use when: task touches this split memory scope or its
  tracked files.
last_updated: '2026-07-04T22:50:53+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T21:22:46+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 6
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

# _ag_core.support.rules — Antigravity Rules Memory

## Current Truth
- This child card owns Antigravity support rule files.
- Rule files bridge shared governance into the Antigravity platform packaging area.
- `01_cross_lingual_guard.md` requires Director-facing Phase 0, 1, and 2 panel content to be Traditional Chinese while internal docs, artifacts, schemas, and canonical statuses keep their local convention.
- `01_cross_lingual_guard.md` makes Turn-1 memory startup a read-only route probe for memory inventory or health summary only.
- Memory startup must not auto-read full cards, call `commit_preflight`, call `memory_commit`, write context/memory, or turn stale/compaction findings into non-commit mid-task blockers.
- Antigravity source sentinel `Antigravity/.agents/rules/AGENTS.md` and deployed live sentinel `.agents/rules/AGENTS.md` now state 62 shared operational skills.
- Platform-specific wording must not override shared policy without an explicit source change.

## Active Constraints
- Do not duplicate full shared policy history here.
- Check shared policy drift when editing these support rules.
- Keep receipt-panel language requirements scoped to Director-facing content; canonical internal artifacts and status values remain local-convention content.
- Report memory startup compaction findings as compact packet or `memory_docs_state`; block only dependent memory-writing, completion, commit-prep, or closeout commit/push readiness phases.

## Cycle Events
- 06: Recorded 2026-07-04 cross-lingual guard repair for Director-facing panel language and read-only memory startup boundaries.
- 05: Recorded Antigravity sentinel skill-count repair from 50 to 62 in source and deployed live rule entrypoints.
- 04: Recorded Antigravity support-rule hardening so [SUDO] no longer skips security or quality gates and experiment output stays prototype-only when validation is incomplete.
- 03: Historical superseded count recorded Antigravity source/deployed sentinel coverage as 50 shared operational skills; event 05 corrected the count to 62 shared operational skills.
- 02: Updated Antigravity rule entrypoints to prefer deployed .agents/shared references.
- 01: Split Antigravity rules ownership out of the support parent card.

## Archive Index
- Parent archive remains at .agents/memory/_ag_core/support/archive-001.md.

## Evidence Base
- source:.agents/memory/_ag_core/support/archive-001.md — Previous support-card content preserved during migration.
- source:Antigravity/.agents/rules/01_cross_lingual_guard.md — Director-facing panel language boundary and read-only memory startup boundary verified on 2026-07-04.
- source:Antigravity/.agents/rules/AGENTS.md and `.agents/rules/AGENTS.md` — Sentinel skill count verified at 62 shared operational skills on 2026-07-03.
- tool:git diff/status — Tracked support-rule source change and this memory update were reviewed before writing on 2026-07-04.
- tool:memory_audit — Granularity advisory identified this support card as broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized focused child-card split.

## Read Contract
- Read this card when changing owned Antigravity support files.
- Read `_ag_core.support` only for support-family navigation and platform context.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Antigravity 支援規則檔。
- `01_cross_lingual_guard.md` 已區分總監可見繁中面板與內部本地慣例內容。
- Turn-1 記憶啟動現在是唯讀路由探測，不得自動讀全卡、commit、寫入或把 stale/compaction 變成一般任務阻斷。
- Antigravity source/live sentinel 的共用技能數已由當時舊口徑 50 修正並驗證為 62。
- 修改時要比對 Shared 共用政策是否漂移。

## Tracked Files
- Antigravity/.agents/rules/01_cross_lingual_guard.md
- Antigravity/.agents/rules/02_code_quality_security.md
- Antigravity/.agents/rules/05_project_skill_contract.md
- Antigravity/.agents/rules/06_memory_push.md
- Antigravity/.agents/rules/AGENTS.md

## Relations
- _ag_core.support (parent card: Antigravity support index)
- _shared (shared policy source)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting Antigravity support topology.
- impact-test-strategy — Use when workflow changes affect multiple entrypoints.
