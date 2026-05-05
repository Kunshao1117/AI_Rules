# [SKILL INDEX — ANTIGRAVITY CLAUDE EDITION]

> 操作型知識庫索引。這些 Skill 是按需讀取的程序指引，非 slash command。
> 需要時由 Master Agent 使用 `Read` 工具讀取對應 SKILL.md。

## Core Operations (核心操作)

| Skill | Path | Use When |
|---|---|---|
| memory-ops | `.claude/skills/memory-ops/SKILL.md` | 讀寫專案記憶卡（.agents/memory/，透過 cartridge-system MCP）時 |
| tech-stack-protocol | `.claude/skills/tech-stack-protocol/SKILL.md` | 初次進入專案、確認技術堆疊版本時 |
| delegation-strategy | `.claude/skills/delegation-strategy/SKILL.md` | 決定是否委派子代理人時 |

## Code Quality (程式碼品質)

| Skill | Path | Use When |
|---|---|---|
| code-quality | `.claude/skills/code-quality/SKILL.md` | 撰寫新檔案前確認行數閾值與 SOLID 原則 |
| security-sre | `.claude/skills/security-sre/SKILL.md` | 處理認證、機密、零信任驗證時 |
| ui-ux-standards | `.claude/skills/ui-ux-standards/SKILL.md` | 設計介面文字與錯誤訊息時 |

## Testing & QA (測試與品保)

| Skill | Path | Use When |
|---|---|---|
| test-patterns | `.claude/skills/test-patterns/SKILL.md` | 決定是否撰寫單元測試時 |
| impact-test-strategy | `.claude/skills/impact-test-strategy/SKILL.md` | 評估變更影響範圍時（/fix 必載） |
| test-automation-strategy | `.claude/skills/test-automation-strategy/SKILL.md` | 撰寫 E2E 測試選擇器時 |
| browser-testing | `.claude/skills/browser-testing/SKILL.md` | 執行瀏覽器視覺驗證時 |
| a11y-testing | `.claude/skills/a11y-testing/SKILL.md` | 無障礙 WCAG 掃描時 |

## MCP Operations (外部工具操作)

| Skill | Path | Use When |
|---|---|---|
| github-ops | `.claude/skills/github-ops/SKILL.md` | Git 操作、Issue/PR 管理時（/commit 必載）|
| supabase-ops | `.claude/skills/supabase-ops/SKILL.md` | 資料庫操作、SQL、遷移驗證時 |
| cloudflare-ops | `.claude/skills/cloudflare-ops/SKILL.md` | KV/D1/R2/Workers 管理時 |
| sentry-ops | `.claude/skills/sentry-ops/SKILL.md` | 錯誤追蹤與效能監控時 |

## Analysis & Reasoning (分析與推理)

| Skill | Path | Use When |
|---|---|---|
| structured-reasoning | `.claude/skills/structured-reasoning/SKILL.md` | 複雜架構決策需深度推理時 |
| code-diagnosis | `.claude/skills/code-diagnosis/SKILL.md` | 大範圍原始碼故障調查時 |
| code-audit | `.claude/skills/code-audit/SKILL.md` | 程式碼品質與安全掃描時 |
| performance-audit | `.claude/skills/performance-audit/SKILL.md` | Lighthouse 效能掃描時 |

## GitNexus Operations (代碼知識圖譜)

| Skill | Path | Use When |
|---|---|---|
| gitnexus-guide | `.claude/skills/gitnexus-guide/SKILL.md` | 了解 GitNexus 工具清單與知識圖譜用法時 |
| gitnexus-cli | `.claude/skills/gitnexus-cli/SKILL.md` | 執行 GitNexus CLI（index/analyze/wiki）時 |
| gitnexus-exploring | `.claude/skills/gitnexus-exploring/SKILL.md` | 探索代碼架構、執行流程、理解陌生模組時 |
| gitnexus-debugging | `.claude/skills/gitnexus-debugging/SKILL.md` | 偵錯、追蹤錯誤來源時 |
| gitnexus-impact-analysis | `.claude/skills/gitnexus-impact-analysis/SKILL.md` | 評估變更安全性、找出依賴鏈時 |
| gitnexus-refactoring | `.claude/skills/gitnexus-refactoring/SKILL.md` | 安全重構（改名、抽取、移動代碼）時 |

## Utilities (輔助工具)

| Skill | Path | Use When |
|---|---|---|
| context7-docs | `.claude/skills/context7-docs/SKILL.md` | 查詢即時框架文件時 |
| excel-ops | `.claude/skills/excel-ops/SKILL.md` | 匯出稽核報告或資料分析時 |
| stitch-design | `.claude/skills/stitch-design/SKILL.md` | UI 設計稿生成時 |

## Memory & Data (記憶與資料擴充)

| Skill | Path | Use When |
|---|---|---|
| memory-arch | `.claude/skills/memory-arch/SKILL.md` | 決定記憶卡層級架構、拆分過大記憶卡時 |
| supabase | `.claude/skills/supabase/SKILL.md` | 涉及 Supabase 完整功能（Auth、Storage、Realtime）時 |
| supabase-postgres-best-practices | `.claude/skills/supabase-postgres-best-practices/SKILL.md` | 撰寫或優化 Postgres 查詢、Schema 設計時 |

---

> **Note**: 操作型知識庫已同步至 36 個完整技能。
> 可直接按需讀取 `.claude/skills/{skill-name}/SKILL.md` 進行操作。
