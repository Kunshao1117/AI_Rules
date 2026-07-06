---
trigger: model_decision
description: 外部工具操作防護欄；高風險 MCP 呼叫前適用，例如資料庫操作、雲端部署或程式碼推送（Use before: high-risk MCP calls）。
---

# [ANTIGRAVITY MCP GUARDRAILS]

## 0. Gateway Execution Contract

當工具透過 Multi-MCP Gateway 提供時：

- `gateway__search_tools` 與 `gateway__list_server_tools` 只能用於 discovery；用途是查找 tool names 與 input schemas。
- 真正的 downstream MCP execution 必須使用 `gateway__call_tool`；不得把 schema search、CLI replacement 或 handler-level simulation 宣稱為已測試 downstream MCP tool。
- 每次 `gateway__call_tool` 呼叫都必須包含明確的 `workspace` absolute path。對 cartridge-system tools，`arguments.projectRoot` 也必須明確指定。
- 不得依賴 Gateway global workspace state。不得猜測 argument names；必須先檢查 schema。

## 1. MCP Human-In-The-Loop Gate

```
[MCP HITL GATE] 執行任何 state-mutating MCP tool 前：
├── MCP action 是否純 READ-ONLY（例如 list, get, search, query docs）？
│   └── YES → 先檢查 §2 Tool-Level Permission Matrix 是否覆寫；若為 🟢 LOW，略過此 gate 並靜默繼續。
├── 總監提示是否包含 [SUDO]?
│   └── YES → 只記錄覆寫/風險關閉請求；此 gate、scoped authorization、Team-Native、validation、review 與 protected gates 仍維持啟用；[SUDO] 不授權 unconstrained execution。
├── action 是否為 STATE-MUTATING（例如 write, update, delete, deploy, push）？
│   └── YES → Agent 必須先輸出 Justification Block:
│         【操作理由】為什麼需要執行此操作（商業語言描述）
│         【影響範圍】此操作可能影響的系統或資料
│         【回滾方案】若操作失敗的復原策略
│         接著 → [HALT] 「🔴 [MCP HALT] 偵測到破壞性外部工具呼叫 ({ToolName})。請總監輸入 [SUDO] 或明確同意。」
│         不得執行該工具；立即停止目前任務（DO NOT execute the tool; stop current task）。
└── 全部通過 → 執行 tool。
```

- **定義（Definition）**: state-mutating MCP tool 指任何會改變 remote infrastructure、database schemas/data 或 version control states 的工具（例如 `supabase__apply_migration`、`github__push`、`cloudflare-ops` container modifications）。
- **執行約束（Enforcement）**: 這是防止 AI 意外執行破壞性動作的嚴格安全邊界。

## 2. Tool-Level Permission Matrix

下表列出 specific tool 時，其 risk level 會覆寫 §1 的一般 READ/WRITE classification。
若 tool 未列於下表，回退採用 §1 的 READ/WRITE classification。

| 工具名稱（Tool Name） | 風險等級（Risk Level） | 核准閘門（Approval Gate） |
|-----------|-----------|---------------|
| `supabase.execute_sql` (non-SELECT) | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `supabase.apply_migration` | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `supabase.deploy_edge_function` | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `cartridge-system__memory_commit` | 🔴 HIGH | 只能在 active memory main file 已寫入且 memory commit phase 啟用後執行 |
| `github.create_or_update_file` | 🟡 MEDIUM | 需提供 Justification Block，並自動記錄（auto-logged） |
| `github.push_files` | 🟡 MEDIUM | 需提供 Justification Block，並自動記錄（auto-logged） |
| `cloudflare.container_*` (mutating) | 🟡 MEDIUM | 需提供 Justification Block，並自動記錄（auto-logged） |
| `gateway__search_tools` / `gateway__list_server_tools` | 🟢 LOW | 自動放行（Auto-proceed） |
| `cartridge-system__memory_list` / `memory_read` / `memory_status` / `memory_deps` | 🟢 LOW | 自動放行（Auto-proceed） |
| `cartridge-system__workspace_brief` / `memory_audit` / `commit_preflight` | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.execute_sql` (SELECT only) | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.list_tables` | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.search_docs` | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.get_logs` | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.list_*` | 🟢 LOW | 自動放行（Auto-proceed） |
| `supabase.get_*` | 🟢 LOW | 自動放行（Auto-proceed） |
| `github.search_repositories` | 🟢 LOW | 自動放行（Auto-proceed） |
| `github.get_*` | 🟢 LOW | 自動放行（Auto-proceed） |
| `github.list_*` | 🟢 LOW | 自動放行（Auto-proceed） |
| `cloudflare.kv_get` | 🟢 LOW | 自動放行（Auto-proceed） |
| `cloudflare.accounts_list` | 🟢 LOW | 自動放行（Auto-proceed） |
