---
name: _shared.ops-skills.quality-ui
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 品質閘門、安全可靠性與 UI/UX 標準技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-04T22:52:02+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-04T21:24:30+08:00'
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

# _shared.ops-skills.quality-ui — Quality and UI Skills Memory

## Current Truth
- This child card owns Shared quality gate, security/SRE, UI design exploration, and UI/UX standard skills; these skills define quality expectations, not task-specific findings.
- Quality review governance requires independent review boundaries: implementation specialists cannot review their own deliverable, and review specialists cannot implement the same deliverable.
- Quality review governance defines correctness, high quality, rigor, review timing, lifecycle states, evidence branch boundaries, and minimum sufficient complexity.
- Quality review governance now follows the active Programming Team Board; review evidence stations default to read-only evidence unless a concrete direct exception is recorded, and evidence branches do not own review disposition, readiness checks, or protected mutation.
- Review output uses canonical English fields internally; Director-facing review summaries must be synthesized in Traditional Chinese.
- AI development and intent alignment gates classify change shape and escalate heavy, structural, governance, public-contract, release, security, cross-module, or repeated fragile work into review-state reporting.
- AI development quality gates require real evidence before completion claims for governance, workflow, public-contract, security, release, or repeated fragile work, while keeping extra token margin for managed-cache and source checkout limits.
- Intent alignment gate defines requirement playback, neutral challenge, decision trace, requirement trace, and drift audit output contracts for architecture and build workflows.
- Interface, visual, and generated design evidence requires detail observation, real-information priority, real rendered screenshots or UI state, or clearly labeled fallback risk.
- High-change security or accessibility guidance must be grounded in current official sources; [SUDO] remains risk-closure only and 03-1 experiments cannot claim production security readiness.

## Active Constraints
- Do not use this card as evidence that a specific product screen or security control passed validation.
- Keep Director-facing design and quality summaries in Traditional Chinese.
- Captain or orchestration synthesis cannot upgrade raw evidence-branch output into independent review disposition or completion readiness.

## Cycle Events
- 10: Recorded security-SRE hardening so [SUDO] cannot skip validation and experiment work remains prototype-only for production security claims.
- 09: Recorded quality-gate hardening so governance, workflow, public-contract, security, release, or repeated-fragile work escalates to review-state evidence instead of lightweight completion.
- 08: Added independent-review and role-separation enforcement to quality-review-governance.
- 07: Aligned quality-review-governance with team-first evidence stations and all-direct review-board rejection.
- 06: Compressed ai-dev-quality-gate with extra token margin after managed cache CRLF checkout exposed line-ending-sensitive estimates.
- 05: Added quality-review-governance and wired review-state escalation into AI development quality and intent alignment gates.
- 04: Added intent-alignment-gate as the shared requirement alignment and drift-audit governance skill.
- 03: Compressed ai-dev-quality-gate wording under the Shared skill quality token limit while preserving change-intent and visual-evidence gates.
- 02: Added change intent classification, patch-stack escalation, detail observation, and real-information visual evidence gates.
- 01: Split quality and UI/UX ownership out of the broad Shared operational skills card.

## Archive Index
- Parent archive remains at .agents/memory/_shared/ops-skills/archive-001.md.

## Evidence Base
- source:Shared/skills/quality-review-governance/SKILL.md — Verified canonical review fields, owner-station review disposition, evidence branch boundaries, and completion/readiness separation.
- source:Shared/skills/browser-testing/SKILL.md — Verified visual evidence real-information priority and capture-time limitation.
- source:Shared/policies/language-governance.md — Verified Director-facing zh-TW synthesis and internal canonical English artifact boundary.
- source:.agents/memory/_shared/ops-skills/archive-001.md — Previous parent-card content preserved during migration.
- tool:memory_audit — Granularity advisory identified this card as too broad by tracked-file count.
- director:2026-06-15 — GO SPLIT authorized controlled child-card split.

## Read Contract
- Read this card when working on owned source files or the named operational area.
- Read the parent card only for Shared-level navigation; do not treat parent-child links as dependencies.

## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.

## 中文摘要
- 此子卡負責品質閘門、安全可靠性與 UI/UX 標準。
- 審查治理已接上團隊站點板，不能把審查證據分支視為單純可選。
- 它記錄規範歸屬，不直接證明單次畫面或安全檢查通過。

## Tracked Files
- Shared/skills/ai-dev-quality-gate/SKILL.md
- Shared/skills/intent-alignment-gate/SKILL.md
- Shared/skills/quality-review-governance/SKILL.md
- Shared/skills/security-sre/SKILL.md
- Shared/skills/ui-design-exploration/SKILL.md
- Shared/skills/ui-ux-standards/SKILL.md

## Relations
- _shared.ops-skills (parent card: operational-skill family index)
- _shared (Shared governance parent)

## Applicable Skills
- memory-ops — Use when updating this child card.
- memory-arch — Use when adjusting child-card topology.
