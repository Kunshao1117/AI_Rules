---
trigger: model_decision
description: 專案衍生技能建立與生命週期合約；建立或審查 derived skills、執行 skill-forge workflow，或目前 workflow 宣告 `skill_generation` 時載入（Load when: project skill lifecycle applies）。
---

# [ANTIGRAVITY PROJECT SKILL CONTRACT]

## 1. Activation Conditions

Load this rule when:
- Creating or modifying a project skill under `.agents/project_skills/`
- Executing the `/12_skill_forge` workflow
- The active workflow declares `skill_generation: true` in its YAML frontmatter
- Reviewing whether an existing project skill should be archived or updated

## 2. Project Skill System

- **Project Skills Directory**: AI-generated reusable skills are stored in `.agents/project_skills/` as individual SKILL.md files. A symlink at `.agents/skills/_project` points to this directory, enabling IDE auto-discovery. Project memory is a separate readable knowledge layer and is not mirrored as executable skills.
- **Readable AND Writable by Master Agent**: Unlike framework-provided skills (read-only), project skills CAN be created and modified by the Master Agent during sanctioned workflows.
- **Director Review Gate**: ALL newly generated project skills MUST be presented to the Director for approval before activation. The Agent MUST NOT silently create and use project skills without Director visibility.
- **Upgrade Protection**: Framework upgrades (via `Deploy-Antigravity.ps1`) NEVER touch the `project_skills/` directory. The symlink architecture ensures physical isolation from the `skills/` copy operation.
- **Format Compliance**: Project skills MUST follow the same SKILL.md format as framework skills, including YAML frontmatter with `metadata.origin: project` to distinguish them from framework-provided skills.
- **Skill Generation Binding**: Only workflows that declare `skill_generation: true` in their YAML frontmatter are authorized to create project skills. Load `skill-factory` skill for generation procedures.

## 3. Skill Metadata Standard

All project skill SKILL.md frontmatter MUST include a `metadata` block with:
- `author`: creator identifier
- `version`: semantic version string
- `origin`: MUST be `project` (distinguishes from framework skills)
- `memory_awareness`: one of `none`, `read`, or `full`
- `tool_scope`: array of permitted tool categories (e.g., `filesystem:read`, `filesystem:write`, `mcp:{server}`, `browser`, `terminal`)
