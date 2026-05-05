---
name: 02_blueprint
description: 商業需求轉化為軟體架構 — 技術堆疊探勘、ER 圖、API 路由設計、記憶卡初始化（支援升級模式與雙 AI 並存架構宣告）
required_skills: [memory-ops, tech-stack-protocol, memory-arch]
memory_awareness: full
user-invocable: true
---

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

**雙 AI 並存架構宣告：**
```
[DUAL AI GATE]
├── 同時偵測到 `.agents/` 目錄（Antigravity）AND `.claude/` 目錄（Claude Edition）？
│   └── YES → 在藍圖中宣告雙 AI 並存架構：
│             「本專案採用雙 AI 引擎並存架構：
│              - Antigravity（Gemini IDE）負責 .agents/ 生態系統
│              - Claude Edition（VS Code 擴充）負責 .claude/ 工作流
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
  5. 【雙 AI 並存架構說明】— 若適用
  6. 【開放問題】— Design decisions requiring Director input

- Output:「[架構藍圖] 已產出。請總監審閱後，執行 /03_build 進入建構階段。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` — no source code writes. Memory card initialization is permitted.
- **Memory**: full — tech stack lock-in and initial card creation.
