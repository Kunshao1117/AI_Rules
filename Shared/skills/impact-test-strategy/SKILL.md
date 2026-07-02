---
name: impact-test-strategy
description: >
  [Testing] Change impact analysis, test scope orchestration, and regression test generation.
  Use when: 跨模組修改（變更影響 2+ 模組）、核心工具/共用服務重構、或 /04_fix 修復後需產生回歸測試 的場景。
  DO NOT use when: 單一模組內的局部修改、僅樣式/文字調整、設定檔變更。
metadata:
  author: antigravity
  version: "5.2"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Impact & Test Strategy — 影響與測試策略

## 1. Impact Analysis Flow (影響分析流程)

Execute BEFORE code modification:

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
- 建議測試範圍：{see § 2}
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

## 2. Test Scope Decision Tree (測試範圍決策樹)

```
Change type?
├── Hotfix → Run: Source module unit tests + Source module E2E
├── Cross-module → Run: All affected modules' unit tests + Full E2E
├── Core utility refactor → Run: ALL unit tests + Full E2E
├── UI-only → Run: E2E visual test for affected pages only
└── Config / Environment → Run: Full E2E suite (no unit tests)
```

Real-path scope rule:

- If the change affects user-visible behavior, data flow, persistence, network requests, files, scheduled jobs, CLI output, permissions, or external integrations, include at least one real execution path in the recommended test scope.
- Before marking real execution unavailable, include operator-tool discovery in the scope: search project scripts, documented commands, routes, test harnesses, browser or desktop operation paths, plugin hosts, logs, databases, and direct request options.
- Treat transient readiness, timeout, or tool-connection failures as retryable evidence gaps first. They do not remove the need for the real execution path.
- If real execution is blocked, list the blocker and the closest controlled real-path alternative, such as preview branch, local service, dry-run, sandbox database, recorded real response, or read-only production check.
- Unit tests, mocks, fixtures, and visual screenshots may support the regression scope, but cannot replace the real execution path for behavior-dependent completion.

### Execution Protocol (執行協定)

1. Unit tests first
2. Fix unit test failures before proceeding to E2E
3. E2E tests last

## 3. Regression Test Generator (回歸測試產生器)

After `/04_fix` bug fix, generate a regression test:

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

1. Write the regression test using `test-patterns` skill's § 1 decision tree for file placement
2. Name the test descriptively: `it('should not regress: {bug description}')`
3. Document one short English evidence item in the module's memory card `## Cycle Events`

### /04_fix Completion Gate Integration

- [ ] Regression test generated for the fixed bug
- [ ] Regression test passes
- [ ] Lesson documented in memory card

## Constraints (限制與邊界)

- Primary testing-context source: memory card `## Relations` section
- `## Relations` is navigation context only. It does not equal frontmatter `dependencies` and must not be used for indirect staleness propagation.
- No memory cards → fall back to `grep_search` for import/require analysis
- This skill determines WHICH tests to run — does NOT execute them
- Test execution: via terminal `run_command`

## References (參考資源)

- `references/regression-test-examples.md` — Common regression test patterns with code examples
