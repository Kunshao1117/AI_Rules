# AI Rules Manager for VS Code

AI Rules Manager 是 AI_Rules 的 VS Code 側邊欄操作面板。第一版設計給本機安裝與小範圍分享使用，之後可再上架 Marketplace。

## 功能

- 檢查更新：讀取 Git 與全域規則狀態。
- 查看更新內容：用白話列出更新影響。
- 套用更新：確認後才執行 `git pull --ff-only`。
- 健康檢查：呼叫 AI_Rules 治理巡檢。
- 同步全域規則：先預覽，確認後才寫入使用者層規則。
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

## 設定

若延伸模組無法自動找到 AI_Rules repo，請設定：

```json
{
  "aiRules.repoRoot": "D:\\AI_Rules"
}
```

預設會使用 `powershell.exe` 執行 `Scripts/AI-RulesManager.ps1`。
