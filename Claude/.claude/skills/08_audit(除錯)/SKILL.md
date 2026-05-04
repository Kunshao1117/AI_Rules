---
name: 08_audit
description: 全光譜專案健檢 — 依賴安全掃描、邏輯深度審查、記憶卡對齊、紅黃綠燈號報告
required_skills: [memory-ops, code-audit, audit-engine]
memory_awareness: full
user-invocable: true
---

# [SKILL: /08_audit — 全光譜健檢]

## Phase 1: Infrastructure Audit (基礎盤點)

### 1.1 Dependency Security (依賴安全)
- Run `npm audit` via `Bash` tool. Parse severity levels.
- Run `npx tsc --noEmit` for TypeScript type safety check.

### 1.2 Memory Topology Check (記憶拓樸)
- Read all memory cards from MEMORY.md index.
- Check each card for staleness (compare tracked files vs actual source).
- Flag orphaned memory cards (tracking deleted files).
- Flag untracked source files (no memory card coverage).

### 1.3 Dead Code & Orphan Detection (死碼偵測)
- Scan for unused exports, unreferenced files.
- Cross-reference with memory card `## Tracked Files`.

---

## Phase 2: Logic Depth Audit (深度邏輯)

### 2.1 Security Review (S1–S5)
- S1: Authentication flow integrity
- S2: Authorization/RLS policy coverage
- S3: Input validation completeness
- S4: Credential isolation (no hardcoded secrets)
- S5: API endpoint exposure audit

### 2.2 API Contract Alignment (前後端串接)
- Compare frontend API calls vs backend route definitions.
- Flag mismatched types, missing endpoints, deprecated routes.

### 2.3 Test Coverage Gap (測試缺口)
- Identify critical paths without test coverage.
- Prioritize by business impact.

---

## Phase 3: Report Generation (報告產出)

Generate health report in Traditional Chinese:

### Traffic Light Dashboard (紅黃綠燈號)
| 項目 | 燈號 | 摘要 |
|---|---|---|
| 依賴安全 | 🟢/🟡/🔴 | ... |
| 型別安全 | 🟢/🟡/🔴 | ... |
| 記憶拓樸 | 🟢/🟡/🔴 | ... |
| 安全架構 | 🟢/🟡/🔴 | ... |
| 前後端串接 | 🟢/🟡/🔴 | ... |
| 測試覆蓋 | 🟢/🟡/🔴 | ... |

### Priority Action Items (優先修復清單)
Ordered by severity × business impact.

Append:「[健檢完成] 如需修復，請對指定項目執行 /04_fix。」

---

## [SECURITY & COMPLIANCE]
- **Role**: Reader — no source code modifications during audit.
- **Memory**: full — memory topology check and staleness repair during audit.
