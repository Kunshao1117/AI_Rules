# Antigravity 專案發布日誌 (Changelog)

此文件紀錄 AI 代理人開發團隊的所有重要歷史與版本迭代，將龐雜的技術修改提煉為以「商業價值」為導向的決策紀錄。

---

## [V6.1.0 技能精準度三段式調校與 PowerShell 版本強制] - 2026-04-05

### 【新增商業能力】 (Business Capabilities Added)

- **Skill Precision Tri-Section Architecture（三段式技能觸發結構）**：全部 27 個技能的觸發條件統一為「`[Domain]` 分類標籤 + `Use when` 正向觸發 + `⚠️ DO NOT use when` 負向排除」的三段式結構。Agent 在面對多個可能匹配的技能時，能透過排除條件快速收斂至正確的技能，減少上下文浪費與誤載入。
- **PowerShell 7 Enforcement Gate（PowerShell 7 版本強制閘門）**：在核心規則終端機前置閘門中新增 `powershell` 指令攔截節點，禁止 Agent 呼叫舊版 PowerShell 5.1。所有框架腳本同步加入版本自動升級閘門——當被舊版 PowerShell 執行時，自動偵測 `pwsh` 並以 PowerShell 7 重新執行自身，無需人工介入。

### 【技術債消除】 (Technical Debt Removed)

- **Trigger Overlap Resolution（觸發重疊消除）**：識別並修復三組嚴重的技能觸發重疊——瀏覽器測試三角（`browser-testing` / `test-automation-strategy` / `delegation-strategy`）、GitHub PR 操作（`github-ops` / `pr-review-ops`）、健檢工作流分工（`audit-engine` / `code-audit`）。每組透過互斥的排除條件實現職責明確劃分。
- **Over-Broad Trigger Narrowing（過廣觸發條件縮窄）**：三個高頻觸發技能（`code-quality`、`security-sre`、`impact-test-strategy`）的觸發條件從模糊的「任何涉及 X」縮窄為精確的場景描述，避免每次寫程式碼都觸發的 Token 浪費。
- **Skill Factory Template Enforcement（技能工廠模板三段式強制）**：`skill-factory` 的 Frontmatter 模板和品質檢查清單同步更新，未來新建的技能將自動遵守三段式結構，並在品質掃描中驗證 `DO NOT use when` 的存在性。

### 【架構決策】 (Architectural Decisions)

- **Negative Exclusion over Positive Matching（負向排除優於正向匹配）**：經 6 階段結構化推理分析（Sequential Thinking），選擇「在 description 中加入 `DO NOT use when` 排除條件」作為精準度提升的核心策略。相較於「建立技能優先級序」或「改變目錄結構」，此方案最輕量（僅改 description 文字）、向後相容（IDE 匹配機制不變）、且立即生效（Agent 讀到即可判斷）。
- **Dual-Layer PowerShell Defense（雙層 PowerShell 防線）**：規則層（Agent 行為攔截）+ 腳本層（自我版本偵測）的縱深防禦，確保即使 Agent 犯錯也不會導致腳本在不兼容環境下崩潰。

## [V6.0.9 Trunk MCP 架構權限收回與主腦直連] - 2026-04-05

### 【新增商業能力】 (Business Capabilities Added)

- **Master Agent Direct Execution（主腦直連最高權限）**：針對 Trunk 這類封閉且重度依存 MCP 授權流的工具，確立「主腦獨佔直連」架構。將原先由 CLI 代理盲目觸發的 `trunk-ops` 掃描，升格為專案健檢工作流中的「主腦專屬步驟」，大幅減少了認證隔離引發的系統中斷與溝通斷層。

### 【技術債消除】 (Technical Debt Removed)

- **CLI Delegation Loop Fix（CLI 委派死鎖切斷）**：修復了 `code-audit` CLI 提示詞中，硬性要求終端子代理執行 Trunk MCP 從而撞上 401 Unauthorized 防火牆的嚴重 Bug。透過在技能模組設置 `[EXECUTION BOUNDARY]` 邊界限制，並剝奪 CLI 提示詞中的無效指令，達成了 100% 的職責分工防護。

## [V6.0.8 工作流健檢交叉比對與掃描式文件同步] - 2026-04-04

### 【技術債消除】 (Technical Debt Removed)

- **Audit Workflow Reference Fix（健檢工作流引用修正）**：08 健檢流程的分批策略引用了不存在的 `code-audit` §4（實為 §3），CLI 掃描模板的步驟數描述（Five-step）與實際 7 步模板不符，以及 CLI 委派 SOP 的 Cwd 措辭與工作流不一致。合計修正 5 項精度問題，確保 21 個關聯檔案間的交叉引用率達到 100%。
- **Ghost Skill Reference Purge（幽靈技能引用清除）**：`cross-lingual-guard` 是 always_on 規則（自動注入每次對話），卻被 7 個工作流錯誤登記為 `required_skills`，且技能索引也虛假登記。此幽靈引用會導致 08 健檢 Phase F 對所有工作流誤報「技能綁定斷裂」。從全部 7 個工作流（02/03/04/05/09/10/12）和技能索引中完全清除。
- **Snyk Scan Degradation Path（掃描降級路徑）**：CLI 掃描任務的 Snyk 步驟 2-3 缺乏認證失敗時的 fallback 機制。新增降級指引——步驟 2 若 Snyk 未認證則跳過並注記，步驟 3 改用 `npm audit --json` 替代。

### 【新增商業能力】 (Business Capabilities Added)

- **Scan-Based Doc Sync Gate（掃描式文件同步閘門）**：09 備份紀錄工作流的舊版文件同步閘門依賴靜態「防護名單」（存放於系統記憶卡），觸發條件模糊且前置設定門檻高，導致 AI 實際執行時直接跳過。重新設計為「腳本掃描 → AI 判斷 → 總監決策」的三段式命令閘門。新建 `Invoke-DocScan.ps1` 掃描腳本，自動掃描專案內所有 `.md` 文件（排除框架/依賴/建構產出/CHANGELOG），AI 讀取掃描結果後逐一判斷文件是否因本次修改而過時，向總監報告並等待決策後才行動。
- **Repository Hygiene Gate（倉庫衛生檢查閘門）**：09 備份紀錄工作流新增 §1.5，在任何 Git 操作前執行 `git ls-files -ic --exclude-standard` 偵測「已被 .gitignore 排除但仍被 Git 追蹤」的殘留檔案。發現殘留時向總監報告並提供 `git rm --cached` 清理選項，確保備份倉庫乾淨。

