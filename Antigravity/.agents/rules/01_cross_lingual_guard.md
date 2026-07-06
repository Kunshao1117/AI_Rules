---
trigger: always_on
---

# [跨語系推理防線 — CROSS-LINGUAL REASONING GUARD]

## 回應前閘門（Pre-Response Gate）

**預設行為：雙面板模式（Dual-Panel Mode）。**

總監輸入中文時，MUST 同時輸出兩個面板。

必要面板為 `🧠 跨語系思維解析` 與 `🤖 系統作業準備清單`。

這是預設模式；除非符合下方窄例外，否則不得省略語義解析面板。

**窄例外：單面板模式（Single-Panel Mode）。** 只有在輸入符合下列條件時，才只輸出 `🤖 系統作業準備清單`，並省略語義解析：

- 5 字以內的短確認語，例如 `GO`、`繼續`、`好的`。
- 單獨出現、沒有其他中文文字的 workflow slash command，例如只有 `@[/04_fix]`。

**不確定時，ALWAYS 使用雙面板模式（Dual-Panel Mode）。**

多輸出語義解析面板只是少量 token 成本。

該輸出卻省略時，會造成意圖解析遺失。

**範例（Examples）：**

| 輸入（Input）             | 模式（Mode）   | 原因（Reason）                     |
| ------------------------- | -------------- | ---------------------------------- |
| `GO`                      | Single-Panel   | 5 字以內短確認                     |
| `繼續`                    | Single-Panel   | 5 字以內短確認                     |
| `@[/04_fix]`              | Single-Panel   | 單獨 workflow，無額外文字          |
| `@[/04_fix] 修復登入頁面` | **Dual-Panel** | workflow 加中文任務內容            |
| `我想修復登入頁面的問題`  | **Dual-Panel** | 具有中文語義內容                   |
| `這段規則需要調整`        | **Dual-Panel** | 具有中文語義內容                   |

**絕對要求（ABSOLUTE MANDATE）**：無論採用哪種模式，都 MUST 在每次文字輸出的最後附上可折疊的 `【實體足跡收據】` 區塊。

該區塊必須位於最終文字的絕對結尾。

## 執行步驟（Execution Steps）

1. **先交給原生思考層（Defer to Native Thought）**：先執行 IDE-native internal thought block。
2. 所有英文推理 MUST 留在 IDE native thought。
3. 不得在 user-facing text layer 輸出英文推理。
4. **輸出下方嵌入模板（Embedded Templates）**；模板本身就是透明化機制。
5. 總監可查看面板並在必要時修正。
6. 不要用自評信心或 echo-back 當作 gate。
7. 對 write-capable workflows，在執行任何破壞性動作前，必須再次核對 Phase 1 意圖解讀。
8. write-capable roles 包含 `Writer/SRE`、`SRE`、`Worker`；參見 `_security_footer.md` 的 Role Permission Matrix。
9. 若輸入複雜，將自評信心覆寫為 LOW。
10. 複雜輸入包含否定句、超過 80 字、抽象要求。

## 嵌入輸出模板與收據要求（Embedded Output Templates And Receipt Mandate）

**關鍵限制（CRITICAL CONSTRAINT）**：

- `<details>` blocks MUST 放在 IDE-native internal thought blocks 之後。
- `<details>` blocks MUST 嚴格出現在任何外部工具呼叫之前，例如 `<call:...>`。
- Director-facing Phase 0、1、2 面板內容 MUST 使用繁體中文。
- internal docs、artifacts、schemas、canonical statuses 維持原本慣例。

**[預設] 語義解析區塊（Semantic Decode Block）：**

```html
<details>
  <summary>🧠 跨語系思維解析 (點擊展開)</summary>

  > **Phase 0：工作流情境辨識（Workflow Context Awareness）**
  > - **觸發來源（Trigger）**: [用繁體中文描述總監可見的觸發來源]
  > - **目前角色（Role）**: [用繁體中文描述目前 Agent 角色]
  > - **範圍限制（Scope Constraints）**: [用繁體中文描述目前限制與邊界]
  >
  > **Phase 1：四層意圖解析（4-Layer Intent Decode）**
  > - **Layer 1（字面）**: [用繁體中文解析字面要求]
  > - **Layer 2（意圖）**: [用繁體中文解析總監意圖]
  > - **Layer 3（情緒）**: [用繁體中文解析語氣與情緒]
  > - **Layer 4（隱含）**: [用繁體中文解析隱含假設]
</details>

下一個區塊前保留一個 Markdown 空行。
```

**[一律需要] 系統作業準備清單（System Preparation Block）：**

```html
<details>
  <summary>🤖 系統作業準備清單 (點擊展開)</summary>

  > - **參考知識區**: [掃描知識庫，填入匹配的 KI 名稱；若無則填 不適用]
  > - **實體操作工具**: [填入即將使用的 MCP 或 native tool name；若無則填 None]
  > - **歷史防偽查驗（對話追溯）**: [MANDATORY: 回看對話歷史，找出前一輪 receipt 的 Turn number。若前次為 Turn: 17，必須精確輸出（讀取到 Turn: 17，核對無誤）。新對話填 1。NEVER 輸出 +1 或無意義字串。]
  > - **歷史防偽查驗（工具追溯）**: [MANDATORY: 回看對話歷史，找出前一輪 receipt 的 Tool list。精確輸出（讀取到 {toolName}({count}), ...，核對無誤）。新對話或前輪無工具呼叫則填 無。]
  > - **決策與應變機制**: [用繁體中文宣告下一步具體 retrieval 或 tool invocation 行動]
</details>

下一個區塊前保留一個 Markdown 空行。
```

**[Turn=1 記憶啟動指令（Memory Startup Instruction）]**：

- 首次回應（`Turn=1`）時，上方 `決策與應變機制` 欄位 MUST 明確寫入：`執行記憶啟動探測（memory_list → 三路徑判斷）`。
- 面板輸出完畢後，立即依 `06_memory_push.md` 執行三路徑探測。
- 此指令不是模板格式的一部分，而是獨立行為命令。

**[記憶啟動邊界（Memory Startup Boundary）]**：

- 首次記憶啟動探測是唯讀路由探測。
- 唯讀探測只能取得 memory inventory 或健康摘要。
- 不得因為輸入是中文就自動讀取完整記憶卡。
- 不得呼叫 `commit_preflight`、`memory_commit`，也不得寫入 context/memory。
- 不得把 stale 或 compaction 結果變成非 commit 任務的中途阻斷。
- 若探測發現 `needsCompaction=true` 或等價狀態，輸出 compact packet 或 `memory_docs_state`。
- 只有在記憶寫入、completion、`09 Commit`、explicit commit-prep、closeout commit/push readiness 階段，才阻塞相依動作。

**[絕對要求] 實體足跡收據（Holographic Execution Receipt）**：

每次回覆總監時，MUST 無條件附上 holographic execution receipt。

收據必須放在最終文字回覆的絕對結尾。

- 掃描對話歷史中的最後 `Turn` number，並加 1。
- 格式必須完全如下，使用可折疊 `<details>` block：

```html
<details>
  <summary>📋 實體足跡收據 (點擊展開)</summary>

  > - **對話次序 (Turn)**: {計算後的絕對數字}
  > - **實體ＩＤ (Step)**: {IDE回傳的ID清單，無則填 None}
  > - **呼叫工具 (Tool)**: {名稱}(次數)，無則填 無
  > - **上下文健康 (Context)**: {🟢 正常 | 🟡 留意 (>10 Turn) | 🔴 建議交接 (>15 Turn)}
</details>
```
