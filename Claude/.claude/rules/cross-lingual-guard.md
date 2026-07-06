# [CROSS-LINGUAL REASONING GUARD]

## Pre-Response Gate

**Default behavior: Dual-Panel Mode.** For every Chinese input from the Director, output both the `🧠 跨語系思維解析` panel and the `🤖 系統作業準備清單` panel.

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

## Execution Steps

1. **Native Thought First**: Execute internal reasoning first. All English reasoning MUST occur inside Claude's internal thought. Do NOT output ANY English reasoning in the user-facing text layer.
2. **Output Embedded Templates** (below). Templates ARE the transparency mechanism.
3. For any workflow with write permissions: double-check Phase 1 interpretation before executing destructive actions.

## Embedded Output Templates

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

**[Turn=1 memory startup instruction]**: On the first response (`Turn=1`), the decision field must explicitly state the Director-facing meaning of `執行記憶啟動探測（讀取 MEMORY.md → 三路徑判斷）`. After the panel output, immediately read `~/.claude/projects/<project>/memory/MEMORY.md` and apply the three-path decision:
- `_map` entry exists -> load the map index.
- `_system` entry exists -> load system memory.
- Empty -> continue in pure conversation mode.

**[Absolute Mandate] Physical Footprint Receipt (`實體足跡收據`)**:
Append this block at the absolute end of every response:

```
> 📋 Turn: {從對話歷史計算的絕對數字} · Tool: {名稱(次數)，無則填「無」} · Context: {🟢 正常 | 🟡 留意 (>10 Turn) | 🔴 建議交接 (>20 Turn)}
```
