# [MEMORY & SKILL CONTRACT]

## 0. Turn=1 Startup Protocol (對話啟動探測 — 每次新對話必執行)

### 前置步驟：崩潰復原檢查點偵測

```
[CHECKPOINT GATE] 對話啟動時，三路徑探測前執行：
├── 檢查 .agents/logs/checkpoint.json 是否存在
│   ├── 存在且 status = "in_progress"
│   │   └── 輸出：「⚠️ 偵測到上次對話未完成存檔點：
│   │           工作流: {workflow}，階段: {phase}，時間: {timestamp}。
│   │           是否從此處繼續？（輸入 GO 繼續 / SKIP 忽略）」
│   │           HALT — 等待總監決定
│   ├── 存在且 status = "completed"
│   │   └── 靜默刪除（Bash rm .agents/logs/checkpoint.json），繼續三路徑探測
│   └── 不存在 → 直接進入三路徑探測

Checkpoint 格式規範（寫入時參考）：
{
  "session_id": "uuid",
  "workflow": "/03_build",
  "phase": "EXECUTION",
  "status": "in_progress",
  "timestamp": "YYYY-MM-DDTHH:mm:ss+08:00",
  "last_completed_step": "Step N 描述",
  "pending_steps": ["Step N+1", "Step N+2"]
}
```

```
新對話 Turn=1：
├── 呼叫 cartridge-system__memory_list(projectRoot)
│   ├── 回傳清單中有 _map → 呼叫 memory_read("_map") 取得全局模組索引
│   │   └── 根據當前任務，按需呼叫 memory_read(moduleName) 載入相關模組卡
│   ├── 回傳清單為空（無任何卡） → 視為空白專案，跳過記憶讀取
│   └── cartridge-system 呼叫失敗 → 記錄警告，繼續執行（降級至純對話模式）
└── 完成探測後，在回應中宣告已載入的記憶模組（或「空白專案，無記憶」）
```

> **衝突防護**：若 Antigravity（Gemini）剛更新過某張記憶卡，下次呼叫 memory_read 會自動取得最新版本。
> **禁止假設**：不可依賴上一次對話的記憶內容，每次新對話必須重新讀取。

## 1. Unified Memory Architecture (單軌共用記憶庫)

**唯一記憶庫**：`.agents/memory/`（相對於專案根目錄）

- **Antigravity（Gemini）**：透過 `cartridge-system` MCP 讀寫
- **Claude Code（本 Agent）**：透過 `cartridge-system` MCP 讀寫（Multi-MCP Gateway 提供）
- **格式**：每個模組一個 `SKILL.md`，路徑為 `.agents/memory/<module>/SKILL.md`
- **禁止使用** `~/.claude/projects/` 或 `.claude/agents/memory/` 作為記憶卡存儲位置

## 1.5 Project Context Layer (專案脈絡層)

**專案脈絡目錄**：`.agents/context/`（相對於專案根目錄）

- **用途**：保存設計 DNA、產品偏好、技術偏好、溝通偏好與驗收偏好。
- **格式**：每張卡使用 `CONTEXT.md`，不可使用 `SKILL.md`，避免被當成可執行技能。
- **狀態**：`candidate`、`approved`、`deprecated`、`conflict`、`review`。
- **讀取**：藍圖、建構、修復、測試、濃縮與技能鍛造遇到相關任務時讀取。
- **寫入**：只能提出候選脈絡；永久寫入或升級為已核准脈絡需要 `GO CONTEXT`。設計 DNA 可用 `GO DNA` 作為別名。
- **邊界**：專案脈絡不走 `memory_commit`，不參與原始碼記憶 stale 檢查。

## 2. Exit Hold Gate (離場條件鎖)

