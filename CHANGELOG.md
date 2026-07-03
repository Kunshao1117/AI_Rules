# Changelog

All notable changes to this project will be documented in this file.

> 語彙說明：本文件保留歷史版本語境；舊條目中的 patch、packet、補丁、封包、隊長代工與 accepted-risk 不得解讀為現行正向規範。現行正向規範只使用交付件、任務軌跡帳本、逐波派工、隊長接收站點交付與彙整狀態、授權後變更由變更站或明確授權 gate 套用，以及缺交付件即阻塞、未驗證或總監風險關閉但非完整。

## [2026-07-01] Team-Native 授權綁定與巡檢閉鎖

### feat
- **隊長薄上下文邊界** — 明確隊長只做微讀、格式檢查、接收站點交付、更新任務板與彙整狀態；阻塞、衝突與授權由隊長處理，正式驗證、審查、記憶文件判讀由對應站點交付，禁止補實作、補審查、補驗證或補記憶歸因後宣稱完整團隊完成。
- **團隊拓撲硬化** — 將 Team-Native 軌跡固定為任務板、站點族群、正式站點、子站點任務、隊員配置、執行通道與交付件，避免用多代理或隊長處理取代角色與證據。
- **縮減邊界收斂** — 明確縮減只能落在子站點任務或隊員數層，不能刪除站點、角色邊界、驗證、審查、記憶文件與完成稽核。

### fix
- **範圍式授權綁定** — 補強日常語句、介面同意與 GO 的可見範圍綁定規則，避免被擴張成未限範圍寫入。
- **治理巡檢失敗閉鎖** — 強化管理器巡檢與稽核入口，讓 Team-Native 硬閘門失敗不能靜默通過。
- **Codex hook 完成證據** — 停止階段改以結構化且已回收的實作、記憶文件、審查與驗證交付件判定完成宣稱，並補齊授權來源、目標、範圍、階段、期限與解析狀態要求。
- **Codex hook 回歸覆蓋** — 補齊中文口語路由、中文與空白路徑、Windows 路徑前綴陷阱、含 BOM 中文完成宣稱、純文字交付件宣稱與授權欄位案例；5 個新增 fixture 納入本輪提交候選清單。
- **跨平台代理同步** — 同步 Antigravity、Claude、Codex 入口、共用政策、技能與記憶歸屬。

## [2026-06-30] Codex hooks 穩定性與團隊硬閘門

### feat
- **Codex hooks 團隊硬閘門** — 新增 Codex 專案層 hooks 與 Team-Native gate，覆蓋提示送出、工具使用、權限請求、隊員啟停與完成宣稱邊界。
- **Captain-Lite 讀取模型** — 核心規範新增小型唯讀、廣泛讀取、專家深讀與保護操作分層，避免 hooks 無端攔截正常探索，同時防止讀取結果被誤宣稱為完成證據。
- **Hooks fixture 回歸套件** — 新增 Codex hooks fixture runner 與 52 個案例，覆蓋範圍式寫入、保護操作授權、歷史對話污染、危險繞過、完成過度宣稱、停止階段活體訊息與隊員生命週期。

### fix
- **Doctor/Audit hooks 檢查** — 管理器巡檢納入 hooks 設定、來源與部署副本雜湊、fixture 追蹤、受保護操作授權與完成交付件檢查。
- **記憶歸屬收斂** — 新增 hooks 測試子記憶卡並更新相關核心、共享、腳本與發布記憶卡，讓提交前檢查可追溯 hooks 穩定性變更。
- **Stop hook 完成宣稱防線** — 修正 Codex 停止階段未讀取最新助理訊息的缺口，讓短句完成宣稱、混合完成宣稱與停止階段續跑仍需交付件證據，同時保留未驗證、阻塞、總監風險關閉與唯讀搜尋回報出口。
- **Doctor Stop fixture 覆蓋同步** — 將新增的 11 個 Stop hook 回歸案例納入管理器巡檢必要清單，避免後續刪除活體訊息、混合宣稱或中文狀態案例時漏過提交前檢查。

## [2026-06-30] Team-Native 工作流編排落地

### feat
- **工作流編排契約** — 新增共用工作流編排政策與情境劇本，明確日常模式、完整模式、純對話、唯讀、寫入、轉場、隊員生命週期與任務板觸發條件。
- **任務板模板強化** — 團隊任務板補齊流程範例、協作轉場劇本、完成狀態、缺件處理、隊長接收交付與授權處理邊界、授權後變更套用 gate 與正式站點欄位。
- **三平台入口同步** — Antigravity、Claude、Codex 的 17 個工作流入口同步 Team-Native 編排層，避免工作流只引用角色技能但缺少實際流程。

### fix
- **治理巡檢覆蓋** — 管理器巡檢新增工作流編排政策、情境劇本、任務板範本、生命週期與部署同步檢查。
- **記憶與證據收斂** — 對應記憶卡補齊 Wave 6A 到 Wave 6C 的政策、工作流、腳本與任務板歸因，讓提交前能追溯本輪重構範圍。

## [2026-06-29] Team-First 團隊狀態機收斂

### feat
- **Team-First 正式狀態機** — 將探索、架構、廣泛讀檔、外部研究、審查與驗證規劃收斂為正式唯讀板；寫入工作則必須使用 GO 支撐的正式寫入板。
- **隊員派工包** — 新增隊員派工包技能，要求每個正式站點攜帶技能引用、深讀範圍、隊長接收交付所需的協調範圍、啟動期限、待命原因與輸出格式。

### fix
- **隊長主線直做防線** — 巡檢補強 no-write 不等於 no-team、隊員 standby/nonlaunch 回報、缺派工包與隊長大量深讀替代隊員等檢查。
- **跨平台工作流同步** — 三平台核心規則、工作流入口、能力矩陣、共享政策與記憶卡同步 Team-First 語義。

## [2026-06-29] 團隊核心授權解析重構

### feat
- **團隊核心最高優先化** — 三平台核心規則新增團隊核心與授權解析前置閘門，讓工作流、平台模式、工具確認與介面按鈕都先收斂到團隊任務板與範圍式授權模型。
- **範圍式授權政策** — 新增共用授權解析政策，明確區分文字同意、介面按鈕、平台模式、權限提示與工作流路由，避免把同意訊號擴張成無範圍寫入。
- **團隊交付欄位硬化** — 任務板、專家角色、變更交付件、記憶文件交付件、驗證交付件、審查交付件與完成閘門都補齊授權來源、目標、範圍、階段、證據、期限、解析狀態與平台模式觀測。

### fix
- **治理巡檢補強** — 管理器巡檢新增授權政策存在性、核心順序、來源與部署副本一致、禁止語義與團隊核心欄位完整性檢查。
- **平台與文件同步** — 平台能力矩陣、工作流證據矩陣、三平台文件與記憶卡同步說明工作流只做路由、介面同意只作範圍式授權證據、隊長替代創作不得宣稱完整團隊完成。

## [2026-06-29] 提交前治理收斂

### fix
- **同步漂移檢查** — 部署同步改與治理巡檢使用一致的精確雜湊判斷，避免部署副本內容不同卻回報無需更新。
- **記憶健康收斂** — 壓縮核心記憶卡舊週期事件並補齊歸檔，讓提交前檢查不再被過期或壓縮需求阻塞。

## [2026-06-28] 團隊原生交付件驅動收斂

### fix
- **Delivery-artifact governance** — 三平台工作流來源與根文件收斂為交付件驅動語義；隊長只協調、派工、監督、接收站點交付、更新任務板、彙整狀態與回報，不產出主要實作、審查、驗證或記憶歸因。
- **Wave and evidence ordering** — 正式入口明確要求任務軌跡帳本與逐波派工；審查與驗證交付件不得早於變更交付件，自審不得完成審查。
- **Risk closure wording** — 缺合格交付件只能標示阻塞、未驗證或總監風險關閉但非完整；已接受風險不得宣稱完整完成。

## [2026-06-28] 團隊原生通道分離重構

### feat
- **Assignment/channel separation** — 團隊原生流程改成先建立任務板與指派專家站點，再判斷執行通道；子代理、工具、瀏覽器、命令列、MCP 或隔離工作區不可用時，只能把站點標示為阻塞、未驗證或總監風險關閉但非完整，不得取消指派或回落成隊長代工完整完成。
- **Direct skill rename** — 正式團隊入口更名為任務板與交付件語義：團隊任務板、變更交付件、記憶文件交付件、驗證交付件與審查交付件成為唯一正式名稱。
- **Specialist-first routing** — 專家分類由專家角色母技能唯一維護；委派策略固定為選專家子技能、選領域標籤、選請求通道、記錄通道能力與啟動狀態，最後回收交付件或標示缺證狀態。

### fix
- **Doctor hardening** — 治理巡檢正向條件改抓新技能名、新交付件、新通道狀態欄位與 Team-Native 軌跡欄位；舊補丁語義只保留為遺留偵測，不再作為通過條件。
- **Deployment sync** — 三平台部署副本同步新子代理政策、新任務板技能、新交付件技能與核心規則 marker block。

