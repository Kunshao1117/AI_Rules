---
description: "Use when: 正式建構功能、設計到建構合約、實作已核准計畫、新增工具或產品行為變更、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 的建構與驗證。DO NOT use when: 純討論、沙盒實驗、或只需要不落地的純架構方案。"
required_skills: [memory-ops, tech-stack-protocol, ai-dev-quality-gate, intent-alignment-gate, quality-review-governance, project-context-protocol, programming-team-governance]
memory_awareness: read
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: build
  role: planner
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read"]
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

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, real data, runtime behavior, operator-visible output, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before planning changes.
> [LOAD SKILL] Before producing a design-to-build contract, read `.agents/skills/intent-alignment-gate/SKILL.md` and apply requirement playback, neutral challenge, requirement-to-task trace, acceptance matrix, and drift audit rules.
> [LOAD SKILL] If this task touches governance, public contracts, shared workflows, release/plugin behavior, security, cross-module logic, repeated fragile code, or competing simple/complex designs, read `.agents/skills/quality-review-governance/SKILL.md` and report review purpose, review state, evidence status, accepted risk, and blockers.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.
## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 03 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Use explore-plan-implement-verify sequencing. Define blueprint adoption status, review purpose/state when required, requirement-to-task trace, acceptance evidence, operator-tool discovery, retry strategy, blocked validation rules, and drift audit rules before writes.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md` and `.agents/skills/team-task-package/SKILL.md`. Treat this workflow as a route hint, then build the Programming Team Board before specialist, browser, CLI, MCP, isolated patch, text patch, validation, review, or completion work. The board records task type, workflow route, implementation authorization, allowed/forbidden specialist roles, Team Station applicability, execution mode, evidence owner, role boundary, direct exception, and completion condition. Enforce no self-review, isolated/text patch packets, and all-direct fake-team guard; the captain keeps main-worktree integration, memory/git/release gates, review-state decision, and final acceptance.
- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

# [WORKFLOW: BUILD — PLAN (建構計畫)]


## 0. Execution Identity（角色識別 — 必讀）

[MODE GATE] Classify execution context before proceeding:
- IF (Director explicitly invoked /03-1_experiment or used keyword "實驗"/"沙盒"):
  - [SANDBOX MODE] Write code IMMEDIATELY to disk. Skip §1–§4.
  - Do NOT run linters, tests, or security scans. Do NOT update memory cards.
  - Dirty code, hardcoded values, and placeholder logic are PERMITTED.
  - Report completion with mandatory warning:
    「⚠️ 實驗模式產出，不具生產級品質。若需正式納入基準，請退回 /03_build 重新建構。」
- ELSE:
  - [PRODUCTION MODE] Continue to §1.

> [LOAD SKILL] §1 執行前，必須讀取：
> `view_file .agents/skills/memory-ops/SKILL.md`

## 1. Memory Recall（記憶載入）

- 從 IDE 注入的技能清單中，找出與目標模組相關的記憶卡。
- 載入相關作用中記憶主檔，了解模組架構、追蹤檔案、決策記錄、已知問題。
- 查看 `## Relations` 段落，確認可能被此次建構影響的跨模組依賴關係。
- 查看 `## Applicable Skills` 段落，確認應載入的操作技能已啟動。

## 2. Context & Architecture Acquisition（情境與架構讀取）

- 使用已載入的記憶技能，理解模組架構與當前狀態。
- 若同一對話已有藍圖，直接沿用，不得重新規劃到遺失上下文。
- 若沒有藍圖，將架構決策納入本次建構計畫：功能邊界、受影響模組、公開介面、不採用方案與驗證影響。
- `/02_blueprint` 僅用於純架構、全系統初始化、重大技術轉向或不立即實作的輸出。
- 根據 Glob 模式，自動套用 `.agents/rules/` 中所有適用的規範。
- 若功能涉及真實資料、執行期狀態、持久化、外部整合、命令輸出、自動化、雲端服務或操作者可見行為，必須依 `ai-dev-quality-gate` 的 Real Execution Evidence Gate 規劃真實驗證路徑。
- 真實驗證規劃必須包含操作者工具搜尋：可用啟動指令、瀏覽器路徑、桌面操作路徑、CLI/TUI、外掛宿主、API、資料庫、日誌、dry-run、preview 或 sandbox；短暫不可用時需規劃重試或等價真實路徑。

