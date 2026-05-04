# [MEMORY & SKILL CONTRACT]

## 0. Turn=1 Startup Protocol (對話啟動探測 — 每次新對話必執行)

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
└── Hold released → Proceed to completion.
```

## 3. Memory Card Operations (記憶卡操作規範)

- **Directory**: `.agents/memory/` with nested `SKILL.md` files (max 4 levels deep).
- **Granularity**: 1 card ≤ 8 tracked files. Suggest splitting when exceeded.
- **Timestamp**: ALL timestamps MUST use ISO 8601 Taiwan timezone: `YYYY-MM-DDTHH:mm:ss+08:00`. UTC (`Z`) is FORBIDDEN.
- **Before modifying files**: Check if the file appears in any memory card's `## Tracked Files`. If yes, read that card first.
- **Sanitization**: NEVER write PII, absolute user paths (`C:\Users\username\`), or secret tokens into memory cards.
- **Load procedures**: Read `.claude/agents/skills/memory-ops/SKILL.md` for card write format and commit procedures.
- **MCP Tool Chain**: `cartridge-system__memory_list` → `cartridge-system__memory_read` → `write_to_file` → `cartridge-system__memory_commit`

## 4. Skill System (技能系統契約)

- **`.claude/skills/`**: Claude Code native skills — user-invoked (`/skill-name`) or Claude-auto-invoked. These are workflow triggers.
- **`.claude/agents/skills/`**: Operational knowledge library — read by Master Agent on demand. These are procedural guides (not slash commands).
- **Progressive Disclosure**: Only skill names/descriptions are known at session start. Full content is read only when needed.
- **Skill Binding**: When a workflow declares `required_skills`, read those `.claude/agents/skills/*/SKILL.md` files before proceeding.

## 5. Memory Sanitization & Deletion (記憶淨化)

- Before writing to any memory card, scrub: PII, absolute system paths with usernames, secret tokens/API keys.
- If a module is deleted from codebase, physically delete its `.agents/memory/` card. No abandoned cards.
