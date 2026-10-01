# Cloudflare Provider Facts and Operation Effects

Provider Reference for cloudflare-ops, not a Skill, runtime, execution mode or
new authorization system. Consult only the relevant product section. Public
provider facts checked 2026-09-15; actual version/schema and target still matter.

## Owners, identity and readiness

`Shared/policies/capability-resolution.md` owns provider selection/readiness;
`Shared/policies/authorization-resolution.md` owns semantic authority. A binary's
presence or successful login does not prove the intended operation is ready or
authorized. Resolve account/profile, project/config, resource name/ID, environment,
local/remote location and exact effect. Unknown identity stops remote mutation.

Use `Shared/policies/references/credential-boundary-contract.md` for credentials.
Do not read tokens, secret values or credential stores into model context, samples
or logs. No automatic login, account/profile switch, profile creation, MCP config,
token creation or host installation. `wrangler auth token` exposes credentials;
it is not a harmless readiness probe. Missing providers permit appropriate
authorized public/read alternatives, not a private-access or action-denial bypass.

Execution, Agent/model, verification, review and completion remain with
`Shared/policies/execution-routing.md`, `Shared/policies/agent-governance.md`,
`Shared/policies/model-profile-routing.md`, `Shared/policies/verification-strategy.md`,
`Shared/policies/review-governance.md` and `Shared/policies/completion-policy.md`.
Memory lifecycle is frozen; no profile/login/readiness/credential persistence in
Memory / Project Context. Provider recipes do not change these owners.

## Wrangler selection, setup and local development

Use an existing inspected executable or project script. Never use `npx wrangler`
or another downloading wrapper to probe presence. Inspect script/build effects
before execution. Missing config does not authorize init, setup or deployment.

