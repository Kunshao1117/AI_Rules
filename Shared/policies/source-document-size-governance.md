# Source Document Size Governance

This policy governs size and split decisions for source-bearing documents and
code in AI_Rules.

Responsibility is the first governance gate.
Size is a second governance signal, not a line-count-only order to split a
cohesive file.
A file that exceeds the responsibility ceiling must split even when it is
small. A large file may remain only when its responsibility boundary is
cohesive and the category rule below permits a documented baseline or
rationale.

## Scope

Apply this policy before creating a new source-bearing file, growing an existing
one, or reviewing a change that adds large tables, procedures, rule catalogs, or
module internals.

This policy owns the size/split categories below:

- Core and platform core.
- Shared policy and reference documents.
- `SKILL.md` files.
- Memory cards.
- PowerShell scripts and modules.
- General source files.

Other governance files and skills should cite this policy instead of copying
its category rules.

## Source Responsibility Contract

This section is the canonical owner for source-file responsibility counting,
coupling evidence, and split-before-write behavior. Consumer skills and
delivery artifacts cite this section and must not redefine the rules.

### Responsibility identity

A responsibility is an independently changeable behavior or contract, not a
heading, folder name, or broad label. Two areas are separate responsibilities
when they have independent change triggers and at least one of these signals:

- different canonical owners or governing sources;
- different inputs, outputs, public contracts, persistent state, or lifecycle;
- different callers, consumers, deployment targets, or platform adapters;
- different failure modes or blocker conditions;
- different test setup, fixture, or acceptance entrypoints;
- the ability to release, replace, or repair one without changing the other.

Renaming selector, receipt reconciliation, and schema validation as one broad
"adapter governance" area does not merge their responsibilities. Review
classifies the actual functions, outputs, consumers, change triggers, and test
boundaries instead of accepting the author's labels at face value.

### One default, two maximum

One responsibility is the default for every source-bearing file.
Two responsibilities are the hard ceiling and are allowed only when all of
these strong-coupling conditions are present:

1. Both responsibilities point to the same named public contract, state
   machine, or generated boundary.
2. At least one named invariant or acceptance case requires both
   responsibilities to change atomically.
3. The declaration names concrete harm caused by splitting, such as duplicated
   mutable state, a circular dependency, broken generated parity, or loss of a
   compatibility entrypoint.
4. Independent review records `coupled-second-accepted`.

Same folder, similar naming, shared helpers, convenience, or a claim that two
areas are often edited together is not strong-coupling evidence.

A third responsibility is always `split-required`. The change must stop before
writing that responsibility and resolve an exact split delta through the
operator-first scope-expansion gate. Existing oversized baselines do not allow
a touched file to add or absorb a third responsibility.

### Required change declaration

Before writing a source-bearing file, change delivery records:

```text
responsibility_inventory:
  - responsibility_id:
    change_trigger:
    contract_or_output:
    validation_ref:
responsibility_count:
second_responsibility_coupling:
  named_boundary:
  atomic_invariant_ref:
  split_harm:
third_responsibility_split_gate:
responsibility_split_delta_ref:
```

`responsibility_count` must equal the inventory length. For one responsibility,
the coupling object and split delta are `not-applicable`. For two
responsibilities, the coupling object is complete and review still decides
whether the evidence is convincing. For three or more responsibilities,
`third_responsibility_split_gate` is `split-required` and
`responsibility_split_delta_ref` names the exact unresolved or approved split
request.

The canonical review dispositions are `single`,
`coupled-second-accepted`, `split-required`, and `unverified`.
Change delivery may propose an inventory and coupling evidence, but it cannot
self-award a review disposition. Completion consumes the independent review
result and must not recalculate responsibility semantics.

### Mechanical and semantic boundary

Static validation may check field presence, inventory uniqueness, count
agreement, required evidence shape, canonical references, allowed disposition
values, and source/deployed parity. It must emit
`semantic-review-required` rather than claim that a regex or line counter
understands responsibility semantics.

Independent review decides the real responsibility count, detects broad labels
that conceal multiple change triggers, judges strong coupling, and verifies
that a proposed split improves ownership, dependency, and test boundaries.

## Category Rules

### Core And Platform Core

Core files keep always-on gates, source-of-truth references, and protected
minimums.

Move long playbooks, field catalogs, examples, and tool recipes to shared
policies, references, or skills.
Do not use core files as a bypass when a shared policy or skill is the smaller
durable home.

Measurable signals:

- Over 250 lines: report size/split impact when touched.
- Over 500 lines: require a baseline note or split rationale.
- Over 800 lines, or growth of more than 100 lines in one change: require a
  split plan when any split signal below is present.

Core split signals:

