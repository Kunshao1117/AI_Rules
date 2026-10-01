# Tool Command Reference

Reference material for the `code-audit` skill.

Conditional recipes only. `Shared/policies/capability-resolution.md` owns
provider readiness and selection. Inspect current tool schemas and executable
resolution; these examples neither require a provider nor authorize setup.

## MCP Tools Through Gateway

When the selected provider uses Gateway, already visible discovery metadata only
describes schemas. Actual downstream execution uses the current Gateway entrypoint
and explicitly passes the current project `workspace`; starting a server is not passive discovery.
Do not claim a real call was completed by naming only the downstream tool from this table.

| Tool | Gateway Call | Purpose |
|------|-------------|---------|
| ESLint | `eslint__lint-files` | Code quality scan |
| Snyk SAST | `snyk__snyk_code_scan` | Source security scan |
| Snyk SCA | `snyk__snyk_sca_scan` | Dependency vulnerability scan |
| Snyk IaC | `snyk__snyk_iac_scan` | Infrastructure configuration scan |
| Snyk Container | `snyk__snyk_container_scan` | Container image scan |
| Supabase Advisors | `supabase__get_advisors` | Database performance advice |

## CLI Shell Commands

| Tech Stack | Type Check |
|------------|------------|
| Next.js / TypeScript | Existing project type-check script or resolved local `tsc --noEmit` |
| Python / Django | `mypy .` |
| Go | `go vet ./...` |

## Platform Tool Examples (resolve current schema)

| Tool | Purpose |
|------|---------|
| `grep_search` | Task marker counts and environment variable search |
| `read_file` | Read `.env.example` and config files |
| `write_file` | Write `scan_report.md` |

## Prerequisites

- Only the selected recipe needs its corresponding ready provider.
- Project declarations must be checked against the actual installed executable.
- Missing optional tools use a legal alternative or reported limitation; never install/login implicitly.
- External source/dependency scans require authorized data egress. No credential reads for discovery.
