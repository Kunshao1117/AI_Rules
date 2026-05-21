---
name: browser-testing
description: >
  [Testing] Browser evidence branch SOP and auto-arbitration gate for E2E visual testing.
  Use when: 需要瀏覽器證據分支進行視覺驗證、E2E 測試執行、DOM 檢查、截圖證據、或瀏覽器自動仲裁閘門判定的場景。
  DO NOT use when: 寫單元測試（用 test-patterns）、只需要 DOM 選擇器策略（用 test-automation-strategy）、決定委派管道（用 delegation-strategy）。
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [playwright, a11y]
  tool_scope: ["filesystem:read", "browser", "mcp:playwright", "mcp:a11y"]
---

# Browser Testing (瀏覽器測試)

## HITL Boundary

- Read-only browser inspection, screenshots, accessibility checks, and test result reporting may proceed silently.
- Applying browser evidence branch proposed code changes, writing files, updating memory, installing packages, pushing commits, or modifying external services requires Director `GO` and an `[MCP HITL GATE]` justification block before execution.
- Discovery of browser or MCP tool schemas is not permission to execute mutating tools.

## Trigger Conditions (觸發條件)

- E2E visual testing, UI verification, browser-based validation, DOM state inspection, or screenshot evidence collection
  （端到端視覺測試、UI 驗證、瀏覽器操作驗證、DOM 狀態檢查或截圖證據收集）

## Procedure (操作流程)

### Step 1: Browser Evidence Branch SOP (瀏覽器證據分支標準作業)

When requesting a browser evidence branch:
（請求瀏覽器證據分支時）

1. **Task description**: MUST be in Traditional Chinese (zh-TW)
   （任務描述必須使用繁體中文）
2. **Platform adapter**: Use the current platform's browser-capable adapter or main-thread browser tool
   （由目前平台轉譯為可用的瀏覽器代理、插件或主代理瀏覽器工具）
3. **Stop condition**: Explicitly define when the branch should stop and return
   （明確定義停止條件）
4. **Return format**: Specify `發現 / 證據 / 風險 / 建議 / 是否阻塞`
   （指定固定回報格式）
5. **Allowed scope**: The branch can only inspect browser state, DOM, screenshots, accessibility tree, and test results. It cannot read/write project files unless the active platform explicitly runs it as a read-only code evidence branch.
   （只能檢查瀏覽器狀態、DOM、截圖、可及性樹與測試結果；不可寫入專案檔案）

### Step 2: Platform Adapter Notes (平台轉譯提示)

- Antigravity / Gemini maps browser branch intent to its browser-capable agent or plugin adapter.
- Claude maps browser branch intent to an allowed browser/testing subagent or main-thread browser tool, depending on project permissions.
- Codex maps browser branch intent to native subagents only when the Director explicitly asks or a workflow gate requires it; otherwise the main Codex agent uses available Browser tooling directly.

### Step 3: Context Passing (上下文傳遞)

- Browser evidence branches may not have module memory loaded.
  （瀏覽器證據分支不一定能存取模組記憶）
- If project context is needed, embed key details directly in the task description prompt.
  （如需專案資訊，直接嵌入任務描述中）

### Step 4: Auto-Arbitration Gate (自動仲裁閘門)

After a browser evidence branch proposes changes:
（瀏覽器證據分支提出變更建議後）

1. Master Agent may apply proposed changes only when the governing workflow is already in a writable phase and Director `GO` has been granted.
   （主代理只有在可寫階段且已取得 GO 時，才能套用變更）
2. Run automated tests if project has them.
   （如有自動測試則執行）
3. **Auto-Pass**: Linter + Tests pass 100% -> skip additional human review only after required Director `GO` / HITL gates are already satisfied.
   （全通過時可略過額外人工審查，但不得略過既有 GO / HITL 閘門，也不自行授權寫入）
4. **Visual Authorization Gate**: UI changes MUST conclude with `/06_test` for visual verification.
   （UI 變更必須以視覺測試收尾）

## Constraints (約束)

- Browser evidence branch output is read-only evidence; Master Agent performs all physical writes.
  （證據分支輸出為唯讀證據，實際寫入由主代理執行）
- Server must be running and warmed up before requesting browser verification.
  （啟動瀏覽器驗證前確保伺服器已運行）

### Step 5: Structured Error Triage (結構化錯誤分類)

When Auto-Arbitration Gate FAILS, classify the error before deciding next action:
（自動仲裁閘門失敗時，先分類錯誤再決定下一步）

```text
[ERROR TRIAGE] On Auto-Arbitration failure:
├── TRANSIENT (暫時性): Network timeout, server not ready, rate limit, 429/503
│   └── Action: Wait 3s with backoff, then retry (max 2 retries).
│       Counts toward Circuit Breaker (Check 0 in _completion_gate).
├── SEMANTIC (語意性): Wrong selector, element not found, assertion mismatch, logic error
│   └── Action: Return structured error to Master Agent for re-planning.
│       Include: { errorType: "SEMANTIC", selector: "...", expected: "...", actual: "..." }
│       Does NOT count toward Circuit Breaker retry limit.
└── INFRASTRUCTURE (基礎設施): Server crash, port conflict, OOM, ECONNREFUSED
    └── Action: [HALT] Escalate to Director immediately.
          「🔴 [INFRA HALT] 基礎設施異常：{error}。請總監確認環境狀態。」
          Does NOT count toward Circuit Breaker retry limit.
```

## Done When (驗證標準)

- Browser evidence branch returned successfully with report
- All approved proposed changes applied by the Master Agent and tests pass
- Visual verification screenshot/recording or DOM state evidence is included in the walkthrough
