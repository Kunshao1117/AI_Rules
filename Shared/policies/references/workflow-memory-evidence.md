# Workflow Memory Evidence Reference

This reference holds memory admission and MCP memory evidence details.

Those details are too large for `Shared/workflow-capability-evidence-matrix.md`.

It is evidence guidance only.

Memory writes, memory commits, and project context writes require their own protected authorization gates.

## Disposition Before Mutation

Every source-changing workflow must produce or receive read-only memory/docs disposition evidence.

This evidence is required before opening any memory mutation path.

It is read-only disposition and routing evidence; it does not authorize memory mutation.

The canonical disposition states are:

### `memory-not-required`

- Meaning:
  - No durable source behavior, workflow rule, public contract, governance, or operational instruction changed.
- Next route:
  - No memory mutation path.

### `memory-attributed-no-write`

- Meaning:
  - Existing memory attribution already covers the change.
  - Read-only evidence may also be sufficient without editing a card.
- Next route:
  - No memory mutation path; preserve evidence in the delivery ledger.

### `memory-required`

- Meaning:
  - A durable source-memory update is required.
- Next route:
  - Open a separate protected memory-write owner station when memory mutation enters scope.
  - This disposition is not write authority.
  - Do not write from the attribution station.

### `memory-card-missing`

- Meaning:
  - No matching owner card can be identified.
- Next route:
  - Route a memory-docs or memory-arch topology decision.
  - This is not authorization to create a card.

### `memory-blocked-by-scope`

- Meaning:
  - Current scope forbids memory writes or protected memory phases.
- Next route:
  - For source-level delivery, report protected follow-up pending.
  - For full completion, commit, or release readiness, report the protected memory path as blocked.
  - That blocked state remains until scoped authorization exists.
  - This disposition is not complete.

### `memory-conflict-or-compaction-blocked`

- Meaning:
  - Memory evidence conflicts, or compaction/split is required before a safe write.
- Next route:
  - Route the smallest memory-ops or memory-arch decision needed before mutation.

### `memory-unverified`

- Meaning:
  - Memory evidence was unavailable or not checked.
- Next route:
  - Report unverified memory impact; do not infer attribution.

`memory_commit` is a separate protected phase.

It is not part of attribution, disposition, source delivery, validation, or review.

`memory-required` and `memory-blocked-by-scope` are not completion states.

Source-level delivery may report protected follow-up pending only when both conditions hold.

- Source implementation, validation, review, and sync are otherwise sufficient.
- Memory mutation is outside current authorization.

Full Team-Native completion, commit readiness, and release readiness require resolved memory/docs when memory mutation is required.

Required protected memory phases must be completed before those readiness states can be claimed.

`memory_commit` runs only after an authorized memory card write updates active memory main-file content.

## Closeout Bundle Boundary

An implementation or change-application `closeout_bundle` may help the memory/docs station find
delivery artifacts, changed files, expected dirty files, grounding handoff, validation/review
handoffs, sync evidence, and residual risks.

The bundle is an index/checklist only.
It does not replace memory attribution, owner-card selection, read-only memory evidence, protected
memory authorization, memory write, or `memory_commit`.
Memory/docs stations must inspect the relevant source delivery and memory evidence instead of
copying bundle text into a memory card.

## Forbidden Memory Content

Do not write these into source memory cards:

- plaintext secrets, credentials, tokens, private keys, or sensitive personal data;
- unverified AI prior, stale recall, guesses, or unsourced external claims;
- raw external research transcripts, raw tool logs, raw test output, screenshots, or one-run traces;
- short-lived task status, dirty-file lists, temporary blockers, or handoff prose;
- pricing, legal, regulatory, security, deployment, or API claims without current accepted evidence;
- rejected alternatives, brainstorming, failed attempts, or review comments without durable source impact.

If such content appears in a delivery bundle, keep it in the task artifact or report as residual
risk. Do not promote it to durable memory.

## Memory Admission Matrix

Source memory writes are allowed only when the workflow has a durable, source-backed fact or active constraint to preserve.

