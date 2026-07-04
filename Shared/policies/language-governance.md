# Language Governance Policy

This policy is the AI_Rules source of truth for language selection, audience
layer classification, exact-evidence preservation, and cross-platform language
references.

External grounding, freshness checks, source ranking, and missing-evidence
labels are governed by `Shared/policies/grounding-governance.md`. This policy
only governs how that evidence is expressed to each audience.

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
- External-grounding requirements, official-source precedence, local-version
  conflicts, and grounding completion labels belong in
  `Shared/policies/grounding-governance.md`; do not duplicate those rules here.
- If a task requires exact quoted evidence, command names, paths, code
  identifiers, API names, schema fields, or tool output, preserve the exact
  token text and explain it in Traditional Chinese when the explanation is
  Director-facing.

## Audience And Artifact Layers

| Layer | Applies To | Language Rule |
|---|---|---|
| Director-facing interface | Replies, status updates, plans, reviews, handoff reports, completion reports, risk explanations, and task summaries visible to the Director | Use Traditional Chinese (zh-TW). Start from plain-language business meaning. Put technical identifiers only where they add evidence, location, or precision. |
| Agent-internal instruction | Skill procedures, workflow steps, gates, metadata, schema fields, command examples, code identifiers, exact tool syntax, and policy/reference/matrix/skill bodies | Prefer concise English. Preserve existing project convention and exact source text. Do not translate identifiers, machine-readable fields, or audit tokens. |
| Bridge references | Skill descriptions, trigger text, memory summaries, project context summaries, shared governance references, and Director-visible templates | Use Chinese only where it helps Director-facing display, bridge labels, discovery snippets, examples, or explicit task requirements. Keep internal body text concise and English-led. |
| Source code and ecosystem artifacts | Source files, APIs, package metadata, generated code, tests, logs, and external documentation excerpts | Preserve local file convention, ecosystem convention, and exact external wording. Director-facing summaries around them remain Traditional Chinese. |
| Memory and project context | Source memory cards, project context cards, archive summaries, and memory delivery artifacts | Preserve required schema headings and exact fields. Keep durable source facts concise and stable; put Chinese summary text in designated Chinese-facing sections such as `## 中文摘要` when the schema provides them. |

## Internal Governance Source Language

- Internal governance source, policy, reference, matrix, and skill bodies prefer
  concise English to keep runtime context light.
- Chinese is reserved for Director-facing report/reply rules, display templates,
  bridge labels, human-facing examples, existing localized workflow names, or
  explicit task requirements.
- Do not add broad "Chinese meaning first" requirements to internal policy
  tables. Apply meaning-first Chinese only when text is Director-facing.
- Preserve exact audit patterns and canonical tokens in English, such as
  `no full-team completion claim`, the phrase "not as `complete`",
  `station_mode`, `role_id`, and file paths.
- Internal evidence and status state remains canonical English. Use
  `sufficient`, `partial`, `unverified`, `blocked`, and `not-applicable` for
  evidence status unless a narrower schema owns a different English value.
  Director display may render Chinese labels, but those labels must not be
  written back as internal state values.

## Director-Facing Report Rules

- Director-facing reports, replies, status updates, summaries, and handoff
  reports must begin with Traditional Chinese meaning. English, identifiers,
  paths, commands, schema fields, state values, and exact tool labels may appear
  only as supporting precision or evidence after the Chinese meaning is clear.
- Director-facing reports and replies must not be a raw list of file names,
  field names, function names, command parameters, internal tool names, or
  station artifact fields.
- When technical identifiers are necessary, introduce the business or governance
  meaning first, then include the exact identifier as supporting evidence,
  location, or precision.
- Raw machine field lists are not Director-readable explanations. For
  Director-facing field display, write the Traditional Chinese meaning first
  and keep the canonical identifier in parentheses, such as
  `任務板狀態（board_state）`; do not translate or rename canonical machine
  fields.
- Commands, paths, code identifiers, schema fields, and exact tool output remain
  exact when cited; add Traditional Chinese explanation around them instead of
  changing the token text.
- Change descriptions in plans, task summaries, and completion reports must
  name the functional or governance behavior first. A file path or code
  identifier alone is not an acceptable change description.
- Do not write in engineering shorthand and translate afterward. Design the
  Director-facing explanation in Traditional Chinese from the start.
- English-led summaries, column-list-led summaries, path-only summaries, or
  canonical-field-list summaries fail the Director-readable gate even when the
  facts are otherwise correct.

