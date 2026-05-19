---
name: 06_test
description: "Use when: 執行 E2E、視覺測試、瀏覽器功能測試、回歸驗證或測試委派。DO NOT use when: 只需要單元測試設計或純程式碼審查。"
required_skills: [browser-testing, test-automation-strategy]
memory_awareness: none
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: test
  role: worker
  memory_awareness: none
  tool_scope: ["browser:test", "terminal:test", "subagent:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /06_test — 視覺測試]

## 1. Test Scope Identification (測試範圍識別)

[SCOPE GATE] Determine test target:
- IF (triggered by /03_build or /04_fix automatically):
  - Scope = files modified in the preceding workflow.
- IF (triggered directly by Director):
  - Ask Director for target URL or component.

## 2. Browser Agent Delegation (瀏覽器代理人委派)

> [LOAD SKILL] Read `.claude/skills/browser-testing/SKILL.md`.

- Delegate to `Agent(subagent_type="general-purpose")` with browser access.
- Task description MUST be in Traditional Chinese and include:
  1. 測試目標 URL 或路徑
  2. 預期行為描述
  3. 截圖要求（完成後回傳）
  4. 回報格式（通過/失敗 + 截圖路徑）

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
- **Role**: Reader — delegates to subagent, no direct source file writes.
- **Memory**: none — test results are not persisted to memory cards.
