---
name: "11-handoff-交接"
description: "Use when: 交接、handoff、彙整目前對話成果、掃描記憶卡並產出下一個 AI 可接手的提示詞。DO NOT use when: 仍在實作或需要提交。"
required_skills: [programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
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

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying workflow-specific language, output-layer, memory-language, handoff, or change-description rules, read .agents/shared/policies/language-governance.md; this workflow cites the center policy and does not use platform core files as the sole language source.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 11 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Preserve current state, dirty files, blockers, unverified evidence, source references, decisions made, and the exact next workflow route.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- Team-First routing applies before tool selection: use `formal-readonly` for handoff scan, state evidence, source/doc evidence, deep-read, review, validation, memory/docs, and counter-evidence stations; use GO-backed `formal-write` only if the handoff routes into a separately authorized write workflow. Workflow name is route only; it does not authorize writes or unbounded specialist launch.
- Any deferred station MUST be recorded as `standby` with trigger, scope, startup condition, and `standby_reason`; it MUST NOT produce evidence until its dispatch wave is open and a delivery artifact returns.
- Large-file or broad-corpus work uses specialist deep-read delivery with cited sections; the captain performs verify-read on the cited sections before relying on the summary and must not claim full-file ingestion from a summary alone.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, assigned skill refs, handoff packet ID, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, deep-read scope, captain verify-read scope, unread scope, startup deadline, standby reason, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal-readonly boards can run no-write evidence, deep-read, research, validation-planning, review-evidence, and standby stations; formal-write boards require scoped GO-backed authorization; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, performs protected integration of returned and qualified delivery artifacts within the authorized scope, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not treat GO as bulk main-worktree write permission and must not author primary implementation, review, validation, or memory attribution.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Natural-language approval must first bind to that current visible scope. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, validation delivery artifacts, or Team-Native trace are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.

- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# source-command-11-handoff-skill

Use this skill when the user asks to run the migrated source command `11_handoff(交接)-SKILL`.

## Command Template

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

## 下一步路由閘門
[下個對話必須先確認的工作流、阻塞條件與 GO 需求]
```

Append:「[交接完成] 請將上方提示詞貼到下一個 AI 對話的第一則訊息。本提示詞適用於 Antigravity（Gemini IDE）與 Codex Edition（VS Code 擴充）。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source file modifications.
- **Memory**: full — reads all cards for handoff, no writes.
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
