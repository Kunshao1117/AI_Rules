# Antigravity — Claude Code Edition

> **版本**: v1.1.0 | **語言**: 繁體中文 (zh-TW) | **平台**: Windows (PowerShell) + Claude Code

Antigravity Claude Edition 是 Antigravity AI 治理框架的 **Claude Code 專用版本**。
所有規則、工作流與技能已針對 Claude Code 原生工具（Write / Edit / Agent / TodoWrite / Plan Mode）完整改寫，與 Antigravity Gemini 版共享同一套設計哲學，並透過 `.agents/memory/` 共用記憶庫實現雙 AI 無縫協作。

---

## 🚀 快速安裝（終端機一行指令）

> 支援 **PowerShell 5.1+** 原生環境。倉庫為 Public，無需 GitHub 帳號。

```powershell
# 🆕 全新安裝到指定專案目錄
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\cc_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1' -OutFile $f; & $f -Target "D:\你的專案路徑"; Remove-Item $f
```

```powershell
# ⬆️ 升級現有安裝
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\cc_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1' -OutFile $f; & $f -Target "D:\你的專案路徑" -Mode Upgrade; Remove-Item $f
```

> **原理**：啟動器從 GitHub 下載 ZIP（走 CDN，無 API 速率限制），解壓後執行 `Deploy-Claude.ps1` 部署腳本，完成後自動清理暫存。

---

