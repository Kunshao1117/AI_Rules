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


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.
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
