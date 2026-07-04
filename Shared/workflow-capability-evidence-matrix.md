# Three-Platform Workflow Capability And Evidence Matrix

This file is the shared external-grounding specification for workflows 00-12.
It does not replace workflow bodies; each workflow references this matrix and
then applies its own task boundary, platform capability, and evidence state. 08
Audit depth, inventory denominators, and coverage rules remain owned by the
shared audit engine.

Workflow orchestration order is governed by `Shared/policies/workflow-orchestration.md`.
This matrix owns per-workflow evidence expectations; the orchestration policy
owns the shared route -> authorization -> operation_mode -> board -> dispatch
wave -> delivery artifact -> completion order. Concrete workflow cooperation
examples live in `Shared/policies/workflow-orchestration-scenarios.md`; those
examples are non-authorizing playbooks and must not replace this matrix or the
orchestration contract.

Language and audience-layer classification for workflow output, handoff text,
memory language, skill trigger language, and change descriptions is governed by
`Shared/policies/language-governance.md`; workflow rows cite that policy instead
of using platform core rules as the sole source.

External grounding for outside facts, source type, freshness sensitivity, and
no-evidence claim boundaries is governed by
`Shared/policies/grounding-governance.md`; this matrix records compact gate
profiles and workflow evidence expectations only.

## Reference Index

Long governance rules live in small references or their canonical policies. This
matrix keeps only route-level evidence expectations and the 00-12 workflow rows.

| Topic | Reference |
|---|---|
| Team-Native, board, delivery, closeout evidence | `Shared/policies/references/workflow-team-evidence.md` |
| Change intent, intent alignment, review lifecycle, visual evidence | `Shared/policies/references/workflow-review-visual-evidence.md` |
| Memory admission and MCP memory evidence | `Shared/policies/references/workflow-memory-evidence.md` |
| Route order, dispatch waves, invalid orchestration patterns | `Shared/policies/workflow-orchestration.md` and `Shared/policies/references/workflow-orchestration-boundaries.md` |

## Evidence Status

| Status | Meaning | Use boundary |
|---|---|---|
| sufficient | Official docs, current source, tool output, or real operation evidence supports the claim | Can support workflow judgment |
| partial | Reasonable evidence exists, but complete operation, version, permission, or environment confirmation is missing | May provide advice with gaps; must not claim high-risk verification is complete |
| unverified | A check is needed but current data or tool output is insufficient | Must name the gap and smallest evidence path |
| blocked | Credentials, authorization, login, external service, hardware, or high-risk approval is missing | Must not give a green light; list blocker conditions only |
| not-applicable | Project type or task intent does not need the check | Must include the basis for the decision |

`closed-with-director-risk` is a process closure state, not evidence status,
completion status, or full team completion. It only records Director risk
closure for a named gap; missing artifacts, independent review, validation,
Team-Native trace, or captain substitute authoring still cannot claim
`complete`.

## Gate Profile References

Gate details stay in their owning policies. Workflow rows below only name the
minimum evidence expected for each route.

- Director-facing output: `Shared/policies/language-governance.md`.
- External grounding: `Shared/policies/grounding-governance.md`.
- Formal orchestration and completion: `Shared/policies/workflow-orchestration.md`
  plus `team-completion-gate`.
- Platform capability translation: `Shared/platform-capability-matrix.md`.

## Team-Native Evidence Reference

Team-Native board, dispatch, delivery, lifecycle, direct-exception, late-result,
and closeout details are referenced instead of repeated here. Use
`Shared/policies/references/workflow-team-evidence.md` and the canonical
policies it cites. Workflow rows may mention Team mode as a minimum evidence
expectation only; they do not redefine Team-Native trace or completion rules.

Team-Native Core Evidence remains a thin route anchor: Team-Native trace evidence,
platform capability route, `conditional`, `unavailable`, daily/full
route chain, `operation_mode`, `board_template`, `board_state`,
`closeout_lane`, station set, `operation_mode_reason`, `role_id`,
`role_instance_id`, `exclusive_task_scope`, and no full-team completion claim
when required evidence is missing.

