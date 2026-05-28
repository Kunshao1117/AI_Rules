---
name: _vscode_extension
description: >-
  AI_Rules VS Code 延伸模組與按鈕式管理入口。追蹤側邊欄 UI、命令註冊、PowerShell 腳本橋接、VSIX 打包設定與 Release
  asset 自動化。
scopePath: Extensions/vscode-ai-rules-manager
last_updated: '2026-05-29T03:44:48+08:00'
staleness: 0
status: stable
metadata:
  author: antigravity
  version: '1.0'
  origin: framework
  memory_awareness: full
  tool_scope:
    - 'filesystem:write'
    - 'mcp:cartridge-system'
---
# _vscode_extension 收容卡匣

## Tracked Files

- Extensions/vscode-ai-rules-manager/package.json
- Extensions/vscode-ai-rules-manager/package-lock.json
- Extensions/vscode-ai-rules-manager/tsconfig.json
- Extensions/vscode-ai-rules-manager/.vscodeignore
- Extensions/vscode-ai-rules-manager/LICENSE
- Extensions/vscode-ai-rules-manager/README.md
- Extensions/vscode-ai-rules-manager/resources/ai-rules.svg
- Extensions/vscode-ai-rules-manager/resources/icon.png
- Extensions/vscode-ai-rules-manager/src/extension.ts
- Extensions/vscode-ai-rules-manager/src/extensionUpdate.ts
- Extensions/vscode-ai-rules-manager/src/panel.ts
- Extensions/vscode-ai-rules-manager/src/commands.ts
- Extensions/vscode-ai-rules-manager/src/scriptRunner.ts
- Extensions/vscode-ai-rules-manager/src/status.ts
- .github/workflows/release-vsix.yml
- Scripts/AI-RulesManager.ps1

## Key Decisions

