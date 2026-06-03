# _system Archive Volume 002

This volume continues the legacy _system card preserved before schema v2 compaction on 2026-06-04.

Source continuation starts after D39 from archive-001.md.

- **D40: 插件交付治理共用化 (2026-05-19)**: `plugin-release-governance` 成為第 37 套 Shared operational skill，負責插件升版、VSIX 打包、GitHub Release/tag/asset 與更新提醒流程；插件發布相關 workflow/command 入口只加載入閘門，不複製完整 playbook。
- **D41: Skill 觸發可靠性治理 (2026-05-19)**: 三平台 workflow/command description 統一補成 `Use when` 口徑；Doctor 同時檢查 Shared operational skill 的中英觸發詞、負向邊界，以及 workflow 入口是否描述何時啟動。
- **D42: VSIX Release Node 24 路線 (2026-05-19)**: `.github/workflows/release-vsix.yml` 改用支援 Node 24 runtime 的官方 GitHub Actions，並以 Node 24 打包 VSIX；這是發布基礎設施維護，不代表 AI Rules Manager 功能版本升級。
- **D43: 插件更新提醒靜默合約 (2026-05-19)**: AI Rules Manager 啟動自動檢查 GitHub latest release 時，只有新版才通知操作者；沒有新版或暫時無法檢查時只寫入 Output Channel。手動「檢查插件新版」才回報已是最新版或錯誤。
- **D44: 三平台子代理治理建構 (2026-05-22)**: 子代理治理正式收斂為「Shared 共用語義 + 平台 adapter」。Shared 層只定義 Delegation Gate、evidence branch、唯讀邊界、主代理整合責任與固定證據包格式；Antigravity / Gemini、Claude Code、Codex 各自在平台入口轉譯成對應子代理或插件能力。Doctor 新增 Subagent Vocabulary Drift，避免 Shared 技能硬寫平台工具名，也避免 Codex workflow 混入 Claude 舊式 Agent subagent_type 語彙。
- **D45: Subagent vocabulary Red gate (2026-05-22)**: 04-fix 將 Shared 未標註平台子代理工具名從 Doctor Yellow 提升為 Red；Shared 主體不得硬編平台狀態檔、子代理工具名或 CLI 工具函式名，合法平台語彙只能出現在明確標示的 adapter / 平台轉譯區塊。
- **D46: Doctor PS5.1 Join-Path 相容修復 (2026-05-22)**: `Measure-SubagentVocabularyDrift` 的 Codex 掃描根目錄改用具名參數與括號包覆的 `Join-Path`，避免 VS Code extension / Windows PowerShell 5.1 將多個路徑誤綁成 `ChildPath` 陣列而中斷平台治理巡檢。
- **D47: AI Rules Manager v0.1.8 更新語意精準化 (2026-05-22)**: 插件面板、Command Palette、確認視窗、`AI-RulesManager.ps1`、README 與 CHANGELOG 統一把「檢查來源狀態 / 更新 AI_Rules 來源庫 / 檢查 VSIX 新版 / 治理巡檢 Doctor / 同步已安裝平台規則」拆成不同語義；extension 版本升到 `0.1.8`，但本次不自動產出 VSIX、tag 或 release。
- **D48: 技術詞彙翻譯閘門 (2026-05-29)**: 三平台面向總監的輸出不得裸露函式名稱、變數名稱、欄位名稱、命令參數、內部工具名或檔案路徑；每一次提到都必須先寫白話名稱，技術名稱只能放在白話名稱後方的括號內。治理巡檢（Doctor）的總監可讀輸出檢查（Director Output Contract）同步檢查此閘門，避免只有表格合格但內容仍看不懂。
- **D49: 技術詞彙括號規則硬化 (2026-05-29)**: 治理巡檢（Doctor）的總監可讀輸出檢查（Director Output Contract）不只確認有技術詞彙翻譯閘門，也要確認規則明示「技術名稱只能放在括號內」與「技術名稱不得單獨出現」；三平台規範標題同步改成中文在前、英文在括號內。
- **D50: 情境式總監可讀輸出契約 (2026-05-29)**: 總監可讀輸出不再每次強制表格。一般討論、狀態回報與簡短判斷可用短段落或短清單；正式計畫、寫入前風險、多檔案變更、完成報告、健檢報告與交接才使用表格或結構化摘要。表格欄位統一為「事項、位置、影響、狀態」，技術詞彙仍必須維持白話名稱在前、技術名稱只放括號內。
- **D51: 表格位置欄精準定位 (2026-05-29)**: 總監可讀表格的「位置」欄不得只寫概念詞，必須先寫白話位置，再用括號標出具體檔案、區塊、工具狀態或目錄範圍；若不是單一檔案，也要明說它是工作區狀態、工具結果或目錄範圍。治理巡檢（Doctor）的總監可讀輸出檢查（Director Output Contract）同步檢查此規則。
- **D52: 事實優先與知識新鮮度治理初版 (2026-05-29)**: 三平台核心規範與工作流入口新增以證據校正總監提議、短證據格式與知識新鮮度查證基礎規則。記憶與內建知識都視為可能過時，高變動資訊需查最新或官方來源，並以版本與目前日期作為查證錨點；此決策已由 D53 升級為中立誠實協作口徑。
- **D53: 中立誠實協作契約 (2026-05-29)**: 證據校正規則升級為中立誠實協作。AI 不以討好、附和或迎合總監為目標，也不得為了顯得有批判性而刻意反對；合理時明確支持，證據衝突時直接指出問題並提出可行替代做法。治理巡檢同步檢查中立誠實、不討好不附和、不刻意反對、短證據格式與知識新鮮度規則。
- **D54: 位置索引式輸出契約 (2026-05-29)**: 正式計畫、完成報告與巡檢報告可用短名稱保持可讀性，但同一份輸出必須提供「位置索引」，把「核心規範、工作流入口、文件說明、巡檢規則、記憶卡」這類短名稱對應到具體檔案、章節、工具狀態或目錄範圍。治理巡檢同步檢查此規則，避免短名稱停留在抽象分類。
- **D55: AI Rules Manager source update guard (2026-05-29)**: `AI-RulesManager.ps1` 更新 AI_Rules 來源庫時，若 managed clone 分叉、本機領先、工作樹有變更或 `git pull --ff-only` 失敗，必須立即停止並不得繼續跑 Doctor，避免更新失敗被後續綠燈巡檢掩蓋。
- **D56: 遠端來源鏡像與排除檔補缺 (2026-05-29)**: AI Rules Manager 在一般專案使用的使用者層 AI_Rules 快取必須視為遠端版本庫鏡像，執行管理動作前先對齊遠端；專案規則同步前若來源未對齊遠端必須停止。排除檔策略已由 D64 升級為根目錄錨定管理區塊，仍不得整理或覆蓋非 AI Rules 相關專案自訂規則。
- **D57: 插件來源設定信任邊界 (2026-05-29)**: VS Code extension 中會改寫 AI_Rules 來源、遠端網址或 PowerShell 執行檔的設定只能放在使用者層設定；專案 workspace 設定若提供這些值，extension 必須停止。同步與清理預覽失敗時，不得再進入確認或寫入階段。
- **D58: AI 開發品質治理共用化 (2026-05-29)**: 新共用技能集中處理技術新鮮度、元件復用、偏好探索、設計參考降級與三尺寸響應式證據；根 README、三平台 README 與 CHANGELOG 同步記錄此治理語義，後續由 D59 的專案脈絡層更新最終技能數字。
- **D59: 專案脈絡層建構 (2026-05-29)**: 建立 `.agents/context/` 作為與 `.agents/memory/`、`.agents/project_skills/` 平行的專案知識資產，用 `CONTEXT.md` 保存設計 DNA、產品偏好、技術偏好、溝通偏好與驗收偏好。Shared 操作型技能增至 39 套，Codex 部署後技能總數增至 56 套（39 Shared + 17 workflow）。Fresh、Upgrade、同步與孤兒清理都必須保護 `.agents/context/`，治理巡檢新增脈絡卡欄位、狀態、核准與誤放檢查。
- **D60: project-context-protocol 前綴例外 (2026-05-29)**: `project-context-protocol` 是正式 Shared skill，不是 project skill discovery 連結。同步器與巡檢器需在 `project-*` 排除與檢查規則中保留此技能，否則來源文件、技能品質掃描、下游實際技能目錄與治理巡檢會互相分裂。
- **D61: Shared 專案脈絡模板來源 (2026-05-29)**: 專案脈絡索引卡改由 `Shared/context/_map/CONTEXT.md` 作為可見 source template。部署初始化優先從 Shared 模板補建缺少的 `.agents/context/_map/CONTEXT.md`，若模板遺失才使用內建 fallback；既有脈絡卡仍受保護，不因 Fresh、Upgrade、Sync 或孤兒清理而被覆蓋。
- **D67: UI 設計探索治理 (2026-05-31)**: 新增 `ui-design-exploration` 共用技能，將 UI 需求探索、網路研究、操作者意圖、共用元件盤點、三案比較、HTML 展示頁或視覺參考選擇、設計 DNA 與專案衍生技能沉澱制度化。Shared 操作型技能更新為 40 套，Codex 部署後技能總數更新為 57 套。
- **D62: 管理器同步補齊專案脈絡基礎設施 (2026-05-29)**: `AI-RulesManager.ps1` 的專案規則同步在 `-Apply` 階段也會呼叫基礎設施初始化，補建 `.agents/context/_map/CONTEXT.md` 與 `.gitignore` 追蹤註記。這確保既有專案只透過 VS Code 管理器同步規則時，也能取得與 Fresh / Upgrade 一致的脈絡層。
- **D63: AI Rules Manager v0.1.12 發布批次 (2026-05-29)**: 因本次治理更新改變 VS Code 管理器的專案同步可見行為，延伸模組版本升級為 `0.1.12` 並準備透過 `v0.1.12` tag 觸發 GitHub Actions 打包 VSIX。CHANGELOG 需保留 `AI Rules Manager v0.1.12` 章節，讓 release notes 來源明確。
- **D64: 根目錄錨定 `.gitignore` 治理 (2026-05-29)**: Fresh、Upgrade 與專案同步預設補入根目錄錨定的 AI Rules `.gitignore` 管理區塊；框架部署產物與本地執行狀態不進版控，`.agents/memory/`、`.agents/context/`、`.agents/project_skills/` 明確放行。VS Code 管理器另提供版控排除規則健檢，可選不覆蓋或覆蓋整理；覆蓋只移除 AI Rules 相關寬鬆規則與舊管理區塊，不影響其他專案自訂規則。
- **D65: `.gitignore` 中文註解編碼熱修復 (2026-05-29)**: `Core.psm1` 的 `.gitignore` 管理流程改用專用文字讀寫，讀取時支援既有 UTF-8、UTF-8 BOM、UTF-16 與舊 ANSI 檔案，寫回時固定使用 UTF-8 BOM。AI Rules Manager v0.1.14 作為 v0.1.13 的 hotfix 版本，避免中文註解在 VS Code 或 Windows PowerShell 5.1 情境下變成亂碼。
- **D66: `.gitignore` 精準標準規則與相似清單分離 (2026-05-29)**: Fresh、Upgrade、同步與一般 `Gitignore` 套用流程只整理目前版本自己產生的繁中標準註解與 AI Rules 完全相同的標準規則行，再把帶繁中註解的最新標準規則補到檔案底部；不再判斷舊版註解、marker 區塊、上下行或相似寬鬆規則。VS Code 管理器的版控排除規則健檢只列出相似規則清單，操作者選擇清理時才刪除清單中的具體相似規則行。AI Rules Manager v0.1.15 重新打包記錄此安全修復。