- A field catalog, status catalog, phase registry, protected-action list,
  scenario catalog, or generated template block is embedded in the core.
- The same rule is repeated in a shared policy, platform core, workflow entry,
  and skill.
- The section contains operational procedure steps better owned by a loaded
  skill or reference.
- A generated/runtime copy block is mixed with canonical source policy.

### Shared Policy And Reference Documents

Shared policies own cross-workflow contracts, precedence, invalid patterns, and
required evidence.

Reference files own examples, scenario catalogs, field tables, and long
procedures.
When a shared policy starts mixing a contract with a playbook, split the
playbook into a reference file and keep the policy as the routing contract.

Measurable signals for shared policies:

- Over 350 lines: report size/split impact when touched.
- Over 600 lines: require a baseline note or split rationale.
- Over 900 lines, or growth of more than 150 lines in one change: require a
  split plan when any split signal below is present.

Measurable signals for reference files:

- Over 500 lines: report size/split impact when touched.
- Over 900 lines: require a baseline note or split rationale.
- Over 1,200 lines, or growth of more than 200 lines in one change: require a
  split plan when responsibilities mix.

Shared policy/reference split signals:

- A status ontology, completion state machine, authorization phase registry,
  protected-action registry, hook event matrix, exception registry, or platform
  copy map is redefined instead of cited.
- One document reaches a third responsibility under the Source Responsibility
  Contract, such as execution field shape plus scenario playbooks plus
  generated templates.
- A policy contains long example catalogs where a reference file would preserve
  the contract more clearly.
- A reference becomes authoritative for a policy decision without a policy file
  naming it as owner.
- Test, hook, runtime, generated-copy, and source-governance responsibilities
  are mixed without a clear owner boundary.

### `SKILL.md`

`SKILL.md` remains the L2 operational contract.
Keep it under 500 lines and under a 5,000-token estimate.

Move long examples, templates, lookup tables, scenario catalogs, and tool
recipes into `references/`.
The main `SKILL.md` must keep the trigger, procedure, gotchas, constraints, and
reference load instructions.

### Memory Cards

Memory cards store source-backed project facts and decisions, not generic
procedures.

Use the memory-card counters, `needsCompaction`, and memory workflow rules for
compaction, archive, or split decisions.
Do not grow memory cards to host reusable policy or skill procedures.

### PowerShell Scripts And Modules

This category covers `Scripts/*.ps1`, `Scripts/**/*.ps1`, and
`Scripts/modules/*.psm1`.

For `Scripts/modules/*.psm1`, line count is a split signal, not a hard failure:

- Over 800 lines: report size/split impact when touched.
- Over 1,500 lines: require a baseline note or split rationale.
- Over 2,500 lines, or growth of more than 300 lines in one change: require a
  split plan when any split signal below is present.

Split signals:

- Multiple independent responsibilities change for different reasons.
- Public interface, exports, command routing, and internal implementation are
  tangled in the same region.
- Tests need unrelated setup because unrelated behaviors share state or
  side effects.
- Rule loading, execution, reporting, persistence, and UI/operator output are
  mixed without a stable boundary.
- Recent or expected work repeatedly touches unrelated regions of the module.

Existing oversized modules can be baselined during the first governance batch.
The baseline is not a blocking failure by itself.
It becomes blocking when a new change adds a second responsibility without
accepted coupling, reaches a third responsibility, worsens public-interface
mixing, or makes isolated testing harder.

### General Source Files

General source files follow the local `code-quality` skill thresholds and the
project's established architecture.

Apply the Source Responsibility Contract before local line thresholds.
Use size as a review trigger only after the responsibility gate clears.
Split when the responsibility ceiling requires it or when a behavior, domain,
adapter, public interface, or test boundary becomes clearer after the split.

## Reporting Contract

Change delivery, review, validation, build, and fix workflows report
size/split impact when a touched file crosses a category rule or adds a new
large source-bearing document.

Report these fields when applicable:

- Responsibility inventory and declared count.
- Second-responsibility coupling evidence or `not-applicable`.
- Third-responsibility split gate and exact delta reference.
- Independent `responsibility_review_disposition`.
- Category: one of this policy's category names.
- Current size and delta when line counts are available.
- Baseline, no-impact, split-needed, split-plan-needed, or not-applicable.
- Split signal, if any.
- Source/deployed pair and parity evidence when a runtime copy exists.

Review checks the real responsibility count and coupling evidence before it
checks new oversized files, duplicated policy text, and rules stuffed into
core or skills instead of references.

Validation may run a dedicated responsibility-contract and size-governance
check when one exists.
When no tool exists, a non-mutating manual classification using the touched
files and this policy is valid validation evidence.