- **VS Code extension 而非 Codex plugin (2026-05-17)**: 使用者所稱插件是 VS Code 延伸模組，因此第一版建立 `Extensions/vscode-ai-rules-manager/`，以 Activity Bar / Sidebar 按鈕提供操作入口，不使用 `.codex-plugin/plugin.json`。
- **UI 與治理引擎分層 (2026-05-17)**: VS Code extension 僅負責按鈕、確認視窗、狀態列與 Output Channel；實際治理邏輯集中在 `Scripts/AI-RulesManager.ps1` 與既有 `Deploy.ps1` / modules，避免 UI 和治理規則分叉。
- **寫入動作必須確認 (2026-05-17)**: 套用更新、同步全域規則、清理孤兒檔案都必須通過 VS Code 確認視窗後才帶 `-Apply` 或 `-RemoveOrphans` 執行；檢查更新、查看更新內容、健康檢查保持唯讀。
- **Webview 指令白名單 (2026-05-17, 2026-05-18 擴充)**: 側邊欄只接受已註冊的 `aiRules.*` 命令，避免 Webview message 直接觸發任意 VS Code command；分類式同步後包含 10 個側邊欄操作。
- **孤兒清理保護 (2026-05-17)**: `CleanupOrphans` 只刪除差異報告列出的孤兒檔案；實際刪除前由 `Core.psm1` 驗證路徑仍在目標根目錄內，且跳過 `.agents/memory/` 與 `.agents/project_skills/`。
- **Windows PowerShell 5.1 腳本編碼相容 (2026-05-18)**: `Scripts/AI-RulesManager.ps1` 必須保存為 UTF-8 with BOM，因 VS Code extension 預設以 `powershell.exe` 執行；若改成 UTF-8 無 BOM，含中文與框線輸出的腳本會在 Windows PowerShell 5.1 被誤解碼並造成 ParserError。
- **狀態判斷必須精準比對 (2026-05-18)**: extension 不可用寬鬆關鍵字判斷治理狀態；`未偵測到遠端更新` 與 `Yellow：0` / `Red：0` 都是 OK 狀態，只有遠端更新完整狀態行或紅黃燈數量大於 0 才顯示需要處理。
- **跨專案來源使用 Git managed clone (2026-05-18)**: extension 不應要求每個專案都包含 `Scripts/AI-RulesManager.ps1`，也不應硬編碼 `D:\AI_Rules`；解析順序為明確 `aiRules.repoRoot`、目前 workspace AI_Rules repo、最後是 VS Code 全域儲存中的 AI_Rules managed clone。managed clone 第一次建立必須經使用者確認，來源由 `aiRules.repoUrl` 決定。
- **Marketplace 產品圖與 Activity Bar 圖示分離 (2026-05-18)**: `resources/icon.png` 作為 VS Code extension manifest 的產品圖，`resources/ai-rules.svg` 繼續作為 Activity Bar 單色圖示，避免 marketplace 視覺資產與側邊欄 glyph 混用。
- **使用者層與專案層同步分離 (2026-05-18)**: `syncGlobalRules` 只處理 `~/.codex` / `~/.claude` / `~/.gemini` 使用者層 bootstrap；`syncProjectRules` 處理目前 workspace 的已安裝平台規則，避免「全域同步成功」被誤解成專案治理也已同步。
- **健康檢查顯示治理語義缺口 (2026-05-18)**: Doctor 必須檢查 Director Output Contract 與 Project Skill Links；Red 或 Yellow 都應在 extension 狀態中顯示為「需要處理」，不可只因全域規則 OK 就顯示全綠。
- **AI Rules Manager v0.1.2 (2026-05-18)**: patch bump 用於分類式專案規則同步；`SyncProjectRules -ProjectPlatform Auto` 只同步已安裝平台，單平台同步未安裝時只回報 Yellow，VSIX 檔名同步為 `ai-rules-manager-0.1.2.vsix`。
- **專案同步補入 shared subagent policy (2026-05-18)**: `AI-RulesManager.ps1 -Action SyncProjectRules` 在同步已安裝平台規則時，會一併套用 shared subagent policy marker，讓 VS Code 側邊欄的單平台同步不會漏掉三平台子代理治理區塊。
- **AI Rules Manager v0.1.3 Release asset automation (2026-05-18)**: VSIX 版本升級到 `0.1.3`；新增 `.github/workflows/release-vsix.yml`，在推送 `v*` tag 後以 Node 20 打包 `ai-rules-manager-0.1.3.vsix`、自動建立 GitHub Release 並上傳 release asset。workflow 強制 tag 必須等於 `v<package.json version>`，並提供 `workflow_dispatch` 補跑入口。
- **跨專案換行誤報修正 (2026-05-19)**: 管理器後端現在以規則文字內容判斷全域與專案同步狀態；當目前 AI_Rules workspace 使用 LF、Antigravity / VS Code 類 IDE managed clone 使用 CRLF 時，`Check`、`SyncGlobal`、`SyncProjectRules` 與 `Doctor` 不再因純換行差異顯示需要處理。
- **AI Rules Manager v0.1.4 (2026-05-19)**: patch bump 用於封裝跨專案換行誤報修正；`package.json` 與 lockfile 升級到 `0.1.4`，release 文件與 VSIX 檔名同步為 `ai-rules-manager-0.1.4.vsix`。
- **Release notes 自動化 (2026-05-19)**: `.github/workflows/release-vsix.yml` 不再只依賴 GitHub `--generate-notes`；workflow 會從 `CHANGELOG.md` 的 `AI Rules Manager v<version>` 段落建立 Release 簡介，既有 Release 補跑時也會更新 body 並覆蓋同名 VSIX asset。
- **AI Rules Manager v0.1.5 (2026-05-19)**: `SyncProjectRules` 會在三平台核心規則同步時保留 05 濃縮寫入的 `PROJECT IDENTITY` 區段，避免專案身份被框架更新覆蓋；Claude 同步補掃 `.claude/CLAUDE.md` 入口檔；`package.json` 與 lockfile 升級到 `0.1.5`，VSIX 檔名同步為 `ai-rules-manager-0.1.5.vsix`。
- **AI Rules Manager v0.1.6 (2026-05-19)**: 新增 GitHub Release 更新提醒；插件啟動時背景檢查 latest release，側邊欄提供「檢查插件新版」手動入口，有新版時只提示開啟 Release 下載，不做靜默下載或安裝。`package.json` 與 lockfile 升級到 `0.1.6`，VSIX 檔名同步為 `ai-rules-manager-0.1.6.vsix`。
- **AI Rules Manager v0.1.7 (2026-05-19)**: Skill 架構整理使 Doctor 多檢查 Skill description 觸發品質，屬於延伸模組「健康檢查」按鈕的可見行為變更；`package.json` 與 lockfile 升級到 `0.1.7`，VSIX 檔名同步為 `ai-rules-manager-0.1.7.vsix`。
- **AI Rules Manager v0.1.7 trigger hardening (2026-05-19)**: 同版 v0.1.7 追加 Doctor 檢查 workflow 入口觸發描述與 Shared Skill 負向邊界；不再另升 patch，重新打包同名 0.1.7 VSIX 以包含完整 Skill 觸發治理。
- **VSIX Release Node 24 pipeline (2026-05-19)**: Release workflow 改用 `actions/checkout@v6`、`actions/setup-node@v6` 與 Node 24 建置，提前避開 GitHub Actions Node 20 淘汰；本次只維護發布管線，不升級 extension 版本。
- **VSIX LICENSE packaging (2026-05-19)**: extension package 內補入 MIT `LICENSE`，讓 `vsce package` 不再出現缺少 LICENSE 的警告；repo root 也補同版授權檔對齊 README badge。
- **Update reminder silent startup (2026-05-19)**: 更新提醒維持既有行為：啟動自動檢查若沒有新版或 GitHub API 失敗，只寫入 Output Channel；只有新版才跳通知。側邊欄手動「檢查插件新版」則必須回報已是最新版或錯誤。
- **AI Rules Manager v0.1.8 operation wording precision (2026-05-22)**: 側邊欄、Command Palette、確認視窗與 `AI-RulesManager.ps1` 輸出明確拆分「AI_Rules 來源庫更新」、「VSIX 安裝包新版檢查」、「治理巡檢 Doctor」與「目前專案規則同步」。這是操作者可見行為修復，extension manifest 與 lockfile 升級到 `0.1.8`；本次只更新 source 與文件，不產出 VSIX、tag 或 release。
- **AI Rules Manager v0.1.9 source update guard (2026-05-29)**: 來源庫更新流程遇到 managed clone 分叉、本機領先、工作樹有變更或 `git pull --ff-only` 失敗時，`AI-RulesManager.ps1` 必須立即停止並不得繼續跑 Doctor；側邊欄狀態判斷同步將來源庫分叉、無法快轉與更新失敗視為需要處理。這是操作者可見行為修復，extension manifest 與 lockfile 升級到 `0.1.9`；本次只更新 source 與文件，不產出 VSIX、tag 或 release。
- **AI Rules Manager v0.1.10 remote mirror source (2026-05-29)**: VS Code / Antigravity 類 IDE 的使用者層 AI_Rules 管理快取是遠端版本庫鏡像，不是人工維護來源；extension 在執行管理腳本前會把快取對齊 `aiRules.repoUrl` 的 `main` 分支，避免舊快取或分叉快取繼續同步專案。明確設定的 `aiRules.repoRoot` 仍視為本機開發來源，只檢查狀態、不自動重設。這是操作者可見行為修復，extension manifest 與 lockfile 升級到 `0.1.10`；正式發布流程透過 `v0.1.10` tag 產生 VSIX 與 GitHub Release。

