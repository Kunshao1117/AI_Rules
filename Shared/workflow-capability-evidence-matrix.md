# 三平台工作流能力與證據矩陣（Three-Platform Workflow Capability And Evidence Matrix）

本文件是 00-12 工作流共用的外部接地與證據期待矩陣，不取代各工作流本體。
各工作流引用本矩陣後，仍需套用自身的 task boundary、platform capability 與 evidence state。
08 Audit 的深度、盤點分母與覆蓋率規則仍由 shared audit engine 擁有。

工作流編排順序由 `Shared/policies/workflow-orchestration.md` 管理。
本矩陣只擁有各工作流的證據期待；共享 route chain 由 orchestration policy 擁有。
本矩陣只用該鏈路對齊各 workflow row 的最低證據。
具體合作範例放在 `Shared/policies/workflow-orchestration-scenarios.md`；
那些範例是不授權的 playbooks，不能取代本矩陣或 orchestration contract。

語言與 audience-layer 分類由 `Shared/policies/language-governance.md` 管理。
該政策涵蓋 workflow output、handoff text、memory language、skill trigger language 與 change descriptions。
工作流列應引用該政策，而不是只使用平台 core rules。

外部接地由 `Shared/policies/grounding-governance.md` 管理。
該政策涵蓋 outside facts、source type、freshness sensitivity 與 no-evidence claim boundaries。
本矩陣只記錄精簡 gate profiles 與 workflow evidence expectations。
AI prior 只能作為假設起點。
Grounding tier 使用 `G0` local-grounded、`G1` stable assumption、`G2` quick-check、`G3` formal external research、`G4` unverified/blocked。
本矩陣只要求 route-level tier classification；詳細 field contract 留在 `workflow-execution-spec-contract.md`。

## Reference Index

Long governance rules live in small references or their canonical policies.
This matrix keeps only route-level evidence expectations and the 00-12 workflow rows.

- Team-Native, board, delivery, closeout evidence:
  - `Shared/policies/references/workflow-team-evidence.md`
- Change intent, intent alignment, review lifecycle, visual evidence:
  - `Shared/policies/references/workflow-review-visual-evidence.md`
- Memory admission and MCP memory evidence:
  - `Shared/policies/references/workflow-memory-evidence.md`
- Route order, dispatch waves, invalid orchestration patterns:
  - `Shared/policies/workflow-orchestration.md`
  - `Shared/policies/references/workflow-orchestration-boundaries.md`

## Evidence Status

Status meanings live in `Shared/policies/references/status-ontology.md`.
Closeout targets and completion states live in
`Shared/policies/references/completion-state-machine.md`.
This matrix only names the minimum evidence expected per workflow route.

## Gate Profile References

Gate details stay in their owning policies.
Workflow rows below only name the minimum evidence expected for each route.

- Director-facing output: `Shared/policies/language-governance.md`.
- External grounding: `Shared/policies/grounding-governance.md`.
- Grounding execution fields and closeout bundle shape:
  `Shared/policies/references/workflow-execution-spec-contract.md`.
- Intent envelope, overreach checks, and design reflection execution fields:
  `Shared/policies/workflow-orchestration.md`,
  `Shared/policies/references/workflow-execution-spec-contract.md`, and
  `Shared/skills/design-reflection-gate/SKILL.md`.
- Formal orchestration and completion: `Shared/policies/workflow-orchestration.md`
  plus `team-completion-gate`.
- Platform capability translation: `Shared/platform-capability-matrix.md`.
  Load condition: workflow orchestration, language governance, and the workflow row are always required for broad evidence or source-impacting work; the platform capability matrix is conditional when platform behavior, tool capability, permission surface, evidence limits, protected phases, source-impacting work, or log-write capability affects the route.

## Team-Native Evidence Reference

Team-Native board, dispatch, delivery, lifecycle, direct-exception, late-result, and closeout details are referenced here.
They are not repeated here.
Use `Shared/policies/references/workflow-team-evidence.md` and the canonical policies it cites.
Workflow rows may mention Team mode as a minimum evidence expectation only.
They do not redefine Team-Native trace or completion rules.

