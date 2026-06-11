---
name: 03_build
description: "Use when: 正式建構功能、設計到建構合約、實作已核准計畫、新增工具或產品行為變更。流程包含架構判斷、建構計畫、GO、寫入、記憶歸卡與驗證。DO NOT use when: 純討論、沙盒實驗、或只需要不落地的純架構方案。"
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
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or mobile/responsive behavior, read `.claude/skills/ai-dev-quality-gate/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.claude/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.
# [SKILL: /build — 設計到建構合約與執行]

## 0. Execution Mode Check (執行模式識別)

[MODE GATE] Classify execution context:
- IF (Director used keyword "實驗" / "沙盒" / "快速原型"):
  - [SANDBOX MODE] Use `Write`/`Edit` immediately. Skip §1–§4.
  - No linters, tests, or memory updates.
  - Report with mandatory warning:「⚠️ 實驗模式產出，不具生產級品質。若需正式納入，請重新執行 /build。」
- ELSE:
  - [PRODUCTION MODE] Continue to §1.

---

## STAGE 1 — DESIGN-TO-BUILD CONTRACT (設計到建構合約)

### 1. Memory Recall (記憶載入)

> [LOAD SKILL] Read `.claude/skills/memory-ops/SKILL.md` before proceeding.

- Check MEMORY.md index for cards relevant to target module.
- Load relevant `.agents/memory/*/SKILL.md` — understand Current Truth, Active Constraints, Cycle Events, archive pointers, tracked files, and relations.
- Check `## Relations` for cross-module dependencies.
- Check `## Applicable Skills` for required operational skills.

### 2. Context And Architecture Acquisition (情境與架構讀取)

> [LOAD SKILL] Read `.claude/skills/code-quality/SKILL.md` and `.claude/skills/security-sre/SKILL.md`.

- Read relevant source files using `Read` tool (from memory card's Tracked Files).
- Check tech stack version via `package.json` or equivalent. Use `WebSearch` to ground framework docs.
- If a blueprint already exists in the same conversation, reuse it directly instead of re-planning from scratch.
- If no blueprint exists, include architecture decisions inside this build plan: functional boundaries, affected modules, public interfaces, rejected alternatives, and validation impact.
- Use `/02_blueprint` only when the Director asks for pure architecture, full-system initialization, major technology pivot, or architecture-only output with no implementation.
- If the feature touches real data, runtime state, persistence, external integrations, command output, automation, cloud services, or operator-visible behavior, plan the real verification path through `ai-dev-quality-gate` Real Execution Evidence Gate.
- Real verification planning must include operator-tool discovery: available start commands, browser routes, desktop control path, CLI/TUI, plugin host, API, database, logs, dry-run, preview, or sandbox. Temporary unavailability requires retry planning or an equivalent real-path alternative.

### 3. Planning Mode (規劃階段)

- **Enter Plan Mode** (`EnterPlanMode`). Use `TodoWrite` to track implementation steps.
- Draft one design-to-build contract in chat. DO NOT use `Write`/`Edit` on source files.
- Plan MUST include:
  - **[GOVERNANCE DEPTH / 治理深度判定]**: Task level, matched escalation factors, exemption reason, and validation evidence. Output only the summary; do not duplicate the full autonomy matrix from `ai-dev-quality-gate`.
  - **[ARCHITECTURE]**: Functional boundary, affected modules, public interface changes, and rejected alternatives.
  - **[REAL EXECUTION]**: Real operation surface, operator-tool discovery result, data source, executable validation path, transient retry strategy, equivalent real-path alternative, expected evidence level, possible blockers, and smallest authorization needed.
  - **[MODIFY]**: Files to be modified
  - **[NEW]**: New files to be created (required for memory archiving)
  - **[DELETE]**: Files to be deleted
  - **[COMPLETENESS]**: User flow, loading/empty/error/permission/offline states when relevant.
  - **[VALIDATION]**: Unit, integration, regression, real execution evidence, and interface adaptation evidence required for completion. Mock, fixture, fake, static screenshot, or synthetic data evidence is partial evidence only.
  - **[MEMORY/DOCS]**: Memory cards, project context, README, changelog, or release notes affected by the change.
  - Code diff previews for each change

### 4. Review Gate (審查閘門)

- Present plan to Director. Output:
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
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

- **[NEW] files**: Find or create matching `.agents/memory/` card. Record file under `## Tracked Files`.
- **[MODIFY] files**: Update the corresponding memory card's `## Current Truth` only for still-valid facts, add one short English item to `## Cycle Events`, and stop for compaction if the card is already due.
- Apply `[EXIT HOLD GATE]` before reporting completion.

### 7. Validation (驗證)

- Run linter/tests via `Bash` tool. Apply `[LINTER GATE]` (max 3 retries).
- If behavior depends on real data, runtime state, persistence, external integration, command output, automation, cloud service, or operator-visible output, collect real execution evidence from the planned operation surface before reporting completion.
- Before declaring the planned operation surface unavailable, re-check available operator tools and entries. Transient server, browser, desktop-control, tool connection, timeout, or readiness failures require retry or an equivalent real-path alternative.
- If operation evidence remains blocked, report searched entries, attempted tools, retry count or unsafe-retry reason, equivalent alternatives considered, and the smallest missing condition.
- If only mock, fixture, static screenshot, or unit evidence is available for behavior-dependent work, report validation as failed or blocked instead of complete.
- If tests and required real execution evidence pass: Report completion in Traditional Chinese with business-level summary.
- If tests fail after 3 retries: Apply `[CIRCUIT BREAK]`. HALT and notify Director.

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — full Write/Edit permissions on source code.
- **Memory**: full — all created/modified files MUST have memory card updates.
