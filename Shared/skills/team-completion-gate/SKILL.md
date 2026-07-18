---
name: team-completion-gate
description: >
  團隊收尾完成門檻（Infra）：Completion gate for captain-led team work. Use when: 收尾 build、
  fix、audit、workflow、skill、memory-docs、commit-prep 或 release-prep task；
  用於檢查 implementation change delivery、memory delivery、validation、review、
  sync, and residual-risk evidence are complete or honestly blocked; 完成門檻、完成交付件、記憶交付件、殘餘風險、
  最終證據。DO NOT use when: 執行實作、修補驗證、memory commit、git commit、push、tag、release、
  實作、修測試、提交或發布。
metadata:
  author: antigravity
  version: "1.1"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read", "terminal:read", "mcp:read"]
---

# Team Completion Gate

## Entry And Core Responsibility

Use this read-only gate to decide whether a captain-led task has enough
station-owned evidence for its selected closeout target. It consumes evidence;
it does not implement, validate, review, mutate memory, or perform protected
actions.

The gate has two responsibilities only:

1. Apply the hard closeout gate and canonical completion states.
2. Route detailed evidence and Director-facing closeout requirements to their
   canonical contracts.

Fields such as station_mode, context_visibility, and handoff_ownership are
closeout evidence only. Their canonical values remain in
Shared/skills/team-task-board/references/board-field-catalog.md.

`responsibility_review_disposition` and `responsibility_findings` are
independent-review delivery inputs. This gate only consumes them; it does not
count responsibilities, accept coupling, or author findings. The canonical
responsibility contract remains
Shared/policies/source-document-size-governance.md, and the detailed evidence
chain and closeout rendering remain in references/completion-evidence-contract.md.

## Hard Closeout Gate

Before any complete claim, confirm all of the following:

- The closeout target and completion state come from
  Shared/policies/references/completion-state-machine.md.
- The required station-owned artifact chain exists for that target. A
  captain-authored substitute never fills a missing station artifact.
- Required validation, independent review, memory/docs disposition, sync or
  parity, authorization, trace, lifecycle, grounding, responsibility, and
  residual-risk evidence are present, or their non-complete status is named.
- The Director-facing body is Traditional Chinese and meaning-first; raw
  fields, paths, and governance labels are supporting evidence rather than the
  opening conclusion.

A missing required artifact keeps the result blocked, unverified, or
closed-with-director-risk. It is not complete.

## Status And Protected Follow-up

Use only the canonical completion state set and transitions in
Shared/policies/references/completion-state-machine.md. Informal labels such
as done, source-level-ready, protected-follow-up-pending, or accepted-risk do
not replace that state.

Protected follow-up pending is a source-level disposition, not full
completion. It may be reported only when delivered source is otherwise
validated, independently reviewed, and synced, while an unrequested or
unauthorized protected phase names its owner and smallest next step. It blocks
process-complete and release-ready closeout.

## Reference Routes

Read the precise contract that matches the question:

| Need | Canonical route |
|---|---|
| Evidence inputs, artifact chain, checklist, grounding, responsibility, and size/split | references/completion-evidence-contract.md#evidence-chain-contract |
| Completion states, lanes, internal artifact schema, and forbidden actions | references/completion-evidence-contract.md#closeout-reporting-contract |
| Responsibility count, coupling, split gate, and review-field provenance | Shared/policies/source-document-size-governance.md |
| Team boundary, role separation, authorization, board, trace, and workflow ordering | References listed by the applicable section of completion-evidence-contract.md |
| Channel wait, probe, resume, replacement, cancellation, and late-return details | Shared/skills/team-station-handoff-packet/references/execution-lifecycle.md |
| Director-facing synthesis order | Shared/policies/language-governance.md, Captain Integration And Director Output Gate |

## Constraints

This skill is read-only. It must not repair evidence gaps, alter review or
validation results, mutate memory, call memory commit, or stage, commit, push,
tag, release, deploy, install, or hide missing authorization behind a
completion claim.
