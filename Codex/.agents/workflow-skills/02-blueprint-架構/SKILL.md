---
name: "02-blueprint-架構"
description: "Use when: 架構設計、藍圖、技術堆疊探勘、ER 圖、API 路由設計、三平台代理治理架構宣告。DO NOT use when: 已有核准計畫要直接建構或修復。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: blueprint
  role: planner
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read", "mcp:cartridge-system"]
  human_gate: "GO required before memory writes"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before architecture planning.
# source-command-02-blueprint-skill

Use this skill when the user asks to run the migrated source command `02_blueprint(架構)-SKILL`.

## Command Template

# [SKILL: /02_blueprint — 架構藍圖]

## 1. Tech Stack Discovery (技術堆疊探勘)

> [LOAD SKILL] Read `.agents/skills/tech-stack-protocol/SKILL.md` before proceeding.
> [LOAD SKILL] Read `.agents/skills/memory-arch/SKILL.md` — 了解記憶卡層級化規則。

```
[INIT MODE GATE]
├── `.agents/memory/_system/` 已存在且 tech stack 已鎖定？
│   └── YES → 進入「升級模式」：讀取現有 _system 記憶卡，評估新功能模組的架構影響
│             輸出：「[升級模式] 偵測到現有系統記憶。本次將在現有架構基礎上新增模組。」
└── 否 → 進入「初始化模式」：執行完整技術堆疊探勘
```

**初始化模式：**
- Scan project root for `package.json`, `tsconfig.json`, `next.config.*`, `.env*` files.
- Identify framework versions and major dependencies.
- Use `WebSearch` to ground latest stable docs for detected frameworks.
- Lock tech stack into `.agents/memory/_system/SKILL.md`.

**三平台代理治理架構宣告：**
```
[DUAL AI GATE]
├── 同時偵測到 `.agents/` 目錄（Antigravity）AND `.Codex/` 目錄（Codex Edition）？
│   └── YES → 在藍圖中宣告三平台代理治理架構：
│             「本專案採用三平台代理治理架構：
│              - Antigravity（Gemini IDE）負責 .agents/ 生態系統
│              - Codex Edition（VS Code 擴充）負責 .Codex/ 工作流
│              - 共用記憶庫位於 .agents/memory/（D01 設計決策）」
└── 否 → 繼續單引擎模式，無需特別宣告
```

## 2. Architecture Design (架構設計)

[SCOPE GATE] Classify blueprint scope:
- IF (Director specifies a single module or feature):
  - Design module-level architecture only.
- IF (Director specifies full-system or greenfield):
  - Design complete system architecture with:
    1. ER Diagram (Mermaid format)
    2. API Route Map (REST or tRPC)
    3. Component hierarchy
    4. State management strategy

## 3. Memory Initialization (記憶卡初始化)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md`.

- Create initial memory cards for each major module identified.
- Populate: `## Tracked Files`, `## Key Decisions`, `## Relations`.
- Follow `memory-arch` nesting guidelines (max depth 4, child paths inside parent directories).

## 4. Blueprint Output (藍圖產出)

- Generate blueprint artifact in Traditional Chinese with structure:
  1. 【技術堆疊鎖定】— Framework + version + rationale
  2. 【系統架構圖】— Mermaid ER/flow diagrams
  3. 【API 路由規劃】— Route map table
  4. 【模組拆分與記憶卡對照】— Module → memory card mapping
  5. 【三平台代理治理架構說明】— 若適用
  6. 【開放問題】— Design decisions requiring Director input

- Output:「[架構藍圖] 已產出。請總監審閱後，執行 /03_build 進入建構階段。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` — no source code writes. Memory card initialization is permitted.
- **Memory**: full — tech stack lock-in and initial card creation.
