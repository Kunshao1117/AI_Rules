---
name: plugin-release-governance
description: >
  [Release] Plugin and extension release governance for VSIX packaging,
  GitHub Release assets, package version bumps, changelog entries, release tags,
  and update reminder design. Use when: 插件開發、extension 修改、VSIX 重新打包、
  GitHub Release 同步、版本升級、tag 發布、自動更新提醒、update reminder、
  VS Code / Antigravity extension 發布。 DO NOT use when: 只是在討論一般 Git
  commit 且不涉及插件或發佈成品。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write", "git:write", "terminal:test"]
---

# Plugin Release Governance

## HITL Boundary

- Read-only inspection of package versions, changelog text, release workflows,
  and existing VSIX assets may proceed normally.
- Version bumps, changelog writes, package builds, commits, tag pushes, release
  updates, and artifact uploads require the active workflow's GO gate.
- Do not silently install, download, or replace a user's extension. Update
  reminders may open the release page only after user confirmation.

## 1. When to Load

Load this skill when a task touches any of these:

- VS Code / Antigravity / editor extension behavior.
- VSIX packaging or installable plugin artifacts.
- `package.json` version changes for an extension.
- GitHub Release creation, asset upload, tag-driven release workflows.
- User-facing update reminders or latest release checks.
- Documentation that tells operators how to install or update a plugin.

## 2. Release Contract

1. If plugin behavior visible to the operator changes, bump the extension
   version before packaging.
2. Keep `package.json`, lockfile, README, extension README, CHANGELOG, and
   memory cards aligned.
3. Name the VSIX asset with the package version, for example
   `ai-rules-manager-0.1.7.vsix`.
4. Do not commit VSIX artifacts unless the repository explicitly tracks release
   binaries.
5. Prefer tag-driven release: commit first, then push a matching `vX.Y.Z` tag so
   CI can build and upload the release asset.
6. Release notes should come from the project changelog when available, not only
   from generated compare links.

## 3. Update Reminder Contract

Until Marketplace / Open VSX native auto-update is adopted:

- Check the latest stable GitHub Release tag.
- Compare it with the installed extension version.
- On newer release, show a user-facing prompt with an "open release" action.
- Manual checks may show errors; startup checks should log failures without
  interrupting the operator.
- Do not silently download or install a VSIX.

## 4. Playbook

For concrete command order, validation points, and release workflow checks, read
`references/vsix-release-playbook.md`.
