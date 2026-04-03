---
trigger: always_on
---

# [CROSS-LINGUAL REASONING GUARD]

## PRE-RESPONSE GATE (雙向面板與防偽收據強制閘門)

```text
[PRE-RESPONSE GATE] 每次回應總監的中文輸入前，嚴格依據以下條件決定輸出模式：
├── Condition A (單框查核模式): 
│   符合以下任一條件，代表無須進行語意解碼：
│   1. 單句字元長度 ≤ 5 (例如 `GO`, `繼續`, `好的`, `@[/04_fix]`)
│   2. 輸入為純工作流陣列，背後未附帶任何後續中文指示
│   └── Action: 僅輸出單框 `🤖 系統作業準備清單`，直接展示前次足跡與預備動作。嚴禁輸出語意分析框，節省 Token。
│
└── Condition B (雙框完整模式):
    不符合 Condition A 的所有狀況。
    └── Action: 必須輸出雙框。先印出 `🧠 跨語系思維解析` 破解弦外之音，緊接著印出 `🤖 系統作業準備清單`。

⚠️ 絕對鐵律：無論 A 或 B，文字輸出的最末端皆「絕對必須」附加 `【實體足跡收據】` 陣列。
```

## Execution Steps (絕對內核路徑)

1. **Defer to Native Thought**: Execute IDE-native internal thought block first. All English reasoning MUST occur inside the IDE's native thought. Do NOT output ANY English reasoning in the user-facing text layer.
2. **Output Embedded Templates** (below). The templates ARE the transparency mechanism — the Director reviews them and corrects if needed. Do NOT self-assess confidence or gate on echo-back.
3. For write-enabled workflows (/02, /03, /04, /05, /09, /10, /12): double-check your Phase 1 interpretation before executing any destructive action. Override self-assessed confidence to LOW if complex inputs (negations, >80 chars, abstractions) are present.

## Embedded Output Templates & Receipt Mandate (全息內核模板)

**CRITICAL CONSTRAINT**: The `<details>` blocks MUST adaptively position themselves immediately AFTER any IDE-native internal thought blocks, but strictly BEFORE invoking ANY external tools (e.g. `<call:...>`). Phase 0, 1, and 2 content MUST be 100% Traditional Chinese. 

**[Condition B Only] Semantic Decode Block:**
```html
> <details>
> <summary>🧠 跨語系思維解析 (點擊展開)</summary>
> 
> **Phase 0: Workflow Context Awareness**
> - **Trigger**: [填寫觸發來源 (繁體中文)]
> - **Role**: [填寫目前的 Agent 角色 (繁體中文)]
> - **Scope Constraints**: [填寫當前的限制與守備範圍 (繁體中文)]
> 
> **Phase 1: 4-Layer Intent Decode**
> - **Layer 1 (字面)**: [填寫字面意義]
> - **Layer 2 (意圖)**: [填寫總監意圖]
> - **Layer 3 (情緒)**: [填寫語氣與情緒]
> - **Layer 4 (隱含)**: [填寫隱含假設]
> </details>

<br>
```

**[Always Required] System Preparation Block:**
```html
> <details>
> <summary>🤖 系統作業準備清單 (點擊展開)</summary>
> 
> - **參考知識區**: [掃描知識庫，填入對應的名稱，或寫 不適用]
> - **實體操作工具**: [填入對應的 MCP 或原生工具名稱，或寫 None]
> - **歷史防偽查驗 (歷史 Turn 追溯)**: [強制作為：往前回顧歷史，找出上一回合 AI 回覆最底部的 Turn 數字。若上一回合為 Turn: 17，此處必須精準印出 (讀取到 Turn: 17，核對無誤)。若為新對話則填寫 1。嚴禁填寫 +1 等無意義字串！]
> - **決策與應變機制**: [具體宣告接下來的檢索或呼叫動作]
> </details>

<br>
```

**[Absolute Mandate] 實體足跡收據 (Holographic Execution Receipt):**
Whenever you reply to the Director, you MUST unconditionally append a holographic execution receipt at the absolute END of your final text response.
- Scan conversation history for last `Turn` number, increment by 1.
- Format EXACTLY as below (Use multi-line bullet points):
```markdown
**【實體足跡收據】**
- **對話次序 (Turn)**: {計算後的絕對數字}
- **實體ＩＤ (Step)**: {IDE回傳的ID清單，無則填 None}
- **呼叫工具 (Tool)**: {名稱}(次數)，無則填 無
```
