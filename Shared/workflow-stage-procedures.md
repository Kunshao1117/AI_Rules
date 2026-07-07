# 工作流階段程序（Workflow Stage Procedures）

本參考保存具體 workflow stage procedures；這些程序細節過長，不放在平台 workflow entries。
Workflow entries 保持精簡：負責 route the task、標示 evidence-matrix row、載入 shared policies，只有需要具體 phase checklist 時才指向這裡。

本文件不是 authorization。
它不取代 Team-Native Core、Authorization Resolution、workflow evidence matrix、platform adapters、team task boards、specialist role skills、delivery artifacts、memory gates、validation、review、commit、release、deployment、install 或 external mutation gates。

只使用符合 workflow route 的對應章節；不要把這些程序複製回 platform entries。

## 總監可見標籤橋接（Director-Visible Label Bridge）

| 中文顯示標籤 | Canonical label / field | 使用範圍 |
|---|---|---|
| 工作流路由 | workflow route | 00-12 section selection |
| 共同階段規則 | Common Phase Rules | 所有 workflow 的前置程序 |
| 任務類型 | Task type | workflow-capability evidence rows |
| 接地依據 | Grounding basis | local/source/external evidence basis |
| 最低證據 | Minimum evidence | evidence state and required artifact hints |
| 常見路由 | Common route | next workflow suggestions |
| 變更後檢查清單 | Post-change checklist | 03/04/12 source-impact handoff |
| 來源/部署副本對 | source/deployed pair | sync and parity evidence |
| 記憶/文件交付 | memory/docs handoff | attribution route, not memory mutation |

## 共同階段規則（Common Phase Rules）

1. Bind the Director request to a current plan, station, file set, command, or protected phase before any write.
2. Read `workflow-orchestration.md`, `language-governance.md`, the workflow evidence matrix row, and the platform capability matrix before broad evidence or source-impacting work.
3. Read `platform-plan-mapping.md` when a platform plan/checklist/progress surface, `plan-only`, or `build-plan` affects routing, authorization interpretation, progress reporting, or completion language.
4. When current official, public, or internal-source evidence can affect a workflow decision, route an `external-research` station before the affected station.
   Each consuming station must carry an `external_research_question` that names the question, source tier, freshness need, accepted evidence, and stop condition.
   Returned research is station input, not write authority.
5. Use `formal-readonly` for evidence, research, impact mapping, validation planning, review evidence, memory/docs attribution, and broad reads.
6. Use `formal-write` only after a scope-bound intent signal is resolved through authorization resolution to the visible plan, file set, station, phase, expiry, and required protected gate.
7. Keep implementation, validation, review, memory/docs, and completion as separate delivery states. Missing states are blocked, unverified, or closed-with-director-risk, not complete.
8. Post-change flow is artifact-chain only:
   - Implementation or authorized change-application returns a delivery handoff bundle with `validation_handoff`, `review_handoff`, and `memory_docs_handoff`.
   - The captain records it in the ledger without rewriting it.
   - The next wave starts validation and review only from that delivery bundle.
   - The memory/docs wave starts after validation and review reach terminal evidence states, using the delivery bundle plus the validation/review results.
   - The implementation bundle may include a `memory_impact` hint, but the memory/docs branch is read-only disposition and attribution routing; it does not authorize memory mutation, memory commit, or direct card writes.
   - Completion consumes only the resulting artifact chain.
9. Separate source-level delivery closeout from full completion:
   - When source delivery, validation, review, and sync are sufficient but memory/docs reports `memory-required` or `memory-blocked-by-scope` only because protected memory mutation was not authorized, report source-level delivery with protected follow-up pending.
   - Do not mark the source-level delivery itself as blocked or ask the Director for an internal phase label.
   - Full completion, commit, or release readiness remains blocked until the protected memory owner station and any required `memory_commit` phase finish.
10. When a source/deployed pair exists, record sync direction and parity evidence before any completion claim.
11. Use `commit_preflight` only in `09 Commit`, explicit commit-prep, or closeout commit/push readiness. Other workflows use normal read-only memory evidence and compact packets without interrupting non-commit work.
12. Read `source-document-size-governance.md` when source-bearing documents, scripts, modules, skills, policies, or rule packs are written, grown, reviewed, validated, or audited.

## 00 Chat / 聊天

- Answer directly only when the response depends on current conversation, Director-provided snippets, or stable general reasoning.
- If the request needs files, screenshots, memory/context cards, rules, workflow evidence, tool output, or later governance decisions, promote to a `formal-readonly` evidence station.
- Route research, architecture, build, fix, test, commit, release, or write work to the matching workflow instead of expanding chat scope.
- Direct chat never writes files, memory, git, release state, deployment, installs, credentials, or external state.

## 01 Explore / 探索

- Define the research question, decision to support, freshness needs, and source quality bar.
- Prefer official, primary, or current sources when the result can influence architecture, implementation, governance, release, or spend.
- Return findings with source dates, confidence, bias or coverage gaps, and route recommendations.
- Route buildable architecture decisions to `02`, experiments to `03-1`, and implementation-ready work to `03` only after evidence is sufficient.

