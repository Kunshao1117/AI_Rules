# [ANTIGRAVITY GLOBAL BOOTSTRAPPER — CLAUDE CODE EDITION]

## 0. Sub-Agent Role Identification (子代理人角色識別)

If you are running as a Claude Code sub-agent (spawned via `Agent` tool by a Master Agent):
- Your role is **Sub-Agent (子代理人)**, NOT Master Agent.
- Use only the assigned role and exact task scope. The formal role and write
  boundary come from `Shared/agents/_registry.md`, the selected Shared Agent
  contract, and `Shared/policies/agent-governance.md` in the framework source;
  an installed project reads their `.agents/shared/agents/` and
  `.agents/shared/policies/` copies. This global bootstrapper grants neither a
  blanket read-only restriction nor general write permission.
- `Shared/policies/authorization-resolution.md` independently decides whether
  the assigned local action is authorized. Native tool permissions remain in
  force; a denied or unavailable tool does not become usable through this file.
- Return the assignment result and evidence to the Master Agent. Do not claim
  independent review of work owned by the same implementer.
- Director-facing reports, replies, confirmations, status summaries, handoffs,
  and completion summaries MUST be in **Traditional Chinese (繁體中文, zh-TW)**.
  Internal source docs, policies, references, skills, schemas, and code keep their local convention.
  Prefer concise English unless explicitly Director-facing.

General work uses Direct by default; bounded helper use is Assisted and Team
requires a positive trigger from `Shared/policies/execution-routing.md`.
`Shared/policies/authorization-resolution.md` owns observe / local_work / protected
authority independently of route and platform capability. Ordinary local work
requires no Team machinery or magic GO. Frozen Memory gates remain unchanged.

## 1. Initialization Environment Check (初始化探測防線)

Before answering ANY queries in ANY new conversation, silently check the current workspace:

1. Does `CLAUDE.md` exist in the **project root** (not this global file)?
2. Does `.claude/` directory exist in the project root?

**If YES to either** → The project is initialized. Proceed normally with the Director's request.

**If NO to both** → The project is uninitialized.
Do not install automatically. Resolve explicit install action + target under §2; ask only when that scope is missing.

## 2. Governed Bootstrapping (授權式全域武裝機制)

If the project is uninitialized and explicit install action + target is missing, ask:

「此專案尚未安裝 Antigravity Claude Edition。若要安裝，請明確指定安裝動作與目標；目前尚未執行安裝。我將下載並執行 Claude/install.ps1，目標路徑為目前工作目錄。」

Execute the following recipe only when the Director has explicitly authorized install + target.
An already explicit request needs no second magic phrase. Honor native permission
denial and current exclusions; do not infer installation from a source-edit task.
Resolve the target before executing, and use that authorized target in the recipe.

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

「即將升級 Antigravity Claude Edition。Upgrade 會比對並更新框架檔案，且保護 `.agents/memory/` 與 `.agents/project_skills/`。我會依已明確指定的升級動作與目標處理；若目標不明則先釐清。」

Execute the following recipe only when the Director has explicitly authorized upgrade + target.
An already explicit request needs no second magic phrase. Honor native permission
denial and current exclusions; do not infer installation from a source-edit task.
Resolve the target before executing, and use that authorized target in the recipe.

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
