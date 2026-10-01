# Debug Investigation Methods

This is an on-demand method reference for Main's `07 Debug` workflow. It is not
a Skill, Agent, execution router, required report format or completion owner.
Use the portions that reduce uncertainty for the actual fault; ordinary small
debugging does not need a separate analysis stage or every item below.

## Define the symptom and reproduction boundary

Describe expected versus observed behavior, the first visible symptom, affected
inputs/users and known working cases. Bound reproduction by source revision,
command or interaction, environment/configuration, timing and recent changes.
Record what was reproduced and what remains reported but unobserved. Distinguish
logs, traces, tests and inspected source facts from inference and model prior.
Relevant existing Memory evidence remains under its unchanged read contract;
this method neither requires a Memory-first scan nor changes Memory semantics.

## Compare root-cause hypotheses

Form competing hypotheses when multiple causes remain plausible. For each,
identify supporting evidence, counter-evidence, assumptions and a discriminating
observation that would support or reject it. Rank likely fault surfaces by their
fit to the symptom, not by file count. Include known/unknown separation and
already ruled-out areas with the reason for exclusion. Repeated failure calls
for revisiting assumptions, scope or missing evidence, not a mandatory tool.

## Trace data, calls, state and boundaries

- Trace input to output through transformations, validation and storage. Check
  data types, null/error values and interface preconditions at each relevant edge.
- Follow the call-chain and dependency path between the first failing boundary
  and the reported symptom. Check imports/exports, callers, return values and
  error propagation; distinguish error origin from downstream symptoms.
- Inspect shared state, state transitions, asynchronous order, races, retries
  and resource lifetimes where timing can explain the failure.
- Compare contracts on both sides of an API, module, service or database
  boundary. Check relevant error handling, configuration and external interaction
  evidence rather than assuming source inspection proves runtime behavior.
- Cite concrete files/locations, snippets when useful and observed outputs for
  suspect areas. Inspect only the next relevant surface that can discriminate
  among hypotheses; do not require reading every tracked file or a numeric
  file/module threshold before narrowing scope.

## Reduce uncertainty and return evidence

Choose the smallest authorized observation or reproduction that can change the
leading hypothesis. Keep evidence and gaps explicit when runtime access is
missing. Avoid a premature fix before the cause is understood; do not patch a
downstream symptom as though it proved the root cause. Stop when evidence is
sufficient for the bounded diagnosis, or the remaining uncertainty and next
evidence need are clear. The existing workflow routes a confirmed repair to Fix.

A useful result explains symptom/reproduction, inspected scope, ranked suspects,
supporting/rejecting evidence, ruled-out areas, data/dependency/state paths,
root-cause judgment and limits. A written report is optional and requires
in-scope output authority; neither a CLI report nor a fixed filename is proof.
When a separate helper supplied preliminary evidence, Main assesses its actual
source/version coverage and supplements runtime/configuration blind spots.
Verification, review and completion remain with their canonical policies.

## Execution and optional providers

`Shared/policies/execution-routing.md` remains the sole mode owner. Main can do
small or multi-file Debug directly. A separate bounded search helper can be
Assisted when selected; many files, modules or broad reading alone do not create
Team or require a CLI worker. Team still needs a positive ownership/separation
trigger. No Diagnosis, Debug, Thinking or Analysis Agent is introduced.

GitNexus and Sequential Thinking are optional tools/methods, not Debug
prerequisites. `Shared/policies/capability-resolution.md` alone resolves provider
fit, readiness and applicable preference. A ready, fitting provider may be used;
missing or unavailable providers do not block ordinary source search and direct
reasoning. Do not automatically activate, analyze or install a provider, require
fixed thought counts, or change execution mode merely because a tool is used.
Existing GitNexus Skill methods remain unchanged and can be loaded when useful.
