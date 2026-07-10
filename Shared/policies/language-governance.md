# Language Governance Policy

This policy is the AI_Rules source of truth for language selection.
It also governs audience layer classification, exact-evidence preservation, and cross-platform language references.

External grounding, freshness checks, source ranking, and missing-evidence labels are governed by `Shared/policies/grounding-governance.md`.
This policy only governs how that evidence is expressed to each audience.

## Source Of Truth And Precedence

- Framework source: `Shared/policies/language-governance.md`.
- Deployed runtime copy: `.agents/shared/policies/language-governance.md`.
- The source file is authoritative.
- The deployed copy must remain content-identical after any language-governance change.
- Platform core files may keep platform bootstrap language requirements and Director-facing Traditional Chinese mandates.
- Complete language-layer classification belongs here.
- Workflow entries, operational skills, matrices, and platform adapters must reference this policy.
- They must not treat any platform core paragraph as the sole language source.
- External-grounding requirements belong in `Shared/policies/grounding-governance.md`.
- Official-source precedence, local-version conflicts, and grounding completion labels also belong there.
- Do not duplicate grounding rules here.
- If a task requires exact quoted evidence, preserve the exact token text.
- Exact tokens include command names, paths, code identifiers, API names, schema fields, and tool output.
- Explain exact tokens in Traditional Chinese when the explanation is Director-facing.

## Audience And Artifact Layers

### Director-Facing Interface

- Applies to: replies, status updates, plans, reviews, handoff reports, completion reports, risk explanations, and task summaries.
- Visibility: visible to the Director.
- Language rule: use Traditional Chinese (zh-TW).
- Director-facing 繁中（Traditional Chinese）output is meaning-first: write the plain 中文 meaning before technical identifiers.
- Start from plain-language business meaning.
- Put technical identifiers only where they add evidence, location, or precision.

### Agent-Internal Instruction

- Applies to: skill procedures, workflow steps, gates, metadata, schema fields, command examples, and code identifiers.
- Also applies to: exact tool syntax and policy/reference/matrix/skill bodies.
- Language rule: prefer concise English.
- Preserve existing project convention and exact source text.
- Do not translate identifiers, machine-readable fields, or audit tokens.

### Bridge References

- Applies to: skill descriptions, trigger text, memory summaries, project context summaries, and shared governance references.
- Also applies to: Director-visible templates.
- Language rule: use Chinese only where it helps Director-facing display or bridge labels.
- Chinese may also appear for discovery snippets, examples, or explicit task requirements.
- Keep internal body text concise and English-led.

### Source Code And Ecosystem Artifacts

- Applies to: source files, APIs, package metadata, generated code, tests, logs, and external documentation excerpts.
- Language rule: preserve local file convention, ecosystem convention, and exact external wording.
- Director-facing summaries around them remain Traditional Chinese.

### Hook, Test, And Resource Layers

- Hook payloads, hook event names, hook config keys, hook script identifiers,
  and hook output schema fields keep exact canonical tokens.
- Test names, assertions, command output, exit codes, fixture names, snapshots,
  selectors, and failure text keep exact local or ecosystem wording.
- Resource identifiers, MCP resource URIs, connector/tool names, file paths,
  hashes, versions, package names, and API identifiers keep exact source text.
- Director-facing explanations about hooks, tests, and resources must be
  Traditional Chinese meaning-first.
- Put exact hook/test/resource tokens after the Chinese meaning as evidence,
  location, command, field, or precision.
- Do not translate canonical hook events such as `SessionStart`, `PreToolUse`,
  or `Stop`.
- Do not write Chinese display labels back into hook payloads, test artifacts,
  resource identifiers, or machine-readable fields.
- Hook reminders and test/resource outputs are evidence or route context only.
  Director-facing reports must explain their practical meaning in Chinese
  before citing raw tokens.

### Memory And Project Context

- Applies to: source memory cards, project context cards, archive summaries, and memory delivery artifacts.
- Language rule: preserve required schema headings and exact fields.
- Keep durable source facts concise and stable.
- Put Chinese summary text in designated Chinese-facing sections such as `## 中文摘要` when the schema provides them.

## Internal Governance Source Language

