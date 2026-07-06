---
trigger: model_decision
description: 記憶卡與技能系統操作合約；涉及模組記憶讀寫、技能載入流程或 workflow chaining 時適用（Use when: memory/skill flow applies）。衍生技能建立請見 `05_project_skill_contract.md`。
---

# [ANTIGRAVITY MEMORY & SKILL CONTRACT]

## 1. Project Memory System

```
[EXIT HOLD GATE] Before reporting task completion:
├── 總監提示包含 [SUDO]?
│   └── YES → 只記錄覆寫/風險關閉請求；exit hold 與 memory/source attribution gates 仍維持啟用；[SUDO] 不授權 completion claims。
├── 目前 workflow 是 /03_sketch?
│   └── YES → 完全略過 memory check（skip memory check entirely）。
├── 本次是否建立 source files?
│   └── YES → 為新模組尋找或建立對應記憶卡（matching memory card）。
│             載入 `memory-ops` skill，依 card creation procedures 建立。
│             若沒有記憶卡 → [HALT] 「🔴 [MEM HALT] 新建模組尚未建立記憶卡。請先執行歸檔。」
├── 本次是否修改 source files?
│   ├── NO  → 解除 completion hold；靜默繼續（Release hold; proceed silently）。
│   └── YES → 檢查所有受影響記憶卡是否已觸發 memory-ops。
│       ├── YES → 解除 completion hold；靜默繼續（Release hold; proceed silently）。
│       └── NO  → [HALT] 「🔴 [MEM HALT] 記憶卡尚未更新。請先執行記憶歸卡。」
│                 不得回報任務完成（DO NOT report completion）。
├── [v4.0] 幽靈檔案檢查（Ghost File Check; non-blocking warning）
│   └── 呼叫 memory_list，掃描 ghostFilesCount > 0 的模組。
│       ├── Found → Output: 「⚠️ [GHOST WARN] {模組名} 存在 {N} 個幽靈檔案（已追蹤但磁碟不存在）。建議下次對話優先處理。」
│       └── None → 靜默通過（Pass silently）。
├── [v5.5] 壓縮門檻檢查（Compaction Check）
│   └── 若 memory_list / workspace_brief / commit_preflight 回報 needsCompaction=true
│       └── [HALT] 「🔴 [MEM HALT] 記憶卡已達壓縮門檻。請先彙整週期事件或拆分歸檔，再繼續追加。」
└── completion hold 已解除 → 進入 Completion Gate。
```

- **記憶目錄（Memory Directory）**: Source-code memory 存放於 `.agents/memory/` 的 active memory cards。目標 canonical main file 是 `MEMORY.md`；在 governed migration 與 cartridge-system support 確認前，`.agents/memory/` 下既有 `SKILL.md` 屬於 legacy compatibility sources。Memory cards 不是 executable skills。
- **專案脈絡目錄（Project Context Directory）**: Long-lived preferences、design DNA、product defaults、communication preferences 與 acceptance preferences 存放於 `.agents/context/**/CONTEXT.md`。這些卡片在 upgrade 時受保護，不是 executable skills，也不參與 source memory staleness。
- **可讀也可寫（Readable AND Writable）**: Memory cards 不同於 operational skills，屬於 read-write。修改由記憶卡追蹤的 source files 後，必須更新其 active memory main file 的相關區段。
- **壓縮限制（Compaction Limits）**: Main card ≤ 16 KB / 120 lines；Cycle Events ≤ 30 items；archive volume ≤ 32 KB / 200 lines。
- **Schema v2**: Main cards 保留英文 `Current Truth`、`Active Constraints`、`Cycle Events`、`Archive Index` 與 `中文摘要`；old cards 可讀，只有被觸碰時才 lazily upgraded。
- **脈絡寫入閘門（Context Write Gate）**: Project context 可在一般 workflows 中提出，但 persistent writes 需要 `GO CONTEXT`；design DNA 可用 `GO DNA` 作為 alias。
- **更新程序（Update Procedures）**: Markdown update format 與 procedures 依 `memory-ops` skill 執行。
- **脈絡完整性（Context Integrity）**: 修改任何 source file 前，檢查它是否出現在記憶卡的 Tracked Files section；若有 matching memory card，先讀取該卡。
- **技能交叉引用（Skill Cross-Reference）**: 載入記憶卡後，檢查其 `## Applicable Skills` section；若列出的 skills 尚未載入，需載入以確保該模組的 operational constraints 已啟用。
- **時間戳標準（Timestamp Standard）**: Memory card frontmatter 的所有 timestamps 必須使用 **ISO 8601 with Taiwan timezone**：`YYYY-MM-DDTHH:mm:ss+08:00`。禁止使用 UTC（`Z` suffix）（FORBIDDEN）。
- **Gateway Path Discipline**: When cartridge-system is reached through Multi-MCP Gateway, use `gateway__call_tool` with explicit `workspace`; also pass `projectRoot` in downstream arguments. Discovery tools (`gateway__search_tools`, `gateway__list_server_tools`) are schema-only.
- **提交風險邊界（Commit Risk Boundary）**: `cartridge-system__memory_commit` 會寫入檔案與 index metadata。禁止在討論、規劃、測試或 read-only audit phase 呼叫；只能在目標記憶卡已經更新後呼叫。



