# [MEMORY & SKILL CONTRACT]

## 1. Two-Tier Memory Architecture (雙層記憶體架構)

| 層次 | 位置 | 用途 | 讀寫 |
|---|---|---|---|
| **Claude Code 原生記憶體** | `~/.claude/projects/<project>/memory/` | 用戶偏好、回饋、專案背景、外部資源 | Master Agent 透過 Write/Edit |
| **專案記憶卡** | `<project>/.agents/memory/` | 程式碼架構知識、模組決策、追蹤檔案 | Master Agent 透過 Write/Edit |

- **Claude Code 原生記憶體** 使用 `user/feedback/project/reference` 四種類型，儲存跨對話的持久偏好與背景。
- **專案記憶卡**（`.agents/memory/*/SKILL.md`）追蹤程式碼模組的架構決策、已知問題、教訓。

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
- **Load procedures**: Read `.agents/skills/memory-ops/SKILL.md` for card write format and commit procedures.

## 4. Skill System (技能系統契約)

- **`.claude/skills/`**: Claude Code native skills — user-invoked (`/skill-name`) or Claude-auto-invoked. These are workflow triggers.
- **`.agents/skills/`**: Operational knowledge library — read by Master Agent on demand. These are procedural guides (not slash commands).
- **Progressive Disclosure**: Only skill names/descriptions are known at session start. Full content is read only when needed.
- **Skill Binding**: When a workflow declares `required_skills`, read those `.agents/skills/*/SKILL.md` files before proceeding.

## 5. Memory Sanitization & Deletion (記憶淨化)

- Before writing to any memory card, scrub: PII, absolute system paths with usernames, secret tokens/API keys.
- If a module is deleted from codebase, physically delete its `.agents/memory/` card. No abandoned cards.
