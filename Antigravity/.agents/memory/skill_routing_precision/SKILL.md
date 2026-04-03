---
name: skill_routing_precision
description: 負責框架內的高精度技能選擇過濾，及實體 MCP 工具呼叫的防規避鎖 (Execution Lock) 守則。
scopePath: .agents/skills
last_updated: '2026-04-04T01:48:32+08:00'
status: active
staleness: 0
---

# 模組記憶：技能高精度路由防線 (Skill Routing Precision)

## Tracked Files

- d:\AI_Rules\Antigravity\.agents\skills\cross-lingual-guard\SKILL.md
- d:\AI_Rules\Antigravity\.agents\skills\skill-factory\SKILL.md

## Key Decisions

- **導入強制執行鎖 (Execution Lock, 2026-04)**：為解決 AI 規避外部 MCP 呼叫並以純文字產生幻覺的問題，決定採用「上下文依賴斷點法」。強制 AI 在 `cross-lingual-guard` 的模板輸出中，寫入無法預測的欄位 `MCP 執行足跡驗證: (Step Id)`。此方法強迫 AI 中斷文字流式生成，回歸等待 API 工具響應，藉此達到物理阻斷幻覺的目的。
- **摘要標籤化與排他約定 (Negative Constraints, 2026-04)**：針對多種技能間的重疊模糊，決定在 `skill-factory` 的技能產出規範中加入嚴格審查標準：摘要需包含 `[Domain]` / `[Quality]` 標籤分類，且必須附有 `DO NOT use when:` 排他防護字句，截斷 AI 首輪語意匹配分流的發散問題。

## Known Issues

- 既有 27 項技能的摘要可能遺漏這套新的標籤矩陣標準。未來需要透過批次稽核或人工更新完成摘要重構。

## Module Lessons

- **幻覺本質 (Hallucination Nature)**：當系統單純依靠「約束文字」要 AI 誠實執行時，AI 在遭遇阻力 (如 Json parse 錯誤) 仍會傾向捏造行為 (Agent Bypass)。唯一防守的手段是在輸出層設置含有不可預測資訊的洞，讓它「無法靠編造填補漏洞」。

## Relations

- 上游模組：`_system`
- 相依技能：`cross-lingual-guard`, `skill-factory`

## Applicable Skills

- memory-ops
- cross-lingual-guard
