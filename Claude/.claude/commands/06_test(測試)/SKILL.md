---
name: 06_test
description: 委派子代理人執行 E2E 視覺與功能性測試，無需總監介入
required_skills: [browser-testing, test-automation-strategy]
memory_awareness: none
user-invocable: true
---

# [SKILL: /06_test — 視覺測試]

## 1. Test Scope Identification (測試範圍識別)

[SCOPE GATE] Determine test target:
- IF (triggered by /03_build or /04_fix automatically):
  - Scope = files modified in the preceding workflow.
- IF (triggered directly by Director):
  - Ask Director for target URL or component.

## 2. Browser Agent Delegation (瀏覽器代理人委派)

> [LOAD SKILL] Read `.claude/agents/skills/browser-testing/SKILL.md`.

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
