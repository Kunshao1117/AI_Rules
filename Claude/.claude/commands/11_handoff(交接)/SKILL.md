---
name: 11_handoff
description: "Use when: 交接、handoff、彙整目前對話成果、掃描記憶卡並產出下一個 AI 可接手的提示詞。DO NOT use when: 仍在實作或需要提交。"
required_skills: [memory-ops, programming-team-governance, team-task-package, team-role-boundaries, implementation-patch-delivery, memory-coupled-delivery, team-validation-packet, team-review-packet, team-completion-gate]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
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
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-package/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, `.claude/skills/implementation-patch-delivery/SKILL.md`, `.claude/skills/memory-coupled-delivery/SKILL.md`, `.claude/skills/team-validation-packet/SKILL.md`, `.claude/skills/team-review-packet/SKILL.md`, `.claude/skills/team-completion-gate/SKILL.md`. Treat this command as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [SKILL: /11_handoff — 交接提示詞]

## HANDOFF PRE-GATE（交接前置閘門）

```
[HANDOFF PRE-GATE]
├── [SUDO] 偵測到？
│   └── YES → 跳過閘門，產出交接提示詞並警告：「⚠️ 記憶卡可能尚未更新，請下一個 AI 主動觸發記憶同步。」
├── 任何記憶卡 staleness > 0？
│   └── YES → [HALT]「🔴 [HANDOFF HALT] 記憶卡 {module} 過期 (staleness={n})，請先執行記憶卡更新後再產出交接提示詞。」
└── 全部新鮮（staleness = 0）→ 繼續產出
```

## 1. Memory Scan (記憶全掃描)

> [LOAD SKILL] Read `.agents/skills/memory-ops/SKILL.md`.

- Call `cartridge-system__memory_list` 取得所有記憶卡清單與健康狀態。
- Load ALL memory cards. For each card, extract: module name, scope, Current Truth, Active Constraints, Cycle Events, Archive Index, 中文摘要, staleness, and compaction status.

## 2. Session Delta & Trap Extraction（對話成果 + 防雷萃取）

Summarize the current conversation with the following **technical precision requirements**:

- **已完成事項**：指定確切的檔案路徑、函式名稱、變數、狀態異動
- **防雷記錄**：嘗試過但失敗的路徑、版本衝突、hydration 錯誤、已知死胡同
- **技術債標記**：hardcoded 值、`@ts-ignore`、遺留 `console.error`、TODO 項目
- **環境異動**：新增 npm 套件、`.env` 變數、資料庫 schema 變更、MCP 工具變更
- **未解問題**：Outstanding issues 或 TODOs
- **總監偏好**：本次觀察到的工作風格與決策傾向

## 3. Handoff Prompt Generation (交接提示詞產出)

Generate a structured handoff prompt in Traditional Chinese:

```markdown
# 交接提示詞 — [專案名稱]

## 專案概況
[從 _system 記憶卡提取技術堆疊與架構摘要]

## 本次對話成果
[§2 的彙整結果，含確切檔案路徑與技術細節]

## 防雷清單
[嘗試過但失敗的路徑、已知問題、技術債]

## 環境異動紀錄
[新增套件 / .env 變數 / schema 變更]

## 記憶卡健康狀態
| 模組 | 過期指數 | 待處理事項 |
|---|---|---|
| ... | ... | ... |

## 待辦事項
[優先順序排列的 TODO 清單]

## 下一步建議
[建議下個對話應該執行的工作流]
```

Append:「[交接完成] 請將上方提示詞貼到下一個 AI 對話的第一則訊息。本提示詞適用於 Antigravity（Gemini IDE）與 Claude Edition（VS Code 擴充）。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: full — reads all cards for handoff, no writes.
 Formal team completion requires implementation patch, memory delivery, review, and validation packets; missing packets must be marked blocked, unverified, or accepted-risk.
- Formal team completion requires implementation patch, memory delivery, review, and validation packets; missing packets must be marked blocked, unverified, or accepted-risk.
- Formal team completion requires implementation patch, memory delivery, review, and validation packets; missing packets must be marked blocked, unverified, or accepted-risk.
- Formal team completion requires implementation patch, memory delivery, review, and validation packets; missing packets must be marked blocked, unverified, or accepted-risk.