## Known Issues

- 無

## Module Lessons

- **D01: 子模組 (Submodule) 封裝陷阱**: 當需要將內部帶有 `.git` 隱藏目錄的專案（如底層框架或工具包）以實體檔案全數上傳至外部 GitHub 儲存庫時，**絕對不可以**讓內部的 `.git` 與外層追蹤發生重疊。這會觸發 Git 的保護機制將其視為 Submodule，導致遠端只收到一個無法展開的 Commit 指標空殼。若要確保外層上傳實體檔案，必須先移除或隱藏內部的 `.git` 目錄。
- **D02: 核心記憶外洩防護 (Deploy Engine)**: 在設計佈署邏輯（如 `Copy-Item -Recurse`）拷貝框架檔案時，若來源端 (如母機) 存在不該流出的專案獨有資產（如 `memory`、`project_skills`），**必須改用細粒度過濾（源頭阻斷複製）**。絕對禁止先暴力整包複製再從目標端刪除，否則一旦在全新環境執行，母機的髒資料就會瞬間污染子專案，引發外洩。
- **D03: 文件同步防腐防線 (Doc-Sync Guard)**: 為了防止程式碼更新但外部 README/Docs 文件腐敗，必須在開發的結案查核閘門中設立**強制阻擋機制 (Hard Gate)**。當更動到公共介面時，系統必須將文件同列為「受災戶 (Affected Documentation)」，若不更新文件，系統嚴禁結案。
- **D04: 冷啟動悖論與內核防禦 (Core Rules Integration)**: 高頻且具強制性的防偽機制（如跨語系雙面板、全息實體足跡收據），絕對不可僅以外部插件（SKILL）形式存在。因 AI 甦醒受捷徑惰性驅使時，極易捨棄額外的檔案調用（讀取外掛）導致防禦機制斷鏈。解決方案是廢棄該次級技能目錄，將防護格式實體硬寫入 `01_cross_lingual_guard.md` 等規則層，使其成為 AI 甦醒即啟用的內核反射。
- **D05: 工作流決策樹越權漏洞 (Decision Tree vs Imperative Steps)**: 當工作流中使用決策樹語法（`├──`、`└──`、`→`）描述需要與總監互動的閘門時，AI 會傾向於「在內部模擬走完整棵樹」來節省對話回合數，從而自行做出本應由總監決定的判斷。**凡是需要總監輸入的決策點，都必須使用命令式步驟搭配 `[MANDATORY HALT]` 標記**，明確禁止 AI 模擬選擇。（實際案例：`09_commit_log` §1.5 Part B 的文件更新閘門被 AI 自行跳過→待修復）
- **D06: Fresh 模式的雙保險 (Memory Survival Guarantee)**: 在設計覆寫式或備份與還原的腳本時，若執行過程中遭遇例外（如命令錯誤或人為中止），所有已經移至暫存區的記憶檔案將面臨物理遺失的風險。**強制規範**：所有涉及重要核心組件備份的還原運算，必須完全建立於 `try/finally` 安全網內，確保邏輯崩潰時，`finally` 區塊能無條件順利執行資產還原。
- **D07: Gateway schema 探索不等於工具測試**: `gateway__search_tools` / `gateway__list_server_tools` 只能確認工具名稱與參數結構；要宣稱下游 MCP 已實測，必須透過 `gateway__call_tool` 執行。
- **D08: 公開 PowerShell 腳本需防 UTF-8 無 BOM 陷阱**: 含中文註解或輸出的 `.ps1` 若以 UTF-8 無 BOM 從 GitHub raw 下載，Windows PowerShell 5.1 可能用系統 ANSI code page 解析並造成字串截斷；公開入口必須強制 UTF-8 BOM 暫存寫入。
- **D09: 巢狀 PowerShell 指令避免裸 `$` 變數**: 若文件提供 `powershell.exe -Command "..."` 形式的 wrapper，使用者在 PowerShell 外層貼上時會先展開內層 `$wc`、`$bytes`、`$text` 等變數，導致第二層 PowerShell 收到壞語法；跨 Shell 公開入口應使用 `-EncodedCommand` 或明確分流。
- **D10: 全域 bootstrap 不是安裝授權**: 全域規則只能偵測專案是否初始化；下載遠端 installer、寫檔、升級框架都必須等 `GO INSTALL` / `GO UPGRADE`，避免把錯誤基底規則自動標準化到新專案。
- **D11: 本地公共 `.ps1` 也要驗證 5.1**: repo 內被 VS Code extension 或一鍵入口呼叫的 `.ps1` 若包含非 ASCII，驗收必須同時跑 Windows PowerShell 5.1 與 PowerShell 7，避免只在 `pwsh` 通過但在 extension 預設路徑失敗。
- **D12: CHANGELOG 也會觸發系統記憶同步**: `_system` 追蹤根變更紀錄；即使只是提交流程補寫變更紀錄，也要在提交前確認系統記憶內容已涵蓋該決策並重新歸卡。
- **D13: 直接讀檔優先於腳本信任**: Doctor 全綠前仍需抽查實際 `SKILL.md` / `AGENTS.md` 內容；本次直接讀檔發現 Codex `03-build` / `04-fix` 的 `automation_safe` 縮排錯誤，以及 Claude `08_audit` 子命令未被舊掃描口徑納入。
- **D14: Project skill 原檔不可混入 discovery 目錄**: `project-*` 若是實體目錄代表隔離設計失效，應由 Doctor 報 Red，不能由 backfill 自動刪除或覆寫。
- **D15: 框架模板差異與專案身份差異要分層**: 同一個核心規則檔可能同時承載框架規則與專案身份；同步工具必須只管理框架層，保留專案層。
- **D16: Skill 不能承擔 always-on 安全底線**: Skill 是按需載入的知識壓縮層，不是冷啟動安全規則；凡是 GO gate、禁止靜默安裝、禁止 blanket staging 等不可漏行為，仍必須存在於核心規則或 workflow 入口。
- **D17: Workflow description 是路由介面**: workflow / command 的 `description` 不應只描述內部步驟，也要寫出總監會怎麼觸發；否則 AI 可能知道流程存在，卻不會在正確任務自動載入。
- **D18: 子代理是證據分支，不是第二個交付主代理**: 三平台可以用不同的 subagent / plugin / browser 能力蒐證，但 GO、memory、commit、push、部署與 mutating MCP 永遠留在主代理整合，Shared 規範不得把任一廠商工具名當成共用語義。
- **D19: Shared vocabulary drift 必須阻斷**: 若 Shared 主體硬寫平台工具名，代表共用語義已被污染；Doctor 應回 Red，而不是只提示 Yellow。
- **D20: Doctor 模組要兼容 extension 的 Windows PowerShell 5.1 host**: 即使 `pwsh` 與互動 shell 可通過，VS Code extension 仍可能走 Windows PowerShell 5.1；`Audit.psm1` 新增語法時必須用保守、具名參數寫法並同時驗證兩個 host。
- **D21: 來源更新與專案同步不可共用模糊文案**: AI_Rules 管理來源庫、VSIX 安裝包與目前 workspace 治理規則是三個不同狀態面；公開文件與插件 UI 必須把「會寫哪裡」和「不會寫哪裡」同時講清楚。
- **D22: 技術詞彙可讀性不能只做首次翻譯**: 若後續描述改回裸技術詞，總監仍會失去脈絡；面向總監的每一次引用都要維持白話名稱，技術名稱只能放在白話名稱後方的括號內，且巡檢必須檢查此硬規則本身是否存在。
- **D23: 短名稱需要同份輸出內定位**: 為了避免每一條正式輸出都塞滿路徑，可以用短名稱降低閱讀負擔；但短名稱必須在同一份輸出用位置索引補回具體檔案、章節、工具狀態或目錄範圍，否則總監仍無法追蹤實際位置。
- **D24: `.gitignore` 自動流程只處理精準標準行**: 部署到一般專案時，排除檔可能已有使用者自訂註解、機密規則與工具產物規則；AI_Rules 自動流程只能刪除完全相同的 AI Rules 標準規則行並補最新標準規則，不得用註解、marker、上下行或模糊字樣推斷刪除範圍。歷史寬鬆規則只能由管理器健檢按鈕列清單，並在操作者明確選擇清理時刪除清單中的具體行。
- **D25: 預覽失敗不可接續寫入確認**: 只要同步或清理的 dry-run / preview 已失敗，UI 不應再問使用者是否套用；否則使用者會以為上一階段成功，只差確認。
- **D26: 偏好脈絡要與原始碼記憶分層**: `.agents/memory/` 只承載架構、檔案、依賴、stale 與治理事實；`.agents/context/` 承載長期偏好與設計 DNA，不走 `memory_commit`，也不參與原始碼記憶的 stale 傳播。
- **D27: 受保護知識資產包含脈絡層**: 部署、升級、專案同步與孤兒清理的保護清單必須同時包含 `memory`、`project_skills`、`context`，避免把總監核准過的偏好或設計 DNA 當成框架殘留刪除。
- **D28: 驗證要看部署後技能目錄**: 新增 Shared skill 時不能只看 `Shared/skills/` 計數；若同步器有排除規則，還要驗證 `.agents/skills/` 或 `.claude/skills/` 的實際注入結果。
- **D29: 脈絡模板也要進治理巡檢**: 專案脈絡層若只有部署程式內建字串，維護者看不到 source template；治理巡檢需同時檢查 Shared 模板存在與目標專案脈絡卡格式。
- **D30: Release notes 必須有版本專章**: VSIX 發布 workflow 會依 `AI Rules Manager v<version>` 標題擷取 release notes；升版打包前必須同步建立對應 CHANGELOG 章節，避免 GitHub Release 只有泛用文字。
- **D31: 管理器同步路徑要等同部署路徑**: 凡是 Fresh / Upgrade 會補齊的受保護知識層，VS Code 管理器的專案同步在套用時也要補齊；否則老專案可能得到新工作流規則，卻缺少其依賴的脈絡索引卡。
- **D32: 排除規則自動補齊必須根目錄錨定**: AI Rules 預設 `.gitignore` 只應管理專案根目錄的框架產物；歷史專案若有寬鬆規則，應交由使用者主動啟動的管理器健檢按鈕整理，不應在 Fresh / Upgrade 自動重排使用者規則。
- **D33: 被寫入的目標文字檔也需要編碼契約**: 不能只保護腳本本身的 UTF-8 BOM；只要框架會把中文註解寫進目標專案檔案，也必須用明確編碼寫回，避免 IDE 或舊版 PowerShell 以錯誤 code page 顯示。

## Documentation Files

- Antigravity/CHANGELOG.md
- Antigravity/README.md
- Antigravity/RELEASE_NOTES.md

## Relations

- 無

## Applicable Skills

- github-ops
