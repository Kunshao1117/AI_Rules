# Grounding Governance Policy

This policy is the AI_Rules source of truth for external grounding, freshness checks, source ranking, and missing-evidence reporting.
Workflow entries, skills, matrices, and platform adapters must reference this policy.
They must not copy external-research rules into local playbooks.

## Source Of Truth And Precedence

- Framework source: `Shared/policies/grounding-governance.md`.
- Deployed runtime copy: `.agents/shared/policies/grounding-governance.md`.
- The source file is authoritative.
- The deployed copy must remain content-identical after any grounding-governance change.
- Machine-readable station fields and the detailed external-research request contract live in:
  - source: `Shared/policies/references/workflow-execution-spec-contract.md`;
  - deployed: `.agents/shared/policies/references/workflow-execution-spec-contract.md`.
- Local project files, lockfiles, and tool output govern the installed project state.
- Official or primary external sources govern current external facts.
- If this policy conflicts with a workflow-local checklist, keep this policy as the external-grounding source.
- Move task-specific procedure back to the workflow or skill.

## Mandatory Grounding Triggers

External grounding is required before giving advice, changing source, or claiming verification when the answer depends on:

- current or fast-changing facts;
- laws, prices, schedules, releases, APIs, platform rules, security advisories, product behavior, public figures, or service status;
- third-party documentation, dependencies, cloud platforms, packages, browser behavior, standards, or vendor policies;
- substantial cost, safety, legal, medical, financial, deployment, release, or security consequences;
- user requests to search, verify, check latest/current/today, cite sources, or use a named external source;
- named external pages, papers, datasets, repositories, issues, or documents;
- conflict between memory, model knowledge, local files, tool output, and external claims.

If grounding is required but unavailable, record `unverified`, `no-evidence`, or `blocked`.
It must not be reported as verified.

## No-Search Exceptions

External grounding may be skipped only when no current external fact is needed.
The decision must be fully supported by current conversation, provided snippets, local source files, or stable general knowledge.
Non-mutating local tool output can also support the no-search exception.

When skipping is material to the conclusion, record `external_grounding_state: not-required`.
Name the basis, for example local file evidence or stable language semantics.
Do not use this exception for dependency versions, service behavior, regulatory claims, pricing, schedules, or "latest" questions.

## AI Prior And Grounding Tiers

`AI prior` means model knowledge, memory, or unstated recall used only as a hypothesis starter.
It is not verified evidence.
It must not support words such as verified, current, latest, safe, supported, or complete unless another accepted source tier grounds the exact claim.

Use the lightest grounding tier that can support the decision:

| Tier | Label | Use boundary |
|---|---|---|
| `G0` | local-grounded | Current local source, lockfile, log, test, non-mutating tool output, or provided artifact supports the claim. |
| `G1` | stable model knowledge | Low-risk stable concept only; mark as assumption or general reasoning, not verified fact. |
| `G2` | quick-check | One to three official or primary sources, with `checked_at`, source tier, and a short evidence artifact. |
| `G3` | formal external research | Architecture, governance, security, deploy, pricing, law, standards, cross-source conflict, or other decision-impacting freshness risk; requires `external_research_artifact_id`. |
| `G4` | unverified/blocked | Required evidence cannot be checked, is inaccessible, conflicts, or remains stale but affects a decision. |

`G2` may be produced as a concise quick-check artifact by an external-research station or a tool-specific docs lookup that feeds external-research artifact semantics.
`G3` remains formal station-owned external research.
Other stations may consume the returned artifact ID and gaps, but they do not become owners of external evidence.

## Source Ranking

Use the strongest available source tier and label weaker evidence honestly.

Source tiers:

- 官方來源:
  - Sources: vendor docs, standards bodies, law/regulator pages, project release notes, and official repositories.
  - Use boundary: preferred for rules, APIs, versions, and supported behavior.
- 主要來源:
  - Sources: source code, lockfiles, changelogs, maintainer issue/PR threads, direct tool output, and observed runtime behavior.
  - Use boundary: preferred for local project state and concrete implementation evidence.
- 高可信二手來源:
  - Sources: reputable technical articles, security advisories, research summaries, and maintained compatibility tables.
  - Use boundary: use only when official/primary evidence is missing or incomplete.
  - Gap label: required.
- 低可信或社群來源:
  - Sources: forums, social posts, unofficial snippets, generated summaries, and mirrors.
  - Use boundary: use as leads only.
  - Verification boundary: do not claim verification from them alone.

Official and primary sources take precedence over summaries, memory, and model knowledge.
If sources disagree, report the conflict.
Use the evidence that best matches the local version, date, and authority.

## Local Version Versus Latest Documentation

Project-locked versions constrain implementation guidance.
Before applying current external documentation to a project, compare it with available local evidence.
Local evidence includes lockfiles, package manifests, framework config, API version pins, generated clients, or runtime tool output.

If latest documentation conflicts with the project-locked version:

