---
name: "06-test-測試"
description: "Use when: 執行 E2E、視覺測試、介面適配證據、瀏覽器功能測試、桌面 GUI 驗證、終端輸出驗證、回歸驗證或測試委派。DO NOT use when: 只需要單元測試設計或純程式碼審查。"
required_skills: [browser-testing, test-automation-strategy, ai-dev-quality-gate, project-context-protocol, programming-team-governance]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: test
  role: worker
  memory_awareness: none
  tool_scope: ["browser:test", "terminal:test", "subagent:read"]
  human_gate: "none"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 06 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Select tests by project surface and evidence level, including terminal, browser, plugin panel, desktop GUI, performance, and accessibility paths when applicable.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.

# source-command-06-test-skill

Use this skill when the user asks to run the migrated source command `06_test(測試)-SKILL`.

## Command Template

# [SKILL: /06_test — 介面與回歸測試]

> [LOAD SKILL] If the test target includes layout, components, styling, interaction states, interface adaptation, generated UI references, design DNA, real data, runtime behavior, or operator-visible output, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before defining visual and real execution evidence.
> [LOAD SKILL] If the test target includes design DNA, product preference, communication preference, or acceptance preference, read `.agents/skills/project-context-protocol/SKILL.md` and compare rendered behavior against approved `.agents/context/**/CONTEXT.md` cards.

## 1. Test Scope Identification (測試範圍識別)

[SCOPE GATE] Determine test target:
- IF (triggered by /03_build or /04_fix automatically):
  - Scope = files modified in the preceding workflow.
- IF (triggered directly by Director):
  - Ask Director for target URL or component.

## 2. Interface Evidence Branch (介面證據分支)

> [LOAD SKILL] Read `.agents/skills/browser-testing/SKILL.md`.

- Classify the target surface before selecting evidence: web/browser, desktop GUI, IDE/plugin panel, terminal/CLI/TUI, or mixed surface.
- Classify the real operation surface before selecting evidence: web, desktop GUI, CLI/TUI, backend service, database, scheduled job, automation, IDE/plugin, scraper/data sync, AI/model feature, cloud/deployment, or mixed surface.
- Inventory operator-capable verification entries before selecting evidence: project scripts, app routes, browser control, desktop GUI control, terminal commands, plugin host commands, direct requests, logs, databases, dry-run, preview, sandbox, recorded real-source replay, or read-only production checks.
- Select evidence level from the preceding **[GOVERNANCE DEPTH / 治理深度判定]** summary, or infer it when the Director invokes testing directly:
  - Minimum evidence: targeted proof for a lightweight change, with the selected evidence matching the interface surface.
  - Enhanced evidence: real rendered or executed evidence across the affected states for medium features and all user-visible UI changes.
  - Exemption evidence: allowed only when the target has no UI, no user-visible output, and no interface adaptation impact; state the reason instead of collecting visual evidence.
- Evidence type MUST match the interface surface and real operation surface. Missing required evidence means the result is failed or blocked, not complete.
- Visual evidence MUST include detail-observation notes: text clipping, long labels, alignment, spacing, borders, overlap, focus/disabled states, loading, empty, error, and feedback states relevant to the surface.
- Visual evidence MUST prefer real information: real pages, real data, real account state, current responses/logs, or an equivalent real path before fallback fake data.
- Fake, fixture, seeded, mock, static, or idealized visual data may be used only when real information is unavailable, permission-blocked, unsafe, broken, or not authorized; label the reason, residual risk, and unsupported completion claims.
- For data-dependent or behavior-dependent features, collect at least one real execution signal: request/response, server log, database query, file side effect, timestamped source data, command output, automation run record, plugin host state, model input/output sample, deployment health check, or controlled real-path dry-run.
- If the primary operator path is temporarily unavailable, confirm readiness and retry before abandoning it. If it remains unavailable, use the nearest equivalent real-path alternative and explain the equivalence.
- If no operator or equivalent real path can run, the test result is blocked and must list searched entries, attempted tools, retry count or unsafe-retry reason, alternatives considered, and the smallest missing condition.
- Mock, fixture, seeded, fake, static, or screenshot-only evidence may support layout or unit logic, but cannot pass a feature that requires real verification.
- For web and browser-rendered panels, run the Delegation Gate and use the Codex adapter for browser evidence.
- For desktop GUI, collect screenshots or UI test evidence for minimum window size, resized window, high-DPI/font-scale behavior, dialogs, scroll regions, and keyboard navigation.
- For terminal or CLI/TUI output, collect command output, wrapping behavior, error readability, exit code, and non-interactive mode evidence.
- Codex adapter: spawn a native subagent only when the Director explicitly asks for subagents or this workflow gate requires one; otherwise use available main-thread browser tooling.
- Task description MUST be in Traditional Chinese and include:
  1. 測試目標 URL 或路徑
  2. 預期行為描述
  3. 介面類型、證據等級與證據要求（包含細微觀察、真實資訊優先、假資料備援標記，完成後回傳）
  4. 回報格式（`發現 / 證據 / 風險 / 建議 / 是否阻塞`）

## 3. Result Processing (結果處理)

- IF (All tests PASS and required real execution evidence is present): Report success in Traditional Chinese.
- IF (Tests FAIL or required real execution evidence is missing):
  - Collect failure screenshots and descriptions.
  - Output diagnostic report:
    1. 【失敗項目】— What failed
    2. 【證據狀態】— Screenshot paths, runtime evidence, or missing evidence
    3. 【操作嘗試】— Searched entries, attempted tools, retry status, and equivalent paths considered
    4. 【建議修復方向】— Suggested fix approach

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — collects browser evidence, no direct source file writes.
- **Memory**: none — test results are not persisted to memory cards.
