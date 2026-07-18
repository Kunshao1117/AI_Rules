---
name: trunk-ops
description: >
  測試品質與 CI 不穩定測試治理：Trunk CI 測試品質操作食譜：測試框架偵測、不穩定測試修復、CI 上傳設定。
  Use when: 現有驗收與精確授權已指名 Trunk CI/test operation、flaky-test repair 或 test-upload setting。
  DO NOT use when: 沒有明確的 test/CI scope、非 CI test-quality work，或一般 local test execution。
  MCP Server: trunk (native, non-Gateway)
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [trunk]
  tool_scope: ["mcp:trunk"]
---

# Trunk Ops — CI Test Quality Recipes

## Test Scope Opt-In

Use this skill only after the current acceptance and exact authorization bind the relevant test or CI
operation. It does not make framework detection, test execution, upload, or flaky-test work a default
follow-up to validation, review, quality practice, regression reasoning, or a workflow route. Test
authorization is owned by `Shared/policies/authorization-resolution.md`; invoke this skill only after
that canonical tool-first gate approves a minimal test exception.

> [!EXECUTION BOUNDARY]
> **主腦專屬 (Direct Execution Only)**
> 此技能與 `mcp_trunk_*` 工具僅限主腦 (Master Agent/IDE) 於本機直連執行，嚴禁委派給 CLI 或其他終端子代理人。

## HITL Boundary

- Read-only framework detection and flaky-test recommendations may proceed only inside the accepted test/CI scope.
- Installing upload tooling is a protected phase.
- Modifying CI configuration is a protected phase.
- Applying generated fixes is a protected phase.
- Changing remote Trunk settings is a protected phase.
- Uploading test data is a protected phase.
- A `GO` phrase is only a scope-bound Director intent signal.
- Before mutation or upload, authorization resolution must bind the visible plan and station.
- It must also bind the file set, exact command/tool call, phase, expiry, and required protected gate.
- `[MCP HITL GATE]` records justification and human-in-the-loop evidence.
- It does not replace authorization resolution.
- Install, CI-write, source-fix, remote-setting mutation, and upload are separate protected phases.
- Discovery of Trunk tool schemas is not permission to execute mutating tools.

## Recipe 1: Authorized Test Framework Detection（已授權測試框架偵測）

1. `detect-frameworks` — Scan codebase to identify test frameworks
2. Review returned instructions and execute the codebase analysis
3. Output: list of detected frameworks（如 jest, vitest, playwright, pytest 等）

> Use this only when the accepted upload scope requires framework identification.

## Recipe 2: Setup Trunk Uploads（CI 測試上傳設定）

```
Have test framework name ready?
├── Yes → Proceed to step 1
└── No → Run Recipe 1 (detect-frameworks) first
```

1. `setup-trunk-uploads` — Configure test result uploads to Trunk
   - `testFramework`: required — one of: jest, vitest, playwright, pytest, mocha, cypress, etc.
   - `ciProvider`: optional — one of: github, gitlab, circleci, buildkite, jenkins, etc.
   - `orgSlug`: optional — Trunk organization slug（非 GitHub org slug）
2. Treat returned instructions as plan material until each protected phase is separately authorized.
3. Follow returned instructions only within the resolved scope.
4. Resolved scope may include:
   - Install trunk analytics CLI
   - Add upload step to CI pipeline
   - Verify first upload

## Recipe 3: Fix Flaky Test（不穩定測試修復）

```
Director provides fix ID?
├── [SUDO] → Record override/risk-closure request; do not skip validation or execute directly.
├── Yes → Proceed to step 2 for recommendation retrieval only; fix ID is not source-write authority
└── No → Ask Director for fix ID（必須由總監提供）
```

1. Get repo name: run `git remote -v` → extract `owner/repo` format
2. `fix-flaky-test` — Get AI-generated fix recommendations
   - `repoName`: required — format `owner/repo`
   - `fixId`: required — provided by Director or from Trunk dashboard
   - `orgSlug`: optional — Trunk org slug
3. Review returned fix recommendations
4. Apply fixes via `/04_fix` workflow
5. Run only the exact test command named by the accepted test scope to record stability evidence
6. Iterate until test passes reliably

## Gotchas (踩坑點)

- Trunk is a **native MCP** (non-Gateway).
- Call tools directly via the `mcp_trunk_*` prefix.
- Do not use `gateway__call_tool`（直接呼叫，不經過 Gateway）
- `orgSlug` is the **Trunk organization slug**, NOT the GitHub organization slug（兩者不同）
- `fix-flaky-test` requires the repo to have **existing test uploads** configured on Trunk.io first（需先設定上傳）
- `setup-trunk-uploads` only sets up **one framework at a time**.
- Call it multiple times for multi-framework projects（一次只設定一個框架）
- `detect-frameworks` returns **instructions to follow**, not direct results — execute the returned steps（回傳的是指示，需執行）

## Interpretation (結果解讀)

- `detect-frameworks` → Returns analysis instructions; execute them to get framework list
- `setup-trunk-uploads` → Returns CI configuration steps; follow to complete setup
- `fix-flaky-test` → Returns specific code fix recommendations with file locations and explanations
