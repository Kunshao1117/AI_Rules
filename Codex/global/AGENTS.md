# [ANTIGRAVITY GLOBAL BOOTSTRAPPER — CODEX EDITION]

## 0. Role Identification (角色識別)

If you are running as an OpenAI Codex agent:
- All responses MUST be in **Traditional Chinese (繁體中文, zh-TW)**.
- You manage source code directly. Framework rules govern your behavior.

## 1. Zero-Touch Environment Check (前哨探測防線)

Before answering ANY queries in ANY new conversation, silently check the current workspace:

1. Does the directory `.codex/` exist in the project root?
2. Does `.agents/` directory exist in the project root?

**If YES to either** → The project is initialized. Proceed normally with the Director's request.

**If NO to both** → The project is uninitialized. Do not install automatically. Output the governed install prompt in §2 and wait for Director approval.

## 2. Governed Bootstrapping (授權式全域武裝機制)

If the project is uninitialized, output in Traditional Chinese:

「此專案尚未安裝 Antigravity Codex Edition。若要安裝，請輸入 `GO INSTALL`。我將下載並執行 Codex/install.ps1，目標路徑為目前工作目錄。」

HALT. Execute the following command only after the Director explicitly inputs `GO INSTALL`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Codex/install.ps1'
$f = "$env:TEMP\ag_codex_install.ps1"
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes)
$text = $text.TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Target (Get-Location).Path
Remove-Item $f
```

After successful deployment, output in Traditional Chinese:
「Antigravity Codex Edition 框架已授權佈署完成。專案現在已具備 Codex 治理能力。」

## 3. Upgrade Execution (框架升級機制)

When the Director explicitly requests an upgrade (e.g., "升級框架", "更新框架", "upgrade"), output in Traditional Chinese:

「即將升級 Antigravity Codex Edition。Upgrade 會比對並更新框架檔案，且保護 `.agents/memory/` 與 `.agents/project_skills/`。若要繼續，請輸入 `GO UPGRADE`。」

HALT. Execute the following command only after the Director explicitly inputs `GO UPGRADE`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$u = 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Codex/install.ps1'
$f = "$env:TEMP\ag_codex_install.ps1"
$wc = New-Object Net.WebClient
$bytes = $wc.DownloadData($u)
$text = [Text.Encoding]::UTF8.GetString($bytes)
$text = $text.TrimStart([char]0xFEFF)
[IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
& $f -Target (Get-Location).Path -Mode Upgrade
Remove-Item $f
```

The Upgrade mode compares all framework files against source (SHA256 diff), reports changes, and applies updates. Project memory (`.agents/memory/`) and project skills (`.agents/project_skills/`) are **protected and will NOT be overwritten**.

## 4. Project Governance Bridge

This machine should have `project_doc_fallback_filenames` configured in
`~/.codex/config.toml` or `.codex/config.toml`, enabling Codex to natively
discover and load `.codex/AGENTS.md` as the primary project governance file.

**Fallback (if config.toml is not set):**
If `.codex/AGENTS.md` exists in the current project root, read it now and
treat it as the sole governance document for this session.
The rules in this global file apply only as a bootstrap mechanism.

## 5. Post-Deployment

After deployment completes, continue with the Director's original request normally.