- [核心設計理念](#核心設計理念)
- [系統架構總覽](#系統架構總覽)
- [模組詳解](#模組詳解)
  - [部署引擎](#部署引擎)
  - [規則系統](#規則系統)
  - [工作流清單](#工作流清單)
  - [技能系統](#技能系統)
  - [專案記憶系統](#專案記憶系統)
- [與 Antigravity Gemini 版對比](#與-antigravity-gemini-版對比)
- [版本管理](#版本管理)
- [專案結構](#專案結構)

---

## 核心設計理念

| 原則 | 說明 |
|------|------|
| **零接觸部署** | 執行一行安裝指令即完成整套治理生態部署，無需人工逐一設定 |
| **雙 AI 共用記憶** | `.agents/memory/` 為唯一記憶庫，Claude Code 與 Gemini 共用，消除協作記憶分歧 |
| **Turn=1 啟動同步** | 每次新對話強制呼叫 `memory_list`，確保啟動時的記憶狀態永遠最新 |
| **按需載入** | 技能僅在需要時讀取，減少 Token 消耗與認知負擔 |
| **繁體中文特化** | 三層語言架構：指令層（英文）、介面層（繁體中文）、橋接層（雙語） |
| **最小權限治理** | 角色分層（讀取者 / 工作者 / 寫入者），子代理人只能唯讀 |
| **@import 模組化** | `CLAUDE.md` 保持 200 行以內，詳細規則透過 `@import` 按需拉入，避免 Token 膨脹 |

---

## 系統架構總覽

```mermaid
graph TB
    subgraph "Claude Edition 源碼倉庫"
        DEPLOY["Deploy-Claude.ps1<br/>部署引擎"]
        VERSION["VERSION<br/>版本追蹤"]
    end

    subgraph ".claude/ 生態系統"
        CLAUDE["CLAUDE.md<br/>主規則入口 (@import)"]
        RULES[".claude/rules/<br/>6 個模組化規則"]
        WF[".claude/commands/<br/>12 道 Slash Command 工作流"]
        SKILLS[".claude/skills/<br/>36 套操作型技能"]
    end

    subgraph "雙 AI 共用層"
        MEM[".agents/memory/<br/>跨 AI 共用記憶庫"]
        CART["cartridge-system MCP<br/>記憶卡讀寫引擎"]
    end

    DEPLOY --> |"Fresh / Upgrade 模式"| .claude/
    CLAUDE --> |"@import"| RULES
    RULES --> WF
    WF --> SKILLS
    SKILLS -.->|"memory_read"| CART
    CART <-->|"統一記憶庫"| MEM
```

---

## 模組詳解

### 部署引擎

**檔案**: `.claude/scripts/Deploy-Claude.ps1`

負責將整套 `.claude/` 生態系統移植到任何目標專案。

#### 兩種部署模式

| 模式 | 觸發條件 | 行為 |
|------|---------|------|
| **Fresh** | 專案無 `.claude/` 目錄 | 完整複製 → 建立受保護目錄 → 寫入版本檔 |
| **Upgrade** | 專案已有 `.claude/` 目錄 | SHA256 逐檔差異比對 → 彩色報告 → 確認後套用 |

#### 安全防護

- `agents/` 頂層目錄受保護，升級時不會刪除（官方子代理人槽位）
- `.agents/memory/` 在升級時永遠受保護
- 偵測孤兒檔案並標記提醒，加入 `-RemoveOrphans` 可自動清除
- `try/finally` 安全網確保部署中斷時不損壞目標專案

---

### 規則系統

**主規則**: `CLAUDE.md`（@import 模組化，< 200 行）
**詳細規則目錄**: `.claude/rules/`

| 檔案 | 定位 | 啟動模式 |
|------|------|----------|
| `core-identity.md` | 核心身份 — 代理人分工、生命週期、語言溝通 | Always On |
| `cross-lingual-guard.md` | 跨語系防護 — 冷啟動強制讀檔、Turn=1 記憶探測、實體足跡收據 | Always On |
| `code-quality.md` | 品質與安全合約 — 機密隔離、驗證器鐵律、SOLID 原則 | 條件載入 |
| `memory-contract.md` | 記憶操作規範 — 統一記憶庫路徑、Exit Hold Gate、操作流程 | 條件載入 |
| `forbidden-vocab.md` | 禁用詞彙規範 — 面向總監的商業層級詞彙對照 | 條件載入 |
| `mcp-guardrails.md` | MCP 外部工具防護 — 高風險操作的 HITL 攔截 | 條件載入 |

#### 分層治理架構

**`core-identity.md`** — 核心原則（Always On）
1. **專職化分工** — 主代理人直接執行，子代理人（Agent 工具）只能唯讀分析
2. **多代理人透明度** — 子代理人的修改必須回傳主代理人在介面呈現
3. **生命週期強制** — Plan Mode → 驗證閘門 → 實體執行 → 記憶更新
4. **禁止終端機文書處理** — 靜默閘門式攔截，支援 `[SUDO]` 覆寫
5. **繁體中文特化** — 三層語言架構（指令層英文、介面層繁中、橋接層雙語）

**`memory-contract.md`** — 記憶操作規範（條件載入）
1. **Turn=1 啟動探測** — 每次新對話強制呼叫 `memory_list` 同步記憶狀態
2. **單軌共用記憶庫** — 絕對路徑 `.agents/memory/`，禁止使用 `.claude/agents/memory/`
3. **Exit Hold Gate** — 修改原始碼後，記憶卡未更新則禁止結案

#### 雙受眾語言設計

框架中所有文件依讀者分為三層：

| 層級 | 讀者 | 語言 | 具體內容 |
|------|------|------|----------|
| **指令層** | AI 執行者 | 英文 | 技能步驟、決策樹、工作流程指令 |
| **介面層** | 總監 | 繁體中文 | 報告輸出、確認訊息、括號內註解 |
| **橋接層** | 兩者共用 | 雙語 | 記憶卡 description、小節標題 |

---

### 工作流清單

**目錄**: `.claude/commands/`（Claude Code 原生 Slash Commands）

```mermaid
graph LR
    subgraph "探索階段"
        W00["00 討論"] --> W01["01 探索"]
    end
    
    subgraph "建設階段"
        W01 --> W02["02 架構"]
        W02 --> W03["03 建構"]
    end
    
    subgraph "維護階段"
        W04["04 修復"]
        W06["06 測試"]
        W07["07 除錯"]
    end
    
    subgraph "治理階段"
        W08["08 健檢"]
        W09["09 備份"]
        W11["11 交接"]
        W12["12 技能鍛造"]
    end
```

| 指令 | 功能 | 角色權限 |
|------|------|---------|
| `/00_chat` | 純對話、腦力激盪、程式碼問答 | Reader |
| `/01_explore` | 可行性研究：網路研究 + 雙狀態魔鬼代言人分析 | Reader |
| `/02_blueprint` | 需求轉化為技術藍圖，同步初始化記憶系統 | Writer/SRE |
| `/03_build` | 兩階段建構：Plan Mode 計畫 → GO → 實體寫入 → 記憶歸卡 | Writer/SRE |
| `/03-1_experiment` | 沙盒快速實驗（所有閘門停用） | Experiment Worker |
| `/04_fix` | 兩階段修復：診斷計畫 → GO → 實體修復 → 記憶更新 | Writer/SRE |
| `/06_test` | 瀏覽器自動化視覺與功能測試 | Reader |
| `/07_debug` | 堆疊追蹤分析、錯誤翻譯為商業語言 | Reader |
| `/08_audit` | 全方位專案健康審計 | Writer/SRE |
| `/09_commit` | 授權備份：掃描 → CHANGELOG 更新 → GO → git commit + push | Writer/SRE |
| `/11_handoff` | 掃描記憶卡，產出結構化交接文件 | Reader/Memory |
| `/12_skill_forge` | 從工作實踐中提煉可複用技能 | Worker |

---

### 技能系統

**目錄**: `.claude/skills/`

技能是**按需載入的知識手冊**。Claude Code 在對話開始時僅注入技能名稱與描述（見 `_index.md`），完整內容在需要時才讀取，實現漸進式揭露。

| 類別 | 技能 | 用途 | 對接 MCP |
|------|------|------|----------|
| **記憶與架構** | `memory-ops` | 記憶卡讀寫操作指引 | cartridge-system |
| | `memory-arch` | 記憶卡架構拓樸、層級拆分規則 | cartridge-system |
| | `skill-factory` | 從工作實踐中提煉可複用衍生技能 | — |
| | `audit-engine` | 健檢語義推理引擎（S1–S5 安全架構） | — |
| **生命週期** | `tech-stack-protocol` | 技術堆疊偵測與鎖定 | — |
| | `delegation-strategy` | 任務委派管道選擇（Agent / CLI / MCP / 直接） | — |
| **品質約束** | `code-quality` | SOLID 原則、動態行數閾值 | — |
| | `security-sre` | 零信任驗證、機密隔離、日誌標準 | — |
| | `ui-ux-standards` | 介面設計、工程術語隔離 | — |
| **測試與品保** | `test-patterns` | 單元測試決策樹、異常場景清單、契約驗證 | — |
| | `impact-test-strategy` | 變更影響分析、測試範圍決策、回歸防護 | — |
| | `test-automation-strategy` | DOM 互動規範、自動修復迴圈 | — |
| | `browser-testing` | E2E 視覺測試委派 SOP | — |
| | `a11y-testing` | 無障礙掃描、WCAG 驗證、修復建議 | a11y |
| | `performance-audit` | Lighthouse 效能掃描與 Web Vitals 測量 | playwright |
| **CLI 委派** | `code-audit` | 程式碼品質與安全掃描 | — |
| | `code-diagnosis` | 大範圍原始碼故障調查 | — |
| **MCP 操作食譜** | `cloudflare-ops` | KV/D1/R2/Workers/容器管理 | cloudflare-* |
| | `github-ops` | 倉庫管理、Issue/PR 操作 | github |
| | `pr-review-ops` | PR 自動審查與合併決策 | github |
| | `supabase-ops` | 資料庫管理、SQL 操作、遷移驗證 | supabase |
| | `sentry-ops` | 錯誤追蹤與效能監控 | sentry |
| | `excel-ops` | 審計報告匯出、資料分析、圖表生成 | excel |
| | `trunk-ops` | CI 測試框架偵測與修復 | trunk |
| | `context7-docs` | 即時框架文件查詢 | context7 |
| | `maps-assist` | Google Maps API 開發輔助 | — |
| | `stitch-design` | UI 設計稿生成與規範擷取 | stitch |
| **代碼知識圖譜** | `gitnexus-guide` | GitNexus 工具清單與知識圖譜用法 | gitnexus |
| | `gitnexus-cli` | 索引倉庫、分析代碼庫、生成 Wiki | gitnexus |
| | `gitnexus-exploring` | 探索代碼架構、執行流程 | gitnexus |
| | `gitnexus-debugging` | 偵錯、追蹤錯誤來源 | gitnexus |
| | `gitnexus-impact-analysis` | 評估變更安全性、找出依賴鏈 | gitnexus |
| | `gitnexus-refactoring` | 安全重構（改名、抽取、移動代碼） | gitnexus |
| **資料庫專精** | `supabase` | Supabase 完整功能整合指引 | supabase |
| | `supabase-postgres-best-practices` | Postgres 效能最佳化與索引設計 | supabase |
| **推理輔助** | `structured-reasoning` | 架構決策深度推理（Sequential Thinking） | sequentialthinking |

---

### 專案記憶系統

**目錄**: `.agents/memory/`（與 Antigravity Gemini 版**共用**）

解決 AI「每次開新對話就失憶」的核心問題。

#### Turn=1 啟動探測流程

```mermaid
graph TD
    A["新對話開始 (Turn=1)"] --> B["呼叫 cartridge-system__memory_list"]
    B --> C{"清單內容？"}
    C -->|"有 _map"| D["呼叫 memory_read('_map')<br/>取得全局模組索引"]
    C -->|"有卡但無 _map"| E["讀取 _system，提示初始化 _map"]
    C -->|"清單為空"| F["空白專案，純對話模式"]
    C -->|"呼叫失敗"| G["記錄警告，降級至純對話模式"]
    D --> H["按任務需要，按需 memory_read 相關模組卡"]
    H --> I["執行任務"]
    I --> J["修改後更新記憶卡 (write + memory_commit)"]
```

#### 記憶卡結構

每張記憶卡是一個 `SKILL.md` 檔案，包含：

- **追蹤的檔案清單** — 這個模組負責哪些原始碼檔案
- **歷史決策紀錄** — 過去做過什麼架構選擇，以及為什麼
- **已知問題** — 目前存在但尚未處理的問題
- **模組教訓** — 可重複利用的經驗知識
- **模組關聯** — 與其他模組的相依性

#### 粒度原則

- 單張記憶卡追蹤不超過 **8 個檔案**
- 支援最多 **4 層**深度的父子巢狀結構
- 超過時系統主動提示拆分（load `memory-arch` skill）

#### 更新模式

| 模式 | 適用場景 |
|------|---------|
| `Write` + `memory_commit` | ✅ 推薦：原生工具寫入完整內容 + MCP 歸卡 |
| `replace`（備援） | MCP 不可用時的降級路徑 |

---

## 與 Antigravity Gemini 版對比

| 功能 | Antigravity (Gemini) | Claude Edition |
|------|---------------------|----------------|
| **主規則載入** | `.agents/rules/` (IDE 自動注入) | `CLAUDE.md` @import 模組化 |
| **計畫模式** | `task_boundary` 呼叫 | Claude Code 原生 `Plan Mode` |
| **檔案寫入** | `write_to_file` / `replace_file_content` | `Write` / `Edit` 工具 |
| **子代理人** | `browser_subagent` / Gemini CLI | `Agent` 工具 |
| **任務追蹤** | `.gemini` scratchpad Artifact | `TodoWrite` 清單 |
| **工作流觸發** | `.agents/workflows/` (IDE 注入) | `.claude/skills/` (Slash Command) |
| **記憶啟動** | D7 Push 三路徑探測 | Turn=1 啟動探測協議 |
| **記憶存放** | `.agents/memory/` | `.agents/memory/`（**共用**） |
| **操作型技能** | `.agents/skills/` (36 個) | `.claude/skills/` (36 個) |
| **規則數量** | 9 個（含 AGENTS.md 哨兵） | 6 個模組（@import） |
| **工作流數量** | 17 道 | 12 道 |

---

## 版本管理

| 檔案 | 用途 |
|------|------|
| `VERSION` | 單行版本號（例如 `1.1.0`） |
| `CLAUDE.md` | 版本號顯示於文件標頭 |

升級時部署引擎採用 **SHA256 差異比對**策略，確保只更新真正有變化的檔案。`CLAUDE.md` 與 `.agents/memory/` 在升級時永遠受到保護。

---

## 專案結構

```
Claude/
├── VERSION                      ← 框架版本號
├── install.ps1                  ← 一鍵安裝啟動器
├── README.md                    ← 本文件
│
└── .claude/
    ├── CLAUDE.md                ← 主規則入口（@import 模組化，< 200 行）
    ├── rules/                   ← 詳細規則（被 CLAUDE.md @import）
    │   ├── core-identity.md     ← 核心身份（Always On）
    │   ├── cross-lingual-guard.md ← 跨語系防護（Always On）
    │   ├── code-quality.md      ← 品質與安全合約（條件載入）
    │   ├── memory-contract.md   ← 記憶操作規範（條件載入）
    │   ├── forbidden-vocab.md   ← 禁用詞彙規範（條件載入）
    │   └── mcp-guardrails.md    ← MCP 外部工具防護（條件載入）
    ├── commands/                ← Slash Command 工作流（12 道）
    │   ├── 00_chat(討論)/
    │   ├── 01_explore(搜索)/
    │   ├── 02_blueprint(架構)/
    │   ├── 03_build(建構)/
    │   ├── 03-1_experiment/
    │   ├── 04_fix(修復)/
    │   ├── 06_test(測試)/
    │   ├── 07_debug/
    │   ├── 08_audit(除錯)/
    │   ├── 09_commit(紀錄)/
    │   ├── 11_handoff(交接)/
    │   └── 12_skill_forge(技能鍛造)/
    ├── skills/                  ← 操作型知識庫（36 個，按需讀取）
    │   ├── _index.md            ← 技能索引
    │   ├── memory-ops/
    │   ├── memory-arch/
    │   ├── code-quality/
    │   ├── github-ops/
    │   ├── gitnexus-*/          ← 代碼知識圖譜（6 個）
    │   └── ...                  ← 其餘 27 個技能
    ├── agents/                  ← 官方子代理人槽位（保留）
    └── scripts/
        ├── Deploy-Claude.ps1        ← 部署引擎（try/finally + 彩色差異報告 + VERSION）
        ├── Invoke-DocScan.ps1       ← 倉庫衛生掃描（輸出 .agents/logs/doc_scan.md）
        ├── Invoke-HealthAudit.ps1   ← 安全健檢（憑證掃描 + 效能指引）
        └── Measure-SkillQuality.ps1 ← 技能品質掃描（行數/Token/Frontmatter）

.agents/memory/                  ← 專案記憶（與 Gemini 版共用，升級時受保護）
    └── (由 AI 執行 /02_blueprint 初始化)
```
