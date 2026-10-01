# Model Profile Routing

This is the sole Shared owner of model profiles and model-intent resolution.
The only profiles are `fast`, `balanced`, `deep`. Roles and workflow names do
not bind models. Platform adapters map intent to currently available models
and supported effort; Shared stores no platform model names or fixed
cross-platform effort equivalence.

## Four Assessment Factors

Assess Complexity, Uncertainty, Risk and Verifiability only. Use qualitative
evidence, not weighted scores, latency coefficients or failure-count formulas.

- Fast: narrow search, extraction, classification, summarization, deterministic
  evidence and straightforward bounded work with low complexity/uncertainty/risk
  and high verifiability. Straightforward coding is not categorically excluded.
- Balanced: default for ordinary bounded implementation, debugging, review,
  verification and reasoning when no special complexity/uncertainty warrants Deep.
- Deep: difficult architecture, uncertain root causes, complex security reasoning,
  difficult cross-module reasoning or competing design tradeoffs.

High action risk alone does not select Deep: a simple destructive command can
remain Balanced while requiring protected authorization and stronger verification.
Low verifiability calls for better evidence, independence or blocked/unverified
reporting; a stronger model alone does not repair the evidence gap.
Neither profile nor effort changes authorization, independence or verification.

This ordered table is a source-conformance contract for normalized evidenced
factors, not an NLP classifier. `*` means any value. Explicit user profile intent
is resolved separately; do not manufacture factor values to justify a preference.

<!-- MODEL_PROFILE_TABLE_START -->
| Complexity | Uncertainty | Risk | Verifiability | Profile |
|---|---|---|---|---|
| high | * | * | * | deep |
| * | high | * | * | deep |
| low | low | low | high | fast |
| * | * | * | * | balanced |
<!-- MODEL_PROFILE_TABLE_END -->

## User Intent And Available Choices

Distinguish a profile request (faster, stronger, deeper analysis) from an exact
named-model request. Preserve an exact request verbatim; do not replace it with
a profile or an allegedly equivalent model. An unspecified request defaults to
Balanced, not to a fixed role model. If profile intent conflicts with the task's
evidenced needs, surface the tradeoff without silently changing explicit intent.

For profile intent, a preferred model's unavailability permits another available
model or provider fitting the same profile when the platform allows it and the
existing capability/authorization scope admits it. Profile intent alone never
authorizes installation, login, credential access or launching an external AI
CLI/provider beyond the current approved platform, task and data scope.
For exact intent, unsupported model, incompatible effort or a known overriding
platform constraint makes resolution unavailable. Do not dispatch a substitute
as if it satisfied the request. An unknown override/effective model remains
unreported; report inability to guarantee the exact choice before relying on it.

## Minimal Resolution Evidence

Only when a selection needs recording, use `requested_profile`,
`requested_model`, `resolved_model`, `resolution_state`.
`requested_model` has a value only for an exact user request. `resolved_model`
is a reported model, `platform-default`, or `unreported`; a proposed payload
alone is not a reported applied model. Preserve the original request separately.
States are exactly `confirmed`, `unreported`, `unavailable`.

<!-- MODEL_RESOLUTION_TABLE_START -->
| Fact (first true wins) | Result |
|---|---|
| exact_unavailable | unavailable |
| exact_effective_mismatch | unavailable |
| effective_model_unreported | unreported |
| effective_model_verified | confirmed |
| otherwise | unreported |
<!-- MODEL_RESOLUTION_TABLE_END -->

`effective_model_verified` requires actual platform-reported or equivalently
verified effective-model evidence, matching the exact request when present.
For profile intent, it also requires evidence that the chosen model fits the
requested profile. Spawn success or an agent ID alone is unreported, never
confirmed. A platform fallback/mismatch must be disclosed; its result cannot
be represented as compliance with an exact request.

Platform references own current model precedence, callable fields, supported
effort and override limitations. Check the current version/schema at invocation;
do not infer current payload values from historical documentation. No
requested/accepted/applied lifecycle, universal receipt schema or timing model
is added. Legacy scoring remains inactive compatibility text only.
