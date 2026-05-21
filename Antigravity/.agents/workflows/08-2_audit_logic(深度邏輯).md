---
name: 08-2_audit_logic(深度邏輯)
description: "Use when: 健檢第二階段、深度邏輯審查、安全架構、API 串接比對、測試覆蓋缺口與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08_audit。"
trigger: manual
required_skills:
  - delegation-strategy
  - code-audit
  - audit-engine
  - security-sre
  - impact-test-strategy
  - test-patterns
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write:logs", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [08-2_audit_logic] Deep Source Code & Architecture Audit

**[SECURITY & COMPLIANCE MANDATE]**
- Role: Master Agent
- Operating Constraint: READ-ONLY analysis for source files and memory cards. CLI evidence branches return evidence only and must not write project files.
- State Passing: The Master workflow is the only actor permitted to write `.agents/logs/audit_logic_results.md` as an intermediary Phase 3 report.

## 1. CLI Evidence Branch Tool Scan

**Directive**: Use the Delegation Gate to request a read-only CLI evidence branch for static code scanning. The branch returns an evidence packet; it does not write the intermediary audit log.
1. Formulate the scan request.
2. Output the exact Traditional Chinese delegation string for the Director to execute:
   `@[CLI] 請讀取 .agents/skills/delegation-strategy/SKILL.md 與 .agents/skills/code-audit/SKILL.md，並以唯讀 CLI evidence branch 執行掃描。請回報 ESLint 警告、TypeScript 型別錯誤與 npm audit 狀態。`
3. **[HALT]** Wait for the Director to run the CLI and confirm completion. DO NOT proceed to Step 2 until the CLI report is ready.

## 2. Scan Report Parsing

**Directive**: Read the static analysis results.
1. Read `.agents/logs/scan_report.md` or `.agents/logs/audit_security_scan.md`.
2. Extract critical TypeScript/ESLint errors and CVE alerts.
3. `> [LOAD SKILL] trunk-ops` (JIT Load). Scan for Flaky Tests or Trunk CI errors if applicable.

## 3. AI Cross-Boundary Analysis (Semantic Reasoning)

**Directive**: Perform deep architectural and code-level checks. This is the core of the AI audit.

- **B (Module Relationship)**: Analyze the dependency graph. Detect Circular Dependencies between core modules.
- **C (API Integration Check)**: `> [LOAD SKILL] audit-engine` (Execute §2). Compare Frontend fetch/axios calls against Backend Routes (Next.js/Express) to ensure parameter and schema alignment.
- **E (Dead Code Detection)**: Identify orphaned functions, unused exports, and unreachable logic.
- **F (Key Function Survival)**: Verify that critical system pathways (e.g., Auth, Payments, Core Features) are intact and not bypassed.
- **G (Skill Quality Scan)**: Optionally execute `.agents/skills/skill-factory/scripts/Measure-SkillQuality.ps1` if checking derivative skills.
- **J (Data Layer Consistency)**: Ensure Database Schema models precisely match the expected API Response interfaces.
- **K (Test Coverage Gap Analysis)**: `> [LOAD SKILL] impact-test-strategy`. Identify high-risk modules completely lacking unit/integration tests.
- **H (Accessibility Audit)**: `> [LOAD SKILL] a11y-testing` (JIT Load). Evaluate frontend UI components for semantic HTML and WCAG compliance.
- **S (Security Architecture Review)**: `> [LOAD SKILL] security-sre`. Execute the S1-S5 checks:
  - S1: Hardcoded Secrets.
  - S2: Authorization Bypasses (RLS/Middleware).
  - S3: Input Sanitization (SQLi/XSS).
  - S4: Credential Isolation.
  - S5: Rate Limiting & DoS vectors.
- **P (DB Performance & N+1)**: Scan loop-driven logic for hidden ORM/SQL calls causing N+1 query bottlenecks. Identify missing index vectors on high-frequency query fields.
- **R (Error Swallowing & Resilience)**: Detect anti-patterns such as `try...catch` blocks that swallow errors without throwing or logging to external services (e.g., Sentry). Check for missing Transaction rollbacks in critical DB mutations.
- **C2 (Concurrency & Race Conditions)**: Scan async state updates, financial/inventory mutations, and concurrent DB writes for missing Row-Level Locks (Optimistic/Pessimistic) or Atomic operations.
- **L (State & Data Flow)**: Detect React/Vue state anomalies (e.g., Stale Closures in Hooks, unsafe global state mutations, excessive prop drilling).
- **T (Type Safety Strictness)**: Detect misuse of `any` or brute-force Type Assertions (`as Type`). Ensure all external API boundaries employ rigorous unknown parsing (e.g., Zod validation).

## 4. State Passing (Mandatory Logging)

**Directive**: You MUST compile ALL findings from Section 2 and Section 3 and write them to the intermediary log file.
1. Target File: `.agents/logs/audit_logic_results.md`
2. Structure: Markdown format with clear sections for `API Gaps`, `Security S1-S5`, `Dead Code`, and `A11Y Issues`.
3. Master workflow action: Use native file write only for `.agents/logs/audit_logic_results.md`. DO NOT delegate this write to an evidence branch. DO NOT modify source files, configuration files, dependency files, or memory cards.

## 5. Interface Layer (Output Mandate)

**[STRICT RULE]**: Output the following summary in **Traditional Chinese**.

> ### 🟢 深度邏輯與安全審查已完成
> 
> **狀態摘要**：
> - 跨邊界掃描完成。
> - 邏輯缺陷與資安漏洞已寫入中繼日誌 (`.agents/logs/audit_logic_results.md`)。
> 
> 請總監接續輸入 `@[/08-3_audit_report]` 產出最終全光譜健康報告。
