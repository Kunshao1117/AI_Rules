---
name: "12-skill-forge-技能鍛造"
description: "Use when: 技能鍛造、建立新專案技能、從健檢/除錯/總監指令萃取可重用方法論。DO NOT use when: 只要修改既有 Shared Skill 描述。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: skill-forge
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
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

> [LOAD SKILL] If the new or revised skill covers plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before defining trigger language.
# source-command-12-skill-forge-skill

Use this skill when the user asks to run the migrated source command `12_skill_forge(技能鍛造)-SKILL`.

## Command Template

# [SKILL: /12_skill_forge — 技能鍛造]

## 0. Source Gate (觸發來源判斷)

```
[SOURCE GATE] Identify skill source:
├── 觸發自 /08_audit 建議？→ 從審查報告中萃取重複模式
├── 觸發自 /07_debug 方法論？→ 將除錯步驟萃取為可重用技能
└── 觸發自總監明確指令？→ 依總監規格設計
```

## 0.5. Backfill Gate（補植既有模式掃描）

> 每次鍛造新技能前，先執行此閘門：

```
[BACKFILL GATE]
├── 掃描現有工作流（.agents/skills/*/SKILL.md）中是否存在重複的操作步驟
├── 若發現可萃取為技能的模式（出現 2+ 次的操作序列）：
│   └── 列出候選模式，提示總監：「發現可萃取模式 {N} 個，是否一併建立技能？」
│       ├── YES → 將候選模式加入本次鍛造清單
│       └── NO  → 繼續僅建立當前指定技能
└── 無候選模式 → 繼續執行 §1
```

## 1. Pattern Extraction (模式萃取)

- 從來源中提取核心操作序列。
- 識別決策點、前置條件、邊界情況。
- 定義明確的輸入與輸出格式。

## 2. Skill Design (技能設計)

Draft new skill with structure:
1. **Frontmatter**: name, description（Traditional Chinese），metadata
2. **Core Logic**: Step-by-step procedure with decision gates
3. **Constraints**: Scope boundaries, forbidden actions
4. **Security & Compliance**: Role, memory interaction level

### Frontmatter Template
```yaml
---
name: <skill-name>
description: <繁中描述>
required_skills: []
memory_awareness: none
user-invocable: false  # 操作型知識庫預設不出現在 / 選單
---
```

## 3. FORGE VALIDATION GATE（技能格式驗證閘門）

```
[FORGE VALIDATION GATE — 寫入前必須通過]
├── 新技能是否已透過 notify_user / Artifact 送審總監？
│   └── NO → [HALT]「🔴 [FORGE HALT] 技能未送審，不得寫入磁碟。」
├── YAML frontmatter 是否符合規範（含 name、description、metadata）？
│   └── NO → 自動修正（最多重試 2 次）
│   └── 2 次後仍不符 → [HALT]「🔴 [FORGE HALT] YAML 格式驗證失敗。」
├── 技能名稱是否與現有技能衝突（`.agents/skills/_index.md`）？
│   └── YES → 提示總監選擇：覆蓋或重新命名
└── 存放路徑是否為 `.agents/project_skills/`？
    └── NO → 自動修正路徑後繼續
```

## 4. Write & Archive (寫入與歸檔)

- 寫入技能至 `.agents/project_skills/<name>/SKILL.md`。
- 更新 `.agents/project_skills/_index.md` 路由表。
- 更新 `.agents/skills/_index.md`（若適用）。
- Report to Director:
  > `[技能鍛造完成] 新技能 <name> 已建立於 .agents/project_skills/<name>/。`

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` — 僅允許寫入 `.agents/project_skills/` 目錄。
- **Memory**: full — 更新技能索引。