## Captain Integration And Director Output Gate

- Team-member delivery artifacts, board fields, trace fields, handoff packets,
  channel states, and specialist output templates are internal evidence
  artifacts. They are not Director-facing reports.
- Before any Director-facing status, plan, handoff, review, risk explanation,
  or completion report, the captain must synthesize received artifacts into
  Traditional Chinese meaning-first prose. Do not paste or lightly wrap internal
  artifacts, English field tables, English workflow phrases, or specialist raw
  output as the main body.
- Technical tokens may be preserved only as identifiers for paths, commands,
  schema fields, tool labels, state values, or exact evidence. Place them after
  the Traditional Chinese meaning, usually in parentheses or evidence
  references.
- Director-facing tables must use Traditional Chinese column labels as primary
  labels. If a canonical token is required, attach it after the Chinese label,
  such as `完成狀態（completion_state）`.
- If a Director-facing report or reply is English-led, led by station artifacts,
  led by canonical field lists, or lacks captain synthesis, it fails the
  Director-facing report gate and must be rewritten or reported as non-complete
  by the relevant completion gate.
- Team-member delivery must not be pasted as the Director-facing body. The
  captain must synthesize a Traditional Chinese meaning-first Director-facing
  report from the artifact's status, evidence, risk, and next-step conclusions
  while preserving exact tokens only where they are evidence. The internal
  artifact itself remains canonical English.
- The captain may translate, summarize, and synthesize team-member delivery but
  must not rewrite evidence source, role ownership, validation, review, risk, or
  state conclusions. If a station reports `partial`, `blocked`, `unverified`,
  `not-applicable`, or a source conflict, the Director-facing synthesis must
  preserve that canonical state and explain it in Traditional Chinese instead
  of upgrading it to verified language.
- A completion report is blocked when its main body is led by English prose,
  canonical field lists, raw station artifacts, or unsynthesized handoff/output
  templates. The report may include a compact evidence table only after the
  Chinese meaning summary.

## Director Body And Evidence Appendix Boundary

- Director-facing reports have a Chinese main body first: outcome, impact,
  evidence state, risk, and next action must be explained in Traditional
  Chinese before any internal schema appears.
- Internal board, trace, handoff, station, authorization, lifecycle, and
  delivery artifact fields are evidence payloads. They must stay in internal
  artifacts or appear only after the Chinese main body in a clearly labeled
  evidence appendix.
- The evidence appendix may preserve exact canonical tokens, state values,
  commands, paths, hashes, and tool output, but each table or list must use a
  Traditional Chinese label first and include canonical identifiers only as
  precision, such as `授權階段（authorization_phase）`.
- A report whose primary structure is the internal field template, raw artifact
  schema, English field sequence, or path-only list fails the Director output
  gate even if an evidence appendix is present.
- Completion, review, validation, memory/docs, and change-delivery skills may
  return raw artifact fields to the captain, but those fields are not the
  Director-facing body and must be synthesized before being shown to the
  Director.

## Director-Facing Planning Vocabulary

- Director-facing plans, blueprints, board reports, station reports, governance
  summaries, handoffs, completion summaries, and risk explanations must avoid
  Director-forbidden wording when describing read-only evidence handling or
  write phases.
- For read-only evidence handling, use the Chinese display words `統整`, `彙整`,
  `歸納`, or `收束` as context allows. They describe evidence processing only and
  do not imply source mutation.
- For formal write phases, use Chinese display words such as `套用`, `寫入`,
  `同步`, or `變更套用 gate` only when resolved scope, station ownership, file
  allowlist, authorization state, and validation route exist.
- Director-facing prose remains Chinese-first. English appears only as
  canonical identifiers, file names, command tokens, evidence excerpts, or exact
  platform/tool labels with Chinese explanation.
- If exact evidence contains Director-forbidden wording, prefer file/line
  evidence plus Chinese explanation, and do not repeat the term in
  Director-facing prose unless the Director explicitly requests an exact quote.

## Workflow And Skill Reference Rule

- Before a workflow or skill applies a language, audience-layer,
  memory-language, skill-description, trigger-language, handoff-language, or
  change-description rule, it must use this policy as the classification source.
- A workflow or skill may state a task-specific Traditional Chinese
  report/reply requirement, such as a handoff prompt or completion summary, only
  when the text is Director-facing.
- A workflow or skill must not copy a platform core language section as its
  only authority. Platform core files are adapter/bootstrap references; this
  policy is the shared source.
