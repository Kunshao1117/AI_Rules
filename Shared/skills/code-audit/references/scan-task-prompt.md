# Scan Task Prompt

Detailed reference for the `code-audit` skill. Fill `{project_root}` and `{file_paths_list}` before use.

When building the prompt, use the `delegation-strategy` `references/cli-prompt-skeleton.md` skeleton and fill:
- **role_name**: `code quality and security scanner`
- **output_path**: `{agents_dir}/logs/scan_report.md`
- **task_description**: use the scan task block below

## Scan Task Block

```
### 1. ESLint code-quality scan, preferring the project's local tool
Prefer run_shell_command:
cd {project_root}; npx eslint --format json .
If ESLint is not installed in the project, use the MCP route:
Call eslint__lint-files through gateway__call_tool with these file paths:
{file_paths_list}
Report: total errors, total warnings, top 5 violated rules, and top 10 severe findings.

### 2. Snyk source security scan through MCP
Call snyk__snyk_code_scan through gateway__call_tool with path={project_root}.
Report: vulnerability counts by Critical / High / Medium / Low and the top 5 severe vulnerabilities.
> Degrade: if Snyk auth is unavailable (`snyk__snyk_auth` incomplete), skip this step and note "Snyk unauthenticated; skipped" in the report.

### 3. Snyk dependency vulnerability scan through MCP
Call snyk__snyk_sca_scan through gateway__call_tool with path={project_root}.
Report: total vulnerabilities and the top 5 severe dependency vulnerabilities.
> Degrade: if Snyk auth is unavailable, use `run_shell_command` to run `npm audit --json` or `yarn audit --json`, then summarize vulnerabilities in the same format.

### 4. TypeScript type check, only for TS projects
Run: cd {project_root}; npx tsc --noEmit
Report total errors and the top 10 errors.

### 5. Task marker count
Use grep_search to scan TODO / FIXME / HACK / XXX / TEMP markers.

### 6. Environment variable consistency
Read `.env.example`, search `process.env` references, and compare differences.


```

> **Tech Stack Adaptation**: Python projects use `pylint`, `mypy`, and `pip-audit` instead.
> **File List Construction**: The captain must build paths from tracked-file lists in all relevant memory cards.