## [2026-06-28] Team-Native Core 團隊原生核心

### feat
- **Team-Native Core** — 新增共用團隊原生核心政策與任務軌跡證據契約，將編程、工作流、驗證、審查、記憶、提交、交接、技能鍛造與治理影響工作預設為站點優先團隊狀態機。
- **Specialist skill registry** — 新增專家角色母技能與十個專家子技能，將意圖需求、範圍影響、架構契約、變更交付、驗證、審查、安全可靠性、文件記憶、發布收尾與外部資訊查證從任務板抽離成獨立技能來源。
- **Change delivery artifact model** — 正式實作成果改稱變更交付件；子代理、瀏覽器、命令列、外部查證、隔離工作區與文字交付只作為執行通道，不再等同專家角色或團隊模式本身。
- **Platform route states** — 平台能力矩陣新增 `conditional` 能力層級；正式站點需記錄 native、adapter、conditional 或 unavailable，缺能力不得降級成 routine direct。
- **Team trace audit** — 治理巡檢新增 Team-Native Core 語意掃描與可選嚴格任務軌跡檢查；管理器與部署稽核入口可要求 Team-Native trace。

### docs
- **Core direction alignment** — 根文件與三平台文件改以 Team-Native Core 描述團隊化方向，並明確區分 Codex / Claude 原生或外掛能力與 Antigravity / Gemini adapter / conditional 路由。
- **Skill count refresh** — 共用操作型技能數更新為 61；Codex Edition 部署後技能總數更新為 78（61 共用 + 17 工作流），根文件與三平台文件同步調整。

### fix
- **Legacy patch wording retirement** — 正式政策、技能、矩陣、三平台工作流與部署副本改用變更交付件語義；舊補丁語彙只保留在歷史紀錄或巡檢偵測規則中。

## [2026-06-28] 團隊協作封包技能拆分（歷史語境）

### feat
- **Team collaboration skill split** — 新增 team-role-boundaries、team-change-delivery-artifact、team-memory-docs-delivery-artifact、team-validation-delivery-artifact、team-review-delivery-artifact、team-completion-gate 六個共用隊員技能，將隊長制從主線處理升級為正式團隊協作。
- **Formal packet completion** — 歷史紀錄：當時以 implementation patch、memory delivery、review、validation 四類封包描述正式團隊完成；現行規範已改為四類交付件與任務軌跡帳本，且缺件不得稱完整完成。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 50；Codex Edition 部署後技能總數更新為 67（50 共用 + 17 工作流），根文件與三平台文件同步調整。

## [2026-06-28] 正式派工板與波次派工語義

### feat
- **Formal dispatch lifecycle** — 隊長制流程明確分成草案包、GO、正式派工板與波次派工；草案板不得啟動隊員。
- **Wave dispatch contract** — 歷史紀錄：正式派工不是一次開全部隊員；當時寫作補丁、審查或驗證證據的上一波輸入，現行規範改稱變更、審查與驗證交付件。

### fix
- **Doctor semantic coverage** — 巡檢新增正式派工生命週期、波次派工、上一波輸入、下一波啟動條件與正式證據資格檢查，並攔截草案證據冒充正式驗收。
- **Documentation alignment** — 根文件與三平台文件同步說明授權後變更由變更站或明確授權 gate 套用，隊員依正式派工板逐波次啟動。

## [2026-06-28] 隊長制團隊任務包模板化

### feat
- **Team task package** — 新增團隊任務包共用技能，集中保存輕量任務板、完整任務板、實驗任務板、專員任務包、證據交付件、隔離變更交付件、文字變更交付件、直接處理例外與收尾檢查表。
- **Workflow template references** — Codex workflow、Claude command 與 Antigravity workflow 入口改為載入隊長制編程治理與團隊任務包，不再在每個入口複製長段任務板規則。
- **Patch packet contract** — 歷史紀錄：當時以補丁與任務包描述實作隊員輸出；現行規範只承認受治理隔離變更交付件或文字變更交付件，缺交付路徑只能總監風險關閉但非完整。
- **GO execution routing** — 三平台建構、修復與提交入口明確改為 GO 後先派實作變更交付件、審查交付件、驗證交付件或收尾證據交付件；隊長接收交付並處理授權邊界，實際變更由變更站或明確授權 gate 套用，記憶、Git 與發布閘門保持獨立。

### fix
- **Captain scope reduction** — 隊長制編程治理改回語義核心，只負責觸發、角色邊界、隊長最小執行權與完成誠實性；任務板與專員包模板交由團隊任務包維護。
- **Doctor semantic coverage** — 巡檢模組新增團隊任務包存在性與模板欄位檢查，並攔截工作流殘留舊版長段規則，避免同步成功但語義漂移。
- **Documentation alignment** — 根文件與三平台文件說明團隊任務包的單一責任；本日後續團隊協作封包技能拆分已將現行技能統計統一更新為 50 共用與 67 Codex 部署技能。

## [2026-06-28] 隊長制編程團隊協作模式

### feat
- **Captain trigger gate** — 歷史紀錄：當時曾採 default-on 隊長制；現行規範已改為由目前總監對 governance、workflow、fix、build、debug、test、audit、source、public-contract 或等價 source/governance/evidence-bearing work 的受治理請求觸發 Team mode，也可由團隊、隊員、subagent、delegation、Team-Native 等派工語意觸發。它不是 AI 在沒有目前使用者受治理請求時自行 default-on；Team mode 啟動也不等於寫入授權，寫入仍需 scope-bound authorization。純聊天、小型穩定問答、無 source/governance/evidence 影響可維持 direct。
- **Task type and dispatch pre-gate** — 隊長制啟動後必須先判斷任務類型、工作流路由、實作授權、允許角色與禁止角色，再建立隊長任務板；任何隊員、子代理、瀏覽器分支、CLI 分支或隔離變更交付不得早於任務板啟動。
- **Captain minimum execution gate** — 歷史紀錄：當時仍保留部分隊長主線處理與驗收語氣；現行規範已收斂為隊長只協調、派工、監督、接收交付、更新任務板、彙整狀態與回報，隊長代工不得稱完整完成。
- **Captain team board** — 團隊站點板升級為隊長任務板，每站必須標示是否適用、執行模式、證據負責人、角色邊界、主線直做例外與完成條件。
- **Role exclusivity** — 新增嚴格角色互斥：提出需求者不實作，架構者不偷改需求，實作者不能審查自己的交付物，審查者不能同時實作同一交付物。
- **Isolated patch branch** — 歷史紀錄：當時以 patch packet 描述隔離實作分支；現行規範改稱受治理隔離變更交付件，且主工作區只能透過授權 gate 套用已回收交付件。
- **00/01 trigger routing** — 對話與探勘入口新增編程意圖轉向規則；普通自然語言要求只要涉及編程，就轉入隊長制編程模式。

### fix
- **Experiment boundary** — 三平台實驗入口保留快速試錯，但最小治理宣告改為 Captain Team Board，並加入角色邊界、隔離變更交付條件、不能自我審查與不能宣稱團隊協作的全主線例外。
- **Condense boundary** — 三平台 05 濃縮入口納入隊長最小執行權與 Captain Team Board，掃描、萃取、審查與收尾稽核不得繞過團隊派工；AGENTS、CLAUDE 與記憶寫入仍需依對應授權 gate 與站點交付處理。
- **Doctor semantic coverage** — 巡檢模組改抓隊長觸發、任務類型、派工前置、隊長最小執行權、角色邊界、隔離變更交付、文字變更交付、總監風險關閉但非完整、自我審查、00/01 自動轉向與實驗邊界，避免舊版只檢查 Full B 字串造成假綠燈。
- **Documentation alignment** — 根文件與三平台文件改以隊長制團隊協作描述編程治理，明確區分隊長接收交付與狀態彙整責任、授權後變更套用 gate、唯讀證據分支與隔離變更交付分支。

## [2026-06-27] 受治理 Full B 編程團隊治理

### feat
- **Programming team governance** — 新增編程團隊治理共用技能，將開發、修改、修復、測試、除錯、健檢、提交、交接與技能鍛造固定拆成需求回放、反證、影響面、計畫授權、實作、短迴圈、審查與收尾站點。
- **Station-gated subagents** — 子代理政策從「必要時才用」改為「編程任務先建立團隊站點板，再判斷唯讀 evidence branch」，並明確禁止委派寫檔、提交、推送、發布、外部狀態與記憶寫入。
- **Team-first evidence stations** — 反證、影響面、短迴圈驗證、審查與收尾稽核預設需要獨立證據分支；全主線直做必須逐站留下主線直做例外與替代證據。
- **Workflow coverage** — Codex workflow skills、Claude commands 與 Antigravity workflows 的編程入口都接入團隊站點板，讓計畫、執行、驗證、審查與收尾不再只依賴大小型或必要時判斷。
- **Doctor coverage** — 治理巡檢新增編程團隊治理覆蓋檢查，會掃描共用技能、子代理政策、委派策略、能力矩陣、工作流證據矩陣、三平台入口與部署後副本 hash。