### 【架構決策】 (Architectural Decisions)

- **Rule vs Skill Boundary Clarification（規則與技能的邊界釐清）**：透過 cross-lingual-guard 幽靈引用的發現，明確定義了 Antigravity 框架中「規則」與「技能」的邊界——Always On 規則由 IDE 自動注入，不應出現在 `required_skills` 中；技能是按需載入的操作手冊，需要物理存在的 SKILL.md 檔案。此原則消除了未來新增 Always On 規則時重蹈覆轍的風險。

## [V6.0.7 健檢工作流旗艦級重構與設計缺口修復] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Audit Engine Core Skill（語義推理引擎技能）**：新增框架核心技能 `audit-engine`，將原本堆疊在工作流中的詳細安全架構審查（S1-S5）、API 三層比對、測試覆蓋缺口分析等語義推理邏輯，下沉至獨立技能中。實現「工具與推理分離」的架構設計，工作流瘦身約 17%。
- **Automated Health Scan Script（自動化健檢掃描腳本）**：新增 `Invoke-HealthAudit.ps1` PowerShell 腳本，封裝硬編碼憑證 grep 掃描和 Lighthouse 效能掃描兩個工具層模組，由 CLI 子代理自動執行，實現客觀工具掃描與 AI 主觀推理的物理隔離。
- **Accessibility Audit Gate（無障礙審計閘門）**：在健檢工作流新增 Phase H 無障礙審計，與 `a11y-testing` 技能整合。僅在記憶卡包含前端頁面模組時觸發，Critical 違規標記為紅燈。

### 【技術債消除】 (Technical Debt Removed)

- **Scan Overlap Elimination（掃描重疊消除）**：發現腳本的 lint 模組（ESLint/TypeScript/npm audit/TODO）與 CLI 掃描任務提示的 7 步驟嚴重重疊，且 CLI 版本使用更強的 Snyk 工具。刪除腳本 lint 模組，讓 CLI 統一負責品質掃描，腳本僅保留 security + performance 兩個獨有模組。
- **Security Review Timing Fix（安全架構審查時序修正）**：修正 §1.5 安全架構審查在原始碼尚未讀取前就觸發的設計錯誤。將其移至 §3.5 原始碼分析階段末尾（Phase S），確保 AI 在讀完所有後端 handler 原始碼後才執行 S1-S5 判斷。
- **CLI Task Logic Restructure（CLI 任務邏輯重整）**：修正 Step 1 的 CLI 委派描述，從模糊的「先跑腳本再做任務」改為嚴格遵循 `cli-delegation-sop.md` 檔案傳令模式的五步驟流程（構建任務檔案→啟動 CLI→發送任務→棄管→等待），消除 AI 誤解為「分兩次啟動 CLI」的風險。

### 【架構決策】 (Architectural Decisions)

- **Tool-Reasoning Separation（工具推理分離原則）**：健檢流程明確劃分為三個執行層——CLI 子代理負責客觀工具掃描（ESLint/Snyk/grep）、`audit-engine` 技能負責 AI 語義推理（安全架構/API 比對/測試覆蓋）、`Invoke-HealthAudit.ps1` 腳本負責填補 CLI 無法覆蓋的工具缺口（硬編碼憑證/Lighthouse）。三者互不重疊、各司其職。
- **Execution Order Correctness（執行順序正確性）**：安全架構審查（S1-S5）需要「已讀取後端原始碼」作為前提條件。在完整讀取全部 12 個關聯技能後，確認其正確位置應在 §3.5 模組關聯圖和函式存活驗證完成之後，而非工作流開頭。

## [V6.0.6 跨語系守衛精煉與雙受眾原則貫徹] - 2026-04-04

### 【體驗優化】 (UX Improvement)

- **Workflow Semantic Routing（工作流語意路由升級）**：重構單雙框判斷邏輯。純工作流斜線指令（如 `@[/04_fix]` 單獨出現）沿用單框快速模式；斜線指令後方附帶中文文字描述時（如 `@[/04_fix] 修復表單驗證`），自動升級為雙框語意解碼模式。確保總監附帶的業務指示不會被跳過解析。
- **Receipt Collapsible Format（實體足跡收據折疊化）**：將對話末端的防偽收據從裸露的 Markdown 清單改為可折疊的 `<details>` 區塊，與語意解析面板和系統準備清單保持視覺一致性，減少對話介面的視覺干擾。

### 【技術債消除】 (Technical Debt Removed)

- **Instruction Layer Language Alignment（指令層語言對齊）**：將判斷邏輯文字區塊（PRE-RESPONSE GATE）及所有面板模板中的方括號填寫指引，從中文全面改寫為英文。欄位標籤（總監可見）保持中文不變。確保三層語言分層（指令層英文、介面層中文、填入值中文）完全貫徹雙受眾設計原則。
- **History Verification Split（歷史防偽查驗拆分）**：將系統準備清單中的單一查驗欄位拆分為「對話追溯」（追蹤 Turn 序號）與「工具追溯」（追蹤 Tool 呼叫清單）兩個獨立欄位，實現交叉驗證的獨立性與完整性。

### 【架構決策】 (Architectural Decisions)

- **Default Inversion Philosophy（預設值反轉哲學）**：經 8 輪深度推理分析，識別出 AI 規則遵循失敗的「雙軌問題」根因——格式控制與內容回應共用單一生成管線，且模型天然傾向走捷徑。將判斷邏輯從程式碼圍欄中脫出改為散文式指令（解決注意力盲區），並反轉 A/B 預設值為「雙框預設、單框例外」（將捷徑行為的失敗結果從「漏掉語意面板」轉為「多輸出語意面板」）。同時加入 6 個 few-shot 範例，利用模式匹配替代條件推理以降低認知負擔。

