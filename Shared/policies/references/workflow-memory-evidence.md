# Workflow Memory Evidence Reference

This is the sole vNext canonical definition owner of the seven Memory
disposition values and their V2 evidence meaning. `../memory-governance.md`
owns the Memory Impact Review trigger, staleness, and admission policy; this reference also
retains evidence detail needed by frozen consumers.

Those details are too large for `Shared/workflow-capability-evidence-matrix.md`.

Its disposition result is evidence and routing, never mutation authority or a
second completion state.

Before a project/runtime passes the M5 cutover checks in
`../authorization-resolution.md`, runtime Memory mutation remains frozen.
Only that owner's narrowly reviewed Repository Source Reconciliation boundary
can classify a source-only existing-card patch separately. It does not satisfy
runtime sync or change the frozen consumer evidence below. The
ordinary vNext evidence path does not require `completion_bundle_ref`, a
`memory-docs` station, or a closure receipt: use the current source/card
comparison in `memory-review-evidence.md`, actual update and sync results in
`memory-update-sync-evidence.md`, and `../completion-policy.md`. These owners
cover disposition, freshness, conditional Verification/Review and completion;
Authorization Resolution and `memory-arch` cover owner, scope and topology.
The legacy bundle remains applicable to an unmigrated frozen consumer.
Project Context writes keep their own authorization boundary.

## Lifecycle Touchpoints

The five touchpoints below describe the frozen Memory workflow/bundle consumer.
They are not a required stage chain for every ordinary vNext task and do not
override `../memory-governance.md` or general authorization/completion policy.

For a bundle-backed legacy formal source change, downstream memory consumers receive only a
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

When Memory Impact Review applies, return exactly one of the seven values below
with evidence for the current source/card scope. Frozen workflows retain their
existing read-only memory/docs disposition requirement and unchanged same-named
legacy judgment/receipt conditions. The V2 meanings below govern ordinary
vNext results; they do not retrospectively reinterpret a frozen bundle or its
receipt. A legacy no-write receipt is not V2 no-write evidence without a new
current-source/card comparison. Conversely, M1 does not invalidate a receipt
for its unchanged legacy closeout target. No operation may combine a legacy
receipt's lower evidence threshold with the ordinary vNext authorization path.

This evidence is required before opening any memory mutation path.

It is read-only disposition and routing evidence; it does not authorize memory mutation.

The canonical disposition states are:

### `memory-not-required`

- Meaning:
  - The reviewed change and scope have no relevant durable Memory knowledge to
    maintain. State the examined scope and reason; a missing card is not evidence
    that Memory is unnecessary.
- Next route:
  - No memory mutation path.

### `memory-attributed-no-write`

- Meaning:
  - This is a completed Memory Impact Review: current source evidence and
    relevant Memory evidence were compared for the affected durable claims;
    the owner and valid scope match, the comparison result shows those claims
    remain correct, and no Memory content change required for this change.
  - Record source/card versions and the compared claims. An existing owner alone
    is insufficient. No-write does not prove that stale or index state is cleared
    or that a tool sync ran. If tracking/metadata repair is required for this
    scope, return `memory-required` with `tracking-only` reason instead; a
    derived stale/index warning alone is not proof of a content change.
- Next route:
  - No content mutation path; preserve the comparison evidence for completion.

### `memory-required`

- Meaning:
  - A durable Memory change is required for current content or necessary
    tracking/owner/dependency/metadata alignment. Record `content` or
    `tracking-only` as a reason/evidence value, not another disposition.
- Next route:
  - Resolve the exact owner, authorization, operation and necessary sync under
    their canonical owners; this result grants no write or commit authority.
  - Frozen consumer: `memory-closure` consumes `completion_bundle_ref` and the
    canonical contract's separate phase evidence. Attribution remains read-only.

### `memory-card-missing`

- Meaning:
  - Durable knowledge needs an owner card, but none can be identified safely;
    name nearby candidates and the unresolved ownership question.
