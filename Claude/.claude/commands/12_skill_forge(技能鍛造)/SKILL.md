---
name: 12_skill_forge
description: "Use when: 技能鍛造、建立新技能、建立 Shared skill、建立 project skill、建立 Codex skill、從健檢/除錯/總監指令萃取可重用方法論、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關技能設計。DO NOT use when: 只是討論技能想法、不準備寫入，或只要修改既有技能描述。"
required_skills: [memory-ops, project-context-protocol]
memory_awareness: full
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
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

> [LOAD SKILL] If the new or revised skill covers plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.claude/skills/plugin-release-governance/SKILL.md` before defining trigger language.
> [LOAD SKILL] If the new or revised skill promotes stable project context, design DNA, product preference, technical preference, or acceptance preference into repeatable procedure, read `.claude/skills/project-context-protocol/SKILL.md` before defining scope.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 12 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Apply the Agent Skills format, description-trigger quality, progressive disclosure, layer selection, reference splitting, and validation gates before writing skills.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.

# [SKILL: /12_skill_forge — 技能鍛造]

## 0. Source Gate (觸發來源判斷)

```
[SOURCE GATE] Identify skill source:
├── 觸發自 /08_audit 建議？→ 從審查報告中萃取重複模式
├── 觸發自 /07_debug 方法論？→ 將除錯步驟萃取為可重用技能
├── 觸發自已核准專案脈絡？→ 只在其描述穩定且可重複執行程序時升級為專案技能
└── 觸發自總監明確指令？→ 依總監規格設計
```

## 0.5. Backfill Gate（補植既有模式掃描）

> 每次鍛造新技能前，先執行此閘門：

```
[BACKFILL GATE]
├── 掃描現有工作流（.claude/commands/*/SKILL.md）中是否存在重複的操作步驟
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
- 更新 `.claude/skills/_index.md`（若適用）。
- Report to Director:
  > `[技能鍛造完成] 新技能 <name> 已建立於 .agents/project_skills/<name>/。`

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` — 僅允許寫入 `.agents/project_skills/` 目錄。
- **Memory**: full — 更新技能索引。
