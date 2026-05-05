---
name: 08-2_logic
description: 健檢第二階段：深度邏輯審查 — 安全架構五維審查、API 前後端串接比對、測試覆蓋缺口分析、死碼偵測
required_skills: [audit-engine, code-diagnosis]
memory_awareness: full
user-invocable: false
---

# [SKILL: /08_audit — Phase 2: 深度邏輯審查]

> 本工作流由 `08_audit(健檢)/SKILL.md` 入口觸發，不應直接呼叫。

## 2.1 Security Review (S1–S5 安全架構審查)

> [LOAD SKILL] 確認 `.agents/skills/audit-engine/SKILL.md` 已載入。

- **S1: 認證流程完整性** — 驗證所有受保護路由均有認證守衛
- **S2: 授權/RLS 政策覆蓋** — 確認資料庫查詢有適當的 RLS 政策
- **S3: 輸入驗證完整性** — 所有使用者輸入是否有 Zod/Yup 等驗證
- **S4: 憑證隔離** — 掃描 hardcoded secrets、API Key 外洩風險
- **S5: API 端點暴露** — 公開端點是否有不必要的資料外洩

## 2.2 API Contract Alignment (前後端串接比對)

- 收集前端 API 呼叫清單（`fetch()`、`axios`、`trpc`、`supabase.from()` 等）
- 比對後端路由定義（`app/api/*/route.ts` 或類似結構）
- 標記：
  - 前端呼叫但後端不存在的端點（斷鏈）
  - 型別不符的請求/回應格式
  - 已棄用但仍被呼叫的路由

## 2.3 Test Coverage Gap (測試覆蓋缺口)

- 識別核心業務路徑中缺少測試覆蓋的區域
- 依「業務影響 × 缺口嚴重程度」排序優先修復清單

## 2.4 Dead Code & Orphan Detection (死碼偵測)

> [LOAD SKILL] 若涉及 3+ 模組診斷，確認 `.agents/skills/code-diagnosis/SKILL.md` 已載入。

- 掃描未使用的 export、未被 import 的檔案
- 與記憶卡 `## Tracked Files` 交叉比對，找出已追蹤但實際已移除的檔案

## 2.5 Output

產出深度邏輯報告物件，傳遞給 Phase 3（08-3_report）彙整：
```
{
  security: { s1, s2, s3, s4, s5 },  // 各維度：{ status: green|yellow|red, findings[] }
  api_alignment: { broken_links[], type_mismatches[], deprecated[] },
  test_coverage: { critical_gaps[] },
  dead_code: { unused_exports[], orphan_files[] }
}
```

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.claude/commands/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Reader` | 純分析審查，不修改任何原始碼或記憶卡。
