# Language Governance Policy

This policy is the AI_Rules source of truth for language selection, audience
layer classification, exact-evidence preservation, and cross-platform language
references.

## Source Of Truth And Precedence

- Framework source: `Shared/policies/language-governance.md`.
- Deployed runtime copy: `.agents/shared/policies/language-governance.md`.
- The source file is authoritative. The deployed copy must remain
  content-identical after any language-governance change.
- Platform core files may keep platform bootstrap language requirements and
  Director-facing Traditional Chinese mandates, but complete language-layer
  classification belongs here.
- Workflow entries, operational skills, matrices, and platform adapters must
  reference this policy instead of treating any platform core paragraph as the
  sole language source.
- If a task requires exact quoted evidence, command names, paths, code
  identifiers, API names, schema fields, or tool output, preserve the exact
  token text and explain it in Traditional Chinese when the explanation is
  Director-facing.

## Audience And Artifact Layers

| Layer | Applies To | Language Rule |
|---|---|---|
| Director-facing interface | Conversation, status, plans, reviews, handoffs, completion reports, risk explanations, and task summaries visible to the Director | Use Traditional Chinese (zh-TW). Start from plain-language business meaning. Put technical identifiers only where they add evidence, location, or precision. |
| Agent-internal instruction | Skill procedures, workflow steps, gates, metadata, schema fields, command examples, code identifiers, and exact tool syntax | Use English technical terms, existing project convention, or exact source text. Do not translate identifiers or machine-readable fields. |
| Bridge references | Skill descriptions, trigger text, memory summaries, project context summaries, and shared governance references | Use bilingual structure when discovery or human review benefits from it: stable English identifiers plus Traditional Chinese descriptions, triggers, or summaries. |
| Source code and ecosystem artifacts | Source files, APIs, package metadata, generated code, tests, logs, and external documentation excerpts | Preserve local file convention, ecosystem convention, and exact external wording. Director-facing summaries around them remain Traditional Chinese. |
| Memory and project context | Source memory cards, project context cards, archive summaries, and memory delivery artifacts | Preserve required schema headings and exact fields. Keep durable source facts concise and stable; put Chinese summary text in designated Chinese-facing sections such as `## 中文摘要` when the schema provides them. |

## Director-Facing Text Rules

- Director-facing output must not be a raw list of file names, field names,
  function names, command parameters, or internal tool names.
- When technical identifiers are necessary, introduce the business or governance
  meaning first, then include the exact identifier as supporting evidence,
  location, or precision.
- Change descriptions in plans, task summaries, and completion reports must
  name the functional or governance behavior first. A file path or code
  identifier alone is not an acceptable change description.
- Do not write in engineering shorthand and translate afterward. Design the
  Director-facing explanation in Traditional Chinese from the start.

## Workflow And Skill Reference Rule

- Before a workflow or skill applies a language, output-layer, memory-language,
  skill-description, trigger-language, handoff-language, or change-description
  rule, it must use this policy as the classification source.
- A workflow or skill may state a task-specific Traditional Chinese output
  requirement, such as a handoff prompt or completion summary, when that output
  is Director-facing.
- A workflow or skill must not copy a platform core language section as its
  only authority. Platform core files are adapter/bootstrap references; this
  policy is the shared source.
