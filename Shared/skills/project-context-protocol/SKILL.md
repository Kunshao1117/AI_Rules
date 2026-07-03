---
name: project-context-protocol
description: >
  [Infra] Project context protocol for design DNA, product preferences,
  technical preferences, communication preferences, acceptance preferences,
  CONTEXT.md card format, approval states, GO CONTEXT, and promotion to project skills.
  Use when: 專案脈絡、設計 DNA、產品偏好、技術偏好、溝通偏好、驗收偏好、CONTEXT.md、
  GO CONTEXT、GO DNA、候選偏好、已核准脈絡、脈絡卡巡檢、或將穩定脈絡升級為專案技能。
  DO NOT use when: 純原始碼記憶歸卡、一般 source staleness 修復、或一次性過程證據保存。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  memory_awareness: read
  tool_scope: ["filesystem:read"]
---

# Project Context Protocol — 專案脈絡協議

## Purpose

Project context stores long-lived preferences and product-facing direction that should not be mixed into source-code memory.

Use `.agents/context/` for:

- Design DNA and visual direction.
- Product behavior preferences.
- Technical preference defaults.
- Communication preferences.
- Acceptance and review preferences.

Do not use project context for source ownership, dependency staleness, implementation evidence, temporary task notes, or executable skills.

Do not write long-lived preferences, design DNA, acceptance defaults, or product direction into source memory. If a workflow discovers a reusable preference, report it as candidate project context and wait for `GO CONTEXT`; authorization resolution must still bind that token to the specific context card or scope before persistence.

## Layer Boundary

| Layer | Location | Purpose | Write Gate |
|---|---|---|---|
| Source memory | `.agents/memory/` | Source ownership, Current Truth, Active Constraints, Cycle Events, Archive Index, Relations, staleness | Scope-bound workflow intent after authorization resolution + memory protected gate |
| Project context | `.agents/context/` | Long-lived preferences, design DNA, acceptance defaults | `GO CONTEXT` after authorization resolution binds the context scope |
| Project skills | `.agents/project_skills/` | Reusable project-specific execution procedure | Skill-forge approval token after authorization resolution and matching protected gate |
| Process evidence | task report, screenshots, test output | Per-task proof and temporary observations | no persistence by default |

Project context cards use `CONTEXT.md`, not `SKILL.md`, so they are not executable skills.

## Card Format

Each context card lives under `.agents/context/{context-name}/CONTEXT.md`.

The default map card is `.agents/context/_map/CONTEXT.md`.

Required frontmatter fields:

- `name`
- `description`
- `context_type`
- `scope`
- `status`
- `confidence`
- `last_reviewed`
- `approval`
- `sources`

Allowed `status` values:

- `candidate`: can inform suggestions, but cannot be applied as a rule.
- `approved`: can be used as the default context for matching work.
- `deprecated`: no longer used.
- `conflict`: conflicts with another context and requires Director decision.
- `review`: old or possibly stale; use only with risk disclosure.

Required body sections:

- `## Approved Context`
- `## Candidate Context`
- `## Deprecated Context`
- `## Conflicts`
- `## Evidence`
- `## Relations`
- `## Promotion Notes`

Use `references/context-template.md` as the canonical starter.

## Read Priority

When a task has relevant context, apply the newest explicit instruction first:

1. Current Director instruction.
2. Module-level project context.
3. General project context.
4. Project-specific skills.
5. Shared skills.

If a candidate context conflicts with the current instruction, the current instruction wins and the context remains candidate.

## Write Approval

Do not permanently write or upgrade context without explicit scope-bound approval resolved against the target context card.

Accepted approval phrases:

- `GO CONTEXT`
- `GO DNA` for design DNA only; treat it as the same scope-bound context gate as `GO CONTEXT` internally.

These tokens are project-context approval signals only. They do not authorize memory, source, git, release, deploy, install, credential, external mutation, or unrelated context writes.

Without approval, completion reports may propose candidate context only. Candidate context must include evidence and the source task that produced it.

## Candidate Handling

Candidate context may be used to:

- Offer better options in a plan.
- Explain why a UI direction appears aligned or risky.
- Ask the Director for confirmation.

Candidate context must not be used to:

- Override explicit requirements.
- Block implementation.
- Become an acceptance standard.
- Auto-promote itself to `approved`.

## Promotion to Project Skill

Project context can become a project skill only when all conditions are true:

1. The context is stable across repeated tasks.
2. The Director has approved it.
3. It describes a repeatable procedure, not just a preference.
4. The skill forge workflow can express it as executable guidance with trigger conditions and negative boundaries.

Do not promote subjective style notes directly into project skills unless they affect repeatable implementation choices.

## Report Contract

When project context affects a task, report:

- Context cards read.
- Approved context adopted.
- Candidate context considered but not enforced.
- Conflicts or review-state risks.
- Any proposed candidate context and whether it needs `GO CONTEXT`.

## Constraints

- This skill does not authorize writes, installs, memory commits, commits, pushes, deployments, or mutating MCP calls.
- Project context does not participate in source memory staleness.
- Source memory cards must not store long-term preferences or aesthetic rules.
- Source memory quality fields may cite Director instructions as evidence only for source facts or active constraints; preference evidence still belongs in project context.
