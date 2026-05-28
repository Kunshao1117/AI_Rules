---
name: "08-2-logic-深度邏輯"
description: "Use when: 健檢第二階段、深度邏輯審查、安全架構、API 串接比對、測試覆蓋缺口與死碼偵測。DO NOT use when: 要完整健檢入口，改用 08-audit。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
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

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.
# source-command-08-audit-08-2-logic-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-2_logic-SKILL`.

## Command Template

# [SKILL: /08_audit — Phase 2: 深度邏輯審查]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。

## 2.1 Security Review (S1–S5 安全架構審查)

> [LOAD SKILL] 確認 `.agents/skills/audit-engine/SKILL.md` 已載入。

- **S1: 認證流程完整性** — 驗證所有受保護路由均有認證守衛
- **S2: 授權/RLS 政策覆蓋** — 確認資料庫查詢有適當的 RLS 政策
- **S3: 輸入驗證完整性** — 所有使用者輸入是否有 Zod/Yup 等驗證
- **S4: 憑證隔離** — 掃描 hardcoded secrets、API Key 外洩風險
- **S5: API 端點暴露** — 公開端點是否有不必要的資料外洩

## 2.2 API Contract Alignment (前後端串接比對)

- 收集前端 API 呼叫清單（`fetch()`、`axios`、`trpc`、`supabase.from()` 等）
- 比對後端路由定義（`app/api/*/route.ts` 或類似結構）
- 標記：
  - 前端呼叫但後端不存在的端點（斷鏈）
  - 型別不符的請求/回應格式
  - 已棄用但仍被呼叫的路由

## 2.3 Test Coverage Gap (測試覆蓋缺口)

- 識別核心業務路徑中缺少測試覆蓋的區域
- 依「業務影響 × 缺口嚴重程度」排序優先修復清單

## 2.4 Dead Code & Orphan Detection (死碼偵測)

> [LOAD SKILL] 若涉及 3+ 模組診斷，確認 `.agents/skills/code-diagnosis/SKILL.md` 已載入。

- 掃描未使用的 export、未被 import 的檔案
- 與記憶卡 `## Tracked Files` 交叉比對，找出已追蹤但實際已移除的檔案

## 2.5 Output

產出深度邏輯報告物件，傳遞給 Phase 3（08-3_report）彙整：
```
{
  security: { s1, s2, s3, s4, s5 },  // 各維度：{ status: green|yellow|red, findings[] }
  api_alignment: { broken_links[], type_mismatches[], deprecated[] },
  test_coverage: { critical_gaps[] },
  dead_code: { unused_exports[], orphan_files[] }
}
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純分析審查，不修改任何原始碼或記憶卡。
