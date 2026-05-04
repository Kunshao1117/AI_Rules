# [MCP GUARDRAILS]

> Apply when: calling state-mutating MCP tools (database ops, cloud deployment, code push).

## 1. MCP Human-In-The-Loop Gate (高風險外部工具攔截)

```
[MCP HITL GATE] Before executing ANY state-mutating MCP tool:
├── Is the action purely READ-ONLY (list, get, search, query)?
│   └── YES → Check §2 Permission Matrix. If 🟢 LOW → Proceed silently.
├── Does the Director prompt contain [SUDO]?
│   └── YES → Skip gate entirely.
├── Is the action STATE-MUTATING (write, update, delete, deploy, push)?
│   └── YES → Output Justification Block FIRST:
│         【操作理由】為什麼需要執行此操作（商業語言描述）
│         【影響範圍】此操作可能影響的系統或資料
│         【回滾方案】若操作失敗的復原策略
│         THEN → [HALT]「🔴 [MCP HALT] 偵測到破壞性外部工具呼叫 ({ToolName})。請總監輸入 [SUDO] 或明確同意。」
│         DO NOT execute. Stop current task.
└── All clear → Execute tool.
```

## 2. Tool-Level Permission Matrix (工具級權限分級)

| Tool | Risk | Gate |
|---|---|---|
| `mcp__claude_ai_Supabase__execute_sql` (non-SELECT) | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Supabase__apply_migration` | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Supabase__deploy_edge_function` | 🔴 HIGH | Director approval + Justification |
| `mcp__claude_ai_Vercel__deploy_to_vercel` | 🔴 HIGH | Director approval + Justification |
| Bash `git push` | 🟡 MEDIUM | Justification Block (auto-logged) |
| Bash `git commit` | 🟡 MEDIUM | Justification Block (auto-logged) |
| `mcp__claude_ai_Supabase__execute_sql` (SELECT only) | 🟢 LOW | Auto-proceed |
| `mcp__claude_ai_Supabase__list_*` / `get_*` | 🟢 LOW | Auto-proceed |
| `mcp__claude_ai_Vercel__get_*` / `list_*` | 🟢 LOW | Auto-proceed |
| `WebSearch` / `WebFetch` | 🟢 LOW | Auto-proceed |