Current [Workers commands](https://developers.cloudflare.com/workers/wrangler/commands/workers/)
document init via C3 with default dependency installation and optional deployment;
deploy without config can configure the project. Deploy --temporary still creates
or reuses a remote preview account and deploys: no automatic fallback for missing
auth. --install-skills and provisioning options can add setup/resource effects;
never enable them implicitly or treat dry-run as a universal zero-effect guarantee.

Local source/config editing is a local_work candidate within the requested scope,
separate from invoking tools. Inspect builds, bindings and outbound calls before
local development. Current wrangler dev uses local execution; remote bindings can
still reach cloud data. --local disables remote bindings, while --remote uses
remote resources. Even local execution can send network requests or download
images/dependencies; neither localhost nor a dry-run label grants that authority.

[Environments](https://developers.cloudflare.com/workers/wrangler/environments/)
select configuration/resource bindings, not an authorization class. Explicitly
resolve config/cwd/environment and resource IDs; staging is still remote when
hosted. Vite integration selects its environment at dev/build time through
CLOUDFLARE_ENV; do not blindly apply a Wrangler --env assumption to every adapter.

[Authentication profiles](https://developers.cloudflare.com/workers/wrangler/profiles/)
are separate from deployment environments. Current resolution prefers an API
token override, then --profile, nearest activated directory, then default login;
--config affects directory resolution. One profile can reach multiple accounts.
Confirm the non-secret target evidence, without inspecting token values. Profile
flags have command exceptions; do not infer whoami selected the target of a later
operation. The account must match config/explicit target and allowed access;
do not auto-activate another profile or choose another account after a failure.

## Product effect examples

These are descriptive examples, not an executable routing table or full catalog.
Flags/defaults vary by product/version; inspect actual config and call semantics.
Remote observation is an external connection, not automatically remote mutation.

| Product/action | Location/effect | What to distinguish |
|---|---|---|
| Worker source/config edit | Local source change | Does not upload, activate or authorize deployment. |
| dev / local build | Local processes/files, possibly network/build effects | Inspect bindings, build scripts and image acquisition; remote data access stays remote. |
| deploy / versions upload / versions deploy | Remote upload/activation/traffic effects differ | A stored version is not proof of active traffic or a complete Container rollout. |
| Worker delete | Remote destructive removal | Exact Worker/environment and deletion authority; no cleanup assumption. |
| D1 execute / migrations apply | Local or remote, plus actual SQL effects | Database identity and complete SQL determine read/data/schema mutation. |
| KV key get/list versus put/delete; namespace create/delete | Local/remote key operations or remote namespace management | Namespace ID, preview binding, key and full deletion extent; read is not permission to write. |
| R2 object get/put/delete; bucket create/delete/config | Local/remote object access or remote bucket state | Downloads also write output locally; object replacement, deletion and bucket policy changes differ. |
| Queues/DNS/config operations via a supported provider | Reads versus enqueue/create/update/delete/configure | Endpoint/payload and exact queue/zone/record/resource; do not invent a Wrangler DNS command. |
| Logs/tail | Remote observation/connection, possible local output | Scope/time window and sensitive content; not authority to mutate another resource. |
| Secret put/delete, registry credentials, auth/profile changes | Remote secret/config or credential/local profile effects | No secret values in model context; not ordinary config reading. |

Read [KV](https://developers.cloudflare.com/workers/wrangler/commands/kv/),
[R2](https://developers.cloudflare.com/workers/wrangler/commands/r2/),
[Workers/secrets](https://developers.cloudflare.com/workers/wrangler/commands/workers/)
and [auth commands](https://developers.cloudflare.com/workers/wrangler/commands/general/)
only as needed. KV/R2 data commands expose local/remote variants; do not extend
those flags to every control-plane operation. Secret names/metadata are different
from values, but still disclose only task-needed information.

## D1: target plus complete SQL

[D1 commands](https://developers.cloudflare.com/workers/wrangler/commands/d1/)
distinguish --local and --remote and provide versioned migration files.
Do not assume a default location from the d1 execute name; resolve flags/config,
DB binding/ID and local persistence path or hosted target before acting.

| Example after SQL inspection | Target | Effect |
|---|---|---|
| SELECT of ordinary table data | Local D1 | Local observation candidate |
| SELECT of ordinary table data | Remote D1 | Remote observation and data access, not a data write |
| INSERT/UPDATE/DELETE | Remote D1 | Remote data mutation |
| CREATE/ALTER/DROP | Remote D1 | Remote schema mutation, possibly destructive |
| INSERT or schema changes | Local D1 | Local state mutation; still needs the task's scope and applicable safety |

Inspect all statements, SQL files and parameters; SELECT followed by DELETE is
not read-only. PRAGMA, import/export, mixed scripts and uncertain side effects
need actual inspection; no first-keyword or generic query-tool authorization.
Export also has local file/data-disclosure effects. Prefer the existing project
migration workflow for schema changes; do not default to ad hoc remote SQL.
Migration create writes a versioned local file; apply executes on the selected
DB. Non-interactive confirmation behavior is not authorization. On apply failure,
earlier successful migrations may remain applied even if the failing migration
rolls back; inspect history/state before retrying, without automatic reset/repair.

## Containers and partial deployment

[Container deployment](https://developers.cloudflare.com/containers/guides/deploy/)
currently activates the Worker before processing Container configuration. Image
build/push or rollout failure can occur after the new Worker is live. These stages
are not transactional. Return success does not mean all instances finished their
rollout; a responding Worker URL does not prove Container routes work.

[Image management](https://developers.cloudflare.com/containers/guides/image-management/)
distinguishes local Dockerfile build, image push, configured registry images and
remote rollout. containers build with --push adds registry mutation. A prebuilt
image does not make deployment local. [Container commands](https://developers.cloudflare.com/workers/wrangler/commands/containers/)
distinguish application deletion, image deletion and registry configuration
deletion. Removing an image may break a later rollback that needs it.

On partial failure, report confirmed Worker/version, image and application/rollout
state separately; unknown remote state stays unknown, never “remote unchanged”.
Use authorized bounded state reads before retries. No automatic rollback,
redeploy, image deletion or resource cleanup. Remote temporary/disposable resources
remain remote: create, exec, install, file writes and delete are separate effects.
Cleanup requires an explicitly covered action/target, not merely task completion.

## MCP and agent-related provider surfaces

The [official MCP catalog](https://developers.cloudflare.com/agents/model-context-protocol/cloudflare/servers-for-cloudflare/)
includes domain servers and an API Code Mode provider with search/execute tools.
The latter runs code against Cloudflare APIs; inspect every actual API call and
payload, not just the outer execute tool. An isolated execution environment does
not make invoked remote mutations read-only. Domain server/provider labels and
old container_* recipes do not prove a current schema or generic sandbox right.
Inspect available observability fields/values before filters; do not assume
set_active_account must run first. OAuth/API access still requires legitimate
existing scope. Agent setup/Cloudflare Skills examples do not authorize installing
another runtime, starting external AI work or changing local MCP configuration.
