---
name: ui-design-exploration
description: >
  [Quality] UI design exploration workflow for project-state discussion, UI skill
  discovery, web research, operator intent, component primitives, design directions,
  HTML demo or visual reference selection, design DNA, and project-derived skill preservation.
  Use when: 新專案 UI 討論、新增或重設 UI、介面風格不明確、需要搜尋 UI 設計技能、
  需要網路搜尋 UI 參考、需要三案比較、共用元件盤點、HTML 展示頁、設計 DNA 或專案衍生技能沉澱。
  DO NOT use when: 已有核准設計 DNA 且只是小型樣式修正、純後端任務、或總監明確要求直接照既有樣式改。
metadata:
  author: antigravity
  version: "1.0"
  origin: framework
  kind: operational
  style: hybrid
  memory_awareness: read
  tool_scope: ["filesystem:read", "filesystem:write", "web:search", "browser"]
---

# UI Design Exploration — UI 探索與設計 DNA 流程

## Trigger Conditions

Use this skill before UI implementation when any condition is true:

- The Director asks for a new page, new app surface, redesign, visual direction, UI template, HTML demo, or style exploration.
- The requested UI has no approved project design DNA.
- Existing UI quality is visually unsuitable and the desired direction is not fully specified.
- The task requires shared component decisions such as dropdowns, scroll behavior, tables, cards, forms, dialogs, toolbars, navigation, empty states, or loading states.

Do not use this skill for a tiny copy, spacing, color-token, or bug fix when approved DNA and component rules already exist.

## Procedure

### 0. Project State And Discussion Gate

```
[PROJECT STATE GATE]
├── New project, no existing UI, or no confirmed product direction?
│   └── Discuss product type, operator, platform, density, workflow, and constraints before reading DNA or components.
├── Existing project with approved DNA?
│   └── Read approved DNA first, then inspect current UI and component system.
├── Existing project without approved DNA?
│   └── Inspect current UI, then discuss whether the work establishes candidate DNA.
└── Narrow local edit?
    └── Preserve current DNA and component rules; skip full exploration unless Director asks.
```

Discussion for a new project must produce:

- product or service category
- target operator and audience
- primary workflow
- platform targets: mobile, desktop, web app, marketing site, extension, kiosk, or mixed
- expected information density
- style boundaries: avoid, prefer, must match, must not match
- initial component families likely needed

Do not read or enforce non-existent DNA. Do not inventory components before confirming that the project has components to inspect.

### 1. Context And Existing Surface

1. If approved project context exists, read `.agents/context/**/CONTEXT.md`.
2. If UI source exists, inspect it before proposing a direction:
   - shared components
   - layout primitives
   - design tokens
   - style utilities
   - page templates
   - current responsive and scroll patterns
3. If no UI source exists, define candidate component primitives instead of reporting reuse.
4. Classify every relevant component decision as reuse, extend, create, or establish.
5. Treat candidate context as advisory only; approved context is binding unless the Director explicitly asks for a redesign or override.

### 2. Operator Intent

Identify the operator, not only the screen type:

| Question | Required output |
| --- | --- |
| Who operates this UI? | End user, internal operator, admin, developer, buyer, visitor, or mixed audience |
| What task are they trying to finish? | Primary workflow and secondary workflow |
| How dense should the interface be? | Operational, editorial, marketing, creative, game, or utility |
| What information must stay visible? | Sticky controls, summary metrics, filters, current object, warnings |
| What failure states matter? | Empty, loading, error, disabled, offline, permission, overflow |

If the Director already gave enough need-level information, infer the likely UI category and continue. Do not ask for preference details that can be explored through examples.

### 3. Reference Source Gate

```
[REFERENCE SOURCE GATE]
├── New UI, redesign, ambiguous visual direction, or no approved DNA?
│   └── YES → Search for usable UI skills first, then search the web.
├── Existing approved DNA plus small local edit?
│   └── YES → Skill and web research optional; preserve existing DNA.
└── Network unavailable?
    └── State that references are unverified and stop at provisional directions.
```

Search in this order:

