---
name: memory-arch
description: >
  [Infra] Memory architecture topology guide: layer resolution, splitting rules, and static container specifications.
  Use when: 需要決定記憶卡的層級架構、拆分過大的記憶卡、收容特殊檔案、或了解整體系統分佈時載入。
  DO NOT use when: 純更新記憶卡內容或修復過期指數（用 memory-ops）。
metadata:
  author: antigravity
  version: "1.3"
  origin: framework
  kind: operational
  memory_awareness: none
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
---

# Memory Architecture (記憶卡架構與拓樸)

## HITL Boundary

- Read-only memory topology inspection may proceed silently.
- Creating, splitting, moving, or rewriting memory cards, and any `memory_commit` call, requires Director `GO` and an `[MCP HITL GATE]` justification block before execution.
- Discovery of memory tool schemas is not permission to execute mutating memory tools.

## 1. Creating New Memory (建立新記憶)

```
New module identified by /02_blueprint or /08_audit?
├── Step 1: Determine nesting level (see Nesting Decision Tree below)
├── Step 2: Create folder at resolved path → `.agents/memory/{module}/`
├── Step 3: Create SKILL.md using template → see references/memory-template.md
│   ⇒ frontmatter: name, description (MUST include Chinese keywords), scopePath
│   ⇒ frontmatter: memory_schema_version=2, content_language=en, human_language=zh-TW
│   ⇒ body: Current Truth, Active Constraints, Cycle Events, Archive Index, 中文摘要, Tracked Files
├── Step 3.5: Dependency Assessment (v4.0)
│   ⇒ Check whether this module's source files import files owned by other memory cards
│   ⇒ If yes, add a `dependencies` field only for those upstream cards
│   ⇒ Also add dependencies for direct technical decision coupling when upstream staleness requires review
│   ⇒ Record the dependency reason in ## Current Truth or ## Active Constraints
└── Step 4: Call memory_commit(moduleName, projectRoot)
    ⇒ Registers card in index + validates structure. When routed through Gateway, use `gateway__call_tool` with explicit `workspace` and `projectRoot`.
```

### Dependency Semantics (依賴語義)

`dependencies` is a system-level staleness propagation field. Use it only when an upstream card becoming stale means this card must be reviewed too.

Allowed cases:

- This card's tracked source files import or consume source files owned by another memory card.
- This card's key technical decisions directly depend on decisions recorded in another card.
- Upstream staleness should trigger review of this card.

Forbidden cases:

- Parent card or child card relationships by default（父子卡預設不是 dependencies）
- Directory nesting or scope containment only
- Navigation-only links
- Recommended reading
- Applicable Skills
- Same-domain sibling cards without a real engineering dependency

Use `## Relations` for navigation. Use `## Applicable Skills` for operational guidance.

### Nesting Decision Tree (層級判斷決策樹)

```
Create new memory card?
├── Does this module belong to an existing functional domain card?
│   ├── No → Create at `.agents/memory/` root level (layer 1)
│   └── Yes → Is the parent card's depth < 4?
│       ├── No → Max depth reached, create at parent's level (keep flat)
│       └── Yes → Create inside parent card's subdirectory
│           ⇒ Path: `.agents/memory/{parentName}/{child}/SKILL.md`
└── Decision criteria:
    ├── scopePath containment? (child's scopePath is sub-path of parent's)
    ├── Does modifying the child typically require referencing the parent's shared decisions?
    └── Are there 3+ modules under the same domain that can be independently tracked?
```

Directory nesting is topology and navigation, not dependency. A child card MUST NOT depend on its parent merely because it is stored under the parent's directory. Represent parent/child navigation in `## Relations` unless staleness propagation is truly required.

## 2. Tree Structure (樹狀結構規則)

### Rules (規則)

- Layer 1–2: `.agents/memory/{module}/SKILL.md` — IDE auto-discovers
- Layer 3–4: `.agents/memory/{parent}/{child}/SKILL.md` — AI loads on-demand via `## Relations`
- Maximum depth: **4 layers**
- `scopePath` (optional): directory prefix for file attribution matching

### Directory Example (目錄範例)

```
.agents/memory/
├── api/                          ← Layer 1 (functional domain) depth=1
│   ├── SKILL.md                  ← Shared API current truth and constraints
│   ├── auth/                     ← Layer 2 depth=2, parent='api'
│   │   ├── SKILL.md              ← Auth module current truth
│   │   └── oauth/                ← Layer 3 depth=3
│   │       └── SKILL.md          ← OAuth sub-module
│   └── manage/                   ← Layer 2 depth=2, parent='api'
│       └── SKILL.md              ← Management module
└── frontend/                     ← Layer 1 (independent domain)
    └── SKILL.md
```

### Loading Nested Cards (子卡載入流程)

```
Need to access a nested card (layer 3–4)?
├── Step 1: Read parent card → check ## Relations for child card names
├── Step 2: Call memory_read(childName)
│   ⇒ resolveSkillPath handles path resolution automatically
└── No manual path construction needed
```

Nested cards should list parent/child context in `## Relations`, for example:

```markdown
## Relations
- api（parent card: shared API current truth and constraints）
- api.auth.oauth（child card: OAuth-specific current truth and constraints）
```

Do not mirror these navigation links into frontmatter `dependencies` unless the Dependency Write Gate in `memory-ops` passes.

## 2.5 Project Context Boundary (專案脈絡邊界)

