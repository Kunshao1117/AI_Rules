---
name: stitch-design
description: >
  介面設計產生與設計稿治理（MCP: stitch）：UI 設計產生、畫面變體、design spec 擷取、設計 DNA 與 generated-image downgrade；
  StitchMCP UI design workflow.
  Use when: 需要 generating/editing UI designs、variants、design spec extraction、
  generated-image downgrade、或 design DNA work。
  DO NOT use when: 任務不是 UI 設計工作，或程式碼實作不需要 design artifact。
metadata:
  author: antigravity
  version: "5.4"
  origin: framework
  kind: operational
  memory_awareness: none
  mcp_servers: [stitch]
  tool_scope: ["mcp:stitch"]
---

# Stitch Design

## HITL Boundary

- Read-only tools (`list`, `get`, `search`, `query`, status/health checks) may proceed silently.
- State-mutating, external-state, write, deploy, push, delete, reset, or resolve operations require a scope-bound intent signal from the Director; authorization resolution must bind it to the visible plan, command/tool, phase, expiry, and target external state before the matching protected gate can pass.
- `[MCP HITL GATE]` is an additional execution gate for MCP calls; it does not replace authorization resolution or authorize a separate protected phase.
- Discovery of tool schemas is not permission to execute mutating tools.

## Trigger Conditions

- 藍圖或建構流程（`/02_blueprint` 或 `/03_build`）期間需要 UI prototyping
- 設計轉程式流程（Design-to-code workflow）：擷取 frontend implementation 所需 design specs
- 為總監審閱產生 design variants

## Procedure

### Step 1: Project Management

1. Call `list_projects` to check existing Stitch projects
2. Call `create_project` with descriptive title if new project needed
3. Note the `projectId` for all subsequent operations

### Step 2: Screen Generation

1. Call `generate_screen_from_text` with **intent-driven prompt** (describe mood/brand, NOT pixels)
2. If `output_components` contains suggestions, present to Director for selection
3. Use `edit_screens` for iterative refinement
4. Use `generate_variants` for alternative explorations

### Step 3: Design System Management

Establish a unified visual language and apply it across all screens.

1. `list_design_systems` - Check existing design systems
2. `create_design_system` — Create new design system:
   - **Color Palette**: Choose preset or define custom primary color + saturation
   - **Typography**: Select font family (e.g., Inter, Roboto, Outfit)
   - **Shape**: Set corner roundness for UI elements
   - **Appearance**: Configure light/dark mode background colors
   - **Design MD**: Free-form design instructions in markdown
3. `update_design_system` — Immediately after creation to apply and display
4. `apply_design_system` — Apply to selected screens:
   - Pass list of screen IDs to apply the design system tokens
   - This modifies screen appearance to align with the design system

### Step 4: Design DNA Extraction

1. Call `get_screen` to retrieve full screen details (colors, typography, layout)
2. Document extracted design tokens as project reference
3. Feed design tokens into frontend implementation
4. Persist approved design DNA only through `project-context-protocol` after `GO CONTEXT` or `GO DNA`.

### Step 4.5: Reference Downgrade Gate

Generated screens and AI images are direction material, not implementation contracts.

1. Extract implementable constraints: density, hierarchy, color roles, type scale, spacing rhythm, shape language, component behavior, and responsive strategy.
2. Map constraints to existing project components before creating new components.
3. Discard purely decorative or impossible details that cannot be reproduced in the project's frontend stack.
4. Use real rendered screenshots, not generated images, as completion readiness evidence.

### Step 5: Sync Checkpoint

- After ANY modification in Stitch web UI, re-call `get_project` / `get_screen` to refresh context

## Constraints

- **Vibe Design**: Use business-level intent prompts, NOT pixel-level specifications
- **Sync Required**: Always re-read after external Stitch edits to avoid stale design data
- Generation can take a few minutes — DO NOT RETRY on timeout

## Done When

- Design screens generated and approved by Director
- Design tokens extracted and documented
- No stale design data in current context
