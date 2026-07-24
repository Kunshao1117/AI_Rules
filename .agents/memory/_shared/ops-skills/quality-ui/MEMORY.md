---
name: _shared.ops-skills.quality-ui
scopePath: Shared/skills/
description: >-
  專案記憶：Shared 品質閘門、安全可靠性與 UI/UX 標準技能。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-07-24T13:40:23+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-24T13:41:00+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 12
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
- This child card owns Shared quality gate, intent-alignment, review governance, security/SRE, UI design exploration, and UI/UX standard skills; these define governance expectations, not task-specific pass results.
- Tracked quality/UI skill descriptions now start with Traditional Chinese task meaning while preserving canonical English review states, evidence fields, and exact technical identifiers.
- AI development quality gate classifies task depth, change intent, patch-stack risk, review escalation, real execution evidence, component reuse, design DNA, reference downgrade, interface evidence, and escalation from `coding-reflection-gate` when route risk or governance depth requires quality routing.
- Real execution is required for claims involving real data, runtime state, persistence, integration, cloud/deployment, or operator-visible behavior; synthetic, mock, fixture, or static screenshot evidence is partial only.
- Quality review governance requires independent review boundaries, lifecycle state, evidence state, review basis, and minimum sufficient complexity; evidence branches do not own final review disposition or protected mutation.
- Intent alignment gate owns requirement playback, neutral challenge, decision trace, acceptance trace, drift audit, and `coding-reflection-gate` reroutes for ambiguity or drift risk; unauthorized deviation or unverified critical acceptance evidence blocks completion claims.
- UI exploration now distinguishes new/no UI, approved DNA, missing DNA, and narrow edits before component inventory; generated images, Stitch screens, and templates are references until real rendered UI validates implementation.
- UI/UX standards classify surface and mode before layout rules, require component reuse/DNA reasoning, and forbid persisting design DNA without explicit `GO CONTEXT` or `GO DNA`.
- Security/SRE keeps [SUDO] as risk-closure only; 03-1 experiments may handle real API/DB/credential risk but cannot claim production security readiness.

## Active Constraints
- Do not use this card as evidence that a specific product screen or security control passed validation.
- Keep Director-facing design and quality summaries in Traditional Chinese.
- Captain or orchestration synthesis cannot upgrade raw evidence-branch output into independent review disposition or completion readiness.
- Use real rendered or equivalent surface-matched evidence before marking UI layout, component, style, or interaction work complete.
- Do not create visually similar components while ignoring existing shared components or approved design DNA.

## Cycle Events
- 12: Recorded `coding-reflection-gate` escalation paths into AI quality and intent-alignment gates for ambiguity, risk, retry, and governance-depth routing.
- 11: Repaired stale quality/UI memory for zh-TW trigger wording, real-evidence gates, review lifecycle, intent drift, component reuse, and design DNA boundaries.
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
- source/upstream_artifact:Shared/skills/ai-dev-quality-gate/SKILL.md — Verified task-depth, change-intent, real-evidence, component reuse, design DNA, reference downgrade, interface evidence gates, and 2026-07-08 coding-reflection-gate escalation input.
- source:Shared/skills/quality-review-governance/SKILL.md — Verified independent review, lifecycle states, evidence branch boundary, minimum sufficient complexity, and completion/readiness separation.
- source/upstream_artifact:Shared/skills/intent-alignment-gate/SKILL.md — Verified requirement playback, neutral challenge, decision/acceptance trace, drift audit states, and 2026-07-08 coding-reflection-gate reroute input.
- source:Shared/skills/ui-design-exploration/SKILL.md and Shared/skills/ui-ux-standards/SKILL.md — Verified UI state classification, component primitives, design DNA persistence boundary, and surface-specific evidence routing.
- source:Shared/skills/security-sre/SKILL.md — Verified [SUDO] and 03-1 prototype-only security boundaries.
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
- 品質/UI skills 已改成繁中 meaning-first 觸發語意，內部 review/evidence 欄位仍保留 canonical English。
- 真實執行、獨立審查、需求偏移與 UI surface 證據是完成主張的邊界。
- 它記錄規範歸屬，不直接證明單次畫面、審查或安全檢查通過。

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
