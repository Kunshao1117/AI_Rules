# Task Capability Assessment Policy

This policy is the unique generic owner of task-specific model and task fit.
It applies to every repository without a repository-identity branch.

## Capability Labels And Fit

Platform capability labels `native`, `adapter`, `conditional`, `unavailable`,
`manual`, and `unknown` remain owned by
`Shared/platform-capability-matrix.md`. This policy does not infer them from a
model or vendor brand, memory, or a previous session.

`model_task_fit` is one of `sufficient`, `constrained`, `unavailable`, or
`unknown`.

## When Assessment Is Required

Create a `capability_assessment` only for systemic change, a protected action,
clear context shortage, a missing required repository/tool/test/browser/
external-grounding capability, an explicit model or effort request, or
requested/applied receipt variance. Do not require it for ordinary bounded
work outside those conditions.

## Capability Assessment

When required, `capability_assessment` uses these fields:

```text
capability_assessment: {
  model_task_fit,
  repository_read,
  repository_write,
  context_capacity,
  code_execution,
  test_execution,
  external_grounding,
  browser_or_multimodal,
  subagent_support,
  protected_action_support,
  applied_configuration_receipt
}
```

Each operational capability field uses the applicable platform label from the
platform-capability matrix. `model_task_fit` uses only the fit vocabulary
above. `applied_configuration_receipt` is an observed receipt reference or
`unknown`; without a receipt it is `unknown`, never applied.

Requested execution, accepted execution, and the applied execution receipt are
separate layers. Their execution-spec semantics remain in
`Shared/policies/references/workflow-execution-spec-contract.md`; their
accepted and observed ledger fields remain in
`Shared/skills/team-task-board/references/board-field-channel-and-receipts.md`.

## Degradation Order

When capability is constrained or unavailable, proceed in this order:

1. narrow `in_scope`;
2. lazy-load relevant material;
3. split systemic acceptance units;
4. use observable tools;
5. select delegated execution only with real coordination gain;
6. otherwise block or request a suitable capability.

## Boundary

This assessment cannot choose a model or vendor configuration, edit receipt
layers, enter a platform payload, auto-select Team execution, or grant
authorization or protected action. It reports task fit and capability gaps
only.