### fix
- **Station state hardening** — 團隊站點板改為分離「是否適用」與「執行模式」，禁止只用啟用中、必要時或大小型判斷作為最終結果。
- **Delegation route order** — 委派策略先判斷主線不可委派責任、憑證與外部狀態邊界，再判斷瀏覽器、CLI 與 MCP 特殊證據路徑，最後才落到一般唯讀 evidence branch。
- **Core accountability wording** — 三平台核心規則從「主代理處理所有事情」改為「隊長接收交付、更新任務板、彙整狀態並處理阻塞、衝突與授權」，避免壓過團隊站點板。
- **Review and browser branch boundaries** — 審查治理與瀏覽器測試技能不再把證據分支描述為可選 fallback；必要分支不可用時必須標示未驗證、阻塞或具體主線直做例外。
- **Experiment minimum governance** — 三平台實驗入口保留快速試錯，但必須先列最小團隊站點、沙盒邊界、允許改動範圍、丟棄條件、升級條件、證據負責人與主線直做例外。
- **Codex skill count wording** — 修正 Codex 核心規範中的共用技能數字，讓來源規範與部署後 43/60 技能統計一致。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 43；Codex Edition 部署後技能總數更新為 60（43 共用 + 17 工作流）。

## [2026-06-21] AI Rules Manager v0.1.19

### fix
- **Doctor token stability** — 技能品質掃描改為使用換行正規化後的內容估算長度，避免同一版本在來源倉庫與管理快取中因換行差異出現不同紅綠燈。
- **Project skill discovery repair** — 專案同步補建流程會安全處理誤落在 discovery 位置的實體 project skill 目錄，必要時遷移到專案技能原檔區並重建 discovery 連結。
- **Shared skill safety margin** — AI 開發品質與記憶操作技能再壓縮，避免貼近技能品質門檻造成後續維護風險。

## [2026-06-21] AI Rules Manager v0.1.18

### feat
- **Engineering review governance** — 新增工程審查共用技能，定義正確、高品質、嚴謹、審查目的、審查時機、審查生命週期、accepted-risk 與最小足夠複雜度取捨。
- **Review-state workflow coverage** — 三平台 02/03/04/08/09/10 入口納入審查目的與狀態，並明確把 evidence branch 視為證據來源而非審查結論擁有者。
- **Doctor review coverage** — 治理巡檢新增審查治理覆蓋檢查，會掃描共用技能、工作流矩陣、子代理政策、部署後副本與三平台工作流入口。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 42；Codex Edition 部署後技能總數更新為 59（42 共用 + 17 工作流）。

## [2026-06-16] 需求對齊與中立建構治理

### feat
- **Intent alignment gate** — 新增需求對齊共用技能，讓架構藍圖與建構計畫固定輸出需求理解回放、中立反證、決策紀錄、驗收追蹤與偏移稽核。
- **Blueprint traceability** — 三平台架構入口要求架構決策表、需求到驗收追蹤表、建構交接合約與未驗證/阻塞清單，避免藍圖與總監意圖分歧。
- **Build drift audit** — 三平台建構入口要求沿用藍圖狀態、需求到任務追蹤表、任務驗收矩陣、偏移稽核規則與完成前回查。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 41；Codex Edition 部署後技能總數更新為 58（41 共用 + 17 工作流）。

## [2026-06-16] 變更意圖與視覺驗證治理

### feat
- **Change intent governance** — 共用矩陣與三平台建構、修復、測試、健檢入口新增緊急修補、根因修復、局部修整與結構重構分類，重複補丁會升級為根因修復或結構重構。
- **Visual detail verification** — 視覺驗證新增細微觀察要求，必須檢查文字截斷、對齊、間距、遮擋、焦點、載入、空狀態與錯誤狀態，不得只用整頁大方向判定通過。
- **Real-information visual evidence** — 視覺證據預設使用真實資訊頁面、真實資料、實際帳號狀態或等價真實路徑；假資料只能作為明確標記的備援證據。

### docs
- **Cross-platform governance docs** — 根文件與三平台文件同步說明補丁堆疊升級、視覺細節觀察與真實資訊優先規則。

## [2026-06-15] MCP 記憶工具治理

### feat
- **MCP memory evidence governance** — 工作流證據矩陣新增記憶工具證據規則與三平台實際位置，讓建構、修復、濃縮、健檢、提交、巡檢、交接與技能鍛造都有一致的最低記憶證據要求。
- **Memory tool contract** — 記憶操作規範新增 MCP 工具契約，明確區分專案本地遷移工具、框架來源管理器、唯讀記憶工具與需要授權的寫入工具。

### fix
- **Traditional Chinese tool output** — 專案本地記憶遷移工具修正 Windows PowerShell 下的繁體中文輸出相容性，避免管理器與外掛呼叫時因編碼造成解析失敗。

### docs
- **Cross-platform workflow alignment** — 三平台工作流與記憶規範同步說明缺少 MCP 證據時應標記為未驗證或阻塞，不得改用手動批次搬檔。

## [2026-06-15] AI Rules Manager v0.1.17

### fix
- **Project-local tools** — 部署與同步流程新增 `.agents/tools/Memory-Migration.ps1`，讓下游專案 AI 不需要完整 AI_Rules 來源倉庫也能乾跑記憶主檔遷移。
- **Sync coverage** — 治理巡檢與同步預覽納入專案本地工具來源與部署狀態，避免預覽通過但下游缺工具。
- **Memory migration safety** — 專案本地遷移工具套用更名時要求 `-Apply -ConfirmApply`，雙主檔衝突仍停止，歸檔卷不被改名。

### docs
- **Downstream tool path** — 根文件、三平台文件與 VS Code 延伸模組文件改為下游優先使用 `.agents/tools/Memory-Migration.ps1`，來源管理器入口標示為框架來源倉庫限定。

## [2026-06-15] AI Rules Manager v0.1.16

### feat
- **Sync coverage check** — VS Code 延伸模組新增同步完整性檢查入口，讓下游專案可從面板確認共用治理參考、Codex 支援檔與同步入口是否齊全。
- **Memory migration dry-run** — VS Code 延伸模組新增記憶遷移乾跑入口；正式套用仍需操作者確認。

### fix
- **Downstream sync coverage** — 專案同步與全新部署補齊子代理政策、選用外部工具設定片段、Codex 工作流支援檔與技能索引，避免下游 AI 找不到共用矩陣或支援檔。
- **Manager dry-run alignment** — 管理器乾跑報告改用與套用流程相同的檔案清單，避免預覽與實際同步結果不一致。

### docs
- **Release examples** — 根文件與延伸模組文件的 Release tag 與 VSIX 檔名更新為 `v0.1.16` / `ai-rules-manager-0.1.16.vsix`。

## [2026-06-15] 共用治理參考部署

### fix
- **Shared governance references** — 專案同步與三平台部署會把平台能力矩陣與工作流證據矩陣複製到共用治理參考目錄，避免下游專案只取得技能卻找不到矩陣依據。
- **Sync coverage completeness** — 專案同步與全新部署補齊子代理政策、選用外部工具設定片段、Codex 工作流支援檔與技能索引，並讓乾跑報告只列出實際會套用的檔案。
- **Downstream path semantics** — 下游規則與工作流改讀部署後共用治理參考目錄；框架來源路徑只保留在明確標示為框架來源倉庫限定的段落。
- **Governance doctor coverage** — 治理巡檢新增下游共用治理參考、Codex 支援檔、記憶遷移入口與外掛入口檢查，避免同步後仍遺漏可讀依據。

### docs
- **Workflow grounding paths** — 三平台工作流與根文件改用部署後可讀的位置說明共用矩陣，並保留框架來源檔作為唯一維護位置。

## [2026-06-15] 深層證據式健檢

### feat
- **Deep audit depth model** — 健檢流程新增快速、標準、深度與鑑識四級，讓不同風險與不同專案型態能選擇對應的盤點深度。
- **Audit inventory coverage** — 健檢流程新增功能、端點、命令、操作路徑、效能與風險盤點契約，報告必須揭露覆蓋率、未驗證項與阻塞項。
- **Surface-specific audit recipes** — 健檢引擎新增網站、後端、命令列、桌面、外掛、函式庫、基礎設施、資料管線、AI 功能與治理庫的型態專屬檢查食譜。

### docs
- **Cross-platform audit alignment** — 根文件與三平台文件同步說明新版深層健檢、平台採證轉譯、證據狀態與中繼日誌輸出。

## [2026-06-15] 記憶卡主檔標準化與拆分

### chore
- **Memory main-file migration** — 專案記憶庫完成作用中主檔從技能主檔命名切換到記憶主檔命名，並保留舊內容歸檔卷作為歷史依據。
- **Memory ownership split** — 將大型記憶卡拆成共用操作技能、Supabase Postgres 參考集、三平台支援入口、根層腳本與 VS Code 外掛子卡，降低單卡追蹤範圍與後續歸屬混亂。
- **Memory engine verification** — 使用記憶引擎完成逐卡提交、索引重建與歸屬檢查；目前無未歸屬檔、幽靈檔、舊主檔或主檔衝突。

