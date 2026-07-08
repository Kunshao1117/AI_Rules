# Skill Governance Contract

AI_Rules uses skills as an on-demand knowledge compression layer.
This file defines where governance content belongs.
That lets three platforms share semantics without forcing every rule into always-on context.

Workflow entries and team skills reference `Shared/policies/workflow-orchestration.md` for sequence semantics.
They do not copy the full board, wave, channel, and completion playbook into every skill.
Language and audience-layer classification is governed by `Shared/policies/language-governance.md`.
That policy covers skills, triggers, handoffs, memory text, and generated documentation.
Skills cite that policy instead of treating a platform core rule as their only source.
External grounding is governed by `Shared/policies/grounding-governance.md`.
That policy covers outside facts, source type, freshness sensitivity, and no-evidence claim boundaries.
Skills and workflow entries cite that policy instead of embedding research or verification playbooks.
Source-document size and split decisions are governed by `Shared/policies/source-document-size-governance.md`.
That policy covers core, shared policies, `SKILL.md`, memory cards, PowerShell modules, audit rule packs, and general source files.
Source/runtime/generated surface classification is governed by `Shared/policies/references/source-runtime-surface-map.md`.
That reference expands the repository surface map while `Shared/policies/references/platform-copy-map.md` keeps the compact copy-role and sync-direction values.

## Skill Placement Contract

Layer meanings:

Operational governance content has five durable homes: policies, skills, workflow entries, memory cards, and scripts.
Platform core, runtime copies, generated blocks, logs, and caches may cite or carry those homes, but they do not become competing governance sources.
Memory cards must not carry governance rules.
Scripts must not embed large governance manuals.
Workflow entries must not copy full policy manuals.

### Core rules

- Purpose: Always-on safety baseline.
- Put here: Scope-bound intent signals, protected gates, no silent install, no blanket staging, and protected project identity.
- Do not put here: Long playbooks, tool recipes, or examples.

### Shared policies

- Purpose: Cross-platform governance contracts.
- Put here: Ownership boundaries, precedence, authorization semantics, source/deployed sync, and trace expectations.
- Do not put here: Workflow-specific recipes, long examples, or platform-only implementation details.

### Workflow / command entry

- Purpose: Task routing and lifecycle phase selection.
- Put here: Build/fix/commit/audit stage order and explicit load gates.
- Do not put here: Full implementation recipes shared across platforms, copied policy manuals, memory procedures, or script playbooks.

### Shared skills

- Purpose: On-demand operational knowledge.
- Put here: Repeatable procedures, team-station governance, tool playbooks, release steps, and test recipes.
- Do not put here: Non-negotiable safety rules that must apply before skill load.
- Reflection-like skills are narrow route gates. They must not replace workflow entries, `execution_spec`,
  implementation/change-delivery, review, validation, memory/docs, or completion gates.

### Memory

- Purpose: Project-specific facts and decisions.
- Put here: Current architecture, version choices, repo lessons, and module ownership.
- Do not put here: Governance rules, generic procedure that should apply to many projects, workflow gates, reusable script manuals, or platform policy copies.

### Scripts and automation

- Purpose: Deterministic executable mechanics.
- Put here: Small checks, transforms, sync helpers, wrappers, and validators that consume policies, skills, or references.
- Do not put here: Large governance manuals, rule catalogs, workflow handbooks, memory schemas, or human-readable policy authority.

### Project context

- Purpose: Long-lived project preferences.
- Put here: Design DNA, product preferences, technical preferences, communication preferences, and acceptance preferences.
- Do not put here: Source ownership, stale tracking, or executable procedures.

Rules that must be obeyed even when no skill triggers stay in core rules.
Details that are only needed for a task should move into Shared skills or their references.
Shared policies are the home for reusable governance contracts.
Those contracts must be available to multiple workflows, skills, or platforms.
Those contracts are too detailed for always-on platform core.
Platform core files may cite those policies.
They must not absorb policy playbooks, field catalogs, scenario examples, or tool recipes.
Language output gates belong in `Shared/policies/language-governance.md`.
External grounding gates belong in `Shared/policies/grounding-governance.md`.
Source-document size/split gates belong in `Shared/policies/source-document-size-governance.md`.
Workflow entries, skills, and matrices may name gate position, source type, freshness sensitivity, and missing-evidence state.
They must not copy the full policy procedure.
When a skill grows beyond the quality gate, split stable details into `references/`.
Do the same when a skill begins compressing multiple role identities into one file.
Pass the relevant reference paths through the station handoff packet.
Do not keep shrinking text until role meaning changes.
Use the source-document size policy for size thresholds, PowerShell module signals, and reference split decisions instead of copying those rules into each skill.
Long-lived preferences should move into `.agents/context/**/CONTEXT.md`, not memory cards.
Stable context that becomes a repeatable procedure can be promoted to a project skill through the skill forge workflow.

## Boundary And Deduplication Defenses

