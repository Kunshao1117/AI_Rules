# Plugin Package And Provider Reference

Phase order is owned by `Shared/workflows/plugin-release.md`. Authorization,
review, verification and completion use the existing canonical policies.

## Package inspection

Inspect operator-visible behavior, the package/lockfile version, changelog,
existing CI release rules and whether binaries are tracked. For a visible fix,
follow the project's accepted version policy; a patch bump is the existing
recipe when compatible with that policy. Align applicable root/extension README
installation examples and release notes. Memory cards are a frozen attribution
surface, not an automatic documentation-write step.

Compile and package through the project's existing toolchain. Match package
version, packaged manifest and VSIX filename, such as
`ai-rules-manager-0.1.7.vsix`. Check LICENSE inclusion, asset size/hash as useful,
and the repository's treatment of node_modules, out and VSIX artifacts.

## GitHub/provider details

For an existing GitHub tag-driven release, compare the `vX.Y.Z` tag and target
commit, workflow run, generated asset, release notes and changelog. Provider
operations use `Shared/skills/github-ops/SKILL.md` with separately resolved
capabilities and action authority. Do not hardwire provider availability into
the workflow or treat an available provider as permission to publish.

The inherited AI_Rules playbook names Node 24-compatible GitHub Actions and
Node 24 packaging, and checking for Node 20 deprecation warnings. Those are
project/toolchain-specific inspection details: verify the actual locked CI
workflow before applying them to another project. They are not global Policy.
Release notes should use the project changelog when available rather than only
generated compare links. A successful release run is publication evidence,
not proof that the user installed or ran the new extension.

## Update-reminder checks

For the existing GitHub Release reminder path, compare installed version with
the latest stable release. Newer releases offer an open-release prompt; current
startup checks remain quiet and log failures to the existing output channel.
Manual checks can report current/equal/older versions or a concise error.
Opening the release page requires user confirmation. Do not silently download,
install or replace an extension. If native Marketplace/Open VSX update is already
adopted, inspect that existing path instead of adding a duplicate mechanism.