Team-Native Core Evidence remains a thin route anchor.
It records these route tokens without redefining the policy:

- Team-Native trace evidence, platform capability route, `conditional`, and `unavailable`.
- Daily/full route chain, `operation_mode`, `board_template`, `board_state`, and `closeout_lane`.
- Station set, `operation_mode_reason`, `role_id`, `role_instance_id`, and `exclusive_task_scope`.
- No full-team completion claim when required evidence is missing.

## Workflow Matrix

### Workflow Routing Is Not Authorization

Workflows 00-12 own task routing, evidence expectations, and next-workflow suggestions only.
Workflow names, commands, buttons, automation-safe triggers, or consent phrases need authorization resolution.
Only then do they become usable authority.
The authorization source is `Shared/policies/authorization-resolution.md`.
They do not bypass board, role, protected-state, review, validation, memory/docs, git, release, deployment, or install gates.
They also do not bypass external-mutation gates.

## Team Governance Reference

Programming-team board, wave, reduction, delivery form, task-type dispatch, and captain-boundary evidence live in the team reference.
The source is `Shared/policies/references/workflow-team-evidence.md`.
This matrix keeps only the per-workflow row expectations below.
Workflow names remain route hints and do not authorize source writes or protected follow-on phases.

## Review And Visual Evidence Reference

Change intent, intent alignment, review lifecycle, and visual-evidence rules live in the review and visual evidence reference.
The source is `Shared/policies/references/workflow-review-visual-evidence.md`.
Workflow rows below cite those rules by task type and keep only their minimum evidence expectations here.

## Workflow Evidence Rows

### 中文路由橋接（Workflow Route Trigger Bridge）

| 工作流 | 中文任務語意 | 常見觸發 / route trigger | 常見下一路由（Common route） |
|---|---|---|---|
| `00 Chat` | 聊天、概念釐清、小型穩定問答 | 純對話、輕量 Q&A、無外部證據依賴 | `01` 探索、`02` 架構、`03` 建構、`04` 修復、`06` 測試、`09` 紀錄 |
| `01 Explore` | 探索、研究、可行性與反方分析 | 網路研究、競品分析、source freshness 問題 | `02` 架構、`03` 建構、`08` 健檢 |
| `02 Blueprint` | 架構、系統藍圖、技術決策 | 架構設計、重大技術方向、build handoff | `03` 建構、`08` 健檢、`12` 技能鍛造 |
| `03-1 Experiment` | 實驗、沙盒 spike、可丟棄原型 | 快速試作、sandbox prototype | `03` 建構、`11` 交接 |
| `03 Build` | 正式建構、產品行為變更 | implementation、feature build、正式 source change | `04` 修復、`06` 測試、`08` 健檢、`09` 紀錄 |
| `04 Fix` | 修復、bug fix、回歸修補 | defect、regression repair、root-cause repair | `06` 測試、`07` 除錯、`09` 紀錄 |
| `05 Condense` | 濃縮、專案身份與長期記憶初始化 | memory/context condensation、project identity | `02` 架構、`11` 交接、`12` 技能鍛造 |
| `06 Test` | 測試、E2E、視覺、效能、無障礙與回歸驗證 | validation、browser/e2e/performance/a11y evidence | `03` 建構、`04` 修復、`08` 健檢 |
| `07 Debug` | 除錯、log/stack trace 定位 | fault localization、observable signal、hypothesis | `04` 修復、`06` 測試、`08` 健檢 |
| `08 Audit` | 健檢、深度審查、高風險預檢 | full-spectrum audit、doctor、preflight | `02` 架構、`03` 建構、`04` 修復、`06` 測試、`09` 紀錄 |
| `09 Commit` | 紀錄、變更摘要、提交/發布前檢查 | changelog、commit prep、version/pre-release scan | `04` 修復、`06` 測試、`08` 健檢、`11` 交接 |
| `10 Routine` | 巡檢、自動化安全唯讀治理 | automation-safe check、drift scan、no-write inspection | `08` 健檢、`12` 技能鍛造 |
| `11 Handoff` | 交接、續跑提示、目前狀態整理 | handoff、continuation prompt、dirty state summary | `02` 架構、`03` 建構、`04` 修復、`09` 紀錄 |
| `12 Skill Forge` | 技能鍛造、新增或修復 shared/project skill | skill creation、trigger quality、reference split | `03` 建構、`08` 健檢、`10` 巡檢 |

