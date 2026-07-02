---
name: _codex_core
scopePath: Codex/
description: >-
  專案記憶：Codex 平台核心來源與治理規則。Use when: task touches this card tracked files or
  governed scope.
last_updated: '2026-07-02T15:02:34+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: source_fact
verification_status: verified
last_verified: '2026-07-02T15:00:23+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
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
# _codex_core — Codex Edition Memory
## Current Truth
- Codex Edition is the OpenAI Codex adapter for the AI_Rules governance framework, using `.codex/AGENTS.md` for project governance and `.agents/skills/` for live skills.
- Codex source workflow skills are sourced from `Codex/.agents/workflow-skills/` and merged into `.agents/skills/`.
- Codex source and deployed rules put Team-Native Core and Authorization Resolution before lifecycle, workflow names, GO text, sandbox prompts, and tool approvals.
- Applicable Codex coding, workflow, validation, review, memory, commit, release, or governance-impact work defaults to captain-led Team-Native mode with boards, role-exclusive stations, handoff packets, channel state, captain delivery receipt, authorized change-application gates, and separated delivery artifacts before full completion.
- Evidence-bearing chat, broad reads, validation, review, memory/docs attribution, commit/release preparation, and completion audit route through formal-readonly or formal-write; pure chat and tiny orientation stay direct only while non-mutating.
- Codex project-level hooks provide Team-Native guardrails for micro-read allowance, broad-read Captain-Lite hints, scoped write target matching, protected mutation authorization, and completion-claim artifact checks.
- Hooks Stability guards separate current payload evidence from historical transcript text, require same-record protected authorization, require every detected protected action to have complete authorization, avoid release/deploy false positives from filenames, enforce exact normalized write-target matching, and gate completion claims on delivery artifacts or explicit non-complete state.
- Codex write-capable and protected hook authorization now requires current structured Team-Native payload fields; historical transcript text and text-only trace blobs are diagnostic only and cannot authorize writes.
- Codex hook completion checks include Unicode-built Chinese completion patterns so Windows PowerShell encoding does not corrupt Chinese fixture behavior.
- Codex hook reference-line detection keeps English reference markers in ASCII regex and builds Chinese reference markers through `New-UnicodeString` codepoints instead of direct Chinese regex literals.
- Stop hook completion checks inspect Codex live `last_assistant_message`, block short generic or mixed completion claims, keep the completion gate active during Stop-hook continuations, and allow explicit blocked/unverified/closed-with-director-risk or read-only search report states.
- Codex hook blocks return diagnostic guidance with action context, missing evidence categories, allowed and forbidden next steps, natural-language binding context, post-block retry denial, and read-only `Deploy.ps1` false-positive protection.
- Codex source hook config now uses `Codex/.codex/hooks.delete` as the renamed-hook marker; while that marker is active, `.codex/hooks.json` should stay absent and restoring it is hook config drift.
- Codex protected write and protected mutation hooks now require scoped protected authorization plus a trusted tool execution envelope and matching trusted execution receipt with the same envelope id or nonce, allowed decision, matching action/target/scope, trusted issuer/source, verified or signed signature state, and fresh nonce; model-filled, assistant-authored, transcript, user-supplied, self-reported, missing-issuer, unsigned, stale, replayed, only-envelope, only-receipt, or mismatched receipt evidence fails closed.
- Codex hook invalid-payload handling returns the same governance diagnostic block shape as other hard gates, so agents should treat malformed tool payloads as designed policy enforcement rather than tool failure.
- Codex documentation and core rules use `closed-with-director-risk` for Director-closed non-complete cases and must not present missing specialist delivery as full team completion.
- Codex workflow entries load shared workflow orchestration, platform matrices, specialist role skills, team task-board templates, change delivery artifacts, and MCP memory evidence contracts before relying on evidence.
- Director-facing Codex output must stay Traditional Chinese and follow the Director-readable output contract.
- The captain owns Director-facing accountability, delivery receipt, board/status synthesis, blocker and authorization handling, protected memory/git/release gates, final review-state decisions, and final reporting; implementation, review, validation, and memory/docs facts must come from separated delivery artifacts unless explicitly closed as blocked, unverified, or `closed-with-director-risk`.
- Codex entry governance now summarizes thin-captain limits, no captain substitute authoring, the Team-Native object topology, multi-specialist separation from native subagents, and hard station-reduction rules.
- Codex completion-claim hooks require structured delivery artifact evidence for implementation, memory/docs, review, and validation; text-only artifact naming is blocked.
- Codex core keeps bootstrap and Director-facing Traditional Chinese mandates, while complete language-layer classification and exact-evidence rules come from the shared language governance policy.
## Active Constraints
- Keep Codex framework versioning separate from VS Code extension versioning.
- Keep root README ownership in `_system`, not this card.
- Keep live `.agents/skills/` sync checks separate from Codex source workflow checks.
- Codex workflow entries must cite the deployed shared language policy before applying workflow-specific output, handoff, memory-language, or change-description rules.
## Cycle Events
- 51: Recorded the Codex `hooks.delete` renamed-hook marker and project `.codex/hooks.json` absence contract after Audit and fixture runner support landed.
- 50: Recorded Codex coordination-boundary hardening: hooks and docs now use `captain_coordination_read_scope`, captain receipt/status synthesis, and authorized change-application gates instead of captain integration evidence.
- 49: Compacted active Codex core memory after commit preflight reported the active-card line limit, without changing current governance facts.
- 48: Removed direct Chinese regex literals from Codex hook reference-line detection, preserved source/deployed hook parity, and validated 58 hook fixtures across powershell.exe and pwsh.exe plus Doctor.
- 47: Recorded second-wave governance/workflow slimming: workflow entries now stay thin, cite shared policies and workflow-stage procedures, and preserve source/deployed parity.
- 46: Recorded Codex language-governance grounding across core rules and selected workflow entries with deployed policy citation.
- 45: Recorded non-hook Codex core hardening that makes Team-Native mode default-on for applicable work and forbids captain substitute authoring from supporting full completion.
- 44: Recorded final Team-Native cleanup for remaining Doctor red-light fixes, cross-platform core-rule sync, and commit-preflight stale blocker cleanup.
- 43: Updated Codex core memory after entry-governance and hook hardening: thin-captain rules, Team-Native object topology, multi-specialist/subagent separation, structured completion evidence, and clearer hook diagnostics are now current.
- 42: Updated Codex core memory after Team-Native authorization binding hardening: captain wording now means protected integration of recovered artifacts, hooks require current structured evidence plus trusted envelope/receipt records for protected mutations, and natural-language prompts stay bound to the visible target.
- 41: Tightened Codex protected mutation hooks so trusted envelope and trusted execution receipt evidence must match by identity or nonce and by action, target, scope, decision, and authorization before protected operations can proceed.
- 39: Added Codex hook diagnostic block reasons, natural-language prompt binding, post-block retry denial, Deploy.ps1 read-only false-positive coverage, fixture diagnostic-label assertions, and Doctor green validation.
- 38: Hardened Codex Team-Native hook authorization around structured current payload fields, transcript distrust, role/channel evidence, protected writes, and Windows-safe Chinese completion detection; source/deployed hook parity was preserved.
- 37: Stop hook repair added Codex live last-assistant-message coverage, short generic and mixed completion-claim blocking, active Stop continuation blocking, negated incomplete/read-only report exceptions, Chinese-key non-complete state handling, explicit memory/docs wording in the Stop block reason, and 52 passing hook fixtures; source/deployed hook hash parity verified.
- 36: Hooks Stability Implementation accepted with source/deployed hook and config hash parity, 41 fixture cases, Doctor Red 0 / Yellow 0, same-record protected authorization, per-action protected authorization coverage, exact write target matching, and a nonblocking deploy.patch dedicated-fixture gap.
## Archive Index
- archive-003.md — Older cycle events 13-22 compacted from the active card.
- archive-001.md — Legacy _codex_core card preserved before schema v2 compaction on 2026-06-04.
- archive-002.md: Pre-standardization active card snapshot created during MEMORY.md migration.
## Evidence Base
- Source evidence: Previous active memory content is preserved in archive-002.md.
- Tool evidence: cartridge-system memory_list and memory_audit identified legacy main files and missing quality metadata before migration.
- Director evidence: 2026-06-15 GO MEMORY MIGRATE authorized active memory-card migration.
## Read Contract
- Read this card when the task touches its tracked files, governed layer, or listed relations.
- Do not use stale or archived claims as current implementation evidence without reading the referenced source files.
## Conflicts and Supersession
- No unresolved conflict recorded during the migration pass; contradictions found later must be indexed here instead of silently overwritten.
## 中文摘要
- Codex 是 OpenAI Codex 平台適配層。
- Codex 的 GO、工具提示與技能名稱現在只會變成有範圍的授權證據，不是無範圍寫入。
- 工作流來源在 Codex 目錄，live 技能在 `.agents/skills/`。
- Codex 編程工作流已改為團隊協作優先，隊長只做接收交付、狀態彙整、阻塞/授權處理與受保護閘門，不替代隊員產出主要交付件。
- Codex 00 證據型對話也會進 formal-readonly；純聊天才維持直接回覆。
- 根層 README 不再由本卡追蹤。
## Tracked Files
- Codex/VERSION
- Codex/README.md
- Codex/install.ps1
- Codex/global/AGENTS.md
- Codex/global/config.toml
- Codex/.codex/AGENTS.md
- Codex/.codex/config.toml
- Codex/.codex/hooks.delete
- Codex/.codex/hooks/team-native-gate.ps1
- .codex/hooks/team-native-gate.ps1
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
