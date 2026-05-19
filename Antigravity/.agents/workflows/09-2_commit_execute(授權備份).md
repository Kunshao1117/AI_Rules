---
description: "Use when: 已有 09-1 掃描與 GO，要執行 commit、push、tag 或 Release 同步。DO NOT use when: 只想查看狀態或尚未通過提交前掃描。"
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["gemini"]
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
# [WORKFLOW: COMMIT EXECUTE (授權備份)]

## 1. SNAPSHOT_AND_RECORD

[EXECUTE] Parse uncommitted diffs via `git diff`.
[EXECUTE] Draft a `CHANGELOG.md` entry in Traditional Chinese based on changes. DO NOT write it before GO.
[CONSTRAINT] DO NOT modify memory card staleness. The scan phase is structurally isolated.

## 2. PRE_COMMIT_BUFFER

[EXECUTE] Formulate a Conventional Commit message in Traditional Chinese based on the diffs.

## 3. AUTHORIZATION_GATE

[IF-THEN-HALT]
- 印出擬定的 Commit Message、明確檔案清單與 CHANGELOG 草稿。
- Print: "【防線鎖定】準備遠端備份。請輸入 GO 核准備份或要求修改註解。"
- HALT: SUSPEND GENERATION IMMEDIATELY. Require Director input exactly `GO` to proceed.

## 4. COMMIT_AND_PUSH

> [LOAD SKILL] 收到 GO 授權後，讀取推播技能：
> `view_file .agents/skills/github-ops/SKILL.md`

[EXECUTE ONLY UPON GO]
Run: write the approved CHANGELOG entry to `CHANGELOG.md`.
Run: `git add <approved file list including CHANGELOG.md>`
Run: `git commit -m "{Message}"`
Run: `git push`

## 4a. CHANGELOG Update（CHANGELOG 同步更新）

- 維護倉庫根目錄的 `CHANGELOG.md`（Keep a Changelog 格式）
- 格式：`## [YYYY-MM-DD]` 下分 `### feat` / `### fix` / `### chore` 三類
- **強制商業語言**：禁止裸露識別符（函式名、變數名），必須用功能模組名稱描述行為
- 只有收到 GO 後才可使用 `write_to_file` 或 `replace_file_content` 更新 CHANGELOG.md
- 禁止 blanket staging；只能 stage 授權清單內的明確檔案。

範例條目格式：
```markdown
## [2026-05-06]
### feat
- 雙版本同等化 — 補入 PRE-FLIGHT GATE 與技能蒸餾閘門
### fix
- 腳本掃描範圍 — 修復 Measure-SkillQuality 漏掃衍生技能目錄
```

## 5. COMPLETION_GATE

[EXECUTE] Inherits: `.agents/workflows/_completion_gate.md`

## [SECURITY & COMPLIANCE MANDATE]
> Inherits: `.agents/workflows/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` | CHANGELOG 寫入與授權清單 git 操作權限，不得修改其他來源檔案
