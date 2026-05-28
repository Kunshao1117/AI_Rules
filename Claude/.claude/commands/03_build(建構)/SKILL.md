---
name: 03_build
description: "Use when: 正式建構功能、實作已核准計畫、新增工具或產品行為變更。流程包含計畫、GO、寫入、記憶歸卡與驗證。DO NOT use when: 純討論或沙盒實驗。"
required_skills: [memory-ops, tech-stack-protocol, code-quality, security-sre, ai-dev-quality-gate, project-context-protocol]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: build
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
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.claude/skills/plugin-release-governance/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, or mobile/responsive behavior, read `.claude/skills/ai-dev-quality-gate/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.claude/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.
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

> [LOAD SKILL] Read `.claude/skills/memory-ops/SKILL.md` before proceeding.

- Check MEMORY.md index for cards relevant to target module.
- Load relevant `.claude/agents/memory/*/SKILL.md` — understand architecture, tracked files, decisions, known issues.
- Check `## Relations` for cross-module dependencies.
- Check `## Applicable Skills` for required operational skills.

### 2. Context Acquisition (情境讀取)

> [LOAD SKILL] Read `.claude/skills/code-quality/SKILL.md` and `.claude/skills/security-sre/SKILL.md`.

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

> [LOAD SKILL] Re-confirm `.claude/skills/memory-ops/SKILL.md` is loaded.

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
