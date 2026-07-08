#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Codex Edition — 遠端安裝啟動器

.DESCRIPTION
    從 GitHub 下載並部署 Antigravity Codex Edition 框架到指定專案目錄。
    下載走 ZIP 封存路徑，不使用 GitHub API，無速率限制問題。

.PARAMETER Target
    目標專案目錄（可選）。未指定時自動使用當前工作目錄。

.PARAMETER Mode
    部署模式：Fresh（全新安裝）或 Upgrade（升級現有安裝）。預設 Fresh。

.PARAMETER Branch
    要下載的 GitHub 分支。預設 main。

.PARAMETER ExpectedZipSha256
    可選的 ZIP SHA256。若提供，下載內容不符合時會停止部署。

.PARAMETER DownloadReceipt
    可選的下載 receipt JSON 輸出路徑。未指定時寫入暫存目錄。

.PARAMETER RemoveOrphans
    是否移除目標中已不存在於源碼的孤兒檔案（僅 Upgrade 模式）

.EXAMPLE
    # 安全遠端啟動；可將 $installerArgs 改為 @('-Target','D:\MyProject') 或 @('-Mode','Upgrade')
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $owner = 'Kunshao1117'
    $repo = 'AI_Rules'
    $ref = 'main'
    $platformPath = 'Codex/install.ps1'
    $expectedInstallSha256 = ''
    $installerArgs = @()
    if ($ref -notmatch '^[A-Za-z0-9._-]+$' -or $ref.Contains('..')) { throw "Unsafe Codex install ref: $ref" }
    $u = "https://raw.githubusercontent.com/$owner/$repo/$ref/$platformPath"
    $uri = [Uri]$u
    if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'raw.githubusercontent.com' -or $uri.AbsolutePath -ne "/$owner/$repo/$ref/$platformPath") { throw "Unexpected Codex install source: $u" }
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
        & $f @installerArgs
    } catch {
        [pscustomobject]@{ source = $u; error = $_.Exception.Message; failedAt = (Get-Date).ToUniversalTime().ToString('o') } |
            ConvertTo-Json | Set-Content -LiteralPath $receipt -Encoding UTF8
        throw
    } finally {
        Remove-Item -LiteralPath $f -Force -ErrorAction SilentlyContinue
    }
#>
param (
    [Parameter(Mandatory = $false)]
    [string]$Target = $PWD.Path,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Fresh", "Upgrade")]
    [string]$Mode = "Fresh",

    [Parameter(Mandatory = $false)]
    [string]$Branch = "main",

    [Parameter(Mandatory = $false)]
    [string]$ExpectedZipSha256 = "",

    [Parameter(Mandatory = $false)]
    [string]$DownloadReceipt = "",

    [Parameter(Mandatory = $false)]
    [switch]$RemoveOrphans
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

function Get-Sha256Hex {
    param (
        [Parameter(Mandatory = $true)]
        [byte[]]$Bytes
    )

    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        return [BitConverter]::ToString($sha.ComputeHash($Bytes)).Replace("-", "").ToLowerInvariant()
    } finally {
        $sha.Dispose()
    }
}

function Assert-SafeRef {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value) -or $Value.Length -gt 80) {
        throw "$Name is empty or too long."
    }
    if ($Value -notmatch '^[A-Za-z0-9._-]+$' -or $Value.Contains("..")) {
        throw "$Name contains unsafe characters: $Value"
    }
}

function Assert-Sha256Value {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Value
    )

    if ($Value -and $Value -notmatch '^[A-Fa-f0-9]{64}$') {
        throw "$Name must be a 64-character hexadecimal SHA256 value."
    }
}

function Resolve-SafePath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value) -or $Value -match '[\*\?]') {
        throw "$Name contains an unsafe path value."
    }

    return [IO.Path]::GetFullPath($Value)
}

function Assert-ChildPath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Parent,

        [Parameter(Mandatory = $true)]
        [string]$Child,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $parentFull = [IO.Path]::GetFullPath($Parent).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $childFull = [IO.Path]::GetFullPath($Child)
    $prefix = $parentFull + [IO.Path]::DirectorySeparatorChar

    if (-not $childFull.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "$Name is outside the expected parent path."
    }

    return $childFull
}

function Write-DownloadReceipt {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [hashtable]$Data
    )

    $Data | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $Path -Encoding UTF8
}