## 02 Blueprint / 架構

- Replay requirements, non-goals, constraints, assumptions, and acceptance criteria.
- Run neutral challenge against current files, tool output, memory/context, and official sources when relevant.
- Record architecture decisions, rejected alternatives, compatibility impact, and migration or rollback path.
- Produce a build handoff contract only when implementation boundaries, validation expectations, memory/docs impact, and unresolved risks are clear.
- When the blueprint becomes a handoff to `03`, produce a dual-format contract: a human-readable flowchart or narrative for Director and reviewer context, and a machine-readable `execution_spec` for downstream routing.
- The `execution_spec` must name:
  - scope;
  - decision IDs;
  - exact file allowlist;
  - acceptance matrix;
  - validation route;
  - memory/docs impact;
  - external research inputs;
  - unresolved risks;
  - handoff target.
- A human flowchart or Mermaid diagram is explanatory only and never substitutes for `execution_spec`.
- Treat ordinary architecture output as `plan-only` unless it explicitly becomes a `build-plan` handoff boundary for workflow `03`; neither state is write authorization.

## 03-1 Experiment / 實驗

- Declare sandbox scope, discard condition, promotion condition, and allowed shortcuts before writing.
- Keep experiment writes out of production quality claims.
- Mark skipped lint, tests, review, validation, and memory/docs as experiment dispositions.
- Promote to `03` only with a new production plan and a scope-bound intent signal resolved through authorization resolution.

## 03 Build / 建構

- If the Director asks for sandbox or quick prototype work, route to `03-1` before production build handling.
- Produce a design-to-build contract before writes: requirement trace, review state when required, architecture boundary, change intent, real validation path, file sets, memory/docs impact, and drift audit rule.
- Treat that design-to-build contract as `build-plan`, not `plan-only`: it defines implementation boundaries and acceptance evidence but does not grant write authority, and Codex `update_plan` remains only a progress mirror.
- A production `build-plan` may start only from a machine-readable `execution_spec`, exact file allowlist, and acceptance matrix. Mermaid, screenshots, or human flowcharts may explain sequence, but they are not enough to open implementation change delivery.
- If the `execution_spec`, file allowlist, or acceptance matrix is missing, route back to `02` or the intent-alignment station before writing.
- Include source-document size/split impact in the build plan when the file set includes core, shared policy/reference, `SKILL.md`, memory card, PowerShell script/module, audit rule pack, or large general source files.
- After a scope-bound intent signal is resolved through authorization resolution, open implementation change delivery only for the named scope.
- Post-change checklist: record:
  - delivery artifact ID;
  - `source_input`;
  - changed files;
  - size/split impact;
  - `memory_impact`;
  - source/deployed pair and sync evidence when applicable;
  - validation, review, and memory/docs handoff targets.
- Route back to implementation only through a new scoped change-delivery or change-application station when a downstream station returns a concrete blocker; captain ledger entries are not fixes.
- Validation and review run after change delivery is returned, blocked, unverified, or risk-closed.
- Memory/docs runs after validation and review reach terminal evidence states, and completion consumes only the resulting artifact chain.
- If memory/docs returns `memory-required` or `memory-blocked-by-scope` after source delivery has passed validation, review, and sync:
  - Close the current source-level build as delivered with protected follow-up pending.
  - Route the memory-write and `memory_commit` work only when that protected phase is explicitly opened.
  - Do not turn the current build closeout into repeated authorization friction.

## 04 Fix / 修復

- Start with symptom, reproduction or observed failure, affected scope, and candidate root causes.
- Classify whether the work is emergency temporary fix, root-cause repair, local refinement, or structural refactor.
- Plan regression evidence before writes, including real-path validation when behavior depends on runtime state, external systems, persistence, UI, or operator-visible output.
- Classify size/split impact before writes when the fix touches a large source document, `Scripts/modules/*.psm1`, audit rule pack, or governance source.
- After a scope-bound intent signal is resolved through authorization resolution, open a repair `change-delivery` station only for the named cause and route failed validation back to diagnosis or a new fix station.
- Post-change checklist: attach:
  - repair delivery artifact ID;
  - symptom/cause `source_input`;
  - changed files;
  - size/split impact;
  - regression handoff;
  - review handoff;
  - memory/docs handoff;
  - source/deployed sync evidence when relevant.
- Route back from validation or review to diagnosis when cause evidence is incomplete; route back to a new fix station only when the blocker names a bounded repair surface. Do not let completion substitute for a missing repair artifact.
- Memory/docs runs only after the fix delivery has terminal validation and review evidence.
- If the fix itself is delivered, validated, reviewed, and synced, but memory mutation is outside the current scope:
  - Report protected follow-up pending for memory instead of blocking the fixed source state.
  - Commit or release readiness still waits for the protected memory path when required.

## 05 Condense / 濃縮

