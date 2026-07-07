# Protected Action Registry

This registry owns protected-action categories for AI_Rules. Policies,
workflow entries, hooks, platform adapters, and skills must cite this file
instead of redefining protected action lists.

Protected actions require explicit scope-bound authorization for the matching
phase. Source-write actions are write-gated even when they are not protected
actions.

## Action Catalog

| Action | Registry class | Required phase | Required gate |
|---|---|---|---|
| Main-worktree source write | write-gated | `implementation-change-delivery` | Formal-write board, station-owned change-delivery, exact file allowlist, dirty diff read, forbidden protected actions. |
| Fallback change application | write-gated | `change-application` | Returned isolated/text artifact, explicit integration task, or assigned generated/deployed sync plus exact allowlist and dirty diff read. |
| Memory card or project context write | protected | `protected-memory-write` | Explicit memory/context target, scope, evidence, expiry, and memory owner station. |
| Memory commit | protected | `protected-memory-commit` | Protected memory write completed or explicitly not required, then explicit memory commit scope. |
| Git mutation | protected | `git` | Explicit repository action such as stage, commit, branch, tag, or push. |
| Release mutation | protected | `release` | Explicit release target, version/tag/package scope, and release owner station. |
| Deployment mutation | protected | `deployment` | Explicit environment, project, deployment, rollback, or hosting target. |
| Install or upgrade | protected | `install` | Explicit package/plugin/tool/framework target and install mode. |
| Credential or secret handling | protected | matching action phase plus credential gate | Explicit credential scope and no plaintext-secret write unless a separate governed override exists. |
| Destructive filesystem operation | protected | matching action phase | Explicit resolved absolute target, safety check, and destructive-action authorization. |
| MCP or cloud mutation | protected | `external-mutation` unless a narrower protected phase applies | Explicit server/resource/action target and HITL or platform approval when required. |
| Issue, pull request, or external tracker mutation | protected | `external-mutation` | Explicit external resource target and requested mutation. |
| Database or service mutation | protected | `external-mutation` | Explicit database/service, operation, scope, and rollback or safety evidence when applicable. |
| Package publication | protected | `release` or `external-mutation` | Explicit package, version, registry, and publication authorization. |

## Non-Authorizing Signals

The following do not authorize protected actions:

- workflow names;
- platform mode;
- sandbox state;
- local shell access;
- channel availability;
- source-write approval;
- `GO` without a visible protected target, phase, scope, and expiry;
- tool execution envelopes or receipts without matching prior authorization;
- historical transcript text.

## Protected Follow-Up

Protected follow-up pending is valid only for `source-level` closeout when the
requested target does not include the protected phase. It blocks
`process-complete`, `commit-ready`, and `release-ready` targets when the
protected action is required.