- Next route:
  - Route the smallest `memory-arch` topology decision; this is not authority to
    create a card. Frozen consumers keep their memory-docs station route.

### `memory-blocked-by-scope`

- Meaning:
  - A necessary Memory operation is known, but observe-only, explicit no-write,
    scope limits, or the applicable legacy protected phase forbids it.
- Next route:
  - Stop only the affected operation and ask for the missing scope decision when
    required. General task completion is decided by `../completion-policy.md`.
  - Frozen consumer: preserve the bundle's `source-level-explicit` exception,
    protected-follow-up rule, and process-complete/release blockers.

### `memory-conflict-or-compaction-blocked`

- Meaning:
  - Relevant evidence conflicts, or compaction/split is required before the
    necessary write can be made safely; name the conflict or limit.
- Next route:
  - Route the smallest evidence or `memory-arch` decision before mutation; do not
    silently choose a convenient fact.

### `memory-unverified`

- Meaning:
  - Relevant source/card/version evidence is missing, inaccessible, stale for
    the claim, or not yet compared; state exactly what remains unknown.
- Next route:
  - Report unverified memory impact; do not infer attribution.

## Frozen Memory Consumer Compatibility

The following closure, receipt, and protected-phase statements apply only to
unmigrated frozen consumers. They remain in force until verified M5 cutover
retires their active runtime path and are not the general meaning of the seven
dispositions.

For this frozen route, `memory_commit` is a separate protected phase.

It is not part of attribution, disposition, source delivery, validation, or review.

`memory-required` and `memory-blocked-by-scope` are not completion states.

Legacy bundle-backed formal source changes target process-complete. After validation and review, memory closure
must consume `completion_bundle_ref` and the canonical contract's accepted evidence, then return
either `memory_no_write_receipt` or `memory_committed_receipt`; the latter proves the distinct
protected write and `memory_commit` phases both ran. Missing MCP evidence or either receipt keeps
process-complete unavailable.

Protected follow-up pending is allowed only when `completion_bundle_ref` resolves through the
canonical contract to `source-level-explicit` and source implementation, validation, review, and
sync are otherwise sufficient. It blocks process-complete, commit readiness, and release readiness.

`memory_commit` runs only after an authorized memory card write updates active memory main-file content.

## Completion Bundle Boundary

In the legacy bundle-backed route, an implementation or change-application delivers `completion_bundle_ref`. Memory/docs and
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
- ordinary rejected alternatives, brainstorming, failed attempts, or review
  comments without durable source impact; a formally evaluated alternative
  meeting `../memory-governance.md` admission criteria is not forbidden merely
  because it was rejected.

If such content appears in a delivery bundle, keep it in the task artifact or report as residual
risk. Do not promote it to durable memory.

## Memory Admission Matrix

`../memory-governance.md` owns admission. The examples below illustrate
durable source-backed facts, constraints, and admitted technical rationale;
they do not narrow or redefine its rule.

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
  - Brainstorming notes, low-value rejected skill drafts, raw lint/test output.

Memory cards must record incomplete evidence as partial, pending review, conflict, or superseded.

They must not present incomplete evidence as verified current truth.

## MCP Memory Evidence Matrix

The detailed tool contract lives in `.agents/skills/memory-ops/references/memory-mcp-tool-contract.md`.

Workflows can use filesystem evidence when MCP is unavailable.

Missing MCP evidence must be reported as `unverified` or `blocked` when it affects the decision.
For a legacy bundle-backed target it cannot support `memory_no_write_receipt`,
`memory_committed_receipt`, or process-complete. Ordinary vNext evaluates the
actual required evidence under Completion Policy without inventing a receipt.

`commit_preflight` is scoped to `09 Commit`, explicit commit-prep, or closeout commit/push readiness.

Other workflows use `workspace_brief`, memory list/status/read/deps, memory audit/graph, and context read-only tools.

Those tools are ordinary evidence.

