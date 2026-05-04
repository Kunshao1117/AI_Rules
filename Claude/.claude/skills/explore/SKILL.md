---
description: 由總監觸發，探索新商業想法或技術方向。執行網路研究、扮演魔鬼代言人，產出可行性報告 Artifact。禁止撰寫可執行原始碼。
required_skills: []
memory_awareness: none
invocation: user
---

# [SKILL: /explore — 可行性探索]

## 1. Execution Constraint

- **Absolute Ban**: DO NOT write, modify, or propose any executable source code during this workflow.

[RECON GATE] Select research path:
- IF (research requires only text/data retrieval):
  - [FAST PATH] Use `WebSearch` + `WebFetch` tools directly.
- IF (research requires UI/UX analysis or JS-rendered pages):
  - [SLOW PATH] Delegate to `Agent(subagent_type="general-purpose")` with browser access.

## 2. Devil's Advocate Protocol (魔鬼代言人協議)

[INTENT GATE] Classify Director intent:
- IF (intent is pure information/doc retrieval with NO hypothesis):
  - [STATE A — Pure Information Search] Challenge reliability. Output exactly three paragraphs:
    1. **Source Bias**: Authority and conflicts of interest.
    2. **Data Freshness**: Flag info older than 18 months.
    3. **Search Coverage Gap**: List excluded topics or competitors.
- ELSE (intent is to explore a business idea or tech architecture):
  - [STATE B — Deep Research] Devil's Advocate mode. Identify at least THREE fatal risks. Each risk MUST include:
    - **Risk Description**: What could go wrong and why.
    - **Failure Scenario**: Concrete, realistic failure scene.
    - **Quantified Impact**: Numeric estimate (e.g., cost, latency, churn rate) or justified range.

## 3. Artifact Generation (輸出規範)

Generate a Markdown report in Traditional Chinese with structure:
1. 【商業意圖解析】— State classification (A or B) + intent summary. Min 2 paragraphs.
2. 【2026 競品與技術趨勢】— Comparative table required (min 3 entries). Min 2 paragraphs of analysis.
3. 【魔鬼代言人：核心風險剖析】— Per §2 protocol.
4. 【架構師提案：三套高階解決方案】— Three distinct solution directions. Each: approach + key trade-offs + effort tier (Low/Medium/High).

**Rules**:
- **Quantify-First**: Any market size, cost, performance claim MUST include a concrete number or justified range. Vague adjectives ("very expensive") are FORBIDDEN.
- **Table-First**: Any comparative data MUST be in a Markdown table. Prose-only comparisons are FORBIDDEN.
- **Minimum Length**: Body text ≥ 800 characters (excluding headers).

Append at end:
`[系統鎖定] 探勘報告已產出。請總監在文件上留言裁決方案，或執行 /build 進入建構階段。`

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no disk writes, no source code generation.
- **Memory**: none — this workflow does not interact with memory cards.
