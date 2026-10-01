---
name: stitch-design
description: >
  Google Stitch provider design methods. Use when: the user explicitly chooses Stitch for design directions, or a task explicitly concerns an existing Stitch project.
  DO NOT use when: ordinary UI bugs, new pages, redesign, generic design exploration or design-system discussion without a Stitch provider choice.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# Stitch Design Candidate Methods

Invocation classification: manual_only; provider-specific: yes.
external_ai_provider_coupling: yes
No automatic sibling loading: GitHub, UI workflow, Debug and Security are not
entry dependencies. Provider facts and effect distinctions are in
`Shared/policies/references/stitch-guide.md`. Ordinary design phase sequencing
belongs to `Shared/workflows/ui-design-exploration.md`, not this provider method.

## Prepare a bounded design request

1. Confirm explicit Stitch use, the requested outcome and existing project/screen
   identity. Existing project access does not authorize creation, edits or generation.
   Do not create an account/project as a presence check or default first step.
2. Prepare the business/user objective, target surface, constraints, relevant
   existing components and useful design references. Include concrete interaction
   and responsive needs, not only mood; distinguish fixed requirements from open
   visual choices. Keep provider context to the permitted task minimum.
3. Select only necessary text, image, code or design context. Never automatically
   upload a repository, secrets, private logs, unrelated user data or an entire
   Project Context. A design request does not authorize unrelated data sharing.
4. For requested exploration, describe differentiated directions (for example
   density, hierarchy or navigation), with the requested number and scope.
   An existing selected direction needs no artificial variant quota.

## Inspect, compare and iterate

For authorized generation/editing, keep the selected project, screen and intended
change explicit. The Stitch Agent can stream changes into a canvas; an intermediate
frame is not a completed result. After relevant external edits, refresh selected
project/screen state before comparing or applying a further edit.
On timeout, inspect existing task/project state rather than duplicate generation;
unknown completion stays unknown. Do not assume fixed latency or instant caching.

Compare candidates by requirement fit, hierarchy, interaction clarity, component
reuse, accessibility implications, implementation feasibility and product fit.
Preserve useful rationale and extract reusable decisions as candidates, not
approved context. Main and the user select through the existing UI workflow;
the provider's preferred result is not the final product decision.

## Translate candidates without promoting them

Every generated screen, variant, layout, design system, DESIGN.md and code/export
starts as a candidate. It is not approved DNA, an implementation acceptance
standard, verified UI, production code or final design merely because it exists.
Extract implementable constraints: density, color roles, typography, spacing,
shape, component behavior and responsive strategy. Map them to existing project
components; discard decorative or infeasible details instead of copying blindly.
Use real rendered UI evidence for implementation claims under the existing
verification owner; generated screenshots do not prove the product works.

DESIGN.md is a portable design-rules artifact, not Project Context approval.
An explicit request to import/apply it identifies proposed scope, not automatic
persistence authority. Keep the existing `GO CONTEXT` / `GO DNA` semantics solely
at `Shared/policies/project-context-protocol.md`; do not overwrite canonical
design rules or promote candidate context here. Main separately checks generated
code against repository conventions, target revision, scope and required evidence.

## Separate delivery effects

A bounded artifact download, share-link creation, Antigravity handoff and web /
Netlify publication have different destinations and effects. Design generation
does not authorize any of these automatically. Resolve the requested artifact,
destination, exposure and permitted action before performing that specific step.
Export to Antigravity is not proof that implementation, backend integration or
deployment has happened. A request for three directions may be satisfied by
those candidates; product UI implementation cannot be completed by designs alone.
`Shared/policies/completion-policy.md` owns completion judgment.

If Stitch is unavailable, ordinary UI work can continue with the existing design
workflow/project system and eligible tools. Do not silently replace explicitly
requested Stitch with another external AI, claim Stitch was used, or automatically
install, login, run OAuth or create a project. Report the provider-specific gap.
Memory and Project Context data stay untouched; no provider-state persistence.
