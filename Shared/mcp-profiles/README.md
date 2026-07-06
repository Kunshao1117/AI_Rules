# MCP 手動啟用設定片段（MCP Opt-in Profiles）

AI_Rules 只提供可選用的設定片段。
Fresh、Upgrade、Sync 與 Audit 不會自動安裝外部 MCP server，也不會覆寫使用者的全域 MCP 設定。

## Codex 設定片段（Codex Profile Snippet）

```toml
# ~/.codex/config.toml
# Opt-in only. Keep approval and sandbox policy under user control.

[mcp_servers.multi_mcp_gateway]
command = "npx"
args = ["-y", "multi-mcp-gateway"]
```

## Claude 設定片段（Claude Profile Snippet）

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

## Gemini / Antigravity 設定片段（Gemini / Antigravity Profile Snippet）

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

## 治理注意事項（Governance Notes）

- 唯讀自動化可以檢視 MCP resources、prompts、schemas 與 health/status tools。
- 發現 MCP resources、prompts 或 tool schemas，不等於取得執行突變工具的授權。
- 會改變狀態的 MCP tools 必須先完成 authorization resolution，且要綁定目前可見的 plan、station、file set、command、phase 或 expiry。
- 會改變狀態的 MCP tools 包含檔案寫入、cloud resource changes、PR creation、commits、code changes 與 memory mutation。
- 會改變狀態的 MCP tools 還需要對應的 protected gate。
- 呼叫 cartridge-system 時，下游參數必須包含 `projectRoot`。
- 呼叫 Gateway 時，必須明確包含 `workspace`。

## cartridge-system 操作契約（Operational Contract）

專案記憶工作要遵循已部署契約：`.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`。

- 專案本機檔案遷移從 `.agents/tools/Memory-Migration.ps1` 開始。
- 下游專案不應尋找框架來源管理器；只有 AI_Rules source repository 本身例外。
- 唯讀 MCP 證據包含：
  - workspace brief；
  - memory list/read/status/dependency/audit/graph；
  - commit preflight；
  - project context inspection tools。
- 會改變狀態的 MCP 操作，例如 memory commit 或 memory reindex，必須同時具備：
  - 綁定範圍式 Director intent signal 的 authorization resolution；
  - 對應的 memory protected gate；
  - MCP HITL gate。
- MCP HITL 是額外執行閘門，不是 authorization resolution 的替代品。
- 如果透過 Multi-MCP Gateway 存取 cartridge-system：
  - 必須透過真實 gateway execution entrypoint 呼叫下游工具，並明確帶入 `workspace`；
  - cartridge-system arguments 必須明確包含 `projectRoot`。
- 缺少 MCP 支援時，證據路徑只能是 unverified 或 blocked；不得因此手改 memory indexes 或批次改名 cards。
