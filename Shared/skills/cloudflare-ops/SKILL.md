---
name: cloudflare-ops
description: >
  雲端服務操作（MCP: cloudflare）：Cloudflare 雲端服務操作食譜：KV/D1/R2 資源管理、Workers 管理、容器操作、日誌查詢。
  Use when: 呼叫 cloudflare 相關工具、雲端資源管理/Workers/KV/D1/R2/容器/日誌 的場景。
  DO NOT use when: 非 Cloudflare 雲端服務操作。
  MCP Server: cloudflare-bindings, cloudflare-containers, cloudflare-observability
metadata:
  author: antigravity
  version: "5.3"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers:
    [cloudflare-bindings, cloudflare-containers, cloudflare-observability]
  tool_scope:
    [
      "mcp:cloudflare-bindings",
      "mcp:cloudflare-containers",
      "mcp:cloudflare-observability",
    ]
---

# Cloudflare Ops — Cloud Service Recipes

> This skill spans three MCP servers: bindings, containers, observability.

## HITL Boundary

- Read-only tools (`list`, `get`, `search`, `query`, status/health checks) may proceed silently.
- State-mutating, external-state, write, deploy, push, delete, reset, or resolve operations require a scope-bound intent signal from the Director; authorization resolution must bind it to the visible plan, command/tool, phase, expiry, and target external state before the matching protected gate can pass.
- `[MCP HITL GATE]` is an additional execution gate for MCP calls; it does not replace authorization resolution or authorize a separate protected phase.
- Discovery of tool schemas is not permission to execute mutating tools.

## Recipe 1: Account Initialization

1. `accounts_list` — List all accounts
2. `set_active_account` — Set active account; this must be done before other operations

## Recipe 2: KV Key-Value Storage

1. `kv_namespaces_list` — List all KV namespaces
2. `kv_namespace_create` — Create new namespace
3. `kv_namespace_get` — View specific namespace details

## Recipe 3: D1 Database Management

1. `d1_databases_list` — List all D1 databases
2. `d1_database_create` — Create new database
3. `d1_database_query` — Execute SQL queries

## Recipe 4: R2 Object Storage

1. `r2_buckets_list` — List all R2 buckets
2. `r2_bucket_create` — Create new bucket
3. `r2_bucket_get` — View bucket details

## Recipe 5: Workers Management & Log Queries

1. `workers_list` — List all Workers
2. `workers_get_worker_code` — Read Worker source code
3. `query_worker_observability` — Query logs and performance metrics
4. Before querying, use `observability_keys` to confirm available fields
5. Use `observability_values` to confirm available values for a field

## Recipe 6: Container Operations

1. `container_initialize` — Start container
2. `container_ping` — Confirm container is running
3. `container_exec` — Execute commands; use `python3`/`pip3` for Python
4. `container_file_write` / `container_file_read` — File read/write

## Recipe 7: Cloud Sandbox Execution

Use Cloudflare Containers as an isolated execution environment for one-off scripts.

### Use Cases

- Data transformation scripts
- Batch processing tasks
- Experimental code execution
- Package installation testing

### Full Execution Flow

1. `container_initialize` — Start a fresh container
2. `container_ping` — Confirm container is ready
3. `container_file_write` — Write script file(s) to container
4. `container_exec` — Execute the script
   - Python: `python3 script.py`
   - Node.js: `node script.js`
   - Install dependencies first if needed: `pip3 install pandas` or `npm install lodash`
5. `container_file_read` — Read output files if generated
6. `container_file_delete` — Clean up sensitive files

### Security Guidelines

- ⛔ NEVER pass API keys, passwords, or tokens to the container
- ⛔ NEVER connect container to production databases
- ✅ Use for read-only analysis and computation
- ✅ Clean up all files after execution

## Gotchas

- **Account first**: Must `set_active_account` before all operations
- **Log queries**: `query_worker_observability` filter fields require `observability_keys` confirmation first — do not guess
- **Container Python**: Must use `python3` and `pip3`, NOT `python`/`pip`
- **Pages migration**: Before migrating Pages to Workers, **must** call `migrate_pages_to_workers_guide` first
- `search_cloudflare_documentation` can search all Cloudflare product docs

## Interpretation

- Log queries support three views: `events`, calculations, specific invocations
- Worker's `workers_get_worker_code` may return bundled version, not necessarily source code
