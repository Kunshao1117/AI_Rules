# Workflow Stage Procedures

This reference holds concrete workflow stage procedures that are too detailed
for platform workflow entries. Workflow entries stay thin: they route the task,
name the evidence-matrix row, load the shared policies, and point here only
when a concrete phase checklist is needed.

This file is not authorization. It does not replace Team-Native Core,
Authorization Resolution, the workflow evidence matrix, platform adapters,
team task boards, specialist role skills, delivery artifacts, memory gates,
validation, review, commit, release, deployment, install, or external mutation
gates.

Use the section matching the workflow route only. Do not copy these procedures
back into platform entries.

## Common Phase Rules

1. Bind the Director request to a current plan, station, file set, command, or
   protected phase before any write.
2. Read `workflow-orchestration.md`, `language-governance.md`, the workflow
   evidence matrix row, and the platform capability matrix before broad
   evidence or source-impacting work.
3. Use `formal-readonly` for evidence, research, impact mapping, validation
   planning, review evidence, memory/docs attribution, and broad reads.
4. Use `formal-write` only after a scope-bound intent signal is resolved
   through authorization resolution to the visible plan, file set, station,
   phase, expiry, and required protected gate.
5. Keep implementation, validation, review, memory/docs, and completion as
   separate delivery states. Missing states are blocked, unverified, or
   closed-with-director-risk, not complete.
6. When a source/deployed pair exists, record sync direction and parity
   evidence before any completion claim.

## 00 Chat

- Answer directly only when the response depends on current conversation,
  Director-provided snippets, or stable general reasoning.
- If the request needs files, screenshots, memory/context cards, rules,
  workflow evidence, tool output, or later governance decisions, promote to a
  `formal-readonly` evidence station.
- Route research, architecture, build, fix, test, commit, release, or write
  work to the matching workflow instead of expanding chat scope.
- Direct chat never writes files, memory, git, release state, deployment,
  installs, credentials, or external state.

## 01 Explore

- Define the research question, decision to support, freshness needs, and
  source quality bar.
- Prefer official, primary, or current sources when the result can influence
  architecture, implementation, governance, release, or spend.
- Return findings with source dates, confidence, bias or coverage gaps, and
  route recommendations.
- Route buildable architecture decisions to `02`, experiments to `03-1`, and
  implementation-ready work to `03` only after evidence is sufficient.

## 02 Blueprint

- Replay requirements, non-goals, constraints, assumptions, and acceptance
  criteria.
- Run neutral challenge against current files, tool output, memory/context, and
  official sources when relevant.
- Record architecture decisions, rejected alternatives, compatibility impact,
  and migration or rollback path.
- Produce a build handoff contract only when implementation boundaries,
  validation expectations, memory/docs impact, and unresolved risks are clear.

## 03-1 Experiment

- Declare sandbox scope, discard condition, promotion condition, and allowed
  shortcuts before writing.
- Keep experiment writes out of production quality claims.
- Mark skipped lint, tests, review, validation, and memory/docs as experiment
  dispositions.
- Promote to `03` only with a new production plan and a scope-bound intent
  signal resolved through authorization resolution.

## 03 Build

- If the Director asks for sandbox or quick prototype work, route to `03-1`
  before production build handling.
- Produce a design-to-build contract before writes: requirement trace, review
  state when required, architecture boundary, change intent, real validation
  path, file sets, memory/docs impact, and drift audit rule.
- After a scope-bound intent signal is resolved through authorization
  resolution, open implementation change delivery only for the named scope.
- Validation, review, memory/docs, and completion run after change delivery is
  returned, blocked, unverified, or risk-closed.

## 04 Fix

- Start with symptom, reproduction or observed failure, affected scope, and
  candidate root causes.
- Classify whether the work is emergency temporary fix, root-cause repair,
  local refinement, or structural refactor.
- Plan regression evidence before writes, including real-path validation when
  behavior depends on runtime state, external systems, persistence, UI, or
  operator-visible output.
- After a scope-bound intent signal is resolved through authorization
  resolution, repair only the named cause and route failed validation back to
  diagnosis or a new fix station.

## 05 Condense

- Separate stable source-backed facts from temporary observations, preferences,
  task evidence, and rejected ideas.
- Read the relevant memory/context inventory before proposing durable facts.
- Keep main cards small and archive or split when compaction thresholds are
  reached.
- Memory or context mutation requires the matching protected authorization.

## 06 Test

- Define the target surface, evidence level, environment, commands, browser or
  operator path, and expected pass/fail state.
- Use non-mutating validation by default.
- Distinguish unit, integration, regression, visual, performance, accessibility,
  real execution, blocked, and unverified evidence.
- Failed validation routes to fix, debug, build, or audit. The validation
  station does not repair the implementation it validates.

## 07 Debug

- Gather logs, traces, stack frames, commands, inputs, recent changes, and
  environment signals without mutating source.
- State hypotheses and disconfirming evidence.
- Stop when root cause, missing evidence, or a broader audit need is clear.
- Route confirmed repair to `04`, missing implementation to `03`, and systemic
  uncertainty to `08`.

## 08 Audit

- Run inventory before logic review, and logic review before final report.
- Define depth, project type, surface denominator, evidence sources, and known
  unavailable areas.
- Do not repair during audit. Findings route to build, fix, test, skill-forge,
  commit prep, or handoff.
- Report red/yellow/green only with evidence status and unresolved scope.

## 08-1 Infra Inventory

- Identify project type, runtime surfaces, commands, routes, files, workflows,
  memory/context cards, and external dependencies.
- Record denominator and skipped scope before any quality judgment.
- Return inventory evidence for `08-2` logic review.

## 08-2 Logic Review

- Review architecture, state/data flow, security, reliability, validation
  coverage, governance consistency, and evidence integrity using `08-1`
  inventory as input.
- Do not issue final audit conclusions before inventory gaps are visible.
- Route repairable findings to the right workflow with evidence status.

## 08-3 Audit Report

- Summarize inventory, logic findings, evidence status, blockers, unverified
  scope, recommended routes, and residual risk.
- Do not treat recommendations as write authorization.
- If commit or release readiness is requested, route to `09`.

## 09 Commit

- Scan dirty files, staged files, source/deployed parity, memory status,
  validation state, review state, and unresolved blockers.
- Commit, push, tag, release, deployment, and memory commit are separate
  protected phases with separate authorization.
- If preflight finds stale memory, missing validation, missing review, missing
  sync, or untracked required files, route back to the owner workflow.
- Do not hide blockers inside a commit summary.

## 10 Routine

- Stay read-only and automation-safe.
- Check drift, skill quality, workflow metadata, source/deployed consistency,
  memory health, MCP profile surfaces, and documented counts.
- Report exact findings and proposed routes. Do not apply fixes.
- Any write proposal routes to build, fix, audit, skill-forge, or commit prep
  and waits for a scope-bound intent signal resolved through authorization
  resolution.

## 11 Handoff

- Summarize current goal, changed or dirty files, evidence collected, blockers,
  unverified areas, memory/context state, validation/review state, and next
  route.
- Distinguish user-provided evidence from evidence verified in the current turn.
- Handoff does not mutate memory unless a separate memory workflow and
  authorization exists.

## 12 Skill Forge

- Decide whether the content belongs in core, shared policy, workflow entry,
  operational skill, reference file, memory, or project context.
- Keep trigger language in frontmatter description; put long examples,
  templates, and procedures in references.
- Validate naming, description specificity, boundary language, required
  metadata, and source/deployed sync.
- Skill source changes require memory/docs impact assessment before completion.
