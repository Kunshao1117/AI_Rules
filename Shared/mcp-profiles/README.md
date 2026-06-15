# MCP Opt-in Profiles

AI_Rules 只提供設定片段，不會在 Fresh / Upgrade / Sync / Audit 中自動安裝外部 MCP server，也不會覆寫使用者全域 MCP 設定。

## Codex Profile Snippet

```toml
# ~/.codex/config.toml
# Opt-in only. Keep approval and sandbox policy under user control.

[mcp_servers.multi_mcp_gateway]
command = "npx"
args = ["-y", "multi-mcp-gateway"]
```

## Claude Profile Snippet

```json
{
  "mcpServers": {
    "multi-mcp-gateway": {
      "command": "npx",
      "args": ["-y", "multi-mcp-gateway"]
    }
  }
}
```

## Gemini / Antigravity Profile Snippet

```json
{
  "mcpServers": {
    "multi-mcp-gateway": {
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "multi-mcp-gateway"]
    }
  }
}
```

## Governance Notes

- Read-only automation may inspect MCP resources, prompts, schemas, and health/status tools.
- Discovery of MCP resources, prompts, or tool schemas is not permission to execute mutating tools.
- Any MCP tool that writes files, changes cloud resources, opens PRs, commits code, or mutates memory requires `GO`.
- cartridge-system calls must include `projectRoot` in downstream parameters.
- Gateway calls must include explicit `workspace`.

## cartridge-system Operational Contract

For project memory work, follow the deployed contract at `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`.

- Project-local file migration starts from `.agents/tools/Memory-Migration.ps1`; downstream projects should not look for the framework source manager unless they are the AI_Rules source repository.
- Read-only MCP evidence includes workspace brief, memory list/read/status/dependency/audit/graph, commit preflight, and project context inspection tools.
- Mutating MCP operations such as memory commit or memory reindex require Director GO and an MCP HITL gate.
- If cartridge-system is accessed through Multi-MCP Gateway, call the downstream tool through the real gateway execution entrypoint with explicit `workspace`, and include explicit `projectRoot` in cartridge-system arguments.
- Missing MCP support is an unverified or blocked evidence path, not permission to hand-edit memory indexes or batch-rename cards.
