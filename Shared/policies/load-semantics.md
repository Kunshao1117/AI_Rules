# Load Semantics

This is the sole cross-platform owner of when governance and method content is
placed in an agent's context. It defines delivery, not authorization, role
identity, verification applicability, completion, or a second content registry.
Semantic type (Policy, Skill, Agent, Procedure, Reference) and platform file type
(AGENTS.md, CLAUDE.md, Rule, command, native Workflow, subagent file) are separate
from load mode. Memory and Project Context keep their frozen owners.

| Mode | Contract |
|---|---|
| `CORE_ALWAYS_ON` | Use only when content applies to nearly every task, omission risks a material governance error, the reminder stays very short, and reliable delayed loading is unsuitable. Carry a minimum boundary and owner pointer, not the full policy. |
| `SCOPED_CONDITIONAL` | Load for a relevant task, domain, file scope, or operation. Use only activation mechanisms the platform actually supports; a file-path glob cannot represent a tool call or a task intention. |
| `DISCOVERABLE_ON_DEMAND` | Expose concise name, purpose, and location at discovery; load the full body only when selected. This is typical for a Skill, including a platform Skill that merely transports a canonical Procedure. Do not preload sibling Skills. |
| `DELEGATED_ISOLATED` | Main sees a role's existence and purpose; load the full Agent contract for the assigned worker when delegated. A same-context reread is not independent review or verification. |
| `LAZY_REFERENCE` | Do not inject the full Reference at startup. Read it for needed detail, then keep its linked canonical owner authoritative. Procedures are normally task-selected and loaded on demand. |

A Policy may be core or scoped according to applicability; Policy does not mean
always-on. A Skill body is not startup context merely because its metadata is
discoverable. An Agent role is not a full Main-context preload. A Reference is
not converted into an always-on Rule by being linked from a platform core.

Platform bootstraps and generated summaries are derived delivery content. Each
summary must cite its Shared owner, stay minimal, and preserve that owner's
meaning. A platform may map paths, schema, native objects and supported
activation modes; it may not create a second governance decision. Within one
normal platform session, do not inject the same semantic topic in full through
multiple always-on surfaces without a concrete platform need. A short pointer
and an essential bootstrap reminder may coexist.

When a platform lacks conditional or isolated loading for a chosen route, report
the limitation and actual evidence; do not claim semantic equivalence or write
the limitation back as a Shared requirement. This contract adds no loader,
context score, registry, or runtime sync requirement.
