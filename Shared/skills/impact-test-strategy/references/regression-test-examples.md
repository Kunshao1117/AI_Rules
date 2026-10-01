# Impact-to-Regression Examples

Use only to explain a selected regression candidate, not to mandate a permanent
test after every fix. Translate to the project's real runner when test design
is selected; do not prescribe TypeScript syntax or a registration step.

| Defect evidence | Candidate scenario and oracle |
|---|---|
| Validation bypass | Reuse the actual invalid input; assert the specified rejection before effects |
| Null reference | Reproduce the missing value; assert the accepted result/error, not merely no crash |
| Wrong status/result | Exercise the triggering identity/resource state and compare with the actual contract |
| Lost transformation | Follow producer-to-consumer serialization and assert meaningful field values, not only property presence |
| Race condition | Control conflicting order or concurrency; assert the intended winner, rejection or final consistency |
| UI state desync | Reproduce the relevant action sequence and inspect the state that previously diverged |

For a private helper with one known caller, inspect that boundary and the changed
behavior; do not expand based on file counts. For a shared response schema, trace
actual consumers and changed fields/defaults/error meanings. A contract used by
several packages may support broader evidence candidates, but verification-strategy
chooses scope. A large generated diff can have one bounded cause; a one-line
default change can affect many consumers. Keep evidence and uncertainty explicit.

No test registration, source repair, Memory lesson, role or completion follows
automatically from this map. Existing test-patterns methods can help only when
there is an actual test-design need; they are not a chained load.
