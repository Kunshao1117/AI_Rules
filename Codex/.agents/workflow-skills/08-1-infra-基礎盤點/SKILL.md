---
name: "08-1-infra-基礎盤點"
description: "Use when: 健檢第一階段、基礎盤點、依賴安全掃描、記憶卡拓樸、技能覆蓋率與目錄衛生檢查。DO NOT use when: 要完整健檢入口，改用 08-audit。"
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
# source-command-08-audit-08-1-infra-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-08-1_infra-SKILL`.

## Command Template

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
- 比對 `.agents/skills/*/SKILL.md` 的 `required_skills` 欄位。
- 標記有工作流引用但實際不存在的技能（斷鏈技能）。

## 1.4 Directory Hygiene (.Codex/ 目錄衛生)

- 掃描 `.agents/workflow-skills/` 目錄，確認每個子目錄均有 `SKILL.md`。
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

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 唯讀掃描 + memory_list 呼叫，不修改任何原始碼。
