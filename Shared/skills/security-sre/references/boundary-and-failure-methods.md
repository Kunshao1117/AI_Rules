# Boundary and Failure Method Examples

Use these examples only after identifying the actual project mechanism.

| Project example | Runtime boundary method |
|---|---|
| TypeScript API | Existing runtime parser or schema validator; test malformed input, lengths, ranges and rejected unknown fields as the contract requires. Type assertions alone do not validate. Zod/Joi are optional examples. |
| Python API | Existing serializer, typed settings/parser or framework runtime validation; inspect coercion and rejection behavior. No JavaScript validator is required. |
| Rust service | Deserialize untrusted input and validate domain invariants before constructing trusted domain values; static types alone do not settle external-input semantics. |
| Go service | Decode into bounded structures, handle decode errors and validate domain constraints before mutation. |
| .NET API | Use the project's binding/validation pipeline or explicit runtime validator; verify authorization and validation precede relevant effects. |

For a create/update payload, ask whether required values, maximum sizes, enum
values and domain transitions are enforced at the relevant boundary. Do not
invent a replacement validator when the project already enforces the contract.

## Failure and secret analysis

Trace credential origin, application consumption, request construction and sinks.
Inspect references and redacted examples rather than fetching live values. Check
least-privilege scope, accidental serialization and logging of headers/payloads.
For external effects, distinguish safe retries from requests whose prior outcome
is unknown. Inspect idempotency keys, deduplication, reconciliation and recovery
only where they address an actual failure mode; never infer action authority.

## Observability without a fixed format

Start with the affected operation and failure interval. Follow the project's
correlation identifier or equivalent context across components. Inspect relevant
error/warning events, status and sanitized diagnostic detail, then compare with
nearby successful behavior. A text log with useful correlation can suffice;
structured event stores, metrics or traces may supply equivalent evidence.

If the existing system uses error/warn/info/debug, interpret error as failed work,
warn as abnormal conditions, info as useful lifecycle/business events and debug
as diagnostic detail subject to the project's production policy. These are
examples, not a required level catalog. Use the system's actual query syntax.
Do not claim a time-bounded query from a line count alone, require /logs/error.log,
impose JSON field names, or change logging infrastructure for a trivial task.