Task evidence, screenshots, raw test output, temporary observations, and preference candidates stay elsewhere.

They stay in reports, logs, or project context.

### 03 Build

- Admissible source memory:
  - Implemented and verified source facts, active constraints, tracked file ownership.
  - Stable validation route summaries.
- Not source memory:
  - Draft plans, unimplemented assumptions, raw test output.

### 04 Fix

- Admissible source memory:
  - Confirmed root cause, still-valid repair constraint, regression route summary.
- Not source memory:
  - Full debugging transcript, failed attempts without active consequence.

### 05 Condense

- Admissible source memory:
  - Source-supported project identity, tech stack, deployment, governance facts.
- Not source memory:
  - Unapproved preferences, temporary observations.

### 06 Test

- Admissible source memory:
  - Long-lived validation entry points, invariants, test surface decisions.
- Not source memory:
  - Single-run logs, screenshots, fixture-only evidence.

### 08 Audit

- Admissible source memory:
  - Evidence-confirmed long-lived governance facts.
  - Stable validation route summaries after follow-up work lands.
- Not source memory:
  - Intermediate audit inventories, raw evidence delivery artifacts, one-time performance readings, unverified guesses.

### 09 Commit

- Admissible source memory:
  - Required memory attribution or final source-memory consistency notes.
- Not source memory:
  - Changelog prose or commit message text.

### 10 Routine

- Admissible source memory:
  - Stable governance drift facts after a follow-up source or rule change lands.
- Not source memory:
  - Read-only routine report, temporary warning list, one-time health snapshot.

### 11 Handoff

- Admissible source memory:
  - Pending memory actions and blockers as report items.
- Not source memory:
  - Full next-agent prompt or temporary handoff narrative.

### 12 Skill Forge

- Admissible source memory:
  - Stable skill ownership, trigger semantics, generated skill source facts, and validation route summaries.
- Not source memory:
  - Brainstorming notes, rejected skill drafts, raw lint/test output.

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded.

They must not present incomplete evidence as verified current truth.

## MCP Memory Evidence Matrix

The detailed tool contract lives in `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`.

Workflows can use filesystem evidence when MCP is unavailable.

Missing MCP evidence must be reported as `unverified` or `blocked` when it affects the decision.

`commit_preflight` is scoped to `09 Commit`, explicit commit-prep, or closeout commit/push readiness.

Other workflows use `workspace_brief`, memory list/status/read/deps, memory audit/graph, and context read-only tools.

Those tools are ordinary evidence.

A commit-preflight dirty-file or memory blocker must route to `09` or closeout.

It must not interrupt non-commit implementation, validation, review, audit, routine, or handoff work mid-task.

### 03 Build

- Entry locations:
  - Codex: `.agents/skills/03-build-建構/SKILL.md`
  - Claude: `.claude/commands/03_build(建構)/SKILL.md`
  - Antigravity: `.agents/workflows/03_build(建構計畫).md`
- Minimum MCP memory evidence:
  - Relevant ownership and staleness from memory list/status/read.
  - Dependency evidence when indirect staleness is reported.
  - Context read evidence when acceptance preferences affect implementation.
  - Disposition state before mutation.
- Mutating MCP gate:
  - Protected memory-write owner station only when disposition is `memory-required`.
  - The disposition state is not write authority.
  - Build completion cannot treat `memory-required` or `memory-blocked-by-scope` as complete.
  - `memory_commit` only after an authorized memory card write updates active memory main-file content.

### 04 Fix

- Entry locations:
  - Codex: `.agents/skills/04-fix-修復/SKILL.md`
  - Claude: `.claude/commands/04_fix(修復)/SKILL.md`
  - Antigravity: `.agents/workflows/04-1_fix_plan(修復計畫).md`
- Minimum MCP memory evidence:
  - Ownership, status, dependency, root-cause evidence, and disposition state for affected cards.
  - Unresolved memory conflicts are repair blockers.
