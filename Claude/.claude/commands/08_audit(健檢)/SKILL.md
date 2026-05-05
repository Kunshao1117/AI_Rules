---
name: 08_audit
description: 全光譜專案健檢入口 — 依序觸發三階段：基礎盤點（08-1）→ 深度邏輯審查（08-2）→ 紅黃綠燈號報告（08-3）
required_skills: [memory-ops, code-audit, audit-engine]
memory_awareness: full
user-invocable: true
---

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

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader/Memory` | 全程唯讀，不修改任何原始碼。記憶卡讀取被允許。
