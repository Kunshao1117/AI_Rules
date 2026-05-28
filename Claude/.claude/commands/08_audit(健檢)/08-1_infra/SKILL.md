---
name: 08-1_infra
description: "Use when: 健檢第一階段、基礎盤點、依賴安全掃描、記憶卡拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08-audit。"
required_skills: [memory-ops, code-audit]
memory_awareness: full
user-invocable: false
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
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
# [SKILL: /08_audit — Phase 1: 基礎盤點]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。

## 1.1 Dependency Security (依賴安全掃描)

Run via `Bash` tool:
```bash
npm audit --json
```
- 解析嚴重程度（critical / high / moderate / low）。
- 記錄結果到臨時報告物件供 Phase 3 彙整。

```bash
npx tsc --noEmit 2>&1
```
- 解析 TypeScript 型別錯誤數量與位置。

## 1.2 Memory Topology Check (記憶卡拓樸驗證)

> [LOAD SKILL] 確認 `.agents/skills/memory-ops/SKILL.md` 已載入。

- Call `cartridge-system__memory_list` 取得所有記憶卡清單。
- 對每張記憶卡執行：
  - 檢查 `staleness` 是否 > 0（過期警報）
  - 檢查 `## Tracked Files` 中的路徑是否實際存在（孤立記憶卡偵測）
  - 檢查是否有未被任何記憶卡追蹤的原始碼檔案（未覆蓋檔案偵測）

## 1.3 Skill Coverage Check (技能覆蓋率)

- 掃描 `.agents/skills/` 目錄，列出所有可用技能。
- 比對 `.claude/commands/*/SKILL.md` 的 `required_skills` 欄位。
- 標記有工作流引用但實際不存在的技能（斷鏈技能）。

## 1.4 Directory Hygiene (.claude/ 目錄衛生)

- 掃描 `.claude/commands/` 目錄，確認每個子目錄均有 `SKILL.md`。
- 掃描 `.agents/memory/` 目錄，確認格式符合 V5 架構（含 frontmatter）。
- 偵測 `.agents/project_skills/` 中無對應符號連結的衍生技能。

## 1.5 Output

產出基礎盤點報告物件，傳遞給 Phase 3（08-3_report）彙整：
```
{
  npm_audit: { critical, high, moderate, low },
  typescript: { error_count },
  memory: { stale_cards[], orphan_cards[], uncovered_files[] },
  skills: { broken_links[] },
  directory: { missing_skill_md[], format_violations[] }
}
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 唯讀掃描 + memory_list 呼叫，不修改任何原始碼。