- follow the local locked version for immediate code changes unless the task is explicitly an upgrade or migration;
- cite the current official documentation as migration or drift evidence;
- do not cite current documentation as proof that the installed project already supports it;
- mark unsupported or unconfirmed version behavior as `partial` or `unverified`;
- do not upgrade dependencies, regenerate clients, or change platform state without a separate scoped authorization gate.

## Team Mode Grounding Responsibilities

When Team mode is active, the captain coordinates routing, board/channel state, station artifact receipt, blockers, and synthesis.
Authorization binding stays with `authorization-resolution.md` and scoped Director evidence.
The captain may perform small coordination reads.
Broad external research is a formal station task.

Use an `external-research` station when external grounding affects these decisions:

- architecture;
- implementation;
- validation;
- review;
- release readiness;
- security;
- compliance;
- cost.

The station records source tier, date or version, search scope, official or primary evidence, conflicts, and missing evidence.
It does not edit source, decide release/completion readiness, or mutate external state.

When a downstream station needs external evidence, it records a narrow `external_research_question`.
That station records `blocked`, `partial`, or `unverified` until evidence returns.
Returned evidence must be an `external-research` artifact.
The only alternative is accepting the missing evidence as residual risk.
Other stations must not turn unperformed research into verified evidence.
Local files, lockfiles, generated clients, and tool output can satisfy local-state evidence.
Current outside facts still require the external-research route when they affect the conclusion.

The captain must not convert missing research into verified evidence.
If the external-research route is unavailable, record one of these canonical states according to the completion gate:

- `unverified`;
- `no-evidence`;
- `blocked`;
- `closed-with-director-risk`.

## Station External Grounding Fields

Formal station traces and `execution_spec` payloads use these canonical fields:

- `ai_prior`;
- `grounding_tier`;
- `grounding_mode`;
- `external_grounding_required`;
- `external_research_question`;
- `external_research_artifact_id`;
- `external_grounding_state`;
- `source_tier`;
- `source_date_or_version`;
- `checked_at`;
- `local_version_anchor`;
- `missing_external_evidence`.

`external_grounding_state` uses these machine states:

- `not-required`;
- `required`;
- `requested`;
- `sufficient`;
- `partial`;
- `no-evidence`;
- `conflicted`;
- `blocked`;
- `unverified`.

Only `sufficient` supports verified language for the exact scoped claim.
The following states must remain visible in downstream validation, review, release, security, and completion evidence:

- `partial`;
- `no-evidence`;
- `conflicted`;
- `blocked`;
- `unverified`.

`source_tier` uses these values:

- `official`;
- `primary`;
- `high-confidence-secondary`;
- `low-confidence-community`;
- `local-tool-output`;
- `not-applicable`;
- `unknown`.

`source_date_or_version` records the date, release, standard revision, API/package/local version, or `not-applicable`.
Detailed field semantics stay in the workflow execution spec reference.

## Evidence Budget And Closeout Bundle

Grounding work should match the decision risk.
Trivial local edits can close with `G0` or a clearly marked `G1` assumption when no external fact affects the result.
Implementation, validation, review, release, security, pricing, legal, deployment, or governance decisions that depend on current outside facts need `G2` or `G3`.

A `closeout_bundle` is only an index of returned artifacts, changed files, grounding tier, validation/review/memory-docs handoffs, sync evidence, expected dirty files, and residual risks.
It does not replace external-research artifacts, validation evidence, review evidence, memory/docs attribution, protected gates, or completion evidence.

## Completion Reporting Display Labels

Director-facing reports that depend on external grounding may render canonical English states with these display labels.
They must explain the evidence in Traditional Chinese meaning-first prose.
Display labels must not be written into machine trace, evidence, status, or completion fields.

| Canonical state | Director-facing display label | Meaning |
|---|---|---|
| `sufficient` | 已查 | Required official or primary sources were checked and support the claim. |
| `partial` | 部分已查 | Some relevant sources were checked, but version, scope, access, or authority gaps remain. |
| `unverified` | 未查 | Grounding was required but not performed. |
| `no-evidence` | 查不到 | Search or source access was attempted, but no adequate evidence was found. |
| `not-required` | 不適用 | No external grounding was needed for the bounded conclusion. |
| `blocked` | 阻塞 | Required evidence is inaccessible due to permissions, credentials, service availability, legal/safety limits, or missing authorization. |

Use `sufficient` only for the exact claim and scope supported by evidence.
A checked adjacent source does not verify unsearched behavior, future releases, different versions, or protected external state.

## Missing Evidence Rule

If required grounding is missing, incomplete, stale, or conflicted:

- state the missing evidence directly;
- avoid "verified", "confirmed", "current", "latest", "safe", or "supported";
- use those words only when evidence supports the exact claim;
- provide the smallest next evidence path when useful;
- keep implementation, validation, review, and completion states honest;
- use canonical English state values such as `partial`, `unverified`, `no-evidence`, `conflicted`, `blocked`, or `closed-with-director-risk`;
- render Director-facing labels through the display mapping above;
- do not use silent verification.
