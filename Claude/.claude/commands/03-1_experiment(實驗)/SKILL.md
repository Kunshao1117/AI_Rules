---
name: 03-1_experiment
description: 沙盒快速實驗模式 — 所有品質、安全性、測試與記憶卡閘門停用。適用快速髒碼實驗與 API 原型測試。
required_skills: []
memory_awareness: none
user-invocable: true
---

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
