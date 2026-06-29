---
name: 09_commit
description: "Use when: 提交、commit、push、版本紀錄、CHANGELOG、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 前置掃描與受治理備份。DO NOT use when: 尚未完成實作或只想查看 git 狀態。"
required_skills: [github-ops, quality-review-governance, programming-team-governance, team-specialist-registry, team-task-board, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
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


## 總監可讀輸出契約（Director-Readable Output Contract）

Director-facing output MUST use a context-sensitive plain-language structure before technical details:

- Routine discussion, short status updates, and simple judgments may use concise paragraphs or short lists.
- Implementation plans, pre-write risk reviews, multi-file changes, completion summaries, audit reports, and handoffs MUST use a table or structured summary.
- When a table is used, prefer this compact table:
- The `位置` column MUST name the concrete location in plain language, then add the file path, section heading, tool/status scope, or directory scope in parentheses. If the item is not a single file, say so explicitly, e.g. `工作區狀態（git status）`, `管理器巡檢工具（框架來源倉庫限定：Scripts/AI-RulesManager.ps1）`, or `規則與技能範圍（部署後：.codex、.agents/skills；框架來源倉庫限定：Codex/.codex、Shared/skills）`.
- Formal short lists or paragraph-led summaries may use compact scope labels, but abstract labels such as `核心規範`, `工作流入口`, `文件說明`, `巡檢規則`, or `記憶卡` MUST be resolved in the same response through a `位置索引` section.
- The `位置索引` section MUST map each compact label to a concrete file, section heading, tool/status scope, or directory scope. Do not leave compact labels as unexplained categories.

| 事項 | 位置 | 影響 | 狀態 |
|---|---|---|---|

Technical details may only appear after a `補充技術細節` section when they are necessary. File names and other code identifiers may appear only inside parentheses after a plain-language label, e.g. `建構流程規則（03-build-建構/SKILL.md）`. Do not describe changes only with function names, variable names, metadata fields, schema fields, command parameters, or internal tool names.

技術詞彙翻譯閘門（Technical Vocabulary Translation Gate）:
- Director-facing text MUST NOT contain bare code identifiers. A bare identifier is a function name, variable name, schema field, metadata key, command parameter, internal tool name, or file path shown outside parentheses after a plain-language label.
- Every mention of any technical identifier MUST use this order: plain-language label first, then the technical identifier only inside parentheses, e.g. `建構流程規則（03-build-建構/SKILL.md）`.
- Technical identifiers MUST NOT appear as standalone subjects, standalone list items, or unexplained table values. If the exact identifier is not needed for location, omit it.
- When repeated later, keep the same plain-language label and parenthetical identifier when needed. Do not switch back to the bare code name.

中立誠實協作與知識新鮮度契約（Neutral Honest Collaboration and Freshness Gate）:
- Maintain a neutral, honest stance: do not optimize for pleasing, flattering, appeasing, or automatically agreeing with the Director. Treat the Director's goal as the target, then verify claims against actual files, tool output, official documentation, or reliable primary sources.
- Support proposals when evidence and feasibility align. If evidence conflicts with the proposal, respond with: `我看到的事實` / `可能問題` / `建議做法`.
- Do not object merely to appear critical. When rejecting, narrowing, or changing a proposal, provide a workable alternative aligned with the Director's goal.
- Treat memory and internal model knowledge as possibly stale. Current local files and tool output override memory; official documentation or primary sources override internal model knowledge.
- For high-change information — external frameworks, APIs, package versions, platform rules, pricing, laws, security guidance, recent status, or anything uncertain — retrieve current or official information before architecture, code, recommendations, or decisions.
- Anchor verification with the project version first. If no version is available, use the current date/year as the time anchor. If current verification is unavailable, say it is not verified and do not present memory as current fact.

> [LOAD SKILL] If staged or dirty files touch plugin / extension / VSIX / GitHub Release / package version / tag / update reminder, read `.claude/skills/plugin-release-governance/SKILL.md` before drafting commit and release steps.
> [LOAD SKILL] If staged or dirty files include governance, public contract, release/plugin behavior, security, cross-module, repeated fragile-code, or Director risk-closed but not complete (`closed-with-director-risk`) changes, read `.claude/skills/quality-review-governance/SKILL.md` before declaring commit readiness.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 09 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Require explicit file lists, review state and Director risk-closed but not complete (`closed-with-director-risk`), unverified, and blocker awareness, memory hygiene, status-check awareness, changelog quality, version impact, and governed release routing before commit or push.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.claude/skills/programming-team-governance/SKILL.md`, `.claude/skills/team-task-board/SKILL.md`, `.claude/skills/team-role-boundaries/SKILL.md`, `.claude/skills/team-change-delivery-artifact/SKILL.md`, `.claude/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.claude/skills/team-validation-delivery-artifact/SKILL.md`, `.claude/skills/team-review-delivery-artifact/SKILL.md`, `.claude/skills/team-completion-gate/SKILL.md`. Treat this command as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

## Team-Native workflow mode / role / board / specialist lifecycle

- `operation_mode` must be selected before board template, board state, closeout lane, or station set. `daily` is allowed only for bounded routine evidence, low-risk documentation alignment, generated-copy checks, or automation-safe inspection with no source, workflow, public-contract, or protected-state change. `full` is required for implementation, repair, bottom-layer refactor, cross-file governance, specialist skill rewrites, Doctor/Audit changes, commit/release/deploy preparation, protected external-state readiness, or any source/workflow/public-contract impact.
- Direct / formal-readonly / formal-write boundary:
  - `direct` is allowed only for the workflow's explicitly permitted pure conversation, tiny factual, tool-only, protected captain gate, or direct-answer step; pure conversation and direct answers must not mutate files, memory, git, release, deploy, install, credentials, or external state.
  - `formal-readonly` is required before broad reading, research, impact mapping, validation planning, review evidence, memory/docs attribution, or any no-write work that can shape source, workflow, validation, review, memory, release, or governance decisions.
  - `formal-write` requires scoped GO-backed authorization and is limited to the named station, phase, file set, command, or tool call. Reader-only workflows must route write needs to the matching build, fix, skill-forge, or commit workflow instead of self-authorizing writes.
- Role split and board trigger: before specialist, browser, CLI, MCP, isolated change delivery, text change delivery artifact, validation, review, memory/docs, or completion work starts, create or promote the Captain Team Board from `programming-team-governance` and `team-task-board`. Select roles from `team-specialist-registry`; every station records `role_id`, `role_instance_id`, `exclusive_task_scope`, assigned specialist skill, evidence owner, role boundary, direct exception, and completion condition. Every formal station receives a `team-station-handoff-packet` with Allowed inputs, Allowed tools, Forbidden actions, Output artifact format, Stop condition, loaded skill refs, read scope, startup monitoring, and blocker state.
- Change and evidence delivery: implementation work uses an implementation change delivery artifact from `team-change-delivery-artifact`; memory impact and memory/docs attribution use a memory/docs delivery artifact from `team-memory-docs-delivery-artifact`; validation uses a validation delivery artifact from `team-validation-delivery-artifact`; review uses a review delivery artifact from `team-review-delivery-artifact`; completion uses `team-completion-gate`. Review and validation wait for a returned, blocked, unverified, or `closed-with-director-risk` change delivery artifact. Missing implementation, memory/docs, review, or validation delivery artifacts are blocked or unverified evidence, not completion.
- Specialist lifecycle: every formal station records station lifecycle state: `assigned`, `standby`, `retained`, `reused`, `handoff-required`, `replaced`, `closed`, or `blocked`. Retain or reuse only when the same station, `role_id`, `role_instance_id`, delivery artifact, dispatch wave, and role boundary continue. Cross implementation/review, validation/repair, memory attribution/protected memory mutation, completion/final acceptance, or any different `role_id` by closing or replacing the prior station. Record retention reason, conversation health, reuse count, handoff summary, closure reason, `startup_started_at`, `first_response_deadline`, `last_progress_at`, `timeout_action`, and `standby_reason`. `standby` is a waiting state, not returned evidence; `closed-with-director-risk` is a non-complete closure state, not full team completion.

- MCP memory evidence must follow .agents/skills/memory-ops/references/memory-mcp-tool-contract.md and the MCP Memory Evidence Matrix in .agents/shared/workflow-capability-evidence-matrix.md; use read-only cartridge-system tools for status/evidence, use project-local tools for main-file migration, and mark missing MCP evidence as 未驗證 or 阻塞.

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
- Review-state blockers, Director risk-closed but not complete (`closed-with-director-risk`) items, or unverified high-risk validation from the build/fix/audit completion report

### 2. Memory Staleness Check (記憶過期偵測)

- Cross-reference changed files against active memory card main files.
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

GO for this workflow authorizes the captain to run protected completion work. It does not authorize any specialist to write memory cards, stage files, commit, push, tag, publish releases, or mutate external state. Specialists may provide memory/docs delivery, review, validation, changelog-quality, release-readiness, or completion evidence delivery artifacts only; implementation change delivery provenance must already exist or be marked not-applicable for commit-only work.

### 5. Review And Completion Evidence Delivery Artifacts（審查與收尾證據交付件）

- Before protected writes or git operations, confirm the formal Programming Team Board has commit-release task type, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, and captain-only protected git/release ownership and memory writes only from returned memory/docs delivery artifacts.
- Collect required implementation change delivery provenance, memory/docs delivery, review, validation, and completion evidence delivery artifacts for changed-file list, review-state blockers, Director risk-closed but not complete (`closed-with-director-risk`) items, memory hygiene, changelog quality, status-check awareness, version impact, and governed release routing.
- Evidence delivery artifact owners must not be the implementation specialists whose changes are being prepared for commit.

### 6. CHANGELOG Update (CHANGELOG 更新)

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

### 7. Commit & Push

> [LOAD SKILL] Read `.agents/skills/github-ops/SKILL.md`.

Captain-only protected operations via `Bash` tool (sequential):
```bash
git add <approved file list including CHANGELOG.md>
git commit -m "<approved message>"
git push
```

[MCP HITL GATE] applies: `git push` is 🟡 MEDIUM risk. Output Justification Block before executing.
No specialist, subagent, browser branch, CLI evidence branch, or isolated change delivery branch may run these operations.

### 8. Completion

- Confirm push succeeded. Report branch name and commit hash.
- Output completion summary in Traditional Chinese.

---

## [SECURITY & COMPLIANCE]
- **Stage 1 Role**: Reader — no source file modifications.
- **Stage 2 Role**: Captain/SRE — CHANGELOG write plus approved git operations are captain-only; specialists provide evidence delivery artifacts only.
- **Memory**: read — check staleness only, no card writes in this workflow.
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
