---
description: "Use when: 正式建構、設計到建構合約、新功能、工具建構或產品行為變更，需要先整合架構判斷、建構計畫並等待 GO。DO NOT use when: 純討論、沙盒實驗、純架構方案或已進入授權執行階段。"
required_skills: [memory-ops, tech-stack-protocol, ai-dev-quality-gate, project-context-protocol]
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

> [LOAD SKILL] If this task touches plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches UI, high-change frameworks, MCP, VS Code extension APIs, generated UI references, design DNA, or mobile/responsive behavior, read `.agents/skills/ai-dev-quality-gate/SKILL.md` before planning changes.
> [LOAD SKILL] If this task touches product behavior, UX preference, design DNA, technical preference, communication preference, or acceptance criteria, read `.agents/skills/project-context-protocol/SKILL.md` and relevant `.agents/context/**/CONTEXT.md` cards before planning changes. Report adopted context or deviation reasons.
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
- 載入相關記憶卡的 `SKILL.md`，了解模組架構、追蹤檔案、決策記錄、已知問題。
- 查看 `## Relations` 段落，確認可能被此次建構影響的跨模組依賴關係。
- 查看 `## Applicable Skills` 段落，確認應載入的操作技能已啟動。

## 2. Context & Architecture Acquisition（情境與架構讀取）

- 使用已載入的記憶技能，理解模組架構與當前狀態。
- 若同一對話已有藍圖，直接沿用，不得重新規劃到遺失上下文。
- 若沒有藍圖，將架構決策納入本次建構計畫：功能邊界、受影響模組、公開介面、不採用方案與驗證影響。
- `/02_blueprint` 僅用於純架構、全系統初始化、重大技術轉向或不立即實作的輸出。
- 根據 Glob 模式，自動套用 `.agents/rules/` 中所有適用的規範。

> [LOAD SKILL] §3 產出計畫並涉及程式碼時，必須讀取：
> 1. `view_file .agents/skills/code-quality/SKILL.md`
> 2. `view_file .agents/skills/security-sre/SKILL.md`

## 3. Design-to-Build Contract & Diff Generation（設計到建構合約與差異生成）

- **必須**呼叫 `task_boundary` 進入 `PLANNING` 模式。
- 將所有新程式碼或修改寫入**隔離的沙盒記憶體**。
- **嚴禁**在此階段寫入物理檔案系統。
- 產出詳細的 `implementation_plan.md` Artifact，附上程式碼 `diff`，並明確標記：
  - **[GOVERNANCE DEPTH / 治理深度判定]**：任務等級、命中升級因子、豁免理由、驗證證據；只輸出摘要，不重貼 `ai-dev-quality-gate` 的完整自治矩陣
  - **[ARCHITECTURE]**：功能邊界、受影響模組、公開介面變更、不採用方案
  - **[MODIFY]**：修改的現有檔案
  - **[NEW]**：本次建構將新建的原始碼檔案（後續歸卡流程依賴此清單）
  - **[DELETE]**：將被刪除的檔案
  - **[COMPLETENESS]**：使用者流程、載入、空狀態、錯誤、權限、離線狀態
  - **[VALIDATION]**：單元、整合、回歸與介面適配證據
  - **[MEMORY/DOCS]**：需要更新的記憶卡、脈絡卡、README、CHANGELOG 或發布紀錄

## 4. Code Review Gate（程式碼審查閘門）

- **停止**：呼叫 `notify_user`，將 `implementation_plan.md` 放入 `PathsToReview`，並輸出：
  > `[最高授權閘門] 設計到建構合約已完成。請總監審閱上方計畫。系統防護中。請輸入 GO 授權覆寫，或留言退回。`
- **等待 GO 指令**。收到核准後，**必須**呼叫 `task_boundary` 切換至 `EXECUTION` 模式，並立即觸發 `/03-2_build_execute` 工作流繼續執行。

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
- **Memory Update**: READ-ONLY at this stage — 實體寫入與記憶歸卡在 `/03-2_build_execute` 執行。
