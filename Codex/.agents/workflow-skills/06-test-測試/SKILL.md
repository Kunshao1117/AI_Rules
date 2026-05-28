---
name: "06-test-測試"
description: "Use when: 執行 E2E、視覺測試、瀏覽器功能測試、回歸驗證或測試委派。DO NOT use when: 只需要單元測試設計或純程式碼審查。"
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.
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
# source-command-06-test-skill

Use this skill when the user asks to run the migrated source command `06_test(測試)-SKILL`.

## Command Template

# [SKILL: /06_test — 視覺測試]

## 1. Test Scope Identification (測試範圍識別)

[SCOPE GATE] Determine test target:
- IF (triggered by /03_build or /04_fix automatically):
  - Scope = files modified in the preceding workflow.
- IF (triggered directly by Director):
  - Ask Director for target URL or component.

## 2. Browser Evidence Branch (瀏覽器證據分支)

> [LOAD SKILL] Read `.agents/skills/browser-testing/SKILL.md`.

- Run the Delegation Gate and use the Codex adapter for browser evidence.
- Codex adapter: spawn a native subagent only when the Director explicitly asks for subagents or this workflow gate requires one; otherwise use available main-thread browser tooling.
- Task description MUST be in Traditional Chinese and include:
  1. 測試目標 URL 或路徑
  2. 預期行為描述
  3. 截圖要求（完成後回傳）
  4. 回報格式（`發現 / 證據 / 風險 / 建議 / 是否阻塞`）

## 3. Result Processing (結果處理)

- IF (All tests PASS): Report success in Traditional Chinese.
- IF (Tests FAIL):
  - Collect failure screenshots and descriptions.
  - Output diagnostic report:
    1. 【失敗項目】— What failed
    2. 【截圖證據】— Screenshot paths
    3. 【建議修復方向】— Suggested fix approach

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — collects browser evidence, no direct source file writes.
- **Memory**: none — test results are not persisted to memory cards.
