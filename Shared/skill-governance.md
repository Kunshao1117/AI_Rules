# Skill Governance Contract


## General verification/review/completion ownership

General verification scope/independence, evidence selection and failure
classification belong only to `Shared/policies/verification-strategy.md`.
Review applicability and judgment belong to `Shared/policies/review-governance.md`;
general task completion belongs to `Shared/policies/completion-policy.md`.
These policies supersede old escalation, review-trigger and completion clauses
in this method/consumer. No Skill hit requires a role, full suite or Memory chain.
Task methods remain here; frozen Memory/legacy release retain their own contracts.

AI_Rules uses skills as an on-demand knowledge compression layer.
This file defines where governance content belongs.
That lets supported platforms share semantics without forcing every rule into always-on context.

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

Content is classified as Policy, Workflow, Agent, Skill, or Reference by its
actual responsibility, not its filename or current loader format. Memory
Subsystem is an independently frozen subsystem, represented as Memory in the
migration census; it is not a sixth general content type.
Agent roles now have the sole canonical registry `Shared/agents/_registry.md`.
They are not Skills. `agent-governance.md` owns assignment/independence and
`model-profile-routing.md` owns profiles. Legacy station Skills are compatibility
consumers, not general Team role definitions or required startup dependencies.
Memory, project context, and scripts have independent ownership boundaries.
Platform core, runtime copies, generated blocks, logs, and caches may cite or carry those homes, but they do not become competing governance sources.
`Shared/policies/load-semantics.md` separately owns when each content type is
loaded; this document still owns Skill identity and source classification.
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

- Purpose: Additional reusable specialist methods, domain knowledge, tool
  operation or procedures loaded on demand for a specific task.
- Put here: Specialized browser, security, testing and tool/domain methods.
- Do not put here: Global authorization, execution/Team routing, model choice,
  review/verification applicability, completion decisions, Agent identity,
  output-schema ownership or platform lifecycle. Cite the existing owner.
- A task's stage sequence belongs to Workflow; schemas, templates, command
  syntax and field catalogs belong to owner-linked Reference. A platform may
  transport either as SKILL.md without changing its architectural identity.

### Agent roles and references

- Agent roles own role boundaries and constraints in `Shared/agents/`; native
  Codex/Claude source projections consume them without fixing a model.
- References hold owner-linked catalogs, field tables, examples, and platform
  details; they are not independent authorization or activation gates.
- Follow `source-runtime-surface-map.md` for concrete placement, future consumer
  registration, and the frozen Memory compatibility consumers.

### vNext migration ownership

- Verification has independent axes: `verification_scope: focused | broad` and
  `verification_independence: direct | independent`. All four combinations are
  active in `Shared/policies/verification-strategy.md`; independence means
  judgment separation, not more tests. Review and completion have separate owners.
- `code-audit` has frozen disposition `PROJECT_DERIVED`, superseding
  `KEEP_BUT_REWRITE`. A4 moves its general methods to
  `Shared/policies/references/project-derived-verification.md`; its original
  tool-specific recipes remain compatibility-only. Verification policy selects
  evidence needs and scope; Capability Resolution selects eligible providers.
  Project declarations supply candidates, not readiness or new Skill creation.

### Classification freeze and migration reference

`policies/references/skill-architecture-disposition.md` freezes the complete
Phase 4B-1 migration map. It is a migration Reference, not a runtime registry
or new routing engine. `Shared/skills/_index.md` remains the current Skill
loader/routing registry, including retained compatibility entries until their
consumers can migrate safely. A policy navigation pointer is not a Skill row.
Count actual `Shared/skills/*/SKILL.md` files; report index omissions and empty
directories separately. Classification never repairs the frozen Memory index.

Every actual Skill has one disposition from this closed set:
KEEP_AS_SKILL, KEEP_BUT_REWRITE, MOVE_TO_AGENT, MOVE_TO_POLICY,
MOVE_TO_WORKFLOW, MOVE_TO_REFERENCE, MERGE_INTO_EXISTING, OPTIONAL_PACK,
PROJECT_DERIVED, RETIRE, DEFER_MEMORY_SUBSYSTEM, UNDECIDED.
Do not use a target Skill count as acceptance. UNDECIDED requires an explicit
unresolved decision and blocks that item's physical migration.