## [2026-06-14] 三平台證據式工作流治理

### feat
- **Full-spectrum audit workflow** — 三平台健檢入口升級為專案型態偵測、動態模組掛載與證據式報告模型，缺少真實證據時改標記為未驗證、阻塞或部分證據。
- **Workflow grounding matrix** — 新增 00 到 12 工作流共用矩陣，統一外部最佳實務、平台採證差異、證據狀態、阻塞條件與下一流程路由。
- **Cross-platform workflow alignment** — Antigravity、Claude Edition 與 Codex Edition 工作流同步補強外部接地、相容性、子代理邊界、GO 閘門與可重跑證據語義。

### docs
- **Platform documentation alignment** — 根文件與三平台文件同步說明新版健檢基準、全工作流外部接地、平台能力矩陣與證據優先原則。

### chore
- **Memory hygiene** — 記憶卡完成本輪歸屬與過期收斂，新增健檢參考規格與工作流矩陣的追蹤事實。

## [2026-06-12] 真實驗證治理強化

### feat
- **Real execution evidence contract** — 三平台建構、修復、測試與健檢流程改為「可驗必驗」；假資料、mock、fixture、靜態截圖或局部單元測試只能作為局部證據，缺少真實執行證據時必須標記為失敗或阻塞。
- **Operator path retention** — 驗證入口沒有第一時間找到或操作者工具短暫失敗時，AI 必須搜尋可用入口、確認服務就緒、重試或改用等價真實路徑，不得直接放棄該驗證方式。
- **Cross-platform verification routing** — 平台能力矩陣補入瀏覽器、桌面操作、終端、外掛宿主、API、資料庫、日誌、preview 與 sandbox 等操作型驗證路徑，並要求阻塞報告列出搜尋、嘗試、重試與替代路徑。

### docs
- **Framework documentation alignment** — 根文件與 Antigravity、Codex、Claude 文件同步說明真實驗證契約與操作者路徑保留原則。

## [2026-06-11] 三平台治理流程改版

### feat
- **Design-to-build contract** — 三平台建構入口改為同一份計畫內整合架構判斷、功能邊界、完整度檢查與驗收矩陣；純架構入口保留給不立即落地的藍圖、初始化與重大技術轉向。
- **Autonomous governance depth** — 共用品質規則新增自治分級矩陣，工作流只輸出治理深度判定摘要；AI 無法證明輕量時預設升級，且不得為了省事自行降級。
- **Functional modularity quality gate** — 原始碼品質規則改為功能模組化優先；檔案大小超線只觸發複查，拆分必須依功能責任、公開介面、測試邊界、耦合或維護困難決定。
- **Interface adaptation evidence** — UI/UX、開發品質與測試技能改用介面類型矩陣，分別處理網頁、桌面 GUI、外掛面板、終端工具與操作型儀表板證據。

### docs
- **Workflow documentation alignment** — 根文件與 Codex 文件同步說明設計到建構合約、自治分級治理、功能模組化優先與介面適配證據。

## [2026-06-04] 記憶卡壓縮治理

### feat
- **Memory compaction governance** — 記憶操作與架構技能升級為 schema v2 語義：主卡只保留英文現行真相，週期事件最多 30 筆，超限需先彙整，歷史移入歸檔分卷。
- **Lazy legacy upgrade** — 舊格式記憶卡維持可讀，不做全專案重寫；只有在修改、修復過期或新增歸屬時才無痛升級，且舊長文先進歸檔卷。

### docs
- **Platform docs alignment** — 根文件、Codex、Claude 與 Antigravity 文件同步補充主卡大小、週期事件、歸檔卷、舊卡懶升級與 cartridge-system 壓縮度量揭露。

## [2026-05-31] UI 設計探索治理

### feat
- **UI design exploration skill** — 新增 `ui-design-exploration` 共用技能，將 UI 需求探索、網路參考搜尋、操作者意圖、共用元件盤點、三案比較、HTML 展示頁或視覺參考選擇、設計 DNA 與專案衍生技能沉澱串成固定流程。
- **Skill forge compatibility** — 技能工廠改為先分流 Shared framework、project-derived、user Codex 與 workflow/command entry 產物；Codex 相容欄位維持在 top-level 允許清單內，AI_Rules 治理欄位收斂到 `metadata`。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 40；Codex Edition 部署後技能總數更新為 57（40 共用 + 17 工作流）。

## [2026-05-29] AI Rules Manager v0.1.15

### fix
- **Gitignore precision cleanup** — 初始化、升級與專案同步改為只處理 AI Rules 精準標準規則；自動流程不再判斷管理區塊、註解、上下行或寬鬆相似規則，避免誤刪專案既有版控設定。
- **Gitignore Chinese comments** — v0.1.15 重新打包時補回繁中標準註解；舊版英文標記註解與專案自訂註解不再由自動流程處理，避免誤刪。
- **Gitignore maintenance confirmation** — 版控排除規則健檢按鈕改為列出相似規則清單，操作者可選擇只補標準規則，或刪除清單中的具體相似規則行後再補標準規則。

### docs
- **Release examples** — 根文件與延伸模組文件的 Release tag 與 VSIX 檔名更新為 `v0.1.15` / `ai-rules-manager-0.1.15.vsix`。

## [2026-05-29] AI Rules Manager v0.1.14

### fix
- **Gitignore comment encoding hotfix** — `.gitignore` 管理流程改用專用文字讀寫，讀取既有 UTF-8、UTF-8 BOM、UTF-16 與舊 ANSI 檔案，寫回時固定使用 UTF-8 BOM，避免中文註解在 VS Code 或 Windows PowerShell 5.1 情境下變成亂碼。

### docs
- **Release examples** — 根文件與延伸模組文件的 Release tag 與 VSIX 檔名更新為 `v0.1.14` / `ai-rules-manager-0.1.14.vsix`。

## [2026-05-29] AI Rules Manager v0.1.13

### feat
- **Gitignore maintenance button** — AI Rules Manager 新增「版控排除規則健檢」按鈕，先預覽目前專案 `.gitignore` 的 AI Rules 管理區塊、根目錄標準規則與寬鬆規則，再由操作者選擇不覆蓋或覆蓋整理。

### fix
- **Root-anchored default ignore policy** — Fresh、Upgrade 與專案同步預設補入根目錄錨定的 AI Rules `.gitignore` 規則，只管理專案根目錄的框架產物，避免影響子資料夾同名目錄。
- **Managed block deduplication** — 若腳本已寫入 AI Rules 管理區塊，插件整理會更新或覆蓋同一區塊，不會重複插入；覆蓋模式只移除 AI Rules 相關寬鬆規則與舊管理區塊，不影響其他專案自訂規則。

### docs
- **Gitignore policy docs** — 根文件與延伸模組文件補充預設排除策略、專案記憶/脈絡/衍生技能放行，以及插件按鈕的不覆蓋與覆蓋行為。

## [2026-05-29] AI Rules Manager v0.1.12

### feat
- **Project context layer release** — VSIX 安裝包升級為 `0.1.12`，讓 AI Rules Manager 能同步本次 AI 開發品質治理與專案脈絡層能力。

### fix
- **Project sync context backfill** — 專案規則同步套用後會補建專案脈絡索引卡與必要追蹤註記，既有專案只透過管理器同步時也能取得 `.agents/context/`。
- **Context protection in manager cleanup** — 管理器同步與孤兒清理會把專案脈絡視為受保護知識資產，不覆蓋、不刪除既有脈絡卡。

### docs
- **Release examples** — 根文件與延伸模組文件的 Release tag 與 VSIX 檔名更新為 `v0.1.12` / `ai-rules-manager-0.1.12.vsix`。

## [2026-05-29] 專案脈絡層治理

### feat
- **Project context layer** — 新增 `.agents/context/` 專案脈絡層與 `_map/CONTEXT.md` 索引卡，用來保存設計 DNA、產品偏好、技術偏好、溝通偏好與驗收偏好，避免混入原始碼記憶。
- **Project context protocol** — 新增 `project-context-protocol` 共用技能，定義 `CONTEXT.md` 格式、狀態機、讀取優先級、`GO CONTEXT` / `GO DNA` 核准口令與升級為專案技能的條件。
- **Deployment protection** — Fresh、Upgrade、專案同步與孤兒清理會保護 `.agents/context/`；基礎設施初始化會建立專案脈絡目錄與預設索引卡。
- **Shared context templates** — 新增 `Shared/context/_map/CONTEXT.md` 作為可見模板來源；部署時只在目標專案缺少索引卡時補建，不覆蓋既有脈絡。
- **Workflow context gates** — Antigravity、Claude Edition 與 Codex Edition 的藍圖、建構、修復、測試、濃縮與技能鍛造入口接入專案脈絡協議；工作流只能提出候選脈絡，永久寫入仍需 `GO CONTEXT`。
- **Project context audit** — 治理巡檢新增脈絡卡格式、核准紀錄、衝突狀態、候選脈絡過期與誤放記憶目錄檢查。

