# Workflow Memory Evidence Reference

This reference holds memory admission and MCP memory evidence details that are
too large for `Shared/workflow-capability-evidence-matrix.md`. It is evidence
guidance only; memory writes, memory commits, and project context writes require
their own protected authorization gates.

## Memory Admission Matrix

Source memory writes are allowed only when the workflow has a durable, source-backed fact or active constraint to preserve. Task evidence, screenshots, raw test output, temporary observations, and preference candidates stay in reports, logs, or project context.

| Workflow | Admissible source memory | Not source memory |
|---|---|---|
| 03 Build | Implemented and verified source facts, active constraints, tracked file ownership, stable validation route summaries | Draft plans, unimplemented assumptions, raw test output |
| 04 Fix | Confirmed root cause, still-valid repair constraint, regression route summary | Full debugging transcript, failed attempts without active consequence |
| 05 Condense | Source-supported project identity, tech stack, deployment, governance facts | Unapproved preferences, temporary observations |
| 06 Test | Long-lived validation entry points, invariants, test surface decisions | Single-run logs, screenshots, fixture-only evidence |
| 08 Audit | Evidence-confirmed long-lived governance facts, stable validation route summaries after follow-up work lands | Intermediate audit inventories, raw evidence delivery artifacts, one-time performance readings, unverified guesses |
| 09 Commit | Required memory attribution or final source-memory consistency notes | Changelog prose or commit message text |
| 10 Routine | Stable governance drift facts after a follow-up source or rule change lands | Read-only routine report, temporary warning list, one-time health snapshot |
| 11 Handoff | Pending memory actions and blockers as report items | Full next-agent prompt or temporary handoff narrative |
| 12 Skill Forge | Stable skill ownership, trigger semantics, generated skill source facts, and validation route summaries | Brainstorming notes, rejected skill drafts, raw lint/test output |

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded instead of presenting it as verified current truth.

## MCP Memory Evidence Matrix

The detailed tool contract lives in `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`. Workflows can use filesystem evidence when MCP is unavailable, but missing MCP evidence must be reported as `unverified` or `blocked` when it affects the decision.

`commit_preflight` is scoped to `09 Commit`, explicit commit-prep, or closeout
commit/push readiness. Other workflows use `workspace_brief`, memory
list/status/read/deps, memory audit/graph, and context read-only tools as
ordinary evidence. A commit-preflight dirty-file or memory blocker must route
to `09` or closeout; it must not interrupt non-commit implementation,
validation, review, audit, routine, or handoff work mid-task.

| Workflow | Entry locations | Minimum MCP memory evidence | Mutating MCP gate |
|---|---|---|---|
| 03 Build | Codex: `.agents/skills/03-build-建構/SKILL.md`; Claude: `.claude/commands/03_build(建構)/SKILL.md`; Antigravity: `.agents/workflows/03_build(建構計畫).md` | Relevant ownership and staleness from memory list/status/read; dependency evidence when indirect staleness is reported; context read evidence when acceptance preferences affect implementation | Memory commit only after source changes and active memory main-file content are updated |
| 04 Fix | Codex: `.agents/skills/04-fix-修復/SKILL.md`; Claude: `.claude/commands/04_fix(修復)/SKILL.md`; Antigravity: `.agents/workflows/04-1_fix_plan(修復計畫).md` | Ownership, status, dependency, and root-cause evidence for affected cards; unresolved memory conflicts are repair blockers | Memory commit cannot be used as a staleness reset shortcut; it follows verified card edits |
| 05 Condense | Codex: `.agents/skills/05-condense-濃縮/SKILL.md`; Claude: `.claude/commands/05_condense（濃縮）/SKILL.md`; Antigravity: `.agents/workflows/05_condense(濃縮).md` | Workspace brief, memory list/read, and context inventory/status evidence to separate source facts from preferences | `_system` source-memory write requires authorization resolution plus the matching memory protected gate; project context write preserves `GO CONTEXT` but still binds it to the visible context scope |
| 08 Audit | Codex: `.agents/skills/08-audit-健檢/SKILL.md` plus `08-1/08-2/08-3`; Claude: `.claude/commands/08_audit(健檢)/SKILL.md` plus subflows; Antigravity: `.agents/workflows/08_audit(健檢).md` plus subflows | Workspace brief, memory audit, memory graph/status, and context audit; commit-preflight findings are referenced only when the audit is explicitly checking commit readiness and routes to `09` | Audit does not mutate memory; follow-up build/fix/commit workflows perform authorized writes |
| 09 Commit | Codex: `.agents/skills/09-commit-紀錄總結/SKILL.md`; Claude: `.claude/commands/09_commit(紀錄)/SKILL.md`; Antigravity: `.agents/workflows/09-1_commit_scan(紀錄掃描).md` | `commit_preflight` or equivalent memory status evidence, dirty file list, stale/unattributed file evidence, compact packets, and blockers | Commit/push are separate gates; memory commit only happens before commit after card content is edited |
| 10 Routine | Codex: `.agents/skills/10-routine-巡檢/SKILL.md`; Claude: `.claude/commands/10_routine(巡檢)/SKILL.md`; Antigravity: `.agents/workflows/10_routine(巡檢).md` | Workspace brief, memory audit, context audit, sync integrity, and read-only tool availability evidence | No mutating MCP calls; any write proposal routes to build/fix/audit for authorization resolution and the matching protected gate |
| 11 Handoff | Codex: `.agents/skills/11-handoff-交接/SKILL.md`; Claude: `.claude/commands/11_handoff(交接)/SKILL.md`; Antigravity: `.agents/workflows/11_handoff(交接).md` | Workspace brief, memory list/status/read summary, stale cards, blockers, dirty files, and unresolved context evidence | Handoff does not mutate memory; pending writes are reported as next-step blockers |
| 12 Skill Forge | Codex: `.agents/skills/12-skill-forge-技能鍛造/SKILL.md`; Claude: `.claude/commands/12_skill_forge(技能鍛造)/SKILL.md`; Antigravity: `.agents/workflows/12_skill_forge(技能鍛造).md` | Skill ownership, memory status/read evidence for affected skill domains, context boundary evidence, and validation route evidence | New or modified skill source requires memory attribution and authorized memory commit before completion |
