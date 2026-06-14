# 三平台工作流能力與證據矩陣

此檔是 00 到 12 工作流的共用外部接地規格。它不取代各工作流本體；各工作流只引用本矩陣，再套用自己的任務邊界、平台能力與證據狀態。08 健檢另由共用健檢引擎定義深度模式、盤點分母與覆蓋率規則。

## Evidence Status

| 狀態 | 意義 | 使用邊界 |
|---|---|---|
| 足夠證據 | 已有官方文件、現有來源、工具輸出或真實操作證據支撐 | 可作為工作流判定依據 |
| 部分證據 | 有合理證據，但缺少完整操作、版本、權限或環境確認 | 可提出建議，不可宣稱已完成高風險驗證 |
| 未驗證 | 有檢查需求，但目前沒有足夠資料或工具結果 | 必須標明缺口與最小補證路徑 |
| 阻塞 | 缺少憑證、授權、登入、外部服務、硬體或高風險操作批准 | 不得給綠燈；只能列出阻塞條件 |
| 不適用 | 專案型態或任務意圖不需要該檢查 | 必須附上判定依據 |

## Platform Translation

| 平台 | 採證最佳化 | 不可混用邊界 |
|---|---|---|
| Antigravity | 優先使用瀏覽器代理、截圖、錄影、視覺產物、IDE 工作流與終端證據 | 不把 Claude 鉤子或 Codex 原生子代理語法寫成 Antigravity 指令 |
| Claude | 優先使用計畫模式、子代理、權限、鉤子、檢查點、批次讀取與非互動命令證據 | 不把 Claude 鉤子視為其他平台可用能力 |
| Codex | 優先使用技能漸進載入、沙盒/審批轉錄、明確允許的子代理、瀏覽器、終端、MCP 與背景任務證據 | 子代理只在總監明確要求、工作流閘門允許或專案代理已配置時啟動 |

## Workflow Matrix

| 工作流 | 任務型態 | 外部接地依據 | 最低證據 | 常見路由 |
|---|---|---|---|---|
| 00 對話 | 純討論、概念釐清、輕量問答 | Codex 指令分層、Claude 上下文管理、Agent Skills 描述觸發 | 當前規則與已知上下文；高變動事實需轉研究 | 01、02、03、04、06、09 |
| 01 探索 | 網路研究、競品、可行性、反方分析 | 深度研究實務、來源可信度、資料新鮮度 | 來源層級、日期、偏誤、覆蓋缺口與未驗證項 | 02、03、08 |
| 02 架構 | 純架構、重大技術轉向、系統藍圖 | ADR、C4、arc42、官方框架文件 | 決策狀態、替代方案、假設、相容性與後續建構契約 | 03、08、12 |
| 03-1 實驗 | 沙盒 spike、丟棄式原型 | 技術 spike 與原型隔離實務 | 實驗邊界、丟棄條件、禁止生產品質聲明 | 03、11 |
| 03 建構 | 正式建構、產品行為變更 | 先探索、再計畫、再實作、再驗證 | 驗收條件、真實驗證路徑、工具發現、阻塞條件 | 04、06、08、09 |
| 04 修復 | bug 修復、回歸修復 | 根因分析、缺陷管理、回歸測試 | 症狀、根因、修復證據、回歸證據 | 06、07、09 |
| 05 濃縮 | 專案身份、長期記憶初始化 | 上下文壓縮、長期記憶、偏好治理 | 來源依據、永久事實與暫時觀察分離 | 02、11、12 |
| 06 測試 | E2E、視覺、效能、無障礙、回歸 | Playwright、Lighthouse、Web Vitals、WCAG | 專案型態、測試面、證據等級、阻塞原因 | 03、04、08 |
| 07 除錯 | stack trace、日誌、故障定位 | OpenTelemetry、SRE 監控、根因診斷 | 可觀測訊號、假設、證實/反證、轉修復條件 | 04、06、08 |
| 08 健檢 | 全光譜專案健檢、深層健檢、上線前高風險審查 | 08 共用健檢引擎、本矩陣、OWASP、Playwright、Lighthouse、Web Vitals、WCAG、OpenTelemetry | 健檢深度、專案型態、能力快照、功能/端點/命令盤點、覆蓋率分母、證據包、燈號、未驗證/阻塞清單 | 02、03、04、06、09 |
| 09 提交 | 變更紀錄、提交、版本、發布前掃描 | Conventional Commits、Keep a Changelog、SemVer、狀態檢查 | 明確檔案清單、記憶狀態、變更摘要、版本/成品判定 | 04、06、08、11 |
| 10 巡檢 | automation-safe 唯讀治理 | 自動化健康檢查、工作流漂移檢查 | 技能品質、文件一致性、矩陣覆蓋、無寫入證明 | 08、12 |
| 11 交接 | 任務交接、續接提示 | 上下文交接與任務摘要實務 | 目前狀態、髒檔、阻塞、未驗證項、下一流程 | 02、03、04、09 |
| 12 技能鍛造 | 新技能、共用技能、專案技能 | Agent Skills 規格、技能描述、漸進載入 | 層級選擇、描述品質、參考資料拆分、驗證門檻 | 03、08、10 |

