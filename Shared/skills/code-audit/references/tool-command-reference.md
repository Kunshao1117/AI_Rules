# Tool Command Reference

Reference material for the `code-audit` skill.

## MCP Tools Through Gateway

Gateway discovery tools only inspect schemas. Real downstream MCP execution must use `gateway__call_tool` and explicitly pass the current project `workspace`.
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
| Next.js / TypeScript | `npx tsc --noEmit` |
| Python / Django | `mypy .` |
| Go | `go vet ./...` |

## CLI Built-In Tools

| Tool | Purpose |
|------|---------|
| `grep_search` | Task marker counts and environment variable search |
| `read_file` | Read `.env.example` and config files |
| `write_file` | Write `scan_report.md` |

## Prerequisites

- `~/.gemini/settings.json` must configure `multi-mcp-gateway`.
- The project must have ESLint installed, with an `eslint` dependency in `package.json`.
- Snyk MCP auth must be complete through `snyk__snyk_auth`.
