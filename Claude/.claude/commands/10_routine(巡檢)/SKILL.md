---
name: 10_routine
description: "Use when: automation-safe 例行巡檢、唯讀健康檢查、技能品質、文件數字、記憶過期與 MCP 設定健康。DO NOT use when: 需要直接修復或寫入檔案。"
required_skills: [memory-ops, code-audit]
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: routine
  role: reader
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "GO required before writes"
  automation_safe: true
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /10_routine — 例行巡檢]

## 1. Scope

Use this Slash Command for scheduled or manually triggered maintenance checks. It is read-only by default and safe for automation.

## 2. Read-only Checks

- Run skill quality checks for `Shared/skills/` and `.claude/skills/`.
- Compare documented platform, skill, workflow, and command counts against the live filesystem.
- Inspect `.agents/memory/` for stale tracked files, missing references, or outdated platform descriptions.
- Inspect MCP resources/prompts and opt-in profile snippets without installing or modifying servers.
- Search for old counts, obsolete paths, and outdated version labels.

## 3. Human Gate

- Do not create, edit, delete, stage, commit, push, or install anything during routine inspection.
- If a fix is needed, report the exact files and proposed edits.
- Stop with:
  > `[例行巡檢閘門] 巡檢已完成。若要套用修正，請輸入 GO。`

## 4. Output

Report in Traditional Chinese with platform capability consistency, workflow metadata health, MCP profile health, automation-safe status, and stale documentation or memory findings.
