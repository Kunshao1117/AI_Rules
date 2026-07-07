# Source Document Size Governance

This policy governs size and split decisions for source-bearing documents and
code in AI_Rules.

Size is a governance signal.
It is not a line-count-only order to split a cohesive file.
Splitting is required only when size combines with responsibility, public
interface, or test-isolation risk.

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
- Audit rule packs.
- General source files.

Other governance files and skills should cite this policy instead of copying
its category rules.

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
- One document owns more than two unrelated responsibility areas, such as
  execution field shape plus scenario playbooks plus generated templates.
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
It becomes blocking when a new change expands responsibilities, worsens public
interface mixing, or makes isolated testing harder.

Large audit modules such as `Audit.psm1` should move toward a facade plus
internal partials:

- Keep stable public commands, exports, and compatibility routing in the facade.
- Move private implementation by responsibility into internal module files.
- Split rule loading, scan execution, reporting, and helper utilities by
  testable boundary.

This policy does not prescribe the full refactor playbook.
Architecture and implementation workflows own the detailed split plan.

### Audit Rule Packs

Audit rule packs, diagnostic catalogs, and evidence matrices should split by
rule family, workflow phase, evidence surface, or platform adapter.

Do not bury large rule data inside orchestrators, platform core, or a generic
utility module.
When a rule pack grows because new rule families are added, prefer a new
reference or rule-pack file over appending another unrelated section.

### General Source Files

General source files follow the local `code-quality` skill thresholds and the
project's established architecture.

Use size as a review trigger.
Split only when a behavior, domain, adapter, public interface, or test boundary
becomes clearer after the split.

## Reporting Contract

Change delivery, review, validation, audit, build, and fix workflows report
size/split impact when a touched file crosses a category rule or adds a new
large source-bearing document.

Report these fields when applicable:

- Category: one of this policy's category names.
- Current size and delta when line counts are available.
- Baseline, no-impact, split-needed, split-plan-needed, or not-applicable.
- Split signal, if any.
- Source/deployed pair and parity evidence when a runtime copy exists.

Review checks for new oversized files, duplicated policy text, and rules stuffed
into core or skills instead of references.

Validation may run a dedicated size-governance check when one exists.
When no tool exists, a non-mutating manual classification using the touched
files and this policy is valid validation evidence.
