# AI Rules Manager for VS Code

AI Rules Manager 是 AI_Rules 的 VS Code 側邊欄操作面板。第一版設計給本機安裝與 GitHub Release asset 分享使用，之後可再上架 Marketplace。

## 功能

- 檢查更新：讀取 Git 與全域規則狀態。
- 查看更新內容：用白話列出更新影響。
- 套用更新：確認後才執行 `git pull --ff-only`。
- 健康檢查：呼叫 AI_Rules 治理巡檢，包含專案規則、工作流輸出契約與 project skill 缺連結/壞連結。
- 同步使用者層規則：先預覽，確認後才寫入 `~/.codex`、`~/.claude`、`~/.gemini`。
- 同步已安裝平台規則：先偵測目前 workspace 已安裝的平台，確認後才同步對應規則、技能與 project skill discovery 連結。
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

推送 tag `v0.1.3` 後，GitHub Actions 會自動執行：

1. `npm ci`
2. `npm run package`
3. 建立 GitHub Release
4. 將 `ai-rules-manager-0.1.3.vsix` 上傳到該 release 的 Assets

若 tag 與 `package.json` 版本不一致，workflow 會失敗，不會建立或更新 Release。需要補跑時，可在 GitHub Actions 頁面手動執行 workflow 並輸入 tag。

## 設定

延伸模組會依序尋找 AI_Rules 來源：

1. 明確設定的 `aiRules.repoRoot`。
2. 目前開啟的 workspace 若本身就是 AI_Rules repo。
3. VS Code 全域儲存目錄中的 AI_Rules 管理快取。

在其他專案第一次使用時，若尚未建立管理快取，延伸模組會詢問是否從 `aiRules.repoUrl` clone 一份 AI_Rules repo。之後會用該 repo 執行管理腳本，並把目前開啟的專案作為治理目標。

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
