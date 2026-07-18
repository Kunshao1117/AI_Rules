---
name: test-patterns
description: >
  單元測試與 API 契約測試模式（Testing）：Unit test scaffolding, API contract validation, and error boundary scenario library.
  Use when: 現有驗收已包含精確的 unit 或 API-contract 測試範圍，或操作員已精確核准。
  DO NOT use when: 測試範圍未獲明確接受與授權，或為 browser E2E visual testing
  （已授權時使用 browser-testing + test-automation-strategy），或為 performance measurement。
metadata:
  author: antigravity
  version: "5.2"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal"]
---

# Test Patterns — 測試模式庫

## Test Scope Opt-In

This skill supplies methods only after the canonical test-admission owner has
found all three conditions true: a qualifying non-visual invariant, no suitable
current-session non-destructive real-tool evidence, and acceptance-bound or
precisely approved exact test scope. It does not itself admit unit,
API-contract, error-scenario, mock, regression tests, or a test project/runner.
When a real tool can prove the acceptance, do not create a test. See
`Shared/policies/authorization-resolution.md`.

## 1. Test Decision Tree (測試決策樹)

Within an authorized test scope, choose the pattern for the accepted behavior:

（僅在已授權的測試範圍內，依據以下決策樹選擇測試模式）

```
Authorized behavior type?
├── Utility / Service functions (計算、轉換、驗證)
│   └── Unit-test pattern
│       → Use template: references/utility-test-template.md
├── API route handler (路由處理器)
│   └── Unit-test and accepted error-scenario patterns
│       → Use template: references/api-route-test-template.md
│       → Apply § 3 Error Scenario Checklist
├── State management logic (Hook, Store, State Machine)
│   └── Unit-test pattern
│       → Use template: references/hook-test-template.md
├── Pure UI component (僅樣式/佈局，無邏輯)
│   └── Use a browser-evidence pattern only when the acceptance authorizes it
├── Config / Declarative routes (設定檔/宣告式路由)
│   └── Use acceptance-bound static validation when applicable; do not infer a test
└── Database model / Schema definition
    └── Use only the specifically accepted validation or test method
```

## 2. Test File Conventions (測試檔案慣例)

Check `_system` memory card for project-specific conventions first.

### Default Conventions (預設慣例)

- **Placement**: Co-located with source file
- **Naming**: `{filename}.test.ts` or `{filename}.spec.ts`
- **Runner**: Read from `_system` memory card tech stack section
- **Run command**: `npx jest {path}` or `npx vitest run {path}`

### Override Protocol (覆寫協定)

If `_system` memory card specifies `__tests__/` directory convention, follow that instead.

## 3. Error Scenario Checklist (異常場景清單)

### API Route Candidate Scenarios (可選場景)

When the accepted test scope names an API route, select only the scenarios needed by that acceptance:

| Scenario | Expected Status | Description |
| --- | --- | --- |
| Valid request（正常請求） | 200/201 | Happy path with correct payload（正確格式的正常請求） |
| Missing required fields（缺少必填欄位） | 400 | Payload missing required properties（缺少必填屬性） |
| Invalid field types（欄位型別錯誤） | 400 | Wrong data types in payload（傳入錯誤的資料型別） |
| Unauthenticated（未登入） | 401 | No auth token or expired token（無認證令牌或令牌過期） |
| Unauthorized（無權限） | 403 | Valid token but insufficient permissions（令牌有效但權限不足） |
| Resource not found（資源不存在） | 404 | Request targets non-existent resource（請求不存在的資源） |
| Duplicate creation（重複建立） | 409 | Creating already-existing unique resource（建立已存在的唯一資源） |
| Server error isolation（伺服器錯誤隔離） | 500 | Simulate DB failure — response must NOT leak internals（模擬資料庫故障，回應不可洩漏內部細節） |

### Frontend Error Handling Scenarios (前端異常場景)

When the accepted test scope covers frontend API handling, these are candidate states:

