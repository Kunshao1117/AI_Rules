# VSIX Release Playbook

Use this reference when a plugin or editor extension change must become an
installable release.

## Preflight

1. Confirm whether the change affects operator-visible behavior.
2. Read the extension package manifest and lockfile version.
3. Check existing release workflow rules, especially tag/version matching.
4. Confirm whether the repo treats VSIX files as ignored release artifacts.
5. Confirm the release workflow uses Node 24-compatible GitHub Actions and
   Node 24 for VSIX packaging.
6. Inspect current dirty files and avoid reverting unrelated user work.

## Version And Documentation

1. Bump the package patch version for visible behavior fixes.
2. Update the lockfile version in the package root.
3. Add a changelog section named for the public plugin version.
4. Update root README and extension README install/update examples.
5. Update memory cards that track release workflow, extension behavior, and
   shared governance decisions.

## Build And Package

1. Compile the extension.
2. Package the VSIX with a filename that exactly matches the new version.
3. Inspect the packaged manifest version.
4. Record VSIX size and SHA256 in the completion summary when useful.
5. Confirm the extension package includes a LICENSE file so VSIX packaging does
   not warn about missing license metadata.
6. Keep generated `node_modules`, `out`, and `.vsix` artifacts out of git unless
   the repo explicitly tracks them.

## Release Sync

Recommended release path:

1. Stage only the approved source, docs, workflow, and memory files.
2. Commit with a Traditional Chinese conventional commit message.
3. Push the branch.
4. Create and push a matching `vX.Y.Z` tag.
5. Confirm GitHub Actions created or updated the Release.
6. Confirm the release run does not show GitHub Actions Node 20 deprecation
   warnings.
7. Confirm the release asset name, version, and notes match the changelog.

## Update Reminder Acceptance

For GitHub Release based update reminders:

- A newer stable `vX.Y.Z` release should show an operator prompt.
- Automatic startup checks must stay silent when the installed version is
  already current; log the result to the Output Channel only.
- Manual checks should report that the extension is current when the latest
  release is equal to or older than the installed version.
- Startup network failures should be logged only.
- Manual network failures should show a concise warning.
- The prompt should open the Release page and should not install silently.
