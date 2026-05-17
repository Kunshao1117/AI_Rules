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