A commit-preflight dirty-file or memory blocker must route to `09` or closeout.

It must not interrupt non-commit implementation, validation, review, routine, or handoff work mid-task.

### 03 Build

- Entry locations:
  - Codex: `.agents/skills/03-build-建構/SKILL.md`
  - Cursor: `.cursor/skills/03-build-建構/SKILL.md`
  - Claude: `.claude/commands/03_build(建構)/SKILL.md`
  - Antigravity: `.agents/workflows/03_build(建構計畫).md`
- Minimum MCP memory evidence:
  - Relevant ownership and staleness from memory list/status/read.
  - Dependency evidence when indirect staleness is reported.
  - Context read evidence when acceptance preferences affect implementation.
  - Disposition state before mutation; `completion_bundle_ref` only for a legacy bundle-backed consumer.
- Mutating MCP gate:
  - Before verified M5 cutover, a protected memory-write phase only when disposition is `memory-required` and the current
    canonical phase evidence reached through `completion_bundle_ref` permits it.
  - The disposition state is not write authority.
  - Legacy bundle-backed Build process-complete needs the memory-closure no-write or committed receipt; it cannot treat
    `memory-required`, `memory-blocked-by-scope`, missing MCP, or a missing receipt as complete.
  - Ordinary vNext Build uses Authorization Resolution and Completion Policy; a bundle or receipt is not required.
  - `memory_commit` only after an authorized memory card write updates active memory main-file content.

### 04 Fix

- Entry locations:
  - Codex: `.agents/skills/04-fix-修復/SKILL.md`
  - Cursor: `.cursor/skills/04-fix-修復/SKILL.md`
  - Claude: `.claude/commands/04_fix(修復)/SKILL.md`
  - Antigravity: `.agents/workflows/04-1_fix_plan(修復計畫).md`
- Minimum MCP memory evidence:
  - Ownership, status, dependency, root-cause evidence, and disposition state for affected cards.
  - Unresolved memory conflicts are repair blockers.
- Mutating MCP gate:
  - Memory commit cannot be used as a staleness reset shortcut.
  - Before verified M5 cutover it follows verified card edits in a separate frozen protected phase; post-cutover ordinary same-scope commit is classified by Authorization Resolution.

### 05 Condense

- Entry locations:
  - Codex: `.agents/skills/05-condense-濃縮/SKILL.md`
  - Cursor: `.cursor/skills/05-condense-濃縮/SKILL.md`
  - Claude: `.claude/commands/05_condense（濃縮）/SKILL.md`
  - Antigravity: `.agents/workflows/05_condense(濃縮).md`
- Minimum MCP memory evidence:
  - Workspace brief, memory list/read, and context inventory/status evidence.
  - This evidence separates source facts from preferences.
- Mutating MCP gate:
  - `_system` source-memory write requires authorization resolution plus the matching frozen Memory protected gate before verified M5 cutover; later action classification remains operation/scope specific.
  - Project context write preserves `GO CONTEXT`.
  - It still binds `GO CONTEXT` to the visible context scope.

### 09 Commit

- Entry locations:
  - Codex: `.agents/skills/09-commit-紀錄總結/SKILL.md`
  - Cursor: `.cursor/skills/09-commit-紀錄總結/SKILL.md`
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
  - Cursor: `.cursor/skills/10-routine-巡檢/SKILL.md`
  - Claude: `.claude/commands/10_routine(巡檢)/SKILL.md`
  - Antigravity: `.agents/workflows/10_routine(巡檢).md`
- Memory boundary: This Git-only route does not inspect memory, context, MCP, or sync-integrity content.
- Mutating MCP gate: No MCP calls.

### 11 Handoff

- Entry locations:
  - Codex: `.agents/skills/11-handoff-交接/SKILL.md`
  - Cursor: `.cursor/skills/11-handoff-交接/SKILL.md`
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
  - Cursor: `.cursor/skills/12-skill-forge-技能鍛造/SKILL.md`
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
