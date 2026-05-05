---
name: 07_debug
description: 分析堆疊追蹤與日誌，將技術性故障翻譯為白話的商業影響說明
required_skills: [memory-ops, code-diagnosis]
memory_awareness: read
user-invocable: true
---

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

> [LOAD SKILL] Read `.claude/agents/skills/memory-ops/SKILL.md`.

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
