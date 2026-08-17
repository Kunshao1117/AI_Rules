# Antigravity Cursor Edition v0.1.0

Cursor Edition adapts AI_Rules to Cursor. It installs project rules in
`.cursor/rules/` and deploys workflow skills plus shared operational skills
into `.cursor/skills/`. Shared governance and project memory stay in
`.agents/shared/` and `.agents/memory/`.

This README is an entry point only. Internal governance remains in
`Shared/policies/`, `Shared/skills/`, and deployed `.agents/shared/` copies.

This first release does not install a global Cursor bootstrapper, VS Code
manager integration, or repository-local Team-routing hooks.

## Mixed Repository Identity

If Cursor opens a workspace that also contains Antigravity, Claude, or Codex
source trees (including this AI_Rules repository), Cursor Edition still owns
the session. The always-on rule `02-platform-identity.mdc` treats those other
platform files as source templates. It does not run their install bootstrap or
Claude sub-agent write ban. Editing those files remains allowed when that is
the requested work.

## Install Or Upgrade

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Cursor/install.ps1'
$f = Join-Path $env:TEMP 'ag_cursor_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f
Remove-Item $f
```

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Cursor/install.ps1'
$f = Join-Path $env:TEMP 'ag_cursor_install.ps1'
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Mode Upgrade
Remove-Item $f
```

Use `-Target "D:\path\to\project"` for another project directory.

Local source deploy:

```powershell
& "D:\AI_Rules\Scripts\Deploy.ps1" -Platform Cursor -Mode Fresh -Target "D:\MyProject"
& "D:\AI_Rules\Scripts\Deploy.ps1" -Platform Cursor -Mode Upgrade -Target "D:\MyProject"
```

## Installed Surfaces

- Cursor always-on rules: `Cursor/.cursor/rules/` to `.cursor/rules/`
- Workflow skills: `Cursor/.agents/workflow-skills/` to `.cursor/skills/`
- Shared skills: `Shared/skills/` to `.cursor/skills/`
- Shared governance references: `Shared` allowlist to `.agents/shared/`
- Project tools: `Shared/project-tools/` to `.agents/tools/`
- Context templates: `Shared/context/` to `.agents/context/`
- Project memory: protected local project asset at `.agents/memory/`
- Project context: protected local project asset at `.agents/context/`

## Hooks

Cursor supports hooks as a platform capability. AI_Rules does not install
repository-local Team-routing hooks by default. Governance core resolves Direct
or delegated topology. A future hook must be deterministic, tool-bound, and
matched only to its necessary event.

## Workflow Skills

Cursor workflow routes are deployed as skills:

`00-chat-聊天`, `01-explore-探索`, `02-blueprint-架構`,
`03-build-建構`, `03-1-experiment-實驗`, `04-fix-修復`,
`05-condense-濃縮`, `06-test-測試`, `07-debug-除錯`,
`09-commit-紀錄總結`, `10-routine-巡檢`,
`11-handoff-交接`, and `12-skill-forge-技能鍛造`.

The route names are triggers only. Authorization, Team-Native dispatch,
protected phases, validation, review, memory attribution, and closeout judgment
come from the shared sources above.

## Version Notes

`Cursor/VERSION` is the source version. `.cursor/VERSION` is the deployed
runtime version marker.
