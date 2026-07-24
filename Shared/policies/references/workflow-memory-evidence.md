# Workflow Memory Evidence Reference

This reference holds memory admission and MCP memory evidence details.

Those details are too large for `Shared/workflow-capability-evidence-matrix.md`.

It is evidence guidance only.

Memory writes, memory commits, and project context writes require their own protected authorization gates.

## Lifecycle Touchpoints

Memory handling has five distinct touchpoints. They must not be collapsed into one task step.

For a normal formal source change, downstream memory consumers receive only a
`completion_bundle_ref`. They consume the canonical Memory Closure Bundle Contract's already
resolved phase evidence through that reference; this evidence reference does not restate a candidate
map, phase-field schema, authority, or owner.

1. Task-start memory read and clues:
   - Relevant memory summary, memory registry, project context, and prior rollout references are read-only clues.
   - They help scope likely owner cards, stale areas, and project constraints before implementation or evidence work.
   - They do not prove current source truth, authorize source writes, authorize memory writes, or satisfy memory/docs delivery.
2. Post-task memory/docs disposition:
   - After source, workflow, skill, governance, or durable documentation changes, a memory/docs route must decide whether memory is not required, already attributed, required, missing, blocked by scope, conflicted, or unverified.
   - This disposition is read-only evidence and routing. It may cite changed files and delivery artifacts.
   - It does not mutate memory and does not authorize mutation.
3. Memory closure:
   - After validation and review return terminal evidence, the read-only memory/docs station hands
     the disposition and `completion_bundle_ref` to `memory-closure`.
   - `memory-closure` consumes the canonical contract's accepted phase evidence and returns
     `memory_no_write_receipt` or the required protected-phase receipts; it neither reuses
     implementation authority nor invents a new authorization.
4. Protected memory write:
   - A memory card write is a separate protected phase.
   - It requires current canonical phase evidence reached through `completion_bundle_ref` and
     current source evidence; this reference does not select a card, topology, or actor.
   - It cannot be performed by implementation, validation, review, or completion stations unless that exact protected phase is assigned.
5. Protected `memory_commit`:
   - `memory_commit` is a separate protected phase after an authorized memory write updates active memory content.
   - It uses current canonical phase evidence reached through `completion_bundle_ref`; it is never
     an automatic continuation of implementation or of the write phase.
   - It is not part of task-start reading, attribution, post-task disposition, source delivery, validation, or review.
   - It must not be used as a shortcut to reset stale memory state without a verified card edit.

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
  - `memory-closure` consumes `completion_bundle_ref` and the canonical contract's resolved phase
    evidence. This disposition and reference are not new write authority.
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
  - A normal formal source change stays blocked or unverified for process-complete.
  - Report protected follow-up pending only when `completion_bundle_ref` resolves through the
    canonical contract to the `source-level-explicit` closeout target.
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

Normal formal source changes target process-complete. After validation and review, memory closure
must consume `completion_bundle_ref` and the canonical contract's accepted evidence, then return
either `memory_no_write_receipt` or `memory_committed_receipt`; the latter proves the distinct
protected write and `memory_commit` phases both ran. Missing MCP evidence or either receipt keeps
process-complete unavailable.

Protected follow-up pending is allowed only when `completion_bundle_ref` resolves through the
canonical contract to `source-level-explicit` and source implementation, validation, review, and
sync are otherwise sufficient. It blocks process-complete, commit readiness, and release readiness.

`memory_commit` runs only after an authorized memory card write updates active memory main-file content.

## Completion Bundle Boundary

An implementation or change-application delivers `completion_bundle_ref`. Memory/docs and
memory-closure consume that reference and the canonical contract's resolved phase evidence to find
delivery artifacts, changed files, expected dirty files, grounding handoff, validation/review
handoffs, sync evidence, and residual risks.

The reference is a consumer input, not evidence by itself. It does not replace memory attribution,
read-only memory evidence, protected authorization, memory write, `memory_commit`, or the required
no-write/committed receipt. Memory/docs stays read-only and hands `completion_bundle_ref` to
`memory-closure`; neither station copies bundle text into a memory card.

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
It cannot support `memory_no_write_receipt`, `memory_committed_receipt`, or process-complete.

`commit_preflight` is scoped to `09 Commit`, explicit commit-prep, or closeout commit/push readiness.

Other workflows use `workspace_brief`, memory list/status/read/deps, memory audit/graph, and context read-only tools.

Those tools are ordinary evidence.

A commit-preflight dirty-file or memory blocker must route to `09` or closeout.

It must not interrupt non-commit implementation, validation, review, routine, or handoff work mid-task.

### 03 Build

- Entry locations:
  - Codex: `.agents/skills/03-build-建構/SKILL.md`
  - Claude: `.claude/commands/03_build(建構)/SKILL.md`
  - Antigravity: `.agents/workflows/03_build(建構計畫).md`
- Minimum MCP memory evidence:
  - Relevant ownership and staleness from memory list/status/read.
  - Dependency evidence when indirect staleness is reported.
  - Context read evidence when acceptance preferences affect implementation.
  - Disposition state before mutation and `completion_bundle_ref`.
- Mutating MCP gate:
  - A protected memory-write phase only when disposition is `memory-required` and the current
    canonical phase evidence reached through `completion_bundle_ref` permits it.
  - The disposition state is not write authority.
  - Build process-complete needs the memory-closure no-write or committed receipt; it cannot treat
    `memory-required`, `memory-blocked-by-scope`, missing MCP, or a missing receipt as complete.
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
- Memory boundary: This Git-only route does not inspect memory, context, MCP, or sync-integrity content.
- Mutating MCP gate: No MCP calls.

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
