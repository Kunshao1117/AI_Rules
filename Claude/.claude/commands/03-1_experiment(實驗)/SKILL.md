---
name: 03-1_experiment
description: "Use when: 沙盒快速實驗、髒碼原型、API spike、創意探索，允許跳過正式品質與記憶閘門。DO NOT use when: 生產建構、正式修復或需提交發布。"
required_skills: []
memory_awareness: none
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: experiment
  role: writer
  memory_awareness: none
  tool_scope: ["filesystem:write", "terminal:manual"]
  human_gate: "Director invocation required"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /03-1_experiment — 沙盒實驗]

## 0. Sandbox Declaration (沙盒宣告)

[SANDBOX MODE ACTIVE] All quality, security, test, and memory gates are DISABLED.

- Dirty code, hardcoded values, and placeholder logic are PERMITTED.
- No linter runs, no test generation, no memory card updates.
- `Write`/`Edit` tools may be used IMMEDIATELY without planning phase.

## 1. Execution (直接執行)

- Read Director's request. Begin coding immediately.
- Use `Bash` tool for quick test runs if needed.
- No `EnterPlanMode` required. No review gate.

## 2. Completion (完成)

- Report results with mandatory warning:
  > `⚠️ 實驗模式產出，不具生產級品質。若需正式納入基準，請執行 /03_build 重新建構。`

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — full permissions, all gates bypassed.
- **Memory**: none — sandbox output is not tracked.