## Workflow Matrix

### Workflow Routing Is Not Authorization

Workflows 00-12 own task routing, evidence expectations, and next-workflow
suggestions only. Workflow names, commands, buttons, automation-safe triggers,
or consent phrases become usable authority only through
`Shared/policies/authorization-resolution.md`; they do not bypass board, role,
protected-state, review, validation, memory/docs, git, release, deployment,
install, or external-mutation gates.

## Team Governance Reference

Programming-team board, wave, reduction, delivery form, task-type dispatch, and
captain-boundary evidence live in
`Shared/policies/references/workflow-team-evidence.md`. This matrix keeps only
the per-workflow row expectations below; workflow names remain route hints and
do not authorize source writes or protected follow-on phases.

## Review And Visual Evidence Reference

Change intent, intent alignment, review lifecycle, and visual-evidence rules
live in `Shared/policies/references/workflow-review-visual-evidence.md`.
Workflow rows below cite those rules by task type and keep only their minimum
evidence expectations here.

## Workflow Evidence Rows

| Workflow | Task type | Grounding basis | Minimum evidence | Common route |
|---|---|---|---|---|
| 00 Chat | Pure discussion, concept clarification, and lightweight Q&A without external evidence dependency; files, screenshots, memory/context, rules, agent behavior, evidence checks, or governance impact route through normal workflows and use `formal-readonly` when a governed request activates Team mode | Codex instruction layers, Claude context management, Agent Skills trigger semantics, governed Team formal-readonly | Direct answers rely only on current conversation, supplied snippets, or stable general reasoning; active Team formal-readonly requires board, read scope, specialist evidence, citations, missing evidence list, evidence state, captain receipt, and board update | 01, 02, 03, 04, 06, 09 |
| 01 Explore | Web research, competitive analysis, feasibility, counter-position analysis | Research source quality, freshness, governed Team formal-readonly | Formal-readonly board, specialist handoff, source tier, date, bias, coverage gap, unverified items; if no specialist opens, record unavailable channel and direct exception | 02, 03, 08 |
| 02 Blueprint | Architecture, major technical direction, system blueprint | ADR, C4, arc42, official framework docs, intent-alignment gate, programming-team governance | Formal-readonly board, requirement replay, counter-evidence, decision state, alternatives, review purpose/state, requirement-to-acceptance trace, assumptions, compatibility, build handoff contract | 03, 08, 12 |
| 03-1 Experiment | Sandbox spike, disposable prototype | Technical spike practice, prototype isolation, governed experiment request triggers Team mode | Reduced/minimal experiment station/board with sandbox scope, allowed changes, discard condition, escalation condition, allowed shortcuts, experiment-only disposition; production promotion needs new authorization, `formal-write`, station-owned `change-delivery`, validation, review, memory/docs | 03, 11 |
| 03 Build | Formal build and product behavior change | Explore -> plan -> implement -> validate, intent-alignment gate, engineering review governance, programming-team governance | Team board, blueprint carryover, review purpose/state, requirement-to-task trace, task acceptance matrix, drift audit, real validation route, tool discovery, blockers, memory ownership/status evidence | 04, 06, 08, 09 |
| 04 Fix | Bug fix and regression repair | Root-cause analysis, defect management, regression testing, engineering review governance, programming-team governance | Team board, symptom, cause, review purpose/state, fix evidence, regression evidence, affected memory-card status and dependency evidence | 06, 07, 09 |
| 05 Condense | Project identity and long-term memory initialization | Context compression, long-term memory, preference governance | Source basis, separation of durable fact from temporary observation, workspace/context inventory evidence | 02, 11, 12 |
| 06 Test | E2E, visual, performance, accessibility, regression | Playwright, Lighthouse, Web Vitals, WCAG, programming-team governance | Test station board, project type, test surface, evidence level, blocker reason | 03, 04, 08 |
| 07 Debug | Stack trace, logs, fault localization | OpenTelemetry, SRE monitoring, root-cause diagnosis, programming-team governance | Debug station board, observable signal, hypothesis, confirmation/counter-evidence, route-to-fix condition | 04, 06, 08 |
| 08 Audit | Full-spectrum audit, deep audit, high-risk preflight | Shared audit engine, this matrix, OWASP, Playwright, Lighthouse, Web Vitals, WCAG, OpenTelemetry, engineering review governance, programming-team governance | Audit board, depth, project type, capability snapshot, feature/endpoint/command inventory, denominator, evidence artifacts, review state, memory/context governance evidence, lights, unverified/blocker list | 02, 03, 04, 06, 09 |
| 09 Commit | Change log, commit, version, pre-release scan | Conventional Commits, Keep a Changelog, SemVer, status checks, engineering review governance, programming-team governance | Commit board, explicit file list, review lifecycle risk, unverified/blocker list, memory status, memory preflight, change summary, version/artifact decision | 04, 06, 08, 11 |
| 10 Routine | Automation-safe read-only governance | Automation health check, workflow drift check, engineering review governance, programming-team governance coverage | Routine station coverage, skill quality, doc consistency, matrix coverage, review governance coverage, read-only memory/context inspection, no-write proof | 08, 12 |
| 11 Handoff | Task handoff and continuation prompt | Context handoff practice, programming-team governance | Handoff board, current status, dirty files, blockers, unverified items, workspace/memory health evidence, next workflow | 02, 03, 04, 09 |
| 12 Skill Forge | New skills, shared skills, project skills | Agent Skills spec, skill descriptions, progressive loading, programming-team governance, skill handoff package | Skill-forge board, layer choice, description quality, reference split, skill handoff package, validation gate, affected memory and skill-index evidence | 03, 08, 10 |

