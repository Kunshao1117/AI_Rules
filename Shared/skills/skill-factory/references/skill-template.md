# Candidate Skill Template

Use only after the prevention-first admission method accepts a candidate.
This template does not activate, register, install or deploy it.

```yaml
---
name: narrow-skill-name
description: >
  具體專業任務方法。Use when: 明確且狹窄的適用任務。
  DO NOT use when: 具體容易混淆但不適用的任務。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  style: guided
  memory_awareness: none
  tool_scope: ["filesystem:read"]
---
```

Keep name ASCII kebab-case, 1-64 characters, matching the eventual directory.
Put Traditional Chinese task meaning first in description and after both trigger
labels; keep description under 1024 characters, without angle brackets. Follow
`Shared/policies/language-governance.md` for the body and audience language.
Top-level keys: name, description, optional license/allowed-tools, metadata.
Project/framework custom annotations belong under metadata; they are not native
platform enforcement or action authority. Do not add obsolete role/lifecycle fields.

Body outline: purpose/single responsibility; when to use and when not to use;
core method; relevant gotchas; reference selection; canonical owner boundaries.
Record allowed/restricted/manual_only as the invocation recommendation in the
candidate, plus provider-specific yes/no and presence/missing/no-install behavior.
Do not invent a top-level invocation-control field unsupported by the platform.

## Eventual layer placement, only after applicable approval

| Layer | Existing destination convention |
|---|---|
| Shared | Shared/skills/{name}/SKILL.md in the actual AI_Rules source repository; origin framework |
| Project-derived | .agents/project_skills/{project-code}-{name}/SKILL.md; origin project; follow the existing project discovery contract |
| Personal | User's chosen supported Skill directory; do not change project registries implicitly |

Before approval keep the candidate outside every loader/discovery root. Do not
write Shared sources from a downstream project without an authorized framework
source location. Do not automatically create a project link or edit an index.
Determine the existing integration mechanism at activation time; generated copies
remain outputs, not editable source owners. Release/deployment is a separate action.
