---
name: "04-fix-修復"
description: "Use when: 修 bug、修復回歸、排除錯誤、診斷缺陷並執行正式修復。流程包含診斷、GO、寫入、記憶更新與回歸測試。DO NOT use when: 新功能建構或純除錯說明。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: fix
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "terminal:test", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
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

> [LOAD SKILL] If this fix touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before diagnosing release impact.
# source-command-04-fix-skill

Use this skill when the user asks to run the migrated source command `04_fix(修復)-SKILL`.

## Command Template

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
- Repair plans MUST use the Director-readable formal format. For formal plans, use the compact table before technical details:

  | 事項 | 位置 | 影響 | 狀態 |
  |---|---|---|---|

- Technical details, root-cause mapping, before/after diffs, and exact file lists may only appear after `補充技術細節`.
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
