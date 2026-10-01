---
name: pr-review-ops
description: >
  Specified GitHub PR evidence and finding methods. Use when: a specific GitHub PR needs diff, checks, comments or review evidence analysis.
  DO NOT use when: ordinary source review, local diff, generic code review or repository/issue mutation without a specified PR analysis need.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# GitHub PR Evidence Methods

Invocation classification: restricted; provider-specific: yes.
No automatic sibling loading. PR analysis does not require github-ops or a
mutation provider. Shared provider facts and effect boundaries live in
`Shared/policies/references/github-guide.md`; read only the relevant sections.

## Understand the specified PR

1. Confirm host, owner/repo, PR number, base/head repositories and refs, head SHA,
   and comparison base. Bind findings to this revision; a branch name alone moves.
2. Read purpose/description and commit context, then changed files and diff.
   Include pagination and truncation limits; added/modified/removed/renamed/binary
   files can all matter. Select review effort by actual risk and affected behavior,
   not a fixed file count or preference for modified files over added files.
3. Read relevant surrounding source at the correct base/head revision. Compare
   claimed intent with actual data flow, boundaries, error handling, dependency
   effects and project-native conventions. Apply language-specific checks only
   to the real stack; no universal TypeScript or new-test requirement. Where
   applicable, use `Shared/policies/source-document-size-governance.md` thresholds.
4. Inspect existing reviews, review threads and issue-style PR comments. Match
   existing findings by defect, scope and location; do not publish duplicates.
   An outdated thread's current coordinates may be absent: compare its original
   revision/location with the new diff, and never invent a current line number.
5. Inspect CI/check evidence for the reviewed head SHA. Combined commit status
   and check runs are distinct; a success label may cover only one subset.
   Distinguish pending, failed, skipped, stale and missing evidence. Do not rerun
   Actions or modify checks merely to obtain evidence.

## Produce findings

Anchor each substantive finding to the relevant file and revision, diff side
and verified line/range when available. Explain the triggering condition,
consequence, severity and bounded scope; separate a proven defect, inference,
question and optional suggestion. Use project context to avoid generic checklists
or irrelevant preferences. Missing evidence is a limitation, not a clean review.
Before final findings or an authorized submission, compare the current head with
the inspected SHA. If it changed, reassess affected evidence; do not silently
approve a different revision. This is freshness of findings, not review admission.

## Analysis versus publication

“Review this PR” means read/analyze and return findings in chat; it does not
by itself request publication. A local text draft needs no GitHub pending review.
“Submit this review” identifies a remote collaboration request; exact repo/PR,
revision, content and intended event must fit the user's authority and provider
permission before execution. Publication, pending-review creation, adding a
pending comment, submission, deleting a pending review and resolving a thread
are separate server-side effects. Pending is not local or mutation-free.

Neither review pass nor CI green authorizes merge. A request for review does not
request merge, push or publication. This Skill has no MERGE GATE, magic phrase,
Team activation, general Reviewer trigger or completion decision.
`Shared/policies/review-governance.md` owns review applicability/independence;
`verification-strategy.md`, `completion-policy.md` and `agent-governance.md` own
their existing decisions. Remaining owners and provider/credential limits are
linked from the shared reference. Keep evidence transient; no Memory / Project
Context writes or automatic sibling loading.