Governance content must use the smallest durable home that still preserves the executable guard:

- Always-on core keeps short non-negotiable gates and cites shared policies for details.
- Shared policies keep cross-workflow contracts, precedence, and invalid patterns.
- Workflow entries keep route order, load gates, and task-specific evidence expectations.
- Skills keep operational procedures, artifact formats, tool recipes, and references loaded on demand.
- Memory keeps source-backed project facts and active constraints.
- Scripts keep executable mechanics only and cite their governance source instead of embedding the manual.
- Project context keeps long-lived preferences and design or acceptance DNA.

If a paragraph duplicates a canonical policy, replace it with a reference.
Keep it only when the local file owns a stricter rule.
A more specific local rule may also remain in place.
Move examples, scenarios, field catalogs, or platform recipes into `references/` when they make a policy hard to scan.
Apply the same rule when they make a skill hard to scan.
You may also cite the existing canonical source.
Condensing is valid only when these safeguards remain executable:

- MUST rules, forbidden shortcuts, required evidence, and blocked states.
- Source/deployed sync obligations.
Do not shorten a file by deleting the guard that made the rule enforceable.

## Existing Change Integration Defense

Read the current diff before editing a dirty governance, workflow, skill, memory, or context file.
The change owner must also read the target section from the file, then integrate with the still-valid parts.
Valid integration edits rewrite or merge the target section.
Invalid edits add a parallel section, repeat the same rule under a new heading, or create a sidecar file.
They cannot avoid the dirty section.
Invalid edits also include overwriting another change without evidence that it is obsolete.
If the existing diff conflicts with the requested change, stop as blocked or ask for a scope decision.
Do not hide the conflict in another patch.

## Source/Deployed Pair Contract

Shared governance sources live under `Shared/` in the framework source tree.
Runtime copies under `.agents/`, `.claude/`, `Codex/.codex/`, or other deployed targets are deployment outputs.
The exception is a task that explicitly names them as the source repair target.
Governance, workflow, skill, and public-contract changes must record the source/deployed pair strategy before completion:

- Source-first is the normal path.
- Runtime copies are synchronized after the source change through a scoped deploy, generated-copy sync, or change-application gate.
- Generated output is not an authority source; repair the generator or source policy, then regenerate or mark parity unverified.
- Deployed-first emergency repair must be backfilled to source before it can be complete.
- Updating only a deployed copy is an invalid completion for framework-level governance.
- Missing parity evidence is blocked or unverified, not a harmless warning.

Use `Shared/policies/references/source-runtime-surface-map.md` to classify `source`, `runtime`, `generated`, `legacy`, and `local-customization` surfaces before deciding the repair order.
Legacy and local customization surfaces may be preserved as local behavior, but they do not define reusable governance unless a source backfill is explicitly scoped.

## Skill Relation Metadata

agentskills.io compatibility still depends on `name` and `description`.
AI_Rules may add optional `metadata.relations` for machine-checkable skill trees.
Missing relations are not a generic skill failure.
Team-Native specialist role skills still use them as governance evidence.

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
`embedded_artifacts` are role-owned evidence formats that do not need a separate artifact skill.
`artifact_contracts` are external delivery or completion contracts.
`trace_contracts` point to the shared trace and handoff evidence rules.
They avoid repeating long trace field lists inside every role skill.

## Skill Trigger Contract

Codex primarily sees `name` and `description` before a skill is loaded.
A skill that depends on automatic triggering must put trigger language in frontmatter.
Body text alone is not enough.

Required description behavior:

- Include the task domain in English and Traditional Chinese.
- Include real user wording, for example "重新打包", "同步 Release", "update reminder".
- Use `Use when:` in the description for positive triggers.
- Use `DO NOT use when:` for operational skills.
- Use it for neighboring skills that are easy to confuse.
- Keep body-level trigger sections as explanation only; they are not a trigger substitute.

## Platform Entry Contract

Antigravity, Claude, and Codex keep different entry shapes:

- Antigravity uses `.agents/workflows/*.md` as the user-facing entry.
- Antigravity uses `.agents/skills/` as operational knowledge.
- Claude uses `.claude/commands/*/SKILL.md` as Slash Command entries.
- Claude uses `.claude/skills/` as operational knowledge.
- Codex uses `.agents/skills/` for workflow skills.
- Codex also uses `.agents/skills/` for operational skills.
- Descriptions must distinguish entry skills from helper skills.

Shared skills must remain platform-neutral.
Platform-specific workflow files may add a load gate pointing to the shared skill.
They should not duplicate the full playbook.

Coding workflows should route through `programming-team-governance` when they touch these areas:

- Source, tests, debugging, audit, commit preparation, handoff, or skill creation.
- Workflow rules, source memory, or governance decisions.

