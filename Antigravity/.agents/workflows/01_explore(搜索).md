---
description: "Use when: 探索新商業想法、技術方向、可行性研究、網路研究、魔鬼代言人分析。DO NOT use when: 需要直接寫程式、修 bug 或提交。"
required_skills: []
memory_awareness: none
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: explore
  role: analyst
  memory_awareness: none
  tool_scope: ["web:read", "filesystem:read"]
  human_gate: "none"
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
# [WORKFLOW: EXPLORE (搜索)]

## 1. Execution Constraint

- **Absolute Ban**: DO NOT write, modify, or propose any executable source code during this workflow.
[RECON GATE] Actuation decision:
- IF (research requires only text retrieval or API data):
  - [FAST PATH] MUST use native search tools (`search_web`, `read_url_content`) to prevent resource waste.
- IF (research explicitly requires UI/UX analysis, JS-rendering, or jumping login/CAPTCHA walls):
  - [SLOW PATH] MUST request a browser evidence branch through the Antigravity / Gemini adapter.
  - [LOAD SKILL] Before requesting browser evidence, you MUST read:
    `view_file .agents/skills/browser-testing/SKILL.md`

- **Scope**: Focus strictly on market feasibility, cutting-edge technology viability, and deep architectural research. If the Director just wants to chat, suggest using `/00_chat`.

## 2. Devil's Advocate Protocol

[INTENT GATE] Classify Director intent:
- IF (intent is pure information, data, or doc retrieval with NO hypothesis):
  - [STATE A - Pure Information Search] Challenge reliability and completeness. Output exactly three paragraphs:
    1. Source Bias: Check authority and conflicts of interest.
    2. Data Freshness: Flag info older than 18 months.
    3. Search Coverage Gap: List excluded topics or competitors.
- ELSE (intent is to explore a business idea, tech architecture, or scenario):
  - [STATE B - Deep Research & Scenario Analysis] Devil's Advocate mode. Identify at least THREE fatal risks. Each risk MUST include:
    - Risk Description: What could go wrong and why.
    - Failure Scenario: Concrete, realistic failure scene (actors, systems, timing).
    - Quantified Impact: Numeric estimate of impact (e.g., cost, latency, churn rate) or justified range.

## 3. Artifact Generation (Output Mandate)

- Generate a beautifully formatted Markdown Artifact.
- **Language**: STRICTLY **Traditional Chinese (繁體中文, zh-TW)**.
- **Minimum Length**: The body text (excluding headers and the closing lock string) MUST be **no fewer than 800 characters**.
- **Table-First Rule**: Any comparative data (features, costs, vendors, frameworks) MUST be presented in a Markdown table. Prose-only comparisons are forbidden.
- **Quantify-First Rule**: Any claim about market size, cost, performance, or scale MUST include a concrete number or a justified estimate range (e.g., "USD $2M–$5M ARR", "P99 latency < 200ms"). Vague adjectives (e.g., "very expensive", "quite fast") are forbidden.
- **Structure**:
  1. 【商業意圖解析】— State classification (State A or B) + intent summary. Minimum 2 paragraphs.
  2. 【2026 競品與技術趨勢】— Comparative table required. Minimum 3 entries. Minimum 2 paragraphs of analysis.
  3. 【魔鬼代言人：核心風險剖析】— Output as defined in Section 2 (State A: 3 paragraph analysis; State B: 3+ structured risk entries).
  4. 【架構師提案：三套高階解決方案】— Three distinct solution directions. Each solution must include: approach, key trade-offs, and estimated cost/effort tier (Low / Medium / High).
- **Halt**: Append this exact string at the bottom of the Artifact:
  `[系統鎖定] 探勘報告已產出。請總監在文件上留言裁決方案，或輸入 /blueprint 進入架構繪製階段。`

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | Permissions based on the security gate matrix。