- Internal governance source, policy, reference, matrix, and skill bodies prefer concise English.
- Concise English keeps runtime context light.
- Chinese is reserved for Director-facing report/reply rules, display templates, bridge labels, and human-facing examples.
- Chinese is also valid for existing localized workflow names or explicit task requirements.
- Do not add broad "Chinese meaning first" requirements to internal policy tables.
- Apply meaning-first Chinese only when text is Director-facing.
- Preserve exact audit patterns and canonical tokens in English.
- Examples include `no full-team completion claim`, the phrase "not as `complete`", `station_mode`, `role_id`, and file paths.
- Internal evidence and status state remains canonical English.
- Use `sufficient`, `partial`, `unverified`, `blocked`, and `not-applicable` for evidence status.
- A narrower schema may own a different English value.
- Director display may render Chinese labels.
- Director display labels must not be written back as internal state values.

## Director-Facing Report Rules

- Director-facing reports, replies, status updates, summaries, and handoff reports must begin with Traditional Chinese meaning.
- English, identifiers, paths, commands, schema fields, state values, and exact tool labels may appear only after the meaning is clear.
- Those technical tokens may appear only as supporting precision or evidence.
- Director-facing reports and replies must not be a raw list of file names.
- They also must not be raw field names, function names, command parameters, internal tool names, or station artifact fields.
- When technical identifiers are necessary, introduce the business or governance meaning first.
- Then include the exact identifier as supporting evidence, location, or precision.
- Raw machine field lists are not Director-readable explanations.
- For Director-facing field display, write the Traditional Chinese meaning first.
- Keep the canonical identifier in parentheses, such as `任務板狀態（board_state）`.
- Do not translate or rename canonical machine fields.
- Director-facing governance and process terms with stable Traditional Chinese
  translations must be introduced as `繁體中文(English)`, such as
  `任務板(board)`, `站點(station)`, `證據(evidence)`, and `驗證(validation)`.
- After the term is established in the same report or section, later uses may
  use Traditional Chinese alone if no precision is lost.
- Exact identifiers remain exact and must not be translated or written back as
  Chinese. Examples include `tokens`, `Codex`, paths, commands, schema keys,
  canonical field names, API names, package names, hook event names, status
  tokens, code identifiers, and exact evidence.
- If a term has no stable Traditional Chinese definition, or is a
  product/brand/exact technical token, preserve the source token and explain
  around it in Traditional Chinese.
- This is a Director-facing display rule only; it does not change internal
  state values.
- Raw board, handoff, channel, authorization, lifecycle, or station field lists must not be the Director-facing main body.
- Explain the route, ownership, risk, and next action in Traditional Chinese first.
- Place canonical fields only in an evidence appendix when needed.
- Report sequencing, synthesis readiness, and the evidence-appendix boundary are owned by `Captain Integration And Director Output Gate`.
- This section owns only Director-facing language and identifier presentation; it does not restate the full report order.
- Commands, paths, code identifiers, schema fields, and exact tool output remain exact when cited.
- Add Traditional Chinese explanation around exact tokens instead of changing them.
- Change descriptions in plans, task summaries, and completion reports must name the functional or governance behavior first.
- A file path or code identifier alone is not an acceptable change description.
- Do not write in engineering shorthand and translate afterward.
- Design the Director-facing explanation in Traditional Chinese from the start.
- English-led summaries fail the Director-readable gate even when the facts are otherwise correct.
- Column-list-led, path-only, or canonical-field-list summaries fail the same gate.

## Captain Integration And Director Output Gate