Classify the content question: rules/allowance => Policy; task stages =>
Workflow; responsibility identity => one of the existing six Agents;
specialized reusable method => Skill; schema/template/syntax => Reference.
Mixed files name preserved content and its owners without making a new role.
Frozen Memory Skills remain DEFER_MEMORY_SUBSYSTEM. High Memory/context
coupling requires preserved paths/anchors and defer-sensitive-migration for
persistent behavior, regardless of the non-Memory content's disposition.

Invocation classification is allowed, restricted or manual_only. Allowed
needs unambiguous task fit and low accidental cost; restricted needs narrow
explicit task semantics; release, expensive/mutating operations and Skill
creation default to manual_only. These are migration classifications, not
new runtime metadata or action permission. Provider-specific recipes record
presence needs, missing-provider behavior and no implicit install; provider
absence never erases the domain or supplies permission to install/login.

Before creating a Skill, check existing model competence, Policy, Workflow,
Agent, Reference, then an existing Skill with an added reference. Only a
remaining specialized reusable procedure with repeated demand or clear product
value justifies a new Skill. skill-factory is KEEP_BUT_REWRITE to implement
this admission order later; this phase does not rewrite its generation flow.

The frozen map preserves gitnexus-cli as KEEP_BUT_REWRITE in its Optional Pack,
code-audit as PROJECT_DERIVED, and structured-reasoning/code-diagnosis as RETIRE
after valuable methods have replacement owners. No generic AI CLI delegation
workaround returns. Phase 4B-1 performs no Skill move/delete/rename, Optional
Pack construction, sync, deployment or Memory/Context behavior change.

### Skill route classification

General entries select phase and task-specific methods; they do not mandate
station dispatch. Main implements ordinary work; independent responsibilities
use `agent-governance.md`. The station, board, handoff and artifact-chain clauses
in this classification are legacy compatibility-only for frozen consumers.
They cannot make a general skill hit create a Team, role or completion artifact.


Skills are route and procedure carriers. A skill match is a candidate route signal only.
It does not grant write authority, protected-action authority, station ownership, handoff completion,
artifact-chain completeness, or a completion state.

#### Entry skills

- Purpose: Start or classify a workflow route from Director intent.
- Examples: build, fix, test, commit-prep, handoff, and skill-forge workflow entries.
- Required boundary:
  - They may open the governed route and name applicable stations.
  - They do not authorize source writes or protected actions by themselves.
  - Current stage ownership follows canonical Policies and Agents. A frozen
    memory/docs packet resolves through its M3 legacy alias and transition
    Reference; no active station Skill is loaded for that old ID.

#### Station skills

- Legacy taxonomy only: the following `REFERENCE.md` paths are non-invocable
  compatibility documents, not current station Skills or routing entries.
- Purpose: Own one Team-Native station role or delivery artifact contract.
- Examples: `Shared/policies/references/legacy-skills/team-change-delivery-artifact/REFERENCE.md`, `Shared/policies/references/legacy-skills/team-validation-delivery-artifact/REFERENCE.md`,
  `Shared/policies/references/legacy-skills/team-review-delivery-artifact/REFERENCE.md`,
  `Shared/policies/references/legacy-skills/team-memory-docs-delivery-artifact/REFERENCE.md`, and
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
Pass relevant reference paths through the bounded assignment or task context;
frozen consumers retain their existing station handoff packet.
Do not keep shrinking text until role meaning changes.
Use the source-document size policy for size thresholds, PowerShell module signals, and reference split decisions instead of copying those rules into each skill.
Long-lived preferences should move into `.agents/context/**/CONTEXT.md`, not memory cards.
Stable context that becomes a repeatable procedure can be promoted to a project skill through the skill forge workflow.

## Boundary And Deduplication Defenses

Governance content must use the smallest durable home that still preserves the executable guard:

