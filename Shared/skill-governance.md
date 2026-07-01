# Skill Governance Contract

AI_Rules uses skills as an on-demand knowledge compression layer. This file
defines where governance content belongs so three platforms can share semantics
without forcing every rule into always-on context.

Workflow entries and team skills reference
`Shared/policies/workflow-orchestration.md` for sequence semantics instead of
copying the full board, wave, channel, and completion playbook into every skill.
Language and audience-layer classification for skills, triggers, handoffs,
memory text, and generated documentation is governed by
`Shared/policies/language-governance.md`; skills must cite that policy instead
of treating a platform core rule as their only source.

## Skill Placement Contract

| Layer | Purpose | Put Here | Do Not Put Here |
|---|---|---|---|
| Core rules | Always-on safety baseline | GO gates, no silent install, no blanket staging, protected project identity | Long playbooks, tool recipes, examples |
| Shared policies | Cross-platform governance contracts | Ownership boundaries, precedence, authorization semantics, source/deployed sync, trace expectations | Workflow-specific recipes, long examples, platform-only implementation details |
| Workflow / command entry | Task routing and lifecycle phase selection | Build/fix/commit/audit stage order, explicit load gates | Full implementation recipes shared across platforms |
| Shared skills | On-demand operational knowledge | Repeatable procedures, team-station governance, tool playbooks, release steps, test recipes | Non-negotiable safety rules that must apply before skill load |
| Memory | Project-specific facts and decisions | Current architecture, version choices, repo lessons, module ownership | Generic procedure that should apply to many projects |
| Project context | Long-lived project preferences | Design DNA, product preferences, technical preferences, communication preferences, acceptance preferences | Source ownership, stale tracking, executable procedures |

Rules that must be obeyed even when no skill triggers stay in core rules.
Details that are only needed for a task should move into Shared skills or their
references.
Shared policies are the home for reusable governance contracts that must be
available to multiple workflows, skills, or platforms but are too detailed for
always-on platform core. Platform core files may cite those policies, but they
must not absorb policy playbooks, field catalogs, scenario examples, or tool
recipes.
When a skill grows beyond the quality gate or begins compressing multiple role
identities into one file, split stable details into `references/` and pass the
relevant reference paths through the station handoff packet. Do not keep
shrinking text until role meaning changes.
Long-lived preferences should move into `.agents/context/**/CONTEXT.md`, not
memory cards. Stable context that becomes a repeatable procedure can be promoted
to a project skill through the skill forge workflow.

## Boundary And Deduplication Defenses

Governance content must use the smallest durable home that still preserves the
executable guard:

- Always-on core keeps short non-negotiable gates and cites shared policies for
  details.
- Shared policies keep cross-workflow contracts, precedence, and invalid
  patterns.
- Workflow entries keep route order, load gates, and task-specific evidence
  expectations.
- Skills keep operational procedures, artifact formats, tool recipes, and
  references loaded on demand.
- Memory keeps source-backed project facts and active constraints.
- Project context keeps long-lived preferences and design or acceptance DNA.

If a paragraph duplicates a canonical policy, replace it with a reference unless
the local file owns a stricter or more specific rule. If examples, scenarios,
field catalogs, or platform recipes make a policy or skill hard to scan, move
them into a `references/` file or cite the existing canonical source. Condensing
is valid only when MUST rules, forbidden shortcuts, required evidence, blocked
states, and source/deployed sync obligations remain executable. Do not shorten a
file by deleting the guard that made the rule enforceable.

## Existing Change Integration Defense

Before editing a governance, workflow, skill, memory, or context file that
already has worktree changes, the change owner must read the current diff and
the target section from the file, then integrate with the still-valid parts.
Valid integration edits rewrite or merge the target section. Invalid edits add a
parallel section, repeat the same rule under a new heading, create a sidecar file
to avoid the dirty section, or overwrite another change without evidence that it
is obsolete. If the existing diff conflicts with the requested change, stop as
blocked or ask for a scope decision instead of hiding the conflict in another
patch.

## Source/Deployed Pair Contract

