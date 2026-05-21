# CLI 能力矩陣

> 此為 `delegation-strategy` 技能的詳細參考資料。

## 可用能力

| 分類 | 抽象能力 | 備註 |
|------|------|------|
| 檔案讀取 | 讀檔能力、目錄列舉能力、搜尋能力 | 實際工具名由平台 adapter 提供 |
| MCP 工具 | MCP direct 或 adapter 核准的 gateway 呼叫能力 | 需使用當前平台的 MCP profile 設定 |
| Shell 指令 | 平台核准的唯讀 shell 讀取能力 | 僅可做讀取、列舉、診斷，不可改變專案或外部狀態 |
| 報告寫入 | 平台核准的報告寫入能力 | 只能寫入 workflow 明確授權的中介報告 |

## 已知限制

| 限制 | 細節 | 繞行方案 |
|------|------|---------|
| 非互動模式工具封鎖 | 部分 CLI 的非互動模式會停用 shell 或檔案工具 | 必須改用平台 adapter 核准的互動模式或主代理執行 |
| MCP 設定獨立 | CLI 的 MCP 設定可能不繼承 IDE | 需由平台 adapter 明確提供 profile |
| Enter 鍵分離 | 部分 CLI TUI 不解讀文字中的換行為 Enter | 文字輸入與確認鍵分開送出 |
| ESLint 絕對路徑 | 某些 lint 工具需要完整絕對路徑陣列 | 從記憶技能追蹤檔案構建 |
| gitignore 過濾 | `.agents/` 被 gitignore 時工具可能跳過 | 改用平台核准的唯讀檔案輸出能力 |
| ESLint MCP 版本衝突 | MCP 內建引擎與專案框架外掛版本衝突 | 改用 `npx eslint` |
