---
name: "09-commit-紀錄總結"
description: "Use when: 提交、commit、push、版本紀錄、CHANGELOG、Release tag 前置掃描與受治理備份。DO NOT use when: 尚未完成實作或只想查看 git 狀態。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: commit
  role: sre
  memory_awareness: read
  tool_scope: ["filesystem:write", "git:write", "terminal:read"]
  human_gate: "GO required before changelog write, commit, or push"
  automation_safe: false
---


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（Codex/.codex、Shared/skills）`.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

> [LOAD SKILL] If staged or dirty files touch plugin / extension / VSIX / GitHub Release / package version / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before drafting commit and release steps.
# source-command-09-commit-skill

Use this skill when the user asks to run the migrated source command `09_commit(紀錄)-SKILL`.

## Command Template

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

  Co-Authored-By: Codex Sonnet 4.6 <noreply@anthropic.com>
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