Assert-SafeRef -Name "Branch" -Value $Branch
Assert-Sha256Value -Name "ExpectedZipSha256" -Value $ExpectedZipSha256

$targetPath = Resolve-SafePath -Name "Target" -Value $Target
$receiptPath = if ([string]::IsNullOrWhiteSpace($DownloadReceipt)) {
    Join-Path $env:TEMP "codex_edition_receipt_$([Guid]::NewGuid().ToString('N')).json"
} else {
    Resolve-SafePath -Name "DownloadReceipt" -Value $DownloadReceipt
}

$repoOwner = "Kunshao1117"
$repoName  = "AI_Rules"
$zipPath   = "/$repoOwner/$repoName/archive/refs/heads/$Branch.zip"
$zipUrl    = "https://github.com$zipPath"
$zipUri    = [Uri]$zipUrl

if ($zipUri.Scheme -ne "https" -or $zipUri.Host -ne "github.com" -or $zipUri.AbsolutePath -ne $zipPath) {
    throw "Unexpected download source: $zipUrl"
}

$tempName = "codex_edition_$([Guid]::NewGuid().ToString('N'))"
$tempZip = Join-Path $env:TEMP "$tempName.zip"
$tempDir = Join-Path $env:TEMP $tempName

try {
    Write-Host ""
    Write-Host "[>] Antigravity Codex Edition 框架安裝程式"
    Write-Host "[*] 目標專案 : $targetPath"
    Write-Host "[*] 模式     : $Mode"
    Write-Host "[*] 分支     : $Branch"
    Write-Host "[*] 來源     : $zipUrl"
    Write-Host ""

    Write-Host "[1/3] 正在從 GitHub 下載框架..."
    Invoke-WebRequest -Uri $zipUri -OutFile $tempZip -UseBasicParsing -ErrorAction Stop
    $zipBytes = [IO.File]::ReadAllBytes($tempZip)
    $actualZipSha256 = Get-Sha256Hex -Bytes $zipBytes

    if ($ExpectedZipSha256 -and $actualZipSha256 -ne $ExpectedZipSha256.ToLowerInvariant()) {
        throw "Downloaded ZIP SHA256 mismatch."
    }

    Write-DownloadReceipt -Path $receiptPath -Data @{
        source       = $zipUrl
        branch       = $Branch
        sha256       = $actualZipSha256
        expectedHash = $ExpectedZipSha256
        bytes        = $zipBytes.Length
        downloadedAt = (Get-Date).ToUniversalTime().ToString("o")
        status       = "downloaded"
    }

    Write-Host "      下載完成：$('{0:N1}' -f ((Get-Item $tempZip).Length / 1MB)) MB"
    Write-Host "      SHA256：$actualZipSha256"
    Write-Host "      Receipt：$receiptPath"

    Write-Host "[2/3] 正在解壓縮..."
    Expand-Archive -Path $tempZip -DestinationPath $tempDir -Force -ErrorAction Stop

    # 統一部署腳本入口
    $sourceRoot = Assert-ChildPath -Parent $tempDir -Child (Join-Path $tempDir "$repoName-$Branch") -Name "Source root"
    $deployScript = Assert-ChildPath -Parent $sourceRoot -Child (Join-Path $sourceRoot "Scripts\Deploy.ps1") -Name "Deploy script"

    if (-Not (Test-Path -LiteralPath $deployScript)) {
        throw "找不到部署腳本，請確認分支名稱正確。"
    }

    Write-Host "[3/3] 正在部署至目標專案..."
    if ($RemoveOrphans) {
        & $deployScript -Platform Codex -Mode $Mode -Target $targetPath -RemoveOrphans
    } else {
        & $deployScript -Platform Codex -Mode $Mode -Target $targetPath
    }

} catch {
    Write-DownloadReceipt -Path $receiptPath -Data @{
        source = $zipUrl
        branch = $Branch
        error = $_.Exception.Message
        failedAt = (Get-Date).ToUniversalTime().ToString("o")
        status = "failed"
    }
    throw
} finally {
    if (Test-Path -LiteralPath $tempZip) { Remove-Item -LiteralPath $tempZip -Force -ErrorAction SilentlyContinue }
    if (Test-Path -LiteralPath $tempDir) { Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue }
}
