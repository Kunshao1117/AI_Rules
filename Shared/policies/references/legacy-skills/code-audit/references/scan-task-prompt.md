# Scan Task Prompt

Detailed reference for the `code-audit` skill. Fill `{project_root}` and `{file_paths_list}` before use.

Use this block directly or pass it to a genuinely separate bounded helper.
Provider selection belongs to `Shared/policies/capability-resolution.md`; no
generic CLI worker/skeleton is required. Bind target, scope, stop condition and
expected evidence. Write a report only when that output is in the authorized scope.
The following are conditional provider recipes, not universal prerequisites or
transport priorities; current callable schemas control actual tool names.

## Scan Task Block

```
### 1. Selected project quality scan
Inspect the project's scripts, executable resolution and package/bin metadata.
Use its existing selected verifier; do not use a package wrapper to discover it.
For a selected compatible ESLint integration, resolve the actual callable schema
and provide the approved file scope:
{file_paths_list}
Report: total errors, total warnings, top 5 violated rules, and top 10 severe findings.

### 2. Snyk source security scan, only when selected, ready and in scope
Resolve the current Snyk tool schema for path={project_root}; verify source data
egress is authorized before execution. Do not initiate login or read credentials.
Report: vulnerability counts by Critical / High / Medium / Low and the top 5 severe vulnerabilities.
> If authentication is known unavailable, consider an existing equivalent provider or report the gap; do not imply the scan ran.

### 3. Selected dependency vulnerability scan
Use the selected ready provider against path={project_root} within authorized data egress.
Report: total vulnerabilities and the top 5 severe dependency vulnerabilities.
> A project-native package audit may be an alternative when applicable and authorized; it does not prove the unavailable Snyk scan completed.

### 4. TypeScript type check, only for TS projects
Run the existing compatible project type-check script/executable from {project_root}; do not download a missing compiler.
Report total errors and the top 10 errors.

### 5. Task marker count
Use grep_search to scan TODO / FIXME / HACK / XXX / TEMP markers.

### 6. Environment variable consistency
Read `.env.example`, search `process.env` references, and compare differences.


```

> **Tech Stack Adaptation**: Select declared existing tools for the actual project; Python tools such as `pylint`, `mypy` and `pip-audit` are examples, not required installs.
> **File List Construction**: The captain must build paths from tracked-file lists in all relevant memory cards.