### fix
- **Shared skill prefix exception** — 技能同步器與專案技能連結巡檢保留 `project-context-protocol`，避免既有 `project-*` 排除規則把正式共用技能誤判成專案技能連結而漏部署或誤報紅燈。
- **Manager context backfill** — AI Rules Manager 的專案規則同步在套用後會補建 `.agents/context/_map/CONTEXT.md` 與必要 `.gitignore` 追蹤註記，讓既有專案只走管理器同步時也能取得專案脈絡層。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 39；Codex Edition 部署後技能總數更新為 56（39 共用 + 17 工作流）。

## [2026-05-29] AI 開發品質治理

### feat
- **AI development quality gate** — 新增 `ai-dev-quality-gate` 共用技能，統一管理技術新鮮度、共用元件復用、偏好探索、生成圖降級與手機/平板/桌面三尺寸證據。
- **UI quality hardening** — 介面品質、設計稿、瀏覽器測試與測試自動化技能新增操作型/品牌展示分流、設計 DNA、元件復用報告與響應式證據閘門。
- **Workflow load gates** — Antigravity、Claude Edition 與 Codex Edition 的藍圖、建構、修復與測試入口會在 UI、高變動技術、生成圖或手機響應式任務中載入 AI 開發品質閘門。

### docs
- **Skill count refresh** — 共用操作型技能數更新為 39；Codex Edition 部署後技能總數更新為 56（39 共用 + 17 工作流）。

## [2026-05-29] AI Rules Manager v0.1.11

### fix
- **Workspace setting trust boundary** — AI Rules Manager now rejects source URL, source root, and PowerShell executable overrides from project workspace settings. These sensitive settings must live in user settings, so opening an unfamiliar project cannot silently redirect the manager to an untrusted source or executable.
- **Preview failure gate** — global rule sync, project rule sync, and orphan cleanup no longer show the write-confirmation prompt after a failed preview.
- **Gitignore equivalent patterns** — target project `.gitignore` checks now recognize equivalent ignore patterns such as `**/.agents/logs/` and `**/.cartridge/`, avoiding duplicate AI Rules managed blocks.

### chore
- **AI Rules Manager v0.1.11** — extension manifest and lockfile versions are bumped to `0.1.11`; source and docs are updated, with no VSIX packaging or release in this change.

## [2026-05-29] AI Rules Manager v0.1.10

### fix
- **Remote source mirror** — VS Code managed AI_Rules cache now auto-aligns to the remote `main` branch before manager actions, so stale or diverged cache copies cannot be used to sync project rules.
- **Project sync freshness gate** — project rule sync now stops if the selected AI_Rules source is not aligned with the remote repository.
- **Gitignore additive policy** — target project `.gitignore` handling now checks for required AI Rules entries and inserts only missing lines, preserving existing project rules and comments.

### chore
- **AI Rules Manager v0.1.10 release** — extension manifest and lockfile versions are bumped to `0.1.10`; source and docs are updated for the tag-driven VSIX release.

## [2026-05-29] AI Rules Manager v0.1.9

### fix
- **Source update guard** — AI Rules Manager now stops immediately when the managed AI_Rules source repo is diverged, locally ahead, dirty, or unable to fast-forward; it no longer runs Doctor after a failed source update.
- **Source status wording** — Source checks now distinguish synced, fast-forward available, diverged source, local-ahead source, and dirty working tree states.
- **Workflow skill count** — Codex workflow skill merge now excludes `_shared` from the user-facing workflow count.

### chore
- **AI Rules Manager v0.1.9** — extension manifest and lockfile versions are bumped to `0.1.9`; source and docs are updated, with no VSIX packaging or release in this change.

## [2026-05-29] 情境式總監可讀輸出與中立誠實協作契約

### feat
- **情境式輸出契約** — 三平台核心規範、工作流與指令入口不再要求所有面向總監文字固定用表格開頭；一般討論與狀態回報可用短段落，正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才使用表格或結構化摘要。
- **精簡表格欄位** — 正式情境需要表格時，欄位統一為「事項、位置、影響、狀態」，降低欄位本身造成的閱讀負擔。
- **位置欄精準定位** — 表格的「位置」欄必須提供白話位置加具體檔案、區塊、工具狀態或目錄範圍，避免只寫概念詞而無法追蹤來源。
- **位置索引式輸出契約** — 正式計畫、完成報告與巡檢報告可用短名稱保持可讀性，但同一份輸出必須提供「位置索引」，把短名稱對應到具體檔案、章節、工具狀態或目錄範圍。
- **中立誠實協作契約** — 三平台核心規範與工作流入口新增「不討好、不附和、不刻意反對」規則；若證據與提議衝突，AI 必須用「我看到的事實／可能問題／建議做法」短格式提出修正與可行替代做法。
- **知識新鮮度查證契約** — AI 需把記憶與內建知識視為可能過時，遇到外部框架、API、版本、平台規則、價格、法規、安全或近期狀態時查最新或官方來源。
- **巡檢標準同步** — 治理巡檢改檢查情境式輸出規則、精簡表格欄位與技術詞括號規則，不再把早期固定四欄表格當成硬性標準。
- **位置索引巡檢** — 總監輸出巡檢新增短名稱與位置索引語意檢查，避免正式輸出只留下「核心規範、工作流入口、記憶卡」這類無法追蹤的分類詞。
- **中立協作與新鮮度巡檢** — 總監輸出巡檢新增中立誠實、不討好、不附和、不刻意反對、短證據格式、知識新鮮度、高變動資訊查證、版本與日期錨定檢查。

### docs
- **歷史規則取代註記** — README、記憶卡與舊變更紀錄補上新規則語意，避免 AI 從舊紀錄恢復成每次強制表格。
- **三平台說明同步** — 根 README 與 Codex、Antigravity、Claude 文件補上位置索引式輸出、中立誠實協作與知識新鮮度行為說明。

## [2026-05-28] 技術詞彙可讀性治理

### feat
- **技術詞彙翻譯閘門（Technical vocabulary translation gate）** — 三平台核心規則與工作流入口新增「技術詞彙翻譯閘門」，禁止面向總監的輸出只用函式名稱、變數名稱、欄位名稱、命令參數、內部工具名或檔案路徑描述變更。
- **總監輸出巡檢強化（Director output audit hardening）** — 治理巡檢（Doctor）新增技術詞彙翻譯閘門要求，避免工作流只有表格與補充段落卻仍輸出裸技術詞。

### docs
- **總監可讀輸出文件（Director-readable output docs）** — README 補充技術詞每次出現時都必須先寫白話名稱，技術名稱只能放在白話名稱後方的括號內。
- **中文前置標題** — 規範與工作流中的總監可讀輸出契約、技術詞彙翻譯閘門標題改成中文在前、英文名稱在括號內。

## [2026-05-22] AI Rules Manager v0.1.8

### fix
- **Operation wording precision** — VS Code 側邊欄、Command Palette、確認視窗與管理腳本輸出明確區分 AI_Rules 來源庫更新、VSIX 安裝包新版檢查、治理巡檢 Doctor 與目前專案規則同步，避免「套用更新」被誤解成會安裝插件或同步 `.agents` / `.claude` / `.codex`。

### chore
- **AI Rules Manager v0.1.8** — extension manifest 與 lockfile 版本升級到 `0.1.8`，下一次正式 release asset 檔名對齊 `ai-rules-manager-0.1.8.vsix`。

## [2026-05-22] 三平台子代理治理建構

### feat
- **Delegation Gate semantic core** — `Shared/policies/subagent-invocation.md` 改為 vendor-neutral 的 Delegation Gate / evidence branch 模型，Shared 層只描述委派判斷、唯讀邊界、隊長接收交付與授權處理責任，以及固定證據交付件格式。
- **Platform adapter translation** — Antigravity / Gemini、Claude Code、Codex 三平台入口改為各自轉譯 Shared 語義，不再把任一平台的子代理工具名硬寫成共用規則。
- **Subagent vocabulary drift audit** — Doctor 新增語彙漂移檢查，Shared 技能中的未標註平台工具名會以 Red 阻斷，並攔截 Codex workflow 殘留的 Claude 舊式 Agent subagent_type 語法。
- **Shared vocabulary hardening** — `delegation-strategy` 與 CLI prompt skeleton 移除平台專屬狀態檔與硬編工具名，browser Auto-Pass 明確不得略過 Director GO / HITL gate。

### docs
- **Common semantics plus adapters** — 根 README、三平台 README、能力矩陣與 memory cards 同步說明「共用語義 + 平台 adapter」模型，取代舊的一刀切同源說法。

## [2026-05-19] VSIX Release Pipeline Node 24 Migration

### chore
- **Release workflow Node 24 migration** — VSIX Release workflow 升級為 Node 24 建置路線，改用支援 Node 24 runtime 的 GitHub 官方 actions，避免 Node 20 淘汰影響自動發布。
- **VSIX license packaging** — 補齊 repo 與 AI Rules Manager extension package 的 MIT 授權檔，讓 VSIX 打包不再出現缺少 LICENSE 的警告。
- **Update reminder silence contract** — 文件與插件發布 playbook 明確規定啟動自動檢查只在有新版時通知；沒有新版或暫時無法檢查時只寫入 Output Channel，手動檢查才回報完整狀態。