1. Available UI skills or design tools:
   - local skills already installed in the current session
   - project-specific skills under `.agents/project_skills/`
   - UI generation skills, design system skills, component library skills, HTML demo skills, browser testing skills, a11y skills, or prompt/process skills
   - external skill libraries or official tool guidance when the user asks for broader discovery
2. Product or domain examples: real apps, competitors, screenshots, app store images, SaaS surfaces, marketplace pages, admin tools, dashboards, or landing pages.
3. Design systems and platform norms: component guidance, accessibility notes, data visualization patterns, mobile conventions, or OS/platform expectations.
4. UI process references: design prompt patterns, AI UI generation workflows, component library examples, or design critique checklists.

Prefer a suitable skill or design tool over a static template when it provides a repeatable workflow, component logic, interaction rules, or validation procedure.

Convert references into constraints. Do not copy a site, visual asset, or generated skill output as-is.

When using a discovered skill, state:

- why it fits the UI task
- which parts become design process
- which parts become component or interaction constraints
- what must be downgraded to match the current project stack

### 4. Component Primitive Inventory

Before presenting directions, define the shared component scope:

| Primitive type | Examples |
| --- | --- |
| Controls | buttons, icon buttons, text fields, selects, dropdowns, toggles, checkboxes, sliders, tabs, segmented controls |
| Data and content | tables, lists, cards, detail panels, metrics, charts, timelines, media blocks |
| Layout | app shell, sidebar, top bar, split panes, drawers, modals, sheets, sticky regions, responsive grids |
| Feedback | loading, skeleton, empty state, error state, success state, warning state, toast, inline validation |
| Interaction | hover, focus, disabled, keyboard, scroll containers, overflow, pagination, sorting, filtering, drag or resize |

For each new or changed primitive, specify:

- visual role
- interaction role
- responsive behavior
- accessibility requirement
- reuse or extension decision

### 5. Direction Set

Present three distinct directions unless the Director already approved one:

| Direction field | Requirement |
| --- | --- |
| Intent | The operator problem this direction optimizes |
| Visual traits | Density, hierarchy, color role, shape language, typography rhythm |
| Component system | Reused, extended, new, and established primitives |
| Interaction model | Navigation, scroll, filtering, selection, editing, feedback |
| Responsive strategy | Mobile, tablet, desktop behavior |
| Reference source | Skill, design tool, product reference, design system, or mixed |
| Risk | What could make this direction unsuitable |

Directions must be visibly and structurally different. Do not present three color variants of the same layout.

### 6. Artifact Selection

Choose the artifact that best answers the design question:

```
[ARTIFACT GATE]
├── Need responsive, scroll, component behavior, or real layout proof?
│   └── Build an HTML demo or app slice.
├── Need early mood, brand feel, or static visual comparison?
│   └── Provide generated image, image reference, or template board as direction material.
├── Existing frontend stack is available and low-risk?
│   └── Build a small real component slice in the project stack.
└── No write approval?
    └── Provide a structured direction brief only.
```

Generated images, Stitch screens, and templates are references only. Final acceptance must use real rendered UI when implementation starts.

### 7. Approval And Preservation

After the Director selects or revises a direction:

1. Record the selected direction as a candidate design DNA.
2. Persist it only after explicit `GO CONTEXT` or `GO DNA`.
3. If the selected process is repeatable for the project, promote it through skill forge into `.agents/project_skills/`.
4. Future UI additions or edits must follow approved DNA and project-derived skills unless the Director explicitly asks for a redesign, refactor, or exception.

## Required Output

For UI exploration, report:

- project state: new, existing with DNA, existing without DNA, or narrow edit
- discussion outcome when the project is new or ambiguous
- UI skills or design tools considered
- research sources and extracted constraints
- operator intent summary
- existing component inventory
- three directions or the reason only one direction is valid
- component primitive decisions
- chosen artifact type
- persistence path: none, candidate DNA, approved DNA, or project-derived skill

## Constraints

- Do not invent a visual style only from model taste when web research is required.
- Do not require existing DNA or component inventory for a new project.
- Do not prefer static webpage templates over suitable UI skills or design tools when those skills can produce better repeatable process.
- Do not create a new component that duplicates an existing component without explaining why extension is insufficient.
- Do not persist design DNA or project-derived skills without explicit Director approval.
- Do not treat generated images as final implementation acceptance.