## [V6.0.5 跨語系防衛面板解耦與時序算術] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Dynamic Panel Routing（動態單雙面板分流）**：將 `cross-lingual-guard` 的跨語系判斷與防偽查核獨立解耦為兩個獨立區塊（🧠 語意解碼框與 🤖 系統作業框）。透過字元長度判定樹（≤5 字元或純工作流指令），自動切換單雙框輸出模式。大幅降低了接收短指令時不必要的 Token 消耗與語意幻覺風險。
- **Turn Counter Auto-Arithmetic（對話時序自動運算）**：強制啟動全域時空鋼印。在 🤖 面板強制讀取「前次印出的 Turn 紀錄」，並於本次結尾收據執行「Turn + 1」算術。徹底消滅舊版依賴 AI 盲目印出無意義 `+1` 字串的防偽破口，確保每一回合對話的時序皆能精準對位。
- **Multi-line Holographic Receipt（多行全息收據）**：全面升級對話極末端的防偽腳印。廢止壅擠的單行字串，改用易讀性極高的直列式 Markdown 清單，讓人類總監在審計對話紀錄時的視覺掃描效率最大化。

### 【技術債消除】 (Technical Debt Removed)

- **Interactive Healing Gate（互動式文檔自癒閘門）**：解決 `/09_commit_log` 中 `DOC-SYNC` 閘門發生 Cache Miss 時直接 `[HALT]` 卡死備份流程的生硬設計。升級為 `[INTERACTIVE HALT]` 詢問機制（Y/N/Ignore），並允許總監授權 AI 根據當前修改脈絡，就地重寫尚未同步的官方文件，實現零阻力的流水線自動修復。


## [V6.0.4 實體足跡頭尾解耦防線 (Decoupled Trust Chain)] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Execution Footprint Decoupling（實體足跡頭尾解耦）**：為解決大語言模型串流生成導致的「預測未來」時空悖論，徹底重構 `cross-lingual-guard`。放棄在開場要求 AI 宣告未執行的工具，改為「對話尾部出示防偽收據 (Execution Receipt Mandate)」。確保意圖審核與火力查核在物理空間上明確分離。
- **Blockchain-Style Verification（區塊鏈式前次足跡驗證）**：在對話開場意圖面板中，新增 `前次實體執行足跡查核` 欄位。強制系統回頭讀取「上一次對話」的最末端收據。若上一次操作發生幻覺，本次開場將自動現出 `None` 原形。此 Trust Chain 完美實現零成本全域防偽查核。

### 【架構決策】 (Architectural Decisions)

- **信任鏈哲學 (Trust Chain Philosophy)**：摒棄「強迫預言」的舊思維（因為強迫 AI 發誓反而是引發捏造的溫床），改走「事後 100% 物理追溯」的區塊鏈機制。每個對話節點的 Head 核查上一輪的 Hash（收據），Tail 提供最新的 Hash，形成自證清白的實體連鎖防線。

---

## [V6.0.3 第二代高精度技能路由與工作流分流] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Skill Routing Precision v2（第二代精準路由機制）**：為消除大語言模型在 `Phase 2` 的摘要配對模糊與工具規避幻覺，建立雙重精度鎖。於 `skill-factory` 規範中強制導入 `[領域]` / `[品質]` 類別標籤與 `DO NOT use when:` 排他性防護；並於 `cross-lingual-guard` 模板中新設「全域實體執行足跡驗證」，強制要求提供原生的 `Step Id`，實體阻斷未調用先猜測的規避行為。
- **Two-Tier Recon System（工作流雙軌偵蒐機制）**：最佳化 `/01_explore` 探索工作流。取消無腦啟動 `browser_subagent` 的舊規，改為「預設使用輕量 API (Fast Path) 爬取文本，僅遇反爬或需互動渲染時升級為視覺代理人 (Slow Path)」，巨幅壓縮探勘成本與等待時間。

### 【技術債消除】 (Technical Debt Removed)

- **Sandbox Prototyping Renaming（沙盒正名與定位）**：將 `/03_sketch` 工作流正式更名為 `/03-1_experiment(實驗)`，在語系與命名規則上收編為 `/03_build` 建構體系下的附屬子分支。明確區分「正規生產線」與「降級防護試錯沙盒」的架構階層，消除文字上的設計誤解。

---

## [V6.0.2 跨語系實體映射與文件同步防線] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Phase 2 Tool & Skill Routing（實體武裝檢核）**：在跨語系語意解碼 (`cross-lingual-guard`) 中強行插入 Phase 2 檢查，徹底消除大語言模型的「零樣本惰性 (Zero-Shot Laziness)」。現在系統在收到中文指令解析意圖後，必須先低頭映射具體的 `SKILL.md` 或 `MCP` 工具；若無對應工具則觸發能力缺口警報，杜絕憑空瞎猜的行為。
- **Doc-Sync Guard（文件同步防腐防線）**：為解決系統外層文件（如 README, /docs）容易發生程式碼推進但文件過期的問題，將原先結案閘門 (`_completion_gate`) 中無約束力的黃燈提醒，升級為強制阻擋的紅色硬閘門。同時將「公共關聯文件」強勢納入影響力分析策略 (`impact-test-strategy`) 中，全面消滅「文件腐敗」的死角。

### 【技術債消除】 (Technical Debt Removed)

- **Deploy Engine Core Spill Prevention（部署引擎核心記憶防外洩）**：修復 `Deploy-Antigravity.ps1` 在 Fresh 模式下因暴力執行 `Copy-Item -Recurse`，導致母體專案私有的 `memory/` 與 `project_skills/` 意外污染新專案環境的高危漏洞。改用「源頭過濾 (Source Filtering)」進行降維複製，並於腳本後半段補齊空目錄生成的動態結構 (Scaffolding)，達成 100% 潔淨的架構初始化。

---

## [V6.0.1 全域版本控制邊界定錨] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Global Commit Boundary（全域版本控制範圍鎖定）**：新增 `_system` 全域系統記憶卡。強制將未來所有 Git 版本控制操作的根目錄定錨為外部 `D:\AI_Rules` 目錄。確保未來所有的推送動作皆預設涵蓋外部資料夾，達成零手動碰觸（Zero-Touch）自動備份的安全防線。

