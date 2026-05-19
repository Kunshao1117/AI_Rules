---
name: "08-3-report-健檢總結"
description: "Use when: 健檢第三階段、彙整健康報告、紅黃綠燈號、優先修復清單與行動建議。DO NOT use when: 尚未完成前兩階段健檢。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# source-command-08-audit-08-3-report-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-3_report-SKILL`.

## Command Template

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

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純報告彙整，不修改任何原始碼或記憶卡。
