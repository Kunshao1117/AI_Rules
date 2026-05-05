---
name: 02_blueprint
description: 商業需求轉化為軟體架構 — 技術堆疊探勘、ER 圖、API 路由設計、記憶卡初始化
required_skills: [memory-ops, tech-stack-protocol]
memory_awareness: full
user-invocable: true
---

# [SKILL: /02_blueprint — 架構藍圖]

## 1. Tech Stack Discovery (技術堆疊探勘)

> [LOAD SKILL] Read `.claude/agents/skills/tech-stack-protocol/SKILL.md` before proceeding.

- Scan project root for `package.json`, `tsconfig.json`, `next.config.*`, `.env*` files.
- Identify framework versions and major dependencies.
- Use `WebSearch` to ground latest stable docs for detected frameworks.
- Lock tech stack into `.claude/agents/memory/_system/SKILL.md`.

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

> [LOAD SKILL] Read `.claude/agents/skills/memory-ops/SKILL.md`.

- Create initial memory cards for each major module identified.
- Populate: `## Tracked Files`, `## Key Decisions`, `## Relations`.
- Update MEMORY.md index.

## 4. Blueprint Output (藍圖產出)

- Generate blueprint artifact in Traditional Chinese with structure:
  1. 【技術堆疊鎖定】— Framework + version + rationale
  2. 【系統架構圖】— Mermaid ER/flow diagrams
  3. 【API 路由規劃】— Route map table
  4. 【模組拆分與記憶卡對照】— Module → memory card mapping
  5. 【開放問題】— Design decisions requiring Director input

- Output:「[架構藍圖] 已產出。請總監審閱後，執行 /03_build 進入建構階段。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source code writes. Memory card initialization is permitted.
- **Memory**: full — tech stack lock-in and initial card creation.
