---
name: _shared.ops-skills.testing
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 測試、瀏覽器、效能、無障礙與回歸策略技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-07T05:52:39+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-07T05:52:39+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 9
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

# _shared.ops-skills.testing — Testing Skills Memory

## Current Truth
- This child card owns Shared testing, browser evidence, accessibility, performance, test automation, test-pattern, Trunk, and regression strategy skills.
- Tracked testing skill descriptions now use Traditional Chinese task meaning first and preserve canonical English for tool names, artifacts, and state values.
- Browser evidence remains station-owned evidence by default; required browser branches cannot silently downgrade to direct browsing without a recorded direct exception and replacement evidence.
- Visual validation must include detail-observation notes; screenshots or DOM snapshots prove only visible capture-time state and do not prove persistence, business rules, real data, or integrations by themselves.
- Real-information visual evidence is preferred: real pages, records, account state, responses, logs, or equivalent real paths. Mock, fixture, fake, seeded, static, or idealized data is fallback only and must state residual risk.
- Test-pattern mocks validate scoped logic and contracts only; they cannot complete real-runtime, data-source, external-service, filesystem, browser, or operator-workflow claims without real execution evidence.
- Performance-audit and Trunk keep install, report-artifact writes, CI/deploy changes, uploads, remote settings, and generated source fixes as separate protected phases.
- Trunk is native MCP, not Gateway; Trunk fixId or setup instructions are plan material until the matching phase is separately authorized.

## Active Constraints
- Do not turn one-time test output into permanent memory.
- Use project-surface evidence requirements from the workflow matrix before declaring behavior verified.
- Resolve each testing protected phase to its own scope, command or tool call, target, expiry, and gate before mutation.
- Failed browser evidence may create a required-change item only; repairs return to `change-delivery` or authorized `change-application`.
- Before marking real execution unavailable, record operator-tool discovery, retry/readiness checks, equivalent paths considered, and the remaining blocker.

## Cycle Events
- 09: Repaired stale testing memory for zh-TW trigger semantics, browser/visual real-evidence rules, mock boundaries, and protected performance/Trunk phases.
- 08: Recorded Batch 4A testing/performance/Trunk gate hardening: install, report writes, CI/deploy changes, uploads, remote settings, and source fixes are separate protected phases; fix IDs do not authorize writes.
- 07: Recorded browser-testing governance alignment after push af501c6: required browser evidence remains station-owned unless a concrete direct exception is recorded.
- 06: Recorded testing-skill hardening so [SUDO] cannot skip mock checks, authorize real network calls, or bypass validation.
- 05: Recorded testing-skill hardening so browser and automation evidence cannot silently downgrade to captain direct work and real-information proof remains required before completion claims.
- 04: Aligned testing and browser evidence memory with captain-led evidence station rules.
- 03: Added browser-branch direct-exception boundaries for team-first evidence station governance.
- 02: Added visual detail observation and real-information priority to browser and test automation evidence strategy.
- 01: Split testing and evidence strategy ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:Shared/skills/browser-testing/SKILL.md — Verified browser branch scope, direct-exception boundary, detail-observation, real-information priority, retry/equivalent-path rules, and read-only evidence routing.
- source:Shared/skills/test-automation-strategy/SKILL.md — Verified visual proof, screenshot boundary, real function proof, fallback-data classification, and Traditional Chinese UI assertion guidance.
- source:Shared/skills/test-patterns/SKILL.md — Verified mock strategy boundaries, [SUDO] handling, and real-execution requirement for runtime-dependent claims.
- source:Shared/skills/performance-audit/SKILL.md and Shared/skills/trunk-ops/SKILL.md — Verified separated protected phases for installs, report writes, CI/deploy mutation, uploads, source fixes, and remote Trunk settings.
- source:Shared/skills/a11y-testing/SKILL.md and Shared/skills/impact-test-strategy/SKILL.md — Verified a11y trigger wording and regression scope requirements for real execution paths.
- source:Shared/policies/language-governance.md — Verified Director-facing zh-TW and internal canonical English field boundary.
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責 Shared 測試、瀏覽器、效能、無障礙與回歸策略。
- 瀏覽器證據不可靜默退回主線工具；缺證據需標記 blocked、unverified 或具體 direct exception。
- 截圖與 mock 只能證明有限狀態；資料、整合、持久化與操作者流程仍需真實或等效路徑。
- 效能與 Trunk 的 install、報告寫入、CI/deploy、upload、remote setting 與 source fix 都是分離 protected phase。

## Tracked Files
- Shared/skills/a11y-testing/SKILL.md
- Shared/skills/browser-testing/SKILL.md
- Shared/skills/impact-test-strategy/references/regression-test-examples.md
- Shared/skills/impact-test-strategy/SKILL.md
- Shared/skills/performance-audit/SKILL.md
- Shared/skills/test-automation-strategy/SKILL.md
- Shared/skills/test-patterns/references/api-route-test-template.md
- Shared/skills/test-patterns/references/hook-test-template.md
- Shared/skills/test-patterns/references/utility-test-template.md
- Shared/skills/test-patterns/SKILL.md
- Shared/skills/trunk-ops/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
