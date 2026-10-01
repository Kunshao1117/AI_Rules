# Discovery Evidence Examples

| Scoped project | Start with | If additional evidence is needed |
|---|---|---|
| Python package | pyproject/requirements/lockfile and relevant source/CI | Inspect declared versus resolved Python/package constraints; only a needed Python executable/configuration is a readiness candidate. |
| TypeScript package | package scripts, lockfile, tsconfig and imports | Inspect the package manager/runtime used by that package; no Rust/Go inventory. |
| Mixed monorepo | Affected package plus relevant root/workspace constraints | Follow shared dependencies only when they affect this package; do not flatten different runtimes into one global stack. |
| No manifest | Relevant source imports, build scripts, configuration and repository documentation | Record inferred versus verified facts; expand the search only to resolve the actual question. |

If a manifest range, lockfile and CI disagree, identify which artifact describes
the intended target and which describes the current build. Do not overwrite one
to make discovery appear consistent. A lockfile can prove a resolved version but
not that its binary is installed in this session. A binary found on PATH can be
unrelated to the target environment; keep its location/configuration/time scoped.

For a supported older framework version, use its compatible APIs. State a latest
documentation mismatch without turning it into an upgrade request. Consult
official migration notes only for the actual proposed version transition.
For MCP/provider configuration, inspect only a relevant declared integration;
configuration presence is neither tool readiness nor permission to connect,
install, authenticate or alter global/project settings.
