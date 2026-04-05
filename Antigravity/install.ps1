<#
.SYNOPSIS
    Antigravity 框架遠端安裝啟動器

.DESCRIPTION
    從 GitHub 下載並部署 Antigravity AI 代理人治理框架到指定專案目錄。
    下載走 ZIP 封存路徑，不使用 GitHub API，無速率限制問題。

.PARAMETER Target
    目標專案目錄（必填）。預設為當前工作目錄。

.PARAMETER Mode
    部署模式：Fresh（全新安裝）或 Upgrade（升級現有安裝）。預設 Fresh。

.PARAMETER Branch
    要下載的 GitHub 分支。預設 main。

.EXAMPLE
    # 一鍵安裝到當前目錄
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\ag_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1' -OutFile $f; & $f -Target "D:\MyProject"; Remove-Item $f

    # 升級現有安裝
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $f="$env:TEMP\ag_install.ps1"; irm 'https://raw.githubusercontent.com/Kunshao1117/AI_Rules/main/Antigravity/install.ps1' -OutFile $f; & $f -Target "D:\MyProject" -Mode Upgrade; Remove-Item $f
#>
param (
    [Parameter(Mandatory = $true)]
    [string]$Target,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Fresh", "Upgrade")]
    [string]$Mode = "Fresh",

    [Parameter(Mandatory = $false)]
    [string]$Branch = "main"
)

# PowerShell 5.1+ 相容模式（建議 PS 7.x，但 PS 5.1 可直接執行）
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repoOwner = "Kunshao1117"
$repoName  = "AI_Rules"
$zipUrl    = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$Branch.zip"

$tempZip = Join-Path $env:TEMP "antigravity_$(Get-Random).zip"
$tempDir = Join-Path $env:TEMP "antigravity_$(Get-Random)"

try {
    Write-Host ""
    Write-Host "[>] Antigravity 框架安裝程式"
    Write-Host "[*] 目標專案 : $Target"
    Write-Host "[*] 模式     : $Mode"
    Write-Host "[*] 分支     : $Branch"
    Write-Host ""

    # ── 步驟 1：下載 ZIP（走 CDN，無 API 速率限制）──
    Write-Host "[1/3] 正在從 GitHub 下載框架..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "      下載完成：$('{0:N1}' -f ((Get-Item $tempZip).Length / 1MB)) MB"

    # ── 步驟 2：解壓縮 ──
    Write-Host "[2/3] 正在解壓縮..."
    Expand-Archive -Path $tempZip -DestinationPath $tempDir -Force

    # ── 步驟 3：執行部署腳本 ──
    $deployScript = Join-Path $tempDir "$repoName-$Branch\Antigravity\.agents\scripts\Deploy-Antigravity.ps1"

    if (-Not (Test-Path $deployScript)) {
        Write-Host "[X] 錯誤：找不到部署腳本，請確認分支名稱正確。"
        exit 1
    }

    Write-Host "[3/3] 正在部署至目標專案..."
    & $deployScript -Target $Target -Mode $Mode

} finally {
    # ── 清理暫存檔案 ──
    if (Test-Path $tempZip) { Remove-Item $tempZip -Force -ErrorAction SilentlyContinue }
    if (Test-Path $tempDir)  { Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue }
}