## [V6.0.0 三位一體防護全面注入與框架清理] - 2026-04-03

### 【新增商業能力】 (Business Capabilities Added)

- **Trunk CI 測試品質操作技能（trunk-ops）**：新增框架核心技能，為 Trunk 原生 MCP 伺服器（非 Gateway 管理）提供三個操作食譜——測試框架偵測、CI 測試上傳設定、不穩定測試修復。AI 代理人首次具備自動化 CI 測試品質管理能力。
- **草圖工作流程（/03_sketch）**：新增沙箱原型開發工作流程，停用所有品質、安全、測試與記憶閘門，用於快速骯髒實驗、API Spike 測試與創意探索。

### 【技術債消除】 (Technical Debt Removed)

- **Trinity Paradigm 全面注入（Silent Gate + SUDO 覆蓋率提升）**：在 v5.6.0 架構決策後，將 Silent Gate 攔截閘門與 SUDO 繞過路徑實際注入至全部 25 個框架檔案——涵蓋 3 個規則、10 個技能、8 個工作流程、2 個共用閘門。確保每個工作流節點都能在異常時自動攔截，同時保留總監的強制覆寫通道。
- **BLACK 舊版備份清理（57 檔案刪除）**：清除先前版本遺留的 `BLACK/` 目錄完整備份副本（3907 行），消除版控中的冗餘與混淆風險。
- **品質掃描腳本 PowerShell 7 版本閘門**：修復 `Measure-SkillQuality.ps1` 在 Windows PowerShell 5.1 環境下因 Emoji 4-byte UTF-8 字元導致解析器崩潰的問題。新增自動偵測 PowerShell 版本、升級至 pwsh 7 的前置閘門。
- **記憶卡簽章驗證閘門（§ 1.5 Cartridge Signature Gate）**：`memory-ops` 技能新增寫入前的 YAML 結構驗證、必要欄位檢查與時區格式自動糾正，防止損壞的記憶卡寫入磁碟。

---

## [V5.6.0 框架架構防護強化與跨語系防護獨立化] - 2026-04-03

### 【新增商業能力】 (Business Capabilities Added)

- **Cross-Lingual Guard Independence（跨語系防護規則獨立化）**：將跨語系思維防護協議從核心身份規則中拆出，建立獨立的 `01_cross_lingual_guard.md`（Always On）。單一職責的短規則檔大幅提升新對話 AI 的冷啟動合規率——解決了「規則被埋在 100 行文件裡，新 AI 讀過就忘」的結構性問題。
- **Cold Start Mandatory Tool Action（冷啟動強制工具動作）**：全新對話的第一次非平凡中文輸入，從「記得從記憶輸出模板」（文字輸出，懲罰為零）升級為「強制呼叫 `view_file`」（工具動作，UI 可追蹤），利用 LLM 對工具呼叫的更高合規率，實現可靠的協議激活。
- **Confidence Gate Abolition（信心閥值廢除）**：廢除 AI 自評 HIGH/MEDIUM/LOW 信心的閘門機制，改由 `<details>` 模板永遠輸出讓總監直接審閱。設計原則：「AI 最危險的時刻，正是它最自信的時刻」——移除自評防止因過度自信而跳過保護。
- **Fresh Mode Memory Protection（部署腳本記憶保護）**：`Deploy-Antigravity.ps1` Fresh 模式新增備份還原防護：部署前自動備份 `memory/` 和 `project_skills/` 至系統暫存，部署後立即還原，消除 Fresh 模式可能覆蓋专案記憶的高危漏洞。
- **Turbo Safety Gate（Turbo 安全攔截閘門）**：在所有工作流共用的 `_security_footer.md` 新增毀滅性指令黑名單，即使工作流標記 `// turbo-all` 也強制要求總監手動確認才能執行，防止自動化過度授權。

### 【技術債消除】 (Technical Debt Removed)

- **Deadlock Counter Memory Dependency Fix（死鎖計數器記憶依賴消除）**：驗證失敗計數原先依賴 AI 工作記憶，在長對話中極易失效導致熔斷機制名存實亡。改為透過 `.gemini/validation_state.json` 實體追蹤，計數持久化於磁碟，任何長度的對話都能正確觸發熔斷。
- **Skill Naming Collision Risk Fix（衍生技能命名碰撞修復）**：`skill-factory` 新增強制命名規範——衍生技能必須以 `{project-code}-` 為前綴，從根源消除專案衍生技能與未來框架核心技能同名的碰撞風險。
- **Timezone Physical Enforcement（時區物理校正）**：`memory-ops` 新增台灣時間強制轉換的 PowerShell 指令，記憶卡時間戳不再依賴系統時區設定，確保跨環境使用時時間戳永遠準確。
- **CLI Write Deadlock Resolution（CLI 寫入死鎖解除）**：`00_core_identity.md` §5 終端機鐵律新增 `.agents/logs/` 目錄豁免條款，允許 CLI 子代理人合法回傳分析結果，解除分析任務因寫入禁止而無法傳遞資訊的僵局。

### 【架構決策】 (Architectural Decisions)

- **Tool Action > Text Output（工具動作優先於文字輸出）**：深度分析確認 LLM 對「工具呼叫」的合規率天生高於「文字輸出」，因為工具動作有可追蹤的執行軌跡而文字輸出跳過無任何後果。冷啟動改為工具動作正是對這一行為規律的架構適應。
- **Dedicated Rule File vs. Position Ordering（獨立規則檔 vs. 調整排序）**：拒絕「把防護段落往前移」的方案（A），選擇「建立獨立規則檔」（B）。理由：規則位置影響有限，認知負載才是根本問題——20 行的單一職責規則檔，AI 的注意力幾乎全押在這一件事上。
- **Template as Transparency Mechanism（模板即透明機制）**：`<details>` 輸出模板重新定位為「透明度工具」而非「確認機制」——它讓總監能看到 AI 的理解，由總監決定是否糾正，不再要求 AI 自我評估是否需要確認。