The shared skill defines the captain trigger gate, captain team board, role exclusivity, and station board.
It also defines read-only evidence branch boundary, isolated change delivery boundary, and direct exception contract.
It also defines evidence owner field and completion condition.
It also defines the fake-team guard.
Platform workflow entries only load the shared skill.
They adapt station evidence or change delivery output to native tools.
Platform entries must load the formal team child skills when applicable:

- `team-role-boundaries`.
- `team-change-delivery-artifact`.
- `team-memory-docs-delivery-artifact`.
- `team-validation-delivery-artifact`.
- `team-review-delivery-artifact`.
- `team-completion-gate`.

Platform entries must also preserve governed Team startup semantics:

- Governed Director requests activate Team mode without a fixed phrase.
- No-write work uses a formal-readonly board when it can influence later source work.
- Write work uses a formal-write board after authorization resolution binds a scope-bound Director intent signal.
- Every formal station receives a handoff packet with loaded skill refs and startup monitoring fields.

Platform entries must preserve `operation_mode`:

- `daily` is reduced Team-Native mode for routine low-risk evidence.
- `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, and specialist skill rewrites.
- `full` is also required for Doctor/Audit changes, commit/release/deploy preparation, or protected external-state readiness.

Platform entry load gates must distinguish always-required route context from conditional platform context:

- Workflow route row, workflow orchestration, and Director-facing language governance are always required for governed broad evidence, source-impacting work, or completion language.
- Platform capability matrix loading is conditional when platform adapter behavior, tool capability, permission surface, evidence limits, source-impacting work, protected phases, or log-write capability affects the route.
- Do not mark platform capability loading as always-required unless every phase in that entry genuinely needs platform translation.

Platform entries must not weaken the shared contract.
They must not replace required delivery artifacts with generic main-thread handling.
Those artifacts are implementation change delivery, memory delivery, review, and validation delivery artifacts.

## Team Field Ownership Contract

Team board, handoff, trace, and completion files may repeat a field name only to show how that field is consumed in that layer.
Canonical board-facing field names and value sets live in `Shared/skills/team-task-board/references/board-field-catalog.md`.
Station startup payloads live in `Shared/skills/team-station-handoff-packet/SKILL.md`.
Trace audit expectations live in `Shared/policies/team-trace-evidence.md`.
Completion consumes the artifact chain through `Shared/skills/team-completion-gate/SKILL.md`.
When a field such as `station_mode`, `context_visibility`, or `handoff_ownership` appears in more than one file, the local file must cite or consume the canonical value instead of redefining a competing catalog.

## Doctor Expectations

Skill quality checks should treat trigger quality as a first-class signal:

- A short or generic description is a warning.
- Body-only `Use when` guidance without description triggers is a warning.
- Operational Shared skills without both English and Traditional Chinese trigger terms are a warning.
- Operational Shared skills without a negative boundary are a warning.
- Skills that copy long size tables, rule catalogs, or module split playbooks instead of citing `source-document-size-governance.md` are a warning.
- Workflow / command entries must describe when the workflow should start.
- They must not only describe what the workflow does internally.
- Coding-related workflow / command entries must expose the team-station board requirement.
- Use a load gate or equivalent grounding section.
- That section must include captain trigger, evidence owner, role boundary, direct exception, and completion condition.
- That section must also state that all-direct evidence boards are invalid without concrete exceptions.
- Coding-related workflow / command entries must load the six formal team child skills when applicable.
- The six skills include `team-role-boundaries`, `team-change-delivery-artifact`, and `team-memory-docs-delivery-artifact`.
- They also include `team-validation-delivery-artifact`, `team-review-delivery-artifact`, and `team-completion-gate`.
- Coding-related workflow / command entries must not imply that the Director must manually name a workflow.
- This applies before captain-led governance starts.
- Coding-related workflow / command entries must not allow implementation specialists to review their own work.
- Coding-related workflow / command entries must not allow implementation specialists to write the main worktree directly.
- Coding-related workflow / command entries must require all four formal delivery artifacts for full team completion.
- The four artifacts are implementation change delivery, memory delivery, review, and validation.
- Implementation change delivery artifacts must include `memory_impact`.
- Memory/docs delivery artifacts must include `memory_impact` and `memory_delivery`.
- Incomplete memory/docs delivery artifacts need a blocked, unverified, or closed-with-director-risk status.
- `closed-with-director-risk` is Director risk closure, not completion.
- Review delivery artifacts and validation delivery artifacts must remain independent from the implementation specialist.
- High-risk release, deployment, or mutation skills must name their public trigger terms explicitly.
- Workflow and operational skills should not mix responsibilities.
- Team-Native specialist role skills should expose `metadata.relations`.
- Required relation fields are `role_id`, `role_layer`, `parent_skill`, and `support_skills`.
- Required relation fields also include `embedded_artifacts`, `artifact_contracts`, and `trace_contracts`.
- Team-Native governance text should distinguish `operation_mode: daily` from `operation_mode: full`.
- Daily mode must not be used for full-only work or to claim full team completion.
