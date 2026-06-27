---
name: "02-blueprint-架構"
description: "Use when: 純架構設計、藍圖、技術堆疊探勘、全系統初始化、重大技術轉向、ER 圖、API 路由設計、三平台代理治理架構宣告、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 的架構判斷。DO NOT use when: 目標是同一輪直接建構功能；改用建構流程的設計到建構合約。"
required_skills: [memory-ops, tech-stack-protocol, memory-arch, ai-dev-quality-gate, intent-alignment-gate, quality-review-governance, project-context-protocol, programming-team-governance]
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before architecture planning.
> [LOAD SKILL] If this blueprint touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before architecture planning.
> [LOAD SKILL] Before producing an architecture blueprint, read `.agents/skills/intent-alignment-gate/SKILL.md` and apply requirement playback, neutral challenge, decision trace, acceptance trace, and drift-risk output sections.
> [LOAD SKILL] If this blueprint touches governance, public contracts, workflow rules, release/plugin behavior, security, cross-module logic, or competing simple/complex designs, read `.agents/skills/quality-review-governance/SKILL.md` and include review purpose, review state, evidence status, accepted risk, and blockers.
> [LOAD SKILL] If this blueprint touches product direction, design DNA, technical preferences, communication preferences, or acceptance preferences, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before architecture planning.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 02 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Record requirement playback, neutral challenge, decision status, alternatives, trade-offs, assumptions, review purpose/state when required, compatibility impact, requirement-to-acceptance trace, and the handoff contract for later build work.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding-related work, read `.agents/skills/programming-team-governance/SKILL.md` and build a Programming Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability and execution mode: direct, delegated, blocked, or not-applicable; evidence branches stay read-only and the main agent owns writes, review state, and acceptance.

# source-command-02-blueprint-skill

Use this skill when the user asks to run the migrated source command `02_blueprint(架構)-SKILL`.

## Command Template

# [SKILL: /02_blueprint — 純架構藍圖]

Use this workflow only when the Director needs architecture output without immediate source implementation, full-system initialization, or a major technology pivot. Normal feature work should keep architecture decisions inside `/03_build` so planning context is not split across workflows.

## 1. Tech Stack Discovery (技術堆疊探勘)

> [LOAD SKILL] Read `.agents/skills/tech-stack-protocol/SKILL.md` before proceeding.
> [LOAD SKILL] Read `.agents/skills/memory-arch/SKILL.md` — 了解記憶卡層級化規則。
> [LOAD SKILL] Read `.agents/skills/project-context-protocol/SKILL.md` when product, design, technical, communication, or acceptance context may affect the blueprint.

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
- Lock tech stack into the active `_system` memory main file.

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
- IF (Director intends to implement the feature in the same task):
  - Stop and route to `/03_build` design-to-build contract.
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
- Populate schema v2 sections: `## Current Truth`, `## Active Constraints`, `## Cycle Events`, `## Archive Index`, `## 中文摘要`, `## Tracked Files`, and `## Relations`.
- Follow `memory-arch` nesting guidelines (max depth 4, child paths inside parent directories).

## 4. Blueprint Output (藍圖產出)

- Generate blueprint artifact in Traditional Chinese with structure:
  1. 【需求理解回放】— Goal, non-goals, operator scenario, constraints, success criteria, and assumptions
  2. 【中立反證檢查】— 我看到的事實 / 可能問題 / 建議做法
  3. 【技術堆疊鎖定】— Framework + version + rationale
  4. 【系統架構圖】— Mermaid ER/flow diagrams
  5. 【API 路由規劃】— Route map table
  6. 【模組拆分與記憶卡對照】— Module → memory card mapping
  7. 【架構決策表】— Decision status, alternatives, trade-offs, compatibility, and evidence level
  8. 【審查目的與狀態】— Review purpose, lifecycle state, evidence status, accepted risk, and blockers when the review gate applies
  9. 【需求到驗收追蹤表】— Requirement source, plan coverage, acceptance evidence, and status
  10. 【建構交接合約】— Must-do, must-not-do, dependencies, risks, and unverified items for `/03_build`
  11. 【三平台代理治理架構說明】— 若適用
  12. 【未驗證與阻塞清單】— Design decisions requiring Director input or later evidence

- Output:「[架構藍圖] 已產出。若總監要進入實作，請在同一對話中交給 /03_build 沿用本藍圖，不要重新規劃上下文。」

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` — no source code writes. Memory card initialization is permitted.
- **Memory**: full — tech stack lock-in and initial card creation.