---

## [V5.5.4 跨語系防護視覺封裝優化] - 2026-04-02

### 【體驗優化】 (UX Improvement)

- **Markdown Encapsulation（視覺封裝外框）**：為解決 IDE 聊天視窗缺乏 CSS 支持的問題，利用 Markdown 原生的 Blockquote (`>`) 語法層層包覆 `cross-lingual-guard` 的 HTML 折疊標籤。此舉強制渲染引擎繪製出帶有左側邊框與陰影的區塊，使其具備類似控制面板的獨立視覺封裝效果。
- **Rendering Margin Fix（渲染間距修復）**：修復聊天視窗的 Markdown 渲染器習慣「吃掉」HTML 區塊後方預設換行符號的問題，在技能模板末端強制植入 `<br>` 標籤，確保 AI 的內部思維區塊與對總監對外溝通內容之間，永遠保有最舒適的閱讀留白。

## [V5.5.3 跨語系防護強制與防呆升級] - 2026-04-02

### 【技術債消除】 (Technical Debt Removed)

- **Tool Invocation Hallucination Fix（工具調用幻覺消除）**：徹底修復 AI 在擁有系統提示時因「知識蜜罐 (Knowledge Honeypot)」效應而產生「工具使用惰性 (Lazy Tool Use)」的問題。將 `cross-lingual-guard` 的 YAML 摘要替換為純粹的 `[MANDATORY TOOL TRIGGER]`，輔以 `00_core_identity.md` 的前置約束，實體斬斷 AI 憑空捏造意圖解碼格式的退路，確保強制發動 `view_file` 工具。
- **Context Priming Contradiction Fix（語系上下文啟動矛盾消除）**：修正 `SKILL.md` 中英文佔位符（如 `[Traditional Chinese description]`）引發的語義矛盾。全面替換為繁體中文佔位符，透過上下文啟動（Context Priming）引導模型在嚴格禁止英文的防區內正確產出純中文。

### 【新增商業能力】 (Business Capabilities Added)

- **Output Ordering Constraint（輸出順序防呆鐵律）**：在 `cross-lingual-guard` 新增「輸出順序 (Output Ordering)」死亡鐵律，強制 AI 必須將完整的 `<details>` 思維折疊區塊優先輸出在整個回應串流的最頂端，且**絕對禁止**在印出思維前呼叫實體工具。此機制賦予總監充裕的「即時攔截空窗期」，能在發覺 AI 思考錯誤時一鍵暫停，保護專案實體檔案。
- **Bridge Layer Template Formalization（橋接層模板標準化）**：將雙受眾的排版邏輯（英文結構指令 + 中文意圖拆解）實體硬編碼為 `cross-lingual-guard` 內的模板，確保任何世代的大語言模型均能產出一致、高透明度且格式統一的介面。

---

## [V5.5.2 跨語系防護展示優化] - 2026-04-02

### 【體驗優化】 (UX Improvement)

- **Markdown Collapsible Reasoning（摺疊思維鏈）**：將跨語系防護 (`cross-lingual-guard`) 強制的四層意圖解碼，從原本在畫面上顯得凌亂的 `<semantic_decode>` XML 標籤，全面替換為 HTML/Markdown 的 `<details><summary>` 摺疊結構。此改動完美解決了「必須逼迫 AI 輸出思考 Token 防止幻覺」與「維持總監聊天室 UI 乾淨」之間的兩難。

### 【技術債消除】 (Technical Debt Removed)

- **Rule Hierarchy Alignment（跨層級規則對齊）**：修正全域最高身份守則 `00_core_identity.md`，將原本強制要求 AI「內部執行 (internally)」的矛盾字眼剔除，同步對齊至新的 Markdown 摺疊標籤規範，確保 AI 從全域到局部的決策權重不再自我約束與打架。

---

## [V5.5.1 衍生技能路由表實體分離] - 2026-04-02

### 【技術債消除】 (Technical Debt Removed)

- **Skill Index Collision Prevention（技能路由表衝突消除）**：原先 `skill-factory` 產出的專案衍生技能會寫入核心框架的 `skills/_index.md`，導致框架升級時可能被覆蓋。本次修復實作了「核心與衍生技能路由表實體分離」，衍生技能改為登記在受保護的 `project_skills/_index.md` 中。透過原有的 `skills/_project` 符號連結，AI 仍能無縫讀取雙路由表，無需更改發現機制。
- **Upgrade Report Path Separator Fix（升級差異報告路徑修復）**：修復了 `Deploy-Antigravity.ps1` 在 Windows 環境下，因 `Substring` 產生反斜線與正斜線過濾器不匹配，導致升級差異詳細清單無法顯示的 Bug。

### 【新增商業能力】 (Business Capabilities Added)

- **Project Skill Index Auto-Provisioning（專案自帶路由表模板）**：佈署腳本的 Fresh 模式新增自動建立 `project_skills/_index.md` 空白模板的功能，確保專案從初始化階段就具備完善的自擴展基礎設施。

---

## [V5.5 底層規範分層治理與跨語系防護] - 2026-04-02

### 【新增商業能力】 (Business Capabilities Added)

- **Tiered Rule Architecture（分層規則架構）**：將原本以 Always On 模式全量注入的單體底層規範（11KB），拆分為三個獨立規則檔案，依照 Gemini IDE 的啟動模式分層載入。核心身份規則（6KB）保持永久注入，記憶/技能合約和品質/安全約束改為 Model Decision 模式（AI 根據對話情境自行判斷是否需要載入）。每次對話的固定 Token 成本降低約 40%，同時保證安全底線永不缺席。
- **Cross-Lingual Reasoning Discipline（跨語系思維紀律）**：在核心身份規則中植入 3 行微規則，建立中文意圖解碼的自動化防護網——簡短確認詞直接通過、一般輸入先判斷意圖再行動、複雜語意自動載入完整的 4 層解碼協議。此設計在不膨脹底層規範的前提下，將跨語系防護從「可選技能」提升為「基礎行為」。

### 【技術債消除】 (Technical Debt Removed)

