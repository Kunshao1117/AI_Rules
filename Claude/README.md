# Antigravity Claude Code Edition v1.2.3

Claude Edition adapts AI_Rules to Claude Code. It installs a modular
`.claude/` runtime, Slash Command workflow entries, and shared skills.

This README is an entry point only. Governance manuals and state machines stay
in `Shared/policies/`, `Shared/skills/`, and deployed `.agents/shared/` copies.

## Install Or Upgrade

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1'
$f = Join-Path $env:TEMP 'cc_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1'
$f = Join-Path $env:TEMP 'cc_install.ps1'
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
Those prompts are scoped to the visible install or upgrade action. They do not
authorize memory mutation, `memory_commit`, git, release, deployment, install
beyond the named framework action, credentials, destructive filesystem work, or
external mutation.

## Installed Surfaces

| Surface | Source | Runtime |
|---|---|---|
| Claude entry | `Claude/.claude/CLAUDE.md` | `.claude/CLAUDE.md` |
| Claude rules | `Claude/.claude/rules/` | `.claude/rules/` |
| Slash commands | `Claude/.claude/commands/` | `.claude/commands/` |
| Shared skills | `Shared/skills/` | `.claude/skills/` |
| Shared governance references | `Shared` allowlist + `Shared/policies/` + `Shared/mcp-profiles/` | `.agents/shared/` |
| Project tools | `Shared/project-tools/` | `.agents/tools/` |
| Context templates | `Shared/context/` | `.agents/context/` |
| Project memory | protected local project asset | `.agents/memory/` |
| Project context | protected local project asset | `.agents/context/` |

## Rule Navigation

| Need | Source |
|---|---|
| Claude platform entry | `Claude/.claude/CLAUDE.md` |
| Workflow route evidence | `Shared/workflow-capability-evidence-matrix.md` |
| Workflow sequence | `Shared/policies/workflow-orchestration.md` |
| Team-Native role and station governance | `Shared/policies/team-native-core.md` and `Shared/skills/team-*` |
| Subagent execution-channel mapping | `Shared/policies/subagent-invocation.md` |
| Completion targets and states | `Shared/policies/references/completion-state-machine.md` |
| Protected action catalog | `Shared/policies/references/protected-action-registry.md` |
| Memory write and commit procedure | `Shared/skills/memory-ops/SKILL.md` |
| Source/runtime parity | `Shared/policies/references/source-runtime-surface-map.md` |

## Workflow Commands

Claude workflow routes are Slash Commands:

`/00_chat`, `/01_explore`, `/02_blueprint`, `/03_build`,
`/03-1_experiment`, `/04_fix`, `/05_condense`, `/06_test`,
`/07_debug`, `/09_commit`, `/10_routine`, `/11_handoff`,
and `/12_skill_forge`.

The command name routes work only. Authorization, Team-Native dispatch,
protected phases, validation, review, memory attribution, and closeout judgment
come from the shared sources above.

## Version Notes

`Claude/VERSION` is the source version. `.claude/VERSION` is the deployed
runtime marker when present. `.agents/memory/`, `.agents/context/`, and
project skills are protected during upgrade.
