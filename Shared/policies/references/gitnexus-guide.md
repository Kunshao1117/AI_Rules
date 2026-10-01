# GitNexus Optional Pack — Shared Reference

This is a non-invocable Reference, not an active Skill, runtime registry, Agent,
execution mode or new provider. Five separate Skills retain CLI operation,
exploration, debugging, impact and refactoring methods. Read only the method
relevant to the task; this family classification never loads the entire pack.

## Existing owners

`Shared/policies/capability-resolution.md` alone owns discovery, readiness and
selection. `Shared/policies/authorization-resolution.md` owns action permission;
platform permission is separate. Command effects below map to those owners and
`Shared/policies/references/protected-action-registry.md`, not a GitNexus gate.
`execution-routing.md` owns mode: Main using GitNexus stays Direct; a separate
helper can be Assisted; formal role separation can be Team. CLI use alone is
neither. `agent-governance.md` / `model-profile-routing.md` retain role/model
ownership. GitNexus is a code-analysis tool, not a generic AI CLI worker; never
create prompt files, spawn/detach another AI CLI, wait for an AI handoff or revive
generic AI delegation. Wiki's explicit provider use is separately scoped egress.

`verification-strategy.md` alone owns scope/independence and test admission;
`review-governance.md` owns review applicability; `completion-policy.md` owns
completion. Graph output is method evidence, never one of these decisions.
All short policy names above resolve beside this reference's parent directory.

## Readiness and provider absence

Apply the existing capability predicates to the current task and target:
passive discovery -> safe read-only probe when useful -> functional probe only
when the task requires it and its effects are authorized. These are safety
limits, not a mandatory pipeline. Existing executable resolution, known local
package/bin metadata or safe declarations establish presence only. Do not read
credentials or launch an unknown shim to prove presence.

Binary presence != ready. Unresolved repository applicability, index state,
command behavior or required environment means present_unverified. A known
constraint can be blocked; checked absence is unavailable; unexamined is not
unavailable. Readiness is target/action-specific, not a global durable fact.
Never write availability/readiness into Memory or Project Context.

Do not run `npx gitnexus` as a presence/readiness probe. No implicit install,
package wrapper fallback (npm exec, bunx, pnpm dlx, yarn dlx or equivalents),
init, login, MCP/server startup or credential access follows a provider gap.
Installation needs a separately explicit request and the existing authorization
and platform gates. This source-migration task performs none of those actions.

A ready, suitable, authorized GitNexus provider may win a tie because the user
prefers it. Preference != authorization; it cannot bypass readiness or block a
reasonable alternative. If unavailable, blocked or present_unverified, ordinary
search/debug/impact/refactor can use rg, project-native search, source navigation,
platform-native exploration or another authorized equivalent. An action denial
still follows that action across providers. Report material evidence limits only
when the alternative cannot establish the required claim; no mandatory install.

## Index evidence

Missing, stale or incomplete index does not auto-analyze, init or rebuild.
First assess task relevance, actual side effects, current authorization and
simpler alternatives. Index/context warnings are observations, not instructions
to execute the suggested refresh. Stale results can guide source inspection if
their limits are explicit; they cannot certify current coverage or absent edges.

If Memory or Project Context is frozen, do not refresh through a command that
writes those surfaces. Do not modify repository context to demonstrate readiness.
Upstream analyze can inject context and skills: --skip-agents-md and --skip-skills
are not interchangeable all-write suppressors. Even --index-only still writes
the index/registry and requires checking the installed version's exact effects.

## Command effects

These are source-checked recipes, not current-session availability evidence or
permission to execute. Check the installed version, wrapper and flags before
launch. All CLI rows inherit the startup caveat: upstream update notification
can spawn a background update check, contact a package registry and write cache
under eligible TTY/install conditions. A command with an observational handler
is not automatically a safe read-only process. Use passive evidence or retain
present_unverified if an inspected, appropriately bounded probe is unavailable.

