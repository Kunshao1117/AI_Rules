---
name: 08-3_report
description: "Use when: 健檢第三階段、彙整健康報告、紅黃綠燈號、優先修復清單與行動建議。DO NOT use when: 尚未完成前兩階段健檢。"
required_skills: []
memory_awareness: none
user-invocable: false
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: audit
  role: reporter
  memory_awareness: none
  tool_scope: ["conversation"]
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
# [SKILL: /08_audit — Phase 3: 健檢總結報告]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，接收 Phase 1 + Phase 2 的報告物件後彙整。

## 3.1 Traffic Light Dashboard (紅黃綠燈號儀表板)

依據 Phase 1 + Phase 2 收集的資料，輸出以下儀表板（全繁中）：

| 項目 | 燈號 | 摘要 |
|---|---|---|
| 🔴 依賴安全 | 🟢/🟡/🔴 | npm audit 嚴重程度分佈 |
| 📘 型別安全 | 🟢/🟡/🔴 | TypeScript 錯誤數量 |
| 🧠 記憶拓樸 | 🟢/🟡/🔴 | 過期卡數 / 未覆蓋檔案數 |
| 🔒 安全架構 | 🟢/🟡/🔴 | S1–S5 最低分維度 |
| 🔌 前後端串接 | 🟢/🟡/🔴 | 斷鏈端點數 |
| 🧪 測試覆蓋 | 🟢/🟡/🔴 | 核心路徑缺口數 |

**燈號判斷基準：**
- 🟢 綠燈：無發現 / 低影響
- 🟡 黃燈：中影響，建議近期修復
- 🔴 紅燈：高影響，需立即修復

## 3.2 Priority Action Items (優先修復清單)

依「嚴重程度 × 業務影響」排序，輸出前 5 項：

| 優先級 | 項目 | 影響範圍 | 建議行動 |
|--------|------|---------|---------|
| 🔴 P1 | ... | ... | `/04_fix` |
| 🟡 P2 | ... | ... | ... |

## 3.3 Completion

Append:「[健檢完成] 如需修復指定項目，請對 🔴 紅燈項目執行 /04_fix。如需深度重構，請先執行 /02_blueprint 評估架構影響。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純報告彙整，不修改任何原始碼或記憶卡。
