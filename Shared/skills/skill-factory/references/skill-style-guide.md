# Skill Method Writing Guide

Write instructions that change the next task-relevant action: steps, bounded
choices, examples, gotchas and interpretation. Remove generic tutorial claims
such as "This skill teaches" and repeated background. Keep rationale where it
explains a consequential method choice; do not replace useful knowledge with slogans.

Follow `Shared/policies/language-governance.md`: Traditional Chinese task meaning
first in description, then Use when: and DO NOT use when: with Chinese meanings
before optional English precision. Internal method prose follows local convention.

Use guided recipes by default. Use imperative wording for actual method invariants
and decision tables only where they help interpretation. Style does not require
HALT blocks, override clauses, copied authorization gates or runtime-role machinery.
Never derive governance authority from a style label.

Keep purpose, triggers, core method and reference selection in SKILL.md. Put long
templates, syntax, stack-specific examples and checklists in references. Name
which question makes each reference worth reading; no preload-all directory rule.
Historical compatibility files are not active reference recipes.

`Shared/policies/source-document-size-governance.md` owns size/split limits.
Keep SKILL.md below 500 lines and the local estimate below 5,000 tokens (characters
divided by 3). Split by stable method responsibility; do not drop valuable content
merely to shorten the entry. Do not copy policy manuals into references either.
