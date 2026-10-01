# Compatibility-only CLI history

Status: legacy / non-canonical / inactive. Retained for historical references
and frozen Memory consumers; not an active vNext dependency or executable SOP.
Generic AI-to-AI CLI worker fallback is retired. Use
`Shared/policies/capability-resolution.md` for providers and
`Shared/policies/subagent-invocation.md` for genuine helper/context work.
Explicit external AI comparison follows the capability owner; the historical
file/detach/Director-notification procedure below is not automatically revived.
Do not rewrite the frozen historical Memory instructions here. Physical file
retirement is deferred to the dedicated retirement phase.

<!-- LEGACY_CLI_HISTORY_START -->
# CLI Capability Matrix

Detailed reference for the `delegation-strategy` skill.

## Available Capabilities

| Category | Abstract capability | Notes |
|---|---|---|
| File reading | File read, directory listing, and search capability | Concrete tool names come from the platform adapter |
| MCP tools | MCP direct calls or adapter-approved gateway calls | Use the current platform MCP profile configuration |
| Shell commands | Platform-approved read-only shell read capability | Read, list, and diagnose only; do not mutate the project or external state |
| Report writing | Platform-approved report write capability | Write only the intermediate report explicitly authorized by the workflow |

## Known Limits

| Limit | Detail | Workaround |
|---|---|---|
| Non-interactive tool block | Some CLIs disable shell or file tools in non-interactive mode | Use the platform adapter's approved interactive mode or the main agent execution route |
| Independent MCP settings | CLI MCP settings may not inherit IDE settings | Require the platform adapter to provide the profile explicitly |
| Enter-key separation | Some CLI TUIs do not treat newline text as Enter | Send text input and the confirmation key separately |
| ESLint absolute paths | Some lint tools require a complete absolute path array | Build paths from tracked-file lists in memory skills |
| gitignore filtering | Tools may skip `.agents/` when it is gitignored | Use platform-approved read-only file output capability |
| ESLint MCP version conflict | MCP's built-in engine may conflict with project framework plugins | Use `npx eslint` instead |

<!-- LEGACY_CLI_HISTORY_END -->
