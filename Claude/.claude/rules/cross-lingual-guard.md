# [CROSS-LINGUAL REASONING GUARD]

## PRE-RESPONSE GATE (雙向面板與防偽收據強制閘門)

**DEFAULT BEHAVIOR: Dual-Panel Mode (雙框模式為預設).** For EVERY Chinese input from the Director, you MUST output BOTH the `🧠 跨語系思維解析` panel AND the `🤖 系統作業準備清單` panel.

**NARROW EXCEPTION: Single-Panel Mode.** Output ONLY the `🤖 系統作業準備清單` panel when the input is:
- A short confirmation phrase of ≤ 5 characters (e.g. `GO`, `繼續`, `好的`)
- A standalone workflow slash command with NO additional Chinese text (e.g. `/build` appearing alone)

**If in doubt, ALWAYS default to Dual-Panel Mode.**

| Input | Mode | Reason |
|---|---|---|
| `GO` | Single-Panel | Short confirmation (≤5 chars) |
| `繼續` | Single-Panel | Short confirmation (≤5 chars) |
| `/build` | Single-Panel | Standalone workflow command |
| `/build 修復登入頁面` | **Dual-Panel** | Workflow + additional Chinese text |
| `我想修復登入頁面的問題` | **Dual-Panel** | Semantic Chinese content |

**ABSOLUTE MANDATE**: Regardless of mode, a collapsible `【實體足跡收據】` block MUST be appended at the absolute END of every text output.

## Execution Steps (絕對內核路徑)

1. **Native Thought First**: Execute internal reasoning first. All English reasoning MUST occur inside Claude's internal thought. Do NOT output ANY English reasoning in the user-facing text layer.
2. **Output Embedded Templates** (below). Templates ARE the transparency mechanism.
3. For any workflow with write permissions: double-check Phase 1 interpretation before executing destructive actions.

## Embedded Output Templates (全息內核模板)

**CRITICAL CONSTRAINT**: Panel blockquotes MUST appear AFTER internal thought but strictly BEFORE invoking ANY tools.

**[Default] Semantic Decode Block:**

```
> 🧠 **跨語系思維解析**
> P0｜觸發: [觸發來源，繁體中文] · 角色: [當前代理人角色，繁體中文] · 範圍: [當前限制與範圍邊界，繁體中文]
> P1｜字面: [字面意義解碼，繁體中文] · 意圖: [總監意圖解碼，繁體中文] · 情緒: [語氣與情緒解碼，繁體中文] · 隱含: [隱含假設解碼，繁體中文]
```

**[Always Required] System Preparation Block:**

```
> 🤖 **系統作業準備清單**
> 知識: [技能名稱或「不適用」] · 工具: [MCP 或原生工具名稱或「None」] · Turn: N · 查驗(對話): [上輪 Turn 號碼，首次填「1」] · 查驗(工具): [上輪工具列表，首次填「無」] · 決策: [下一步具體行動]
```

**[Turn=1 記憶啟動指令]**: 首次回應（Turn=1）時，「決策與應變機制」欄位 MUST 包含「執行記憶啟動探測（讀取 MEMORY.md → 三路徑判斷）」的明確聲明。面板輸出完畢後，立即執行：讀取 `~/.claude/projects/<project>/memory/MEMORY.md` → 三路徑判斷：
- 有 `_map` 條目 → 載入地圖索引
- 有 `_system` 條目 → 載入系統記憶
- 空白 → 純對話模式

**[Absolute Mandate] 實體足跡收據:**
每次回應的最末端 MUST 附加：

```
> 📋 Turn: {從對話歷史計算的絕對數字} · Tool: {名稱(次數)，無則填「無」} · Context: {🟢 正常 | 🟡 留意 (>10 Turn) | 🔴 建議交接 (>20 Turn)}
```
