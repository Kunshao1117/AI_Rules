# 三平台共用子代理治理政策

此檔是 AI_Rules 的子代理治理唯一來源。共用層只定義「何時需要委派證據分支」與「主代理如何收斂證據」，不得把任一廠商的工具名稱當成跨平台規則。三平台核心規則只能保存由本檔轉譯出的 marker block；工作流與技能不得另立一套啟用政策，只能繼承本檔與 `Shared/skills/delegation-strategy/SKILL.md`。

## 共用語義

### Delegation Gate

主代理在進入研究、測試、除錯、健檢，或建構/修復後的驗證尾段時，必須先判斷是否存在可安全隔離的 evidence branch（證據分支）。Delegation Gate 的輸出只能是下列其中之一：

| Gate 結果 | 使用時機 | 主代理義務 |
|---|---|---|
| `direct` | 任務簡短、下一步被此資訊阻塞、或委派成本高於收益 | 主代理直接處理，必要時說明不委派理由 |
| `evidence branch` | 存在獨立唯讀調查線索，例如文件盤點、跨模組影響面、回歸風險或競品/規格研究 | 委派一個或多個唯讀證據分支，主代理整合結果 |
| `browser branch` | 需要 UI、DOM、截圖、瀏覽器互動或視覺驗證 | 交由平台 browser adapter 或主代理瀏覽器工具取得證據 |
| `CLI branch` | 需要大量 CLI 輸出、掃描、測試摘要或日誌整理，且可隔離為報告 | 允許只在 `.agents/logs/` 產出中繼報告，不可改原始碼 |
| `MCP direct` | 需要即時工具資料、雲端狀態、文件查詢或資料庫讀取 | MCP 是主代理直接工具，不是委派目標；寫入型 MCP 仍需 GO/HITL |

### 必須評估委派的典型場景

1. 同一任務存在兩條以上可平行讀取的線索，例如文件盤點、跨模組影響面、競品或規格研究。
2. 需要大量讀檔、搜尋、瀏覽器檢查或 CLI 分析，但結果只作為主代理決策素材。
3. 主代理正在處理實作主線，旁路可以同時驗證文件、測試風險、UI 呈現或相容性。
4. 子代理任務能用明確邊界描述，且輸出可用固定格式回收。

### 禁止委派條件

下列情況不得委派，或必須先由主代理處理：

1. 下一步主線被該資訊阻塞，等待分支只會增加延遲。
2. 任務需要直接修改原始碼、記憶卡、雲端資源、PR、Issue、版本控制或部署狀態。
3. 任務需要使用憑證、密鑰、登入態或不可外洩的私人資料。
4. 任務定義含糊，無法清楚界定讀取範圍、工具範圍或回報格式。
5. 證據分支會重複主代理正在做的同一件事，造成結果衝突或成本浪費。

### 主代理整合責任

主代理永遠是唯一整合者與交付責任人：

- 主代理必須審核證據分支輸出，不得原樣視為事實或直接套用。
- 主代理負責決定哪些發現進入計畫、程式碼、文件、測試或記憶卡。
- 主代理不得把總監溝通、GO gate、commit、push、部署、安裝、memory_commit 或外部狀態變更委派出去。
- 分支回報若互相矛盾，主代理必須重新查證或明確標示不確定性。

### 證據分支唯讀邊界

證據分支只能執行唯讀探索、分析、驗證與草稿建議。允許範圍包含讀檔、搜尋、瀏覽器觀察、截圖檢查、測試結果分析、文件摘要與風險評估。禁止範圍包含寫入原始碼、修改記憶卡、stage/commit/push、部署、安裝套件、改雲端資源、修改 Issue/PR 狀態，或呼叫任何會改外部狀態的 MCP tool。

### 固定回報格式

所有證據分支必須用以下格式回報，讓主代理可以快速整合：

```text
發現:
證據:
風險:
建議:
是否阻塞:
```

## 平台轉譯區塊

以下區塊由同步腳本注入各平台核心規則。三平台副本不得手動修改。平台專用工具名只能出現在這些轉譯區塊或平台專屬 workflow / command 中；Shared 共用語義段落不得硬寫單一廠商工具名。

<!-- SUBAGENT_POLICY:CODEX_START -->
### Shared Subagent Invocation Policy (Codex native subagents)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Delegation Gate**: Evaluate whether the task has an isolated read-only evidence branch before broad research, testing, debugging, audit work, or post-change verification.
- **Invocation rule**: Codex spawns native subagents only when the Director explicitly asks for subagents, when a workflow gate explicitly requires a Codex evidence branch, or when project-scoped `.codex/agents/*.toml` custom agents are intentionally configured for that workflow.
- **Do not invoke**: Do not use a Codex subagent when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the main agent's current work.
- **Main-agent accountability**: The main Codex agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Codex evidence branches may read, search, inspect browser state when available, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Codex evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CODEX_END -->

<!-- SUBAGENT_POLICY:CLAUDE_START -->
### Shared Subagent Invocation Policy (Claude Code subagents)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Delegation Gate**: Evaluate whether the task has an isolated read-only evidence branch before broad research, testing, debugging, audit work, or post-change verification.
- **Invocation rule**: Claude Code may use built-in, custom, or plugin subagents through description-driven delegation, `@agent` mentions, or `Agent(...)` tool permissions when the branch is bounded and read-only.
- **Do not invoke**: Do not use a Claude subagent when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the Master Agent's current work.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Claude evidence branches may read, search, inspect browser state when allowed, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Claude evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:CLAUDE_END -->

<!-- SUBAGENT_POLICY:ANTIGRAVITY_START -->
### Shared Subagent Invocation Policy (Antigravity / Gemini adapters)

This block is generated from `Shared/policies/subagent-invocation.md`. Do not edit the platform copy by hand.

- **Delegation Gate**: Evaluate whether the task has an isolated read-only evidence branch before broad research, testing, debugging, audit work, or post-change verification.
- **Invocation rule**: Antigravity / Gemini may map evidence branches to Gemini CLI subagents, `@`-directed specialists, browser-capable agents, or Antigravity plugin adapters when the branch is bounded and read-only.
- **Do not invoke**: Do not use an Antigravity / Gemini adapter when the next main-thread step is blocked on that answer, when the task is vague, when it requires secrets or login state, or when it would duplicate the Master Agent's current work.
- **Master-Agent accountability**: The Master Agent remains the only integrator and Director-facing owner. It must review evidence output before using it and must not delegate GO gates, commits, pushes, deployments, installs, memory commits, or external state changes.
- **Read-only boundary**: Antigravity / Gemini evidence branches may read, search, inspect browser state, analyze logs, summarize docs, and propose changes as text. They must not modify source files, memory cards, git state, cloud resources, issues, pull requests, or call mutating MCP tools.
- **Required report format**: Every Antigravity / Gemini evidence branch returns `發現 / 證據 / 風險 / 建議 / 是否阻塞`.
<!-- SUBAGENT_POLICY:ANTIGRAVITY_END -->
