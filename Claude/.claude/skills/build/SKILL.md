---
description: 兩階段建構工作流。第一階段：載入記憶、生成實作計畫、等待總監核准 GO。第二階段：實體寫入、記憶歸卡、驗證測試。
required_skills: [memory-ops, tech-stack-protocol, code-quality, security-sre]
memory_awareness: full
invocation: user
---

# [SKILL: /build — 建構計畫與執行]

## 0. Execution Mode Check (執行模式識別)

[MODE GATE] Classify execution context:
- IF (Director used keyword "實驗" / "沙盒" / "快速原型"):
  - [SANDBOX MODE] Use `Write`/`Edit` immediately. Skip §1–§4.
  - No linters, tests, or memory updates.
  - Report with mandatory warning:「⚠️ 實驗模式產出，不具生產級品質。若需正式納入，請重新執行 /build。」
- ELSE:
  - [PRODUCTION MODE] Continue to §1.

---

## STAGE 1 — PLAN (建構計畫)

### 1. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.claude/agents/skills/memory-ops/SKILL.md` before proceeding.

- Check MEMORY.md index for cards relevant to target module.
- Load relevant `.claude/agents/memory/*/SKILL.md` — understand architecture, tracked files, decisions, known issues.
- Check `## Relations` for cross-module dependencies.
- Check `## Applicable Skills` for required operational skills.

### 2. Context Acquisition (情境讀取)

> [LOAD SKILL] Read `.claude/agents/skills/code-quality/SKILL.md` and `.claude/agents/skills/security-sre/SKILL.md`.

- Read relevant source files using `Read` tool (from memory card's Tracked Files).
- Check tech stack version via `package.json` or equivalent. Use `WebSearch` to ground framework docs.
- Follow the blueprint or Director's specification strictly.

### 3. Planning Mode (規劃階段)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track implementation steps.
- Draft implementation plan in chat. DO NOT use `Write`/`Edit` on source files.
- Plan MUST include:
  - **[MODIFY]**: Files to be modified
  - **[NEW]**: New files to be created (required for memory archiving)
  - **[DELETE]**: Files to be deleted
  - Code diff previews for each change

### 4. Review Gate (審查閘門)

- Present plan to Director. Output:
  > `[最高授權閘門] 實體建構計畫已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
- **HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (建構執行)

> Begins only after Director inputs GO.

### 5. Exit Plan Mode & Execute

- Call `ExitPlanMode`. Begin writing source code using `Write`/`Edit` tools.
- Apply `[SEC SILENT GATE]` before each file write (see `code-quality` rule).
- Mark each `TodoWrite` item `completed` as you finish it.

### 6. Memory Archive (記憶歸卡)

> [LOAD SKILL] Re-confirm `.claude/agents/skills/memory-ops/SKILL.md` is loaded.

- **[NEW] files**: Find or create matching `.claude/agents/memory/` card. Record file under `## Tracked Files`.
- **[MODIFY] files**: Update corresponding memory card's `## Key Decisions` and `## Known Issues`.
- Apply `[EXIT HOLD GATE]` before reporting completion.

### 7. Validation (驗證)

- Run linter/tests via `Bash` tool. Apply `[LINTER GATE]` (max 3 retries).
- If tests pass: Report completion in Traditional Chinese with business-level summary.
- If tests fail after 3 retries: Apply `[CIRCUIT BREAK]`. HALT and notify Director.

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — full Write/Edit permissions on source code.
- **Memory**: full — all created/modified files MUST have memory card updates.