### 00 Chat / 聊天

- 任務類型（Task type）:
  - Pure discussion, concept clarification, and lightweight Q&A without external evidence dependency.
  - Files, screenshots, memory/context, rules, agent behavior, evidence checks, or governance impact route normally.
  - Use `formal-readonly` when a governed request activates Team mode.
- 接地依據（Grounding basis）:
  - Codex instruction layers, Claude context management, Agent Skills trigger semantics, governed Team formal-readonly.
- 最低證據（Minimum evidence）:
  - Direct answers rely only on current conversation, supplied snippets, or stable general reasoning.
  - Low-risk chat uses a quick intent/design matrix only when needed to prevent overreach or claim inflation.
  - Active Team formal-readonly requires board, read scope, specialist evidence, citations, missing evidence list.
  - It also requires evidence state, captain receipt, and board update.
- 常見路由（Common route）: 01, 02, 03, 04, 06, 09.

### 01 Explore / 探索

- 任務類型（Task type）: Web research, competitive analysis, feasibility, counter-position analysis.
- 接地依據（Grounding basis）: Research source quality, freshness, governed Team formal-readonly.
- 最低證據（Minimum evidence）:
  - Formal-readonly board, specialist handoff, source tier, date, bias, coverage gap, unverified items.
  - Research-to-recommendation handoff records intent envelope, grounding state, and quick/full design reflection when findings can shape architecture, implementation, governance, spend, or release.
  - If no specialist opens, record unavailable channel and direct exception.
- 常見路由（Common route）: 02, 03, 08.

### 02 Blueprint / 架構

- 任務類型（Task type）: Architecture, major technical direction, system blueprint.
- 接地依據（Grounding basis）:
  - ADR, C4, arc42, official framework docs, intent-alignment gate, programming-team governance.
- 最低證據（Minimum evidence）:
  - Formal-readonly board, requirement replay, counter-evidence, decision state, alternatives.
  - Review purpose/state, requirement-to-acceptance trace, assumptions, compatibility, design reflection decision, build handoff contract.
- 常見路由（Common route）: 03, 08, 12.

### 03-1 Experiment / 實驗

- 任務類型（Task type）: Sandbox spike, disposable prototype.
- 接地依據（Grounding basis）:
  - Technical spike practice, prototype isolation, governed experiment request triggers Team mode.
- 最低證據（Minimum evidence）:
  - Reduced/minimal experiment station/board with sandbox scope, allowed changes, discard condition.
  - Escalation condition, allowed shortcuts, and experiment-only disposition.
  - Production promotion needs new authorization, `formal-write`, station-owned `change-delivery`, validation.
  - It also needs review and memory/docs.
- 常見路由（Common route）: 03, 11.

### 03 Build / 建構

- 任務類型（Task type）: Formal build and product behavior change.
- 接地依據（Grounding basis）:
  - Explore -> plan -> implement -> validate, intent-alignment gate, engineering review governance.
  - Programming-team governance.
  - `G0` local evidence by default; `G2` quick-check for narrow current API/package docs;
    `G3` formal external research for architecture, governance, security, deploy, pricing, law,
    standards, release-readiness, or cross-source risk.
- 最低證據（Minimum evidence）:
  - Team board, blueprint carryover, review purpose/state, requirement-to-task trace, task acceptance matrix.
  - Intent envelope, overreach check, applicable design reflection status, drift audit, real validation route, tool discovery, blockers, memory ownership/status evidence.
  - Implementation delivery bundle with `grounding_handoff`, `closeout_bundle`, and expected dirty files when source changed.
- 常見路由（Common route）: 04, 06, 08, 09.

### 04 Fix / 修復

- 任務類型（Task type）: Bug fix and regression repair.
- 接地依據（Grounding basis）:
  - Root-cause analysis, defect management, regression testing, engineering review governance.
  - Programming-team governance.
  - `G0` local reproduction/log/source evidence; `G2` quick-check for narrow current framework/API behavior;
    `G3` formal research for security, deployment, legal, pricing, standards, or conflicting outside facts.
