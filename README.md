# AI_Rules

## 一句話定位

AI_Rules 是一套放進你現有 AI 開發工具的專案規則，幫你把「想做什麼、可以做什麼、怎樣算真的做好」說清楚，並用白話繁體中文回報結果。

## 適合誰

適合你如果：

- 你知道想完成的軟體工作，但不熟悉程式、英文指令或技術細節。
- 你希望 AI 不要把「已開始」或「改了一些內容」說成「已做好」。
- 你需要在 AI 要改檔、發布或做其他重要動作前，先知道影響並保留決定權。

不需要先會寫提示詞，也不需要先看懂專案裡的程式碼。

## 它實際幫你避免什麼

- AI 沒有檢查，就把工作說成已完成。
- AI 把已修改、已驗證、已提交、已發布與已部署混成同一件事。
- AI 把技術錯誤、英文指令或一長串紀錄丟給你，卻沒有先說你真正需要知道的事。
- AI 把一次同意擴大成未說明的其他重要操作。

AI_Rules 會要求 AI 先說明現在結果、實際影響、仍有的風險或未完成事項，以及你是否需要做決定。它不是保證 AI 一定正確的魔法，也不是工具本身的硬性權限；真正能阻擋操作的，仍是各平台提供的權限、確認與隔離設定。

## 一個使用情境

你可以直接對 AI 說：「請把網站的聯絡按鈕改成『立即詢問』，完成後告訴我有沒有檢查過。」

理想的回報會先告訴你：文字是否已改、檢查是否真的執行、還有哪些事沒有做，以及你現在要不要決定下一步。你不用先追問「所以到底好了沒？」

## 安裝或套用後會改什麼

AI_Rules 會把該平台讀取的規則、工作流程與共用操作說明加入目前專案。它不會因為安裝就自動修改你的產品功能；之後任何軟體變更仍要依當次任務與授權範圍處理。

升級時，既有的專案記憶、專案背景與自訂技能會受到保護，不會被框架來源直接覆蓋。安裝與升級前，平台會先顯示要進行的動作；請先看懂影響再確認。

## 五分鐘開始

1. 選擇你已在使用的 AI 工具。
2. 打開下方對應的起步說明，依畫面上的確認步驟套用到目前專案。
3. 用自然語言說出目標、你不想改的部分，以及你希望如何確認結果。
4. 收到回報時，先看第一層的結果、影響、注意事項與下一步；需要時再展開技術資料。

如果你看不懂安裝說明，不要直接執行看不懂的指令。可以先對 AI 說：「請先用中文告訴我這一步會改什麼、會保留什麼，等我確認後再繼續。」

## AI 會如何回報

小型工作可以只用幾句自然中文，不必每次都像公文一樣有固定標題。例如：

> 你要的按鈕文字已改成「立即詢問」，指定檢查也已通過。這次沒有提交、發布或部署網站，也沒有改其他頁面。你現在不用做任何事。

資訊較多時，AI 可以使用「目前結果／影響／注意事項／下一步」。技術名稱、完整指令、檔案位置與原始錯誤仍可查閱，但不會是第一層說明。

其中的狀態有明確差別：

- **已修改**：內容已改，但不等於已檢查或已可用。
- **已驗證**：指定檢查已通過，並有結果與範圍說明；若檢查失敗，會明確寫「驗證未通過」。
- **已完成**：這次說明範圍內的結果已有相應證據；沒有證據的後續工作會另外說明。
- **已提交**：這次來源變更已寫入版本紀錄；不等於已發布或已部署。
- **已發布**：指定版本已在說明的發行位置提供取得；不等於已部署到執行環境。
- **已部署**：指定版本已送到說明的執行環境；不等於所有功能都已驗證。

## 安全與能力邊界

AI_Rules 會引導 AI 做出較清楚的說明與證據判斷，但文件規則本身不是平台的強制保護。重要操作仍要依平台的權限提示、隔離環境與你的明確同意處理。

Antigravity Runtime Context 行為目前只有官方文件描述，尚未在本機驗證。不會因為 AI_Rules 已部署，就宣稱平台的對話內容、隔離程度、Token 用量或速度已經改善。

## 支援平台

| 你正在使用的工具 | 起步說明 |
|---|---|
| Antigravity / Gemini | [Antigravity 起步說明](Antigravity/README.md) |
| Claude Code | [Claude Code 起步說明](Claude/README.md) |
| OpenAI Codex | [Codex 起步說明](Codex/README.md) |

## 進階資料（需要時再看）

以下內容提供給需要安裝、升級、維護或查核框架的人。一般使用者不需要先讀懂它們，才能開始描述想完成的工作。

### 安裝與升級

根目錄提供三個平台的安裝與升級入口。這些指令會從公開來源下載當前分支的安裝程式；它們不是無風險的一鍵操作。請先閱讀對應平台說明與確認提示，再決定是否執行。

#### Antigravity / Gemini

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1'
$f = Join-Path $env:TEMP 'ag_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

將最後一行改為 `& $f -Mode Upgrade` 可進行升級。

#### Claude Code

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1'
$f = Join-Path $env:TEMP 'cc_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

將最後一行改為 `& $f -Mode Upgrade` 可進行升級。

#### OpenAI Codex

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Codex/install.ps1'
$f = Join-Path $env:TEMP 'ag_codex_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

將最後一行改為 `& $f -Mode Upgrade` 可進行升級。三個平台都可加上 `-Target "D:\path\to\project"` 指定其他專案目錄。PowerShell 5.1+ 與 PowerShell 7 均受支援。

### 受控確認提示

全域啟動器不會自行安裝。它只會先要求你輸入 `GO INSTALL` 或 `GO UPGRADE`，而這些確認只授權眼前的框架安裝或升級範圍，不授權其他記憶、Git、發布、部署、憑證、刪除或外部操作。

### 平台入口與版本

| 平台 | 來源入口 | 部署位置 | 版本 |
|---|---|---|---|
| Antigravity / Gemini | `Antigravity/README.md` | `.agents/` | v8.0.3 |
| Claude Code | `Claude/README.md` | `.claude/` 與共用 `.agents/` | v1.2.3 |
| OpenAI Codex | `Codex/README.md` | `.codex/` 與共用 `.agents/` | v0.1.3 |

### 架構與開發者文件

| 需要查什麼 | 權威來源 |
|---|---|
| 任務如何分派與保留責任邊界 | `Shared/policies/team-native-core.md` |
| 授權與受保護操作 | `Shared/policies/authorization-resolution.md`、`Shared/policies/references/protected-action-registry.md` |
| 完成、驗證與審查證據 | `Shared/policies/references/completion-state-machine.md`、`Shared/policies/workflow-orchestration.md` |
| 使用者語言、技術資料與輸出案例 | `Shared/policies/language-governance.md`、`Shared/policies/references/user-facing-output-examples.md` |
| 來源與部署副本的對照 | `Shared/policies/references/source-runtime-surface-map.md` |
| 專案目錄與腳本 | `Shared/`、`Scripts/`、`Extensions/vscode-ai-rules-manager/` |

部署副本位於 `.agents/`、`.claude/` 與 `.codex/`。它們由來源模板與共用政策同步產生；修正框架時應先改來源，再用既有部署流程更新副本。