| Scenario                       | Expected Behavior                                       |
| ------------------------------ | ------------------------------------------------------- |
| Network offline（網路離線）    | Show friendly "連線不穩定" message + retry button       |
| API timeout（API 逾時）        | Show loading indicator → timeout message → retry option |
| Auth expired (401)（認證過期） | Auto-redirect to login page                             |
| Forbidden (403)（無權限）      | Show "權限不足" message, no retry                       |
| Corrupted response（損壞回應） | Graceful fallback, not white screen of death            |

## 4. API Contract Validation (前後端契約驗證)

### Step 1: Identify the Contract

1. Locate backend Zod schema (or equivalent) for the target API route
2. Locate frontend fetch/axios call and its payload/response types

### Step 2: Cross-Validate

1. Compare field names: frontend vs backend → Flag mismatch
2. Compare field types: frontend sends vs backend expects → Flag mismatch
3. Compare required/optional: frontend omits backend-required field → Flag mismatch
4. Compare response shape: frontend expects vs backend returns → Flag mismatch

### Step 3: Report or Fix

- During `/03_build` → Repair only when the acceptance and source-write authorization include it

## 5. Mock Strategy Decision Tree (Mock 策略決策樹)

- Unit tests and mocks validate scoped logic and contracts.
- They do not prove that the complete feature works against the real runtime.
- They do not prove behavior against the real data source or real external service.
- They do not prove behavior against real file system state, real browser behavior, or real operator workflow.

Use mocks to isolate:

- Error handling
- Branch coverage
- Contract assumptions
- Deterministic unit behavior

Do not use mocks, fixtures, fake timers, seeded data, or synthetic screenshots as completion evidence.

This applies to data-dependent or integration-dependent features.

Pair them with real execution evidence through:

- `ai-dev-quality-gate`
- `browser-testing`
- terminal commands, database queries, logs, preview deployments, or controlled real-path environments

If that real path is unavailable, document:

- operator-tool discovery
- transient retry status
- equivalent real-path alternatives considered
- the remaining blocker

```
What are you mocking?
├── External API calls (fetch/axios to third-party)
│   └── Use MSW (Mock Service Worker) or fetch mock
│       → Intercept at network level, not at module level
├── Database operations (DB read/write)
│   └── Use repository pattern mock
│       → Mock the repository/service layer, not the DB client
├── File system operations (讀寫檔案)
│   └── Use memfs or temp directory
│       → Never mock fs module directly
├── Time-dependent logic (時間相關)
│   └── Use fake timers (jest.useFakeTimers)
│       → Control Date.now() and setTimeout
└── Environment variables (環境變數)
    └── Use process.env override in test setup
        → Restore original values in afterEach
```

## 5.5 Mock Presence Gate (Mock 存在性閘門)

```
[MOCK GATE] Before finalizing an authorized test file:
├── [SUDO] detected? → Record override/risk-closure request; continue this gate.
│   It does not skip mock checks or authorize real network calls.
├── Test file contains external API calls (fetch/axios)?
│   ├── NO  → Proceed silently.
│   └── YES → Mock/MSW interceptor present?
│       ├── YES → Proceed silently.
│       └── NO  → [HALT] 「🔴 [TEST HALT] 偵測到外部 API 呼叫但無 Mock 攔截。」
│                 Request an exact test-scope expansion before adding an MSW handler.
└── Gate cleared.
```

## 6. Memory Card Integration (記憶卡整合)

When an authorized test scope uses a target module's memory card, cross-reference:

1. `## Current Truth` → Align the accepted test behavior with current valid behavior
2. `## Active Constraints` → Cover only the documented limits and edge cases named by acceptance
3. `## Applicable Skills` → Load referenced skills for domain-specific constraints

## Constraints (限制與邊界)

- Scope: unit tests and contract validation ONLY
- No test creation, modification, or execution occurs without the canonical opt-in authorization.
- Mocked, fixture, or fake-time tests are partial evidence only.
- They cannot complete a real-runtime-dependent feature by themselves.
- E2E browser tests: `browser-testing` + `test-automation-strategy`
- Performance testing: NOT covered
- Test execution: via terminal `run_command`, NOT MCP tools