- 最低證據（Minimum evidence）:
  - Team board, symptom, cause, review purpose/state, fix evidence, regression evidence.
  - Design reflection is required when the fix changes public behavior, contracts, workflow/skill semantics, or governance rules.
  - Affected memory-card status and dependency evidence.
  - Repair delivery bundle with grounding handoff, expected dirty files, validation/review/memory-docs handoffs, and closeout bundle index.
- 常見路由（Common route）: 06, 07, 09.

### 05 Condense / 濃縮

- 任務類型（Task type）: Project identity and long-term memory initialization.
- 接地依據（Grounding basis）: Context compression, long-term memory, preference governance.
- 最低證據（Minimum evidence）:
  - Source basis, separation of durable fact from temporary observation, workspace/context inventory evidence.
- 常見路由（Common route）: 02, 11, 12.

### 06 Test / 測試

- 任務類型（Task type）: E2E, visual, performance, accessibility, regression.
- 接地依據（Grounding basis）:
  - Playwright, Lighthouse, Web Vitals, WCAG, programming-team governance.
- 最低證據（Minimum evidence）:
  - Test station board, project type, test surface, evidence level, blocker reason.
  - Validation may consume design reflection as expected-behavior context, but design reflection is not validation evidence.
- 常見路由（Common route）: 03, 04, 08.

### 07 Debug / 除錯

- 任務類型（Task type）: Stack trace, logs, fault localization.
- 接地依據（Grounding basis）:
  - OpenTelemetry, SRE monitoring, root-cause diagnosis, programming-team governance.
  - AI prior only as hypothesis; `G0` for local logs/traces/source/tool output; `G2` or `G3`
    when current docs, advisories, platform rules, or conflicting external evidence can change diagnosis.
- 最低證據（Minimum evidence）:
  - Debug station board, observable signal, hypothesis, confirmation/counter-evidence, route-to-fix condition.
  - Grounding tier and missing evidence state before routing a fix.
- 常見路由（Common route）: 04, 06, 08.

### 08 Audit / 健檢

- 任務類型（Task type）: Full-spectrum audit, deep audit, high-risk preflight.
- 接地依據（Grounding basis）:
  - Shared audit engine as the semantic and logic owner, this matrix, OWASP, Playwright, Lighthouse, Web Vitals, WCAG, OpenTelemetry.
  - `code-audit` is only an optional deterministic scan source when a separate scan artifact exists or a scan phase is explicitly routed.
  - Engineering review governance and programming-team governance.
- 最低證據（Minimum evidence）:
  - Audit board, depth, project type, capability snapshot, feature/endpoint/command inventory, denominator.
  - Artifact chain: `08-1` inventory artifact -> `08-2` logic-review artifact -> `08-3` final report.
  - Evidence artifacts, review state, memory/context governance evidence, lights, unverified/blocker list.
  - Audit log writes require a separate `audit-log-write` stage scoped only to `.agents/logs/`; no-write audit evidence does not authorize log file creation.
- 常見路由（Common route）: 02, 03, 04, 06, 09.

### 09 Commit / 紀錄

- 任務類型（Task type）: Change log, commit, version, pre-release scan.
- 接地依據（Grounding basis）:
  - Conventional Commits, Keep a Changelog, SemVer, status checks, engineering review governance.
  - Programming-team governance.
  - Closeout bundle is an index only; commit readiness re-checks artifact chain, dirty state,
    grounding gaps, sync, validation, review, and memory/docs disposition.
- 最低證據（Minimum evidence）:
  - Commit board, explicit file list, review lifecycle risk, unverified/blocker list, memory status.
  - Memory preflight, change summary, version/artifact decision.
  - Expected dirty-file comparison, unresolved `G4` grounding gaps, and unresolved design reflection blockers reported as blockers or residual risk.
- 常見路由（Common route）: 04, 06, 08, 11.

### 10 Routine / 巡檢

- 任務類型（Task type）: Automation-safe read-only governance.
- 接地依據（Grounding basis）:
  - Automation health check, static read-only workflow drift check, engineering review governance, programming-team governance coverage.
