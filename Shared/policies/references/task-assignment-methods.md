# Task Intake, Impact And Bounded Assignment Methods

This reference preserves methods from the retired intent/scope/delegation
Skills. Main owns intake and scope; `requirement-precision.md` and its existing
schema own the task contract. `agent-governance.md` owns assignments. This is
not a trigger, role registry, mandatory output schema or authorization source.

## Requirement replay and drift

Read the current request and approved constraints. Restate the desired outcome,
identify explicit non-goals, extract observable acceptance and spot ambiguity
or contradictions. Distinguish explicit requirements from inference; an
implementation preference is not automatically a requirement. Use the existing
Compact/Extended contract as applicable, without adding a second field catalog.

Challenge an assumption when contrary evidence changes feasibility, scope,
acceptance, cost or user impact. Present the observed fact, potential problem
and bounded recommendation. Label inference; do not object merely for ceremony.
For a consequential decision, preserve accepted/rejected/deferred alternatives,
tradeoffs, reversibility and supporting evidence in the existing workflow record.

Compare request, accepted plan, actual changes and evidence. Explain justified
deviations; identify unauthorized changes or unverified acceptance rather than
silently redefining success. Requirement IDs and acceptance traces, when already
used, stay owned by the requirement schema. Do not create an Intent Agent.

## Architecture alternatives and evidence

Main and an assigned Architect can use this method when a Blueprint has a real
design choice or uncertain boundary. A simple architecture question needs no
extra reasoning stage, tool or checklist. For a consequential choice:

- State the decision, desired behavior, constraints and must-preserve interfaces.
  Separate observed facts and source evidence from inference and assumptions.
- Form viable alternatives, including retaining the current design when useful.
  Compare their trade-offs against the actual constraints: correctness, coupling,
  compatibility, migration, reversibility, operational cost and evidence gaps.
  Do not manufacture alternatives merely to reach a fixed option count.
- Check assumptions against inspected source, contracts or relevant external
  evidence. Seek counter-evidence that would reject the preferred option and
  competing hypotheses that explain the same observations differently.
- Name unresolved uncertainty and the smallest discriminating check that could
  change the decision. Revise or reject an option when contrary evidence warrants
  it. Distinguish a supported rationale from a provisional inference.
- Stop when evidence is sufficient for the bounded decision, or report the
  specific missing evidence that prevents it. Return the selected/rejected
  alternatives, decision rationale, remaining risks and compatibility limits in
  the existing Blueprint record; no new mandatory schema or thought log is added.

Sequential Thinking (`sequentialthinking`) is an optional tool if task fit and
current readiness support it under `Shared/policies/capability-resolution.md`.
Do not automatically activate or install it. Its absence does not block analysis;
its use sets no fixed thought count and does not change execution mode. Main can
reason directly. Execution routing remains with its existing canonical policy.
Fault-specific hypothesis methods are in `debug-investigation-methods.md`.

## Scope and impact mapping

Start with the allowed scope and current changes. Search affected callers,
policy/Skill references, workflows, copied/generated files and documentation.
Distinguish direct dependencies from historical mentions and protected surfaces.
Map the regression surface to observable workflows, commands, tests and UI paths.
Name searched and unreadable areas, uncertainty, minimal safe implementation
scope and relevant evidence. Memory/context attribution is not write permission.
Avoid adjacent refactors without evidence of impact. Specialized regression
methods remain in `Shared/skills/impact-test-strategy/SKILL.md`; no Scope Agent
or automatic testing cascade is introduced.

## Bounded assignment wording

After execution routing selects an applicable helper/Team role, formulate one
concrete question or deliverable. Name inputs, source version, exact read/write
scope, exclusions, expected evidence and stop condition using the existing
Agent assignment contract. State dependencies so parallel work does not consume
unfinished output. Preserve requested model intent through model-profile routing
and use the actual native adapter schema. Returned evidence must match the
assigned source version. No generic AI CLI delegation, fixed board, station
lifecycle, provider selection or completion chain is supplied by this method.
