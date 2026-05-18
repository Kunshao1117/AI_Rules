# 三平台共用子代理啟用政策

此檔是 AI_Rules 的子代理治理唯一來源。三平台核心規則只能保存由本檔轉譯出的 marker block；工作流與技能不得另立一套啟用政策，只能繼承本檔與 `Shared/skills/delegation-strategy/SKILL.md`。

## 共用語義

### 中度自動啟用條件

主代理可在不額外詢問的情況下啟用子代理，但必須符合「有實際節省主線負擔」與「可安全隔離」兩個條件。典型場景：

1. 同一任務存在兩條以上可平行讀取的線索，例如文件盤點、跨模組影響面、競品或規格研究。
2. 需要大量讀檔、搜尋、瀏覽器檢查或 CLI 分析，但結果只作為主代理決策素材。
3. 主代理正在處理實作主線，旁路可以同時驗證文件、測試風險、UI 呈現或相容性。
4. 子代理任務能用明確邊界描述，且輸出可用固定格式回收。

### 禁止啟用條件

下列情況不得啟用子代理，或必須先由主代理處理：

1. 下一步主線被該資訊阻塞，等待子代理只會增加延遲。
2. 任務需要直接修改原始碼、記憶卡、雲端資源、PR、Issue、版本控制或部署狀態。
3. 任務需要使用憑證、密鑰、登入態或不可外洩的私人資料。
4. 任務定義含糊，無法清楚界定讀取範圍、工具範圍或回報格式。
5. 子代理會重複主代理正在做的同一件事，造成結果衝突或成本浪費。

### 主代理整合責任

主代理永遠是唯一整合者與交付責任人：

- 主代理必須審核子代理輸出，不得原樣視為事實或直接套用。
- 主代理負責決定哪些發現進入計畫、程式碼、文件、測試或記憶卡。
- 主代理不得把總監溝通、GO gate、commit、push、部署、安裝、memory_commit 或外部狀態變更委派給子代理。
- 子代理回報若互相矛盾，主代理必須重新查證或明確標示不確定性。

### 子代理唯讀邊界

子代理只能執行唯讀探索、分析、驗證與草稿建議。允許範圍包含讀檔、搜尋、瀏覽器觀察、截圖檢查、測試結果分析、文件摘要與風險評估。禁止範圍包含寫入原始碼、修改記憶卡、stage/commit/push、部署、安裝套件、改雲端資源、修改 Issue/PR 狀態，或呼叫任何會改外部狀態的 MCP tool。

### 固定回報格式

所有子代理必須用以下格式回報，讓主代理可以快速整合：

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## 平台轉譯區塊

以下區塊由同步腳本注入各平台核心規則。三平台副本不得手動修改。

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Moderate auto-invocation**: Use Codex native subagents for bounded, parallel, read-only exploration when the task has independent branches such as broad file reading, documentation comparison, UI/browser verification, regression risk review, or compatibility checks. The main agent should continue non-overlapping work while subagents run.
- **Do not invoke**: Do not use a subagent when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the main agent's current work.
- **Main-agent accountability**: The main Codex agent remains the only integrator and Director-facing owner. It must review subagent output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Codex subagents may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Codex subagent returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CODEX_END -->

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Agent tool)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Moderate auto-invocation**: Use the Claude `Agent` tool for bounded, parallel, read-only exploration when the task has independent branches such as broad file reading, documentation comparison, UI/browser verification, regression risk review, or compatibility checks. The Master Agent should continue non-overlapping work while Agents run.
- **Do not invoke**: Do not use an Agent when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the Master Agent's current work.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review Agent output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Claude Agents may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Claude Agent returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CLAUDE_END -->

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Moderate auto-invocation**: Use `browser_subagent` or the Gemini CLI read-only analytical adapter for bounded, parallel, read-only exploration when the task has independent branches such as broad file reading, documentation comparison, UI/browser verification, regression risk review, or compatibility checks. The Master Agent should continue non-overlapping work while adapters run.
- **Do not invoke**: Do not use a subagent adapter when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the Master Agent's current work.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review adapter output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: `browser_subagent` and Gemini CLI analytical adapters may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Antigravity subagent adapter returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