## [2026-05-19] AI Rules Manager v0.1.7

### feat
- **Skill governance contract** — 新增 Skill 放置與觸發契約，將核心規則、workflow / command、Shared Skill 與 memory 的職責分層，讓 Skill 成為三平台按需載入的知識壓縮層。
- **Plugin release governance skill** — 新增 `plugin-release-governance`，集中管理插件升版、VSIX 打包、GitHub Release、tag、Release asset 與更新提醒的共用流程。
- **Skill trigger quality audit** — Doctor 的技能品質檢查新增 description 觸發品質欄位，檢查 Shared Skill 中英觸發詞、負向邊界與 workflow 入口觸發語句，避免格式正確但 AI 不會自動讀取的 Skill 漏檢。
- **Workflow trigger descriptions** — 三平台 00-12 workflow / command 入口統一補上 `Use when` 口徑，讓入口負責任務路由、Shared Skill 負責細節 playbook。

### chore
- **AI Rules Manager v0.1.7** — extension manifest 與 lockfile 版本升級到 `0.1.7`，重新打包產物改為 `ai-rules-manager-0.1.7.vsix`。

## [2026-05-19] AI Rules Manager v0.1.6

### feat
- **GitHub Release update reminder** — 插件啟動時會檢查 GitHub latest release；若有較新的正式 `vX.Y.Z` 版本，提示操作者開啟 Release 下載 VSIX。
- **Manual extension update check** — 側邊欄新增「檢查插件新版」按鈕，可手動確認目前安裝版本是否已是最新版。

### chore
- **AI Rules Manager v0.1.6** — extension manifest 與 lockfile 版本升級到 `0.1.6`，重新打包產物改為 `ai-rules-manager-0.1.6.vsix`。

## [2026-05-19] AI Rules Manager v0.1.5

### fix
- **Project identity preservation** — `SyncProjectRules` 同步三平台專案規則時，會保留 05 濃縮寫入的 `PROJECT IDENTITY` 區段，只更新框架管理內容。
- **Project rules drift check** — 健康檢查比對 `.codex/AGENTS.md` 時會忽略 `PROJECT IDENTITY` 區段；真正框架內容不同仍會提示 Yellow。
- **Codex condense path wording** — Codex 05 濃縮工作流的舊 `.Codex/AGENTS.md` 路徑修正為 `.codex/AGENTS.md`。

### chore
- **AI Rules Manager v0.1.5** — extension manifest 與 lockfile 版本升級到 `0.1.5`，重新打包產物改為 `ai-rules-manager-0.1.5.vsix`。

## [2026-05-19] Release 簡介自動化

### chore
- **Release notes body** — VSIX release workflow 改為從 `CHANGELOG.md` 的 `AI Rules Manager v<version>` 段落產生 GitHub Release 簡介，不再只依賴 GitHub 的 Full Changelog。
- **Existing release refresh** — workflow 重新執行時會更新既有 Release 簡介並覆蓋同名 VSIX asset，方便補跑發布。

## [2026-05-19] AI Rules Manager v0.1.4

### chore
- **AI Rules Manager v0.1.4** — extension manifest 與 lockfile 版本升級到 `0.1.4`，讓跨專案同步換行誤報修正對應到新的安裝包版本。
- **VSIX package refresh** — 重新打包產物改為 `ai-rules-manager-0.1.4.vsix`，release 文件範例同步改用 `v0.1.4`。

## [2026-05-19] 跨專案同步換行誤報修正

### fix
- **Runtime drift semantic compare** — 使用者層全域規則與 repo source 比對時，文字規則檔會先正規化 CRLF/LF 換行；內容相同不再顯示 Yellow。
- **Project sync line-ending tolerance** — 專案規則與 shared skills 差異掃描沿用同一套文字語意比對，避免 `D:\AI_Rules` 與 IDE managed clone 只因 checkout 換行不同互相觸發同步提示。
- **Legacy danger pattern narrowing** — 舊路徑高風險語義偵測不再把合法 `.codex/AGENTS.md` fallback 誤標為歷史大寫 Codex agents 路徑。

### docs
- **Managed clone behavior** — README 與 AI Rules Manager 文件補充 Antigravity / VS Code 類 IDE 在非 AI_Rules workspace 會使用 globalStorage 管理快取，且全域規則漂移以文字內容判斷。

## [2026-05-18] VSIX Release 自動建立與附加

### feat
- **Release VSIX workflow** — 新增 GitHub Actions workflow，在推送 `v*` tag 後自動打包 AI Rules Manager VSIX、建立 GitHub Release 並上傳到 release assets。
- **Release tag guard** — workflow 會檢查 tag 是否等於 VSIX 版本（例如 `v0.1.3`），避免版本名與插件包不一致。

### chore
- **AI Rules Manager v0.1.3** — VS Code extension manifest 與 lockfile 版本升級到 `0.1.3`，產物檔名為 `ai-rules-manager-0.1.3.vsix`。

## [2026-05-18] `.gitignore` 策略整理與部署目標 managed block

### chore
- **Repository ignore cleanup** — 整理 root 與三平台 `.gitignore`，用狀態註解區分本機狀態、runtime logs、build artifacts 與追蹤例外。
- **Platform template hygiene** — 三平台模板 `.gitignore` 移除歷史殘留規則，並明確標示 `.agents/memory/` 預設是專案知識庫、不忽略。

### feat
- **Managed target gitignore block** — `Set-GitignoreEntries` 改為寫入 `AI_RULES_GITIGNORE` marker block，Fresh/Upgrade 會集中管理 `.cartridge/` 與 `.agents/logs/`，並保留目標專案既有規則。

### docs
- **Deployment ignore policy** — 根 README 補充框架 repo 自身與部署目標專案的 `.gitignore` 差異。

## [2026-05-18] 三平台共用子代理啟用政策

### feat
- **Shared subagent invocation policy** — 新增 `Shared/policies/subagent-invocation.md` 作為子代理啟用語義唯一來源，並轉譯到 Codex native subagents、Claude `Agent` tool 與 Antigravity browser / CLI adapter。
- **Policy marker sync** — 部署與專案同步流程會把 Shared policy marker block 注入三平台核心規則，避免手動維護三份子代理政策。
- **Subagent drift audit** — Doctor 新增 shared subagent policy drift 檢查，若三平台 marker block 與 Shared policy 不一致會回報治理紅黃燈。

### docs
- **Delegation channel model** — `delegation-strategy` 擴充為 direct / native subagent / browser subagent / CLI analytical subagent / MCP tool，並明確 MCP 是主代理工具，不是委派目標。
- **三平台文件同步** — 更新根 README、三平台 README 與能力矩陣，說明子代理政策採共用語義與平台轉譯。

### chore
- **Patch versions** — Antigravity `8.0.3`、Claude Edition `1.2.3`、Codex Edition `0.1.3`。

## [2026-05-18] 分類式專案規則同步與相容性修復

### feat
- **Platform-aware project sync** — VS Code 管理器的專案同步改為「同步已安裝平台規則」，並新增 Codex / Claude / Antigravity 單平台同步入口。
- **Auto detection for installed platforms** — `SyncProjectRules` 新增 `-ProjectPlatform Auto|Codex|Claude|Antigravity`，Auto 只同步目前專案實際安裝的平台。

### fix
- **Codex version anchor isolation** — Codex live 版本錨點改為 `.codex/VERSION`，不再覆寫 Antigravity 使用的 `.agents/VERSION`。
- **Single-platform compatibility** — 未安裝平台只回報 Yellow，不自動建立 `.codex`、`.claude` 或 Antigravity rules/workflows。

### chore
- **Patch versions** — Antigravity `8.0.2`、Claude Edition `1.2.2`、Codex Edition `0.1.2`、AI Rules Manager VSIX `0.1.2`。

## [2026-05-18] Project skill 連結治理與版本更新

### feat
- **Project skill link governance** — Doctor 現在同時檢查 `.agents/skills/project-*` 與 `.claude/skills/project-*`，可抓出缺連結、壞連結、連到錯誤目標與實體目錄混入。
- **Project skill backfill repair** — `SyncProjectRules -Apply` 會補建或修復 discovery 連結，保留 `.agents/project_skills/` 作為唯一原檔區。

### chore
- **Patch versions** — Antigravity `8.0.1`、Claude Edition `1.2.1`、Codex Edition `0.1.1`、AI Rules Manager VSIX `0.1.1`。

## [2026-05-18] 三平台總監可讀治理修復

### feat
- **Workflow output contract coverage** — 三平台所有 workflow / command / workflow skill 皆明示總監可讀輸出契約；此早期版本要求固定白話表格，已由 2026-05-29 的情境式輸出契約取代。
- **Director output contract audit** — `Doctor` 新增輸出契約覆蓋率檢查，直接掃 source workflow、Codex live workflow 與目前專案 `.codex/AGENTS.md`。
- **Project rules sync** — VS Code 管理器新增「同步目前專案規則」，與「同步使用者層規則」分開處理，避免把全域 bootstrap 同步誤認為專案治理同步。

