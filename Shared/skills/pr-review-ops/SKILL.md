---
name: pr-review-ops
description: >
  程式碼審查與合併準備檢查（MCP: github）：PR 程式碼審查、結構化 review comments、CI 狀態檢查與 merge readiness 判定；
  PR automated review recipes。
  Use when: 需要 reviewing PR code、提交 structured review comments、檢查 CI status、
  或判斷 PR merge readiness。
  DO NOT use when: 需要建立 branch、push 檔案、issue 管理或一般 GitHub 操作；用 github-ops。
  MCP Server: github
metadata:
  author: antigravity
  version: "5.3"
  origin: framework
  kind: operational
  memory_awareness: read
  mcp_servers: [github]
  tool_scope: ["mcp:github"]
---

# PR Review Ops — Automated Code Review Recipes

## HITL Boundary

- Read-only tools (`list`, `get`, `search`, `query`, status/health checks) may proceed silently.
- State-mutating, external-state, write, deploy, push, delete, reset, or resolve operations require a scope-bound intent signal from the Director; authorization resolution must bind it to the visible plan, command/tool, phase, expiry, and target external state before the matching protected gate can pass.
- `[MCP HITL GATE]` is an additional execution gate for MCP calls; it does not replace authorization resolution or authorize a separate protected phase.
- Discovery of tool schemas is not permission to execute mutating tools.

## Trigger Conditions

- 總監要求審查特定 PR（code review on a specific PR）
- 健檢流程（`/08_audit`）發現待審 PR
- 建構後工作流需要 peer review gate

## Recipe 1: PR Content Analysis

1. `get_pull_request` — Get PR metadata (title, description, author, base/head branch)
2. `get_pull_request_files` — List all changed files with status
   - `status` values: `added` / `modified` / `removed`
   - Note `changes` count per file to prioritize review effort
3. `get_pull_request_comments` — Read existing review comments to avoid duplicates
4. For each significant changed file, use `get_file_contents` to read full context

## Recipe 2: Structured Review Submission

1. Analyze changes against the following review checklist:

   **Quality checklist**:
   - [ ] Naming conventions are consistent for functions, variables, and files.
   - [ ] No hard-coded sensitive data, such as API keys or passwords.
   - [ ] Error handling covers try/catch paths and boundary cases.
   - [ ] TypeScript is type-safe, with no avoidable `any` and appropriate `unknown`.
   - [ ] File length stays within the `code-quality` thresholds.
   - [ ] No unused imports or variables.
   - [ ] Non-business-logic changes, such as refactors, have test coverage.

2. `create_pull_request_review` — Submit structured review
   - `event`: `APPROVE` / `REQUEST_CHANGES` / `COMMENT`
   - Include specific file + line references in `body`
   - Use business-level language in review comments.

## Recipe 3: Merge Decision Flow

```
[MERGE GATE] Approval decision:
├── [SUDO] detected? → Record override/risk-closure request; do not approve, merge, or skip checks.
├── CI status = success?
│   ├── NO → [HALT] 「🔴 [PR HALT] 持續整合未通過（CI failed）。拒絕合併。」
│   └── YES → Continue.
├── Security checklist items from Recipe 2 ALL passed?
│   ├── NO → Submit REQUEST_CHANGES. Block merge.
│   └── YES → Continue.
├── At least one APPROVE review exists?
│   ├── NO → [HALT] 「🔴 [PR HALT] 尚無核准審查。」
│   └── YES → Approve merge.
└── Gate cleared → merge_pull_request.
```

## Gotchas

- Always read existing comments before submitting review to avoid redundant feedback.
- `create_pull_request_review` with `REQUEST_CHANGES` blocks merge; use it thoughtfully.
- Review comments are visible to all collaborators; maintain a professional tone.
- For large PRs with 20 or more files, prioritize reviewing `modified` files over `added` files.

## Interpretation

- `get_pull_request_files` — `additions` and `deletions` indicate change magnitude.
- `get_pull_request_status` — `total_count` shows number of configured CI checks.
- High-risk indicators include auth files, database migrations, and environment config changes.
