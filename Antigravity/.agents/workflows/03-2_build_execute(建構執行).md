---
description: "Use when: 已有 /03_build 核准 GO，要執行建構寫入、記憶歸卡與驗證測試。DO NOT use when: 尚未完成建構計畫或未取得 GO。"
required_skills: [memory-ops, security-sre, code-quality, test-patterns, trunk-ops]
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
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.
# [WORKFLOW: BUILD — EXECUTE (建構執行)]


> **前置條件**: 本工作流須由 `/03_build(建構計畫)` 的 GO 授權後方可執行。

## 0. Precondition Check（前置條件確認）

[PRECONDITION GATE] Verify authorization before any disk write:
- IF (Not triggered by an explicit GO approval from /03_build):
  - [HALT] Output exactly: 「🔴 [AUTH HALT] 未收到建構計畫授權。請先執行 /03_build 並取得 GO 確認。」
- ELSE:
  - Load `implementation_plan.md` to identify [NEW] and [MODIFY] file lists. Proceed to §1.

## 1. Physical Write（實體寫入磁碟）

- 呼叫 `task_boundary` 切換至 `EXECUTION` 模式。
- 依 `implementation_plan.md` 的 diff 清單，將所有變更**寫入物理磁碟**。
- 寫入順序：**依賴者先於被依賴者**（底層模組先寫，上層模組後寫）。

// turbo

## 2. New File Memory Card Archiving（新建檔案歸卡歸檔）

[MEM ARCHIVE GATE] For every [NEW] file in implementation_plan.md:
- IF (An existing memory card already tracks this module's scope):
  - [LOAD SKILL] `view_file .agents/skills/memory-ops/SKILL.md`
  - Append new file to that card's `## Tracked Files` section. Update `last_updated`.
- ELSE (No existing card found):
  - [LOAD SKILL] `view_file .agents/skills/memory-ops/SKILL.md`
  - Create a new memory card. Populate: Tracked Files, Key Decisions, Relations, Applicable Skills.
- CONSTRAINT: Memory card descriptions MUST include Traditional Chinese keywords.
- HALT CHECK: If card creation/update fails, [HALT] and output: 「🔴 [MEM HALT] 新建模組尚未完成歸卡。」 Do NOT proceed to §3.

## 3. Modified File Memory Update（修改檔案記憶卡更新）

[MEM UPDATE GATE] For every [MODIFY] file in implementation_plan.md:
- IF (Found the memory card tracking this file):
  - Update Key Decisions, Known Issues, Module Lessons, and `last_updated`.
- ELSE (Card not found):
  - [LOAD SKILL] `view_file .agents/skills/memory-ops/SKILL.md` and create it.
- HALT CHECK: If card update fails, [HALT] and output: 「🔴 [MEM HALT] 記憶卡尚未更新。」 Do NOT proceed to §4.

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

## 5. Automated Chaining to Test（自動串聯視覺測試）

- 單元測試通過後，**必須自主觸發** `/06_test` 工作流，對自身的修改執行視覺驗證。
- **禁止**要求總監手動執行測試工作流。

## COMPLETION GATE（完成閘門 — 不可略過）

> Inherits: `.agents/workflows/_completion_gate.md`

- Execute all checks defined in the shared Completion Gate.

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | Permissions based on the security gate matrix。
- **Memory Update**: MANDATORY — §2 與 §3 強制執行，不可略過。違反即 HALT。
