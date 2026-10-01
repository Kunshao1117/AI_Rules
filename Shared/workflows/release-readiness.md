# Release Readiness Workflow

This read-only phase sequence organizes evidence for an explicitly selected
release/closeout question. It is not a Completion Agent, authorization source,
review trigger or independent completion state machine.

## 1. Establish the claim

Compare the request, accepted scope and actual changes. Distinguish source
delivery, built package, published release and deployed/installed behavior.
Completion-policy determines which evidence is necessary for the actual claim;
verification-strategy and review-governance own applicability and independence.

## 2. Inspect applicable evidence

Read the existing implementation, verification and review evidence. Check the
source/generated/deployed pair and documentation when the requested result needs
them. Identify missing or stale evidence and the smallest next evidence path.
Do not convert a source edit, checkpoint, helper summary or release asset into
proof of runtime behavior. Use `plugin-release.md` for the plugin/package phases.

## 3. Separate protected follow-up

Report pending publication, deployment, installation, Git or Memory actions
without executing them or treating a source-level task as their authorization.
Frozen Memory consumers retain their original bundle, targets and receipts in
the compatibility reference; this workflow neither derives nor rewrites them.

## 4. Return the evidence summary

Name evidence present, evidence missing, residual risks, protected follow-up and
claim limits. Submit the actual evidence to completion-policy for the final
decision. Historical readiness/receipt shapes remain at
`Shared/policies/references/legacy-skills/team-specialist-release-completion/REFERENCE.md`;
their old state labels are not new general completion states.
