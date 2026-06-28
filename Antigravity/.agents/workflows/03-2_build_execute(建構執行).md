---
description: "Use when: 已有 /03_build 設計到建構合約並取得 GO，要執行建構寫入、記憶歸卡與驗證測試。DO NOT use when: 尚未完成建構合約或未取得 GO。"
required_skills: [memory-ops, security-sre, code-quality, test-patterns, ai-dev-quality-gate, trunk-ops, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
memory_awareness: full
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
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

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use explore-plan-implement-verify sequencing. Define acceptance evidence, operator-tool discovery, retry strategy, and blocked validation rules before writes.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

# [WORKFLOW: BUILD — EXECUTE (建構執行)]


> **前置條件**: 本工作流須由 `/03_build(設計到建構合約)` 的 GO 授權後方可執行。

## 0. Precondition Check（前置條件確認）

[PRECONDITION GATE] Verify authorization before any disk write:
- IF (Not triggered by an explicit GO approval from /03_build):
  - [HALT] Output exactly: 「🔴 [AUTH HALT] 未收到建構計畫授權。請先執行 /03_build 並取得 GO 確認。」
- ELSE:
  - Load `implementation_plan.md` to identify [ARCHITECTURE], [REAL EXECUTION], [NEW], [MODIFY], [COMPLETENESS], [VALIDATION], and [MEMORY/DOCS] sections. Proceed to §1.

## 1. Change Delivery Artifact Dispatch And Integration（變更交付件派工與整合）

- 呼叫 `task_boundary` 切換至 `EXECUTION` 模式前，必須確認 正式 Captain Team Board 已標記 GO-write authorization、派工波次、前一波輸入、下一波啟動條件與正式證據資格。
- 任何主工作區寫入前，先依 `team-task-board` 建立或確認實作變更交付件路徑：有受治理隔離區時使用 isolated change delivery artifact；沒有隔離區時使用 text change delivery artifact。隊長不得以直接寫入替代變更交付件；缺少合格交付路徑時只能標示阻塞、未驗證或總監風險關閉但非完整（`closed-with-director-risk`），並記錄缺少隔離變更交付路徑的原因。
- 每個實作隊員只負責一個明確任務，只能產出變更交付件；不得擴張需求、審查自己的產出、更新記憶、stage、commit、push、release、deploy、install 或改動外部狀態。
- 隊長只整合已回收、已有記憶文件交付處置，且已有獨立審查交付件與驗證交付件的變更交付件；整合順序仍依賴者先於被依賴者（底層模組先整合，上層模組後整合）。

// turbo

## 2. New File Memory/Docs Delivery Integration（新建檔案記憶文件交付整合）

[MEM ARCHIVE GATE] For every [NEW] file in implementation_plan.md:
- Require a returned memory/docs delivery artifact that names the target memory card, tracked files, schema v2 sections, Traditional Chinese keywords, and any archive or split requirement.
- The captain integrates only that returned memory/docs delivery artifact; the captain must not author the memory attribution.
- HALT CHECK: If the memory/docs delivery artifact is missing or incomplete, [HALT] and output: 「🔴 [MEM HALT] 新建模組缺少合格記憶文件交付件。」 Do NOT proceed to §3.

## 3. Modified File Memory/Docs Delivery Integration（修改檔案記憶文件交付整合）

[MEM UPDATE GATE] For every [MODIFY] file in implementation_plan.md:
- Require a returned memory/docs delivery artifact that identifies the affected active memory main file, still-valid truth changes, cycle event text, archive impact, and sync requirement.
- The captain integrates only returned memory/docs delivery artifacts and must not create memory attribution directly.
- HALT CHECK: If the memory/docs delivery artifact is missing or incomplete, [HALT] and output: 「🔴 [MEM HALT] 修改檔案缺少合格記憶文件交付件。」 Do NOT proceed to §4.

## 4. Unit Test Generation（單元測試熔斷器）

> [LOAD SKILL] 執行測試前，必須讀取：
> `view_file .agents/skills/test-patterns/SKILL.md`

[TEST CIRCUIT BREAKER] After §1–§3 complete:
- Consult `test-patterns` skill §1 to decide if unit tests are required.
- IF (Unit tests NOT required): Proceed to §5 silently.
- IF (Unit tests required): Run tests.
  - IF (Tests FAIL): Trigger auto-repair loop (max 3 attempts).
  - IF (FAIL after 3 attempts): [HALT] Output exactly: 「🔴 [BUILD HALT] 單元測試修復失敗 (3/3)。請總監介入診斷。」
- IF (Tests PASS or auto-repaired): Chain to §5.

> ⚠️ 此正規工作流**嚴禁使用 [SUDO] 破窗**。品質不達標就是死鎖。

// turbo

## 5. Real Execution And Interface Verification（真實執行與介面驗證）

- 單元測試通過後，若本次變更影響真實資料、執行期狀態、持久化、外部整合、命令輸出、自動化、雲端服務或操作者可見行為，必須依 [REAL EXECUTION] 與 [VALIDATION] 收集真實執行證據。
- 若本次變更影響版面、元件、樣式、互動或操作者可見輸出，**必須自主觸發** `/06_test` 工作流，依 [VALIDATION] 的介面類型執行介面適配與真實功能證據驗證。
- 非 UI 的後端、CLI、資料庫、排程、外掛或雲端變更，必須執行對應的真實命令、請求、查詢、日誌、dry-run、preview、sandbox 或只讀狀態檢查。
- 執行驗證前必須重新確認可用操作者工具與入口；若計畫中的主要工具短暫失敗，先確認服務就緒、重試或改用等價真實路徑，不得因第一次失敗就捨棄該驗證方式。
- 若最後仍無法操作驗證，回報必須列出已搜尋的入口、嘗試的工具、重試次數或未重試理由、已評估的等價路徑與最小阻塞條件。
- 若只取得 mock、fixture、假資料、靜態截圖或局部單元測試證據，結果必須標記為驗證失敗或阻塞，不得結案。
- **禁止**要求總監手動執行可由代理完成的測試工作流；只有缺少外部授權、真實憑證、實體設備、不可安全執行的破壞性動作、第三方不可用、MFA/CAPTCHA、法規或安全限制時，才可回報阻塞。

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Captain/SRE` | 主工作區寫入僅限整合已回收變更交付件；實作隊員只產出隔離或文字變更交付件。
- **Memory Update**: MANDATORY — §2 與 §3 必須整合已回收記憶文件交付件；隊長不得自行產生記憶歸因。違反即 HALT。
 Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
