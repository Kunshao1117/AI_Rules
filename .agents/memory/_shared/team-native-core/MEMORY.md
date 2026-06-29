---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-06-29T09:41:05+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-29T07:25:32+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
cycle_event_count: 16
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
# _shared.team-native-core — Team-Native Core Governance Memory
## Current Truth
- Authorization Resolution is now a shared Team-Native Core pre-write gate: GO, interface approvals, platform prompts, modes, and workflow names must resolve into scoped authorization fields before protected work.
- Formal boards, Team-Native trace evidence, delivery artifacts, and completion gates now carry the same scoped authorization fields, so missing authorization blocks completion instead of becoming captain repair.
- Team-Native Core is the default governance model for source, workflow, validation, review, memory, commit, release, handoff, skill-forge, generated-copy, public-contract, and governance-impact work.
- Team-Native Core is delivery-artifact-driven and station-first: the captain creates boards, dispatches, supervises, integrates returned qualified artifacts, decides review state, and reports; specialist stations own primary content, implementation, review, validation, and memory attribution.
- Specialist roles are defined by `team-specialist-registry` plus ten child skills: intent requirements, scope impact, architecture contract, change delivery, validation, review, security reliability, memory docs, release completion, and external research; task boards reference those skills instead of maintaining independent role lists.
- Platform routes are recorded as native, adapter, conditional, or unavailable. Conditional routes require evidence; unavailable routes resolve to blocked, unverified, or `closed-with-director-risk`, never routine direct work.
- Full team completion requires an implementation change delivery artifact, memory/docs delivery artifact, independent review delivery artifact, validation delivery artifact, completion evidence, and required Team-Native trace evidence.
- Formal boards open work by dispatch wave; review, validation, memory/docs, and completion stations wait for the needed prior-wave artifact or recorded blocked, unverified, or `closed-with-director-risk` state.
- Team task and delivery sources use direct-renamed skill names: `team-task-board`, `team-change-delivery-artifact`, `team-memory-docs-delivery-artifact`, `team-validation-delivery-artifact`, and `team-review-delivery-artifact`; old formal skill names are legacy only.
- Specialist assignment is mandatory before channel selection; unavailable subagent/tool/browser/CLI/MCP/isolation routes leave the station blocked, unverified, or `closed-with-director-risk` instead of cancelling the station or becoming routine captain work.
- The captain owns protected integration but does not author primary implementation, review, validation, or memory-attribution content. Captain substitute authoring is blocked, unverified, or `closed-with-director-risk` and is never `complete`.
- Completion gates use `closed-with-director-risk` for Director-closed non-complete risk; the old risk-completion state is retired except in legacy-detection code.
- Team trace `review_state` may use `accepted-risk` only as a review lifecycle judgment; station status, delivery artifact status, memory/docs state, captain-authoring state, and completion state must use blocked, unverified, or `closed-with-director-risk` as applicable.
- Subagents are execution channels only; specialist execution-channel fields use vendor-neutral platform wording, while platform-specific subagent names stay in translation sections and matrices.
- Team trace evidence now includes scoped authorization fields and platform-mode observation; task logs remain under `.agents/logs/team-traces/` when enabled, while durable source facts belong in source memory after the memory phase.
- Governance Doctor includes static Team-Native Core semantic checks and optional strict trace checks with explicit trace parameters from the audit entrypoint.
- Antigravity / Gemini team stations are adapter or conditional routes unless a concrete native capability is verified.
- Delegation strategy, programming-team governance, and team-task-board skills were compressed below the shared-skill quality gate; governance red lights, three-skill TokenStatus issues, and accepted-risk residue in two specialist skills were fixed and synchronized to deployed copies.
- Team-Native task boards now define specialist lifecycle state, retention reason, conversation health, reuse count, handoff summary, closure reason, fast closeout lane, Yellow classification, Yellow resolution state, and repair loop count. Light closeout reduces station churn only when evidence remains traceable; standard/release-grade lanes still require separated artifacts.
## Active Constraints
- Do not describe missing platform capability as routine direct work.
- Do not claim `complete` without separated delivery artifact classes, independent review, validation, memory/docs disposition, and trace evidence.
- Do not copy raw task traces into source memory; record only stable governance facts or validation routes.
- Keep platform-specific tool names in adapter sections or platform-specific files.

