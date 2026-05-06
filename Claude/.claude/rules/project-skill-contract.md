# [PROJECT SKILL CONTRACT]

> 條件載入觸發情境：
> - 建立或修改衍生技能（`.agents/project_skills/`）
> - 執行 `/12_skill_forge` 時

## Project Skill Gate（衍生技能建立閘門）

```
[PROJECT SKILL GATE] 建立衍生技能前：
├── 技能草稿是否已透過 Artifact / 對話輸出送審總監？
│   └── NO → [HALT]「🔴 [FORGE HALT] 衍生技能草稿未送審，不得寫入磁碟。」
├── YAML frontmatter 是否包含：name, description, metadata(origin: project)?
│   └── NO → 自動修正（最多重試 2 次）→ 仍失敗 → [HALT]
├── 存放路徑是否為 .agents/project_skills/<name>/SKILL.md？
│   └── NO → 自動修正路徑後繼續
└── 技能名稱是否與現有技能衝突（.agents/skills/ 索引）？
    └── YES → [HALT] 提示總監選擇覆寫或重命名
```

## 升級保護宣告

- 框架升級（`Deploy-Claude.ps1`）絕不觸碰 `.agents/project_skills/`
- 符號連結：`.claude/skills/project-{name}` → `.agents/project_skills/{name}/`（由 Backfill 建立）

## Frontmatter 必填規格

```yaml
metadata:
  author: <creator>
  version: "1.0"
  origin: project        # 區別框架技能
  memory_awareness: none|read|full
  tool_scope: [...]
```

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | 建立衍生技能屬寫入操作，需 Writer 角色。
