---
name: impact-test-strategy
description: >
  變更影響與回歸測試策略（Testing）：Change impact analysis, test scope orchestration, and regression test generation.
  Use when: 現有驗收已明確指名測試範圍，或操作員已精確核准測試差異，
  適用於跨模組變更、核心工具/共用服務重構，或已授權的回歸測試。
  DO NOT use when: 測試範圍未獲明確接受與授權，或僅為沒有已接受測試需求的局部樣式、文字、
  設定或靜態資料工作。
metadata:
  author: antigravity
  version: "5.2"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Impact & Test Strategy — 影響與測試策略

## Test Scope Opt-In

This skill is a method for an already authorized test scope; it does not decide that tests are
necessary. Do not create, modify, discover for execution, or run tests unless the current acceptance
and exact authorization permit them. Validation, quality preference, regression rationale, workflow
route, and impact level do not grant that permission. The canonical owner is
`Shared/policies/authorization-resolution.md`; this skill applies only after that policy's tool-first
gate establishes that a minimal test exception is necessary.

## 1. Impact Analysis Flow (影響分析流程)

Use this flow only when an accepted test scope needs impact mapping:

### Step 1: Map File → Module (檔案→模組映射)

```
Modified file identified?
├── Read .agents/memory/ — scan all memory cards' ## Tracked Files
├── Find which memory card(s) track this file
└── Result: "This file belongs to module {X}"
    └── If no memory card tracks this file → Flag as untracked, proceed with caution
```

### Step 2: Map Module → Affected Modules (模組→受影響模組)

```
Source module identified?
├── Read the source module's ## Relations section for navigation/testing context
├── List all modules that DEPEND ON the source module
│   └── These modules may break if the source module's interface changes
├── List all modules that the source module DEPENDS ON
│   └── Changes here should NOT affect dependents (unless interface changed)
├── List all outward-facing documentation files related to this module's public interface (e.g., README.md, docs/)
│   └── Documentation must be marked as an affected target if the module's behavior changes.
└── Result: Affected module list + dependency direction + affected documentation
```

### Step 3: Risk Classification (風險分級)

| Risk Level | Criteria                                                            | Examples                                    |
| ---------- | ------------------------------------------------------------------- | ------------------------------------------- |
| 🔴 High    | File is imported by 3+ modules, OR is a core utility/shared service | `utils.ts`, `auth-service.ts`, shared hooks |
| 🟡 Medium  | File is internal to a module but affects module's public interface  | Module's main export, API route handler     |
| 🟢 Low     | File is a leaf component used by only one parent                    | Single-use UI component, isolated helper    |

### Step 4: Output Impact Report (輸出影響報告)

Include in `implementation_plan.md`:

```markdown
【影響分析】

- 修改檔案：{file path}
- 所屬模組：{module name}
- 風險等級：🔴/🟡/🟢
- 受影響模組：{list of affected modules}
- 關聯文件：{documentation files that require sync}
- 已授權測試範圍：{see § 2}
- 真實驗證路徑：{real operation surface, data source, executable path, and blocker status}
```

### Step 5: Impact Array Validation (影響陣列驗證)

```
[IMPACT GATE] Before proceeding to code modification:
├── [SUDO] detected? → Record override/risk-closure request; do not allow blind edits or skip impact evidence.
├── affected_modules[] array length > 0?
│   ├── YES → Proceed with modification.
│   └── NO  → [HALT] 「🔴 [IMPACT HALT] 影響範圍分析結果為空。請先確認波及模組。」
│             DO NOT modify code without understanding blast radius.
└── Gate cleared.
```

## 2. Authorized Test Scope Selection (已授權測試範圍選擇)

```
Does current acceptance and exact authorization name a test action?
├── NO → Do not select, create, modify, or run a test. Return to the acceptance-bound validation route.
└── YES → Select only the named behavior, files, commands, data/fixtures, phase, and expiry:
    ├── Authorized unit behavior → use the scoped unit-test method
    ├── Authorized browser behavior → use the scoped E2E or visual-test method
    ├── Authorized regression behavior → use the scoped regression-test method
    └── Other authorized behavior → use only the explicitly approved test technique
```

Real-path scope rule:

- When an authorized test scope requires a real execution path for user-visible behavior, data flow, persistence, network requests, files, scheduled jobs, CLI output, permissions, or external integrations, include that named path in the scope.
- Before marking real execution unavailable, include operator-tool discovery in the scope: search project scripts, documented commands, routes, test harnesses, browser or desktop operation paths, plugin hosts, logs, databases, and direct request options.
- Treat transient readiness, timeout, or tool-connection failures as retryable evidence gaps first. They do not remove the need for the real execution path.
- If real execution is blocked, list the blocker and the closest controlled real-path alternative, such as preview branch, local service, dry-run, sandbox database, recorded real response, or read-only production check.
- Unit tests, mocks, fixtures, and visual screenshots may support the regression scope, but cannot replace the real execution path for behavior-dependent completion.

### Execution Protocol (執行協定)

Follow the order in the exact authorized commands. Do not infer unit, E2E, full-suite, or regression
execution from the change type alone.

## 3. Authorized Regression Test Design (已授權回歸測試設計)

When a bug-fix acceptance expressly authorizes a regression test, design it as follows:

### Step 1: Analyze the Fix Diff (分析修復差異)

From the code diff, extract:

- **Root cause pattern**: Bug type
- **Trigger condition**: Input/state that caused the bug
- **Expected behavior**: Correct behavior

### Step 2: Select Regression Template (選擇回歸模板)

```
What type of bug was fixed?
├── Validation bypass (驗證繞過)
│   └── Template: "Send the exact invalid input that previously bypassed validation"
├── Null reference (空值引用)
│   └── Template: "Pass null/undefined for the field that caused the crash"
├── Race condition (競爭條件)
│   └── Template: "Simulate concurrent operations that previously conflicted"
├── Wrong status code (錯誤狀態碼)
│   └── Template: "Verify the exact HTTP status code for the scenario"
├── Missing data transformation (資料轉換遺漏)
│   └── Template: "Verify data shape matches expected contract"
└── UI state desync (UI 狀態失同步)
    └── Template: "Reproduce the exact user action sequence that caused the desync"
```

### Step 3: Write and Register (撰寫並註冊)

1. Create or change only the authorized test files, using `test-patterns` skill's § 1 placement method.
2. Name the test descriptively: `it('should not regress: {bug description}')`.
3. Route any memory update through its separate protected memory authorization; this test scope does not authorize it.

### /04_fix Completion Gate Integration

- [ ] The accepted regression test delta was delivered, if one was authorized.
- [ ] The exact accepted test command produced its recorded evidence, if execution was authorized.
- [ ] Any memory lesson follows a separately authorized memory route.

## Constraints (限制與邊界)

- Primary testing-context source: memory card `## Relations` section
- `## Relations` is navigation context only. It does not equal frontmatter `dependencies` and must not be used for indirect staleness propagation.
- No memory cards → fall back to `grep_search` for import/require analysis
- This skill determines an already accepted test scope; it does not make testing a default or execute it.
- Test execution, when precisely authorized, uses the named terminal command.

## References (參考資源)

- `references/regression-test-examples.md` — Common regression test patterns with code examples