> [LOAD SKILL] §3 產出計畫並涉及程式碼時，必須讀取：
> 1. `view_file .agents/skills/code-quality/SKILL.md`
> 2. `view_file .agents/skills/security-sre/SKILL.md`

## 3. Design-to-Build Contract & Diff Generation（設計到建構合約與差異生成）

- **必須**呼叫 `task_boundary` 進入 `PLANNING` 模式。
- 將所有新程式碼或修改寫入**隔離的沙盒記憶體**。
- **嚴禁**在此階段寫入物理檔案系統。
- 產出詳細的 `implementation_plan.md` Artifact，附上程式碼 `diff`，並明確標記：
  - **[GOVERNANCE DEPTH / 治理深度判定]**：任務等級、命中升級因子、豁免理由、驗證證據；只輸出摘要，不重貼 `ai-dev-quality-gate` 的完整自治矩陣
  - **[CHANGE INTENT / 變更意圖分類]**：將工作分類為緊急修補、根因修復、局部修整或結構重構；包含補丁堆疊風險、允許範圍、升級條件，以及為何可以或不可用更窄補丁處理
  - **[INTENT ALIGNMENT / 需求對齊]**：需求理解回放、中立反證檢查、沿用藍圖狀態、需求到任務追蹤表、任務驗收矩陣，以及帶證據狀態的假設
  - **[REVIEW STATE / 審查狀態]**：若 `quality-review-governance` 適用，列出審查目的、生命週期狀態、證據狀態、發現處置、accepted-risk、阻塞條件與最小足夠複雜度判斷
  - **[ARCHITECTURE]**：功能邊界、受影響模組、公開介面變更、不採用方案
  - **[REAL EXECUTION]**：真實操作面、操作者工具搜尋結果、資料來源、可執行驗證路徑、短暫失敗重試策略、等價真實替代路徑、預期證據等級、可能阻塞條件與最小授權需求
  - **[MODIFY]**：修改的現有檔案
  - **[NEW]**：本次建構將新建的原始碼檔案（後續歸卡流程依賴此清單）
  - **[DELETE]**：將被刪除的檔案
  - **[COMPLETENESS]**：使用者流程、載入、空狀態、錯誤、權限、離線狀態
  - **[VALIDATION]**：單元、整合、回歸、真實執行證據與介面適配證據；假資料、示意資料、靜態截圖或 mock 僅能列為局部證據，不得作為完成依據；視覺驗證必須包含細微觀察並優先使用真實資訊，假資料備援必須標記原因、殘留風險與不可宣稱的完成範圍
  - **[DRIFT AUDIT / 偏移稽核]**：完成前必須比對原始需求、核准合約、實際變更、驗證證據與未驗證項，並標記符合、合理偏離、未授權偏離或未驗證
  - **[MEMORY/DOCS]**：需要更新的記憶卡、脈絡卡、README、CHANGELOG 或發布紀錄

## 4. Code Review Gate（程式碼審查閘門）

- **停止**：呼叫 `notify_user`，將 `implementation_plan.md` 放入 `PathsToReview`，並輸出：
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
- **等待 GO 指令**。收到核准後，**必須**呼叫 `task_boundary` 切換至 `EXECUTION` 模式，並立即觸發 `/03-2_build_execute` 工作流繼續執行。

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
- **Memory Update**: READ-ONLY at this stage — 補丁包整合與記憶歸卡由 `/03-2_build_execute` 在 GO 後依隊長整合閘門執行。
