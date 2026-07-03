---
trigger: always_on
---

# [ANTIGRAVITY GLOBAL BOOTSTRAPPER]

This file confirms that the Antigravity `.agents/` ecosystem has been deployed to this project.

The full bootstrapping protocol (Zero-Touch Environment Check, Silent Deployment, Post-Deployment Notification) is defined in the `user_global` system-level rule injected by Gemini IDE. This file serves as a sentinel — its presence tells the Agent that the workspace is already initialized and no deployment is needed.

## Framework Components

- **Rules**: Core mandate and bootstrapper sentinel (00–07; 00/01 always-on, 02–07 on-demand). 07 includes tool-level permission matrix.
- **Workflows**: 20 lifecycle workflow files + 2 shared gates
  - 建構系列：`03_build(建構計畫)` / `03-1_experiment` / `03-2_build_execute`
  - 修復系列：`04-1_fix_plan` / `04-2_fix_execute`
  - 濃縮系列：`05_condense(濃縮)` — 專案初始化萃取
  - 提交系列：`09-1_commit_scan` / `09-2_commit_execute`
  - 健檢系列：`08_audit(健檢)` / `08-1_audit_infra` / `08-2_audit_logic` / `08-3_audit_report`
  - 例行巡檢：`10_routine(巡檢)` — automation-safe read-only maintenance
  - 其他：00–02, 06–07, 11–12 各一個工作流
  - 共用閘門：`_completion_gate` / `_security_footer`
- **Skills**: 62 shared operational skills + project memory cards + project context cards
- **Platform governance**: deployed project reference `.agents/shared/platform-capability-matrix.md` defines native/adapter/manual capability levels; the framework source repository keeps the original at `Shared/platform-capability-matrix.md`. Workflow frontmatter MUST carry metadata v2 (`kind`, `platforms`, `lifecycle_phase`, `role`, `memory_awareness`, `tool_scope`, `human_gate`, `automation_safe`).
- **MCP profile policy**: external MCP servers are opt-in only. Use deployed snippets in `.agents/shared/mcp-profiles/`; the framework source repository keeps the originals under `Shared/mcp-profiles/`. Never install or modify global MCP config during Fresh/Upgrade/Audit.

<!-- PROJECT IDENTITY 保護區段格式定義：
     由 /05_condense 工作流生成，升級時由部署腳本保留。
     起始標記：## [PROJECT IDENTITY — /05_condense 生成，升級時保留]
     結束標記：<!-- /PROJECT_IDENTITY_END -- >
     部署腳本識別這兩個標記之間的內容，升級時不覆蓋。 -->
