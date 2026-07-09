# Antigravity Gemini Edition v8.0.3

Antigravity Edition adapts AI_Rules to Gemini-oriented `.agents/` runtimes. It
installs rules, workflow entries, shared skills, and protected project knowledge
surfaces.

This README is an entry point only. Detailed governance remains in
`Shared/policies/`, `Shared/skills/`, and deployed `.agents/shared/` copies.

## Install Or Upgrade

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1'
$f = Join-Path $env:TEMP 'ag_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1'
$f = Join-Path $env:TEMP 'ag_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Mode Upgrade
Remove-Item $f
```

Use `-Target "D:\path\to\project"` for another project directory.

## Governed Authorization

The global bootstrapper only prompts for `GO INSTALL` or `GO UPGRADE`.
Those prompts authorize only the visible install or upgrade scope. They do not
authorize memory mutation, `memory_commit`, git, release, deployment, install
beyond the named framework action, credentials, destructive filesystem work, or
external mutation.

## Installed Surfaces

| Surface | Source | Runtime |
|---|---|---|
| Gemini entry | `Antigravity/.agents/rules/AGENTS.md` | `.agents/rules/AGENTS.md` |
| Rules | `Antigravity/.agents/rules/` | `.agents/rules/` |
| Workflow entries | `Antigravity/.agents/workflows/` | `.agents/workflows/` |
| Shared skills | `Shared/skills/` | `.agents/skills/` |
| Shared governance references | `Shared` allowlist + `Shared/policies/` + `Shared/mcp-profiles/` | `.agents/shared/` |
| Project tools | `Shared/project-tools/` | `.agents/tools/` |
| Context templates | `Shared/context/` | `.agents/context/` |
| Project memory | protected local project asset | `.agents/memory/` |
| Project context | protected local project asset | `.agents/context/` |
| Project skills | protected local project asset | `.agents/project_skills/` |

## Rule Navigation

| Need | Source |
|---|---|
| Antigravity platform entry | `Antigravity/.agents/rules/AGENTS.md` |
| Workflow route evidence | `Shared/workflow-capability-evidence-matrix.md` |
| Workflow sequence | `Shared/policies/workflow-orchestration.md` |
| Team-Native role and station governance | `Shared/policies/team-native-core.md` and `Shared/skills/team-*` |
| Subagent execution-channel mapping | `Shared/policies/subagent-invocation.md` |
| Completion targets and states | `Shared/policies/references/completion-state-machine.md` |
| Protected action catalog | `Shared/policies/references/protected-action-registry.md` |
| Memory write and commit procedure | `Shared/skills/memory-ops/SKILL.md` |
| Source/runtime parity | `Shared/policies/references/source-runtime-surface-map.md` |

## Workflow Entries

Antigravity workflow routes are `.agents/workflows/` entries:

`00_chat`, `01_explore`, `02_blueprint`, `03_build`,
`03-1_experiment`, `04_fix`, `05_condense`, `06_test`, `07_debug`,
`08_audit`, `09_commit`, `10_routine`, `11_handoff`, and
`12_skill_forge`.

Legacy split-stage files remain compatibility surfaces. They do not create new
public completion levels, authorization levels, or workflow meanings.

The route name routes work only. Authorization, Team-Native dispatch, protected
phases, validation, review, memory attribution, and closeout judgment come from
the shared sources above.

## Version Notes

`Antigravity/VERSION` is the source version. `.agents/VERSION` is the deployed
runtime marker. `.agents/memory/`, `.agents/context/`, and
`.agents/project_skills/` are protected during upgrade.
