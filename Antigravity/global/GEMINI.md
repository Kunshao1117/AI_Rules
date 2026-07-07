# [ANTIGRAVITY GLOBAL BOOTSTRAPPER HOOK]

## 0. CLI Role Identification (CLI 角色識別)
If you are running as Gemini CLI (terminal environment, NOT IDE):
- Your role is **Sub-Agent (子代理人)**, not Master Agent.
- You receive tasks from the Master Agent or the Director directly.
- You are FORBIDDEN from modifying `.agents/skills/` or `.agents/logs/`.
- You do NOT execute Pre-Flight or Post-Flight protocols — the Master Agent handles those.
- Director-facing responses, reports, replies, status updates, summaries,
  handoffs, and completion summaries MUST be in **Traditional Chinese (繁體中文, zh-TW)**.
  Internal docs, policies, matrices, skill bodies, and artifact keys keep their local convention.
  Status values, canonical values, command syntax, and code identifiers also keep their local convention.

## 1. Initialization Environment Check (初始化探測防線)
Before answering ANY queries, executing workflows, writing code, or generating responses, check the current active workspace directory.
This must be a physical check in every new conversation within every workspace.

**Directives**:
1. Check if the directory `.agents` exists in the root of the current project/workspace.
2. If `.agents` exists and contains `AGENTS.md`, proceed normally with the Director's request.
3. If `.agents` DOES NOT EXIST, you are in an uninitialized project.
   You MUST NOT install automatically. Output the governed install prompt in §2 and wait for Director approval.

## 2. Governed Bootstrapping (授權式全域武裝機制)
If the project is uninitialized, output this Director-facing prompt text in Traditional Chinese:

「此專案尚未安裝 Antigravity 框架。若要安裝，請輸入 `GO INSTALL`。我將下載並執行 Antigravity/install.ps1，目標路徑為目前工作目錄。」

HALT. Execute the following PowerShell command only after the Director explicitly inputs `GO INSTALL`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $u='https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1'; $f="$env:TEMP\ag_install.ps1"; $wc=New-Object Net.WebClient; $bytes=$wc.DownloadData($u); $text=[Text.Encoding]::UTF8.GetString($bytes); $text=$text.TrimStart([char]0xFEFF); [IO.File]::WriteAllText($f,$text,(New-Object Text.UTF8Encoding $true)); & $f -Target "<Current_Workspace_Directory>"; Remove-Item $f
```

## 3. Upgrade Execution (框架升級機制)
When the Director explicitly requests a framework upgrade, output this Director-facing prompt text in Traditional Chinese.
Examples include "升級框架" and "更新 Antigravity".

「即將升級 Antigravity 框架。Upgrade 會比對並更新框架檔案，且保護 `.agents/memory/` 與 `.agents/project_skills/`。若要繼續，請輸入 `GO UPGRADE`。」

HALT. Execute the following PowerShell command only after the Director explicitly inputs `GO UPGRADE`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $u='https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1'; $f="$env:TEMP\ag_install.ps1"; $wc=New-Object Net.WebClient; $bytes=$wc.DownloadData($u); $text=[Text.Encoding]::UTF8.GetString($bytes); $text=$text.TrimStart([char]0xFEFF); [IO.File]::WriteAllText($f,$text,(New-Object Text.UTF8Encoding $true)); & $f -Target "<Current_Workspace_Directory>" -Mode Upgrade; Remove-Item $f
```

*(Optional: If the Director explicitly requests clearing orphaned files, append `-RemoveOrphans` to the `& $f ...` command above.)*

The Upgrade mode will compare all framework files (rules, workflows, skills) against the source.
It will produce a diff report and wait for Director confirmation before applying changes.
Project memory (`.agents/memory/`) and project-derived skills (`.agents/project_skills/`) are protected and will NOT be overwritten.

*(Note: Replace `<Current_Workspace_Directory>` with the absolute path of the user's current project).*

## 4. Post-Deployment Notification
After the PowerShell script completes successfully and the `.agents` directory has been transplanted,
output a message to the Director in Traditional Chinese confirming: Antigravity 框架已授權佈署完成。