```
[EXIT HOLD GATE] Before reporting task completion:
├── Director prompt contains [SUDO]? → Clear hold. Allow completion.
├── Were any source files CREATED in this session?
│   └── YES → Find or create a matching .agents/memory/ card.
│             [HALT if no card]「🔴 [MEM HALT] 新建模組尚未建立記憶卡。請先執行記憶歸卡。」
├── Were any source files MODIFIED in this session?
│   ├── NO  → Release hold. Proceed.
│   └── YES → Check: did memory-ops fire for ALL affected cards?
│       ├── YES → Release hold. Proceed.
│       └── NO  → [HALT]「🔴 [MEM HALT] 記憶卡尚未更新。請先執行記憶歸卡。」
├── [v4.0] Ghost File Check (non-blocking warning)
│   └── Call memory_list, scan for modules where ghostFilesCount > 0
│       ├── Found → Output: 「⚠️ [GHOST WARN] {模組名} 存在 {N} 個幽靈檔案（已追蹤但磁碟不存在）。建議下次對話優先處理。」
│       └── None → Pass silently
├── [v5.5] Compaction Check
│   └── If memory_list / workspace_brief / commit_preflight reports needsCompaction=true
│       └── [HALT]「🔴 [MEM HALT] 記憶卡已達壓縮門檻。請先彙整週期事件或拆分歸檔，再繼續追加。」
└── Hold released → Proceed to completion.
```

## 3. Memory Card Operations (記憶卡操作規範)

- **Directory**: `.agents/memory/` with nested `SKILL.md` files (max 4 levels deep).
- **Context boundary**: Long-term preferences and aesthetic rules belong in `.agents/context/`, not memory cards.
- **Granularity**: 1 card ≤ 8 tracked files. Suggest splitting when exceeded.
- **Compaction limits**: Main card ≤ 16 KB / 120 lines; Cycle Events ≤ 30 items; archive volume ≤ 32 KB / 200 lines.
- **Schema v2**: Main cards keep English `Current Truth`, `Active Constraints`, `Cycle Events`, `Archive Index`, and `中文摘要`; old cards are readable and upgraded lazily only when touched.
- **Timestamp**: ALL timestamps MUST use ISO 8601 Taiwan timezone: `YYYY-MM-DDTHH:mm:ss+08:00`. UTC (`Z`) is FORBIDDEN.
- **Before modifying files**: Check if the file appears in any memory card's `## Tracked Files`. If yes, read that card first.
- **Sanitization**: NEVER write PII, absolute user paths (`C:\Users\username\`), or secret tokens into memory cards.
- **Load procedures**: Read `.claude/skills/memory-ops/SKILL.md` for card write format and commit procedures.
- **MCP Tool Chain**: `cartridge-system__memory_list` → `cartridge-system__memory_read` → `write_to_file` → `cartridge-system__memory_commit`
- **Gateway Path Discipline**: When cartridge-system is reached through Multi-MCP Gateway, use `gateway__call_tool` with explicit `workspace`; also pass `projectRoot` in downstream arguments. Discovery tools (`gateway__search_tools`, `gateway__list_server_tools`) are schema-only.
- **Commit Risk Boundary**: `cartridge-system__memory_commit` writes files and index metadata. It is forbidden in discussion, planning, testing, or read-only audit phases; call it only after the target memory card has already been updated.

## 4. Skill System (技能系統契約)

- **`.claude/skills/`**: Claude Code native skills — user-invoked (`/skill-name`) or Claude-auto-invoked. These are workflow triggers.
- **`.claude/skills/`**: Operational knowledge library — read by Master Agent on demand. These are procedural guides (not slash commands).
- **Progressive Disclosure**: Only skill names/descriptions are known at session start. Full content is read only when needed.
- **Skill Binding**: When a workflow declares `required_skills`, read those `.claude/skills/*/SKILL.md` files before proceeding.

## 5. Memory Sanitization & Deletion (記憶淨化)

- Before writing to any memory card, scrub: PII, absolute system paths with usernames, secret tokens/API keys.
- If a module is deleted from codebase, physically delete its `.agents/memory/` card. No abandoned cards.

- **All-Ghost Cartridge Detection (v4.0)**: If `memory_list` shows a cartridge where `ghostFilesCount` equals
  `trackedFilesCount` (every tracked file is a ghost), proactively propose retiring the card to the Director —
  all files it tracks no longer exist on disk.