- This section is the sole owner of the complete Director-facing synthesis order and evidence-appendix boundary.
- Team-member delivery artifacts are internal evidence artifacts.
- Board fields, trace fields, handoff packets, channel states, and specialist output templates are also internal evidence artifacts.
- They are not Director-facing reports.
- Before any Director-facing status, plan, handoff, review, risk explanation, or completion report, the captain must synthesize.
- The synthesis must turn received artifacts into Traditional Chinese meaning-first prose.
- The required visible main-body order is: current conclusion/status -> next step -> authorization boundary -> evidence.
- First name the smallest next step that can move now, then name missing authorization or out-of-scope limits, and only then add evidence, paths, fields, hashes, or internal state.
- The visible main body must start with Traditional Chinese plain meaning about outcome, impact, risk, and next action.
- Internal fields, exact identifiers, paths, hashes, canonical states, and tool output may appear only as supporting precision after that explanation or in a clearly labeled evidence appendix.
- Each appendix table or list must use a Traditional Chinese label first; canonical identifiers may follow as precision, such as `授權階段（authorization_phase）`.
- Engineering labels such as `blocked`, `HALT`, `station_mode`, `authorization_phase`, or handoff IDs must not lead the report.
- Do not paste or lightly wrap internal artifacts as the main body.
- Do not paste or lightly wrap English field tables, English workflow phrases, or specialist raw output as the main body.
- Do not make self-correction or internal governance repair text the Director-facing main body.
- Forbidden examples include "I should have created a board" or "I am fixing my trace."
- State the practical route/state instead.
- The practical state includes what will be routed, what is blocked or unverified, what scope is authorized, and what remains separate.
- Technical tokens may be preserved only as identifiers for paths, commands, schema fields, tool labels, state values, or exact evidence.
- Place technical tokens after the Traditional Chinese meaning.
- Parentheses or evidence references are the usual placement.
- Director-facing tables must use Traditional Chinese column labels as primary labels.
- If a canonical token is required, attach it after the Chinese label, such as `完成狀態（completion_state）`.
- If a Director-facing report or reply is English-led, it fails the Director-facing report gate.
- A report also fails when it is led by station artifacts, canonical field lists, or lacks captain synthesis.
- A failed report must be rewritten or reported as non-complete by the relevant completion gate.
- Team-member delivery must not be pasted as the Director-facing body.
- The captain must synthesize a Traditional Chinese meaning-first Director-facing report from the artifact.
- The synthesis uses the artifact's status, evidence, risk, and next-step conclusions.
- Exact tokens remain only where they are evidence.
- The internal artifact itself remains canonical English.
- The captain may translate, summarize, and synthesize team-member delivery.
- The captain must not rewrite evidence source, role ownership, validation, review, risk, or state conclusions.
- If a station reports `partial`, `blocked`, `unverified`, `not-applicable`, or a source conflict, preserve that canonical state.
- Explain the preserved canonical state in Traditional Chinese.
- Do not upgrade the preserved state to verified language.
- A completion report is blocked when its main body is led by English prose or canonical field lists.
- It is also blocked when led by raw station artifacts or unsynthesized handoff/output templates.
- The report may include a compact evidence table only after the Chinese meaning summary.
- It names the practical governance behavior before naming files, fields, commands, hashes, or station artifacts.
- Missing evidence remains visible in Chinese and preserves the canonical state such as `blocked`, `unverified`, or `not-applicable`.
- The main body must not be a raw artifact template, raw field sequence, raw diff summary, compliance-only report, English-led station report, path-only list, or report that skips the next action.
- An unsynthesized internal artifact cannot support a Director-facing completion report.
- When the report body fails this threshold, the relevant completion gate must treat Director output as non-complete until the captain provides a Traditional Chinese meaning-first synthesis.
- This gate affects reporting readiness only; it does not alter source truth, validation results, review results, memory/docs disposition, or protected-action authorization.
- Completion, review, validation, memory/docs, and change-delivery skills may return raw artifact fields to the captain.
- Those fields are not the Director-facing body and must be synthesized before being shown to the Director.

## Director-Facing Planning Vocabulary

- Director-facing plans, blueprints, board reports, station reports, and governance summaries must avoid forbidden wording.
- Handoffs and completion summaries must also avoid forbidden wording.
- Risk explanations must also avoid forbidden wording.
- This applies when describing read-only evidence handling or write phases.
- For read-only evidence handling, use Chinese display words such as `統整`, `彙整`, `歸納`, or `收束` as context allows.
- These words describe evidence processing only.
- They do not imply source mutation.
- For formal write phases, use Chinese display words such as `套用`, `寫入`, `同步`, or `變更套用 gate` only when gates exist.
- Required gates include resolved scope, station ownership, file allowlist, authorization state, and validation route.
- Director-facing prose remains Chinese-first.
- English appears only as canonical identifiers, file names, command tokens, evidence excerpts, or exact platform/tool labels.
- English tokens need Chinese explanation.
- Planning report order follows `Captain Integration And Director Output Gate`; this section only governs planning vocabulary.
- If exact evidence contains Director-forbidden wording, prefer file/line evidence plus Chinese explanation.
- Do not repeat the term in Director-facing prose unless the Director explicitly requests an exact quote.

## Workflow And Skill Reference Rule

- Before a workflow or skill applies language rules, it must use this policy as the classification source.
- Covered rules include audience-layer, memory-language, skill-description, trigger-language, and handoff-language rules.
- Change-description rules are also covered.
- A workflow or skill may state a task-specific Traditional Chinese report/reply requirement only when the text is Director-facing.
- Examples include a handoff prompt or completion summary.
- A workflow or skill must not copy a platform core language section as its only authority.
- Platform core files are adapter/bootstrap references.
- This policy is the shared source.
