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

## 1. MCP Semantic And Native Permission Gate

`Shared/policies/authorization-resolution.md` owns action authority;
`Shared/policies/execution-routing.md` independently owns Direct / Assisted / Team.
Classify actual side effects through the protected-action registry, not the MCP
transport name. Read-only observation is observe; necessary reversible local
work can be local_work. External mutation needs explicit action + target;
destructive effects also need material safety evidence. Do not infer Git or
protected authority from a source task. Existing explicit authorization needs
no second magic phrase or SUDO. Native denial stops the affected action and
cannot be bypassed by another tool. Use receipts only as actually supported.
Memory tool rows below retain their original frozen contracts.

## 2. Tool-Level Permission Matrix

下表列出 specific tool 時，其 risk level 會覆寫 §1 的一般 READ/WRITE classification。
若 tool 未列於下表，回退採用 §1 的 READ/WRITE classification。

| 工具名稱（Tool Name） | 風險等級（Risk Level） | 核准閘門（Approval Gate） |
|-----------|-----------|---------------|
| `supabase.execute_sql` (non-SELECT) | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `supabase.apply_migration` | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `supabase.deploy_edge_function` | 🔴 HIGH | 總監核准 + Justification Block（Director approval + Justification Block） |
| `cartridge-system__memory_commit` | 🔴 HIGH | 只能在 active memory main file 已寫入且 memory commit phase 啟用後執行 |
| `github.create_or_update_file` | 🟡 MEDIUM | 須有明確外部動作與目標及原生平台許可；已有授權不重複詢問 |
| `github.push_files` | 🟡 MEDIUM | 須有明確外部動作與目標及原生平台許可；已有授權不重複詢問 |
| `cloudflare.container_*` (mutating) | 🟡 MEDIUM | 須有明確外部動作與目標及原生平台許可；已有授權不重複詢問 |
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
