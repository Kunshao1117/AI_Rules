---
name: browser-testing
description: >
  [Testing] Browser evidence branch SOP, web/extension interface adaptation evidence,
  and auto-arbitration gate for E2E visual testing.
  Use when: 需要瀏覽器證據分支進行視覺驗證、E2E 測試執行、DOM 檢查、截圖證據、網頁或外掛面板介面適配驗收、或瀏覽器自動仲裁閘門判定的場景。
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
- If project context or design DNA is needed, the main thread reads approved `.agents/context/**/CONTEXT.md` cards and embeds key details directly in the task description prompt.
  （如需專案脈絡或設計 DNA，由主線讀取已核准脈絡後直接嵌入任務描述中）

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

### Step 4.5: Interface Evidence Matrix (介面證據矩陣)

For browser-rendered UI changes that affect layout, components, styling, or interaction states:
（影響版面、元件、樣式或互動狀態的瀏覽器渲染 UI 變更）

1. For web apps and websites, capture or inspect at least one mobile viewport, one tablet viewport, and one desktop viewport.
   （網頁與網站至少檢查手機、平板與桌面三種視窗）
2. For IDE webviews or plugin panels, capture narrow sidebar width, expanded panel width, light/dark theme when supported, and confirmation or feedback states.
   （IDE webview 或外掛面板檢查窄側欄、展開寬度、支援時的明暗主題，以及確認或回饋狀態）
3. For non-browser desktop GUI or terminal interfaces, report that browser evidence is not the right adapter and route validation through `ai-dev-quality-gate` interface adaptation evidence.
   （非瀏覽器桌面 GUI 或終端介面，不套用瀏覽器證據，改走介面適配證據）
4. Check text overflow, compressed controls, overlapping components, table or chart overflow, fixed elements covering content, touch target size when relevant, spacing consistency, and type hierarchy.
   （檢查文字溢出、按鈕擠壓、元件重疊、表格超出、固定區塊遮擋、觸控尺寸、間距一致性與字級層級）
5. If required evidence for the selected surface is missing, report the UI as pending visual validation and do not mark the task complete.
   （缺少該介面類型必要證據時，只能回報待驗收，不得宣稱完成）

### Step 4.6: Real Function Evidence Boundary (真實功能證據邊界)

Screenshots and DOM snapshots prove only what is visible at capture time. They do not, by themselves, prove real data, persistence, business logic, market data, time-series correctness, permissions, external integrations, or post-action side effects.

For browser-rendered features that depend on data or behavior:

1. Pair screenshots with at least one real execution signal: user interaction result, network request or response, console or server log, persisted state, timestamped data source, or accessible application state.
2. If the page uses mock, fixture, seeded, or static data, label that evidence as layout or flow evidence only.
3. If a browser branch cannot access the needed data source, it must return a blocked validation report with attempted steps and missing conditions.
4. A browser evidence packet that contains only screenshots for a data-dependent feature is incomplete and must not be treated as passing.

Operator-path retention:

1. Do not drop browser validation because the first route, selector, tab, or tool call failed. Search the app routes, scripts, docs, and stable selectors before declaring the browser path unavailable.
2. For transient browser, network, or server-readiness failures, retry with the Step 5 triage budget before switching paths.
3. If browser control remains unavailable, use the nearest equivalent operator path when it still exercises the same behavior: desktop controller, plugin host, direct request plus logs, preview URL, or controlled real-path replay.
4. The blocked report must list the searched entry points, tool attempts, retry count, alternative paths considered, and the missing condition.

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
│   └── Action: Wait 3s with backoff, then retry (max 2 retries). Do not abandon the browser evidence path after a single transient failure.
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
- Data-dependent or behavior-dependent UI includes a real execution signal, or is explicitly marked failed or blocked
- Layout-affecting browser UI changes include the required web or plugin-panel evidence, or are explicitly marked pending validation
