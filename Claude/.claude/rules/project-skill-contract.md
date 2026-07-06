# [PROJECT SKILL CONTRACT]

> Load when:
> - Creating or modifying derived skills under `.agents/project_skills/`.
> - Running `/12_skill_forge`.

## Project Skill Gate

```text
[PROJECT SKILL GATE] Before creating a derived project skill:
├── Has the skill draft been submitted to the Director through an artifact or conversation output?
│   └── NO -> [HALT]「🔴 [FORGE HALT] 衍生技能草稿未送審，不得寫入磁碟。」
├── Does YAML frontmatter contain `name`, `description`, and `metadata(origin: project)`?
│   └── NO -> Auto-fix, retry at most twice, then HALT if still failing.
├── Is the storage path `.agents/project_skills/<name>/SKILL.md`?
│   └── NO -> Correct the path, then continue.
└── Does the skill name conflict with an existing `.agents/skills/` index entry?
    └── YES -> HALT and ask the Director to choose overwrite or rename.
```

## Upgrade Protection Statement

- Framework upgrade through `Deploy-Claude.ps1` must never touch `.agents/project_skills/`.
- Symlink form: `.claude/skills/project-{name}` -> `.agents/project_skills/{name}/`, created by Backfill.

## Required Frontmatter

```yaml
metadata:
  author: <creator>
  version: "1.0"
  origin: project        # Distinguishes project skills from framework skills.
  memory_awareness: none|read|full
  tool_scope: [...]
```

## Security And Compliance Mandate

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE`. Creating a derived project skill is a write operation and requires the Writer role.
