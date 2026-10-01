# Memory Runtime Cutover Deployment Evidence

This Reference records deployment evidence, not authorization, an activation
flag, or a second state machine. `../authorization-resolution.md` remains the
action owner. M5B rehearsals never activate a real project/runtime. The exact
project root, platform, runtime instance/version and source content fingerprint
must be rechecked at M5C; HEAD alone cannot identify a dirty source revision.

```text
evidence_id: transaction/rehearsal identifier
project_root: exact isolated or real target, with isolation evidence
platform: exact platform
runtime_instance_version: exact instance/version, or unverified
canonical_source_revision: HEAD plus dirty source content fingerprint
preflight_evidence: current plan and blockers
managed_path_inventory: exact file paths, pre-image hashes and provenance
projection_hashes: expected and observed output hashes
legacy_copy_disposition: exact-known retire | absent | preserve-and-block
local_override_blockers: modified/unknown paths; no overwrite or force retire
rollback_point: persistent manifest plus original bytes and verified hashes
static_checks: path resolution, index, direct scan, metadata and role registry
new_session_smoke: pending | observed evidence; never inferred from disk parity
activation_eligibility: evidence assessment, with remaining conditions
failure_rollback: exact-point restore procedure and observed result
```

Use `New-DeploymentRollbackPoint` in `Deployment.Transaction.psm1` before the
existing `Invoke-DeploymentTransaction`; pass its `RollbackPointPath` so the
failure snapshot is limited to that exact file inventory. The plan must cover
routes, indexes, required-skills metadata, physical retirement and new
projection together. Existing files require independently established exact
framework hashes. Absent files are planned new framework projections. A
modified/unknown pre-image blocks point creation before deployment writes.
Do not derive ownership merely from a file being inside a runtime directory.

After successful projection, `Complete-DeploymentRollbackPoint` verifies the
planned output hashes. The point survives process exit. After a later smoke
failure, `Restore-DeploymentRollbackPoint -Path <point> -TargetRoot <exact-root>`
validates all pre-images/backups and current hashes before any recovery write.
It restores only listed paths; fresh planned files may be removed only while
their current hash matches the expected projection. A subsequent local edit
blocks the entire recovery and is preserved. Unknown adjacent files, Memory,
Project Context, logs, Cartridge, credentials and Git history are outside the
point. An interrupted recovery can be retried after resolving its blocker;
do not claim rollback complete without hash verification. Keep the point
through the real smoke; do not use blanket orphan cleanup.

Activation is scoped to `project root × platform × runtime instance/version`.
Successful fixture/static checks only support a real preflight. They do not
authorize a different platform or an already-open session. Record
`REAL_SESSION_BEHAVIOR_REQUIRES_M5C` until a new real session is observed.
Writing or reading this evidence is never itself a cutover decision, and no
authorization resolver reads a boolean here to unlock Memory. In M5B report
real runtime frozen even when every disposable fixture passes.

Cartridge synthetic results prove policy interpretation only. Actual isolated
source executions must identify source commit and tested seam. A headless
watcher/event-helper observation does not verify the installed VS Code
extension or a long-running desktop session. A warning self-write that clears
pending/ghost state before reconciliation must remain a stated compatibility
finding; never repair Cartridge as part of the deployment rehearsal.
