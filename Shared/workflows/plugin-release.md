# Plugin Release Workflow

Entry is an explicit release/package/update-reminder task, not any extension
edit. This workflow is manual-only phase guidance; it grants no action authority.
`Shared/policies/authorization-resolution.md` and the protected-action registry
resolve each applicable action. Review, verification and completion remain with
their canonical policies; no phase label implies their acceptance.

## 1. Inspect the release target

Read the current package/lockfile version, changelog, existing release workflow,
artifact naming and repository binary-tracking conventions. Identify whether
operator-visible behavior changes and which package/version is actually intended.
Preserve unrelated dirty changes. Product-specific checks and provider details
are in `Shared/policies/references/plugin-release-procedure.md`.

## 2. Prepare the version and package

Within authorized scope, align package version, lockfile and applicable release
documentation. Compile/package with the project's existing toolchain, inspect
the packaged manifest, and match the VSIX asset name to the package version.
Record artifact hash/size when needed. Source Memory attribution stays with its
frozen owners and never becomes an automatic write in this workflow.

## 3. Follow the publication sequence

Where the project uses tag-driven release, the sequence is scoped source commit,
branch publication, matching version tag, build/release job, then asset/notes
inspection. Each protected action uses its own applicable authorization; entering
the workflow does not authorize later phases. Use existing GitHub/provider
guidance for provider calls and project workflow syntax.

## 4. Inspect update-reminder behavior

Compare the installed version with the latest stable release. A newer release
offers an operator prompt; startup checks stay quiet when current and log
failures, while manual checks can report current/error status. Opening the
release page follows user confirmation. Never silently download/install/replace
the extension. Existing native Marketplace/Open VSX update behavior, if used by
the project, is the relevant path rather than a duplicate reminder system.

## 5. Report release evidence

Separate source/package readiness, published tag/release evidence and deployed
or installed behavior. Use `Shared/workflows/release-readiness.md` to organize
remaining evidence; completion-policy owns the final completion decision.
