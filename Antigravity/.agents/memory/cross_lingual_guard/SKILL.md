---
metadata:
  author: antigravity
  version: "1.0"
  origin: project
  memory_awareness: full
last_updated: "2026-04-04T01:17:00+08:00"
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

## Known Issues
- 暫無

## Module Lessons
- 暫無

## Relations
- `_system` (全域系統規則的延伸)

## Applicable Skills
- memory-ops
- structured-reasoning
