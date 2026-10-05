---
name: memory-ops
description: >
  專案記憶卡日常方法：查找先前專案知識、operator recall、Memory Impact Review、
  stale review 與既有卡維護。Use when: a task needs relevant Memory evidence,
  historical technical reasoning, or an ordinary existing-card comparison/update.
  DO NOT use when: choosing new-card topology, an ambiguous owner, split,
  compaction, or archive structure; use memory-arch for those decisions.
metadata:
  author: antigravity
  version: "3.0"
  origin: framework
  kind: operational
  memory_awareness: full
  load_semantics: DISCOVERABLE_ON_DEMAND
  tool_scope: ["filesystem:read", "filesystem:write", "mcp:cartridge-system"]
---

# Memory Operations

This is the provider-neutral, Direct-first method Skill for Memory discovery,
operator recall, Memory Impact Review, and ordinary existing-card maintenance.
It supplies methods, not authorization, completion, Team routing, or a new
disposition vocabulary. `../../policies/memory-governance.md` owns when and why
to review; `../../policies/references/workflow-memory-evidence.md` owns the seven
dispositions. Load only the reference needed for the task:

| Need | Reference |
|---|---|
| Existing card format and content sections | `references/memory-template.md` |
| Stale, tracking, schema, and heading maintenance | `references/memory-lifecycle-procedures.md` |
| Available tool behavior and failure evidence | `references/memory-mcp-tool-contract.md` |
| New owner, split, compaction, or archive topology | `../memory-arch/SKILL.md` |

## Find The Smallest Relevant Memory Surface

- For a known module or card, use relevant `memory_status` and `memory_read`
  directly, or read the active main file if the provider is unavailable.
- For an unknown owner, discover candidates with `memory_list`, `memory_graph`,
  or `memory_deps`; then read only plausible cards and their direct relations.
- `memory_deps` helps when indirect staleness or actual dependency impact is in
  question. It is not required for every read.
- Do not scan every card at startup or impose `memory_list → memory_read` on
  every task. A known module needs no discovery-first ceremony.
- Active target cards use `MEMORY.md`; existing `SKILL.md` card files remain
  legacy compatibility until their governed migration. Neither is an
  executable Skill just because of its filename.

## Operator Recall

For questions such as “what did we previously decide?”, “why was an approach
stopped?”, or “is it still applicable?”, read the relevant Memory and its
traceable archive when needed. If the answer concerns an approved product
direction or preference, also read the relevant Project Context under
`../../policies/project-context-protocol.md`. If the question asks what is true
*now*, obtain current direct evidence from source, version, or an appropriate
live read-only check. Report the historical conclusion, reason, scope, and
current validity separately. A stale card can guide investigation but cannot
by itself establish current truth.

## Memory Impact Review Method

Apply `../../policies/memory-governance.md` and return a disposition from
`../../policies/references/workflow-memory-evidence.md`; do not define another
set here.

1. Locate the plausible owner card and note its valid scope and version.
2. Obtain current source evidence (including version or changed slice) and
   relevant Memory evidence. Compare the affected durable claims, ownership,
   scope, and tracking relationships; record material gaps.
3. Record the comparison result and reason against the source/card versions.
   An existing card alone never proves `memory-attributed-no-write`. For that
   result, record current source evidence, relevant Memory evidence, owner and
   valid scope, affected durable claims, comparison result, and reason why the
   durable content and tracking remain correct.
4. Treat `stale = review needed`, not proven wrong or mandatory write. A stale
   card is a historical clue, not current truth without revalidation. Review
   can lead to no-write, content update, tracking-only update, conflict, or
   unverified evidence. No-write does not claim the stale index is cleared.
5. When only `Tracked Files`, owner mapping, dependencies, or other persistent
   metadata changed, select canonical `memory-required` with reason
   `tracking-only`, not an eighth disposition. Distinguish changed knowledge
   from changed tracking.

## Existing-Card Maintenance And Sync

For an ordinary content edit or tracking repair of a known existing card,
`memory-ops` is sufficient; it does not require `memory-arch`. Use this order:

1. Complete the Impact Review and decide whether any edit is necessary.
2. Make the necessary content or tracking edit only if permitted by
   `../../policies/authorization-resolution.md`; preserve evidence, scope,
   important supersession, and card schema. Memory is not a changelog.
3. Run `memory_commit` or applicable sync only when separately permitted by
   the applicable authorization contract and supported by the provider.
4. Inspect result with read-only evidence. Report the content update result,
   commit result, index or derived-state result, and remaining warnings
   separately. A successful main-file write does not prove sync succeeded.

`confirm:true` is a tool mutation acknowledgement, not user authorization or
scope expansion permission. Main's direct verification is not independent
review or independent verification. Apply `../../policies/review-governance.md`
and `../../policies/verification-strategy.md` if independence is required;
`../../policies/completion-policy.md` owns the overall completion judgment.
This method does not create a Memory Agent.

Content follows the existing card sections (`Current Truth`, `Active
Constraints`, `Evidence Base`, `Read Contract`, `Relations`, `Archive Index`,
`Conflicts and Supersession`). Keep concise technical rationale, important
supersession/stop reasons, and revalidation conditions when costly to
rediscover; longer traceable history goes to archive. A rejected alternative
belongs only if formally evaluated, directly relevant, likely to recur, of
high rediscovery cost, and supported by evidence, scope, and rejection reason
under `../../policies/memory-governance.md`. Ordinary brainstorming and failed
attempts do not qualify. Technical facts and rationale go to Memory; approved
product direction and acceptance defaults go to Project Context. A candidate
recorded in Memory is not an approved Context decision.

## Migration Boundary

The vNext target method permits ordinary same-scope maintenance only after
the applicable authorization decision. **Current migration compatibility is
stricter:** until the exact project/runtime passes evidenced M5 cutover, any physical runtime
`.agents/memory/**` mutation, `memory_commit`, reindex, or index sync remains
`frozen_memory_action` under `../../policies/authorization-resolution.md`,
regardless of caller, tool, or whether this Skill was loaded. Loading this
source Skill does not activate the target `local_work` route. Do not use
`memory_commit` as a stale-counter reset or perform mutation during read-only
work. Current platform runtime copies remain unchanged until M5 projection.
For an explicitly requested source-only reconciliation, follow the complete
Repository Source Reconciliation boundary in Authorization Resolution and its
`../../policies/references/repository-memory-reconciliation.md` evidence method. An ordinary
source edit request is not that migration authorization. This route cannot
call Memory mutation tools or claim synchronized runtime state.

## Legacy Compatibility

This section is not the ordinary method. Unmigrated Team/Memory consumers
still follow `../../policies/references/memory-closure-bundle-contract.md`,
the four legacy Team Memory Skills, and their protected-phase receipts. The
legacy `completion_bundle`, `team-task-board`, and station fields are
compatibility transport, not this Skill's general routing or schema.

For that frozen route, `memory-closure` returns `memory_no_write_receipt` or
`memory_committed_receipt` with distinct write and commit receipts.
Missing MCP capability or receipt is `memory-unverified` or `blocked`; it cannot be rendered as process-complete.
A `memory-conflict-or-compaction-blocked` legacy finding
requires its contract's decision before writing. A legacy no-write receipt
does not substitute for a new V2 source/card comparison.
