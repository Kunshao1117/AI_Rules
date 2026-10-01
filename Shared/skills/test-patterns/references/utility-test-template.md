# Value and Service Test Design Template

Use for selected utility/service behavior. Translate this language-neutral
outline to the project's existing runner and placement convention.

```text
arrange representative input and an independently derived expected outcome
act by executing the real function/service logic
assert the business result and only relevant observable effects
restore any test-owned state
```

| Candidate case | Useful assertion |
|---|---|
| Typical valid input | Exact transformation or relevant business invariant |
| Empty/min/max/single-item boundary | The specified boundary result; not arbitrary graceful handling |
| Invalid/null/malformed value | Contract-defined rejection, sentinel or error; no universal throw rule |
| Repeat operation | Idempotency only if that is the contract, not merely determinism |
| Side effect | Expected owned state change and absence of forbidden effects |

Use data-driven cases when they remain readable. Avoid coupling to private calls
or computing the expected value with the same algorithm being tested. A defect
in core logic should make a relevant assertion fail. Use controllable time or
external fakes only where useful; do not replace the function under test itself.
