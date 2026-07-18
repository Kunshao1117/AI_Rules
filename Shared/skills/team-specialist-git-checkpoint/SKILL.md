---
name: team-specialist-git-checkpoint
description: >
  長工作 Git checkpoint 專家站點（Infra）：Protected local Git checkpoint for a stable
  acceptance-sized delivery slice during long work.
  Use when: 多切片工作、context compaction、跨對話交接、agent replacement、跨 phase、
  或風險操作前需要評估一次本機 checkpoint commit。
  DO NOT use when: 最終 commit、push、tag、branch、merge、history rewrite、一般 dirty files、
  固定時間、只因工作很久、source edit、review、validation、memory mutation。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: none
  tool_scope:
    - filesystem:read
    - terminal:git:read
    - terminal:git:add-exact
    - terminal:git:commit-local-once
  relations:
    role_id: git-checkpoint
    role_layer: specialist
    parent_skill: team-specialist-registry
    support_skills:
      - team-role-boundaries
    embedded_artifacts: []
    artifact_contracts:
      - Shared/skills/team-task-board/references/board-field-catalog.md#git-checkpoint-receipt
    trace_contracts:
      - team-trace-evidence
      - team-station-handoff-packet
---

# Team Specialist Git Checkpoint

## Purpose And Boundary

This skill is the sole execution-procedure owner for one protected local Git
checkpoint during long work. It has two inseparable responsibilities:

1. Evaluate whether one stable delivery slice is eligible for a checkpoint.
2. Under a separately resolved Git authorization, stage exact paths and create
   one local checkpoint commit.

A Git checkpoint improves recoverability. It is not a slice-boundary ledger
checkpoint, final commit, completion, release readiness, validation, review,
memory/docs attribution, or source/deployed sync.

## Eligibility Events

These events may trigger eligibility evaluation only:

- multiple stable delivery slices;
- context compaction;
- cross-thread handoff;
- agent replacement;
- transition across a workflow phase;
- before a separately identified risk-bearing operation.

The following never authorize or require a commit:

- a fixed elapsed time or schedule;
- dirty files by themselves;
- generic `GO`, `continue`, or approval wording;
- the statement that work has taken a long time;
- model capability, convenience, context pressure, or routine cleanup.

If no event applies, return `not-applicable`. If an event applies but the Git
gate is unresolved, return eligibility evidence only and do not mutate Git.

## Protected Authorization Gate

Checkpoint execution requires all of these in the current visible trace:

- formal board row and startup-complete station handoff packet;
- `role_id: git-checkpoint` with a fresh `role_instance_id`;
- protected `authorization_phase: git`;
- exact repository root, stage path allowlist, one local commit action, commit
  subject, expiry, and stop condition;
- `authorization_resolution_state: authorized`;
- forbidden source edits, tests, memory mutation, push, release, deployment,
  install, credential mutation, and external mutation.

The authorization applies to one checkpoint attempt and expires when the
receipt is returned, the baseline drifts, or any gate fails.

## Minimum Eligibility Contract

Before staging, consume the current delivery artifact and existing downstream
evidence without performing those stations' work. All conditions are required:

1. The delivery slice is internally consistent and has one acceptance
   objective.
2. There is no known broken source state. Unknown evidence remains
   `unverified`; a known break is `blocked`.
3. The smallest static or tool evidence proportionate to checkpoint risk is
   already available or is a permitted non-mutating observation. Do not create,
   modify, or run tests from this station.
4. The stage allowlist contains exact file paths, not directories, wildcards,
   globs, or repository-wide selectors.
5. The Git index baseline is empty before staging.
6. No unrelated user change is mixed into the delivery slice or stage
   allowlist.
7. The candidate staged diff contains no plaintext credentials or secret
   material.
8. The commit subject explicitly identifies the commit as a checkpoint, for
   example `checkpoint: <bounded slice meaning>`.

Validation, review, memory/docs, and sync may remain `pending` or `unverified`
for an otherwise stable slice. The receipt must preserve those states and must
not claim completion.

## Allowed Read-Only Evidence

Use only bounded Git reads needed for the receipt, such as:

- worktree and index status;
- current branch, `HEAD`, and repository root;
- unstaged and staged diff for exact paths;
- staged path list and staged diff fingerprint;
- final `HEAD` and commit metadata.

Read-only evidence does not grant mutation authority and does not replace
independent validation or review.

## Execution Procedure

After every gate passes:

1. Record repository root, branch, `head_before`, exact `stage_allowlist`, and
   empty `index_baseline`.
2. Execute one exact staging command:

   ```text
   git add -- <exact-path-1> <exact-path-2> ...
   ```

3. Confirm that `staged_files` equals the exact allowlist and record
   `staged_diff_hash`, evidence states, and secret-check result.
4. If the staged set, baseline, diff, authorization, or secret check does not
   match, stop before commit as `blocked` or `unverified`. Do not use reset,
   restore, checkout, stash, or another mutation to repair the state.
5. Execute exactly one local commit:

   ```text
   git commit -m "checkpoint: <bounded slice meaning>"
   ```

6. Record `commit_sha`, verify the new `HEAD`, set
   `push_state: not-requested`, and set `history_mode: append-only`.
7. Return the canonical `git_checkpoint_receipt` from the board field catalog
   and stop.

## Mutation Allowlist

The only permitted Git mutations are:

- one `git add -- <exact paths>` command;
- one local `git commit` command.

Forbidden actions include source edits, additional staging commands, tests,
push, tag, branch creation or switch, merge, amend, reset, restore, checkout,
rebase, stash, clean, force, cherry-pick, revert, worktree mutation, release,
deployment, install, memory mutation, credential handling, and history rewrite.

Checkpoint repair uses a new authorized append-only commit. Never rewrite the
checkpoint commit. One stable slice should normally produce at most one
checkpoint so the route does not become frequent commit noise.

## Receipt And Downstream Boundary

The board field catalog is the sole owner of the
`git_checkpoint_receipt` schema. This skill populates that object; it does not
redefine it.

The receipt must preserve the checkpoint ID, slice and acceptance references,
authorization snapshot, repository and `head_before`, exact stage allowlist,
empty index baseline, staged files and diff hash, evidence states, secret
check, checkpoint subject, commit SHA, verified final `HEAD`,
`push_state: not-requested`, `history_mode: append-only`, result, and blocker.

Final commit or release readiness still requires the full downstream artifact
chain and separately authorized protected phases. This station does not
self-review, validate, repair, update memory, synchronize deployed copies, or
push.

## Source And Runtime Pair

This source skill normally deploys to:

`Shared/skills/team-specialist-git-checkpoint/SKILL.md`
-> `.agents/skills/team-specialist-git-checkpoint/SKILL.md`

Missing deployed parity remains pending or unverified until a separately
authorized sync station verifies it.
