---
name: context7-docs
description: >
  即時框架文件查詢（MCP: context7）：官方文件證據、框架 API 確認與版本指定查詢；
  live framework documentation query recipes。
  Use when: 需要即時文件查詢、框架 API 確認、Next.js/React/Payload CMS 文件證據、
  或版本相容性查證；English: live docs lookup and version-specific official docs.
  DO NOT use when: 不確定框架名稱且需先用 web search 找來源，或不需要即時文件查詢；
  English: framework unknown or live docs lookup not needed.
  MCP Server: context7
metadata:
  author: antigravity
  version: "5.3"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [context7]
  tool_scope: ["mcp:context7"]
---

# Context7 Docs — Live Documentation Query Recipes

## Trigger Conditions

- 編碼時不確定 framework API（Uncertainty about a framework API during coding）
- 需要確認 API 是否在最新版本廢棄或變更（deprecated or changed in the latest version）
- 建構或修復流程（`/03_build` 或 `/04_fix`）遇到框架特定問題
- 總監詢問 framework best practices

## Recipe 1: Framework Documentation Query

### Step 1: Resolve Library ID

1. Call `resolve-library-id` with both required parameters:
   - `libraryName`: framework or package name, such as `"nextjs"`, `"react"`, or `"payloadcms"`
   - `query`: what you are trying to do, such as `"Next.js framework"` or `"React UI library"`
   - Returns: Library ID in `/org/project` format, such as `/websites/nextjs`
2. If multiple results returned, select based on:
   - Name match > Source Reputation (High > Medium) > Benchmark Score > Code Snippet count

### Step 2: Query Documentation

1. Call `query-docs` with both required parameters:
   - `libraryId`: ID from Step 1, such as `/websites/nextjs`
   - `query`: specific technical question, such as `"App Router server components data fetching"`
   - Use specific, targeted queries for best results
   - ✅ Good: `"App Router server components data fetching"`
   - ❌ Bad: `"how does Next.js work"`
2. Results return relevant documentation snippets with source links

### Common Query Patterns

| Framework    | Common queries                                                                            |
| ------------ | ----------------------------------------------------------------------------------------- |
| Next.js      | `"App Router metadata API"`, `"server actions form handling"`, `"middleware redirect"`    |
| React        | `"useOptimistic hook"`, `"server components vs client components"`, `"suspense boundary"` |
| Payload CMS  | `"collection hooks afterChange"`, `"access control functions"`, `"local API usage"`       |
| Tailwind CSS | `"arbitrary values"`, `"dark mode configuration"`, `"responsive breakpoints"`             |

## Recipe 2: Version-Specific Query

When the project uses a specific framework version:

1. Check `package.json` for the exact version.
2. Include version info in the query context
3. Cross-reference results with the project's locked tech stack.

## Gotchas

- **Both parameters are REQUIRED**: `resolve-library-id` and `query-docs` each require two parameters. Missing one causes an `invalid_type` error.
- **`libraryId` format**: Must be `/org/project` format, such as `/websites/nextjs`, not a package name.
- Context7 queries the **latest** documentation; if your project uses an older version, verify API compatibility.
- Use specific queries, not broad questions. Narrower queries produce better results.
- If `resolve-library-id` returns no results, try alternative names (e.g., `"next"` vs `"nextjs"`).
- Documentation results are snapshots; for critical decisions, verify against the actual source.
- Call at most three times per question. If no good result appears after three calls, use the best available result and record the API limit.

## Integration with Workflows

| Workflow | Use case |
| --- | --- |
| `/03_build` | Query framework API usage to implement correctly |
| `/04_fix` | Query API changes to confirm the repair path |
| `/07_debug` | Query known issues and solutions |
| `/08_audit` | Query best practices for code-quality assessment |