Long-lived preferences, design DNA, product acceptance defaults, and communication style belong in `.agents/context/`, not `.agents/memory/`.

Source memory cards should record source ownership, Current Truth, Active Constraints, Cycle Events, Archive Index, staleness, and Relations. Historical detail belongs in archives or compacted summaries only when still relevant to current behavior.

If a task discovers a reusable preference:

1. Propose it as candidate project context.
2. Wait for explicit `GO CONTEXT` before writing `.agents/context/**/CONTEXT.md`.
3. Do not call `memory_commit`; project context does not participate in source memory staleness.

### Granularity Advisory (粒度建議)

- Target **8 tracked files** or fewer per card for easy review.
- Exceeded → `memory_list` may flag a split suggestion; this is advisory by file count alone.
- Split becomes required only when the card also exceeds a hard limit, mixes unrelated ownership, or creates real maintenance difficulty.

### Compaction Hard Limits (壓縮硬上限)

Memory architecture separates current truth from historical evidence:

| Layer | Default limit | Action after limit | Notes |
|------|---------------|--------------------|-------|
| Main card | 16 KB or 120 lines | Compact or split into child cards | Controls default read cost |
| Cycle Events | 30 items | Compact before adding item 31 | Event numbers are cycle-local |
| Archive volume | 32 KB or 200 lines | Open the next volume | Archive is loaded only for trace-back |
| Root index card | 8 KB | Keep as pure navigation index | Do not store history here |

Main cards MUST preserve only currently valid facts. Historical repair detail belongs in archive volumes referenced by `## Archive Index`.

### Card Layer Model (卡片分層模型)

- **Main card**: schema v2 SKILL.md containing English `## Current Truth`, `## Active Constraints`, `## Cycle Events`, `## Archive Index`, `## 中文摘要`, and `## Tracked Files`.
- **Child card**: narrower ownership card created when a main card exceeds hard limits, mixes concerns, or file-count warnings reveal real maintenance difficulty.
- **Archive volume**: historical long-form record created during compaction or lazy upgrade. It is not part of normal startup loading.
- **Root index card**: map/navigation only. If it grows past 8 KB, move details into child cards or archive volumes.

## 3. Splitting Memory Cards (拆分操作步驟)

When a memory card exceeds hard limits, mixes unrelated ownership, or maintenance difficulty is discovered during routine work:

```
Need to split a memory card?
├── Step 1: Call memory_read to get the full content of the old card
│   ⇒ Analyze trackedFiles distribution, Current Truth, Cycle Events, and Archive Index
├── Step 2: Propose split strategy to Director
│   ⇒ Explain which current truths stay in the parent, which move to child cards, and which history moves to archive volumes
├── Step 3: Execute after Director approves
│   ├── Promote the original card to parent (retain shared current truth + scopePath)
│   ├── Create child card subdirectories under parent (each with scopePath + specific decisions)
│   ├── Add parent/child navigation under ## Relations
│   ├── Move superseded or verbose history into archive volumes
│   └── write_to_file to update parent SKILL.md (trim to current shared portions only)
├── Step 4: Plugin auto scan + refresh
│   ⇒ Index and file watchers update automatically
├── Step 5: Call memory_commit for EACH new child card
│   ⇒ Each child card must be individually committed
└── Step 6: Call memory_commit for the parent card
    ⇒ Parent card's trimmed content must also be committed
```

Splitting a card does not automatically create `dependencies` between the parent and children. Add frontmatter dependencies only when source imports or decision coupling require indirect staleness propagation.

## 3.5 Compaction Procedure (週期彙整程序)

Use this when a main card reaches 30 cycle events, exceeds 16 KB, exceeds 120 lines, or contains conflicting historical notes:

```
Compaction due?
├── Step 1: Read the main card and relevant source files
├── Step 2: Identify still-valid facts and constraints
├── Step 3: Rewrite ## Current Truth as at most 10 English bullets
├── Step 4: Rewrite ## Active Constraints as active hard limits only
├── Step 5: Move historical cycle detail into archive-001.md / archive-002.md / ...
├── Step 6: Update ## Archive Index with volume path and scope
├── Step 7: Reset ## Cycle Events for the next cycle
└── Step 8: Call memory_commit after the SKILL.md file is updated
```

Do not add event 31. If the card is too contradictory to summarize safely, stop at a compaction plan and ask for Director approval.

## 4. Static Container Cards (靜態收容卡匣)

### Rules & Definitions
對於必須被 git 追蹤但缺乏商業動態邏輯的檔案（如 `package-lock.json`、`assets/*.png`），強烈建議建立專職的「靜態收容卡匣」以避免幽靈檔案污染。

### Naming Convention (命名約定)
這類卡匣的名稱必須以底線開頭（例如：`_assets`、`_ghost_bin`、`_config_locks`），明確標示其「非業務邏輯記憶」的屬性。

### Green Channel & Staleness Privilege (過期放寬特權)
這類帶底線的收容卡匣若因鎖定檔或靜態資源更新而產生卡匣過期警報（Staleness > 0），AI 具有特權：
- **跳過繁瑣檢視**：在確認該異動無視野安全風險後，可合法略過 `memory-ops` 原有之 6 步檢索流程。
- **單步核銷**：直接發動 `memory_commit` 單步歸卡以快速核銷警報。
- **風險邊界**：此特權只適用於已確認無視野安全風險的靜態收容卡匣歸卡階段；`memory_commit` 仍是會寫檔的高風險工具，不得在討論、規劃或唯讀盤點階段呼叫。