### fix
- **Codex live governance drift** — 將目前專案 `.codex/AGENTS.md` 對齊 `Codex/.codex/AGENTS.md`，確保 Codex 實際載入總監可讀輸出契約。
- **Project skill link hygiene** — 健康檢查新增 project skill 連結檢查，並清理本機已失效的 `project-ag_backup_project_443698824` 符號連結。

## [2026-05-18] VS Code 管理器相容性與跨專案支援

### feat
- **VS Code 管理入口強化** — 支援跨專案自動建立 AI_Rules 管理快取，讓一般專案也能直接使用側邊欄治理操作。
- **VS Code 插件產品圖** — 新增 Marketplace / VSIX 顯示用產品圖，並保留 Activity Bar 專用圖示。

### fix
- **Windows PowerShell 5.1 相容** — 管理器後端腳本固定為 UTF-8 with BOM，避免 VS Code extension 預設 `powershell.exe` 解析中文輸出時失敗。
- **VS Code 狀態判斷修正** — 避免把「無更新」或零值健康檢查結果誤判為需要處理。

## [2026-05-17] 總監可讀輸出契約

### docs
- **總監可讀輸出契約（Director-readable output contract）** — 三平台核心規則新增「總監可讀輸出契約」；此早期版本要求固定白話表格，已由 2026-05-29 的情境式輸出契約取代。
- **建構/修復計畫模板** — Codex 的建構流程規則（03-build-建構）與修復流程規則（04-fix-修復）要求計畫先用白話摘要，避免以檔名、內部欄位、資料結構或命令參數作為第一層說明。

## [2026-05-17] VS Code 延伸模組管理器

### feat
- **AI Rules Manager VS Code extension** — 新增 `Extensions/vscode-ai-rules-manager/`，提供左側側邊欄按鈕：檢查更新、查看更新內容、套用更新、健康檢查、同步全域規則、清理孤兒檔案。
- **按鈕式治理後端** — 新增 `Scripts/AI-RulesManager.ps1`，作為 VS Code extension 與既有 PowerShell 治理引擎之間的穩定入口。
- **Runtime drift 巡檢** — `Deploy.ps1 -Action Audit` 新增使用者層全域規則漂移報告，能指出 `~/.codex/AGENTS.md` 等 runtime 規則與 repo source 不一致。

### fix
- **Global dry-run/apply 分離** — `Deploy.ps1 -Action Global` 預設只報告差異；必須加 `-Apply` 才會寫入使用者層全域規則，且寫入前建立備份。
- **VS Code 安全操作流** — 套用更新、同步全域規則、清理孤兒檔案都保留確認閘門；唯讀按鈕不修改檔案。

## [2026-05-17] 基底治理語義修復

### fix
- **Governed global bootstrap** — 三平台全域觸發器不再未授權自動下載執行；未初始化等待 `GO INSTALL`，升級等待 `GO UPGRADE`。
- **Workflow 權限語義對齊** — Antigravity audit logic 改為 `filesystem:write:logs`，測試 workflow 僅輸出失敗報告，commit workflow 在 GO 後才寫 CHANGELOG、stage 明確清單、commit、push。
- **MCP HITL 邊界補強** — 高風險 Shared skills 補入標準 HITL/GO 邊界，明確區分 schema discovery 與 mutating execution。
- **Governance Semantics audit** — `Deploy.ps1 -Action Audit` 新增語義紅黃燈，掃描舊路徑、自動安裝、blanket staging、automation-safe 變異與 MCP HITL 缺口；紅燈 exit 1，黃燈只報告。

## [2026-05-17] 三平台代理治理升級

### feat
- **平台能力矩陣** — 新增 `Shared/platform-capability-matrix.md`，以 `native` / `adapter` / `manual` 對齊 Antigravity、Claude Edition、Codex Edition 的 Skills、commands、AGENTS/CLAUDE/GEMINI 載入、MCP、subagents、automation 與權限模型。
- **Workflow metadata v2** — 三平台 workflow / command frontmatter 補齊 `kind`、`platforms`、`lifecycle_phase`、`role`、`memory_awareness`、`tool_scope`、`human_gate`、`automation_safe`。
- **例行巡檢工作流** — 新增 `10-routine-巡檢` / `10_routine(巡檢)`，作為 automation-safe 唯讀巡檢入口；任何寫入、安裝、記憶歸卡、commit、push 仍需 GO。
- **MCP opt-in profiles** — 新增 `Shared/mcp-profiles/` 設定片段，明確不在升級流程中自動安裝外部 MCP server 或改動全域工具設定。

### fix
- **技能品質審計相容性** — `Measure-SkillQuality` 改以 `metadata.kind` 和實際目錄判斷 workflow，不再用英文 slug 規則誤判中文 Codex workflow。
- **平台代理治理巡檢** — `Deploy.ps1 -Action Audit` 新增能力矩陣、workflow metadata、MCP profile、文件數字與記憶卡漂移檢查。
- **文件數字漂移** — 同步更新 Shared 36、Codex workflow 17、Claude commands 14、Antigravity workflow files 20、Codex total skills 53 等公開數字。

## [2026-05-17] 公開安裝入口相容性升級

### fix
- **Windows PowerShell 5.1 中文環境相容** — 公開安裝指令改為下載 raw bytes、以 UTF-8 解碼並用 UTF-8 BOM 寫入暫存腳本，避免舊版 PowerShell 將中文腳本誤判為 ANSI/Big5。
- **部署腳本編碼標準化** — 三平台遠端啟動器與統一部署引擎腳本統一保存為 UTF-8 with BOM，提升 PowerShell 5.1 與 PowerShell 7 解析穩定性。

### docs
- **CMD 相容入口** — 根 README 新增 `cmd.exe` wrapper 指令，讓非 PowerShell 終端也能啟動 Antigravity 管理控制台。
- **通用 Shell 管理控制台入口** — 管理控制台 wrapper 改為 `-EncodedCommand`，避免使用者在 PowerShell 中貼上 CMD 範例時，外層 Shell 提前展開 `$` 變數造成 ParserError。

## [2026-05-17] Antigravity 遠端管理控制台啟動修復

### fix
- **`-Mode Menu` 參數驗證修復** — 修正 `Antigravity/install.ps1` 的 `ValidateSet` 未包含 `Menu`，導致 README 管理控制台指令在進入部署邏輯前即被 PowerShell 拒絕的問題。

## [2026-05-17] Gateway 與記憶卡工具規範同步

### feat
- **Gateway 真實呼叫合約** — 三平台規範明確區分 Gateway schema 探索與下游 MCP 真實執行；真實呼叫必須透過 `gateway__call_tool`，並顯式帶入 `workspace`。
- **cartridge-system 路徑紀律** — 記憶卡工具規範要求下游參數同步帶入 `projectRoot`，避免依賴 Gateway 全域 workspace 狀態。
- **記憶治理工具分級** — 將 `workspace_brief`、`memory_audit`、`commit_preflight` 納入唯讀診斷工具；將 `memory_commit` 明確列為會寫檔的高風險歸卡工具。

### docs
- **三平台文件同步** — 更新根 README、Antigravity、Claude Edition、Codex Edition 與 Codex/Claude 規範，改用「Gateway 統一入口 + cartridge-system 下游工具」模型描述記憶卡操作。

## [2026-05-13] 部署引擎安裝缺陷修復

### fix
- **記憶備份還原機制 (D17)** — 修正 `Core.psm1` 的 `Copy-Item` 語意缺陷（加 `\*`），防止每次 Fresh 安裝在 `.agents/memory/` 產生嵌套垃圾目錄（影響三個平台）
- **Codex 治理規則部署 (D17)** — 修正根 `.gitignore` 誤以全域規則排除 `Codex/.codex/` 源碼，使 AGENTS.md 等治理規則可被 git 追蹤並出現在 GitHub ZIP 封存
- **部署終端機輸出精簡 (D17)** — 三平台（Antigravity/Claude/Codex）技能注入函式回傳值統一以 `$null` 吸收（共 7 處），消除終端機孤立數字噪音

### chore
- **記憶庫衛生維護** — 清理前次安裝遺留的嵌套備份垃圾目錄（`ag_backup_memory_774906873`），並同步更新兩張受影響的記憶卡（`_system`、`claude-edition-rules`）

## [2026-05-13] 全域規則安全閘門與遠端一鍵管理機制

### feat
- **全域規則安全閘門 (D15)**: 實作基於 SHA256 雜湊比對的規則更新機制。當偵測到使用者全域設定（如 `~/.gemini/GEMINI.md`）與框架最新版本有衝突時，系統將不強制覆寫，而是將最新規則產出至專案內的 `.agents/global_stage/` 安全暫存區，確保自動化更新不破壞個人化配置。
- **管理機制遠端一鍵指令化 (D16)**: 強化 `Antigravity/install.ps1` 支援 `-Mode Menu` 遠端引導模式。現在總監只需從 GitHub README 複製一段單行指令貼上，即可直接啟動完整的互動式管理控制台，實現「README 即控制台」的零依賴維護體驗。
- **框架控制台 (Deploy.ps1) 升級**: 優化選單入口，將全域規則安裝升級為「全域規則安全閘門」，並加入對應的 SHA256 比對引擎（Core.psm1）。

