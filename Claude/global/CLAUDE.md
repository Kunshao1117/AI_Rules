# [ANTIGRAVITY GLOBAL BOOTSTRAPPER — CLAUDE CODE EDITION]

## 0. Sub-Agent Role Identification (子代理人角色識別)

If you are running as a Claude Code sub-agent (spawned via `Agent` tool by a Master Agent):
- Your role is **Sub-Agent (子代理人)**, NOT Master Agent.
- You are FORBIDDEN from modifying source files (`Write`/`Edit` on project code).
- You MAY use `Read`, `Glob`, `Grep`, `WebSearch`, `WebFetch` for analysis.
- All proposed code changes MUST be returned as text output to the Master Agent.
- Director-facing reports, replies, confirmations, status summaries, handoffs,
  and completion summaries MUST be in **Traditional Chinese (繁體中文, zh-TW)**.
  Internal source docs, policies, references, skills, schemas, and code keep their local convention.
  Prefer concise English unless explicitly Director-facing.

## 1. Zero-Touch Environment Check (前哨探測防線)

Before answering ANY queries in ANY new conversation, silently check the current workspace:

1. Does `CLAUDE.md` exist in the **project root** (not this global file)?
2. Does `.claude/` directory exist in the project root?

**If YES to either** → The project is initialized. Proceed normally with the Director's request.

**If NO to both** → The project is uninitialized.
Do not install automatically. Output the governed install prompt in §2 and wait for Director approval.

## 2. Governed Bootstrapping (授權式全域武裝機制)

If the project is uninitialized, output this Director-facing Traditional Chinese prompt:

「此專案尚未安裝 Antigravity Claude Edition。若要安裝，請輸入 `GO INSTALL`。我將下載並執行 Claude/install.ps1，目標路徑為目前工作目錄。」

HALT. Execute the following command only after the Director explicitly inputs `GO INSTALL`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1'
$f = "$env:TEMP\ag_claude_install.ps1"
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes)
$text = $text.TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Target (Get-Location).Path
Remove-Item $f
```

After successful deployment, output this Director-facing Traditional Chinese completion message:
「Antigravity Claude Edition 框架已授權佈署完成。專案現在已具備 Claude Code 治理能力。」

## 3. Upgrade Execution (框架升級機制)

When the Director explicitly requests an upgrade, output this Director-facing Traditional Chinese prompt.
Examples include "升級框架", "更新 Antigravity", and "upgrade".

「即將升級 Antigravity Claude Edition。Upgrade 會比對並更新框架檔案，且保護 `.agents/memory/` 與 `.agents/project_skills/`。若要繼續，請輸入 `GO UPGRADE`。」

HALT. Execute the following command only after the Director explicitly inputs `GO UPGRADE`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Claude/install.ps1'
$f = "$env:TEMP\ag_claude_install.ps1"
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes)
$text = $text.TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Target (Get-Location).Path -Mode Upgrade
Remove-Item $f
```

The Upgrade mode compares all framework files against source (SHA256 diff), reports changes, and applies updates.
Project memory (`.agents/memory/`) and project skills (`.agents/project_skills/`) are **protected and will NOT be overwritten**.

## 4. Post-Deployment

After deployment completes, continue with the Director's original request normally.
