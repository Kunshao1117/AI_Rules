---
name: 09_commit
description: 兩階段授權備份工作流。第一階段：掃描倉庫衛生、偵測記憶過期、產出 Commit Message 草稿，含條件分岔衛生閘門。第二階段：收到 GO 後提交並推送，同步更新 CHANGELOG.md。
required_skills: [github-ops]
memory_awareness: read
user-invocable: true
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["claude"]
  lifecycle_phase: commit
  role: sre
  memory_awareness: read
  tool_scope: ["filesystem:write", "git:write", "terminal:read"]
  human_gate: "GO required before changelog write, commit, or push"
  automation_safe: false
---


## Director-Readable Output Contract（總監可讀輸出契約）

All Director-facing conversations, implementation plans, reports, and completion summaries MUST start with this table before any technical details:

| 功能/目的 | 相關檔案 | 白話說明 | 寫入/風險 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section. File names may appear, but each file name MUST be paired with a plain-language purpose. Do not describe changes only with function names, variable names, metadata, schema fields, or CLI parameters.
# [SKILL: /commit — 授權備份]

---

## STAGE 1 — SCAN (紀錄掃描)

### 1. Repository Hygiene Check (倉庫衛生)

Run via `Bash` tool:
- `git status` — list all changed files
- `git diff` — parse uncommitted diffs

Scan for:
- Orphaned files (no memory card coverage)
- Debug artifacts (`console.log`, hardcoded test values, `TODO` comments)
- Untracked files that should be in `.gitignore`

### 2. Memory Staleness Check (記憶過期偵測)

- Cross-reference changed files against `.agents/memory/*/SKILL.md` cards.
- Flag any modified source file whose memory card was NOT updated this session.
- Output staleness report in Traditional Chinese.

### 2.5. Condition Gate (掃描結果分岔)

```
[CONDITION GATE — 掃描結果分岔]
├── Branch A：有記憶卡過期（staleness > 0）OR 有孤立檔案（無記憶卡覆蓋）
│   └── [HALT] 輸出：「⚠️ 發現 {N} 項衛生問題，請先處理後再輸入 GO 繼續」
│         列出具體問題清單（記憶卡名稱 / 孤立檔案路徑）
└── Branch B：全部乾淨
    └── 直接進入 §3，產出 Commit Message 草稿並輸出 GO 提示
```

### 3. Commit Message Draft (提交訊息草稿)

- Analyze diffs to determine change type and business impact.
- Draft a `CHANGELOG.md` entry in Traditional Chinese. DO NOT write it before GO.
- Draft Conventional Commit message in Traditional Chinese:
  ```
  feat(模組名稱): 商業行為描述

  - 變更項目 1（商業語言）
  - 變更項目 2（商業語言）

  Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
  ```
- Output commit draft, approved file list, CHANGELOG draft, and staleness report to Director.

### 4. Authorization Gate (授權閘門)

Output:「【防線鎖定】準備遠端備份。請確認上方 Commit Message 與變更紀錄。輸入 GO 核准備份，或留言要求修改。」
**HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (授權備份)

> Begins only after Director inputs GO.

### 5. CHANGELOG Update (CHANGELOG 更新)

- Only after GO, write the approved entry to repository root `CHANGELOG.md`（Keep a Changelog 格式）.
- 格式：`## [YYYY-MM-DD]` 下分 `### feat` / `### fix` / `### chore` 三類
- **強制商業語言**：禁止裸露識別符（函式名、變數名），必須用功能模組名稱描述行為
- 範例條目：
  ```markdown
  ## [2026-05-05]
  ### feat
  - 交接工作流強化 — 新增防雷萃取與環境異動記錄段落
  ### fix
  - 路徑修正 — 修復修復工作流與備份工作流中的記憶卡路徑錯誤
  ```

### 6. Commit & Push

> [LOAD SKILL] Read `.agents/skills/github-ops/SKILL.md`.

Run via `Bash` tool (sequential):
```bash
git add <approved file list including CHANGELOG.md>
git commit -m "<approved message>"
git push
```

[MCP HITL GATE] applies: `git push` is 🟡 MEDIUM risk. Output Justification Block before executing.

### 7. Completion

- Confirm push succeeded. Report branch name and commit hash.
- Output completion summary in Traditional Chinese.

---

## [SECURITY & COMPLIANCE]
- **Stage 1 Role**: Reader — no source file modifications.
- **Stage 2 Role**: Writer/SRE — CHANGELOG write + approved git operations only, no unrelated source file edits.
- **Memory**: read — check staleness only, no card writes in this workflow.
