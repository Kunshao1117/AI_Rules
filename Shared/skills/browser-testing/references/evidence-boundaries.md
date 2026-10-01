# Browser Evidence Interpretation

| Observed evidence | Supports | Does not establish alone |
|---|---|---|
| Screenshot | Visible state at capture time | Persistence, DB write, transaction success, backend correctness |
| DOM/accessibility tree snapshot | Exposed elements, names and state at observation | A completed interaction or durable side effect |
| Actual runtime interaction and observed result | Element behavior and the observed state transition | Unobserved backend/data-store behavior |
| Request and response observation | A request occurred and a response returned | Durable commit unless the contract and follow-up evidence establish it |
| Trace/console/log | Recorded events or diagnostic clues within its capture scope | Events outside that scope or correctness merely from no logged errors |

For a Save flow, a visible success notice proves the notice appeared. A captured
successful response adds transport/application evidence. If durable saving is
the claim, inspect the selected contract and relevant follow-up read/reload or
other available persistence evidence; a cached value may not settle that claim.

For a button visual bug, inspect the affected state and detail. Do not expand to
all pages, mobile viewports or all browser engines. For a dialog navigation bug,
record the actual open/action/close sequence and result. For a loading/error/empty
state, exercise that state when relevant rather than treating all states as a suite.
For a webview, use accepted panel widths, themes or font scaling only as relevant;
browser evidence cannot stand in for unrelated native desktop behavior.

If a route fails, inspect relevant scripts/docs/routes and present error evidence.
Separate wrong element, assertion mismatch, application failure, transient timing,
environment and provider failures. Equivalent requests/logs can support some
backend claims but do not prove a browser interaction occurred. Report a missing
required browser observation honestly instead of relabeling other evidence.
Keep artifacts bounded and redact account data, credentials and private payloads.
