---
name: 12_skill_forge
description: 從健檢發現、除錯方法論或總監指令中萃取可重用模式，建立新的專案衍生技能
required_skills: [memory-ops]
memory_awareness: full
user-invocable: true
---

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
- 更新 `.claude/agents/skills/_index.md`（若適用）。
- Report to Director:
  > `[技能鍛造完成] 新技能 <name> 已建立於 .agents/project_skills/<name>/。`

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` — 僅允許寫入 `.agents/project_skills/` 目錄。
- **Memory**: full — 更新技能索引。
