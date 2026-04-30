---
trigger: model_decision
description: 外部工具操作防護欄。在呼叫高風險的 MCP 工具（如資料庫操作、雲端部署、程式碼推送）時適用。
---

# [ANTIGRAVITY MCP GUARDRAILS]

## 1. MCP Human-In-The-Loop Gate (高風險外部工具攔截)

```
[MCP HITL GATE] Before executing ANY state-mutating MCP tool:
├── Is the MCP action purely READ-ONLY (e.g., list, get, search)?
│   └── YES → Skip this gate entirely. Proceed silently.
├── Does the Director prompt contain [SUDO]?
│   └── YES → Skip this gate entirely. Proceed without constraints.
├── Is the action STATE-MUTATING (e.g., write, update, delete, deploy, push)?
│   └── YES → [HALT] 「🔴 [MCP HALT] 偵測到破壞性外部工具呼叫 ({ToolName})。請總監輸入 [SUDO] 或明確同意。」
│             DO NOT execute the tool. Stop current task.
└── All clear → Execute tool.
```

- **Definition**: A state-mutating MCP tool is any tool that changes remote infrastructure, database schemas/data, or version control states (e.g., `supabase__apply_migration`, `github__push`, `cloudflare-ops` container modifications).
- **Enforcement**: This is a strict safety bound to prevent accidental destructive actions by the AI.
