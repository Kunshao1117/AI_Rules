# Exact Local Checkpoint Procedure

Phase owner: `Shared/workflows/git-checkpoint.md`. This reference describes an
already authorized checkpoint; it never authorizes Git or creates a Team role.

Record repository root, branch, HEAD, exact file allowlist and empty index
baseline. Consume existing slice/acceptance evidence, secret-check result and
remaining review/verification/Memory/sync states without upgrading them.

After the existing protected Git gate resolves the action:

```text
git add -- <exact-path-1> <exact-path-2> ...
```

Compare staged paths to the exact allowlist and record the staged diff hash.
If scope, baseline, authorization, diff or secret evidence differs, stop before
commit. Do not use reset, restore, stash, checkout or another mutation as repair.
When the authorized staged state matches, the one local commit recipe is:

```text
git commit -m "checkpoint: <bounded slice meaning>"
```

Record commit SHA and verified final HEAD, preserve `push_state: not-requested`
and `history_mode: append-only`, then return the receipt and stop. One stable
slice normally needs at most one checkpoint. Any repair needs a new authorized
append-only action, never implicit amend/history rewriting.

The frozen `git_checkpoint_receipt` field owner remains
`Shared/policies/references/legacy-skills/team-task-board/references/board-field-catalog.md`.
Its checkpoint ID, slice/acceptance references, authority snapshot, paths,
before/after HEAD, staged diff, evidence states, subject, result and blocker
semantics are unchanged. Existing frozen consumers can use the old ID/path
through `legacy-skill-migration.md`; this document does not duplicate the schema.
