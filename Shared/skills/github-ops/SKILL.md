---
name: github-ops
description: >
  GitHub repository and remote operation methods. Use when: a specific GitHub repository, issue, branch or remote operation is requested, or GitHub-specific remote evidence is needed.
  DO NOT use when: ordinary local Git, general coding, local source review or PR quality analysis without a repository operation need.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# GitHub Repository Operation Methods

Invocation classification: restricted; provider-specific: yes.
No automatic sibling loading. An issue update does not load pr-review-ops;
this entry does not teach PR quality review or decide whether review is required.
Read the relevant section of `Shared/policies/references/github-guide.md` for
provider facts, effect classes and the existing canonical owners.

## Identify the operation and target

1. Resolve the GitHub host, owner/repository, visibility and access context.
   Match the requested URL/repository; a local remote name is only a clue.
   Distinguish source and destination repositories for forks and cross-repo PRs.
2. Bind the actual target: issue/PR number, branch/ref, file path, tag/release,
   workflow ID and ref as applicable. Do not assume the default branch is main.
   Read the necessary current state; paginate rather than assume one page is all.
3. State the intended effect before selecting a provider operation: observation,
   collaboration mutation, repository mutation or integration/publication.
   These are effect descriptions, not a new authorization enum. Actual authority
   comes from `Shared/policies/authorization-resolution.md` and provider permission.
   Unknown action/target stops mutation; available tools do not supply intent.

## Repository and issue methods

- **Read/search:** narrow repo/ref/path or issue filters to the question. Search
  results identify candidates; inspect the actual file and commit for evidence.
  Distinguish a file's blob SHA from a commit SHA; report missing/truncated/binary
  content as a limitation. Reading a public repo does not require PR review.
- **Issue changes:** inspect existing state/comments before proposing exact field
  changes or a comment, avoiding duplicates. Read, create, edit, assign, close and
  comment are separate effects; do not chain them because a tool returned success.
- **Branch/file changes:** bind source ref and destination branch, intended paths
  and existing file content. For an update, use the current blob SHA from the same
  destination branch when required by the provider. Validate replacement content
  and preserve concurrent edits. A multi-file push may make one remote commit;
  it is not a local filesystem write. Never force or retry over changed state.
- **PR creation/update:** confirm destination repo, exact head/base and scope of
  the title/body before an authorized request. Existing commits and completed
  local source work do not authorize creating a PR or updating its branch.
- **Integration/publication:** a merge, release, dispatch or publish request must
  identify its own action and target. For an authorized merge, recheck head SHA,
  relevant required evidence and repository restrictions; use expected-head
  protection where supported. Review approved or CI green never supplies merge
  authority. A provider failure does not authorize bypassing branch protection.

## Execution result and freshness

For an authorized operation, use only the selected ready provider and exact
in-scope payload. Refresh stale state rather than overwriting it. On a timeout
or ambiguous response, inspect the affected remote state before any retry to
avoid duplicate comments, PRs, commits, releases or workflow runs.
Report proposed, attempted and confirmed changes separately; retain the returned
identity/revision and read back material effects when needed. A successful call
is not proof of application correctness, workflow completion or deployment.

“Fix the bug” permits the necessary local work, not remote push. “Fix it and push
the branch” includes that remote action only for the resolved target and scope.
Do not automatically push, create a PR, merge, release or dispatch a workflow.
Do not automatically invoke Copilot or another external AI worker. Capability,
review, verification, completion, Agent/model and Memory decisions remain with
the canonical owners named in the provider reference; no readiness/auth state
is written to Memory / Project Context.
