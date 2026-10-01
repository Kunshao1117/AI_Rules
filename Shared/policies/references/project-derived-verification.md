# Project-Derived Verification Methods

This on-demand reference answers which project-native evidence routes exist for
an already selected verification need. `Shared/policies/verification-strategy.md`
alone owns evidence need, focused/broad scope and direct/independent judgment.
Review applicability and completion stay with their own policies. This is not
a universal audit Skill, provider engine, mandatory scan sequence or new registry.

## 1. Read relevant project evidence

Start at the affected project's actual root, including the relevant workspace
package. Read manifests, scripts, lockfiles, compiler/linter/test configuration,
repository scripts, Makefile and CI definitions before naming a verifier. In a
mixed repository inspect the affected package rather than assigning one global
toolchain. Manifest evidence identifies candidates, never installed/ready tools.

| Stack | Possible evidence paths (inspect only when relevant) |
|---|---|
| JavaScript/TypeScript | package.json; package-lock.json; yarn.lock; pnpm-lock.yaml; tsconfig*.json; eslint.config.*; .eslintrc* |
| Python | pyproject.toml; requirements*.txt; poetry.lock; uv.lock; pytest.ini; ruff.toml; .ruff.toml; mypy.ini |
| Rust | Cargo.toml; Cargo.lock; clippy.toml |
| Go | go.mod; go.sum; .golangci.* |
| .NET | *.sln; *.slnx; *.csproj; Directory.Build.props; .editorconfig |

These paths are clues, not required files or a language detector runtime. Inspect
actual contents: a type/compiler configuration, pytest/Ruff/mypy settings, Cargo
workspace, Go module or .NET project can explain an existing route. Repository
scripts and CI may be sufficient even without a listed manifest. Do not probe
all language versions, load tech-stack-protocol automatically or require Memory.

## 2. Prefer a fitting declared route

Prefer an existing project script/CI/Make target that covers the selected evidence
over rebuilding its underlying tool commands. Read its body, working directory,
package manager/lockfile convention, scope and side effects before executing.
For example, if an applicable package declares `verify` to run lint, compiler and
tests, use that entry through the project's actual package manager when that
coverage is needed. A focused UI-copy check does not automatically select it;
prefer an existing narrower route or sufficient direct evidence when appropriate.

Python CI may declare `python -m pytest`; Rust may use a Cargo workspace target;
Go may use `go test`; .NET may use `dotnet test`. These are conditional examples,
not fallback commands invented from a filename. If no script exists, inspect
actual tool config and resolve a compatible executable before deriving a bounded
command. Do not skip project setup/options to call a lower-level tool directly.

## 3. Refine candidates for the selected evidence

The following are relevance checks on candidates, not automatic verification
triggers. Apply the selected scope and acceptance from verification-strategy.

| Candidate evidence | Project/context fit |
|---|---|
| Compiler/type check | Relevant typed/compiled boundary and actual project compiler/type configuration; not TypeScript for every project |
| Lint/static analysis | Relevant source-quality question and an existing applicable linter/analyzer configuration |
| Tests | Existing project test route relevant to the acceptance; no compulsory full suite |
| Dependency/security audit | Dependency change, a security-sensitive package issue, explicit audit request, or selected release/security evidence need |
| Configuration consistency | Relevant configuration change/question; actual declarations/schema/settings/secret references compared with usage |
| TODO/FIXME/marker scan | Selected audit, release readiness, cleanup or explicit quality-scan question where markers supply useful evidence |

An ordinary source change or UI-copy fix does not automatically need dependency
audit or repository-wide marker counts. Security evidence depends on the actual
dependency system, stack, configured tools and threat context; npm audit is not
a universal security scan and does not decide whether a Security Reviewer exists.

## 4. Resolve readiness and effects separately

Use `Shared/policies/capability-resolution.md` for ready, present_unverified,
blocked or unavailable and provider selection. A dependency, script or config
declaration is not readiness evidence. Resolve only the needed executable/tool
and applicable version/configuration through authorized checks. Never use `npx`
or another downloading wrapper as a presence probe; do not install, log in,
read credentials or initiate external scans implicitly. Inspect scripts for
downloads, source writes, migrations, remote calls and other effects too.
Authorization and native permissions remain independent of project declaration.

If no verification setup is found, do not invent a toolchain or install one.
Use available direct source/behavior evidence where it proves the requested
claim; report necessary missing evidence as unverified or a stated limitation.
A missing optional provider may have a legal equivalent. Name the route actually
used; an alternative scan does not prove the unavailable scan ran.

## 5. Configuration and evidence interpretation

Discover the project's actual configuration/secret declaration mechanism: env
variables, settings files, typed settings objects, config schema or secret-manager
references. Compare declared/required keys with usage and relevant defaults;
check missing, misspelled or stale keys without exposing secret values. Node
`.env.example` versus `process.env` is one possible example, never a requirement
for Python, Go, Rust, .NET or projects using a different mechanism.

Report the inspected source/version, selected route and scope, readiness/effect
limits, command/tool actually used, observed errors/warnings and relevant rule or
vulnerability details with source locations. Distinguish not run, failed and
passed evidence; counts alone are not proof of correctness or completion. An
unreferenced config key or TODO is a finding to interpret, not automatically a
defect. Use a report file only when useful and authorized; no CLI author, fixed
filename, top-N quota, Memory-derived file list or schema is required.

Existing test-patterns, browser-testing and impact methods remain optional lazy
loads for an actual need, not a bundle. Existing scripts/config usually suffice:
do not automatically generate a project verification Skill. Consider one under
existing Skill governance only for stable, repeated, special procedures with
clear reusable value. No context or Memory persistence is introduced here.
