# Capability Resolution

This is the sole Shared owner of provider discovery, readiness and selection.
It is a thin decision contract, not a runtime engine, registry, dispatch system,
or lifecycle. `execution-routing.md` owns Direct / Assisted / Team;
`authorization-resolution.md` owns observe / local_work / protected.
Capability != authorization; capability != execution mode.

## Providers And Responsibility

| Type | Source of capability |
|---|---|
| Platform-native | Current-session filesystem, search, terminal, browser/web, native helper and structured tools |
| Project-native | Declared package/repository scripts, Makefile, pyproject, Cargo, Go, .sln, compiler, linter, runner or project-local executable |
| Connected integration | Visible MCP, plugin, connector or structured API integration |
| Optional local tool / vendor CLI | Existing optional GitNexus, gh, wrangler, supabase, sentry-cli, terraform, aws, gcloud or other local tooling |

These provenance categories may overlap: an integration can launch a local
executable. Declaration is not installation; visible is not authenticated;
authenticated and ready are not mutation authorization. Inspect the relevant
execution chain, not just the outer tool name.
CLI, shell, terminal, browser and MCP are capabilities/providers, not workers,
Team members, independent reviewers, evidence branches or delegation routes.
An evidence branch is a genuinely separate worker/context used for independent
evidence or large intermediate-output isolation. Ordinary tool calls stay Direct.

## Lazy Discovery

Discover only providers relevant to a capability the task actually needs.
Do not scan unrelated vendor tools at startup or inventory the whole host.
These levels are safety limits, not a mandatory three-stage pipeline:

1. **Passive:** current tool schemas, manifests/scripts, already visible
   integration metadata, executable path resolution and file existence.
   Do not launch unknown third-party tools. Starting an MCP server to obtain
   its schema is not passive metadata inspection.
2. **Safe readiness probe:** only for a provider the task may actually use,
   after checking the probe's real behavior, authorization and platform limits.
   Version/status flags are not proof of no side effects. Discovery never
   authorizes login, init, configure, install, upgrade or account mutation.
3. **Functional probe:** only when the capability is needed and the probe itself
   is authorized with in-scope side effects. Use the smallest sufficient action;
   do not run a functional test merely to promote readiness. Collect-only,
   query and list labels do not guarantee non-mutation.

Check authorization and sandbox/permission before a probe and again for the
selected action. Do not inspect credentials to establish presence/readiness.

## Readiness

Evaluate against the current capability, target and environment, using evidence.
The following ordered predicates are source-conformance facts, not a runtime
classifier. `present` requires existence evidence; `sufficient` requires current
readiness evidence; `known_blocker` requires an observed constraint;
`checked_absent` means relevant discovery found no available provider.

| Predicate (first matching row) | Status |
|---|---|
| present & known_blocker | blocked |
| present & sufficient | ready |
| present | present_unverified |
| checked_absent | unavailable |

Unexamined is not unavailable: no matching predicate means no readiness record.
`present_unverified` covers unresolved version, auth, configuration, target,
project applicability or functional readiness. `blocked` reasons include known
permission, sandbox, auth, version, configuration or environment constraints.
Use `reason`, not another status enum. A provider gap is not a task-level gap
when a legal equivalent provider can supply the required evidence.

## Selection And Missing Providers

Hard filters below consume evidenced, normalized facts in order for one
candidate/action (source conformance only). `not_ready` includes a missing
provider; project declaration alone does not qualify as existing availability.

| Disqualifying fact (first matching row) | Decision |
|---|---|
| action_denied | stop_action |
| implicit_install_download_init | reject_provider |
| missing_authorization | reject_provider |
| platform_denied | reject_provider |
| capability_mismatch | reject_provider |
| project_version_mismatch | reject_provider |
| insufficient_evidence | reject_provider |
| out_of_scope_effects | reject_provider |
| external_ai_unrequested | reject_provider |
| not_ready | inspect_or_alternative |
| otherwise | eligible |

`out_of_scope_effects` includes unauthorized data egress. Any proposed probe
has its own facts and gates; `inspect_or_alternative` does not authorize probing.
Among eligible ready providers, compare project-native fit, evidence quality,
reliability, lower side effects/setup burden, material cost/latency and explicit
user preference. No transport priority or mathematical score applies.
Preferred != required. A preferred ready suitable GitNexus provider may win a
tie; preference cannot bypass authorization, make it mandatory, install it when
missing, block a reasonable alternative or justify claiming it was used.

Missing optional provider != permission to install. Seek existing legal
alternatives; use a reasonable equivalent and disclose material evidence limits.
Only when none exists and the gap affects the result, report the limitation.
Do not automatically request CLI installation. Legitimate project dependency
restoration remains governed by the authorization owner and user exclusions;
do not relabel a missing optional provider as a project dependency to install it.
An action-level denial stops that action across providers: no provider switch
may bypass it. A provider-specific unsupported function, with no action denial,
allows assessment of an otherwise authorized equivalent provider.

## Package Wrappers And External AI

`npx`, `npm exec`, `bunx`, `bun x`, `uvx`, `uv tool run`, `pipx run`,
`pnpm dlx`, `yarn dlx` and equivalents are not proof of a local executable.
Before execution inspect project declaration where applicable, actual executable
resolution, package/bin metadata, script/shim/hooks behavior and whether the
wrapper can download or create an environment. A manifest, lockfile, cached
package, absent global install or omitted confirmation flag is not enough.
Prefer an already resolved executable or inspected project script. Never run a
wrapper to see whether the package exists; possible download is not passive.

Generic AI-to-AI CLI fallback is retired. Missing native helpers must not launch
another AI provider automatically. An explicit request for another AI provider's
second opinion/comparison may use its already existing ready CLI, only with
in-scope data egress and native permission, without automatic install/login or
credential access. It is explicit external AI provider use, not generic fallback.

## Minimal Evidence And Ownership

When useful, express `capability`, `status`, `provider`, `evidence`, `reason`;
add `checked_at` only when freshness matters. Evidence must identify its target
within the current task context. Keep it transient; no mandatory object or
execution spec for every task, no Memory/Project Context writes or registry DB.
This does not alter any frozen Memory consumer or Memory write/commit contract.
The platform matrix records supported facts/limits, never session readiness.
Adapters map current tools/native configuration/returns; skills own domain
procedures and legitimate provider recipes, not duplicate provider governance.
