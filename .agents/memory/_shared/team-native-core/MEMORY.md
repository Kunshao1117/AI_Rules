---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-01T22:55:44+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-01T22:54:48+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
cycle_event_count: 15
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
- Workflow orchestration is now the shared sequence layer between workflow routing and Team-Native station execution; Team-Native Core remains the hard gate.
- Route and state are separated: blocked, unverified, standby, not-authorized, and `closed-with-director-risk` are station or evidence states, not fallback execution routes.
- Captain-Lite Reading Model separates micro-read probes from evidence: broad captain reads need specialist deep-read evidence or a recorded direct exception before completion claims.
- Captain deep-read substitution is a hard exception path: the captain may integrate returned artifacts and verify-read bounded scope, but broad reading or specialist replacement requires recorded exception evidence.
- Protected mutations now require explicit protected authorization evidence for current phase, target, scope, and closure state; a general formal-write board is not enough.
- Source/deployed parity is part of the Team-Native trace contract for shared governance and skill files; sync direction and sync evidence must be recorded when both copies exist.
- Team-Native Core is a default-on execution precondition for applicable work: the next valid runtime state is a Captain Team Board with applicable stations, handoff packets, channel states, and formal-readonly/formal-write mode before broad reading or protected work.
- Authorization Resolution is a shared pre-write gate: GO, interface approvals, platform prompts, modes, and workflow names resolve into scoped fields used by boards, traces, artifacts, and completion gates.
- Full work uses operation mode `full`; `daily` is reduced routine evidence only and cannot cover implementation, bottom-layer refactor, cross-file governance, Doctor/Audit changes, release/deploy preparation, or public-contract impact.
- Specialist roles come from `team-specialist-registry` plus ten child skills; child skills carry role IDs, parent/support skill relations, artifact contracts, and shared trace/handoff references.
- Full team completion requires implementation change delivery, memory/docs delivery, independent review delivery, validation delivery, completion evidence, and required Team-Native trace evidence.
- The captain owns protected integration and final acceptance, but unavailable specialist routes remain blocked, unverified, or `closed-with-director-risk`; they do not become routine direct work.
- Evidence-bearing 00 chat is Team-Native formal-readonly work with bounded specialist evidence, citations, missing-scope reporting, evidence status, and captain verify-read.
- Natural-language Director instructions are valid only after the current action, target, visible context, authorization phase, and expiry are bound; everyday words such as GO or follow-up prompts do not authorize hidden file sets, protected state, or unrelated stations.
- Hook-blocked actions must stop as blocked, unverified, or `closed-with-director-risk`; retrying with another tool, changing channels, or using transcript text as current authorization is a governance violation.
- Tool execution envelopes and execution receipts are carriers and return records, not authorization sources; write-capable or protected mutation traces require trusted issuer, signature, nonce, matching scope-bound authorization, the same envelope id or nonce across envelope and receipt, allowed receipt decision, matching action/target/scope, and fail-closed handling for malformed or unverifiable payloads.
- Route fields name actual execution channels or delivery forms; blocked, unverified, standby, not-authorized, unavailable, and `closed-with-director-risk` belong in state fields and cannot act as fallback routes.
- Team-Native topology now separates Captain Team Board, station family, formal station, substation task, specialist assignment, execution channel, and delivery artifact; multi-specialist defaults do not depend on native subagent availability.
- The captain thin-context rule limits captain work to Director communication, board ownership, dispatch, supervision, format checks, bounded verify-read, protected adoption or merge of qualified artifacts, protected gates, and reporting.
- Captain substitute authoring, broad deep-read replacement, self-review, self-validation, or memory attribution replacement can only close as blocked, unverified, or `closed-with-director-risk`; it cannot support `complete`.
- Station reduction is valid only at substation-task or specialist-count level with replacement evidence and residual risk; convenience, speed, cost, or small-task reasoning is not a valid downgrade for governance, workflow, hook, validation, memory, or release surfaces.
- Platform and workflow matrices now cite the shared language governance policy for language and audience-layer classification while platform core files keep only bootstrap and Director-facing mandates.
## Active Constraints
- Do not describe missing platform capability as routine direct work.
- Do not claim `complete` without separated delivery artifact classes, independent review, validation, memory/docs disposition, and trace evidence.
- Keep platform-specific tool names in adapter sections or platform-specific files.
- Do not copy raw task traces into source memory; keep only stable governance facts.
- Do not use platform core language mandates as the sole authority for Team-Native handoffs, workflow output, memory language, or change-description wording.
## Cycle Events
- 37: Recorded validation repair for second-wave slimming: subagent policy now states review-state boundary, and Audit accepts thin workflow/core entries through shared source-of-truth checks.
- 36: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 35: Recorded matrix language-governance grounding so workflow and platform entries cite the shared policy instead of platform-core-only language rules.
- 34: Recorded non-hook Team-Native core hardening so applicable work is default-on team mode, station assignment precedes channel selection, and no-write work still requires formal team evidence.
- 33: Recorded final Team-Native cleanup for remaining Doctor red-light fixes, cross-platform core-rule sync, and commit-preflight stale blocker cleanup.
- 32: Added thin-captain, team-topology, multi-specialist default, and hard reduction rules to shared Team-Native policies and matrices; captain substitute authoring remains non-complete.
- 31: Updated shared Team-Native memory after hook and workflow hardening: natural-language authorization must bind to the visible scope, hook blocks are stop states instead of retry prompts, route fields cannot carry blocked states, and tool envelope/receipt records remain carriers rather than authorization sources.
- 30: Clarified protected mutation matching so trusted envelope evidence and trusted receipt evidence must share envelope identity or nonce and match action, target, scope, decision, and authorization before any protected operation can proceed.
- 29: Added trusted tool execution envelope and receipt rules, invalid-payload fail-closed semantics, route/state separation, current scoped Director risk-close evidence, and post-block bypass hard-block requirements to shared Team-Native policies and trace evidence.
- 28: Added natural-language authorization binding and post-hook-block stop-state rules to shared authorization, Team-Native Core, trace evidence, Codex hooks, fixture runner coverage, and Doctor checks.
- 27: Hardened route/state separation, captain deep-read limits, source/deployed sync evidence, and task-board templates so blocked or unverified states cannot act as fallback routes.
- 26: Added Captain-Lite Reading Model and protected mutation authorization semantics to Team-Native Core policy.
- 25: Wave 6C added non-authorizing workflow scenario playbooks, task-board reusable templates, and explicit separation between full completion and non-complete states.
- 24: Wave 6B added Shared/policies/workflow-orchestration.md, wired it into shared policies, workflow entries, deployed copies, and Doctor/Audit checks.
- 23: Compacted active Team-Native governance memory after commit preflight reported the active card line limit.
## Archive Index
- archive-001.md / archive-002.md — Older cycle events 1-19 compacted from the active card.
## Evidence Base
- source: Shared Team-Native policies, platform matrix, workflow matrix, specialist registry, ten specialist skills, and Audit module.
- tool: commit preflight identified active-card compaction due on 2026-06-30.
- director: 2026-06-30 GO authorized compaction of the four blocking memory cards.
## Read Contract
- Read this card when touching Team-Native Core policy, subagent policy, task board, platform/workflow matrix, specialist skills, or Doctor team governance checks; read `_shared` for parent navigation and `_system.scripts` for root PowerShell implementation details.
## Conflicts and Supersession
- Supersedes older memory wording that framed team collaboration as optional helper branches.
## 中文摘要
- Team-Native Core 是團隊化核心，不是可選子代理功能。
- 授權必須解析成範圍式欄位；工作流與平台模式只提供路由或背景。
- daily/full 模式是任務板最上層決策；正式站點要記錄角色身份與平台能力路由。
- 子代理不可用時只能標示未驗證、阻塞或 `closed-with-director-risk`，不是完整完成。
## Tracked Files
- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md
- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/team-station-handoff-packet/SKILL.md
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