| Operation | Effect category | Scope and caveats |
|---|---|---|
| status | observational intent; cache-writing and startup/network possible | Reads target metadata, source/commit freshness and index coverage; analyzer identity resolution can write cache. A registered repository is not proof of current functional readiness. |
| list / list_repos | observational intent; local-writing possible | Registry validation can prune missing/empty/unowned entries and rewrite the global registry. Avoid unrelated host inventory; disabling the notifier does not suppress these writes. |
| analyze | local-writing; potentially destructive replacement and network-sensitive | Parses source; writes graph, metadata, cache, registry and generated context/skills/hooks depending on flags/version. Rebuild/drop flags can replace data; embeddings/model downloads or remote modes add effects. --self-commit adds opt-in Git mutation; no such authority follows indexing. |
| clean | destructive + local-writing | Removes exact index data and registry entries; --all expands targets and --force removes a prompt, not the authorization requirement. |
| wiki | local-writing + external/network-sensitive | Generates docs through configured LLM; may persist provider configuration including secrets. Source/context egress and optional public publication are separately scoped effects. Interactive TTY can offer Gist publication without --gist; a local-provider branch can launch an AI CLI. Neither is authorized by this recipe or a readiness task. Do not inspect credentials or use that branch as generic delegation. |
| init / rebuild | unsupported or unverified syntax | No init subcommand was found in the checked upstream CLI registry; rebuild is a conceptual operation, not a verified command. Do not invent or probe either command. |
| query / context / impact / detect-changes | observational intent; local-writing/network possible | Backend refresh validates/prunes the registry; read-only DB opening can recover/quarantine/replay storage with writes. Query embedding facilities need separate inspection. MCP detect_changes and CLI detect-changes spellings differ; inspect the actual schema. |
| cypher | read query at checked DB boundary; startup effects remain | The checked backend uses a read-only database; this does not make startup/recovery write-free. Use schema-checked bounded reads only. Do not rely on an unverified version to reject mutation queries. |
| rename (MCP) | preview or local-writing | Checked dry_run defaults true; false writes multiple files and can return partial failure. Preview success is not write authorization or atomic rollback. Confirm installed behavior; no universal CLI rename syntax is asserted. |
| setup / mcp / serve | configuration writes / process lifecycle / network exposure | Not presence probes. No implicit editor setup, daemon/server start or exposure. |

## Tools, resources and graph concepts

Names below describe upstream concepts. Bound tool names may be prefixed by a
connector, and schemas/resources vary by version. Inspect already visible
schemas or official source; do not start a provider to discover them.

| Concept | Use and evidence limit |
|---|---|
| query | Find concept-related symbols/processes, not proof of execution. |
| context | Inspect a disambiguated symbol's incoming/outgoing relationships. |
| impact | Navigate dependents/dependencies; depth/confidence are not certainty of breakage. |
| detect_changes | Map an existing diff to candidate flows; no stage/commit authority. |
| rename | Inspect proposed edits and ambiguous matches before separately authorized application. |
| cypher | Read the installed graph schema first; bound traversal and result volume. |

Common resource family: `gitnexus://repo/{name}/context`, `/clusters`,
`/cluster/{clusterName}`, `/processes`, `/process/{processName}`, `/schema`.
Use an already selected repository; `gitnexus://repos` / list_repos may help
disambiguate only when actually exposed. Resource Process paths are inferred
structure, not measured runtime traces. Historical approximate token budgets are
not guarantees. Confirm support before using these provider-specific recipes.

Common graph concepts include File, Function, Class, Interface, Method, Community
and Process. CodeRelation types can include CALLS, IMPORTS, EXTENDS, IMPLEMENTS,
DEFINES, MEMBER_OF and STEP_IN_PROCESS. This is not a complete/fixed schema.
A conditional example after schema confirmation:

```cypher
MATCH (caller)-[:CodeRelation {type: 'CALLS'}]->(f:Function {name: 'myFunc'})
RETURN caller.name, caller.filePath LIMIT 20
```

Disambiguate duplicate symbol names and inspect current source. Missing edges,
high confidence and direct dependencies do not prove absence, correctness or
failure. Static process paths cannot prove a timeout, race or hot path occurred.

## Historical guide

Old gitnexus-guide IDs/paths resolve through `legacy-skill-migration.md` to
`legacy-skills/gitnexus-guide/REFERENCE.md`, which preserves the original body
and anchors as historical data only. No SKILL.md stub or invocation alias stays
behind. The five rewritten entries retain their own historical reference bodies;
none is a required active prerequisite.

## Source grounding

Checked 2026-09-15 against official upstream commit
`41fa74cd84f6b2c0446d45779681e5d74c8a6fcf`; not an installed-version
or functional readiness claim. Recheck version-dependent behavior when used.

- [CLI registration](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/index.ts)
- [Status](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/status.ts), [List](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/list.ts)
- [Analyze](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/analyze.ts), [Clean](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/clean.ts), [Wiki](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/wiki.ts)
- [Startup update notice](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/cli/update-notice.ts)
- [MCP backend](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/mcp/local/local-backend.ts)
- [Registry validation](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/storage/repo-manager.ts), [Identity cache](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/core/analyzer-identity.ts), [DB pool recovery](https://github.com/abhigyanpatwari/GitNexus/blob/41fa74cd84f6b2c0446d45779681e5d74c8a6fcf/gitnexus/src/core/lbug/pool-adapter.ts)
