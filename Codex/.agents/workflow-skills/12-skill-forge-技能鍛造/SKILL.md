---
name: 12-skill-forge-技能鍛造
description: "Use when: 技能鍛造、建立新技能、建立 Shared skill、建立 project skill、建立 Codex skill、從健檢/除錯/總監指令萃取可重用方法論、plugin/extension/插件/延伸模組、VSIX、Release/發布、version/版本、tag、update reminder/更新提醒 相關技能設計。DO NOT use when: 只是討論技能想法、不準備寫入，或只要修改既有技能描述。"
required_skills: [programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
metadata:
  author: antigravity
  version: "2.0"
  origin: framework
  kind: workflow
  platforms: ["codex"]
  lifecycle_phase: skill-forge
  role: writer
  memory_awareness: full
  tool_scope: ["filesystem:write", "mcp:cartridge-system"]
  human_gate: "GO required before writes"
  automation_safe: false
  required_skills: ["skill-factory", "memory-ops", "project-context-protocol", programming-team-governance]
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

> [LOAD SKILL] If the new or revised skill covers plugin / extension / VSIX / GitHub Release / version bump / tag / update reminder, read `.agents/skills/plugin-release-governance/SKILL.md` before defining trigger language.
> [LOAD SKILL] If the new or revised skill promotes stable project context, design DNA, product preference, technical preference, or acceptance preference into repeatable procedure, read `.agents/skills/project-context-protocol/SKILL.md` before defining scope.

## 工作流外部接地與證據矩陣（Workflow Grounding Contract）

- Before broad reading, station work, validation, review, memory/docs, completion, or any write path, read .agents/shared/policies/workflow-orchestration.md and use it as the shared route -> authorization -> operation_mode -> board -> wave -> artifact -> completion order.
- Before applying workflow-specific language, output-layer, memory-language, handoff, or change-description rules, read .agents/shared/policies/language-governance.md; this workflow cites the center policy and does not use platform core files as the sole language source.
- Before applying this workflow, read .agents/shared/workflow-capability-evidence-matrix.md and use the 12 row as the minimum external grounding and evidence contract.
- Workflow-specific grounding: Apply the Agent Skills format, description-trigger quality, progressive disclosure, layer selection, reference splitting, and validation gates before writing skills.
- Evidence status must be reported as 足夠證據, 部分證據, 未驗證, 阻塞, or 不適用 when the result depends on sources, tools, runtime behavior, platform capability, or external state.
- Apply the platform adapter in .agents/shared/platform-capability-matrix.md; do not copy another platform's subagent, hook, checkpoint, browser, or sandbox semantics as executable instructions.
- Team-First routing applies before tool selection: use `formal-readonly` for skill-source analysis, pattern extraction, source/doc evidence, deep-read, review, validation, memory/docs, and counter-evidence stations; use GO-backed `formal-write` only for authorized skill/source writes. Workflow name is route only; it does not authorize writes or unbounded specialist launch.
- Any deferred station MUST be recorded as `standby` with trigger, scope, startup condition, and `standby_reason`; it MUST NOT produce evidence until its dispatch wave is open and a delivery artifact returns.
- Large-file or broad-corpus work uses specialist deep-read delivery with cited sections; the captain performs verify-read on the cited sections before relying on the summary and must not claim full-file ingestion from a summary alone.
> [LOAD SKILL] For coding, workflow, validation, review, memory, commit, release, or governance-impact work, read `.agents/skills/programming-team-governance/SKILL.md`, `.agents/skills/team-task-board/SKILL.md`, `.agents/skills/team-station-handoff-packet/SKILL.md`, `.agents/skills/team-role-boundaries/SKILL.md`, `.agents/skills/team-change-delivery-artifact/SKILL.md`, `.agents/skills/team-memory-docs-delivery-artifact/SKILL.md`, `.agents/skills/team-validation-delivery-artifact/SKILL.md`, `.agents/skills/team-review-delivery-artifact/SKILL.md`, `.agents/skills/team-completion-gate/SKILL.md`. Treat this workflow as a route hint, then build the Captain Team Board before specialist, browser, CLI, MCP, isolated change delivery, text change delivery, validation, review, or completion work. The board records board state, task type, workflow route, implementation authorization, allowed/forbidden specialist roles, phase, dispatch wave, previous-wave input, next-wave start condition, formal evidence eligibility, Team Station applicability, execution mode, specialist role source, assigned skill refs, handoff packet ID, domain label, execution channel, delivery artifact, evidence owner, role boundary, direct exception, deep-read scope, captain verify-read scope, unread scope, startup deadline, standby reason, and completion condition. Draft boards cannot spawn specialists or satisfy formal acceptance; formal-readonly boards can run no-write evidence, deep-read, research, validation-planning, review-evidence, and standby stations; formal-write boards require scoped GO-backed authorization; formal boards dispatch wave-by-wave with no post-board all-at-once launch. Enforce no self-review, isolated/text change delivery artifacts, specialist role source, execution channel, delivery artifact, no_captain_authoring, and all-direct fake-team guard; the captain only coordinates, dispatches, supervises, integrates returned delivery artifacts into the main worktree, owns protected memory/git/release operations, records review state from returned review artifacts, and reports to the Director; the captain must not author primary implementation, review, validation, or memory attribution.

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

# source-command-12-skill-forge-skill

Use this skill when the user asks to run the migrated source command `12_skill_forge(技能鍛造)-SKILL`.

## Command Template

# [SKILL: /12_skill_forge — 技能鍛造]

## 0. Source Gate (觸發來源判斷)

```
[SOURCE GATE] Identify skill source:
├── 觸發自 /08_audit 建議？→ 從審查報告中萃取重複模式
├── 觸發自 /07_debug 方法論？→ 將除錯步驟萃取為可重用技能
├── 觸發自已核准專案脈絡？→ 只在其描述穩定且可重複執行程序時升級為專案技能
└── 觸發自總監明確指令？→ 依總監規格設計
```

## 0.5. Backfill Gate（補植既有模式掃描）

> 每次鍛造新技能前，先執行此閘門：

```
[BACKFILL GATE]
├── 掃描現有工作流（.agents/skills/*/SKILL.md）中是否存在重複的操作步驟
├── 若發現可萃取為技能的模式（出現 2+ 次的操作序列）：
│   └── 列出候選模式，提示總監：「發現可萃取模式 {N} 個，是否一併建立技能？」
│       ├── YES → 將候選模式加入本次鍛造清單
│       └── NO  → 繼續僅建立當前指定技能
└── 無候選模式 → 繼續執行 §1
```

## 1. Pattern Extraction (模式萃取)

- 從來源中提取核心操作序列。
- 識別決策點、前置條件、邊界情況。
- 定義明確的輸入與輸出格式。

## 2. Skill Design (技能設計)

Draft new skill only after selecting the target layer:

```
[LAYER GATE]
├── Cross-project framework behavior AND current workspace is the AI_Rules framework source repository? → Shared framework skill
│   └── Source path: Shared/skills/<skill-name>/SKILL.md
├── Cross-project framework behavior in a downstream project without framework source root? → stop and ask Director to run skill forge from AI_Rules source or explicitly approve project-derived scope
├── Single project repeatable behavior? → Project-derived skill
│   └── Source path: .agents/project_skills/<project-code>-<skill-name>/SKILL.md
├── Personal/global Codex behavior? → User Codex skill
│   └── Source path: user's Codex skills directory
└── Lifecycle entry or command routing? → Workflow/command entry
```

Skill structure:
1. **Frontmatter**: Codex-compatible `name`, `description`, and `metadata`
2. **Core Logic**: Step-by-step procedure with decision gates
3. **Constraints**: Scope boundaries, forbidden actions
4. **Security & Compliance**: Role, memory interaction level

### Frontmatter Template
```yaml
---
name: <skill-name>
description: >
required_skills: [programming-team-governance, team-specialist-registry, team-task-board, team-station-handoff-packet, team-role-boundaries, team-change-delivery-artifact, team-memory-docs-delivery-artifact, team-validation-delivery-artifact, team-review-delivery-artifact, team-completion-gate]
  Use when: <English and Traditional Chinese trigger phrases>.
  DO NOT use when: <negative boundary>.
metadata:
  author: antigravity
  version: "1.0"
  origin: framework|project
  kind: operational
  style: imperative|guided|hybrid
  memory_awareness: none|read|full
  tool_scope: []
  required_skills: [programming-team-governance]
  user_invocable: false
---
```

Do not add AI_Rules-only fields at the YAML top level. Codex-compatible top-level fields are `name`, `description`, `license`, `allowed-tools`, and `metadata`.

## 3. FORGE VALIDATION GATE（技能格式驗證閘門）

```
[FORGE VALIDATION GATE — 寫入前必須通過]
├── 新技能是否已透過 notify_user / Artifact 送審總監？
│   └── NO → [HALT]「🔴 [FORGE HALT] 技能未送審，不得寫入磁碟。」
├── YAML frontmatter 是否符合規範（含 name、description、metadata）？
│   └── NO → 自動修正（最多重試 2 次）
│   └── 2 次後仍不符 → [HALT]「🔴 [FORGE HALT] YAML 格式驗證失敗。」
├── Codex 內建技能驗證器是否通過？
│   └── NO → 修正 name、description、top-level YAML 欄位後重試
├── 技能名稱是否與目標層既有技能衝突？
│   └── YES → 提示總監選擇：覆蓋或重新命名
└── 存放路徑是否符合 LAYER GATE 判定？
    └── NO → 自動修正路徑後繼續
```

## 4. Change Delivery And Archive Integration (變更交付與歸檔整合)

- All writes below require returned change delivery, memory/docs delivery, review, and validation delivery artifacts; the captain integrates returned delivery artifacts only and reports blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`) when any required delivery artifact is missing.
- Shared framework skill：only inside the AI_Rules framework source repository, write `Shared/skills/<name>/SKILL.md`, update `Shared/skills/_index.md`, and sync through the manager.
- Project-derived skill：寫入 `.agents/project_skills/<name>/SKILL.md`，更新 `.agents/project_skills/_index.md`，並建立 `.agents/skills/project-<name>` discovery link。
- User Codex skill：寫入使用者 Codex 技能目錄；除非總監明確要求，不更新 AI_Rules 專案索引。
- Workflow/command entry：寫入對應平台 workflow/command 來源，並更新平台文件。
- Report to Director:
  > `[技能鍛造交付件已整合] 新技能 <name> 已建立於核准的技能層；若缺少審查、驗證或記憶文件交付件，僅能標示為阻塞、未驗證或總監風險關閉但非完整（`closed-with-director-risk`）。`

---

## [SECURITY & COMPLIANCE MANDATE]

> Inherits: `.agents/skills/_shared/_security_footer.md` (Role Lock Gate)

- **Role**: `Writer/SRE` — 僅允許寫入 LAYER GATE 核准的技能來源目錄與對應索引。
- **Memory**: full — 受影響的技能索引與記憶卡更新必須來自記憶文件交付件；隊長不得自行產生記憶歸因。
- Formal team completion requires implementation change delivery, memory/docs delivery, review, and validation delivery artifacts with Team-Native trace; missing delivery artifacts must be marked blocked, unverified, or Director risk-closed but not complete (`closed-with-director-risk`).