## Cycle Events
- 16: Promoted authorization fields into team-task-board, programming-team-governance, completion gate, and delivery artifact templates; synced Codex/Antigravity and Claude skill copies; Doctor and Deploy Audit returned red 0 / yellow 0.
- 15: Added scoped authorization resolution policy, authorization trace fields, workflow route-only semantics, and platform button/mode mapping; source and deployed shared copies are synchronized.
- 14: Removed format-only EOF drift from Team-Native source skills and policies, synchronized deployed copies, and reverified Doctor and Deploy Audit at red 0 / yellow 0.
- 13: Added specialist lifecycle, fast closeout lanes, Yellow classification/resolution, repair loop limits, and byte-level source/deployed sync verification; Doctor and Deploy Audit returned red 0 / yellow 0.

## Archive Index
- archive-001.md — Older cycle events 1-12 compacted from the active card.
- No archive volumes yet.

## Evidence Base
- source:Shared/policies/authorization-resolution.md — Scoped authorization policy source; deployed copy is `.agents/shared/policies/authorization-resolution.md`.
- source:Shared/policies/team-native-core.md — Team-Native Core policy source.
- source:Shared/policies/team-trace-evidence.md — Team trace evidence contract.
- source:Shared/platform-capability-matrix.md and Shared/workflow-capability-evidence-matrix.md — route states, dispatch waves, and completion evidence.
- source:Shared/skills/team-specialist-registry/SKILL.md and ten Shared/skills/team-specialist-*/SKILL.md child skills — role source; deployed .agents/skills copies are sync evidence only.
- source:Scripts/modules/Audit.psm1 — Doctor Team-Native Core and trace checks.

## Read Contract
- Read this card when touching Team-Native Core policy, subagent policy, team-task-board, platform matrix, workflow matrix, or Doctor team governance checks.
- Read `_shared` for parent Shared governance navigation and `_system.scripts` for root PowerShell implementation details.

## Conflicts and Supersession
- Supersedes older memory wording that framed team collaboration as captain-led governance plus optional helper branches.

## 中文摘要
- Team-Native Core 是團隊化的核心，不是可選子代理功能。
- 授權現在必須解析成範圍式欄位；工作流與平台模式只提供路由或背景，不是授權本身。
- 任務板、隊員交付件、完成閘門與任務軌跡現在使用同一組授權欄位，缺欄位就不能宣稱完成。
- 每個正式站點都要先分派專家技能，再記錄平台能力路由與軌跡證據。
- conditional 能力缺證時只能標示未驗證、阻塞或 `closed-with-director-risk`；這不是完整完成。
- 隊長不得吸收主要實作、審查、驗證或記憶歸因內容；子代理不可用也不能取消站點或改稱完整完成。
- 任務軌跡是任務證據，不直接寫入來源記憶。

## Tracked Files
- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md
- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/delegation-strategy/SKILL.md
- Shared/skills/team-completion-gate/SKILL.md
- Shared/skills/team-specialist-registry/SKILL.md
- Shared/skills/team-specialist-intent-requirements/SKILL.md
- Shared/skills/team-specialist-scope-impact/SKILL.md
- Shared/skills/team-specialist-architecture-contract/SKILL.md
- Shared/skills/team-specialist-change-delivery/SKILL.md
- Shared/skills/team-specialist-memory-docs/SKILL.md
- Shared/skills/team-specialist-validation/SKILL.md
- Shared/skills/team-specialist-review/SKILL.md
- Shared/skills/team-specialist-security-reliability/SKILL.md
- Shared/skills/team-specialist-release-completion/SKILL.md
- Shared/skills/team-specialist-external-research/SKILL.md

## Relations
- _shared (parent Shared governance memory); _shared.ops-skills.skill-governance (skill factory and non-core skill governance); _system.scripts (Doctor and deployment script implementation)