## Memory Evidence Reference

Memory admission and MCP memory evidence live in
`Shared/policies/references/workflow-memory-evidence.md`. This matrix does not
authorize memory mutation; memory writes and commits keep their separate
protected gates.

## Official References

| Topic | Source |
|---|---|
| Codex skills and instructions | https://developers.openai.com/codex/skills, https://developers.openai.com/codex/guides/agents-md |
| Claude workflows, subagents, permissions, hooks | https://code.claude.com/docs/en/best-practices, https://code.claude.com/docs/en/sub-agents, https://code.claude.com/docs/en/permissions, https://code.claude.com/docs/en/hooks |
| Antigravity browser evidence | https://antigravity.google/docs/browser |
| Agent Skills format | https://agentskills.io/specification |
| Architecture records and diagrams | https://adr.github.io/, https://c4model.com/, https://arc42.org/overview |
| Testing, performance, accessibility | https://playwright.dev/docs/best-practices, https://developer.chrome.com/docs/lighthouse/overview, https://web.dev/articles/vitals, https://www.w3.org/WAI/WCAG22/quickref/ |
| Security and reliability | https://owasp.org/www-project-application-security-verification-standard/, https://opentelemetry.io/docs/, https://sre.google/sre-book/monitoring-distributed-systems/ |
| Commit, changelog, versioning | https://www.conventionalcommits.org/en/v1.0.0/, https://keepachangelog.com/en/1.1.0/, https://semver.org/, https://docs.github.com/articles/about-status-checks |

## Usage Rules

- Workflow files must reference this matrix instead of copying every rule.
- Workflow names and platform workflow commands are route declarations only;
  scoped authorization must be bound by authorization resolution to an explicit
  visible plan, button prompt, permission prompt, command, file list, station,
  phase, expiry, or protected gate.
- Missing tools, missing credentials, or unsupported platform features must be
  reported as unverified or blocked, not treated as success.
- Platform adapters may add stronger evidence paths, but they must not weaken
  the minimum evidence contract.
- 08 remains the deep full-spectrum audit baseline; other workflows use only the
  row relevant to their lifecycle and do not copy 08 inventory machinery unless
  the audit workflow is active.
