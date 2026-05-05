# Invoke-HealthAudit.ps1 — 健檢工具掃描腳本（安全 + 效能）
# 供 /08_audit 工作流使用，輸出至 .agents/logs/audit_*.md
param(
    [string]$ProjectRoot = ".",
    [string]$AgentsDir = ".agents",
    [ValidateSet("security", "performance", "all")]
    [string]$Module = "all"
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    $pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshCmd) { & pwsh -File $MyInvocation.MyCommand.Path @PSBoundParameters; exit $LASTEXITCODE }
    Write-Error "[HALT] 此腳本需要 PowerShell 7+。"; exit 1
}

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
$logsDir = Join-Path $AgentsDir "logs"
if (-not (Test-Path $logsDir)) { New-Item -ItemType Directory -Path $logsDir | Out-Null }

function Write-ReportHeader { param([string]$T, [string]$F)
    Set-Content $F "# $T`nGenerated: $timestamp`nProjectRoot: $ProjectRoot`n" -Encoding UTF8 }
function Append-Section { param([string]$C, [string]$F) Add-Content $F $C -Encoding UTF8 }

function Invoke-SecurityModule {
    $out = Join-Path $logsDir "audit_security_scan.md"
    Write-ReportHeader "健檢報告：工具層安全掃描" $out
    Push-Location $ProjectRoot
    try {
        Append-Section "## 硬編碼憑證掃描" $out
        $patterns = @('sk-[a-zA-Z0-9]{20,}','AIza[a-zA-Z0-9_-]{35}','ghp_[a-zA-Z0-9]{36}',
            'mongodb\+srv://.+:.+@','postgresql://.+:.+@')
        $found = $false
        foreach ($p in $patterns) {
            if (Test-Path "src") {
                $m = Select-String -Path "src/**/*" -Pattern $p -Recurse 2>$null
                if ($m) { $found = $true; $m | ForEach-Object { Append-Section "  - $($_.Filename):$($_.LineNumber)" $out } }
            }
        }
        if (-not $found) { Append-Section "✅ 未偵測到明顯硬編碼憑證模式" $out }

        Append-Section "`n## 環境變數一致性" $out
        $envEx = Join-Path $ProjectRoot ".env.example"
        if (Test-Path $envEx) {
            $keys = (Get-Content $envEx) | Where-Object { $_ -match "^[A-Z_]+=" } |
                ForEach-Object { ($_ -split "=")[0].Trim() }
            Append-Section ".env.example 定義變數：$($keys.Count) 個" $out
            foreach ($k in $keys) {
                if (Test-Path "src") {
                    $u = Select-String -Path "src/**/*" -Pattern "process\.env\.$k" -Recurse 2>$null
                    if (-not $u) { Append-Section "  🟡 $k — 已定義但未在 src/ 中使用" $out }
                }
            }
        } else { Append-Section "未找到 .env.example 檔案" $out }
    } finally { Pop-Location }
    Write-Host "✅ security 掃描完成 → $out"
}

function Invoke-PerformanceModule {
    $out = Join-Path $logsDir "audit_perf.md"
    Write-ReportHeader "健檢報告：效能掃描" $out
    Push-Location $ProjectRoot
    try {
        $hasFrontend = (Test-Path "src/app") -or (Test-Path "app") -or (Test-Path "pages")
        if (-not $hasFrontend) {
            Append-Section "本專案無前端頁面，效能掃描跳過。" $out
            Write-Host "⏭️ 無前端頁面，效能掃描跳過"; return
        }
        Append-Section "## Lighthouse 效能掃描" $out
        Append-Section "執行命令（啟動 dev server 後手動執行）：" $out
        Append-Section '```powershell' $out
        Append-Section "npx lighthouse http://localhost:3000 --output=json --output-path=$logsDir/lighthouse.json" $out
        Append-Section '```' $out
        Append-Section "判定標準：Performance < 90 → 🟡（< 70 → 🔴） | LCP > 2.5s → 🟡（> 4s → 🔴）" $out
    } finally { Pop-Location }
    Write-Host "✅ performance 模組完成 → $out"
}

switch ($Module) {
    "security"    { Invoke-SecurityModule }
    "performance" { Invoke-PerformanceModule }
    "all" { Invoke-SecurityModule; Invoke-PerformanceModule
            Write-Host "`n✅ 所有健檢掃描模組完成，報告位於：$logsDir" }
}
