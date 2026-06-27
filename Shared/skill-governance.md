# Skill Governance Contract

AI_Rules uses skills as an on-demand knowledge compression layer. This file
defines where governance content belongs so three platforms can share semantics
without forcing every rule into always-on context.

## Skill Placement Contract

| Layer | Purpose | Put Here | Do Not Put Here |
|---|---|---|---|
| Core rules | Always-on safety baseline | GO gates, no silent install, no blanket staging, protected project identity | Long playbooks, tool recipes, examples |
| Workflow / command entry | Task routing and lifecycle phase selection | Build/fix/commit/audit stage order, explicit load gates | Full implementation recipes shared across platforms |
| Shared skills | On-demand operational knowledge | Repeatable procedures, team-station governance, tool playbooks, release steps, test recipes | Non-negotiable safety rules that must apply before skill load |
| Memory | Project-specific facts and decisions | Current architecture, version choices, repo lessons, module ownership | Generic procedure that should apply to many projects |
| Project context | Long-lived project preferences | Design DNA, product preferences, technical preferences, communication preferences, acceptance preferences | Source ownership, stale tracking, executable procedures |

Rules that must be obeyed even when no skill triggers stay in core rules.
Details that are only needed for a task should move into Shared skills or their
references.
Long-lived preferences should move into `.agents/context/**/CONTEXT.md`, not
memory cards. Stable context that becomes a repeatable procedure can be promoted
to a project skill through the skill forge workflow.

## Skill Trigger Contract

Codex primarily sees `name` and `description` before a skill is loaded. A skill
that depends on automatic triggering must put trigger language in frontmatter,
not only in the body.

Required description behavior:

- Include the task domain in English and Traditional Chinese.
- Include real user wording, for example "重新打包", "同步 Release", "update reminder".
- Use `Use when:` in the description for positive triggers.
- Use `DO NOT use when:` for operational skills and for neighboring skills that
  are easy to confuse.
- Keep body-level trigger sections as explanation only; they are not a trigger
  substitute.

## Platform Entry Contract

Antigravity, Claude, and Codex keep different entry shapes:

- Antigravity uses `.agents/workflows/*.md` as the user-facing entry and
  `.agents/skills/` as operational knowledge.
- Claude uses `.claude/commands/*/SKILL.md` as Slash Command entries and
  `.claude/skills/` as operational knowledge.
- Codex uses `.agents/skills/` for both workflow skills and operational skills;
  descriptions must distinguish entry skills from helper skills.

Shared skills must remain platform-neutral. Platform-specific workflow files
may add a load gate pointing to the shared skill, but should not duplicate the
full playbook.

Coding workflows should route through `programming-team-governance` when they
touch source, tests, debugging, audit, commit preparation, handoff, skill
creation, workflow rules, source memory, or governance decisions. The shared
skill defines the captain trigger gate, captain team board, role exclusivity,
station board, read-only evidence branch boundary, isolated patch boundary,
direct exception contract, evidence owner field, completion condition, and
fake-team guard; platform workflow entries only load it and adapt the station
evidence or patch output to their native tools. Platform entries must not
weaken the shared contract by replacing evidence-oriented stations with
generic main-thread handling.

## Doctor Expectations

Skill quality checks should treat trigger quality as a first-class signal:

- A short or generic description is a warning.
- Body-only `Use when` guidance without description triggers is a warning.
- Operational Shared skills without both English and Traditional Chinese trigger
  terms are a warning.
- Operational Shared skills without a negative boundary are a warning.
- Workflow / command entries must describe when the workflow should start, not
  only what it does internally.
- Coding-related workflow / command entries must expose the team-station board
  requirement through a load gate or equivalent grounding section, including
  captain trigger, evidence owner, role boundary, direct exception, completion
  condition, and the rule that all-direct evidence boards are invalid without
  concrete exceptions.
- Coding-related workflow / command entries must not imply that the Director
  must manually name a workflow before captain-led governance starts.
- Coding-related workflow / command entries must not allow implementation
  specialists to review their own work or write the main worktree directly.
- High-risk release, deployment, or mutation skills must name their public
  trigger terms explicitly.
- Workflow and operational skills should not mix responsibilities.
