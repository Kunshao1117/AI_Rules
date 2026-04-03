# Antigravity 專案發布日誌 (Changelog)

此文件紀錄 AI 代理人開發團隊的所有重要歷史與版本迭代，將龐雜的技術修改提煉為以「商業價值」為導向的決策紀錄。

---

## [V5.7.1 全域版本控制邊界定錨] - 2026-04-04

### 【新增商業能力】 (Business Capabilities Added)

- **Global Commit Boundary（全域版本控制範圍鎖定）**：新增 `_system` 全域系統記憶卡。強制將未來所有 Git 版本控制操作的根目錄定錨為外部 `D:\AI_Rules` 目錄。確保未來所有的推送動作皆預設涵蓋外部資料夾，達成零手動碰觸（Zero-Touch）自動備份的安全防線。

## [V5.7.0 三位一體防護全面注入與框架清理] - 2026-04-03

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
