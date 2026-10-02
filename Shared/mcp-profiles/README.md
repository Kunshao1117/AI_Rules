# MCP 手動啟用設定片段（MCP Opt-in Profiles）

AI_Rules 只提供可選用的設定片段。
Fresh、Upgrade、Sync 與 Audit 不會自動安裝外部 MCP server，也不會覆寫使用者的全域 MCP 設定。

Provider discovery follows `Shared/policies/capability-resolution.md`. The opt-in
wrapper snippets below may download packages when activated; they are not
presence probes. Reading visible metadata and launching a server are different
actions. Activation does not authorize installation, login or downstream mutation.

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

本段只提供 MCP 使用摘要；一般授權以 [Authorization Resolution](../policies/authorization-resolution.md) 與 [Protected Action Registry](../policies/references/protected-action-registry.md) 為正式來源。MCP 是工具／傳輸方式，授權類別由實際副作用與目前使用者要求的範圍決定。

- 唯讀 MCP resources、prompts、schemas、health/status、read-only API 與文件／狀態查詢屬於 `observe`；一般不需要 GO、Team、station、authorization phase、expiry 或 execution envelope，仍受平台權限、隱私、憑證邊界與使用者明確排除事項約束。
- 發現 MCP resources、prompts 或 tool schemas，不等於取得執行突變工具的授權。
- 使用者目前要求範圍內，必要、有限、合理且可逆的本機檔案／專案設定修改、本機測試、build 與非破壞性驗證，可屬於 `local_work`；不因透過 MCP 執行就額外要求 station、phase、expiry、formal-write 或 protected gate。
- 實際副作用符合 `protected.external`、`protected.destructive`、`protected.credential_privilege` 或 `protected.system` 時，依正式 registry 處理明確 action／target、適用的安全／回復證據與原生權限；已有明確授權時，不額外要求通用 magic phrase。
- 平台／工具拒絕操作時，停止受影響動作；使用者授權不能用來改走其他工具或通道規避拒絕。
- Memory frozen compatibility 是明確例外，依下節的專屬契約處理。
- 呼叫 cartridge-system 時，下游參數必須包含 `projectRoot`。
- 呼叫 Gateway 時，必須明確包含 `workspace`。

## cartridge-system 操作契約（Operational Contract）

專案記憶工作要遵循已部署契約：`.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`。

依正式授權政策，在特定專案／runtime 有正式 M5 cutover 證據前，實體 `.agents/memory/**` 的寫入、建立、搬移或刪除，以及 `memory_commit`、`memory_reindex` 與 index sync，仍屬於 `frozen_memory_action`，使用保留的 legacy Memory contract，不能直接套用一般 `local_work`。

- 專案本機檔案遷移從 `.agents/tools/Memory-Migration.ps1` 開始。
- 下游專案不應尋找框架來源管理器；只有 AI_Rules source repository 本身例外。
- 唯讀 MCP 證據包含：
  - workspace brief；
  - memory list/read/status/dependency/audit/graph；
  - commit preflight；
  - project context inspection tools。
- 仍適用 frozen compatibility 的 Memory MCP 操作，例如 memory commit 或 memory reindex，必須同時具備：
  - 綁定範圍式 Director intent signal 的 authorization resolution；
  - 對應的 memory protected gate；
  - MCP HITL gate。
- MCP HITL 是額外執行閘門，不是 authorization resolution 的替代品。
- 如果透過 Multi-MCP Gateway 存取 cartridge-system：
  - 必須透過真實 gateway execution entrypoint 呼叫下游工具，並明確帶入 `workspace`；
  - cartridge-system arguments 必須明確包含 `projectRoot`。
- 缺少 MCP 支援時，證據路徑只能是 unverified 或 blocked；不得因此手改 memory indexes 或批次改名 cards。