## Known Issues

- 第一版以本機 VSIX 與 GitHub Release asset 為目標，尚未建立 Marketplace 發布流程。
- 尚未提供完整 Webview Dashboard；目前採側邊欄輕量按鈕。

## Module Lessons

- **延伸模組不應內建框架副本**：AI_Rules repo 仍是唯一真實來源；extension 可使用 workspace、明確設定或 Git managed clone 找到 repo root，然後呼叫 repo 內腳本。
- **PowerShell bridge 是公共介面**：VS Code extension、手動 CLI、未來其他平台入口都應呼叫 `AI-RulesManager.ps1`，不要各自重寫治理流程。
- **D01: VS Code bridge 腳本需固定 BOM**：只要 extension 預設仍支援 Windows PowerShell 5.1，含非 ASCII 輸出的 `.ps1` 應以 UTF-8 with BOM 保存，不能只用 PowerShell 7 成功作為驗收標準。
- **D02: UI 狀態不可只靠片段字串**：若 CLI 輸出包含否定句或零值計數，extension 必須判斷完整語意或數值，避免把健康狀態誤標為需要處理。
- **D03: 跨專案使用需分離來源與目標**：`RepoRoot` 代表 AI_Rules 框架來源，可由 Git managed clone 提供；`Target` 代表目前開啟的專案，兩者不可混用或用本機硬編碼路徑替代。
- **D04: VS Code manifest 圖示需使用獨立產品圖**：`package.json` 的 `icon` 欄位應指向方形 PNG 產品圖；Activity Bar 仍使用 SVG glyph，兩者服務不同尺寸與呈現場景。
- **D05: 全域 OK 不代表專案 OK**：extension UI 必須清楚區分 user profile bootstrap 與 project governance；Doctor 要能抓出 live project 規則漂移、workflow 輸出契約缺失與壞掉的 project skill link。
- **D06: Red/Yellow 狀態需掃所有計數**：Doctor 輸出有多個區塊時，前面的 `Yellow：0` / `Red：0` 不可遮住後面區塊的正數；extension 狀態判斷必須掃描所有 Red/Yellow counter。
- **D07: project skill link 修復是專案同步的一部分**：使用者點「同步已安裝平台規則」或單平台同步時，應修復對應 discovery 連結；「健康檢查」只回報，不寫入。
- **D08: 專案同步需依平台分類**：`.agents/skills` 可被 Codex 與 Antigravity 共用，不能只因 `.agents/` 存在就判定三平台都已安裝；Auto 同步必須檢查 `.codex/`、`.claude/`、`.agents/rules|workflows` 的實際入口。
- **D09: managed clone 與 workspace repo 可能只有換行不同**：一般專案會透過 IDE globalStorage 內的 AI_Rules managed clone 執行後端腳本，AI_Rules repo 自身則使用 workspace root；兩份 source 的 Git commit 相同但 working tree 換行可能不同，狀態判斷必須用正規化文字內容而非原始 SHA256 單點決策。
- **D10: 後端行為改變也要 bump VSIX**：即使 TypeScript UI 未變，只要 extension 按鈕呼叫的後端治理結果對使用者可見，應升級 patch 版本並重新打包，避免安裝包版本與實際行為修正脫節。
- **D11: Release 不能只靠 Full Changelog**：GitHub 自動 notes 可能只產生比較連結；插件發布 workflow 應明確寫入人可讀簡介，且簡介來源要跟 CHANGELOG 同步，避免 release 頁面缺少更新說明。
- **D12: 專案同步不可覆蓋專案身份**：`PROJECT IDENTITY` 是 05 濃縮產生的專案資訊，不屬於框架模板內容；同步預覽與套用都必須排除或還原該區段。
- **D13: VSIX 發布需要更新提醒層**：GitHub Release asset 只是下載來源，不是 IDE 原生自動更新通道；在 Marketplace / Open VSX 前，extension 應以 latest release 檢查提醒使用者手動下載新版 VSIX。
- **D14: Doctor 可見語義變更也要 bump VSIX**：即使 TypeScript UI 未變，只要延伸模組按鈕呼叫的 Doctor 後端新增紅黃燈判斷，操作者看到的健康狀態就可能改變，應升級 patch 版本並重新打包。
- **D15: 同一未發布 patch 可合併治理補強**：若版本尚未 tag/release，後續 Doctor 規則補強可併入同一 patch 重新打包；若已發布，才需要再 bump 下一個 patch。
- **D16: 發布管線維護不必自動 bump VSIX**：只要沒有改 extension 功能或操作者可見後端結果，GitHub Actions / LICENSE 這類發布基礎設施修正可不升 patch；下一個正式版本 tag 會自然使用新版 pipeline。
- **D17: 自動更新檢查不可產生無更新提示**：啟動時的背景檢查是低干擾提醒機制，不應在「沒有新版」時彈窗；需要完整狀態回饋時，操作者應使用手動檢查按鈕。
- **D18: 管理按鈕文案要標明目標與非目標**：當同一個面板同時管理 source repo、VSIX 安裝包與目前專案規則時，按鈕標題、確認視窗與 README 必須明確說明會動哪一層，也要說明不會動哪一層，避免「更新」一詞混淆來源庫、插件包與專案同步。
- **D19: 管理快取是遠端鏡像，不是第二來源**：非 AI_Rules workspace 透過 IDE globalStorage 使用的管理快取必須自動對齊遠端版本庫；若快取落後、分叉、本機領先或有髒變更，應修復快取或停止，不可拿舊快取同步目前專案。

## Relations

- 後端治理入口：`Scripts/AI-RulesManager.ps1`
- 統一部署引擎：`Scripts/Deploy.ps1`
- 全域規則同步：`Scripts/modules/Core.psm1`
- runtime drift 巡檢：`Scripts/modules/Audit.psm1`

## Applicable Skills

- memory-ops（維護與更新本卡時）
