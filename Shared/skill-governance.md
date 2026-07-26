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
That policy covers core, shared policies, `SKILL.md`, memory cards, PowerShell modules, and general source files.
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
- Put here: Build/fix/commit stage order and explicit load gates.
- Do not put here: Full implementation recipes shared across platforms, copied policy manuals, memory procedures, or script playbooks.

### Shared skills

- Purpose: On-demand operational knowledge.
- Put here: Repeatable procedures, team-station governance, tool playbooks, release steps, and test recipes.
- Do not put here: Non-negotiable safety rules that must apply before skill load.
- Reflection-like skills are narrow route gates. They must not replace workflow entries, `execution_spec`,
  implementation/change-delivery, review, validation, memory/docs, or completion gates.

### Skill route classification

Skills are route and procedure carriers. A skill match is a candidate route signal only.
It does not grant write authority, protected-action authority, station ownership, handoff completion,
artifact-chain completeness, or a completion state.

#### Entry skills

- Purpose: Start or classify a workflow route from Director intent.
- Examples: build, fix, test, commit-prep, handoff, and skill-forge workflow entries.
- Required boundary:
  - They may open the governed route and name applicable stations.
  - They do not authorize source writes or protected actions by themselves.
  - They must pass implementation, validation, review, memory/docs, and completion work to the matching station skills when those stages apply.

#### Station skills

- Purpose: Own one Team-Native station role or delivery artifact contract.
- Examples: `team-change-delivery-artifact`, `team-validation-delivery-artifact`,
  `team-review-delivery-artifact`, `team-memory-docs-delivery-artifact`, and
  `team-completion-gate`.
- Required boundary:
  - They become actionable only after a board row, handoff packet, station ownership,
    authorization phase, and file or evidence scope are resolved.
  - They may produce only their station-owned artifact.
  - They must not fill another station's validation, review, memory/docs, protected-action,
    or completion evidence.

#### Support skills

- Purpose: Provide reusable procedures, references, and tool guidance for an entry or station route.
- Examples: role-boundary, grounding, source-size, memory-ops, platform, and testing support skills.
- Required boundary:
  - They can inform station work or evidence collection.
  - They cannot replace a station handoff packet or station-owned delivery artifact.
  - They cannot convert a skill hit into authorization, protected mutation, or completion.

Skill descriptions and relation metadata should identify whether a skill is an entry skill,
station skill, or support skill when that distinction affects routing.
Completion gates must treat a bare skill trigger as `unverified` or `blocked` evidence until the
required station route, artifact chain, and language synthesis are present.

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

## Verification Ownership And Specialist Routing

`Shared/policies/verification-strategy.md` is the generic owner for
minimum-sufficient evidence selection, ordinary test admission, failure
classification, focused-versus-full boundaries, verification budget, and
Director-facing verification rendering. Load it whenever a route must choose
evidence, admit a durable test, classify a verification failure, or decide
whether a broader verification route is justified. It does not authorize a
write, protected action, or Team trace.

After that policy selects a specialized method, use only its narrow owner:

- `test-automation-strategy` for browser and visual evidence.
- `test-patterns` for unit and contract-test patterns.
- `impact-test-strategy` for regression impact and scoped regression design.
- `code-audit` for an explicit `deep-audit` or scoped deterministic scan.
- `quality-review-governance` for review lifecycle and procedure.
- `ai-dev-quality-gate` for high-change, UI, or real-runtime specialized evidence.
- `team-validation-delivery-artifact` and `team-review-delivery-artifact` only
  after delegated topology resolves.

These specialists do not become generic test-admission, evidence-budget,
full-suite, or failure-classification owners. A test label, failed check,
review obligation, or available tool alone does not select their method or
authorize execution. `deep-audit` is limited to the positive triggers in
`verification-strategy.md`; routine failure, lint, or regression does not
activate it.

`Shared/policies/execution-routing.md` resolves execution topology before any
Team mechanics load. Generic engineering verbs; source, policy, documentation,
multi-file, or multi-step work; skill availability; and generic governed labels
do not activate Team. Only resolved `execution_topology: delegated` activates
`programming-team-governance` Team mechanics and its child artifacts.

After delegated topology resolves, the shared skill defines the Team board,
role boundaries, evidence ownership, and delivery conditions. Platform workflow
entries adapt the applicable station evidence or change-delivery output to
native tools and load the applicable formal Team child skills:

- `team-role-boundaries`.
- `team-change-delivery-artifact`.
- `team-memory-docs-delivery-artifact`.
- `team-validation-delivery-artifact`.
- `team-review-delivery-artifact`.
- `team-completion-gate`.

All formal board, handoff, and `operation_mode` requirements in this section
apply only after delegated topology resolves. Their detailed selection triggers
remain owned by `Shared/policies/execution-routing.md`.

After delegated topology resolves, platform entries must preserve
`operation_mode`:

- `daily` is reduced Team-Native mode for routine low-risk evidence.
- `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, and specialist skill rewrites.
- `full` is also required for commit/release/deploy preparation or protected external-state readiness.

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
