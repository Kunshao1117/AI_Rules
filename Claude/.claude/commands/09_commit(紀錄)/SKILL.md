---
name: 09_commit
description: 兩階段授權備份工作流。第一階段：掃描倉庫衛生、偵測記憶過期、產出 Commit Message 草稿。第二階段：收到 GO 後提交並推送。
required_skills: [github-ops]
memory_awareness: read
user-invocable: true
---

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

- Cross-reference changed files against `.claude/agents/memory/*/SKILL.md` cards.
- Flag any modified source file whose memory card was NOT updated this session.
- Output staleness report in Traditional Chinese.

### 3. Commit Message Draft (提交訊息草稿)

- Analyze diffs to determine change type and business impact.
- Draft Conventional Commit message in Traditional Chinese:
  ```
  feat(模組名稱): 商業行為描述
  
  - 變更項目 1（商業語言）
  - 變更項目 2（商業語言）
  
  Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
  ```
- Output draft + staleness report to Director.

### 4. Authorization Gate (授權閘門)

Output:「【防線鎖定】準備遠端備份。請確認上方 Commit Message 與變更紀錄。輸入 GO 核准備份，或留言要求修改。」
**HALT. Wait for GO.**

---

## STAGE 2 — EXECUTE (授權備份)

> Begins only after Director inputs GO.

### 5. Commit & Push

> [LOAD SKILL] Read `.claude/agents/skills/github-ops/SKILL.md`.

Run via `Bash` tool (sequential):
```bash
git add <specific files — NOT git add -A>
git commit -m "<approved message>"
git push
```

[MCP HITL GATE] applies: `git push` is 🟡 MEDIUM risk. Output Justification Block before executing.

### 6. Completion

- Confirm push succeeded. Report branch name and commit hash.
- Output completion summary in Traditional Chinese.

---

## [SECURITY & COMPLIANCE]
- **Stage 1 Role**: Reader — no source file modifications.
- **Stage 2 Role**: Writer/SRE — git operations only, no source file edits.
- **Memory**: read — check staleness only, no card writes in this workflow.
