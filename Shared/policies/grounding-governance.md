# Grounding Governance Policy


## General verification/review/completion ownership

General verification scope/independence, evidence selection and failure
classification belong only to `Shared/policies/verification-strategy.md`.
Review applicability and judgment belong to `Shared/policies/review-governance.md`;
general task completion belongs to `Shared/policies/completion-policy.md`.
These policies supersede old escalation, review-trigger and completion clauses
in this method/consumer. No Skill hit requires a role, full suite or Memory chain.
Task methods remain here; frozen Memory/legacy release retain their own contracts.

## General Agent applicability

`Shared/policies/agent-governance.md` and `Shared/agents/_registry.md` own
general Team assignments. Main is the ordinary implementer. In this mixed
domain reference, every station, fixed roster, board, handoff, delivery-slice,
dispatch-wave, retained-member, timing or execution-spec lifecycle prescription
is legacy compatibility-only, not required for general vNext work, including
Team. Read those prescriptions only for a frozen consumer that requires them.
Domain procedures, grounding/evidence quality and protected gates remain.
General Verification/Review/Completion now use their canonical policy owners;
frozen Memory semantics remain in force. Old completion targets, status ladders
and fixed evidence chains below are compatibility-only for frozen consumers.
No vNext assignment is a substitute for a Memory bundle or receipt.

This policy is the AI_Rules owner of general factual-judgment grounding:
whether evidence supports a factual claim, how strong that claim may be, and
how to handle missing or conflicting evidence. It also owns external grounding,
freshness checks, contextual source preference, and missing-evidence reporting.
It does not select verification scope, method or independence
(`verification-strategy.md`), define requirements (`requirement-precision.md`),
authorize actions (`authorization-resolution.md`), decide task completion
(`completion-policy.md`), or own Director-facing wording
(`language-governance.md`).
Workflow entries, skills, matrices, and platform adapters must reference this policy.
They must not copy external-research rules into local playbooks.

`memory-governance.md` applies this source-freshness boundary to Memory Impact
Review: its conclusion identifies current relevant source evidence and card
version/scope. A later change that may affect a reviewed claim, owner, tracking
relationship or valid scope requires reassessment of that conclusion. Review
and Verification retain their independent freshness owners.

## General Factual Judgment Boundary

- A user sets the goal and may constrain scope, tools, browsing, login, external
  access, and evidence sources. Those constraints limit what can be established;
  they do not change what the available evidence means. If required evidence is
  excluded or unavailable, lower the conclusion's strength and name the gap.
  Do not fill it with model recall and call the result confirmed.
- Model-internal knowledge can explain stable concepts, help understand a
  request, form hypotheses, and plan a search. It is not, by itself, evidence
  of current external, project-specific, version-specific, runtime, deployed,
  security-sensitive, or other verifiable factual state. Ordinary conceptual
  explanations need no external search when no current factual claim depends
  on one. Model knowledge is not proof.
- A canonical governance source establishes the applicable specification:
  what should be done. Whether an action happened or a system currently
  conforms is an empirical question requiring current evidence. A policy that
  requires authorization for a push does not prove that no push occurred.
- Source labels alone do not confer empirical truth. Memory, project context,
  database records, README/docs, policies, tool output, logs, tests, Agent or
  Reviewer/Verifier reports, user statements, prior AI answers, and external
  documents may supply relevant context or evidence; assess what each actually
  observed and can support. Memory can point to source-backed knowledge, but
  does not override newer or more direct current evidence merely because a
  card says `Current Truth`. Check its scope, date, environment, staleness, and
  whether referenced source was deployed. This does not alter Memory contracts.
- A user's direct account can establish their stated goal or reported
  experience; it is not automatically proof of a separate external or deployed
  state. A database row such as `status = completed` establishes what that
  database currently records, not that the underlying work satisfies
  `completion-policy.md`. A test supports only the behavior, environment, and
  conditions it actually covered; verification selection stays with
  `verification-strategy.md`.
- Judge a factual source for directness, recency, applicable scope, and
  verifiability for the exact question. If credible evidence conflicts, check
  whether time, environment, scope, or version explains the difference; seek
  the smallest more direct, current, repeatable check when permitted. Revise
  the conclusion if resolved; otherwise preserve the conflict or uncertainty.
  Do not select a convenient side merely to provide one answer.
- Earlier assistant conclusions, summaries, recommendations, and Agent reports
  are revisable when better relevant evidence arrives, even if repeated or
  previously accepted. Correctness takes priority over consistency; do not
  reopen unrelated history during ordinary work.
- Hypotheses, scenarios, proposals, and requested advocacy may adopt stated
  assumptions or a viewpoint, but those do not become verified facts in a
  later report. User-defined acceptance may establish that the user's named
  threshold was met; it does not erase underlying factual failures or replace
  the completion owner's judgment.
- Neutral judgment neither agrees with nor opposes the user by default. Match
  conclusion strength to evidence. For consequential decisions, contested
  claims, or high uncertainty, consider contradictory evidence and alternative
  explanations; do not impose a Team, Reviewer, or red-team step on every
  ordinary task.

## Source Of Truth And Precedence

- Framework source: `Shared/policies/grounding-governance.md`.
- Deployed runtime copy: `.agents/shared/policies/grounding-governance.md`.
- The source file is authoritative.
- After an authorized runtime sync or deployment, the deployed copy must match
  the authoritative source. A source-only change does not itself update runtime.
- Machine-readable station fields and the detailed external-research request contract live in:
  - source: `Shared/policies/references/workflow-execution-spec-contract.md`;
  - deployed: `.agents/shared/policies/references/workflow-execution-spec-contract.md`.
- Local project files, lockfiles, and tool output are evidence candidates for
  the installed project state within their observed scope.
- Official or primary external sources are preferred evidence candidates for
  current external facts within their applicable date, version, and scope.
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
The decision must be fully supported by current conversation, provided snippets, local source files, or stable general knowledge for the exact claim each can support.
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
| `G3` | formal external research | Architecture, governance, security, deploy, pricing, law, standards, cross-source conflict, or other decision-impacting freshness risk; record dated sources, conflicts and evidence limits. Legacy Team traces retain `external_research_artifact_id` where their contract requires it. |
| `G4` | unverified/blocked | Required evidence cannot be checked, is inaccessible, conflicts, or remains stale but affects a decision. |

`G2` may be a concise check by Main, a bounded helper, an assigned Researcher,
or a fitting documentation tool. `G3` requires a sufficiently attributable
research result, not a Team or station. Main may gather it directly; a formal
Researcher is assigned only when execution and Agent governance justify that
separation. Legacy Team consumers retain their existing station artifact ID
and handoff contract; another station's use of that artifact does not make it
the external-grounding owner.

## Source Ranking

Use the most relevant, sufficiently strong available evidence for the exact
question and label weaker evidence honestly. Source tiers guide external
research; they are not a universal ranking or numerical score of empirical
truth. Directness, recency, scope, and verifiability may make local version or
observed runtime evidence more probative for an installed environment than
newer general documentation.

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

For matching external rules, APIs, and versions, prefer applicable official or
primary sources over summaries, memory, and model knowledge. This preference
does not prove a different environment's current behavior.
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

## General research ownership

Main may obtain external facts directly in any mode. A bounded research helper
is Assisted; a separately responsible Researcher uses the formal role when Team
is justified. Evidence tier and freshness never require a station or provider.
Researcher supplies current facts and checked-at sources, not final architecture
ownership. Existing source ranking and missing-evidence rules below still apply.

## Legacy Team Mode Grounding Responsibilities

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
