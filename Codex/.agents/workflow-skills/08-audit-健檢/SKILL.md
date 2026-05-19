---
name: "08-audit-健檢"
description: "Use when: 全光譜專案健檢、audit、治理巡檢、基礎盤點、深度邏輯審查與健康報告。DO NOT use when: 只要單一測試或單一 bug 修復。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: audit
  role: analyst
  memory_awareness: full
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
  human_gate: "none"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# source-command-08-audit-skill

Use this skill when the user asks to run the migrated source command `08_audit(健檢)-SKILL`.

## Command Template

# [SKILL: /08_audit — 全光譜健檢（三階段入口）]

> 本工作流為三階段健檢的**入口控制器**，不包含實際掃描邏輯。
> 實際邏輯分別在 `08-1_infra/`、`08-2_logic/`、`08-3_report/` 子工作流中。

## Phase 1 → 基礎盤點

> [LOAD SKILL] Read `08_audit(健檢)/08-1_infra/SKILL.md`

執行 §1.1–§1.5 並收集基礎盤點報告物件。

---

## Phase 2 → 深度邏輯審查

> [LOAD SKILL] Read `08_audit(健檢)/08-2_logic/SKILL.md`

執行 §2.1–§2.5 並收集深度邏輯報告物件。

---

## Phase 3 → 健檢總結報告

> [LOAD SKILL] Read `08_audit(健檢)/08-3_report/SKILL.md`

合併 Phase 1 + Phase 2 報告物件，執行 §3.1–§3.3，輸出最終燈號儀表板。

---

## 單獨觸發模式（Partial Audit）

若總監只需要特定階段：

```
[PARTIAL AUDIT GATE]
├── 「/08_audit infra」或「只跑基礎盤點」→ 僅執行 Phase 1
├── 「/08_audit logic」或「只跑邏輯審查」→ 僅執行 Phase 2
├── 「/08_audit report」→ 使用上次快取的報告物件直接出燈號
└── 無修飾詞 → 執行完整三階段
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 全程唯讀，不修改任何原始碼。記憶卡讀取被允許。