- Separate stable source-backed facts from temporary observations, preferences, task evidence, and rejected ideas.
- Read the relevant memory/context inventory before proposing durable facts.
- Keep main cards small and archive or split when compaction thresholds are reached.
- When a card reports `needsCompaction=true`, emits event 31, or lacks reliable counters, produce the normal compact packet and wait for the matching memory protected authorization before compacting, splitting, or archiving.
- Memory or context mutation requires the matching protected authorization.

## 06 Test / 測試

- Define the target surface, evidence level, environment, commands, browser or operator path, and expected pass/fail state.
- Use non-mutating validation by default.
- Distinguish unit, integration, regression, visual, performance, accessibility, real execution, blocked, and unverified evidence.
- Run a non-mutating size-governance check when a workflow asks for it or when touched files cross the source-document policy categories.
- Failed validation routes to fix, debug, build, or audit. The validation station does not repair the implementation it validates.

## 07 Debug / 除錯

- Gather logs, traces, stack frames, commands, inputs, recent changes, and environment signals without mutating source.
- State hypotheses and disconfirming evidence.
- Stop when root cause, missing evidence, or a broader audit need is clear.
- Route confirmed repair to `04`, missing implementation to `03`, and systemic uncertainty to `08`.

## 08 Audit / 健檢

- Run inventory before logic review, and logic review before final report.
- Define depth, project type, surface denominator, evidence sources, and known unavailable areas.
- Include oversized source documents, PowerShell modules, audit rule packs, and repeated core/skill stuffing in the audit denominator when size/split governance is in scope.
- Do not repair during audit. Findings route to build, fix, test, skill-forge, commit prep, or handoff.
- Report red/yellow/green only with evidence status and unresolved scope.

## 08-1 Infra Inventory / 基礎盤點

- Identify project type, runtime surfaces, commands, routes, files, workflows, memory/context cards, and external dependencies.
- Record source-document size/split signals when they are in scope; existing oversized modules may be baseline findings rather than blocking failures.
- Record denominator and skipped scope before any quality judgment.
- Return inventory evidence for `08-2` logic review.

## 08-2 Logic Review / 深度邏輯

- Review architecture, state/data flow, security, reliability, validation coverage, governance consistency, and evidence integrity using `08-1` inventory as input.
- Review whether size combines with multiple responsibilities, mixed public interfaces, or difficult test isolation before recommending a split.
- Do not issue final audit conclusions before inventory gaps are visible.
- Route repairable findings to the right workflow with evidence status.

## 08-3 Audit Report / 健檢總結

- Summarize inventory, logic findings, evidence status, blockers, unverified scope, recommended routes, and residual risk.
- Do not treat recommendations as write authorization.
- If commit or release readiness is requested, route to `09`.

## 09 Commit / 紀錄

- Scan dirty files, staged files, source/deployed parity, memory status, validation state, review state, and unresolved blockers.
- Run `commit_preflight` or equivalent source-memory consistency evidence only in this route or an explicit commit-prep/closeout station.
- Commit, push, tag, release, deployment, and memory commit are separate protected phases with separate authorization.
- If preflight finds stale memory, missing validation, missing review, missing sync, compact-packet blockers, or untracked required files, route back to the owner workflow.
- Source-level protected follow-up pending becomes a blocker in this route when it affects commit readiness. Do not hide it inside the commit summary.
- Commit message subject, commit body, and commit summary must use Traditional Chinese meaning-first text as the main body; technical tokens, canonical states, file paths, and commit conventions may appear only as supporting evidence or precision.
- Commit message wording rules do not authorize commit, push, tag, release, deployment, memory commit, or any other protected mutation.
- Do not hide blockers inside a commit summary.

## 10 Routine / 巡檢

- Stay read-only and automation-safe.
- Check drift, skill quality, workflow metadata, source/deployed consistency, memory health, MCP profile surfaces, and documented counts.
- Report exact findings and proposed routes. Do not apply fixes.
- Any write proposal routes to build, fix, audit, skill-forge, or commit prep and waits for a scope-bound intent signal resolved through authorization resolution.

## 11 Handoff / 交接

- Summarize current goal, changed or dirty files, evidence collected, blockers, unverified areas, memory/context state, validation/review state, and next route.
- Distinguish user-provided evidence from evidence verified in the current turn.
- Handoff does not mutate memory unless a separate memory workflow and authorization exists.

## 12 Skill Forge / 技能鍛造

- Decide whether the content belongs in core, shared policy, workflow entry, operational skill, reference file, memory, or project context.
- Keep trigger language in frontmatter description; put long examples, templates, and procedures in references.
- Validate naming, description specificity, boundary language, required metadata, and source/deployed sync.
- Post-change checklist: return:
  - skill delivery artifact ID;
  - source/deployed pair;
  - sync direction;
  - parity evidence;
  - memory/docs handoff;
  - validation handoff;
  - independent review handoff.
- Route back to skill forge through a new scoped station when metadata, boundary language, source/deployed parity, or reference placement fails downstream review. Skill source changes require memory/docs impact assessment before completion.
- If skill source delivery is validated and reviewed but memory mutation is a protected follow-up:
  - Report the skill source layer as delivered with protected follow-up pending.
  - Full completion, commit, and release readiness still wait for the protected memory path when required.
