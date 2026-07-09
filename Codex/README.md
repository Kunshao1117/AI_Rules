# Antigravity Codex Edition v0.1.3

Codex Edition adapts AI_Rules to OpenAI Codex. It installs `.codex/AGENTS.md`
as the project entry point and deploys workflow skills plus shared operational
skills into `.agents/skills/`.

This README is an entry point only. Internal governance remains in
`Shared/policies/`, `Shared/skills/`, and deployed `.agents/shared/` copies.

## Install Or Upgrade

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Codex/install.ps1'
$f = Join-Path $env:TEMP 'ag_codex_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Codex/install.ps1'
$f = Join-Path $env:TEMP 'ag_codex_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Mode Upgrade
Remove-Item $f
```

Use `-Target "D:\path\to\project"` for another project directory.

## Governed Authorization

The global Codex bootstrapper only prompts:

- Install: `GO INSTALL`
- Upgrade: `GO UPGRADE`

Those signals authorize only the named install or upgrade scope after the
visible prompt is bound to the current project. They do not authorize source
writes outside the installer, memory mutation, `memory_commit`, git, release,
deployment, credentials, destructive filesystem work, or external mutation.

## Installed Surfaces

| Surface | Source | Runtime |
|---|---|---|
| Codex entry | `Codex/.codex/AGENTS.md` | `.codex/AGENTS.md` |
| Codex config | `Codex/.codex/config.toml` | `.codex/config.toml` |
| Workflow skills | `Codex/.agents/workflow-skills/` | `.agents/skills/` |
| Shared skills | `Shared/skills/` | `.agents/skills/` |
| Shared governance references | `Shared` allowlist + `Shared/policies/` + `Shared/mcp-profiles/` | `.agents/shared/` |
| Project tools | `Shared/project-tools/` | `.agents/tools/` |
| Context templates | `Shared/context/` | `.agents/context/` |
| Project memory | protected local project asset | `.agents/memory/` |
| Project context | protected local project asset | `.agents/context/` |

## Rule Navigation

| Need | Source |
|---|---|
| Codex project governance entry | `Codex/.codex/AGENTS.md` |
| Workflow route evidence | `Shared/workflow-capability-evidence-matrix.md` |
| Workflow sequence | `Shared/policies/workflow-orchestration.md` |
| Team-Native role and station governance | `Shared/policies/team-native-core.md` and `Shared/skills/team-*` |
| Subagent execution-channel mapping | `Shared/policies/subagent-invocation.md` |
| Completion targets and states | `Shared/policies/references/completion-state-machine.md` |
| Protected action catalog | `Shared/policies/references/protected-action-registry.md` |
| Memory write and commit procedure | `Shared/skills/memory-ops/SKILL.md` |
| Source/runtime parity | `Shared/policies/references/source-runtime-surface-map.md` |

## Workflow Skills

Codex workflow routes are deployed as skills:

`00-chat-聊天`, `01-explore-探索`, `02-blueprint-架構`,
`03-build-建構`, `03-1-experiment-實驗`, `04-fix-修復`,
`05-condense-濃縮`, `06-test-測試`, `07-debug-除錯`,
`08-audit-健檢`, `08-1-infra-基礎盤點`, `08-2-logic-深度邏輯`,
`08-3-report-健檢總結`, `09-commit-紀錄總結`, `10-routine-巡檢`,
`11-handoff-交接`, and `12-skill-forge-技能鍛造`.

The route names are triggers only. Authorization, Team-Native dispatch,
protected phases, validation, review, memory attribution, and closeout judgment
come from the shared sources above.

## Version Notes

`Codex/VERSION` is the source version. `.codex/VERSION` is the deployed runtime
version marker. The `PROJECT IDENTITY` section in `.codex/AGENTS.md` is
preserved during upgrade.
