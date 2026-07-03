---
name: _shared.team-native-core
scopePath: Shared/
description: >-
  專案記憶：Team-Native Core shared governance, station routing, trace evidence, and
  team completion contracts.
last_updated: '2026-07-03T21:00:45+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-07-03T20:57:12+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-28-001
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
# _shared.team-native-core — Team-Native Core Governance Memory
## Current Truth
- Workflow orchestration is now the shared sequence layer between workflow routing and Team-Native station execution; Team-Native Core remains the hard gate.
- Route and state are separated: blocked, unverified, standby, not-authorized, and `closed-with-director-risk` are station or evidence states, not fallback execution routes.
- Captain-Lite Reading Model separates micro-read probes from evidence: broad captain reads need specialist deep-read evidence or a recorded direct exception before completion claims.
- Captain deep-read, repository-wide search, recursive inventory, implementation, review, validation, and memory/docs substitution are hard exception paths; the captain normally uses coordination read only for board, blocker, conflict, authorization scope, and delivery receipt.
- Protected mutations, captain authorization interpretation, and formal delegation promotion require authorization-resolved scope, target, phase, expiry, and matching protected gate; a formal-write board or evidence branch cannot decide protected authorization by itself.
- Source/deployed parity is part of the Team-Native trace contract for shared governance and skill files; sync direction and sync evidence must be recorded when both copies exist.
- Governed user requests automatically activate Team-Native / Team mode for governance, workflow, fix, build, debug, test, audit, skill, memory/docs, commit, handoff, source, public-contract, equivalent evidence-bearing work, or team/subagent/delegation dispatch.
- Without a current governed user request, AI must not self-start Team mode or team work from prior context, workflow names, source impact, platform tools, prompts, or approvals alone; pure conversation, small stable Q&A, and no-impact work can stay direct under ordinary lifecycle.
- In active Team mode, the mainline/main agent automatically serves as captain and must stay within captain authority: communication, authorization resolution, board ownership, dispatch, supervision, delivery receipt, state synthesis, blockers/protected gates, and reporting.
- Authorization Resolution is a shared pre-write gate: GO, interface approvals, platform prompts, modes, and workflow names resolve into scoped fields used by boards, traces, artifacts, and completion gates.
- Full work uses operation mode `full`; `daily` is reduced routine evidence only and cannot cover implementation, bottom-layer refactor, cross-file governance, Doctor/Audit changes, release/deploy preparation, or public-contract impact.
- Specialist roles come from `team-specialist-registry` plus ten child skills; child skills carry role IDs, parent/support skill relations, artifact contracts, and shared trace/handoff references.
- Full team completion requires implementation change delivery, memory/docs delivery, independent review delivery, validation delivery, completion evidence, and required Team-Native trace evidence.
- The captain owns delivery receipt, board/status synthesis, blocker and authorization handling, protected gates, and Director-facing reporting; unavailable specialist routes remain blocked, unverified, or `closed-with-director-risk` and do not become routine direct work.
- Evidence-bearing 00 chat is Team-Native formal-readonly work with bounded specialist evidence, citations, missing-scope reporting, evidence status, and captain coordination read limited to receipt, board, blocker, or authorization needs.
- Natural-language Director instructions are valid only after the current action, target, visible context, authorization phase, and expiry are bound; everyday words such as GO or follow-up prompts do not authorize hidden file sets, protected state, or unrelated stations.
- Hook-blocked actions must stop as blocked, unverified, or `closed-with-director-risk`; retrying with another tool, changing channels, or using transcript text as current authorization is a governance violation.
- Tool execution envelopes and execution receipts are carriers and return records, not authorization sources; write-capable or protected mutation traces require trusted issuer, signature, nonce, matching scope-bound authorization, the same envelope id or nonce across envelope and receipt, allowed receipt decision, matching action/target/scope, and fail-closed handling for malformed or unverifiable payloads.
- Team-Native topology now separates Captain Team Board, station family, formal station, substation task, specialist assignment, execution channel, and delivery artifact; multi-specialist defaults do not depend on native subagent availability.
- Main-worktree implementation defaults to named station-owned `change-delivery` stations with `implementation-change-delivery`, exact file scope, dirty-diff evidence, and no protected actions; `change-application` is fallback for returned artifacts, explicit integration, or generated/deployed sync.
- `03-1` experiment and sandbox prototype requests are governed workflow requests that automatically activate Team mode; they use reduced/minimal experiment station/board with sandbox scope, discard/promotion conditions, allowed shortcuts, and no production completion claim; promotion or source write still requires scope-bound authorization, formal-write, station-owned `change-delivery`, validation, review, and memory/docs.
- Specialist channel lifecycle now requires pause-and-report status probes: wait timeouts are not failures, probed members must pause and report, explicit captain resume is required before continuation, replacement does not cancel the original channel, late results need receipt decisions, and unresolved channel states block `complete`.
- The captain thin-context rule limits captain work to Director communication, board ownership, dispatch, supervision, delivery receipt, board/status updates, blocker or authorization handling, protected gates, and reporting.
- Captain substitute authoring, broad deep-read replacement, self-review, self-validation, or memory attribution replacement can only close as blocked, unverified, or `closed-with-director-risk`; it cannot support `complete`.
- Station reduction is valid only at substation-task or specialist-count level with replacement evidence and residual risk; convenience, speed, cost, or small-task reasoning is not a valid downgrade for governance, workflow, hook, validation, memory, or release surfaces.
- Platform, workflow, subagent, completion, specialist, and task-board governance cite shared language and grounding policies: Director-facing output must be meaning-first Traditional Chinese, and freshness-sensitive or external claims need grounded source evidence before completion.
## Active Constraints
- Do not describe missing platform capability as routine direct work, claim `complete` without separated delivery/review/validation/memory/trace evidence, copy raw traces into source memory, use platform core language mandates as the sole language authority, let captain deep-read replace specialist delivery, or treat evidence branches as protected-action authority.
- Keep platform-specific tool names in adapter sections or platform-specific files.
## Cycle Events
- 46: Recorded dual-gate integration across workflow orchestration, workflow evidence, platform capability, and completion semantics: Director output uses language-governance, and external or freshness-sensitive claims use grounding-governance.
- 45: Corrected shared Team mode truth: governed user requests auto-activate Team mode, mainline serves as captain, `03-1` uses reduced experiment boards, and absent current governed requests cannot self-start team work.
- 38-44: Consolidated task-board field display, active-card compaction, role-boundary hardening, captain coordination wording, station-owned change delivery, authorization-scoped promotion, and channel lifecycle evidence.
- 37: Recorded validation repair for second-wave slimming: subagent policy now states review-state boundary, and Audit accepts thin workflow/core entries through shared source-of-truth checks.
- 36: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 31-35: Consolidated language-governance grounding, governed-request Team routing, final cleanup, topology/reduction rules, scope-bound authorization, hook stop states, route/state separation, and envelope/receipt carrier semantics.
- 30: Clarified protected mutation matching so trusted envelope evidence and trusted receipt evidence must share envelope identity or nonce and match action, target, scope, decision, and authorization before any protected operation can proceed.
- 25-29: Added workflow scenarios, Captain-Lite Reading Model, protected mutation authorization, route/state separation, source/deployed sync evidence, natural-language authorization binding, hook stop-state rules, trusted tool envelope/receipt rules, and post-block bypass hard-block requirements.
## Archive Index
- archive-001.md / archive-002.md — Older cycle events 1-19 compacted from the active card.
## Evidence Base
- source/tool/director: Shared Team-Native policies, platform/workflow matrices, task-board references, specialist registry, ten specialist skills, Audit module, commit preflight compaction evidence, and 2026-06-30 GO compaction authorization.
## Read Contract
- Read this card when touching Team-Native Core policy, subagent policy, task board, platform/workflow matrix, specialist skills, or Doctor team governance checks; read `_shared` for parent navigation and `_system.scripts` for root PowerShell implementation details.
## Conflicts and Supersession
- Supersedes older memory wording that framed team collaboration as optional helper branches.
## 中文摘要
- 受治理使用者請求會自動啟動 Team-Native / Team mode；沒有目前受治理使用者請求時 AI 不能自行啟動；啟動後主線自動擔任隊長但只做隊長職權內工作。
- `03-1` experiment/sandbox prototype 也是受治理 workflow，會自動進 Team mode 並使用 reduced/minimal experiment board；sandbox writes 不等於 production completion。
- 隊員交付件是內部證據，隊長對總監輸出前必須轉成繁中摘要；通道探針需暫停回報並等待隊長恢復，晚回交付件需接收決策。
## Tracked Files
- Shared/policies/authorization-resolution.md
- Shared/policies/team-native-core.md
- Shared/policies/team-trace-evidence.md
- Shared/policies/subagent-invocation.md
- Shared/policies/workflow-orchestration.md
- Shared/policies/workflow-orchestration-scenarios.md
- Shared/platform-capability-matrix.md
- Shared/workflow-capability-evidence-matrix.md
- Shared/skills/programming-team-governance/SKILL.md
- Shared/skills/team-task-board/SKILL.md
- Shared/skills/team-task-board/references/board-field-catalog.md
- Shared/skills/team-task-board/references/board-templates-and-delivery.md
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
- _shared (parent Shared governance); _shared.ops-skills.skill-governance (skill governance); _system.scripts (Doctor/deploy scripts)
