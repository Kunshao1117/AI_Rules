---
name: excel-ops
description: >
  Workbook-specific spreadsheet methods. Use when: explicitly editing or inspecting workbook formulas, worksheet/range identity, tables, charts or pivots that require workbook semantics.
  DO NOT use when: CSV-only work, generic DataFrame analysis, generic tables, text reports or conversion without workbook semantics.
metadata:
  author: antigravity
  version: "6.0"
  origin: framework
  kind: operational
  memory_awareness: none
---

# Workbook and Worksheet Methods

Invocation classification: restricted; provider-specific: no.
Provider identity: provider_unspecified / capability-derived. The legacy `excel`
label and recipe names do not establish a concrete implementation or version.
No automatic sibling loading.

## Capabilities and ownership

Describe needs such as workbook_read, workbook_write, formula_inspection and
range_update; these are capability descriptions, not invented executable tools.
`Shared/policies/capability-resolution.md` selects an existing suitable provider.
Do not require Graph, openpyxl or MCP. Confirm the actual provider can preserve
needed formulas, formatting, pivots and workbook features before using it.
When unavailable or insufficient, use another authorized suitable capability or
report the specific limitation. Do not automatically install libraries/integrations,
configure Graph/MCP, connect an account or access credentials.
`Shared/policies/authorization-resolution.md` owns actual read/write and protected
operation authority; this Skill adds no Excel-specific authorization gate.

## Before any write

1. Confirm target workbook identity (resolved path for a local file, stable resource
   identity for a remote workbook), existing/new status and requested result.
2. Inspect the target worksheet, exact range/table and current contents. Check
   headers, table boundaries, blank rows, merged cells, hidden rows/columns/sheets
   and protected structures when they can affect the operation. A valid address
   alone does not prove it is the intended sheet or range.
3. Distinguish read, append, update cells, replace range, replace worksheet,
   create worksheet, delete worksheet and overwrite workbook. Determine collision
   and overwrite effects before mutation; unknown target/effect stops the write.
4. Bind formula preservation versus intentional value replacement and whether
   formatting is in scope. Inspect formula references/dependents and the provider's
   feature/recalculation limits; do not silently flatten formulas or lose features.
   For destructive replacement, identify recoverable original data and the exact
   affected area before proceeding under the canonical authorization boundary.

## Bounded workbook recipes

- **Populate a report:** establish destination and headers before creation/write;
  for a 2D table, a header at A1 implies data starts at A2 only when that matches
  the inspected layout. Append after the actual table boundary, not merely the
  first blank cell. Preserve surrounding formulas and styles; format only in scope.
- **Formula edit:** inspect formula versus stored/cached value; validate syntax,
  target range and relative/absolute references before applying. For example,
  `=SUM(B2:B100)` must match the intended table. Copy formulas only after checking
  how references shift. A stored formula or cached value does not prove recalculation.
- **Chart:** confirm populated source range, headers, data types and labels; choose
  the chart type for the question (for example bar versus scatter). Place it in
  an agreed location; creating another worksheet is a distinct operation.
- **Pivot:** use a flat source table with explicit headers; inspect blanks/types,
  select row/column/value fields and aggregation (sum/count/average). Confirm
  provider support, source boundaries and refresh behavior; do not silently
  substitute a static value table for a requested working pivot.
- **Worksheet management:** create/rename/copy/delete and merge/unmerge are distinct
  operations, not a cleanup chain. Check references and data loss before rename,
  delete or merge; a temporary-looking sheet is not permission to delete it.

## Check the result

Read back the intended sheet/range and compare intended changes with surrounding
cells, formulas, formatting and dependent chart/pivot structure as relevant.
Verify append did not replace existing rows and a replacement stayed in its target.
Report what was actually written, calculated and checked separately; disclose
unsupported features or stale cached results. Method checks supply evidence to
`Shared/policies/verification-strategy.md`; it owns scope and independence.
`review-governance.md` and `completion-policy.md` own review and completion.
Execution, Agent/model decisions and Memory lifecycle remain with
`execution-routing.md`, `agent-governance.md`, `model-profile-routing.md` and frozen
Memory contracts. Do not persist provider readiness, credentials or workbook data
in Memory / Project Context as a side effect of this method.