## 2. Turbo Mode
- If a workflow step is annotated with `// turbo`, you are authorized to autonomously chain the next step.

## 3. Skill System
- **Knowledge Layer Architecture**: The framework separates executable skills from non-executable project context:
  1. **Framework Skills** in `.agents/skills/` — Framework-provided, overwritten on upgrade. Read-only for the Agent.
  2. **Project Memory** in `.agents/memory/` — Project-specific knowledge state. Read-write. Protected on upgrade. Not an executable skill source.
  3. **Project Context** in `.agents/context/` — Long-lived preferences in CONTEXT.md. Read by relevant workflows, written only after `GO CONTEXT`.
- **On-Demand Loading**: Skills are loaded on-demand, NOT always-on.
- **Progressive Disclosure**: Only skill names and descriptions are injected at session start. Full SKILL.md is loaded only when activated.
- **Workflow Binding**: Workflows declare `required_skills` in YAML frontmatter. The Agent MUST load all listed skills before proceeding.
- **Memory Binding**: Workflows declare `memory_awareness` in YAML frontmatter (`none`, `read`, `full`). `full` means affected memory cards MUST be updated after execution.
- **Available Skills**: Determined by the `.agents/skills/` directory and project skills. Project memory and project context are readable knowledge layers, not skill sources. For project skills, see `05_project_skill_contract.md`.
- **Skill Metadata Standard**: All SKILL.md frontmatter MUST include a `metadata` block with `author`, `version`, `origin` (`framework` or `project`), `memory_awareness` (`none`, `read`, or `full`), and `tool_scope` (array of permitted tool categories) fields.

## 4. Configuration Interface Obligation
- **Settings Registry**: For core plugin or system-level features that expose behavioral thresholds, exclude paths, or dynamic logic toggles, the developer MUST formally register these settings via VS Code `contributes.configuration` (e.g., `cartridge.excludeDirs`) or an equivalent standard interface.
- **Hardcoding Ban**: Long-living configuration settings MUST NOT be permanently hardcoded in source files (e.g. `src/config.ts`).
- **Memory Tracking Validation**: When a capability depends on configuration interfaces, its corresponding memory card (e.g. `_system` or `extension`) MUST document the associated configuration keys (`cartridge.xxx`) mapped to it.

## 5. Memory Sanitization And Deletion

- **Sanitization**: Before writing to ANY memory card, you MUST scrub all PII (Personally Identifiable Information), absolute system paths containing user names (e.g., `C:\Users\JohnDoe\`), and secret tokens/API keys. Memory cards must contain only architectural knowledge and relative paths.
- **Purging**: If a module is entirely deleted from the codebase, you MUST physically delete its corresponding memory card from `.agents/memory/`. Do NOT leave abandoned memory cards, as they permanently pollute the AI's source context. Project context should be marked `deprecated` unless the Director explicitly approves deletion.

- **All-Ghost Cartridge Detection (v4.0)**: If `memory_list` shows a cartridge where `ghostFilesCount` equals
  `trackedFilesCount` (every tracked file is a ghost), proactively propose retiring the card to the Director —
  all files it tracks no longer exist on disk.
