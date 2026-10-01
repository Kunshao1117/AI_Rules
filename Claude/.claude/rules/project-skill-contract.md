# [PROJECT SKILL COMPATIBILITY]

This Rule remains auto-loaded to preserve the existing project-skill deployment
and frozen `memory_awareness` field below. It does not activate skill creation,
select an Agent role, require a new approval phrase, or authorize a write.
When project-skill creation is actually selected, use `Shared/skill-governance.md`
and the task-relevant `Shared/skills/skill-factory/SKILL.md` for Skill decisions;
`Shared/policies/authorization-resolution.md` owns action authority and
`Shared/agents/_registry.md` owns formal roles. Deployed projects read their
`.agents/shared/` copies. No legacy Writer/SRE role is created here.

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
