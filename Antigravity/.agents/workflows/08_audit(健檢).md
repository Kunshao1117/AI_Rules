---
description: "Use when: 全光譜專案健檢、audit、治理巡檢、基礎盤點、深度邏輯審查與健康報告。DO NOT use when: 只要單一測試或單一 bug 修復。"
required_skills: [memory-ops, code-audit, audit-engine]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
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
# [WORKFLOW: 08_audit — 全光譜健檢入口]

> 本工作流為三階段健檢的入口控制器，不包含實際掃描邏輯。
> 實際邏輯分別在 08-1_audit_infra / 08-2_audit_logic / 08-3_audit_report 工作流中。

## 入口分派閘門

```
[PARTIAL AUDIT GATE] 依總監輸入決定執行路徑：
├── 「@[/08_audit] infra」或「只跑基礎盤點」→ 僅觸發 @[/08-1_audit_infra]
├── 「@[/08_audit] logic」或「只跑邏輯審查」→ 僅觸發 @[/08-2_audit_logic]
├── 「@[/08_audit] report」→ 使用上次快取報告直接觸發 @[/08-3_audit_report]
└── 無修飾詞 → 完整三階段依序執行：
    Step 1: 觸發 @[/08-1_audit_infra] → 等待完成
    Step 2: 觸發 @[/08-2_audit_logic] → 等待完成
    Step 3: 觸發 @[/08-3_audit_report] → 輸出最終燈號儀表板
```

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 全程唯讀，不修改任何原始碼。
