---
name: 12_skill_forge
description: 從健檢發現、除錯方法論或總監指令中萃取可重用模式，建立新的專案衍生技能
required_skills: [memory-ops]
memory_awareness: full
user-invocable: true
---

# [SKILL: /12_skill_forge — 技能鍛造]

## 1. Pattern Extraction (模式萃取)

[SOURCE GATE] Identify skill source:
- IF (triggered from /08_audit findings):
  - Extract recurring patterns from audit recommendations.
- IF (triggered from /07_debug methodology):
  - Extract debugging methodology as reusable skill.
- IF (triggered by Director's explicit instruction):
  - Follow Director's specification.

## 2. Skill Design (技能設計)

Draft new skill with structure:
1. **Frontmatter**: name, description (Traditional Chinese), metadata
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

## 3. Validation (驗證)

- Ensure no naming conflict with existing skills in `.claude/agents/skills/`.
- Ensure skill follows Claude Code tool naming (Read/Write/Edit/Bash/Agent).
- Ensure all outputs are in Traditional Chinese.

## 4. Write & Archive (寫入與歸檔)

- Write skill to `.claude/agents/skills/<name>/SKILL.md`.
- Update `.claude/agents/skills/_index.md` with new entry.
- Report to Director:
  > `[技能鍛造完成] 新技能 <name> 已建立於 .claude/agents/skills/<name>/。`

---

## [SECURITY & COMPLIANCE]
- **Role**: Writer/SRE — writes to agents/skills/ directory only.
- **Memory**: full — updates skill index.
