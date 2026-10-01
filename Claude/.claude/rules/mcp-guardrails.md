# [MCP GUARDRAILS]

> Apply when: calling state-mutating MCP tools (database ops, cloud deployment, code push).

## 0. Gateway Execution Contract

When tools are provided through Multi-MCP Gateway:

- `gateway__search_tools` and `gateway__list_server_tools` are discovery-only. Use them to find tool names and input schemas.
- Real downstream MCP execution MUST use `gateway__call_tool`; do not claim a downstream MCP tool was tested by schema search, CLI replacement, or handler-level simulation.
- Every `gateway__call_tool` call MUST include an explicit `workspace` absolute path. For cartridge-system tools, `arguments.projectRoot` MUST also be explicit.
- Do not rely on Gateway global workspace state. Do not guess argument names; inspect the schema first.

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

| Tool | Risk | Gate |
|---|---|---|
| `mcp__claude_ai_Supabase__execute_sql` (non-SELECT) | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Supabase__apply_migration` | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Supabase__deploy_edge_function` | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Vercel__deploy_to_vercel` | 🔴 HIGH | Director approval + Justification |
| `cartridge-system__memory_commit` | 🔴 HIGH | Only after the active memory main file has been written and memory commit phase is active |
| Bash `git push` | protected.external | Explicit push action + target and native permission |
| Bash `git commit` | local Git | Explicit commit request; source work alone does not authorize it |
| `gateway__search_tools` / `gateway__list_server_tools` | 🟢 LOW | Auto-proceed |
| `cartridge-system__memory_list` / `memory_read` / `memory_status` / `memory_deps` | 🟢 LOW | Auto-proceed |
| `cartridge-system__workspace_brief` / `memory_audit` / `commit_preflight` | 🟢 LOW | Auto-proceed |
| `mcp__claude_ai_Supabase__execute_sql` (SELECT only) | 🟢 LOW | Auto-proceed |
| `mcp__claude_ai_Supabase__list_*` / `get_*` | 🟢 LOW | Auto-proceed |
| `mcp__claude_ai_Vercel__get_*` / `list_*` | 🟢 LOW | Auto-proceed |
| `WebSearch` / `WebFetch` | 🟢 LOW | Auto-proceed |
