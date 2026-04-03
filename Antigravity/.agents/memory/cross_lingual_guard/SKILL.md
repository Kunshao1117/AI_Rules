---
metadata:
  author: antigravity
  version: "1.0"
  origin: project
  memory_awareness: full
last_updated: "2026-04-04T05:41:00+08:00"
status: active
staleness: 0
---
# 跨語系思維解析器 (Cross Lingual Guard)

包含 `01_cross_lingual_guard.md` 規則以及對應技能的演進記憶。

## Tracked Files
- d:\AI_Rules\Antigravity\.agents\rules\01_cross_lingual_guard.md
- d:\AI_Rules\Antigravity\.agents\skills\cross-lingual-guard\SKILL.md

## Key Decisions
- **架設 Phase 2 實體映射防線 (2026-04)**: 為解決語言轉換與操作落地之間的誤差 (Zero-Shot Laziness)，在 `Phase 1 意圖解碼` 之後強制加入 `Phase 2: Tool & Skill Routing` 思考區塊。利用 Transformer 模型的注意力連結，以「強制寫出工具對應名稱」來控制執行。
- **柔性降級與擴充 (Graceful Fallback)**: 當找不到任何對應的工具或技能時，不可陷入死鎖。必須拋出「能力缺口警報」，暫用內建模型常識作答，並主動建議總監掛載額外 MCP，或藉由 `/12_skill_forge` 將經驗提煉為新技能。
- **工作流語意判斷升級 (2026-04)**: Condition A/B 分流條件重構——工作流斜線指令若附帶額外中文文字，視同語意輸入進入雙框模式。防止工作流觸發時跳過語意解碼。
- **實體足跡收據折疊化 (2026-04)**: 三個面板（語意解析、系統準備、實體收據）統一為 `<details>` 折疊格式，維持介面一致性。
- **模板指引英文化 (2026-04)**: 所有面板模板中的方括號填寫指引從中文改為英文，符合雙受眾設計原則的指令層規範。
- **歷史防偽查驗拆分 (2026-04)**: 將單一查驗欄位拆分為「對話追溯」與「工具追溯」兩個獨立欄位，確保對話序號與工具呼叫紀錄各自可追溯。
- **預設值反轉架構決策 (2026-04)**: 經 8 輪深度推理識別「雙軌問題」根因後，將判斷邏輯從 code fence 中脫出改為散文指令，並反轉預設值——雙框為預設行為，單框為極窄例外。核心原理：模型走捷徑的結果從「漏掉語意面板」（危險）變為「多輸出語意面板」（安全冗餘）。同時加入 6 個 few-shot 範例實現模式匹配而非條件推理。

## Known Issues
- 暫無

## Module Lessons
- 暫無

## Relations
- `_system` (全域系統規則的延伸)

## Applicable Skills
- memory-ops
- structured-reasoning
