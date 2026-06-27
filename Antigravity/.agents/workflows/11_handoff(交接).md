---
description: "Use when: 交接、handoff、彙整目前對話成果、掃描記憶卡並產出下一個 AI 可接手的提示詞。DO NOT use when: 仍在實作或需要提交。"
required_skills: [memory-ops, programming-team-governance]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: handoff
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
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
## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 11 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Preserve current state, dirty files, blockers, unverified evidence, source references, decisions made, and the exact next workflow route.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and enter captain-led mode automatically. Build a Captain Team Board before planning, execution, validation, review, or completion. Report each applicable Team Station with applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Valid execution modes are direct, evidence branch, browser branch, CLI branch, MCP direct, isolated patch, blocked, or not-applicable. Evidence-oriented stations default to read-only team evidence; implementation specialists may only produce isolated patch packets when a governed isolated workspace exists; all-direct evidence boards are invalid. Role boundaries are exclusive: implementation cannot self-review and review cannot implement the same deliverable. The captain owns main-worktree writes, review state, memory/git/release actions, and acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [WORKFLOW: HANDOFF (交接)]


> [LOAD SKILL] 執行任何步驟前，必須依序讀取：
> 1. `view_file .agents/skills/memory-ops/SKILL.md`
> 2. `view_file .agents/skills/memory-arch/SKILL.md`

## 1. Memory Skill State Aggregation

- Use MCP tool `cartridge-system__memory_list` to get all project memory modules.
- If deep context is needed, use `cartridge-system__memory_read` on specific memories.
- **Project Skills Scan**: List all custom project skills in `.agents/project_skills/`. Extract their names and descriptions from the frontmatter.
- **Skill-Memory Cross-Reference**: For each memory card, collect its `Applicable Skills` entries to build a governance mapping for the handoff prompt.

## 2. Session Delta & Trap Extraction

- You MUST explicitly extract HIGH-RESOLUTION technical details from the current conversation:
  - **Granular Changes**: Specify exact file paths, functions, variables, and state mutations (e.g., "Added sessionToken cookie to auth.ts", NOT just "Fixed login").
  - **Traps & Dead Ends**: Identify any approaches attempted that FAILED (e.g., version conflicts, hydration errors). This prevents the next AI from repeating mistakes.
  - **Hacks & Tech Debt**: Note any `@ts-ignore`, hardcoded values, or lingering console errors left behind.
  - **Infrastructure Delta**: List any new npm packages installed, `.env` variables added, or database schema changes.
  - **WIP & Next Steps**: Identify the exact technical blockage or next immediate function to implement.

## 3. Memory Skill Update Enforcement

[HANDOFF PRE-GATE] Memory freshness verification:
- IF ([SUDO] detected in Director prompt): 
  - Skip check. Generate handoff with stale data. 
  - Warn exactly: 「[SUDO OVERRIDE] 記憶卡可能未更新。交接資訊完整性無法保證。」
- ELSE IF (ANY memory card has staleness > 0):
  - [HALT] Output exactly: 「🔴 [HANDOFF HALT] 記憶卡 {module_name} 過期 (staleness={N})。請先更新再交接。」
  - Do NOT generate the handoff prompt.
- ELSE: Proceed silently to generate handoff_prompt.md.

## 4. Handoff Prompt Generation

Generate a Markdown Artifact named `handoff_prompt.md` in **Traditional Chinese (繁體中文, zh-TW)** using the following EXACT structure:

```markdown
# 🔄 AI 交接提示詞

## 專案資訊
- 專案名稱：<project name>
- 記憶卡位置：.agents/memory/

## 📍 當前階段與總結
<1-2句話精準描述當前功能開發進度>

## ✅ 本次完成事項 (技術細節)
- [<module_name>]：<具體做了什麼，精確到變數、函數或狀態變更>
- [<module_name>]：...

## ⚠️ 防雷與死胡同記錄 (Traps & Dead Ends)
- ❌ 嘗試過的失敗路徑：<記錄行不通的解法、報錯或版本衝突，警告下一個 AI 避開>
- 🚨 遺留技術債 (Hacks)：<記錄寫死的值、@ts-ignore 或目前尚未解決的 Console Error>

## 📦 環境異動 (Infrastructure)
- 依賴變更：<新增了哪些 npm 套件，提醒總監可能需要 npm i>
- Schema/.env：<是否有資料庫結構或環境變數變更>

## 🔄 進行中的工作 (WIP) & 下一步優先事項
1. [<module_name>] 需要處理... <遺留的確切邏輯阻礙>
2. [<module_name>] 準備...

## 🎯 給下一個 AI 的指令
你正在接手一個使用 Antigravity 記憶技能系統的專案。開始工作前，請先執行以下步驟：
1. 查看 .agents/memory/ 中所有記憶卡，取得專案概覽和模組清單。
2. 查看每個技能的 status 和 staleness 了解最新進度。
3. 查看 .agents/project_skills/ 中的專案衍生技能，瞭解本專案特有的操作規範。
4. 針對上方「防雷與死胡同記錄」，絕對不要重複嘗試已經證實失敗的路徑。
5. 針對上方「環境異動」，如果需要，請主動提醒總監執行安裝指令。
```

## 5. Output Mandate

- **Halt**: Output the handoff prompt Artifact and display exactly:
  `[交接完成] 豐富化交接提示詞已產出。請總監複製 Artifact 內容，貼到下一個對話的開頭即可。`
- Remind the Director: `如需備份，可先執行 /09_commit_log 再關閉對話。`

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | Permissions based on the security gate matrix。
