# Native Codex project instruction discovery

## Compatibility boundary

Codex discovers `AGENTS.override.md`, then `AGENTS.md`, in each directory on
its project-root-to-working-directory path. A fallback must be a filename:
`.codex/AGENTS.md` contains a path separator and is ignored by the standard
loader. This was checked against Codex `0.163.0-alpha.10.2`, upstream commit
[`4ebc485ca321243727539187169425fcf972f2c4`](https://github.com/openai/codex/blob/4ebc485ca321243727539187169425fcf972f2c4/codex-rs/core/src/agents_md.rs#L272-L296).
This does not establish that every host-specific instruction channel is absent.

The project config key belongs at config root, not under `[projects.'...']`.
No project or global fallback is required for a standard root `AGENTS.md`.
The project and global merge helpers stop adding the invalid default. They
preserve existing values, including unknown operator configuration; this is
not a global configuration cleanup or a new machine-wide fallback.

## One source, managed projections

`Codex/.codex/AGENTS.md` remains the canonical core template. Existing deployment
preserves `PROJECT IDENTITY` and synchronizes the small shared-policy marker in
`.codex/AGENTS.md`. `Sync-CodexRootProjection` then copies that complete body into
root `AGENTS.md`, preceded only by a generated-file comment. The full adapter
is not expanded. Neither generated file is a second source of policy truth.
This is physical native-discovery content, not a link, junction, native include,
or an instruction asking the model to read another file.

Fresh, Upgrade, Deploy Sync and Manager Sync use this same projection. The
fixed `.codex/ai-rules-root-agents.json` receipt records the generated root's
SHA256. Repeated sync leaves identical bytes and timestamps alone. Generic
upgrade/orphan scanning excludes the receipt; only the projection owns it.
Root instructions apply to that project and descendants under normal Codex
rules. Child-directory instructions keep their normal precedence. Other tools
that discover root `AGENTS.md` may also read this Codex-labelled core; existing
root files therefore require explicit reconciliation, never automatic merging.

## Conflicts and recovery

Before platform writes, Codex entry points check for an unowned/edited root,
invalid or incomplete receipt pair, root `AGENTS.override.md`, non-file paths,
and linked paths. Any conflict preserves the files and blocks successful
projection. An identical pre-existing root without a receipt is still unowned.
An absent root with a leftover receipt is an incomplete pair, not permission to
recreate it. Resolve these cases with the project owner and a verified backup;
there is no force/adopt flag. Do not edit hashes to bypass this check.

Codex batch transactions include root `AGENTS.md`; other platform-only batches
do not expand their snapshot scope. Root and receipt are restored together on
caught failure. Persistent exact-file recovery and cohort planning also include
both files. The preflight computes the same identity-preserving core bytes as
Upgrade. These mechanisms do not provide process-crash atomicity or a writer
lock. Stop concurrent sync/editing while applying or restoring.

## Same-revision local application contract

This repository change alone does not repair a user's installed project.
For a later, separately authorized application:

1. Pin the reviewed Git commit, not a moving branch. Record the installed Codex
   version and source revision. Keep the installed version for the acceptance
   check; this patch does not request a Codex upgrade.
2. Inspect project status and preserve an external backup of existing root
   `AGENTS.md`/override (or record absence), `.codex/AGENTS.md`, the receipt,
   and `.codex/config.toml`. Do not overwrite user/global configuration.
3. Use the reviewed projection helper on the approved, current managed core,
   or the approved standard deployment entry if that broader deployment is
   separately in scope. Back up the exact touched paths first. Do not run an
   all-platform upgrade merely to fix instruction discovery.
4. Compare generated root body with the preserved managed core and verify the
   receipt hash. Check an intentionally fresh session from both the project
   root and an ordinary descendant using the same installed Codex version.
   A file/hash test proves projection, not that a particular host loaded it.
5. Report the observed native load evidence and remaining warnings separately.
   If validation fails, restore the exact backup pair (including prior absence),
   provided no subsequent user edits would be lost. No global settings, security
   policy, paused integrations, release or deployment is authorized by this note.
