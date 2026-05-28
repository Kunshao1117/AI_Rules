# Changelog

All notable changes to this project will be documented in this file.

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
- **Delegation Gate semantic core** — `Shared/policies/subagent-invocation.md` 改為 vendor-neutral 的 Delegation Gate / evidence branch 模型，Shared 層只描述委派判斷、唯讀邊界、主代理整合責任與固定證據包格式。
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