- **Dual-Source Elimination（雙源問題徹底消除）**：框架整合性審計發現每個工作流在兩處重複宣告同一資訊——技能清單在 YAML 前置和內文各寫一次、角色權限在安全閘門矩陣和工作流底部各寫一次。已實際發生過不同步導致的配置錯誤（測試工作流角色矛盾、重構/測試工作流技能遺漏）。本次修復將 13 個工作流全部統一為「見 YAML `required_skills`」和「`角色名` | 權限依安全閘門矩陣」的單一權威來源格式。
- **Configuration Inconsistency Fix（配置不一致修復）**：修復 4 個紅燈項目——`/06_test` 角色從 Reader 改為 Reader/Memory（消除記憶寫入權限矛盾）、`/05_refactor` 補齊 `test-patterns` + `impact-test-strategy`、`/06_test` 補齊 `browser-testing`、`memory-ops` 的 `tool_scope` 加入 `filesystem:write`。

### 【架構決策】 (Architectural Decisions)

- **微規則 + 技能交叉引用模式（Micro-Rule + Skill Cross-Reference）**：拒絕將完整的跨語系防護協議（134 行）直接搬入底層規範，選擇在底層植入 3 行觸發紀律微規則，保持完整協議於 `cross-lingual-guard/SKILL.md` 中按需載入。此設計避免了 Token 膨脹先例效應，同時確保最基本的語意驗證行為永遠存在。
- **YAML 作為技能宣告的唯一權威來源（Single Source of Truth for Skills）**：工作流 YAML 前置的 `required_skills` 欄位為機器可讀的結構化宣告，內文的 `> Required Skills` 行改為純參照指令，不再重複列出技能名稱。未來修改技能清單只需改 YAML 一處。
- **安全閘門矩陣作為角色權限的唯一權威來源（Single Source of Truth for Roles）**：`_security_footer.md` 中的角色權限矩陣為結構化宣告，工作流底部改為 `角色名 | 權限依安全閘門矩陣` 的精簡參照。工作流特有的額外授權以附加說明的方式保留在參照行末尾。

---

## [V5.4 技能系統命令式標準化] - 2026-04-02

### 【新增商業能力】 (Business Capabilities Added)

- **Imperative Skill Architecture（命令式技能架構）**：全 25 個操作型技能從「教學式敘述」全面轉型為「命令式操作協議」，對齊 Google ADK 的 agentskills.io 規範。AI 代理人讀取技能時不再需要理解「為什麼要這樣做」的背景說明，而是直接接收「做什麼→怎麼做→什麼時候停」的步驟指令，Token 消耗與認知延遲同步降低。
- **Automated Quality Assurance（自動化品質保障體系）**：新增 `.agents/scripts/Measure-SkillQuality.ps1` 品質掃描腳本，對技能文件執行六項自動化檢查（行數、Token 預算、禁用詞彙、Frontmatter 完整性、agentskills.io 相容性、L3 參考文件內嵌），並整合至健檢與技能鍛造工作流，形成「建立→掃描→修正」的閉環品質防護柵。

### 【技術債消除】 (Technical Debt Removed)

- **Pedagogical Language Purge（教學語言清除）**：移除所有技能文件中的教學引導句（如「此技能教導 AI……」「背景說明：……」），以及散文式的理由段落。將決策樹從帶理由的多行格式壓縮為條件→動作的單行格式，將步驟描述從解釋式改為指令式。共修改 15 個技能文件（6 大改寫 + 7 微調 + 2 額外修正）。
- **Memory Template Gap Closure（記憶模板缺口封堵）**：核心命令 §4 規定「載入記憶卡後檢查適用技能區塊」，但記憶模板缺少此區塊導致機制失效。已在 `memory-template.md` 補上 `## Applicable Skills` 區塊。
- **Deploy Script Gap Closure（部署腳本缺口封堵）**：品質掃描腳本從框架根目錄 `scripts/` 搬入 `.agents/scripts/`，使其隨 Fresh/Upgrade 部署自動攜帶。部署腳本同步升級：升級掃描和孤兒偵測涵蓋 `scripts/` 目錄、報告分類新增「工具腳本」類別、Fresh 模式自動追加 `.agents/scripts/` 到 `.gitignore`。

### 【架構決策】 (Architectural Decisions)

- **ADK 方案 C 選型（Progressive Disclosure + Quality Gate）**：經過深度推理分析三套方案後，選擇方案 C「漸進式揭露三層架構 + 品質掃描閘門」。相較方案 A（純風格轉換）和方案 B（拆檔到 references/），方案 C 在保持單檔自足性的前提下，透過 Token 預算和自動掃描來防止技能膨脹，同時為跨平台遷移預留 agentskills.io 接口。
- **Scripts Portability（腳本隨框架部署）**：品質掃描腳本定位為「框架級工具」而非「專案原始碼」，因此放在 `.agents/scripts/` 中隨部署攜帶，但加入 `.gitignore` 排除，不污染專案版控。
- **Forbidden Word Context Awareness（禁用詞上下文感知）**：掃描腳本的禁用詞檢測排除 FORBIDDEN 規則定義行中的引用，避免「定義規則的人反而被規則懲罰」的自矛盾問題。

---

## [V5.3 工具技能生態擴展] - 2026-04-02

### 【新增商業能力】 (Business Capabilities Added)

- **Tool Ecosystem Expansion（工具生態系統擴展）**：框架從原先 21 個技能擴展至 25 個，新增 4 個操作型技能並擴充 4 個既有技能。核心理念不是「加裝更多工具」，而是「解鎖已有工具的隱藏能力」——框架已內建的 171 個 MCP 工具中，有大量功能因缺少操作指引而從未被使用。本次升級透過撰寫精準的操作食譜，讓 Excel（18 工具）、GitHub PR 審查（6 工具）、Sentry Seer AI 分析、Cloudflare 容器沙箱等能力首次被 AI 代理人正式納入工作流。

### 【技術債消除】 (Technical Debt Removed)

