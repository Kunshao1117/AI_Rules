# Local Git Checkpoint Workflow

This is phase guidance for an explicitly requested, separately authorized local
checkpoint. It is not an Agent role, scheduled commit trigger, final commit or
completion decision. Execution/authorization policy and the protected Git gate
remain canonical. A stable slice or elapsed time never supplies permission.

## 1. Evaluate a bounded recovery point

Consider a stable acceptance-sized slice before a handoff, phase transition or
identified recovery risk. Inspect existing evidence and the exact candidate
paths. Keep unknown/broken state explicit; do not run another station's repairs
or tests as part of checkpoint inspection. Check that no unrelated dirty change
or secret is included and that the Git index baseline is empty.

## 2. Resolve the exact Git action

Use authorization-resolution and the protected-action registry for repository,
exact staging paths, one local commit, subject, expiry and stop condition. No
directory/glob/repository-wide staging scope is supplied by this workflow.
If authority or stable scope is absent, return eligibility evidence only.

## 3. Stage, inspect, commit and stop

After the authorized gates are satisfied, record HEAD/index baseline; stage
exact paths once; compare the staged set and diff to the accepted scope; then
make the single local checkpoint commit. Stop before commit on any mismatch;
do not repair the index with another mutation. Preserve append-only history
and leave push unrequested. Detailed command/receipt methods are in
`Shared/policies/references/git-checkpoint-procedure.md`.

## 4. Return the receipt

Record before/after HEAD, exact paths, diff evidence, checkpoint subject, result
and remaining evidence gaps. The existing board catalog remains the frozen
`git_checkpoint_receipt` schema owner through the compatibility mapping. A
checkpoint does not satisfy review, validation, Memory, release or completion.
