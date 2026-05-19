---
name: 07_debug
description: "Use when: 除錯、分析 stack trace、閱讀日誌、定位錯誤來源並說明商業影響。DO NOT use when: 已決定要修改原始碼，改用修復工作流。"
required_skills: [memory-ops, code-diagnosis]
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: debug
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /07_debug — 除錯分析]

## 1. Input Collection (輸入收集)

[INPUT GATE] Classify input type:
- IF (Director pastes error/stack trace):
  - Parse stack trace. Extract: error type, file path, line number, call chain.
- IF (Director describes symptom verbally):
  - Ask clarifying questions to narrow scope.
- IF (IDE provides error context):
  - Use provided file and cursor position as starting point.

## 2. Memory-Guided Navigation (記憶導航)

> [LOAD SKILL] Read `.claude/skills/memory-ops/SKILL.md`.

- Check MEMORY.md index for module owning the error file.
- Load relevant memory card to understand architecture and known issues.
- Check `## Known Issues` — the bug may already be documented.

## 3. Diagnosis (診斷)

- Use `Read` tool to examine relevant source files.
- Trace the call chain from stack trace to root cause.
- For complex cross-module issues:
  - Use `Agent(subagent_type="general-purpose")` to parallelize file reading if needed.

## 4. Business Translation (商業語言翻譯)

Generate diagnostic report in Traditional Chinese:
1. 【故障白話文翻譯】— What happened in non-technical terms
2. 【技術根因】— Root cause with code references
3. 【影響範圍】— Which features/users are affected
4. 【建議修復方向】— Approach options with effort estimates
5. 【已知相關問題】— Cross-reference with memory card `## Known Issues`

Append:「[除錯完成] 如需修復，請執行 /04_fix。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: read — check known issues, no card writes.