- **Tool-Skill Gap Closure（工具與技能的斷層封堵）**：原框架存在「工具有了但不會用」的結構性問題——Excel MCP 有 18 個工具但零操作指引、GitHub MCP 有完整的 PR 審查工具組但沒有審查 SOP、Sentry MCP 已內建 Seer AI 根因分析但技能文件僅一行帶過。v5.3 為每個被忽略的工具群組撰寫完整的操作食譜，將「工具可用」升級為「工具好用」。

### 【架構決策】 (Architectural Decisions)

- **解鎖優先於新增（Unlock Before Add）**：經過 6 輪深度推理分析，確立「先解鎖已有 171 個工具的隱藏能力，再考慮新增 MCP 伺服器」的策略，避免工具膨脹導致認知負載崩潰。
- **Context7 作為唯一新增 MCP（Single MCP Addition）**：在評估 7 個候選 MCP 伺服器後，僅選擇 Context7（即時框架文件查詢）作為唯一新增項目，因其直接解決了開發中最頻繁的痛點——查文件耗時。
- **效能稽核的非 MCP 實現（Terminal-Native Performance Audit）**：效能稽核選擇基於終端指令（Lighthouse CLI）+ 既有 Playwright MCP 的混合方案，而非引入新的 MCP 伺服器，展示了技能文件可以在不增加基礎設施的前提下擴展框架能力。

---

## [V5.2 品質保障多層防線建立] - 2026-04-02

### 【新增商業能力】 (Business Capabilities Added)

- **Multi-Layer Quality Assurance（多層品質保障體系）**：框架從原先的「靜態掃描 + E2E 視覺測試」二元防線，升級為「靜態掃描 → 單元測試 → 契約驗證 → E2E 視覺 → 無障礙掃描」的五層品質防線。技能總數從 18 增加至 21，品質相關工作流從 2 個擴展到 5 個，使 AI 代理人在每次寫程式後都能自動產生測試、在每次修復後自動產生回歸防護，大幅降低「改了 A 壞了 B」的連鎖故障風險。

### 【技術債消除】 (Technical Debt Removed)

- **Testing Gap Closure（測試中間層缺口封堵）**：原框架在「低層靜態掃描」與「高層 E2E 視覺測試」之間存在結構性空白——寫完功能後缺少自動化小驗證、修改共用模組前缺少影響範圍評估、修復 Bug 後缺少防止同類問題再犯的回歸測試。v5.2 透過三個新技能（`test-patterns`、`impact-test-strategy`、`a11y-testing`）精確填補此缺口，同時擴充現有的 `security-sre`（日誌標準化）和 `supabase-ops`（遷移驗證），將品質約束從「原則級」升級為「可操作級」。

### 【架構決策】 (Architectural Decisions)

- **三合一測試模式庫（Consolidated Test Patterns）**：深度思考分析後，決定將「單元測試鷹架」「API 契約測試」「異常情境測試」合併為單一 `test-patterns` 技能，因為三者在實際使用中密不可分——寫測試時必然需要同時知道「測什麼」（決策樹）、「怎麼測」（模板）和「測哪些意外」（場景清單）。此設計減少了技能載入次數，節省 Token 消耗。
- **影響分析與回歸防護的統一（Impact-Test Unification）**：將「修改前的影響分析」「測試範圍決策」和「修復後的回歸測試產生」統一為 `impact-test-strategy`，因為三者形成一條完整的風險管理鏈條，分開會導致流程斷裂。
- **框架核心技能定位（Framework-Level Promotion）**：這些技能建立為框架核心技能（`origin: framework`）而非專案衍生技能，因其品質保障指引具有跨專案通用性，任何新專案佈署時都會自動攜帶。
- **工作流深度整合（Workflow Deep Integration）**：`/03_build` 在寫程式碼與 E2E 之間插入單元測試產生步驟、`/04_fix` 在修復前插入影響分析且修復後自動產生回歸測試、`/06_test` 在視覺測試後插入無障礙掃描，形成無縫的品質閘門鏈條。

---

## [V4.2 記憶系統韌性升級] - 2026-04-01

### 【新增商業能力】 (Business Capabilities Added)

- **Memory Ops Graceful Degradation（記憶系統備援降級機制）**：重新設計 `memory-ops` 操作技能，使其在 `cartridge-system` MCP 停用或無法連線時，能**自動切換至原生工具備援路徑**，而非中止工作流程。此設計讓記憶卡讀寫操作在任何 MCP 可用性狀態下均可穩定執行，消除了框架對單一外部服務的硬依賴。

### 【技術債消除】 (Technical Debt Removed)

- **MCP 硬依賴解除（Resilience-First Redesign）**：原 `memory-ops/SKILL.md` §1 的「禁止手動寫入」硬性規範，升級為「MCP 優先 → 降級次之」的雙軌政策。新增覆蓋全部五個 MCP 操作動詞的備援程序（讀取、列表、建立、更新、狀態診斷），每個備援段落均包含：逐步英文指令、驗證確認步驟、至少一條明確禁令，確保 AI 在無 MCP 的情況下仍能無歧義地執行記憶卡管理。

### 【架構決策】 (Architectural Decisions)

- **三層 Staleness 時機推斷模型**：針對備援模式無法使用 git hash 自動追蹤的限制，設計 L1（總監直接告知）→ L2（AI 任務推斷）→ L3（保守預設）的分層判斷演算法，明確規定 L3 僅作安全網，禁止繞過 L1+L2 直接執行。
- **指令層英文化（Instruction Layer Enforcement）**：備援程序所有步驟指令統一採用英文，符合 Core Mandate §7 雙受眾設計原則，確保指令層對所有 AI 模型均具可讀性，不受語言理解偏差影響。

---

## [V3.1 Workflow Consolidation] - 2026-03-06

### 【架構決策】 (Architectural Decisions)

