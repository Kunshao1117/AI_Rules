# AI_Rules Governance Suite

AI_Rules is the source repository for the Antigravity governance framework across
Antigravity/Gemini, Claude Code, and OpenAI Codex.

This README is an entry point only. It keeps installation, upgrade, version, and
navigation information. Governance contracts, workflow sequences, protected
actions, Team-Native roles, memory write/commit rules, and source/runtime sync
rules live in the source files listed below.

## Install Or Upgrade

Run the command for the platform you want to install into the current project.
PowerShell 5.1+ and PowerShell 7 are supported.

### Antigravity / Gemini

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

### Claude Code

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

### OpenAI Codex

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

Use `-Target "D:\path\to\project"` to install or upgrade another directory.

## Governed Bootstrap Prompts

Global bootstrappers do not install automatically.

- Install prompt: `此專案尚未安裝 Antigravity Codex Edition。若要安裝，請輸入 GO INSTALL。`
- Upgrade prompt: `即將升級 Antigravity Codex Edition。若要繼續，請輸入 GO UPGRADE。`

These prompts are authorization checkpoints only. They do not authorize memory
writes, git, release, deployment, install beyond the named framework action,
credentials, destructive filesystem operations, or external mutation.

## Platform Entries

| Platform | Source entry | Runtime surface | Version |
|---|---|---|---|
| Antigravity / Gemini | `Antigravity/README.md` | `.agents/` | v8.0.3 |
| Claude Code | `Claude/README.md` | `.claude/` plus shared `.agents/` | v1.2.3 |
| OpenAI Codex | `Codex/README.md` | `.codex/` plus shared `.agents/` | v0.1.3 |

All three platforms share `Shared/skills/`, `.agents/memory/`, and
`.agents/context/`. Memory and context are protected project assets during
upgrade.

## Where Rules Live

| Need | Authoritative source |
|---|---|
| Team-Native role model, captain limits, and station-first work | `Shared/policies/team-native-core.md` |
| Subagent and platform execution-channel governance | `Shared/policies/subagent-invocation.md` |
| Task trace fields and invalid trace patterns | `Shared/policies/team-trace-evidence.md` |
| Workflow sequence and dispatch order | `Shared/policies/workflow-orchestration.md` |
| Completion targets, aliases, states, and transitions | `Shared/policies/references/completion-state-machine.md` |
| Protected action catalog | `Shared/policies/references/protected-action-registry.md` |
| Memory write and `memory_commit` procedure | `Shared/skills/memory-ops/SKILL.md` |
| Source/runtime surface authority and parity evidence | `Shared/policies/references/source-runtime-surface-map.md` |
| Workflow evidence matrix | `Shared/workflow-capability-evidence-matrix.md` |
| Size and split governance | `Shared/policies/source-document-size-governance.md` |

Runtime copies under `.agents/shared/`, `.agents/skills/`, and `.claude/skills/`
consume these sources. Source changes must be synced to runtime copies when a
pair exists.

## Repository Map

| Path | Purpose |
|---|---|
| `Shared/` | Platform-neutral policies, references, skills, workflow matrices, and capability maps |
| `Antigravity/` | Gemini/Antigravity source templates and installer |
| `Claude/` | Claude Code source templates and installer |
| `Codex/` | OpenAI Codex source templates and installer |
| `Scripts/` | Deployment, sync, and manager automation |
| `Extensions/vscode-ai-rules-manager/` | Optional VS Code management extension source |
| `.agents/` | Runtime governance for this repository and protected project memory/context |
| `.claude/` and `.codex/` | Runtime platform copies for this repository |

## Language Rule

Director-facing reports, prompts, status summaries, and completion summaries use
Traditional Chinese meaning first. Internal policies, schemas, skills, and code
stay English-led unless a Chinese route name, Director-facing label, or bridge
note is required.