- 最低證據（Minimum evidence）:
  - Routine station coverage, skill quality, doc consistency, matrix coverage, review governance coverage.
  - Read-only drift check for intent envelope, overreach, grounding, and design reflection rules becoming duplicated, unused, or too complex.
  - Read-only memory/context inspection and no-write proof.
  - No package-manager, compiler, linter, audit, or interactive batch execution from the routine route; heavy scans route to `08`, `06`, or another explicit non-routine workflow.
- 常見路由（Common route）: 08, 12.

### 11 Handoff / 交接

- 任務類型（Task type）: Task handoff and continuation prompt.
- 接地依據（Grounding basis）: Context handoff practice, programming-team governance.
- 最低證據（Minimum evidence）:
  - Handoff board, current status, dirty files, blockers, unverified items, workspace/memory health evidence.
  - Next workflow.
- 常見路由（Common route）: 02, 03, 04, 09.

### 12 Skill Forge / 技能鍛造

- 任務類型（Task type）: New skills, shared skills, project skills.
- 接地依據（Grounding basis）:
  - Agent Skills spec, skill descriptions, progressive loading, programming-team governance, skill handoff package.
  - `G2` quick-check for narrow live skill/tool documentation; `G3` formal research for platform
    governance, security, deployment, legal/pricing, external mutation, or cross-source conflict.
- 最低證據（Minimum evidence）:
  - Skill-forge board, layer choice, description quality, reference split, skill handoff package.
  - Full design reflection when adding or changing gates, matrices, roles, workflow rules, skill boundaries, or repeated governance fields.
  - Validation gate, affected memory and skill-index evidence.
  - Source/deployed parity, grounding handoff, expected dirty files, and closeout bundle index.
- 常見路由（Common route）: 03, 08, 10.

## Memory Evidence Reference

Memory admission and MCP memory evidence live in `Shared/policies/references/workflow-memory-evidence.md`.
This matrix does not authorize memory mutation.
Memory writes and commits keep their separate protected gates.

## Official References

- Codex skills and instructions:
  - https://developers.openai.com/codex/skills
  - https://developers.openai.com/codex/guides/agents-md
- Claude workflows, subagents, permissions, hooks:
  - https://code.claude.com/docs/en/best-practices
  - https://code.claude.com/docs/en/sub-agents
  - https://code.claude.com/docs/en/permissions
  - https://code.claude.com/docs/en/hooks
- Antigravity browser evidence:
  - https://antigravity.google/docs/browser
- Agent Skills format:
  - https://agentskills.io/specification
- Architecture records and diagrams:
  - https://adr.github.io/
  - https://c4model.com/
  - https://arc42.org/overview
- Testing, performance, accessibility:
  - https://playwright.dev/docs/best-practices
  - https://developer.chrome.com/docs/lighthouse/overview
  - https://web.dev/articles/vitals
  - https://www.w3.org/WAI/WCAG22/quickref/
- Security and reliability:
  - https://owasp.org/www-project-application-security-verification-standard/
  - https://opentelemetry.io/docs/
  - https://sre.google/sre-book/monitoring-distributed-systems/
- Commit, changelog, versioning:
  - https://www.conventionalcommits.org/en/v1.0.0/
  - https://keepachangelog.com/en/1.1.0/
  - https://semver.org/
  - https://docs.github.com/articles/about-status-checks

## Usage Rules

- Workflow files must reference this matrix instead of copying every rule.
- Workflow names and platform workflow commands are route declarations only.
- Scoped authorization must be bound by authorization resolution to an explicit visible plan or operation.
- The visible operation may be a button prompt, permission prompt, command, file list, station, phase, expiry, or protected gate.
- Missing tools, missing credentials, or unsupported platform features must be reported as unverified or blocked.
- Missing tools, missing credentials, or unsupported platform features must not be treated as success.
- Platform adapters may add stronger evidence paths.
- Platform adapters must not weaken the minimum evidence contract.
- 08 remains the deep full-spectrum audit baseline.
- Other workflows use only the row relevant to their lifecycle.
- Other workflows do not copy 08 inventory machinery unless the audit workflow is active.
