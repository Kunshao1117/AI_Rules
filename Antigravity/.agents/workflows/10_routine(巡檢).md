---
name: 10_routine(巡檢)
description: "Git-only 唯讀狀態回報：只適用於 Git 工作樹、HEAD、追蹤分支與 origin 關係（Use when: Git status report）。不適用於任何內容檢查、修復或寫入（DO NOT use when: inspect content, fix, or write）。"
required_skills: []
memory_awareness: none
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
  lifecycle_phase: routine
  role: reader
  memory_awareness: none
  tool_scope: ["filesystem:read", "terminal:read"]
  human_gate: "none for Git-only read-only reporting; any mutation needs its own scoped workflow"
  automation_safe: true
---

## Git-Only Routine Contract

This workflow reports only Git worktree state, `HEAD`, the tracking branch,
and the relation to `origin`.

- Report each relation as synchronized, behind, ahead, diverged, or unable to confirm.
- Do not scan policies, skills, documentation, memory, hooks, configuration, or source content.
- Do not run package-manager, compiler, linter, audit, browser, MCP, or interactive batch commands.
- Do not write, fix, stage, commit, push, or mutate external state.
