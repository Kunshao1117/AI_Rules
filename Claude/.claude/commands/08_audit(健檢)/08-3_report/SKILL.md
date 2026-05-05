---
name: 08-3_report
description: 健檢第三階段：全光譜健康報告彙整 — 紅黃綠燈號儀表板（5 維度）、優先修復清單、行動建議
required_skills: []
memory_awareness: none
user-invocable: false
---

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