- Always-on core keeps short non-negotiable gates and cites shared policies for details.
- Shared policies keep cross-workflow contracts, precedence, and invalid patterns.
- Workflow entries keep route order, load gates, and task-specific evidence expectations.
- Skills keep specialized operational methods and tool recipes loaded on demand;
  artifact formats and catalogs have owner-linked References.
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
Root runtime copies under `.agents/`, `.claude/`, `.codex/`, `.cursor/`, or other
deployed targets are deployment outputs. `Codex/.codex/**` and the other
platform-prefixed templates are canonical source, not root runtime copies.
Generated markers remain generator-owned even inside canonical templates.
Local/user/global customization must not be overwritten from framework source.
Explicit emergency runtime repair does not change that ownership.
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

`support_skills` are references a handoff packet may load with the role.
For migrated A1/A2/A3/A4 IDs, `parent_skill`, `support_skills`, `required_skills` and
`loaded_skill_refs` resolve through
`Shared/policies/references/legacy-skill-migration.md` and its exact mapping
before any Skill invocation. Read their compatibility documents, preserving
original IDs and frozen packet/Memory semantics; never invoke them as Skills.
Other IDs continue through the active Skill registry. This legacy relation
example is not a second formal Agent registry.
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

Antigravity, Claude, Codex, and Cursor keep different entry shapes:

- Antigravity uses `.agents/workflows/*.md` as the user-facing entry.
- Antigravity uses `.agents/skills/` as operational knowledge.
- Claude uses `.claude/commands/*/SKILL.md` as Slash Command entries.
- Claude uses `.claude/skills/` as operational knowledge.
- Codex uses `.agents/skills/` for workflow skills.
- Codex also uses `.agents/skills/` for operational skills.
- Cursor uses `.cursor/skills/` for workflow skills.
- Cursor also uses `.cursor/skills/` for operational skills.
- Cursor uses `.cursor/rules/*.mdc` as the instruction-load entry.
- Descriptions must distinguish entry skills from helper skills.

Shared skills must remain platform-neutral.
Platform-specific workflow files may add a load gate pointing to the shared skill.
They should not duplicate the full playbook.

## Verification, Review and Completion ownership

Use `Shared/policies/verification-strategy.md` for scope, independence, evidence
selection and failure classification; `review-governance.md` for applicability
and independent review responsibility; `completion-policy.md` for five task
states. Truth facts live in status ontology. Methods remain in testing/browser/
quality Skills without owning triggers or task status. Phase 4B owns relocation.
Only frozen consumers use the original Team/Skill machinery below.

## Frozen verification/completion compatibility

The following original body is legacy compatibility-only for frozen Memory or
legacy release consumers. It is not a general vNext trigger, scope, roster,
completion ladder or status owner. Preserve original anchors and meanings;
never translate vNext states into its bundle, phases or receipts.

<!-- LEGACY_COMPLETION_COMPATIBILITY_START -->
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
do not activate Team. For the frozen legacy contract only, resolved
`execution_topology: delegated` allows interpretation of historical
`programming-team-governance` mechanics and child artifacts. It does not load
retired Skills for current work.

The following old child IDs identify frozen packet evidence after delegated
topology resolves; they are compatibility lookups, not active Skill loads:

- `team-role-boundaries`.
- `team-change-delivery-artifact`.
- `team-validation-delivery-artifact`.
- `team-review-delivery-artifact`.
- `team-completion-gate`.

Current Memory Review evidence uses
`Shared/policies/references/memory-review-evidence.md`. The old
`team-memory-docs-delivery-artifact` ID resolves only through its M3 legacy
alias and `legacy-memory-team-transition.md` for frozen consumers.

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


<!-- LEGACY_COMPLETION_COMPATIBILITY_END -->
## Team Field Ownership Contract

Team board, handoff, trace, and completion files may repeat a field name only to show how that field is consumed in that layer.
Canonical board-facing field names and value sets live in `Shared/policies/references/legacy-skills/team-task-board/references/board-field-catalog.md`.
Station startup payloads live in `Shared/policies/references/legacy-skills/team-station-handoff-packet/REFERENCE.md`.
Trace audit expectations live in `Shared/policies/team-trace-evidence.md`.
Completion consumes the artifact chain through `Shared/skills/team-completion-gate/SKILL.md`.
When a field such as `station_mode`, `context_visibility`, or `handoff_ownership` appears in more than one file, the local file must cite or consume the canonical value instead of redefining a competing catalog.
