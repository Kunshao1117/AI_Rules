---
name: _system.scripts
scopePath: Scripts/
description: >-
  專案記憶：根層 PowerShell 部署、巡檢、技能同步與平台同步腳本。Use when: task touches this split memory
  scope or its tracked files.
last_updated: '2026-06-30T16:00:06+08:00'
status: stable
staleness: 0
memory_schema_version: 2
memory_quality_version: 1
memory_kind: governance_rule
verification_status: verified
last_verified: '2026-06-30T03:21:47+08:00'
valid_scope: current-project
content_language: en
human_language: zh-TW
cycle_id: 2026-06-15-001
cycle_event_count: 11
cycle_event_limit: 30
size_limit_bytes: 16384
line_limit: 120
archive_policy: volume
compaction_status: active
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _system.scripts — Repository Script Governance Memory
## Current Truth
- Audit and Skills-Sync now include workflow-orchestration and workflow-orchestration-scenarios as shared governance references, checking workflow-entry coverage, scenario templates, source/deployed drift, Team-Native semantics, and mixed completion/non-completion wording.
- Doctor/Audit now checks Codex project-level hook governance, including hook config/script source-deployed parity, encoded command decoding, transcript-capable fixture runner support, fixture entrypoint presence, tracked-fixture coverage, Captain-Lite read coverage, current/historical evidence separation, tool behavior classification, exact scoped write target matching, protected mutation authorization, and completion artifact requirements.
- This child card owns root PowerShell deployment, audit, memory migration, skill sync, and platform sync scripts.
- Doctor/Audit now enforces Team-Native core ordering, scoped authorization fields, role identity, loaded skill refs, handoff packets, full-only trace mode, strict trace parameters, delivery artifact IDs, multi-direct exceptions, and captain-authoring safety.
- Governance Doctor rejects no-write/read-only work being treated as no-team, missing formal-readonly routing, unreported not-started specialist channels, missing standby state, and captain large-file deep-read substitution.
- Governance sync and Doctor include authorization-resolution policy, source/deployed drift checks, exact SHA256 comparison for deploy-copy paths, and forbidden authorization semantic scans.
- Governance Doctor covers draft/formal board lifecycle, dispatch waves, formal evidence eligibility, specialist lifecycle fields, closeout lanes, Yellow classification/resolution, repair loop counts, and deployed-copy drift closure.
- The platform governance audit entrypoint explicitly passes strict trace parameters; public PowerShell entrypoints must preserve UTF-8 compatibility for Windows PowerShell 5.1.
- Project rule sync and platform deploy scripts copy restricted project-local tools and shared governance references into downstream `.agents/` locations.
## Active Constraints
- Do not mutate external repositories or deployment targets without explicit Director approval.
- Keep script behavior aligned with protected memory and project-skill directories.
- Do not use this card as a substitute for reading the current script implementation before edits.
## Cycle Events
- 41: Added Doctor/Audit required-fixture coverage for the 11 Stop hook live-message, mixed-completion, read-only report, Chinese state, and no-artifact regression cases so future deletion is caught before commit.
- 40: Hardened Doctor/Audit Codex hook stability checks for transcript fixture support, source/deployed parity, required fixture coverage, tracked fixture governance, exact write target matching, same-record protected authorization, partial protected-action authorization, and completion overclaim checks; final Doctor returned Red 0 / Yellow 0.
- 39: Added Codex hook governance checks and fixture coverage to Doctor/Audit for Team-Native hook usability.
- 38: Wave 6C added Doctor/Audit and Skills-Sync coverage for workflow orchestration scenarios, task-board templates, deployed scenario reference drift, and mixed completion-state wording.
- 37: Wave 6B follow-up added Doctor coverage for source/deployed workflow entry drift across Codex, Claude, and Antigravity after independent review found a deployment false negative.
- 36: Wave 6B updated Audit and Skills-Sync checks for workflow-orchestration coverage; Doctor and Check passed after sync.
- 35: Wave 6A extended Audit checks for workflow operation mode, daily/full boundaries, direct/formal-readonly/formal-write routing, role split, board trigger, and specialist lifecycle coverage; Doctor and Deploy Audit governance checks passed.
- 34: Compacted active script memory after commit preflight reported the active card line limit.
- 33: Hardened Doctor/Audit strict trace checks for core-rule order, role identity, loaded skill refs, handoff packets, full-only trace mode, completion-state whitelist, delivery artifact IDs, multi-direct exceptions, and captain-authoring semantics.
- 32: Added Doctor/Audit checks for Team-Native operation mode, ten role IDs, specialist relation metadata, trace/handoff references, and role-identity trace fields; source Doctor and Deploy Audit returned red 0 with deployment-drift yellows only.
- 31: Added Doctor checks for 00 evidence-bearing chat formal-readonly routing, ambiguous-positive governance wording, channel monitoring fields, and standby-not-complete trace compatibility.
## Archive Index
- archive-002.md — Script governance events 23-30 compacted on 2026-06-30.
- archive-001.md — Older script cycle events 09-21 compacted from the active card.
## Evidence Base
- source: Scripts/modules/Audit.psm1 and related root PowerShell scripts.
- tool: commit preflight identified active-card compaction due on 2026-06-30.
- director: 2026-06-30 GO authorized compaction of the four blocking memory cards.
## Read Contract
- Read this card when changing root PowerShell scripts.
- Read `_system` for repository-level governance and release context before high-risk script changes.
## Conflicts and Supersession
- No unresolved conflict recorded during this split; newly found contradictions must be indexed here.
## 中文摘要
- 此子卡負責根層 PowerShell 腳本。
- Doctor 會檢查任務板、交付件、完成閘門、任務軌跡、授權解析與 Team-Native 硬閘門。
- Doctor 與同步工具會檢查源頭與部署副本漂移、授權欄位、禁止授權誤讀語句與 formal-readonly 邊界。
- 腳本修改前仍必須讀取實際來源。
## Tracked Files
- Scripts/Deploy.ps1
- Scripts/modules/Core.psm1
- Scripts/modules/Audit.psm1
- Scripts/modules/Memory-Migration.psm1
- Scripts/modules/Skills-Sync.psm1
- Scripts/modules/Platform-Antigravity.psm1
- Scripts/modules/Platform-Claude.psm1
- Scripts/modules/Platform-Codex.psm1
## Relations
- _system (parent card: repository governance)
- _shared (shared governance source)
- _system.scripts.codex-hooks (child card: Codex hook fixture tests)
- _vscode_extension.release (related manager entrypoint ownership)
