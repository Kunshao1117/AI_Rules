# API and Contract Test Design Template

Use the actual project client/server/schema and existing test harness. Read
scripts/configuration directly; no Memory or Node runner prerequisite.

1. State the boundary: in-process handler, serialized request/response, middleware,
   actual service/store integration or consumer compatibility. Name bypassed layers.
2. Arrange the relevant identity, payload, resource and failure state using
   controlled fixtures or the authorized integration environment.
3. Send the operation through that boundary and assert the contract's response,
   required/optional fields, types, errors and relevant observable side effects.
4. Restore test-owned state even on failure without touching unrelated resources.

| Candidate scenario | Contract question |
|---|---|
| Valid request | Correct status/result, response shape and relevant state change? |
| Missing/invalid input | Is the actual validation contract enforced before effects? |
| Missing/expired identity | Is the operation rejected or handled as specified? |
| Insufficient permission | Is access denied without leaking protected data? |
| Missing resource/duplicate creation | Does the API preserve its declared semantics? |
| Dependency failure | Safe response and diagnostic behavior, no stack/query/secret leak? |
| Offline/timeout/corrupt response | Does the consumer reach its accepted failure/retry state? |

HTTP 200/201/400/401/403/404/409/500 are possible contract-specific examples,
not universal expected codes. Expired auth need not always redirect; forbidden
responses need not share one retry UI. Follow the product's real contract.
Compare consumer and producer fields, serialization, defaults and error shape.
A mocked repository tests its consumer assumptions, not real database behavior.
Do not require a mock when the selected claim is an authorized real integration.