- **UI/UX Manifesto (介面語彙與多語系防線)**: Added `06_ui_ux_manifesto.md` to strictly prohibit the leakage of internal engineering terminology (e.g., CRUD, Payload, Token) into the user interface. Enforced "Intent-Driven Translation" and dynamic language prompting to ensure graceful error handling and proper localization strategies across all AI-generated UI components.
- **Workflow Consolidation (15-to-10 Strategy)**: Refactored the original 15 Antigravity workflows down to 10 core commands to reduce Director cognitive load.
  - Merged `08_audit` and `13_index` into `08_audit_index(專案健檢)`.
  - Merged `10_snapshot`, `11_record`, and `14_commit` into `09_commit_log(備份紀錄)`.
  - Renamed `12_rollback` to `10_rollback(還原)` to fit the new numerical sequence.
  - Formally deleted the obsolete `09_review` workflow as its capabilities are absorbed by the Validator Subagent Hooks.
- **Hybrid Token-Saving Tagging Protocol**: Remodeled the 10 core workflows to use high-compression English for machine instructions, but strict Traditional Chinese (zh-TW) templates for the `Output Mandate` to prevent LLM context contamination and token waste.

---

## [V3.0 Ultimate Upgrade] - 2026-03-01### 【新增商業能力】 (Business Capabilities Added)

- **Zero-Touch 零接觸全自動組織佈署 (Bootstrapping 機制)**：導入全域母規則 `~/.gemini/GEMINI.md` 與自動派發腳本。自此之後，企業內任何新設立的專案資料夾，皆能在無須工程師介入鍵入任何指令或連線 Git 的狀態下，在背景自動取得高達 23 份的 AI 治理生態系與軍團武裝。大幅降低團隊擴編帶來的初始培訓成本。
- **Titans 陣發性記憶庫 (AI 自體再學習機制)**：為軍團大腦擴增了 `07_episodic_memory.md` 規則與實體 `.agents/episodic_log.md` 教訓檔。使 AI 代理人具備「記取歷史教訓」的能力。未來遭遇同類型商業邏輯 Bug 時，AI 將自動閃避曾犯下的錯誤，免去人類主管的重複監督與訓話。

### 【技術債消除】 (Technical Debt Removed)

- **100% Native System Tools Mandate (禁止終端機文書處理)**：新增第 8 條底層規則 `08_native_tools_mandate.md`，強力封殺 AI 代理人企圖使用終端機指令（如 echo, cat）撰寫或修改任何文檔或錯誤紀錄的行為。全面強制代理人必須透過專屬內建的系統工作區工具進行實體檔案讀寫，徹底杜絕終端機字元跳脫導致的寫入毀損風險。
- **Dual-AI Auto-Arbitration (雙軌 AI 仲裁機制)**：實作方案 B，修改 `01` 與 `04` 核心典範。正式解除靜態的 200 行上限，改為「動態閾值」。同時將 Linter 與單測升級為物理防護閘門，AI 將自動執行程式碼糾錯，僅在嘗試 3 次失敗或發生架構級衝突後才發送通知請總監裁決，大幅減輕人類主管的審查負擔。
- **Rule Overlap Refactoring (8 變 5 核心收斂)**：為降低 AI Agent 的 Token 認知負擔並消除邏輯重疊，全面重構並濃縮原本的 8 條底層規則，精簡為最核心的 5 大典範 (`01` 執行、`02` 記憶、`03` SRE、`04` 風格、`05` 技術棧)。維持原商業限制不變，但大幅提升系統載入與查閱速度。
- **Bootstrapper & Parent Protocol Sync (部署腳本與母法則同步)**：修復 `Deploy-Antigravity.ps1` 在全自動武裝新專案時遺漏複製根目錄 `AGENTS.md` 的 Bug。同步修改母法則 `AGENTS.md`，正式承認「次代理人 (Validator/Subagents)」的存在，並指明其擁有向 OS 隔離腦區寫入未過濾日誌檔之特權，以兼顧最小權限與系統透明度。
- **Agentic Swarm MAS Architecture (多代理人蜂群架構重構)**：全面升級 Antigravity 底層規則，寫入 2026 最新 Multi-Agent System (MAS) 三大精神。在 `01_execution` 確立主腦與次代理人的「職責專職化 (Agent Specialization)」，禁止主腦微操；在 `02_memory` 寫入「最小上下文切片 (Context Slicing)」，物理性隔離幻覺擴散；並正式確立次代理人具備「隔離腦區日誌輸出 (Subagent Observability)」特權。徹底消滅主對話 AI 因資訊過載帶來的腦霧與幻覺。
- **Pre-Flight Capability Discovery (起飛前環境與能力探索)**：重構 `AGENTS.md` 喚醒防呆機制與 `05_tech_stack_dynamic.md`。透過將「可用工具鏈 (Toolchain)」與「OS 種類」物理性固化至 `knowledge_index.json` 中，並配合超輕量的 Session Ping 測試，解決了跨設備切換導致的終端機報錯危機。讓 AI 每一次喚醒都能根據系統實體能力切換語法，達成跨平台的「零盲點」部署。
- **消除 AI 幻覺與粗放式寫入 (Vulnerability Audit)**：全面盤點並覆寫超過 50% 的舊版手術刀與底層規則，包含以 Linter 與 JSON Validator 實體驗證取代任意臆測。徹底拔除了 AI 瞎猜（AI Magic）導致修改到專案核心「祖傳代碼」的定時炸彈。
- **Gated Chaining 受控串聯 (自動化而不失控)**：引進 `// turbo` 連續點火機制，修復與建構完成後自動銜接 E2E UI 測試（`/06_test`），不僅消除人工銜接成本，也在真正覆寫實體檔案前增加了強制性的「視覺圖形防呆閘門」。

### 【架構決策】 (Architectural Decisions)

- **採用 Google SAIF 最小權限代理 (Least Privilege Governance)**：在主協議 `AGENTS.md` 中強勢引入「角色隔離 (Role Separation)」機制。將軍團硬性劃分為「只能讀取」的 Reader Agents 與「受限修改」的 Worker Agents，物理上斷絕了探勘型代理人意外毀去專案核心結構的後門。
- **Black Box 機制建置 (Immutable Audit Trail)**：新增第 6 條底層規則並部署了 `.agents/audit_trail.jsonL` 黑盒子。將所有代理人對於硬碟的實體修改或終端機下達的操作，轉為機器專用的不可竄改履歷鏈。確立了企業在使用高階自主 AI 時代不可或缺的「事故追責與災難重建備份」底線。

---
