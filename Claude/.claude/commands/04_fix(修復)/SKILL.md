---
name: 04_fix
description: 兩階段修復工作流。第一階段：診斷缺陷、分析影響範圍，產出全繁中實作計畫供總監審閱（唯讀）。第二階段：實體修復、記憶更新、回歸測試。
required_skills: [memory-ops, impact-test-strategy]
memory_awareness: full
user-invocable: true
---

# [SKILL: /fix — 修復計畫與執行]

---

## STAGE 1 — PLAN (修復計畫)

### 0. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md` before proceeding.

- Check MEMORY.md index for cards relevant to the bug's module.
- Load relevant `.agents/memory/*/SKILL.md`. Check `## Known Issues` (bug may be documented) and `## Relations` for cascade impact.

### 1. Current State Constraint

- [CONSTRAINT] Use loaded memory cards' `## Tracked Files` to navigate to relevant files. Use `Read` tool.
- [FORBIDDEN] DO NOT guess file paths blindly.

### 1.5. Impact Analysis (影響分析)

> [LOAD SKILL] Read `.agents/skills/impact-test-strategy/SKILL.md`.

1. Map target file(s) to owning module(s) via memory cards.
2. Identify affected modules through `## Relations`.
3. Classify risk level (High / Medium / Low).
4. Include impact report in patch plan (§3).

### 2. Minimal Impact Principle (最小影響原則)

- Identify the exact root cause.
- [FORBIDDEN] STRICTLY FORBIDDEN from refactoring adjacent code or changing architecture. Modify ONLY the precise lines necessary to resolve the issue.

### 3. Patch Plan Generation (修復計畫產出)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track fix steps.
- Draft plan in chat with structure:
  1. 【故障根因白話文翻譯】
  2. 【影響分析】(Risk level + affected modules from §1.5)
  3. 【修改範圍】(Exact files to be touched)
  4. 【實作邏輯對照】(Before / After diff)
  5. 【連帶影響評估】

### 4. Halt & Eject

- [HALT] STAGE 1 has NO permission to write source files. `ExitPlanMode` is NOT called here.
- Output:「[修復計畫擬定] 請總監審閱上方計畫。確認修復方向無誤後，請輸入 GO 授權進入實體覆寫程序。」
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (修復執行)

> Begins only after Director inputs GO.

### 5. Exit Plan Mode & Fix

- Call `ExitPlanMode`. Apply fixes using `Write`/`Edit` tools.
- Strictly limited to the files listed in `【修改範圍】`. No scope creep.
- Apply `[SEC SILENT GATE]` before each write.

### 6. Regression Test (回歸測試)

> [LOAD SKILL] Re-confirm `.agents/skills/impact-test-strategy/SKILL.md` is loaded.

- Run tests scoped to affected modules via `Bash` tool. Apply `[LINTER GATE]`.
- Verify the original bug is resolved AND no regression introduced.

### 7. Memory Update (記憶更新)

> [LOAD SKILL] Re-confirm `.agents/skills/memory-ops/SKILL.md` is loaded.

- Update `.agents/memory/` cards for all modified files: record fix in `## Key Decisions`, remove resolved item from `## Known Issues`.
- Apply `[EXIT HOLD GATE]` before reporting completion.
- Report completion in Traditional Chinese with business-level summary.

---

## [SECURITY & COMPLIANCE]
- **Stage 1 Role**: Reader — no disk writes.
- **Stage 2 Role**: Writer/SRE — Write/Edit on exact files listed in plan only.
- **Memory**: full — modified files MUST have memory card updates.