### chore
- **README.md 控制台文檔化**: 於根目錄 README.md 加入「框架控制台與日常維護」區段，正式定義一鍵管理指令與選單功能解說。
- **記憶卡架構同步與幽靈收編**: 完成全平台記憶卡過期指數 (Staleness) 清零。收編 Codex 版共用閘門與 `.gitignore` 等未歸屬檔案至 `_codex_core` 記憶卡。

## [2026-05-12] 框架文檔與工作流目錄合規修正

### feat
- **工作流目錄標準化**: 將 17 套工作流技能目錄由舊式的括號格式（如 `00_chat(討論)`）全面重命名為符合標準的破折號格式（如 `00-chat-聊天`），解決路徑特殊字元可能引發的解析問題。
- **Codex 橋接設定支援**: 部署腳本（Deploy.ps1）新增對 Codex Edition 的 `config.toml` 回退橋接支援（`project_doc_fallback_filenames`），使原生工具能精確定位治理哨兵檔。

### chore
- **跨平台技術文件精確對齊**: 徹底審查並修正四份 README.md（根目錄、Codex、Antigravity、Claude Edition）。統一架構圖中的指令路徑，移除不存在的 CHANGELOG 引用，更正總技能數為 53 套，並強化「三平台架構」的用語一致性。
- **倉庫衛生與記憶卡清理**: 執行 09-1 狀態掃描，移除 `.cartridge/index.json`、`.codex/AGENTS.md` 等不再追蹤的殘留檔案，並同步更新 5 張核心記憶卡，確保框架處於健康狀態。

## [2026-05-11] 統一部署引擎 + Codex Edition v0.1.0

### feat
- **三平台統一部署引擎（D12）**: 廢除各平台分散部署腳本（8 支），建立 `Scripts/` 統一引擎（6 模組，減少 40% 代碼量）。`Scripts/Deploy.ps1` 支援選單模式與參數模式兩用。
- **操作型技能單一真實來源（D12）**: 36 套操作型技能從各平台目錄統一遷移至 `Shared/skills/`，部署時由 `Skills-Sync.psm1` 自動注入三個平台，消除多份副本維護問題。
- **Codex Edition v0.1.0（D12）**: 新增第三個平台適配層（OpenAI Codex / agentskills.io），含首批 Codex 工作流技能、`.codex/AGENTS.md` 哨兵治理規則；現行框架共支援 53 套技能。
- **三平台全局觸發器版控（D12）**: 新增 `Antigravity/global/`、`Claude/global/`、`Codex/global/` 目錄，版控各平台全局觸發器，由 `-Action Global` 同步。

### fix
- **符號連結靜默失敗修復（D13）**: `Invoke-ProjectSkillBackfill` 加入 Junction 降級回退 + `Test-Path` 驗證，解決 Windows 無 Developer Mode 時靜默誤報成功問題。
- **技能目錄升級嵌套 Bug 修復（D13）**: `Merge-WorkflowSkills` 改為複製目錄內容（`path\*`）而非目錄本身，修復 Codex Upgrade 後產生嵌套結構的問題。
- **PSScriptAnalyzer 動詞合規修復（D14）**: 重命名 3 個未授權 PowerShell 動詞（`Ensure-*` → `Initialize-*/Set-*`、`Append-Section` → `Add-ReportSection`），消除靜態分析警告。

### chore
- **四份 README.md 全面更新**: 根目錄、Antigravity、Claude Edition、Codex Edition 四份技術文件對齊統一引擎現況（架構圖、部署說明、目錄結構）。

## [2026-05-06] v4.0 Memory Architecture

### docs: README 全面重構與設計語感升級
- **母機總覽文件 (README.md)**: 導入問題導向敘事（說明 AI 失憶與無紀律痛點），加入 Badge 徽章系統（版號/平台/授權）與 Emoji 標題層次，將目錄移至安裝說明之前，全面對齊 `cartridge_system` 的專業開源文件標準，同時保留所有架構與技術細節。

### feat(deploy): 安裝指令體驗優化
- **免手動指定目錄**: 調整 `Antigravity/install.ps1` 與 `Claude/install.ps1` 的 `-Target` 參數為可選項，預設值改為 `$PWD.Path`。使總監能在 IDE 終端機直接複製並執行指令，實現當前目錄自動安裝，大幅簡化操作流程並向下相容舊有指令。

### feat(memory): 治理架構升級 (幽靈偵測與依賴傳播)
- **幽靈檔案偵測 (Ghost Detection)**: 於 `memory-ops` 技能新增 `ghostFilesCount` 處理邏輯。當模組內追蹤檔案已在磁碟刪除時，自動清除殘留路徑；並新增全幽靈卡匣自動汰除建議。此邏輯同步實裝至 Antigravity (`03_memory_skill_contract.md`) 與 Claude (`memory-contract.md`) 版的退出閘門。
- **依賴感知傳播 (Dependency Propagation)**: 於 `memory-ops` 新增 `indirectStaleness` 上游依賴過期感知機制，並在 `memory-arch` 加入 `dependencies` 評估步驟；同步更新 `memory-template.md` 支援依賴關係宣告。
- **跨平台對等**: 持續落實 D06 原則，同步完成 Antigravity 與 Claude Edition 雙引擎的記憶操作技能與系統合約的 v4.0 升級。
- **文件更新**: 升級三份 `README.md`，納入記憶系統的幽靈檔案偵測與依賴傳播機制說明。

## [2026-05-05] Antigravity v8.0.0 / Claude Edition v1.2.0

### feat(deploy): 雙引擎部署腳本全面繁中本土化與功能對等升級
- **全繁中行內說明**: 為 `Deploy-Antigravity.ps1`（622 行）與 `Deploy-Claude.ps1`（480 行）補回完整的繁體中文行內說明，涵蓋參數定義、函式邏輯、效能最佳化原因（時間戳優先比對）、D06 安全防線設計及各階段流程說明。
- **歷史包袱清除**: 移除 Antigravity 版部署引擎中的舊版記憶卡遷移邏輯（`skills/mem-*` → `memory/` 遷移）與 `$SkipDemo` 清除流程，精簡為現代四階段架構。
- **功能缺口補齊**: Claude Edition 部署引擎新增確認閘門機制（`Get-UpgradeReport` → 分類顏色差異報告 → 互動式確認）、CHANGELOG 更新說明擷取（`Get-ReleaseNotes`）及衍生技能自動補建（`Invoke-ProjectSkillBackfill`）。
- **安裝啟動器修正**: 修正 `Antigravity/install.ps1` 的 ZIP 解壓路徑邏輯，確保可靠的遠端部署。

### feat(claude-commands): Claude Edition 工作流指令重構
- **目錄命名標準化**: 將 `03-1_experiment`、`07_debug`、`08_audit(除錯)` 等指令目錄更名為符合中文標示規範的名稱（`03-1_experiment(實驗)`、`07_debug(除錯)`、`08_audit(健檢)`）。
- **共用閘門抽離**: 新增 `_shared/` 目錄，收容 `_completion_gate.md` 與 `_security_footer.md` 共用閘門。
- **多道指令內容更新**: 更新架構、修復、紀錄、交接、技能鍛造等工作流指令的內容結構。

### docs: 三份 README 全面更新
- **根目錄 README**: 架構圖加入行數與繁中註解標示、部署模式加入 D06 安全網流程、安全防護新增確認閘門與衍生技能補建段落。
- **Antigravity README**: 部署引擎段落加入行數說明、移除舊版遷移描述、安全防護改為表格化。
- **Claude README**: 部署引擎段落加入行數與對等說明、安全防護統一為表格化格式。

### chore: 版本號升級
- Antigravity: v7.0.0 → v8.0.0
- Claude Edition: v1.2.0 → v1.2.0

## [Unreleased]

### feat(claude): 雙引擎架構對等升級 (D06)
- **架構升級**: 補齊 Claude Edition 缺失的 3 個輔助腳本 (`Invoke-DocScan.ps1`, `Invoke-HealthAudit.ps1`, `Measure-SkillQuality.ps1`)。
- **佈署引擎優化**: 升級 `Deploy-Claude.ps1`，加入 `try/finally` 安全網、升級模式彩色差異報告與 `VERSION` 追蹤機制，達致與 Antigravity 同等之健壯性。
- **記憶卡同步**: 建立 D06「雙引擎功能對等原則」決策，並修復 `claude-edition-rules` 及 `_system` 記憶卡之過期狀態 (staleness 重置為 0)。
- **目錄純化**: 將 12 個工作流指令與 36 個操作技能從舊版的 `agents/skills/` 徹底遷移至符合官方規範之 `.claude/commands/` 與 `.claude/skills/`。
