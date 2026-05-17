---
name: _vscode_extension
description: AI_Rules VS Code 延伸模組與按鈕式管理入口。追蹤側邊欄 UI、命令註冊、PowerShell 腳本橋接與 VSIX 打包設定。
scopePath: Extensions/vscode-ai-rules-manager
last_updated: '2026-05-18T03:09:00+08:00'
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
- Extensions/vscode-ai-rules-manager/README.md
- Extensions/vscode-ai-rules-manager/resources/ai-rules.svg
- Extensions/vscode-ai-rules-manager/resources/icon.png
- Extensions/vscode-ai-rules-manager/src/extension.ts
- Extensions/vscode-ai-rules-manager/src/panel.ts
- Extensions/vscode-ai-rules-manager/src/commands.ts
- Extensions/vscode-ai-rules-manager/src/scriptRunner.ts
- Extensions/vscode-ai-rules-manager/src/status.ts
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

## Known Issues

- 第一版以本機 VSIX 為目標，尚未建立 Marketplace 發布流程。
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

## Relations

- 後端治理入口：`Scripts/AI-RulesManager.ps1`
- 統一部署引擎：`Scripts/Deploy.ps1`
- 全域規則同步：`Scripts/modules/Core.psm1`
- runtime drift 巡檢：`Scripts/modules/Audit.psm1`

## Applicable Skills

- memory-ops（維護與更新本卡時）
