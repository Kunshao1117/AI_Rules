# [SKILL INDEX — ANTIGRAVITY CLAUDE EDITION]

> 操作型知識庫索引。這些 Skill 是按需讀取的程序指引，非 slash command。
> 需要時由 Master Agent 使用 `Read` 工具讀取對應 SKILL.md。

## Core Operations (核心操作)

| Skill | Path | Use When |
|---|---|---|
| memory-ops | `.claude/agents/skills/memory-ops/SKILL.md` | 讀寫專案記憶卡（.claude/agents/memory/）時 |
| tech-stack-protocol | `.claude/agents/skills/tech-stack-protocol/SKILL.md` | 初次進入專案、確認技術堆疊版本時 |
| delegation-strategy | `.claude/agents/skills/delegation-strategy/SKILL.md` | 決定是否委派子代理人時 |

## Code Quality (程式碼品質)

| Skill | Path | Use When |
|---|---|---|
| code-quality | `.claude/agents/skills/code-quality/SKILL.md` | 撰寫新檔案前確認行數閾值與 SOLID 原則 |
| security-sre | `.claude/agents/skills/security-sre/SKILL.md` | 處理認證、機密、零信任驗證時 |
| ui-ux-standards | `.claude/agents/skills/ui-ux-standards/SKILL.md` | 設計介面文字與錯誤訊息時 |

## Testing & QA (測試與品保)

| Skill | Path | Use When |
|---|---|---|
| test-patterns | `.claude/agents/skills/test-patterns/SKILL.md` | 決定是否撰寫單元測試時 |
| impact-test-strategy | `.claude/agents/skills/impact-test-strategy/SKILL.md` | 評估變更影響範圍時（/fix 必載） |
| test-automation-strategy | `.claude/agents/skills/test-automation-strategy/SKILL.md` | 撰寫 E2E 測試選擇器時 |
| browser-testing | `.claude/agents/skills/browser-testing/SKILL.md` | 執行瀏覽器視覺驗證時 |
| a11y-testing | `.claude/agents/skills/a11y-testing/SKILL.md` | 無障礙 WCAG 掃描時 |

## MCP Operations (外部工具操作)

| Skill | Path | Use When |
|---|---|---|
| github-ops | `.claude/agents/skills/github-ops/SKILL.md` | Git 操作、Issue/PR 管理時（/commit 必載）|
| supabase-ops | `.claude/agents/skills/supabase-ops/SKILL.md` | 資料庫操作、SQL、遷移驗證時 |
| cloudflare-ops | `.claude/agents/skills/cloudflare-ops/SKILL.md` | KV/D1/R2/Workers 管理時 |
| sentry-ops | `.claude/agents/skills/sentry-ops/SKILL.md` | 錯誤追蹤與效能監控時 |

## Analysis & Reasoning (分析與推理)

| Skill | Path | Use When |
|---|---|---|
| structured-reasoning | `.claude/agents/skills/structured-reasoning/SKILL.md` | 複雜架構決策需深度推理時 |
| code-diagnosis | `.claude/agents/skills/code-diagnosis/SKILL.md` | 大範圍原始碼故障調查時 |
| code-audit | `.claude/agents/skills/code-audit/SKILL.md` | 程式碼品質與安全掃描時 |
| performance-audit | `.claude/agents/skills/performance-audit/SKILL.md` | Lighthouse 效能掃描時 |

## Utilities (輔助工具)

| Skill | Path | Use When |
|---|---|---|
| context7-docs | `.claude/agents/skills/context7-docs/SKILL.md` | 查詢即時框架文件時 |
| excel-ops | `.claude/agents/skills/excel-ops/SKILL.md` | 匯出稽核報告或資料分析時 |
| stitch-design | `.claude/agents/skills/stitch-design/SKILL.md` | UI 設計稿生成時 |

---

> **Note**: 上表技能大部分尚待從 Antigravity/ 移植並調整工具語法。
> 移植優先順序：memory-ops → github-ops → code-quality → security-sre → impact-test-strategy