Shared governance sources live under `Shared/` in the framework source tree.
Runtime copies under `.agents/`, `.claude/`, `Codex/.codex/`, or other deployed
targets are deployment outputs unless a task explicitly names them as the source
repair target. Governance, workflow, skill, and public-contract changes must
record the source/deployed pair strategy before completion:

- Source-first is the normal path.
- Deployed-first emergency repair must be backfilled to source before it can be
  complete.
- Updating only a deployed copy is an invalid completion for framework-level
  governance.
- Missing parity evidence is blocked or unverified, not a harmless warning.

## Skill Relation Metadata

agentskills.io compatibility still depends on `name` and `description`. AI_Rules
may add optional `metadata.relations` for machine-checkable skill trees. Missing
relations are not a generic skill failure, but Team-Native specialist role skills
use them as governance evidence.

```yaml
metadata:
  relations:
    role_id: change-delivery
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
      - team-change-delivery-artifact
    embedded_artifacts: []
    artifact_contracts:
      - change-delivery-artifact
    trace_contracts:
      - Shared/policies/team-trace-evidence.md
      - team-station-handoff-packet
```

`support_skills` are skills a handoff packet may load with the role.
`embedded_artifacts` are role-owned evidence formats that do not need a separate
artifact skill. `artifact_contracts` are external delivery or completion
contracts. `trace_contracts` point to the shared trace and handoff evidence
rules instead of repeating long trace field lists inside every role skill.

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
station board, read-only evidence branch boundary, isolated change delivery boundary,
direct exception contract, evidence owner field, completion condition, and
fake-team guard; platform workflow entries only load it and adapt the station
evidence or change delivery output to their native tools. Platform entries must also load
the formal team child skills when applicable: `team-role-boundaries`,
`team-change-delivery-artifact`, `team-memory-docs-delivery-artifact`,
`team-validation-delivery-artifact`, `team-review-delivery-artifact`, and `team-completion-gate`.
Platform entries must also preserve Team-First startup semantics: no-write work
uses a formal-readonly board when it can influence later source work; write work
uses a formal-write board after scoped GO; every formal station receives a
handoff packet with loaded skill refs and startup monitoring fields.
Platform entries must preserve `operation_mode`: `daily` is reduced Team-Native
mode for routine low-risk evidence, while `full` is required for implementation,
repair, bottom-layer refactor, cross-file governance, specialist skill rewrites,
Doctor/Audit changes, commit/release/deploy preparation, or protected
external-state readiness.
Platform entries must not weaken the shared contract by replacing
implementation change delivery, memory delivery, review, or validation delivery artifacts with
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
- Coding-related workflow / command entries must load the six formal team child
  skills when applicable: `team-role-boundaries`,
  `team-change-delivery-artifact`, `team-memory-docs-delivery-artifact`,
  `team-validation-delivery-artifact`, `team-review-delivery-artifact`, and
  `team-completion-gate`.
- Coding-related workflow / command entries must not imply that the Director
  must manually name a workflow before captain-led governance starts.
- Coding-related workflow / command entries must not allow implementation
  specialists to review their own work or write the main worktree directly.
- Coding-related workflow / command entries must require all four formal
  delivery artifacts for full team completion: implementation change delivery, memory
  delivery, review, and validation. Implementation change delivery artifacts must include
  `memory_impact`; memory/docs delivery artifacts must include `memory_impact`,
  `memory_delivery`, and a blocked, unverified, or closed-with-director-risk status when not
  complete; closed-with-director-risk is Director risk closure, not completion; review delivery artifacts and validation delivery artifacts must remain independent from
  the implementation specialist.
- High-risk release, deployment, or mutation skills must name their public
  trigger terms explicitly.
- Workflow and operational skills should not mix responsibilities.
- Team-Native specialist role skills should expose `metadata.relations` with
  `role_id`, `role_layer`, `parent_skill`, `support_skills`,
  `embedded_artifacts`, `artifact_contracts`, and `trace_contracts`.
- Team-Native governance text should distinguish `operation_mode: daily` from
  `operation_mode: full`; daily mode must not be used for full-only work or to
  claim full team completion.
