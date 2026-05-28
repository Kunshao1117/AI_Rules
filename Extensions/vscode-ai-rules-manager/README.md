# AI Rules Manager for VS Code

AI Rules Manager 是 AI_Rules 的 VS Code 側邊欄操作面板。第一版設計給本機安裝與 GitHub Release asset 分享使用，之後可再上架 Marketplace。手動安裝 VSIX 不會取得 Marketplace 原生自動更新，因此延伸模組啟動時會查 GitHub Release；只有發現新版安裝檔時才通知，沒有新版或暫時無法連線時只寫入 Output Channel，不打擾操作者。

## 功能

- 檢查來源狀態：讀取 AI_Rules 管理來源庫的 Git 狀態，區分已同步、可快轉更新、來源庫分叉、本機領先遠端與工作樹變更；不寫入。
- 檢查 VSIX 新版：手動查 GitHub Release 是否有新版 VSIX 可下載；沒有新版時也會明確回報已是最新版。
- 查看來源更新影響：說明若更新 AI_Rules 來源庫，會執行哪些 Git 與治理巡檢動作。
- 更新 AI_Rules 來源庫：確認後才嘗試快轉更新；若來源庫分叉、工作樹有變更或 Git 更新失敗，會停止且不執行治理巡檢；不安裝 VSIX，也不同步目前專案規則。
- 治理巡檢 Doctor：呼叫 AI_Rules 治理巡檢，包含 Shared Skill 品質、workflow metadata、policy marker、子代理語彙、全域規則漂移與 project skill links。
- 同步使用者層規則：先預覽，確認後才寫入 `~/.codex`、`~/.claude`、`~/.gemini`。
- 同步已安裝平台規則：先偵測目前 workspace 已安裝的平台，確認後才同步 `.agents` / `.claude` / `.codex` 對應規則、技能與 project skill discovery 連結。
- 單平台同步：可分別同步 Codex、Claude 或 Antigravity；未安裝的平台只回報 Yellow，不自動建立。
- 清理孤兒檔案：先預覽，確認後才刪除。

## 本機開發

```powershell
cd Extensions/vscode-ai-rules-manager
npm install
npm run compile
```

在 VS Code 按 `F5` 啟動 Extension Development Host，左側會出現 `AI Rules`。

## 打包 VSIX

```powershell
cd Extensions/vscode-ai-rules-manager
npm run package
```

產出的 `.vsix` 可在 VS Code 的 Extensions 視窗中用 `Install from VSIX...` 安裝。

## GitHub Release

推送 tag `v0.1.9` 後，GitHub Actions 會自動執行：

1. `npm ci`
2. `npm run package`
3. 建立 GitHub Release
4. 從 `CHANGELOG.md` 的對應 `AI Rules Manager v<version>` 段落產生 Release 簡介
5. 將 `ai-rules-manager-0.1.9.vsix` 上傳到該 release 的 Assets

Release workflow 使用 Node 24 與支援 Node 24 runtime 的官方 GitHub Actions。若 tag 與 `package.json` 版本不一致，workflow 會失敗，不會建立或更新 Release。需要補跑時，可在 GitHub Actions 頁面手動執行 workflow 並輸入 tag；若 Release 已存在，workflow 會更新簡介並覆蓋同名 VSIX asset。

## 設定

延伸模組會依序尋找 AI_Rules 來源：

1. 明確設定的 `aiRules.repoRoot`。
2. 目前開啟的 workspace 若本身就是 AI_Rules repo。
3. VS Code / Antigravity 類相容 IDE 全域儲存目錄中的 AI_Rules 管理快取。

在其他專案第一次使用時，若尚未建立管理快取，延伸模組會詢問是否從 `aiRules.repoUrl` clone 一份 AI_Rules repo。之後會用該 repo 執行管理腳本，並把目前開啟的專案作為治理目標。

不同 workspace 可能分別使用本機 AI_Rules repo 或 IDE globalStorage 內的管理快取；來源狀態檢查與同步預覽會以規則文字內容為準，CRLF/LF 換行格式不同不會被視為全域規則漂移。同步目前專案規則時，05 濃縮寫入的 `PROJECT IDENTITY` 會被視為專案資訊區，不會因框架更新被覆蓋。

若要固定使用已存在的本機 AI_Rules repo，請設定：

```json
{
  "aiRules.repoRoot": "D:\\AI_Rules"
}
```

若要改用 fork 或內部鏡像來源，請設定：

```json
{
  "aiRules.repoUrl": "https://github.com/Kunshao1117/AI_Rules.git"
}
```

預設會使用 `powershell.exe` 執行 `Scripts/AI-RulesManager.ps1`。
