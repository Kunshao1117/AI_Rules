# [ANTIGRAVITY GLOBAL BOOTSTRAPPER — CODEX EDITION]

## 0. Role Identification (角色識別)

If you are running as an OpenAI Codex agent:
- Director-facing reports, replies, confirmations, status summaries, handoffs,
  and completion summaries MUST be in **Traditional Chinese (繁體中文, zh-TW)**.
  Internal source docs, policies, references, skills, schemas, and code keep their local convention.
  Prefer concise English unless explicitly Director-facing.
- You manage source code directly. Framework rules govern your behavior.

## 1. Zero-Touch Environment Check (前哨探測防線)

Before answering ANY queries in ANY new conversation, silently check the current workspace:

1. Does `.codex/AGENTS.md` exist in the project root?
2. If not, does `.codex/` contain another documented Codex initialization sentinel produced by this framework?

`.agents/` alone is not a Codex initialization signal; it may belong to shared governance, another platform, or a partial deployment.

**If YES to either Codex signal** → The project is initialized. Proceed normally with the Director's request.

**If NO to both Codex signals** → The project is uninitialized.
Do not install automatically. Output the governed install prompt in §2 and wait for Director approval.

## 2. Governed Bootstrapping (授權式全域武裝機制)

If the project is uninitialized, output the following Director-facing install prompt in Traditional Chinese:

「此專案尚未安裝 Antigravity Codex Edition。若要安裝，請輸入 `GO INSTALL`。我將下載並執行 Codex/install.ps1，目標路徑為目前工作目錄。」

HALT. Execute the following command only after the Director explicitly inputs `GO INSTALL`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$owner = 'Kunshao1117'
$repo = 'AI_Rules'
$ref = 'main'
$expectedInstallSha256 = ''
if ($ref -notmatch '^[A-Za-z0-9._-]+$' -or $ref.Contains('..')) { throw "Unsafe Codex install ref: $ref" }
$u = "https://raw.githubusercontent.com/$owner/$repo/$ref/Codex/install.ps1"
$uri = [Uri]$u
if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'raw.githubusercontent.com' -or $uri.AbsolutePath -ne "/$owner/$repo/$ref/Codex/install.ps1") { throw "Unexpected Codex install source: $u" }
$f = Join-Path $env:TEMP 'ag_codex_install.ps1'
$receipt = Join-Path $env:TEMP 'ag_codex_install.receipt.json'
try {
    $wc = New-Object Net.WebClient
    $bytes = $wc.DownloadData($u)
    $actualInstallSha256 = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-', '').ToLowerInvariant()
    if ($expectedInstallSha256 -and $actualInstallSha256 -ne $expectedInstallSha256.ToLowerInvariant()) { throw "Codex install script SHA256 mismatch." }
    $text = [Text.Encoding]::UTF8.GetString($bytes)
    $text = $text.TrimStart([char]0xFEFF)
    [IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
    [pscustomobject]@{ source = $u; sha256 = $actualInstallSha256; bytes = $bytes.Length; downloadedAt = (Get-Date).ToUniversalTime().ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath $receipt -Encoding UTF8
    & $f -Target (Get-Location).Path -Branch $ref
} catch {
    [pscustomobject]@{ source = $u; error = $_.Exception.Message; failedAt = (Get-Date).ToUniversalTime().ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath $receipt -Encoding UTF8
    throw
} finally {
    Remove-Item $f -Force -ErrorAction SilentlyContinue
}
```

After successful deployment, output the following Director-facing install completion prompt in Traditional Chinese:
「Antigravity Codex Edition 框架已授權佈署完成。專案現在已具備 Codex 治理能力。」

## 3. Upgrade Execution (框架升級機制)

When the Director explicitly requests an upgrade (e.g., "升級框架", "更新框架", "upgrade"), output this upgrade prompt in Traditional Chinese:

「即將升級 Antigravity Codex Edition。Upgrade 會比對並更新框架檔案，且保護 `.agents/memory/` 與 `.agents/project_skills/`。若要繼續，請輸入 `GO UPGRADE`。」

HALT. Execute the following command only after the Director explicitly inputs `GO UPGRADE`:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$owner = 'Kunshao1117'
$repo = 'AI_Rules'
$ref = 'main'
$expectedInstallSha256 = ''
if ($ref -notmatch '^[A-Za-z0-9._-]+$' -or $ref.Contains('..')) { throw "Unsafe Codex install ref: $ref" }
$u = "https://raw.githubusercontent.com/$owner/$repo/$ref/Codex/install.ps1"
$uri = [Uri]$u
if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'raw.githubusercontent.com' -or $uri.AbsolutePath -ne "/$owner/$repo/$ref/Codex/install.ps1") { throw "Unexpected Codex install source: $u" }
$f = Join-Path $env:TEMP 'ag_codex_install.ps1'
$receipt = Join-Path $env:TEMP 'ag_codex_install.receipt.json'
try {
    $wc = New-Object Net.WebClient
    $bytes = $wc.DownloadData($u)
    $actualInstallSha256 = [BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($bytes)).Replace('-', '').ToLowerInvariant()
    if ($expectedInstallSha256 -and $actualInstallSha256 -ne $expectedInstallSha256.ToLowerInvariant()) { throw "Codex install script SHA256 mismatch." }
    $text = [Text.Encoding]::UTF8.GetString($bytes)
    $text = $text.TrimStart([char]0xFEFF)
    [IO.File]::WriteAllText($f, $text, (New-Object Text.UTF8Encoding $true))
    [pscustomobject]@{ source = $u; sha256 = $actualInstallSha256; bytes = $bytes.Length; downloadedAt = (Get-Date).ToUniversalTime().ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath $receipt -Encoding UTF8
    & $f -Target (Get-Location).Path -Mode Upgrade -Branch $ref
} catch {
    [pscustomobject]@{ source = $u; error = $_.Exception.Message; failedAt = (Get-Date).ToUniversalTime().ToString('o') } |
        ConvertTo-Json | Set-Content -LiteralPath $receipt -Encoding UTF8
    throw
} finally {
    Remove-Item $f -Force -ErrorAction SilentlyContinue
}
```

The Upgrade mode compares all framework files against source (SHA256 diff), reports changes, and applies updates.
Project memory (`.agents/memory/`) and project skills (`.agents/project_skills/`) are **protected and will NOT be overwritten**.

## 4. Project Governance Bridge

- Configure `project_doc_fallback_filenames` in `~/.codex/config.toml` or `.codex/config.toml`.
- This allows Codex to discover and load `.codex/AGENTS.md` as the primary project governance file.

**Fallback (if config.toml is not set):**
- If `.codex/AGENTS.md` exists in the current project root, read it now.
- Treat `.codex/AGENTS.md` as the sole governance document for this session.
- The rules in this global file apply only as a bootstrap mechanism.

## 5. Post-Deployment

After deployment completes, continue with the Director's original request normally.
