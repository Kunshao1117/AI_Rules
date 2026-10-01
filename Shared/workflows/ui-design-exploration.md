# UI Design Exploration Workflow

This workflow arranges design phases for a requested new UI, redesign or open
visual direction. A narrow edit covered by existing DNA/components need not run
full exploration. It does not select execution mode, authorization, review,
verification or completion; those remain with their canonical policies.

## 1. Establish project state and operator intent

For a new/no-UI project, discuss product category, operator, primary workflow,
platform, information density, constraints and initial component families before
looking for DNA or components. For existing approved DNA, read it before current
UI inspection. Without approved DNA, inspect the existing surface before forming
candidate direction. Preserve existing rules for a narrow local edit.

Identify the actual operator, task, must-visible information and failure states.
Use enough supplied need-level information to continue; do not demand preferences
that a small example can help reveal. Context precedence and candidate handling
come from `Shared/policies/project-context-protocol.md`.

## 2. Gather and interpret references

Consider available project/local design methods and tools, domain examples,
design systems and platform conventions. External discovery follows grounding,
capability and authorization policies; no implicit install is allowed. Explain
why a reference fits and extract constraints rather than copying its output.
When evidence is unavailable, label provisional direction and the evidence gap.

## 3. Decide primitives and compare directions

Inspect existing components, layout primitives, tokens, style utilities, page
templates and responsive/scroll patterns. For a new UI, establish candidate
controls, data/content, layout, feedback and interaction primitives instead.
For each, describe visual/interaction role, adaptation, applicable accessibility
and the reuse/extension decision.

When direction is open, compare distinct density, hierarchy, color roles,
typography, component systems, navigation and feedback approaches. Three visibly
different directions are useful when requested or needed for comparison; an
already approved direction does not require artificial alternatives. Include
reference basis, adaptation strategy and suitability risks.

## 4. Select a bounded artifact

Use an app slice/HTML demo for layout or interaction questions and visual
references for early mood or brand comparison. Prefer a small real component
slice when the project stack is available. The existing authorization owner
determines which writing/execution actions may proceed; a brief remains useful
when implementation is outside scope. Generated images are direction material.
Browser and visual evidence methods follow verification-strategy's selected scope.

## 5. Return direction and candidate DNA

Report project state, discussion, references, operator intent, primitive
decisions, direction choice, artifact and unresolved evidence. Selection alone
does not persist or approve context. Apply project-context-protocol's unchanged
GO CONTEXT / GO DNA rules and skill-forge rules for any later promotion.
Review applicability and completion truth remain with review-governance and
completion-policy. UI examples are in `Shared/policies/references/ui-ux-methods.md`.
