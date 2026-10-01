# Diagnosis Task Prompt

Detailed reference for the `code-diagnosis` skill.

Use this block directly or with a genuinely separate bounded helper/context.
Bind symptoms, scope, context, expected evidence and stop condition; no generic
CLI worker or CLI skeleton is required. Provider selection follows
`Shared/policies/capability-resolution.md`. Report-file output, if needed, stays
within current authorization. Existing Memory reading instructions below remain unchanged.

## Diagnosis Task Block

Fill `{fault_symptoms}` and `{suspect_modules}` before use:

```
## Failure Symptoms
{fault_symptoms}

## Analysis Tasks
1. Read the memory modules above to understand architecture, tracked files, historical decisions, and known issues.
2. Read all tracked files for the relevant modules one by one.
3. Pay special attention to:
   - Data flow: trace the full path from input to output.
   - Error handling: check for missing try/catch blocks or unhandled boundary cases.
   - Type mismatches: verify function parameters and return values are consistent.
   - Module boundaries: verify imports and exports are correct.
   - State management: inspect async timing and race conditions.
4. Mark all suspect code areas, sorted from highest to lowest likelihood.
5. For each suspect area, include a concrete code snippet and reason for suspicion.
```

> **Scope Control**: When scope exceeds 30 files, the captain should narrow the request to only the most relevant memory modules.