## Memory Admission Matrix

Source memory writes are allowed only when the workflow has a durable, source-backed fact or active constraint to preserve. Task evidence, screenshots, raw test output, temporary observations, and preference candidates stay in reports, logs, or project context.

| 工作流 | 可寫入來源記憶 | 不可寫入來源記憶 |
|---|---|---|
| 03 建構 | Implemented and verified source facts, active constraints, tracked file ownership, stable validation route summaries | Draft plans, unimplemented assumptions, raw test output |
| 04 修復 | Confirmed root cause, still-valid repair constraint, regression route summary | Full debugging transcript, failed attempts without active consequence |
| 05 濃縮 | Source-supported project identity, tech stack, deployment, governance facts | Unapproved preferences, temporary observations |
| 06 測試 | Long-lived validation entry points, invariants, test surface decisions | Single-run logs, screenshots, fixture-only evidence |
| 08 健檢 | Evidence-confirmed long-lived governance facts, stable validation route summaries after follow-up work lands | Intermediate audit inventories, raw evidence packets, one-time performance readings, unverified guesses |
| 09 提交 | Required memory attribution or final source-memory consistency notes | Changelog prose or commit message text |
| 11 交接 | Pending memory actions and blockers as report items | Full next-agent prompt or temporary handoff narrative |

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded instead of presenting it as verified current truth.

## Official References

| 主題 | 來源 |
|---|---|
| Codex skills and instructions | https://developers.openai.com/codex/skills, https://developers.openai.com/codex/guides/agents-md |
| Claude workflows, subagents, permissions, hooks | https://code.claude.com/docs/en/best-practices, https://code.claude.com/docs/en/sub-agents, https://code.claude.com/docs/en/permissions, https://code.claude.com/docs/en/hooks |
| Antigravity browser evidence | https://antigravity.google/docs/browser |
| Agent Skills format | https://agentskills.io/specification |
| Architecture records and diagrams | https://adr.github.io/, https://c4model.com/, https://arc42.org/overview |
| Testing, performance, accessibility | https://playwright.dev/docs/best-practices, https://developer.chrome.com/docs/lighthouse/overview, https://web.dev/articles/vitals, https://www.w3.org/WAI/WCAG22/quickref/ |
| Security and reliability | https://owasp.org/www-project-application-security-verification-standard/, https://opentelemetry.io/docs/, https://sre.google/sre-book/monitoring-distributed-systems/ |
| Commit, changelog, versioning | https://www.conventionalcommits.org/en/v1.0.0/, https://keepachangelog.com/en/1.1.0/, https://semver.org/, https://docs.github.com/articles/about-status-checks |

## Usage Rules

- Workflow files must reference this matrix instead of copying every rule.
- Missing tools, missing credentials, or unsupported platform features must be reported as 未驗證 or 阻塞, not treated as success.
- Platform adapters may add stronger evidence paths, but they must not weaken the minimum evidence contract.
- 08 remains the deep full-spectrum audit baseline; other workflows use only the row relevant to their lifecycle and do not copy 08 inventory machinery unless the audit workflow is active.
