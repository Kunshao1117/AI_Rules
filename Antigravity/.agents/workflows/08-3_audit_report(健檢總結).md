---
name: 08-3_audit_report(健檢總結)
description: "Use when: 健檢第三階段、彙整健康報告、紅黃綠燈號、優先修復清單與行動建議。DO NOT use when: 尚未完成前兩階段健檢。"
trigger: manual
required_skills:
  - performance-audit
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
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
# [08-3_audit_report] Traffic Light Health Report Generation

**[SECURITY & COMPLIANCE MANDATE]**
- Role: Master Agent
- Operating Constraint: Read-only aggregation.

## 1. Data Aggregation

**Directive**: Collect all audit states.
1. Read `.agents/cartridges/_system.md` and related memory cards.
2. Read `.agents/logs/scan_report.md` (CLI Static Scan).
3. Read `.agents/logs/audit_logic_results.md` (AI Deep Logic Scan from Phase 2).

## 2. Performance, UI & SEO Scan

**Directive**: Evaluate frontend performance, design compliance, and SEO structures.
1. IF the project is a frontend web application (e.g., React, Next.js, Vite):
   - `> [LOAD SKILL] performance-audit`.
   - Extract metrics from `.agents/logs/audit_perf.md` (if previously run by CLI) OR deduce standard Core Web Vitals optimizations needed based on code structure.
   - **[Design Token Compliance]**: Detect hardcoded magic numbers in CSS/Tailwind (e.g., `#3a4f5c`, `27px`) and mandate consolidation into the Design System tokens.
   - **[SEO & Assets Audit]**: Evaluate the presence of proper OpenGraph Meta Tags and identify unoptimized large static asset patterns.
2. IF the project is strictly backend:
   - Skip performance web UI checks and focus on API response time architectures.

## 3. Interface Layer (Output Mandate)

**[STRICT RULE]**: You MUST generate the final report EXACTLY matching the structure below in **Traditional Chinese**.

> ## 專案全光譜健康報告 (Traffic Light Health Report)
>
> **1. 系統記憶狀態 (Memory Topology)**
> - 🟢 狀態：[例如：完美對齊] / 🔴 狀態：[例如：發現 3 個孤兒檔案]
> - 描述：[從 08-1 擷取的結果]
>
> **2. 架構與邏輯缺陷 (Architecture & Code Logic)**
> - 🟢/🟡/🔴 狀態：
> - 描述：[從 audit_logic_results.md 擷取的 API 缺口、死碼等結果]
>
> **3. 安全性審查 (S1-S5 Security)**
> - 🟢/🟡/🔴 狀態：
> - 描述：[從 audit_logic_results.md 擷取的資安掃描結果]
>
> **4. 資料庫效能與程式韌性 (DB Perf & Resilience)**
> - 🟢/🟡/🔴 狀態：
> - 描述：[從 audit_logic_results.md 擷取的 N+1 查詢、錯誤吞噬、競態條件等深層邏輯結果]
>
> **5. 靜態指標與 UI/UX 規範 (Static, UI/UX & SEO)**
> - 🟢/🟡/🔴 狀態：
> - 描述：[CLI ESLint/TS 狀態、Lighthouse 效能、Magic Numbers 抓漏與 SEO 狀態]
> 
> ### 💡 總監行動建議 (Next Steps)
> 1. [最高優先級的修復建議]
> 2. [次要優化建議]
