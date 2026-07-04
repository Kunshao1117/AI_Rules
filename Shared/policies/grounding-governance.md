# Grounding Governance Policy

This policy is the AI_Rules source of truth for external grounding, freshness
checks, source ranking, and missing-evidence reporting. Workflow entries,
skills, matrices, and platform adapters must reference this policy instead of
copying external-research rules into local playbooks.

## Source Of Truth And Precedence

- Framework source: `Shared/policies/grounding-governance.md`.
- Deployed runtime copy: `.agents/shared/policies/grounding-governance.md`.
- The source file is authoritative. The deployed copy must remain
  content-identical after any grounding-governance change.
- Local project files, lockfiles, and tool output govern the installed project
  state. Official or primary external sources govern current external facts.
- If this policy conflicts with a workflow-local checklist, keep this policy as
  the external-grounding source and move task-specific procedure back to the
  workflow or skill.

## Mandatory Grounding Triggers

External grounding is required before giving advice, changing source, or
claiming verification when the answer depends on:

- current or fast-changing facts: laws, prices, schedules, releases, APIs,
  platform rules, security advisories, product behavior, public figures, or
  external service status;
- third-party documentation, dependencies, cloud platforms, packages, browser
  behavior, standards, or vendor policies that may have changed;
- substantial cost, safety, legal, medical, financial, deployment, release, or
  security consequences;
- user requests to search, verify, check latest/current/today, cite sources, or
  use a named external page, paper, dataset, repository, issue, or document;
- conflict between memory, model knowledge, local files, tool output, and
  external claims.

If grounding is required but unavailable, the result is `未查`, `查不到`, or
`阻塞`; it must not be reported as verified.

## No-Search Exceptions

External grounding may be skipped only when the decision is fully supported by
the current conversation, provided snippets, local source files, stable general
knowledge, or non-mutating local tool output, and no current external fact is
needed.

When skipping is material to the conclusion, mark completion evidence as
`不適用` and name the basis, for example local file evidence or stable language
semantics. Do not use this exception for dependency versions, service behavior,
regulatory claims, pricing, schedules, or "latest" questions.

## Source Ranking

Use the strongest available source tier and label weaker evidence honestly.

| 等級 | 來源 | 使用邊界 |
|---|---|---|
| 官方來源 | Vendor docs, standards bodies, law/regulator pages, project release notes, official repositories | Preferred for rules, APIs, versions, and supported behavior. |
| 主要來源 | Source code, lockfiles, changelogs, issue/PR threads by maintainers, direct tool output, observed runtime behavior | Preferred for the local project state and concrete implementation evidence. |
| 高可信二手來源 | Reputable technical articles, security advisories, research summaries, maintained compatibility tables | Use only when official/primary evidence is missing or incomplete; label the gap. |
| 低可信或社群來源 | Forums, social posts, unofficial snippets, generated summaries, mirrors | Use as leads only; do not claim verification from them alone. |

Official and primary sources take precedence over summaries, memory, and model
knowledge. If sources disagree, report the conflict and use the evidence that
best matches the local version, date, and authority.

## Local Version Versus Latest Documentation

Project-locked versions constrain implementation guidance. Before applying
current external documentation to a project, compare it with local lockfiles,
package manifests, framework config, API version pins, generated clients, or
runtime tool output when those files are available.

If latest documentation conflicts with the project-locked version:

- follow the local locked version for immediate code changes unless the task is
  explicitly an upgrade or migration;
- cite the current official documentation as migration or drift evidence, not
  as proof that the installed project already supports it;
- mark unsupported or unconfirmed version behavior as `部分已查` or `未查`;
- do not upgrade dependencies, regenerate clients, or change platform state
  without a separate scoped authorization gate.

## Team Mode Grounding Responsibilities

When Team mode is active, the captain coordinates routing, board/channel state,
station artifact receipt, blockers, and Director-facing synthesis.
Authorization binding stays with `authorization-resolution.md` and scoped
Director evidence. The captain may perform small coordination reads, but broad
external research is a formal station task.

Use an `external-research` station when external grounding affects architecture,
implementation, validation, review, release readiness, security, compliance, or
cost. The station records source tier, date or version, search scope, official
or primary evidence, unresolved conflicts, and missing evidence. It does not
edit source, decide release/completion readiness, or mutate external state.

The captain must not convert missing research into verified evidence. If the
external-research route is unavailable, record `未查`, `查不到`, `阻塞`,
`未驗證`, or `closed-with-director-risk` according to the completion gate.

## Completion Reporting Labels

Director-facing reports that depend on external grounding must use one of these
labels and explain the evidence in Traditional Chinese meaning-first prose.

| 標示 | 意義 |
|---|---|
| 已查 | Required official or primary sources were checked and support the claim. |
| 部分已查 | Some relevant sources were checked, but version, scope, access, or authority gaps remain. |
| 未查 | Grounding was required but not performed. |
| 查不到 | Search or source access was attempted, but no adequate evidence was found. |
| 不適用 | No external grounding was needed for the bounded conclusion. |
| 阻塞 | Required evidence is inaccessible due to permissions, credentials, service availability, legal/safety limits, or missing authorization. |

Use `已查` only for the exact claim and scope supported by evidence. A checked
adjacent source does not verify unsearched behavior, future releases, different
versions, or protected external state.

## Missing Evidence Rule

If required grounding is missing, incomplete, stale, or conflicted:

- state the missing evidence directly;
- avoid "verified", "confirmed", "current", "latest", "safe", or "supported"
  unless the evidence supports that exact claim;
- provide the smallest next evidence path when useful;
- keep implementation, validation, review, and completion states honest:
  `部分已查`, `未查`, `查不到`, `阻塞`, `未驗證`, or
  `closed-with-director-risk` are valid; silent verification is not.
