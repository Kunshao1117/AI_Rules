---
name: 08-1_infra
description: 健檢第一階段：系統基礎盤點 — 依賴安全掃描、記憶卡拓樸驗證、技能覆蓋率、目錄衛生檢查
required_skills: [memory-ops, code-audit]
memory_awareness: full
user-invocable: false
---

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
