---
name: 10_routine(巡檢)
description: "Use when: automation-safe 例行巡檢、唯讀健康檢查、技能品質、文件數字、記憶過期與 MCP 設定健康。DO NOT use when: 需要直接修復或寫入檔案。"
required_skills: [memory-ops, code-audit]
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: routine
  role: reader
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "GO required before writes"
  automation_safe: true
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [WORKFLOW: ROUTINE — 例行巡檢]

## 1. Scope

此工作流可由排程或總監手動觸發。預設只讀，負責巡檢技能、文件、記憶與 MCP 設定健康。

## 2. Read-only Checks

- 檢查 `Shared/skills/` 技能品質。
- 比對三平台文件中的平台數、技能數、工作流數與命令數。
- 檢查 `.agents/memory/` 是否有過期追蹤、舊平台敘述或缺失關聯。
- 檢查 MCP opt-in profile snippets 是否存在；不得安裝外部 MCP server。
- 搜尋舊詞：舊技能數、舊版本、舊路徑與不再適用的平台描述。

## 3. Human Gate

- 巡檢期間禁止建立、修改、刪除、stage、commit、push 或安裝任何項目。
- 若需要修正，列出檔案與建議 patch。
- 停在：
  > `[例行巡檢閘門] 巡檢已完成。若要套用修正，請輸入 GO。`

## 4. Output

輸出繁體中文報告，包含平台代理能力一致性、workflow metadata、MCP profile、automation-safe 狀態與文件/記憶漂移。
