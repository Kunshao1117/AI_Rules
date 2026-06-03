---
description: "Use when: 除錯、分析 stack trace、閱讀日誌、定位錯誤來源並說明商業影響。DO NOT use when: 已決定要修改原始碼，改用修復工作流。"
required_skills: [memory-ops, delegation-strategy, code-diagnosis]
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: debug
  role: analyst
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "none"
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
# [WORKFLOW: DEBUG (除錯)]


## 0. Memory Recall (記憶載入)

> [LOAD SKILL] 讀取記憶前，必須參考操作指引：
> `view_file .agents/skills/memory-ops/SKILL.md`

- Check the IDE-injected skill list for memory cards relevant to the failing module.
- Load relevant memory card SKILL.md files — check `## Current Truth`, `## Active Constraints`, and `## Cycle Events` to determine if this behavior or prior fix event is documented.

## 1. Hardened Evidence Collection

- **Absolute Ban**: DO NOT invent or assume bug causes.
- You MUST actively use terminal tools (`cat`, `tail`, or read terminal IDs) to extract logs from the target process, browser console inputs, or the `/logs` directory based on the Director's description.

## 1.5 CLI Code Diagnosis (CLI 程式碼診斷 — 可選步驟)

> **Trigger**: Evaluate the `code-diagnosis` skill §1 trigger conditions. If ANY condition is met, execute this step. Otherwise, skip to §2.

When triggered:

> [LOAD SKILL] 啟動 CLI 診斷時才讀取：
> 1. `view_file .agents/skills/delegation-strategy/SKILL.md`
> 2. `view_file .agents/skills/code-diagnosis/SKILL.md`

1. Execute the CLI branch following `delegation-strategy` SOP.
2. Construct prompt using `code-diagnosis` template.
3. Construct the diagnosis prompt:
   - **fault_symptoms**: Summarize the evidence collected in §1 (stack traces, error messages, Director's description)
   - **suspect_modules**: List the memory modules most likely related to the fault
4. Execute the CLI branch following `delegation-strategy` CLI role boundary.
5. Inform the Director: 「CLI 證據分支診斷已啟動。完成後請通知我繼續。」
6. **Wait** for the Director to confirm CLI has finished
7. Read the diagnosis report: `view_file` on `{agents_dir}/logs/diagnosis_report.md`
8. Follow `code-diagnosis` §4 review guide to validate CLI's findings
9. Incorporate validated findings into §2 Root Cause Translation

## 2. Root Cause Translation

- Generate a Root Cause Analysis (RCA) Artifact in **Traditional Chinese (繁體中文)**.
- **Structure**:
  1. 【故障症狀】(What is broken physically)
  2. 【日誌實證】(Exact excerpt of the error trace found)
  3. 【CLI 診斷摘要】(Summary of CLI diagnosis findings, if §1.5 was executed — omit if not)
  4. 【根因白話文解析】(Why it broke, translated into plain business logic)
  5. 【概念修復方案】(Proposed architectural fix)
  6. 【技能萃取建議】(If the debugging methodology developed in this session is reusable across future incidents, recommend creating a project skill via `/12_skill_forge` — 若本次歸納出可重用的診斷方法論，建議萃取為專案衍生技能)
- **Halt**: Output: `[防線鎖定] 數位鑑識完畢。若總監同意修復方向，請輸入 /fix 啟動修復程序。`

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | Permissions based on the security gate matrix。