- Mutating MCP gate:
  - Memory commit cannot be used as a staleness reset shortcut.
  - It follows verified card edits in a separate protected phase.

### 05 Condense

- Entry locations:
  - Codex: `.agents/skills/05-condense-濃縮/SKILL.md`
  - Claude: `.claude/commands/05_condense（濃縮）/SKILL.md`
  - Antigravity: `.agents/workflows/05_condense(濃縮).md`
- Minimum MCP memory evidence:
  - Workspace brief, memory list/read, and context inventory/status evidence.
  - This evidence separates source facts from preferences.
- Mutating MCP gate:
  - `_system` source-memory write requires authorization resolution plus the matching memory protected gate.
  - Project context write preserves `GO CONTEXT`.
  - It still binds `GO CONTEXT` to the visible context scope.

### 08 Audit

- Entry locations:
  - Codex: `.agents/skills/08-audit-健檢/SKILL.md` plus `08-1/08-2/08-3`
  - Claude: `.claude/commands/08_audit(健檢)/SKILL.md` plus subflows
  - Antigravity: `.agents/workflows/08_audit(健檢).md` plus subflows
- Minimum MCP memory evidence:
  - Workspace brief, memory audit, memory graph/status, and context audit.
  - Commit-preflight findings are referenced only when the audit explicitly checks commit readiness.
  - Those findings route to `09`.
- Mutating MCP gate:
  - Audit does not mutate memory.
  - Follow-up build/fix/commit workflows perform authorized writes.

### 09 Commit

- Entry locations:
  - Codex: `.agents/skills/09-commit-紀錄總結/SKILL.md`
  - Claude: `.claude/commands/09_commit(紀錄)/SKILL.md`
  - Antigravity: `.agents/workflows/09-1_commit_scan(紀錄掃描).md`
- Minimum MCP memory evidence:
  - `commit_preflight` or equivalent memory status evidence.
  - Dirty file list, stale/unattributed file evidence, compact packets, and blockers.
- Mutating MCP gate:
  - Commit/push are separate gates.
  - Memory commit only happens before commit after card content is edited.

### 10 Routine

- Entry locations:
  - Codex: `.agents/skills/10-routine-巡檢/SKILL.md`
  - Claude: `.claude/commands/10_routine(巡檢)/SKILL.md`
  - Antigravity: `.agents/workflows/10_routine(巡檢).md`
- Minimum MCP memory evidence:
  - Workspace brief, memory audit, context audit, sync integrity, and read-only tool availability evidence.
- Mutating MCP gate:
  - No mutating MCP calls.
  - Any write proposal routes to build/fix/audit for authorization resolution and the matching protected gate.

### 11 Handoff

- Entry locations:
  - Codex: `.agents/skills/11-handoff-交接/SKILL.md`
  - Claude: `.claude/commands/11_handoff(交接)/SKILL.md`
  - Antigravity: `.agents/workflows/11_handoff(交接).md`
- Minimum MCP memory evidence:
  - Workspace brief, memory list/status/read summary, stale cards, blockers, dirty files.
  - Unresolved context evidence.
- Mutating MCP gate:
  - Handoff does not mutate memory.
  - Pending writes are reported as next-step blockers.

### 12 Skill Forge

- Entry locations:
  - Codex: `.agents/skills/12-skill-forge-技能鍛造/SKILL.md`
  - Claude: `.claude/commands/12_skill_forge(技能鍛造)/SKILL.md`
  - Antigravity: `.agents/workflows/12_skill_forge(技能鍛造).md`
- Minimum MCP memory evidence:
  - Skill ownership, memory status/read evidence for affected skill domains, context boundary evidence.
  - Validation route evidence and disposition state.
  - Evidence that attribution is read-only or that protected mutation is required.
- Mutating MCP gate:
  - New or modified skill source requires memory attribution before completion.
  - If attribution requires mutation, completion waits for authorized memory write and `memory_commit`.
  - Attribution without card mutation is sufficient only when disposition is `memory-attributed-no-write`.
